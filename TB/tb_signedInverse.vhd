LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
ENTITY tb_signedInverse IS
END tb_signedInverse;

ARCHITECTURE tb OF tb_signedInverse IS

    COMPONENT signedInverse
        PORT (
            Input : IN STD_LOGIC_VECTOR (5 DOWNTO 0);
            Weight : IN STD_LOGIC;
            Output : OUT STD_LOGIC_VECTOR (5 DOWNTO 0));
    END COMPONENT;

    SIGNAL Input : STD_LOGIC_VECTOR (5 DOWNTO 0);
    SIGNAL Weight : STD_LOGIC;
    SIGNAL Output : STD_LOGIC_VECTOR (5 DOWNTO 0);

BEGIN

    dut : signedInverse
    PORT MAP(
        Input => Input,
        Weight => Weight,
        Output => Output);

    stimuli : PROCESS
    BEGIN
        -- EDIT Adapt initialization as needed
        Input <= "000111";
        Weight <= '0';

        WAIT FOR 100 ns;
        Input <= "000111";
        Weight <= '1';
        WAIT FOR 100 ns;
        Input <= "100111";
        Weight <= '0';
        WAIT FOR 100 ns;
        Input <= "100111";
        Weight <= '1';

        WAIT;
    END PROCESS;

END tb;

-- Configuration block below is required by some simulators. Usually no need to edit.

CONFIGURATION cfg_tb_signedInverse OF tb_signedInverse IS
    FOR tb
    END FOR;
END cfg_tb_signedInverse;