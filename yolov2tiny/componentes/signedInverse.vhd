LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

LIBRARY work;
USE work.YOLO_pkg.ALL;

ENTITY signedInverse IS
    GENERIC (layer : INTEGER := 1);
    PORT (
        datain : IN STD_LOGIC_VECTOR(bits(layer)-1 DOWNTO 0);
        Weights : IN STD_LOGIC;
        dataout : OUT STD_LOGIC_VECTOR(bits(layer)-1 DOWNTO 0)
    );
END ENTITY signedInverse;

ARCHITECTURE rtl OF signedInverse IS

    SIGNAL s_input : signed(bits(layer)-1 DOWNTO 0);
    SIGNAL s_output : signed(bits(layer)-1 DOWNTO 0);

BEGIN

    MUX : PROCESS (Weights, s_input)
    BEGIN

        CASE Weights IS
            WHEN '1' =>
                s_output <= s_input;
            WHEN OTHERS =>
                s_output <= NOT(s_input) + 1;
        END CASE;

    END PROCESS MUX;

    dataout <= STD_LOGIC_VECTOR(s_output);
    s_input <= signed(datain);

END ARCHITECTURE rtl;