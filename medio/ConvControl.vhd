LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

LIBRARY work;
USE work.YOLO_pkg.ALL;

ENTITY ConvControl IS
    GENERIC (
        layer : INTEGER
    );
    PORT (
        clk : IN STD_LOGIC;
        reset : IN STD_LOGIC;

        start : IN STD_LOGIC;

        startLBuffer : OUT STD_LOGIC;
        enableLBuffer : OUT STD_LOGIC; --?????????????????????? DO ITe s como el start del CV

        validOut : OUT STD_LOGIC
    );

END ConvControl;

ARCHITECTURE rtl OF ConvControl IS

    CONSTANT rst_val : STD_LOGIC := '0';

    CONSTANT Hr : INTEGER := rows(layer);
    CONSTANT Hc : INTEGER := columns(layer);
    CONSTANT Ch : INTEGER := channels(layer);
    CONSTANT F : INTEGER := filters(layer);
    CONSTANT K : INTEGER := kernels(layer);
    SIGNAL count_col : INTEGER;
    SIGNAL count_row : INTEGER;
    SIGNAL count_filters : INTEGER;
    SIGNAL count_ch : INTEGER;

    SIGNAL count_data : INTEGER := 0;

BEGIN
    clk_proc : PROCESS (clk, reset)
    BEGIN
        IF reset = rst_val THEN

            --filas
            count_row <= 0;

            --columnas
            count_col <= - 1;

            --channel
            count_ch <= 0;

            --filters
            count_filters <= 0;

            --startBuffer
            startLbuffer <= '1';
            count_data <= 0;
            --validOut
            validOut <= '0';

        ELSIF rising_edge(clk) THEN

            IF start = '1' THEN

                enableLBuffer <= '1';

                --Contadores
                IF count_col < Hc - 1 THEN
                    count_col <= count_col + 1;
                ELSE
                    count_col <= 0;
                    count_ch <= count_ch + 1;
                    IF count_ch = Ch - 1 THEN
                        count_ch <= 0;
                        count_filters <= count_filters + 1;
                        IF count_filters = F/K THEN
                            count_filters <= 0;
                            count_row <= count_row + 1;
                            IF count_row = Hr - 1 THEN
                                count_row <= 0;
                            END IF;
                        END IF;
                    END IF;
                END IF;

                count_data <= count_data + 1;

                IF count_data = (Hc * Ch) THEN --cuando terminemos con el filtro 
                    startLbuffer <= '1';
                    count_data <= 1;
                    validOut <= '0';

                ELSE
                    --startLBuffer     a 1 cuando empezamos una nueva fila o filtro
                    IF count_data < Hc THEN
                        startLbuffer <= '1';
                    ELSE
                        startLbuffer <= '0';
                    END IF;

                    --validOut 
                    IF count_data <= Hc * (Ch - 1) -1 THEN --ultumo canal
                        validOut <= '0';
                    ELSE
                        validOut <= '1';
                    END IF;
                END IF;

            END IF;

        END IF;
    END PROCESS clk_proc;

    data_proc : PROCESS (count_data)
    BEGIN
    END PROCESS data_proc;
END ARCHITECTURE rtl;