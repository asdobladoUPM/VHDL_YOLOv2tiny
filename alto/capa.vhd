LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

LIBRARY work;
USE work.YOLO_pkg.ALL;

ENTITY capa IS
    GENERIC (layer : INTEGER := 2);
    PORT (
        clk : IN STD_LOGIC;
        reset : IN STD_LOGIC;

        start : IN STD_LOGIC);
END capa;

ARCHITECTURE rtl OF capa IS

    CONSTANT rst_val : STD_LOGIC := '0';

    CONSTANT Hr : INTEGER := memrows(layer);
    CONSTANT Hc : INTEGER := memcolumns(layer);
    CONSTANT F : INTEGER := filters(layer);
    CONSTANT K : INTEGER := kernels(layer);
    COMPONENT ConvControl
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

    END COMPONENT;

    COMPONENT MPcontrol
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
    END COMPONENT;

    SIGNAL outCV : STD_LOGIC;
    SIGNAL outMP : STD_LOGIC;
    SIGNAL done : STD_LOGIC;
    SIGNAL counterdata : INTEGER;
    SIGNAL countercicles : INTEGER;

BEGIN

    ConvLX : ConvControl
    GENERIC MAP(Layer => Layer)
    PORT MAP(
        clk => clk, reset => reset,
        validIn => start,
        startLBuffer => OPEN, enableLBuffer => OPEN,
        validOut => outCV);

    MPL : MPControl
    GENERIC MAP(Layer => layer) --X EL NUMERO DE F
    PORT MAP(
        clk => clk,
        reset => reset,
        validIn => outCV,
        val_d1 => OPEN, enLBuffer => OPEN,
        validOut => outMP
    );

    clk_proc : PROCESS (clk, reset)
    BEGIN
        IF reset = rst_val THEN

            counterdata <= 0;
            countercicles <= 1;
            done <= '0';

        ELSIF rising_edge(clk) THEN
            countercicles <= countercicles + 1;

            IF start = '1' THEN
                done <= '0';
                IF outMP = '1' THEN
                    counterdata <= counterdata + 1;
                    IF counterdata = (Hc * Hr * (F/K)) - 1 THEN
                        counterdata <= 0;
                        countercicles <= 1;
                        done <= '1';
                    END IF;
                END IF;
            END IF;

        END IF;
    END PROCESS clk_proc;

END ARCHITECTURE rtl;