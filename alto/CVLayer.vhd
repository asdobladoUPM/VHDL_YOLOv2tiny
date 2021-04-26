LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

LIBRARY work;
USE work.YOLO_pkg.ALL;

ENTITY CVLayer IS
    GENERIC (L : INTEGER := 2);
    PORT (
        clk : IN STD_LOGIC;
        reset : IN STD_LOGIC;

        datain : IN STD_LOGIC_VECTOR ((grid(L) * 6) - 1 DOWNTO 0);
        weights : IN STD_LOGIC_VECTOR ((kernels(L) * (grid(L))) - 1 DOWNTO 0);
        bias : IN signed ((kernels(L) * 2 * 16) - 1 DOWNTO 0);

        start : IN STD_LOGIC;

        dataout : OUT STD_LOGIC_VECTOR ((kernels(L) * 6) - 1 DOWNTO 0)); --dimension?
END CVLayer;

ARCHITECTURE rtl OF CVLayer IS

    CONSTANT rst_val : STD_LOGIC := '0';

    CONSTANT Hr : INTEGER := rows(L);
    CONSTANT Hc : INTEGER := columns(L);
    CONSTANT F : INTEGER := filters(L);
    CONSTANT Ch : INTEGER := channels(L);
    CONSTANT K : INTEGER := kernels(L);
    CONSTANT Gr : INTEGER := grid(L);
    CONSTANT BW : INTEGER := bufferwidth(L);

    COMPONENT control
        GENERIC (
            Step : INTEGER := 2;
            Hr : INTEGER;
            Hc : INTEGER;
            F : INTEGER;
            Ch : INTEGER;
            K : INTEGER;
            Gr : INTEGER;
            BW : INTEGER
        );
        PORT (
            clk : IN STD_LOGIC;
            reset : IN STD_LOGIC;

            start : IN STD_LOGIC;

            CVpadding : OUT STD_LOGIC_VECTOR(8 DOWNTO 0);
            CVstartLBuffer : OUT STD_LOGIC;

            MPval_d1 : OUT STD_LOGIC; -- es como el start del MP
            MPval_d2 : OUT STD_LOGIC;
            MPenLBuffer : OUT STD_LOGIC;

            col_odd : OUT STD_LOGIC;
            row_odd : OUT STD_LOGIC;

            count_col : OUT INTEGER;
            count_row : OUT INTEGER;
            count_ch : OUT INTEGER;
            count_filters : OUT INTEGER;
        );
    END COMPONENT;

    COMPONENT ConvCVLayer
        GENERIC (L : INTEGER);
        PORT (
            clk : IN STD_LOGIC;
            reset : IN STD_LOGIC;

            datain : IN STD_LOGIC_VECTOR((Gr * 6) - 1 DOWNTO 0);

            padding : IN STD_LOGIC_VECTOR(Gr - 1 DOWNTO 0);
            startLbuffer : IN STD_LOGIC;
            enableLbuffer : IN STD_LOGIC;

            Weights : IN STD_LOGIC_VECTOR(Gr - 1 DOWNTO 0);
            Ynorm : IN signed(15 DOWNTO 0);
            Bnorm : IN signed(15 DOWNTO 0);

            dataout : OUT STD_LOGIC_VECTOR(5 DOWNTO 0));

    END COMPONENT;

    COMPONENT MaxPoolCVLayer
        GENERIC (
            BL : INTEGER;
            WL : INTEGER);
        PORT (
            clk, reset : IN STD_LOGIC;
            Hc, count_col, count_row : IN INTEGER;

            col_odd, row_odd : IN STD_LOGIC;
            datain : IN STD_LOGIC_VECTOR((WL - 1) DOWNTO 0);
            dataout : OUT STD_LOGIC_VECTOR((WL - 1) DOWNTO 0));
    END COMPONENT;

    SIGNAL CLdataout : STD_LOGIC_VECTOR((K * 6) - 1 DOWNTO 0);

    SIGNAL padding : STD_LOGIC_VECTOR(8 DOWNTO 0);
    SIGNAL startLbuffer : STD_LOGIC;

    SIGNAL val_d1 : STD_LOGIC;
    SIGNAL val_d2 : STD_LOGIC;
    SIGNAL enLBuffer : STD_LOGIC;

    signal col_odd: STD_LOGIC;
    signal row_odd: STD_LOGIC;


    

    

BEGIN

    cont : control
    GENERIC MAP(
        Step = >, Hr => Hr, => Hc => Hc, F => F,
        Ch => Ch, K => K, Gr => Gr, BW => BW)
    PORT MAP(
        clk => clk, reset => reset, start => start,
        CVpadding => padding, CVstartLBuffer => startLbuffer
        MPval_d1 => val_d1, MPval_d2 => val_d2, MPenLBuffer => enLBuffer,
        col_odd => col_odd, row_odd => row_odd, count_col => count_col,
        count_row => count_row, count_ch => count_ch, count_filters => count_filters);

    proc : FOR I IN 1 TO K GENERATE
        ConvLX : ConvCVLayer
        GENERIC MAP(L => L)
        PORT MAP(
            clk => clk, reset => reset,
            datain => datain,
            padding => padding, startLbuffer => startLbuffer, enableLBuffer => '1',
            Weights => weights((I * Gr) - 1 DOWNTO (I * Gr) - 9),
            Ynorm => bias(((I * 32) - 17) DOWNTO ((I * 32) - 32)),
            Bnorm => bias(((I * 32) - 1) DOWNTO ((I * 32) - 16)),
            dataout => CLdataout((I * 6) - 1 DOWNTO (I * 6) - 6));

        MPL : MaxPoolCVLayer
        GENERIC MAP(BL => (Hc/2) * F, WL => 6) --X EL NUMERO DE F
        PORT MAP(
            clk => clk,
            reset => reset,
            count_row => count_row,
            count_col => count_col,
            col_odd => col_odd,
            row_odd => row_odd,
            datain => (OTHERS => '0'),
            dataout => dataout
        );

    END GENERATE proc;

END ARCHITECTURE rtl;