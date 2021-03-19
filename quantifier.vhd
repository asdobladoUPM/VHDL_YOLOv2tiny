LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY quantifier IS
    GENERIC (
        Win : INTEGER := 17 ;
        Wout : INTEGER := 6
    );
    PORT (
        dIN : IN STD_LOGIC_VECTOR((Win - 1)DOWNTO 0);
        dOUT : OUT STD_LOGIC_VECTOR((Wout - 1) DOWNTO 0));
END quantifier;

ARCHITECTURE gate_level OF quantifier IS

BEGIN

dOUT <= dIN((Win-1) DOWNTO (Win-Wout));

END gate_level;