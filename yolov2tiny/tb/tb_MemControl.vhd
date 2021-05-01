LIBRARY IEEE;
USE IEEE.Std_logic_1164.ALL;
USE IEEE.Numeric_Std.ALL;

ENTITY MemControl_tb IS
END;

ARCHITECTURE bench OF MemControl_tb IS

  COMPONENT MemControl
    GENERIC (
      layer : INTEGER := 1);
    PORT (
      clk : IN STD_LOGIC;
      reset : IN STD_LOGIC;
      start: in std_logic;
      we : IN STD_LOGIC;
      rMem : OUT INTEGER;
      rMemOdd : OUT STD_LOGIC;
      address0 : OUT INTEGER;
      address1 : OUT INTEGER;
      address2 : OUT INTEGER;
              weightaddress : OUT INTEGER;

      padding : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
      kernelCol : OUT INTEGER;
      kernelRow : OUT INTEGER;
      weRAM : OUT STD_LOGIC;
      wMemOdd : OUT STD_LOGIC;
      wBank : OUT INTEGER;
      waddress : OUT INTEGER;
      validOut : OUT STD_LOGIC);
  END COMPONENT;

  SIGNAL clk : STD_LOGIC;
  SIGNAL reset : STD_LOGIC;
  SIGNAL we : STD_LOGIC;
    SIGNAL start : STD_LOGIC;

  SIGNAL rMem : INTEGER;
  SIGNAL rMemOdd : STD_LOGIC;
  SIGNAL address0 : INTEGER;
  SIGNAL address1 : INTEGER;
  SIGNAL address2 : INTEGER;
    SIGNAL weightaddress : INTEGER;

  SIGNAL padding : STD_LOGIC_VECTOR(2 DOWNTO 0);
  SIGNAL kernelCol : INTEGER;
  SIGNAL kernelRow : INTEGER;
  SIGNAL weRAM : STD_LOGIC;
  SIGNAL wMemOdd : STD_LOGIC;
  SIGNAL wBank : INTEGER;
  SIGNAL waddress : INTEGER;
  SIGNAL validOut : STD_LOGIC;

  CONSTANT clock_period : TIME := 10 ns;
  SIGNAL stop_the_clock : BOOLEAN;

BEGIN

  -- Insert values for generic parameters !!
  uut : MemControl GENERIC MAP(layer => 8)
  PORT MAP(
    clk => clk,
    reset => reset,
    start => start,
    we => we,
    rMem => rMem,
    rMemOdd => rMemOdd,
    address0 => address0,
    address1 => address1,
    address2 => address2,
        weightaddress => weightaddress,

    padding => padding,
    kernelCol => kernelCol,
    kernelRow => kernelRow,
    weRAM => weRAM,
    wMemOdd => wMemOdd,
    wBank => wBank,
    waddress => waddress,
    validOut => validOut);

  stimulus : PROCESS
  BEGIN

    -- Put initialisation code here

    reset <= '0';
    WAIT FOR 5 ns;
    reset <= '1';
    WAIT FOR 50 ns;
    start<='1';
    we<='1';
    
    wait for 5000000 ms;


    -- Put test bench stimulus code here

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