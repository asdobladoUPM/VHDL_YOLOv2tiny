LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY MPLayer IS
    GENERIC (
        BL : INTEGER := 10;  --------------debe ser Hc*Ch/2 para step 2 y (Hc-1)*Ch para step 1????????????
        WL : INTEGER := 6
    );
    PORT (
        clk, reset : IN STD_LOGIC;

        val_d1 : IN STD_LOGIC;
        val_d2 : IN STD_LOGIC;
        enLBuffer : IN STD_LOGIC;

        datain : IN STD_LOGIC_VECTOR((WL - 1) DOWNTO 0);

        dataout : OUT STD_LOGIC_VECTOR((WL - 1) DOWNTO 0)
    );
END ENTITY MPLayer;

ARCHITECTURE rtl OF MPLayer IS

    COMPONENT LinealBuffer
        GENERIC (
            BL : INTEGER;
            WL : INTEGER
        );
        PORT (
            clk : IN STD_LOGIC;
            reset : IN STD_LOGIC;

            enable_LBuffer : IN STD_LOGIC;
            datain : IN STD_LOGIC_VECTOR((WL - 1) DOWNTO 0);

            dataout : OUT STD_LOGIC_VECTOR((WL - 1) DOWNTO 0)
        );
    END COMPONENT;

    CONSTANT rst_val : STD_LOGIC := '0';
    SIGNAL zeroes : STD_LOGIC_VECTOR((WL - 2) DOWNTO 0);

    SIGNAL s_datain : SIGNED((WL - 1) DOWNTO 0);

    SIGNAL max1, max2 : SIGNED((WL - 1) DOWNTO 0);

    SIGNAL d1 : STD_LOGIC_VECTOR((WL - 1) DOWNTO 0);
    SIGNAL sd1 : SIGNED((WL - 1) DOWNTO 0);
    SIGNAL LBo : STD_LOGIC_VECTOR((WL - 1) DOWNTO 0);
    SIGNAL sLBo : SIGNED((WL - 1) DOWNTO 0);
BEGIN

    s_datain <= SIGNED(datain);
    sLBo <= signed(LBo);
    zeroes <= (OTHERS => '0');
    sd1 <= signed(d1);

    LB : LinealBuffer
    GENERIC MAP(BL => BL, WL => WL)
    PORT MAP(
        clk => clk,
        reset => reset,
        enable_LBuffer => enLBuffer,
        datain => STD_LOGIC_VECTOR(max1),
        dataout => LBo);

    sec : PROCESS (clk, reset)
    BEGIN
        IF reset = '0' THEN

            d1 <= '1' & zeroes;

        ELSIF rising_edge(clk) THEN

            IF val_d1 = '1' THEN
                d1 <= datain;
            END IF;

        END IF;

    END PROCESS sec;

    MAX1p : PROCESS (sd1, s_datain)
    BEGIN
        IF (sd1 > s_datain) THEN
            max1 <= sd1;
        ELSE
            max1 <= s_datain;
        END IF;
    END PROCESS MAX1p;

    MAX2p : PROCESS (sLBo, max1)
    BEGIN
        IF (sLBo > max1) THEN
            max2 <= sLBo;
        ELSE
            max2 <= max1;
        END IF;
    END PROCESS MAX2p;

    dataout <= STD_LOGIC_VECTOR(max2);

END ARCHITECTURE rtl;