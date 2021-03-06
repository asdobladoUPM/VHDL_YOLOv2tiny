LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY tb_HA IS
END tb_HA;

ARCHITECTURE tb OF tb_HA IS

    COMPONENT HA
        PORT (
            in_b1 : IN STD_LOGIC;
            in_b2 : IN STD_LOGIC;
            S : OUT STD_LOGIC;
            Cout : OUT STD_LOGIC);
    END COMPONENT;

    SIGNAL in_b1 : STD_LOGIC;
    SIGNAL in_b2 : STD_LOGIC;
    SIGNAL S : STD_LOGIC;
    SIGNAL Cout : STD_LOGIC;

BEGIN

    dut : HA
    PORT MAP(
        in_b1 => in_b1,
        in_b2 => in_b2,
        S => S,
        Cout => Cout);

    stimuli : PROCESS
    BEGIN
        -- EDIT Adapt initialization as needed
        in_b1 <= '0';
        in_b2 <= '0';
        WAIT FOR 100 ns;
        in_b1 <= '1';
        in_b2 <= '0';
        WAIT FOR 100 ns;
        in_b1 <= '1';
        in_b2 <= '1';
        WAIT FOR 100 ns;
        in_b1 <= '1';
        in_b2 <= '1';
        WAIT;
    END PROCESS;

END tb;