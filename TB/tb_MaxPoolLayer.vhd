LIBRARY IEEE;
USE IEEE.Std_logic_1164.ALL;
USE IEEE.Numeric_Std.ALL;

ENTITY MaxPoolLayer_tb IS
END;

ARCHITECTURE bench OF MaxPoolLayer_tb IS

  COMPONENT MaxPoolLayer
    GENERIC (
      L_buffer : INTEGER := 10;
      W_buffer: integer :=3
    );
    PORT (
      clk, reset : IN STD_LOGIC;
      col_odd, row_odd : IN STD_LOGIC;
      input : IN STD_LOGIC_VECTOR((W_buffer-1) DOWNTO 0);
      output : OUT STD_LOGIC_VECTOR((W_buffer-1) DOWNTO 0)
    );
  END COMPONENT;

  SIGNAL clk, reset : STD_LOGIC;
  SIGNAL col_odd, row_odd : STD_LOGIC;
  SIGNAL input : STD_LOGIC_VECTOR(2 DOWNTO 0);
  SIGNAL output : STD_LOGIC_VECTOR(2 DOWNTO 0);

  CONSTANT clock_period : TIME := 10 ns;
  SIGNAL stop_the_clock : BOOLEAN;

BEGIN

  uut : MaxPoolLayer GENERIC MAP(L_buffer =>4, W_buffer=>3)
  PORT MAP(
    clk => clk,
    reset => reset,
    col_odd => col_odd,
    row_odd => row_odd,
    input => input,
    output => output);

  stimulus : PROCESS
  BEGIN

    -- Put initialisation code here
    reset <= '0';
    row_odd <= '0';
    col_odd <= '0';
    wait for 50 ns;

    -- Put test bench stimulus code here
    reset <= '1';

    input <= "101";
    col_odd <= '1';
    row_odd <= '1';
    wait for clock_period;

    input <= "011";
    col_odd <= '0';
    wait for clock_period;

    input <= "001";
    col_odd <= '1';
    wait for clock_period;

    input <= "010";
    col_odd <= '0';
    wait for clock_period;

    input <= "110";
    col_odd <= '1';
    wait for clock_period;

    input <= "000";
    col_odd <= '0';
    wait for clock_period;

    input <= "000";
    col_odd <= '1';
    wait for clock_period;

    input <= "011";
    col_odd <= '0';
    wait for clock_period;

    input <= "001";
    col_odd <= '1';
    row_odd <= '0';
    wait for clock_period;

    input <= "001";
    col_odd <= '0';
    wait for clock_period;

    input <= "011";
    col_odd <= '1';
    wait for clock_period;

    input <= "000";
    col_odd <= '0';
    wait for clock_period;

    input <= "001";
    col_odd <= '1';
    wait for clock_period;

    input <= "111";
    col_odd <= '0';
    wait for clock_period;

    input <= "001";
    col_odd <= '1';
    wait for clock_period;

    input <= "001";
    col_odd <= '0';
    wait for clock_period;
    
        input <= "101";
    col_odd <= '1';
    row_odd <= '1';
    wait for clock_period;
input <= "101";
    col_odd <= '1';
    row_odd <= '1';
    wait for clock_period;

    input <= "011";
    col_odd <= '0';
    wait for clock_period;

    input <= "001";
    col_odd <= '1';
    wait for clock_period;

    input <= "010";
    col_odd <= '0';
    wait for clock_period;

    input <= "110";
    col_odd <= '1';
    wait for clock_period;

    input <= "000";
    col_odd <= '0';
    wait for clock_period;

    input <= "000";
    col_odd <= '1';
    wait for clock_period;

    input <= "011";
    col_odd <= '0';
    wait for clock_period;

    input <= "001";
    col_odd <= '1';
    row_odd <= '0';
    wait for clock_period;

    input <= "001";
    col_odd <= '0';
    wait for clock_period;

    input <= "011";
    col_odd <= '1';
    wait for clock_period;

    input <= "000";
    col_odd <= '0';
    wait for clock_period;

    input <= "001";
    col_odd <= '1';
    wait for clock_period;

    input <= "111";
    col_odd <= '0';
    wait for clock_period;

    input <= "001";
    col_odd <= '1';
    wait for clock_period;

    input <= "001";
    col_odd <= '0';
    wait for clock_period;
    
        input <= "101";
    col_odd <= '1';
    row_odd <= '1';
    wait for clock_period;

    

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