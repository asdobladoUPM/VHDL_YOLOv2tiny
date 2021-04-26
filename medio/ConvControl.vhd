LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

LIBRARY work;
USE work.YOLO_pkg.ALL;

ENTITY ConvControl IS
    GENERIC (
        Hr : INTEGER;
        Hc : INTEGER;
        F : INTEGER;
        Ch : INTEGER;
        K : INTEGER
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

    SIGNAL row_odd : STD_LOGIC;
    SIGNAL col_odd : STD_LOGIC;

    SIGNAL count_col : INTEGER := 1;
    SIGNAL count_row : INTEGER := 1;
    SIGNAL count_filters : INTEGER := 1;
    SIGNAL count_ch : INTEGER := 1;

    SIGNAL count_validOut : INTEGER := 0;

    SIGNAL count_SBuffer : INTEGER := 0;

BEGIN
    enableLBuffer <= start;

    clk_proc : PROCESS (clk, reset)
    BEGIN
        IF reset = rst_val THEN

            --filas
            row_odd <= '1';
            count_row <= 1;

            --columnas
            col_odd <= '0';
            count_col <= 0;

            --channel
            count_ch <= 1;

            --filters
            count_filters <= 1;

            --startBuffer
            startLbuffer <= '1';
            count_SBuffer <= 0;

            --validOut
            validOut <= '0';
            count_validOut <= 0;
        ELSIF rising_edge(clk) THEN

            IF start = '1' THEN

                --Contadores
                IF count_col < Hc THEN
                    col_odd <= NOT(col_odd);
                    count_col <= count_col + 1;
                ELSE
                    col_odd <= '1';
                    count_col <= 1;
                    count_ch <= count_ch + 1;
                    IF count_ch = Ch THEN
                        count_ch <= 1;
                        count_filters <= count_filters + 1;
                        IF count_filters = F/K THEN
                            count_filters <= 1;
                            count_row <= count_row + 1;
                            row_odd <= NOT(row_odd);
                            IF count_row = Hr THEN
                                count_row <= 1;
                                row_odd <= '1';
                            END IF;
                        END IF;
                    END IF;
                END IF;

                --startLBuffer     a 1 cuando empezamos una nueva fila o filtro
                IF count_SBuffer < Hc THEN
                    startLbuffer <= '1';
                    count_SBuffer <= count_SBuffer + 1;
                ELSE
                    startLbuffer <= '0';
                    count_SBuffer <= count_SBuffer + 1;
                    IF count_SBuffer = (Hc * Ch) THEN --cuando terminemos con el filtro 
                        startLbuffer <= '1';
                        count_SBuffer <= 1;
                    END IF;
                END IF;

                --validOut 
                IF count_validOut < Hc * (Ch - 1) THEN
                    validOut <= '0';
                    count_validOut <= count_validOut + 1;
                ELSE
                    validOut <= '1';
                    count_validOut <= count_validOut + 1;
                    IF count_validOut = Hc * Ch THEN
                        count_validOut <= 1;
                        validOut <= '0';
                    END IF;

                END IF;

            ELSE
                --filas
                row_odd <= '1';
                count_row <= 1;

                --columnas
                col_odd <= '0';
                count_col <= 0;

                --channel
                count_ch <= 1;

                --filters
                count_filters <= 1;

                --startBuffer
                startLbuffer <= '1';
                count_SBuffer <= 0;

                --validOut
                validOut <= '0';
                count_validOut <= 0;
            END IF;

        END IF;
    END PROCESS clk_proc;
END ARCHITECTURE rtl;