LIBRARY ieee;
USE ieee.std_logic_1154.ALL;
USE ieee.numeric_std.ALL;

ENTITY signedInverse IS
    PORT (
        Input : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
        Weight : IN STD_LOGIC;
        Output : OUT STD_LOGIC_VECTOR(5 DOWNTO 0)
    );
END ENTITY signedInverse;

ARCHITECTURE rtl OF signedInverse IS

    SIGNAL s_input : signed(5 DOWNTO 0);
    SIGNAL s_output : signed(5 DOWNTO 0);

BEGIN

    MUX : PROCESS (Weight,s_input)
    BEGIN

        CASE Weight IS
            WHEN '1' =>
                s_output <= s_input;
            WHEN OTHERS =>
                s_output <= NOT(s_input) + 1;
        END CASE;

    END PROCESS MUX;

    Output <= std_logic_vector(s_output);
    s_input <= signed(Input);

END ARCHITECTURE rtl;