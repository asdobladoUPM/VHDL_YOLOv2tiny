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

        validIn : IN STD_LOGIC;

        startLBuffer : OUT STD_LOGIC;
        enableLBuffer : OUT STD_LOGIC;

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

    SIGNAL s_startLBuffer : STD_LOGIC;

    SIGNAL novalid : STD_LOGIC;

BEGIN
    clk_proc : PROCESS (clk, reset)
    BEGIN
        IF reset = rst_val THEN

            --filas
            count_row <= 0;

            --columnas
            count_col <= 0;

            --channel
            count_ch <= 0;

            --filters
            count_filters <= 0;

            novalid <= '1';

        ELSIF rising_edge(clk) THEN

            IF validIn = '1' THEN

                --Contadores
                IF count_col < Hc - 1 THEN
                    count_col <= count_col + 1;
                ELSE
                    novalid <= '0';
                    count_col <= 0;
                    count_ch <= count_ch + 1;
                    IF count_ch = Ch - 1 THEN
                        count_ch <= 0;
                        count_filters <= count_filters + 1;
                        IF count_filters = F/K -1 THEN
                            count_filters <= 0;
                            count_row <= count_row + 1;
                            IF count_row = Hr - 1 THEN
                                count_row <= 0;
                            END IF;
                        END IF;
                    END IF;
                END IF;
            END IF;
        END IF;

    END PROCESS clk_proc;

    comb_proc : PROCESS (validIn, count_ch)
    BEGIN

        IF validIn = '1' THEN

            enableLBuffer <= '1';

            IF count_ch = 0 THEN
                s_startLBuffer <= '1';
            ELSE
                s_startLBuffer <= '0';
            END IF;

        ELSE
            enableLBuffer <= '0';
            s_startLBuffer <= '0';
        END IF;

    END PROCESS comb_proc;

    validOut <= s_startLBuffer AND NOT(novalid);
    startLBuffer <= s_startLBuffer;

END ARCHITECTURE rtl;