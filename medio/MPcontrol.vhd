LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

LIBRARY work;
USE work.YOLO_pkg.ALL;

ENTITY MPcontrol IS
    GENERIC (
        Layer : INTEGER
    );
    PORT (
        clk : IN STD_LOGIC;
        reset : IN STD_LOGIC;

        validIn : IN STD_LOGIC;

        val_d1 : OUT STD_LOGIC;
        enLBuffer : OUT STD_LOGIC;

        validOut : OUT STD_LOGIC
    );

END MPcontrol;

ARCHITECTURE rtl OF MPcontrol IS

    CONSTANT rst_val : STD_LOGIC := '0';

    CONSTANT Step : INTEGER := step(layer);
    CONSTANT Hc : INTEGER := columns(layer);
    CONSTANT F : INTEGER := filters(layer);
    CONSTANT k : INTEGER := kernels(layer);


    SIGNAL count_col : INTEGER;
    SIGNAL count_ch : INTEGER;
    SIGNAL count_filters : INTEGER;

    SIGNAL col_odd : STD_LOGIC;
    SIGNAL row_odd : STD_LOGIC;

BEGIN

    comb_proc : PROCESS (validIn, col_odd, row_odd, count_col)
    BEGIN

        IF validIn = '1' THEN

            val_d1 <= '1';

            IF step = 2 THEN
                IF count_col =- 1 THEN
                    validOut <= '0';
                    enLBuffer <= '0';
                ELSE
                    validOut <= (col_odd NOR row_odd);
                    enLBuffer <= NOT(col_odd);
                END IF;
            ELSE --si es 1
                IF count_col =- 1 THEN
                    validOut <= '0';
                    enLBuffer <= '0';
                ELSE
                    IF count_col < 1 THEN
                        enLBuffer <= '0';
                    ELSE
                        enLBuffer <= '1';
                    END IF;
                    IF count_col = 0 OR row_odd = '1' THEN
                        validOut <= '0';
                    ELSE
                        validOut <= '1';
                    END IF;
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

            --canales
            count_ch <= 0;

        ELSIF rising_edge(clk) THEN

            IF validIn = '1' THEN

                --ColumnasCanalesYFilas     
                IF count_col < Hc - 1 THEN
                    col_odd <= NOT(col_odd);
                    count_col <= count_col + 1;
                ELSE
                    col_odd <= '1';
                    count_col <= 0;
                    count_ch <= count_ch + 1;
                    IF count_ch = (F/K) - 1 THEN
                        count_ch <= 0;
                        row_odd <= NOT(row_odd);
                    END IF;
                END IF;
            END IF;
        END IF;

    END PROCESS clk_proc;
END ARCHITECTURE rtl;