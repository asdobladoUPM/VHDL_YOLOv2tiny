library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity RAM_tb is
end;

architecture bench of RAM_tb is

  component RAM
      GENERIC (
          WL : INTEGER := 8;
          bitsAddr : INTEGER := 64);
      PORT (
          clk : IN STD_LOGIC;
          oe : IN STD_LOGIC;
          we : IN STD_LOGIC;
          Din : IN STD_LOGIC_VECTOR(WL - 1 DOWNTO 0);
          Addr : IN STD_LOGIC_VECTOR(bitsAddr - 1 DOWNTO 0);
          Dout : OUT STD_LOGIC_VECTOR(WL - 1 DOWNTO 0));
  end component;

  signal clk: STD_LOGIC;
  signal oe: STD_LOGIC;
  signal we: STD_LOGIC;
  signal Din: STD_LOGIC_VECTOR(2 - 1 DOWNTO 0);
  signal Addr: STD_LOGIC_VECTOR(2 - 1 DOWNTO 0);
  signal Dout: STD_LOGIC_VECTOR(2 - 1 DOWNTO 0);

  constant clock_period: time := 10 ns;
  signal stop_the_clock: boolean;

begin

  -- Insert values for generic parameters !!
  uut: RAM generic map ( WL       => 2,
                         bitsAddr =>  2)
              port map ( clk      => clk,
                         oe       => oe,
                         we       => we,
                         Din      => Din,
                         Addr     => Addr,
                         Dout     => Dout );

  stimulus: process
  begin
  
    -- Put initialisation code here
    oe <= '0';
    we <= '0';
    Din <= "00";
    Addr <= "00";

    -- Put test bench stimulus code here

    we <= '1';
    Din <= "11";
    Addr <= "00";

    wait for 10 ns;

    we <= '1';
    Din <= "10";
    Addr <= "11";

    wait for 10 ns;

    we <= '0';
    oe <= '1';
    Addr <= "00";

    wait for 10 ns;

    oe <= '1';
    Addr <= "11";

    wait for 10 ns;

    stop_the_clock <= true;
    wait;
  end process;

  clocking: process
  begin
    while not stop_the_clock loop
      clk <= '0', '1' after clock_period / 2;
      wait for clock_period;
    end loop;
    wait;
  end process;

end;