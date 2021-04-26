LIBRARY IEEE;
USE IEEE.Std_logic_1164.ALL;
USE IEEE.Numeric_Std.ALL;

ENTITY CLcontrol_tb IS
END;

ARCHITECTURE bench OF CLcontrol_tb IS

  COMPONENT CLcontrol
    GENERIC (
      Hr : INTEGER;
      Hc : INTEGER;
      F : INTEGER;
      Ch : INTEGER;
      K : INTEGER
    );
    PORT (
      clk : IN STD_LOGIC;
      reset : IN STD_LOGIC;
      start : IN STD_LOGIC;

      padding : OUT STD_LOGIC_VECTOR(8 DOWNTO 0);
      startLBuffer : OUT STD_LOGIC;
      enableLBuffer : OUT STD_LOGIC;
      validOut : OUT STD_LOGIC
    );
  END COMPONENT;

  SIGNAL clk : STD_LOGIC;
  SIGNAL reset : STD_LOGIC;
  SIGNAL start : STD_LOGIC;
  SIGNAL padding : STD_LOGIC_VECTOR(8 DOWNTO 0);
  SIGNAL startLBuffer : STD_LOGIC;
  SIGNAL enableLBuffer : STD_LOGIC;
  SIGNAL validOut : STD_LOGIC;

  CONSTANT clock_period : TIME := 10 ns;
  SIGNAL stop_the_clock : BOOLEAN;

BEGIN

  -- Insert values for generic parameters !!
  uut : CLcontrol GENERIC MAP(
    Hr => 2,
    Hc => 4,
    F => 2,
    Ch => 4,
    K => 1)
  PORT MAP(
    clk => clk,
    reset => reset,
    start => start,
    padding => padding,
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

    wait for 2 us;

    start <= '0';

    wait for 50 ns;

    start <= '1';

    wait for 300 ns;

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