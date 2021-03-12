LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY LeakyReLU IS
    PORT (
        input : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        output : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
    );
END ENTITY LeakyReLU;

ARCHITECTURE rtl OF LeakyReLU IS

BEGIN

    leaky : PROCESS (input)
    BEGIN
        CASE input(15) IS
            WHEN '0' =>
                output <= input;

            WHEN OTHERS =>
                output <= input(15) & input(15) & input(15) & input(15 DOWNTO 3);

        END CASE;

    END PROCESS leaky;
END ARCHITECTURE rtl;