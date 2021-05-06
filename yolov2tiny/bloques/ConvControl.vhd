LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

LIBRARY work;
USE work.YOLO_pkg.ALL;

--Bloque de control para la convolucion

ENTITY ConvControl IS
    GENERIC (
        layer : INTEGER
    );
    PORT (
        clk : IN STD_LOGIC;
        reset : IN STD_LOGIC;

        validIn : IN STD_LOGIC;

        startLBuffer : OUT STD_LOGIC; --LB mux control
        enableLBuffer : OUT STD_LOGIC;--LB enable

        validOut : OUT STD_LOGIC
    );

END ConvControl;

ARCHITECTURE rtl OF ConvControl IS

    CONSTANT rst_val : STD_LOGIC := '0';

    --Constantes

    CONSTANT Hr : INTEGER := rows(layer);
    CONSTANT Hc : INTEGER := columns(layer);
    CONSTANT Ch : INTEGER := channels(layer);
    CONSTANT F : INTEGER := filters(layer);
    CONSTANT K : INTEGER := kernels(layer);

    --Contadores

    SIGNAL count_col : INTEGER;
    SIGNAL count_row : INTEGER;
    SIGNAL count_filters : INTEGER;
    SIGNAL count_ch : INTEGER;

    SIGNAL count_pushing : INTEGER;

    --Señales de control

    SIGNAL s_startLBuffer : STD_LOGIC;
    SIGNAL pushing : STD_LOGIC;

BEGIN
    clk_proc : PROCESS (clk, reset)
    BEGIN
        IF reset = rst_val THEN

            --reset de contadores
            count_col <= 0;
            count_row <= 0;
            count_filters <= 0;
            count_ch <= 0;

            --reset de señales
            pushing <= '0';
            count_pushing <= 0;

        ELSIF rising_edge(clk) THEN

            --si llega un dato aumentamos contadores
            IF validIn = '1' THEN
                count_col <= count_col + 1;
                IF count_col = Hc - 1 THEN --cambio de canal
                    count_col <= 0;
                    count_ch <= count_ch + 1;
                    IF count_ch = Ch - 1 THEN --cambio de filtro
                        count_ch <= 0;
                        count_filters <= count_filters + 1;
                        IF count_filters = F/K - 1 THEN --cambio de fila
                            count_filters <= 0;
                            count_row <= count_row + 1;
                            IF count_row = Hr - 1 THEN --ultimo dato
                                pushing <= '1'; --señal para vaciar el LB
                                count_row <= 0;
                            END IF;
                        END IF;
                    END IF;
                END IF;
            END IF;

            IF pushing = '1' THEN --estado final para sacar del LB los datos de la última fila del último filtro
                count_pushing <= count_pushing + 1;
                IF count_pushing = Hc - 1 THEN --si se han sacado Hc datos
                    count_pushing <= 0;
                    pushing <= '0'; --se termina
                END IF;
            END IF;
        END IF;

    END PROCESS clk_proc;

    comb_proc : PROCESS (validIn, count_ch, count_filters, count_row, pushing)
    BEGIN

        IF validIn = '1' THEN 
            enableLBuffer <= '1';
            IF count_ch = 0 THEN --los primeros datos
                s_startLBuffer <= '1'; --no deben usar los datos del LB
            ELSE
                s_startLBuffer <= '0';
            END IF;
        ELSE
            enableLBuffer <= '0';
            s_startLBuffer <= '0';
        END IF;

        IF pushing = '1' THEN --si estamos en pushing
            validOut <= '1'; --los datos son válidos siempre
        ELSIF validIN = '1' AND count_ch = 0 THEN --si la entrada es valida y es el primer canal
            IF count_filters = 0 AND count_row = 0 THEN
                validOut <= '0';
            ELSE
                validOut <= '1'; --los datos son válidos si no es la primera fila del primer filtro 
            END IF;
        ELSE
            validOut <= '0'; --si no es ninguno de los dos casos anteriores los datos no son válidos
        END IF;

    END PROCESS comb_proc;

    startLBuffer <= s_startLBuffer;

END ARCHITECTURE rtl;