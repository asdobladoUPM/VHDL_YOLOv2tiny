LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
ENTITY tb_LeakyReLU IS
END tb_LeakyReLU;

ARCHITECTURE tb OF tb_LeakyReLU IS

    COMPONENT LeakyReLU
        PORT (
            input : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
            output : OUT STD_LOGIC_VECTOR (15 DOWNTO 0));
    END COMPONENT;

    SIGNAL input : STD_LOGIC_VECTOR (15 DOWNTO 0);
    SIGNAL output : STD_LOGIC_VECTOR (15 DOWNTO 0);

BEGIN

    dut : LeakyReLU
    PORT MAP(
        input => input,
        output => output);

    stimuli : PROCESS
    BEGIN

        input <= (OTHERS => '0');
        WAIT FOR 50 ns;

        input <= "0000000000001010";
        WAIT FOR 50 ns;

        input <= "1111111111110110";
        WAIT FOR 50 ns;

        input <= "0000010011101000";
        WAIT FOR 50 ns;

        input <= "1111101100011000";
        WAIT FOR 50 ns;

        WAIT;
    END PROCESS;

END tb;

-- Configuration block below is required by some simulators. Usually no need to edit.

CONFIGURATION cfg_tb_LeakyReLU OF tb_LeakyReLU IS
    FOR tb
    END FOR;
END cfg_tb_LeakyReLU;