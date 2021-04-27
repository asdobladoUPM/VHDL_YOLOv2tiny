LIBRARY IEEE;
USE IEEE.Std_logic_1164.ALL;
USE IEEE.Numeric_Std.ALL;

ENTITY tb_ConvControl IS
END;

ARCHITECTURE bench OF tb_ConvControl IS

  COMPONENT ConvControl
    GENERIC (
      layer : INTEGER
    );
    PORT (
      clk : IN STD_LOGIC;
      reset : IN STD_LOGIC;
      start : IN STD_LOGIC;

      startLBuffer : OUT STD_LOGIC;
      enableLBuffer : OUT STD_LOGIC;
      validOut : OUT STD_LOGIC
    );
  END COMPONENT;

  SIGNAL clk : STD_LOGIC;
  SIGNAL reset : STD_LOGIC;
  SIGNAL start : STD_LOGIC;
  SIGNAL startLBuffer : STD_LOGIC;
  SIGNAL enableLBuffer : STD_LOGIC;
  SIGNAL validOut : STD_LOGIC;

  CONSTANT clock_period : TIME := 10 ns;
  SIGNAL stop_the_clock : BOOLEAN;

BEGIN

  -- Insert values for generic parameters !!
  uut : ConvControl GENERIC MAP(
    layer => 6)
  PORT MAP(
    clk => clk,
    reset => reset,
    start => start,
    startLBuffer => startLBuffer,
    enableLBuffer => enableLBuffer,
    validOut => validOut);

  stimulus : PROCESS
  BEGIN

    -- Put initialisation code here
    reset <= '0';
    start <= '0';
    wait for 20 ns;
    -- Put test bench stimulus code here

    reset <= '1';

    wait for 20 ns;

    start <= '1';

    wait for 1000 ms;

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