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

    start : IN STD_LOGIC;
END capa;

ARCHITECTURE rtl OF capa IS

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

            datain : IN STD_LOGIC_VECTOR((Gr * 6) - 1 DOWNTO 0);

            padding : IN STD_LOGIC_VECTOR(Gr - 1 DOWNTO 0);
            startLbuffer : IN STD_LOGIC;
            enableLbuffer : IN STD_LOGIC;

            Weights : IN STD_LOGIC_VECTOR(Gr - 1 DOWNTO 0);
            Ynorm : IN signed(15 DOWNTO 0);
            Bnorm : IN signed(15 DOWNTO 0);

            dataout : OUT STD_LOGIC_VECTOR(5 DOWNTO 0));

    END COMPONENT;

    COMPONENT MPLayer
        GENERIC (
            BL : INTEGER;
            WL : INTEGER);
        PORT (
            clk, reset : IN STD_LOGIC;

            val_d1 : IN STD_LOGIC;
            val_d2 : IN STD_LOGIC;
            enLBuffer : IN STD_LOGIC;

            datain : IN STD_LOGIC_VECTOR((WL - 1) DOWNTO 0);

            dataout : OUT STD_LOGIC_VECTOR((WL - 1) DOWNTO 0)
        );
    END COMPONENT;

    SIGNAL datain : STD_LOGIC_VECTOR((Gr * 6) - 1 DOWNTO 0);
    SIGNAL padding : STD_LOGIC_VECTOR(Gr - 1 DOWNTO 0);

BEGIN
    ConvLX : ConvLayer
    GENERIC MAP(L => L)
    PORT MAP(
    clk => clk, reset => reset,
    datain => (OTHERS => '0'),
    padding => (OTHERS => '0'), startLbuffer => startLbuffer, enableLBuffer => '1',
    Weights => (OTHERS => '0'),
    Ynorm => (OTHERS => '0'),
    Bnorm => (OTHERS => '0'),
    dataout => OPEN;

    MPL : MPLayer
    GENERIC MAP(BL => (Hc/2) * F, WL => 6) --X EL NUMERO DE F
    PORT MAP(
        clk => clk,
        reset => reset,
        val_d1 = >,
        val_d2 = >,
        enLBuffer = >,
        datain => (OTHERS => '0'),
        dataout => OPEN
    );

END ARCHITECTURE rtl;