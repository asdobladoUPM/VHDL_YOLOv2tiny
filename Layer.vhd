LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

LIBRARY work;
USE work.YOLO_pkg.ALL;

ENTITY Layer IS
    GENERIC (L : INTEGER := 2);
    PORT (
        clk : IN STD_LOGIC;
        reset : IN STD_LOGIC;

        datain : IN STD_LOGIC_VECTOR ((grid(L) * 6) - 1 DOWNTO 0);
        weights : IN STD_LOGIC_VECTOR ((kernels(L) * (grid(L))) - 1 DOWNTO 0);
        bias : IN signed ((kernels(L) * 2 * 16) - 1 DOWNTO 0);

        start : IN STD_LOGIC;

        dataout : OUT signed ((kernels(L) * 6) - 1 DOWNTO 0));
END Layer;

ARCHITECTURE rtl OF Layer IS

    CONSTANT rst_val : STD_LOGIC := '0';

    CONSTANT Hr : INTEGER := rows(L);
    CONSTANT Hc : INTEGER := columns(L);
    CONSTANT F : INTEGER := filters(L);
    CONSTANT Ch : INTEGER := channels(L);
    CONSTANT K : INTEGER := kernels(L);
    CONSTANT Gr : INTEGER := grid(L);
    CONSTANT BW : INTEGER := bufferwidth(L);

    COMPONENT ConvLayer
        GENERIC (L : INTEGER);
        PORT (
            clk : IN STD_LOGIC;
            reset : IN STD_LOGIC;

            datain : IN STD_LOGIC_VECTOR((grid(L) * 6) - 1 DOWNTO 0);

            padding : IN STD_LOGIC_VECTOR(grid(L) - 1 DOWNTO 0);
            startLbuffer : IN STD_LOGIC;
            enableLbuffer : IN STD_LOGIC;

            Weights : IN STD_LOGIC_VECTOR(grid(L) - 1 DOWNTO 0);
            Ynorm : IN signed(15 DOWNTO 0);
            Bnorm : IN signed(15 DOWNTO 0);

            dataout : OUT STD_LOGIC_VECTOR(5 DOWNTO 0));

    END COMPONENT;

    COMPONENT MaxPoolLayer
        GENERIC (
            L_buffer : INTEGER;
            W_buffer : INTEGER);
        PORT (
            clk, reset : IN STD_LOGIC;
            col_odd, row_odd : IN STD_LOGIC;
            input : IN STD_LOGIC_VECTOR((W_buffer - 1) DOWNTO 0);
            output : OUT STD_LOGIC_VECTOR((W_buffer - 1) DOWNTO 0));
    END COMPONENT;

    SIGNAL CLdataout : STD_LOGIC_VECTOR((K * 6) - 1 DOWNTO 0);

    SIGNAL deadline_count_row : INTEGER := 0;
    SIGNAL count_row : INTEGER := 1;
    SIGNAL row_odd : STD_LOGIC := '1';

    SIGNAL count_col : INTEGER := 1;
    SIGNAL col_odd : STD_LOGIC := '1';

    SIGNAL count_ch : INTEGER := 1;

    SIGNAL count_filters : INTEGER := 0;

    SIGNAL startLbuffer : STD_LOGIC := '1';
    SIGNAL deadline_startLbuffer : INTEGER := 0;

    SIGNAL padding : STD_LOGIC_VECTOR(8 DOWNTO 0);

BEGIN
    --    ConvL : FOR I IN 1 TO K GENERATE
    --        ConvLX : ConvLayer
    --        GENERIC MAP(L => L)
    --        PORT MAP(
    --            clk => clk, reset => reset,
    --            datain => datain,
    --            padding => padding, startLbuffer => startLbuffer, enableLBuffer => '1',
    --            Weights => weights((I * Gr) - 1 DOWNTO (I * Gr) - 9),
    --            Ynorm => bias(((I * 32) - 17) DOWNTO ((I * 32) - 32)),
    --            Bnorm => bias(((I * 32) - 1) DOWNTO ((I * 32) - 16)),
    --            dataout => CLdataout((I * 6) - 1 DOWNTO (I * 6) - 6));

    --    END GENERATE ConvL;

    clk_proc : PROCESS (clk, reset)
    BEGIN
        IF reset = rst_val THEN
            --filas
            row_odd <= '1';
            count_row <= 1;
            deadline_count_row <= 0;

            --columnas
            col_odd <= '1';
            count_col <= 1;

            --channel
            count_ch <= 1;

            --filters
            count_filters <= 1;

            --startBuffer
            startLbuffer <= '1';
            deadline_startLbuffer <= 0;

            --padding
            padding <= "001001111";

        ELSIF rising_edge(clk) THEN

            IF start = '1' THEN

                --ColumnasCanalesYFiltros
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
                        END IF;
                    END IF;
                END IF;

                --filas
                IF deadline_count_row < (((Hc * Ch * F)/K) - 1) THEN
                    row_odd <= row_odd;
                    deadline_count_row <= deadline_count_row + 1;
                ELSE
                    row_odd <= NOT(row_odd);
                    deadline_count_row <= 0;
                    count_row <= count_row + 1;
                    IF count_row = Hr THEN
                        count_row <= 1;
                    END IF;
                END IF;

                --startLBuffer
                IF deadline_startLbuffer < Hc - 1 THEN
                    startLbuffer <= '1';
                    deadline_startLbuffer <= deadline_startLbuffer + 1;
                ELSE
                    startLbuffer <= '0';
                    deadline_startLbuffer <= deadline_startLbuffer + 1;
                    IF deadline_startLbuffer = (Hc * Ch) - 1 THEN --cuando terminemos con el filtro 
                        startLbuffer <= '1';
                        deadline_startLbuffer <= 0;
                    END IF;
                END IF;

                --padding
                --0
                IF count_row = 1 THEN
                    padding(0) <= '1';
                ELSE
                    IF count_col = Hc THEN
                        padding(0) <= '1';
                    ELSE
                        padding(0) <= '0';
                    END IF;
                END IF;

                --1
                IF count_row = 1 THEN
                    padding(1) <= '1';
                    IF (count_col = Hc AND count_ch = Ch AND count_filters = F/K) THEN
                        padding(1) <= '0';
                    END IF;
                ELSE
                    IF (count_row = Hr AND count_col = Hc AND count_ch = Ch AND count_filters = F/K) THEN
                        padding(1) <= '1';
                    ELSE
                        padding(1) <= '0';
                    END IF;
                END IF;

                --2
                IF count_row = 1 THEN
                    padding(2) <= '1';
                    IF (count_col = Hc AND count_ch = Ch AND count_filters = F/K) THEN
                        padding(2) <= '0';
                    END IF;
                ELSE
                    IF count_col = Hc - 1 THEN
                        padding(2) <= '1';
                    ELSE
                        padding(2) <= '0';
                    END IF;
                END IF;

                --3
                IF count_col = Hc THEN
                    padding(3) <= '1';
                ELSE
                    padding(3) <= '0';
                END IF;

                --5
                IF count_col = Hc - 1 THEN
                    padding(5) <= '1';
                ELSE
                    padding(5) <= '0';

                END IF;

                --6
                IF count_row = Hr THEN
                    padding(6) <= '1';
                ELSE
                    IF count_col = Hc THEN
                        padding(6) <= '1';
                    ELSE
                        padding(6) <= '0';
                    END IF;
                END IF;

                --7
                IF count_row = Hr THEN
                    padding(7) <= '1';
                    IF (count_col = Hc AND count_ch = Ch AND count_filters = F/K) THEN
                        padding(7) <= '0';
                    END IF;
                ELSE
                    padding(7) <= '0';
                    IF (count_row = Hr - 1 AND count_col = Hc AND count_ch = Ch AND count_filters = F/K) THEN
                        padding(7) <= '1';
                    END IF;
                END IF;

                --8
                IF count_row = Hr THEN
                    padding(8) <= '1';
                    IF (count_col = Hc AND count_ch = Ch AND count_filters = F/K) THEN
                        padding(8) <= '0';
                    END IF;
                ELSE
                    IF count_col = Hc - 1 THEN
                        padding(8) <= '1';
                    ELSIF count_row = Hr - 1 AND count_col = Hc AND count_filters = F/K THEN
                        padding(8) <= '1';
                    ELSE
                        padding(8) <= '0';
                    END IF;
                END IF;

            END IF;
        END IF;
    END PROCESS clk_proc;

    padding(4) <= '0';

END ARCHITECTURE rtl;