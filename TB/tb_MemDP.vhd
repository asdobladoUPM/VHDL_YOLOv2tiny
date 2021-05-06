-- Testbench created online at:
--   https://www.doulos.com/knowhow/perl/vhdl-testbench-creation-using-perl/
-- Copyright Doulos Ltd

LIBRARY IEEE;
USE IEEE.Std_logic_1164.ALL;
USE IEEE.Numeric_Std.ALL;

ENTITY MemDP_tb IS
END;

ARCHITECTURE bench OF MemDP_tb IS

    COMPONENT MemDP
        GENERIC (
            layer : INTEGER := 4);
        PORT (
            clk : IN STD_LOGIC;
            reset : IN STD_LOGIC;
            ValidIN : IN STD_LOGIC;
            rMem : IN INTEGER;
            rMemOdd : IN STD_LOGIC;
            address0 : IN INTEGER;
            address1 : IN INTEGER;
            address2 : IN INTEGER;
            padding : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            kernelCol : IN INTEGER;
            kernelRow : IN INTEGER;
            Din : IN STD_LOGIC_VECTOR((6 * 2) - 1 DOWNTO 0);
            we : IN STD_LOGIC;
            wMemOdd : IN STD_LOGIC;
            wBank : IN INTEGER;
            waddress : IN INTEGER;
            Dout : OUT STD_LOGIC_VECTOR((9 * 6) - 1 DOWNTO 0);
            Weightaddress : IN INTEGER;
            Weights : OUT STD_LOGIC_VECTOR(8 DOWNTO 0));
    END COMPONENT;

    SIGNAL clk : STD_LOGIC;
    SIGNAL reset : STD_LOGIC;
    SIGNAL ValidIN : STD_LOGIC;
    SIGNAL rMem : INTEGER;
    SIGNAL rMemOdd : STD_LOGIC;
    SIGNAL address0 : INTEGER;
    SIGNAL address1 : INTEGER;
    SIGNAL address2 : INTEGER;
    SIGNAL padding : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL kernelCol : INTEGER;
    SIGNAL kernelRow : INTEGER;
    SIGNAL Din : STD_LOGIC_VECTOR((2 * 6) - 1 DOWNTO 0);
    SIGNAL we : STD_LOGIC;
    SIGNAL wMemOdd : STD_LOGIC;
    SIGNAL wBank : INTEGER;
    SIGNAL waddress : INTEGER;
    SIGNAL Dout : STD_LOGIC_VECTOR((9 * 6) - 1 DOWNTO 0);
    SIGNAL Weightaddress : INTEGER;
    SIGNAL Weights : STD_LOGIC_VECTOR(8 DOWNTO 0);

    CONSTANT clock_period : TIME := 10 ns;
    SIGNAL stop_the_clock : BOOLEAN;
BEGIN

    -- Insert values for generic parameters !!
    uut : MemDP GENERIC MAP(layer =>3)
    PORT MAP(
        clk => clk,
        reset => reset,
        ValidIN => ValidIN,
        rMem => rMem,
        rMemOdd => rMemOdd,
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
        Dout => Dout,
        Weightaddress => Weightaddress,
        Weights => Weights);

    stimuli : PROCESS
    BEGIN
        -- EDIT Adapt initialization as needed
        validIn <= '0';
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
        validIn <= '1';
        rmem <= 1;
        rmemodd <= '0';
        address0 <= 0;
        address1 <= 1;
        address2 <= 3;
        WAIT FOR 100 * clock_period;

        -- Stop the clock and hence terminate the simulation
        stop_the_clock <= true;
        WAIT;
    END PROCESS;

    clocking : PROCESS
    BEGIN
        WHILE NOT stop_the_clock LOOP
            clk <= '0', '1' AFTER clock_period / 2;
            WAIT FOR clock_period;
        END LOOP;
        WAIT;
    END PROCESS;
END;