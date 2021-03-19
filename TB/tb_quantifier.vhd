LIBRARY IEEE;
USE IEEE.Std_logic_1164.ALL;
USE IEEE.Numeric_Std.ALL;

ENTITY quantifier_tb IS
END;

ARCHITECTURE bench OF quantifier_tb IS

    COMPONENT quantifier
        GENERIC (
            Win : INTEGER := 17;
            Wout : INTEGER := 6
        );
        PORT (
            dIN : IN STD_LOGIC_VECTOR((Win - 1)DOWNTO 0);
            dOUT : OUT STD_LOGIC_VECTOR((Wout - 1) DOWNTO 0));
    END COMPONENT;

    SIGNAL dIN : STD_LOGIC_VECTOR((10- 1)DOWNTO 0);
    SIGNAL dOUT : STD_LOGIC_VECTOR((3 - 1) DOWNTO 0);

BEGIN

    -- Insert values for generic parameters !!
    uut : quantifier GENERIC MAP(
        Win => 10,
        Wout => 3)
    PORT MAP(
        dIN => dIN,
        dOUT => dOUT);

    stimulus : PROCESS
    BEGIN

        din <= "1010101110";
        WAIT FOR 10 ns;
        din <= "1111110000";
        WAIT FOR 10 ns;
        din <= "1001110100";
        WAIT FOR 10 ns;
        din <= "1111111111";
        WAIT FOR 10 ns;
        din <= "0000000000";
        WAIT;
    END PROCESS;
END;