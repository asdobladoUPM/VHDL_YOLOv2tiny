LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

LIBRARY work;
USE work.YOLO_pkg.ALL;

ENTITY tb_MemLayer IS
END tb_MemLayer;

ARCHITECTURE tb OF tb_MemLayer IS

    COMPONENT MemLayer
        GENERIC (
            layer : INTEGER := 1);
        PORT (
            clk : IN STD_LOGIC;
            reset : IN STD_LOGIC;
            oe : IN STD_LOGIC;
            rMem : IN INTEGER;
            rMemodd : IN STD_LOGIC;
            address0 : IN INTEGER;
            address1 : IN INTEGER;
            address2 : IN INTEGER;
            padding : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
            kernelCol : IN INTEGER;
            kernelRow : IN INTEGER;
            Din : IN STD_LOGIC_VECTOR ((kernels(layer) * bits(layer)) - 1 DOWNTO 0);
            we : IN STD_LOGIC;
            wMemOdd : IN STD_LOGIC;
            wBank : IN INTEGER;
            waddress : IN INTEGER;
            Dout : OUT STD_LOGIC_VECTOR ((9 * bits(layer)) - 1 DOWNTO 0));
    END COMPONENT;

    SIGNAL clk : STD_LOGIC;
    SIGNAL reset : STD_LOGIC;
    SIGNAL oe : STD_LOGIC;
    SIGNAL rMemodd : STD_LOGIC;
    SIGNAL rMem : INTEGER;
    SIGNAL address0 : INTEGER;
    SIGNAL address1 : INTEGER;
    SIGNAL address2 : INTEGER;
    SIGNAL padding : STD_LOGIC_VECTOR (2 DOWNTO 0);
    SIGNAL kernelCol : INTEGER;
    SIGNAL kernelRow : INTEGER;
    SIGNAL Din : STD_LOGIC_VECTOR (2 * 6 - 1 DOWNTO 0);
    SIGNAL we : STD_LOGIC;
    SIGNAL wMemOdd : STD_LOGIC;
    SIGNAL wBank : INTEGER;
    SIGNAL waddress : INTEGER;
    SIGNAL Dout : STD_LOGIC_VECTOR (9 * 6 - 1 DOWNTO 0);

    CONSTANT TbPeriod : TIME := 10 ns; -- EDIT Put right period here
    SIGNAL TbClock : STD_LOGIC := '0';
    SIGNAL TbSimEnded : STD_LOGIC := '0';

BEGIN

    dut : MemLayer GENERIC MAP(layer => 10)
    PORT MAP(
        clk => clk,
        reset => reset,
        oe => oe,
        rmemodd => rmemodd,
        rMem => rMem,
        address0 => address0,
        address1 => address1,
        address2 => address2,
        padding => padding,
        kernelCol => kernelCol,
        kernelRow => kernelRow,
        Din => Din,
        we => we,
        wMemOdd => wMemOdd,
        wBank => wBank,
        waddress => waddress,
        Dout => Dout);

    -- Clock generation
    TbClock <= NOT TbClock AFTER TbPeriod/2 WHEN TbSimEnded /= '1' ELSE
        '0';

    -- EDIT: Check that clk is really your main clock signal
    clk <= TbClock;

    stimuli : PROCESS
    BEGIN
        -- EDIT Adapt initialization as needed
        oe <= '0';
        rmemodd <= '0';
        rMem <= 0;
        address0 <= 0;
        address1 <= 1;
        address2 <= 2;

        padding <= (OTHERS => '0');
        kernelCol <= 0;
        kernelRow <= 0;

        Din <= "000001" & "111111";

        we <= '0';
        wMemOdd <= '0';
        wBank <= 0;
        waddress <= 0;

        -- Reset generation
        -- EDIT: Check that reset is really your reset signal
        reset <= '0';
        WAIT FOR 100 ns;
        reset <= '1';
        WAIT FOR 100 ns;

        -- EDIT Add stimuli here
        we <= '1';
        WAIT FOR 10 ns;
        wBank <= 0;
        waddress <= 1;
        WAIT FOR 10 ns;
        wBank <= 0;
        waddress <= 1;
        WAIT FOR 10 ns;
        wBank <= 0;
        waddress <= 3;
        WAIT FOR 10 ns;
        wBank <= 2;
        waddress <= 1;
        WAIT FOR 10 ns;
        wBank <= 4;
        waddress <= 1;
        WAIT FOR 10 ns;
        we <= '0';
        oe <= '1';
        rmem <= 1;
        rmemodd <= '0';
        address0 <= 0;
        address1 <= 1;
        address2 <= 3;
        WAIT FOR 100 * TbPeriod;

        -- Stop the clock and hence terminate the simulation
        TbSimEnded <= '1';
        WAIT;
    END PROCESS;

END tb;

-- Configuration block below is required by some simulators. Usually no need to edit.

CONFIGURATION cfg_tb_MemLayer OF tb_MemLayer IS
    FOR tb
    END FOR;
END cfg_tb_MemLayer;