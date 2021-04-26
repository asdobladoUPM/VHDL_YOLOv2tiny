LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

LIBRARY work;
USE work.YOLO_pkg.ALL;

ENTITY MPcontrol IS
    GENERIC (
        Step : INTEGER;
        Hc : INTEGER;
        Ch : INTEGER
    );
    PORT (
        clk : IN STD_LOGIC;
        reset : IN STD_LOGIC;

        start : IN STD_LOGIC;

        val_d1 : OUT STD_LOGIC;
        enLBuffer : OUT STD_LOGIC;

        validOut : OUT STD_LOGIC
    );

END MPcontrol;

ARCHITECTURE rtl OF MPcontrol IS

    CONSTANT rst_val : STD_LOGIC := '0';

    SIGNAL count_col : INTEGER := 1;
    SIGNAL count_row : INTEGER := 1;
    SIGNAL count_ch : INTEGER := 1;

    SIGNAL col_odd : STD_LOGIC;
    SIGNAL row_odd : STD_LOGIC;
    SIGNAL deadline_count_row : INTEGER := 0;

BEGIN

    comb_proc : PROCESS (start, col_odd, row_odd, count_col, count_row)
    BEGIN

        IF start = '1' THEN

            val_d1 <= '1';

            IF step = 2 THEN
                validOut <= (col_odd NOR row_odd);
                enLBuffer <= NOT(col_odd);
            ELSE --si es 1
                IF count_col < 2 THEN
                    enLBuffer <= '0';
                ELSE
                    enLBuffer <= '1';
                END IF;
                IF count_col = 1 OR count_row = 1 THEN
                    validOut <= '0';
                ELSE
                    validOut <= '1';
                END IF;
            END IF;

        ELSE
            val_d1 <= '0';
            validOut <= '0';
            enLBuffer <= '0';
        END IF;
    END PROCESS comb_proc;

    clk_proc : PROCESS (clk, reset)
    BEGIN
        IF reset = rst_val THEN

            --columnas
            col_odd <= '0';
            count_col <= 0;

            --filas
            row_odd <= '1';
            count_row <= 1;
            deadline_count_row <= 0;

            --canales
            count_ch <= 1;

        ELSIF rising_edge(clk) THEN

            IF start = '1' THEN

                --ColumnasCanalesYFilas     
                IF count_col < Hc THEN
                    col_odd <= NOT(col_odd);
                    count_col <= count_col + 1;
                ELSE
                    col_odd <= '1';
                    count_col <= 1;
                    count_ch <= count_ch + 1;
                    IF count_ch = Ch THEN
                        count_ch <= 1;
                        row_odd <= NOT(row_odd);
                        count_row <= count_row + 1;
                        IF count_row = 2 THEN
                            count_row <= 1;
                        END IF;
                    END IF;
                END IF;

            ELSE
                count_col <= 0;
            END IF;
        END IF;

    END PROCESS clk_proc;
END ARCHITECTURE rtl;