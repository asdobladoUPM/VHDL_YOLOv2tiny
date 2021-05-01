LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY LeakyReLU IS
    PORT (
        datain : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        dataout : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
    );
END ENTITY LeakyReLU;

ARCHITECTURE rtl OF LeakyReLU IS

BEGIN

    leaky : PROCESS (datain)
    BEGIN
        CASE datain(15) IS
            WHEN '0' =>
                dataout <= datain;

            WHEN OTHERS =>
                dataout <= datain(15) & datain(15) & datain(15) & datain(15 DOWNTO 3);

        END CASE;

    END PROCESS leaky;
END ARCHITECTURE rtl;