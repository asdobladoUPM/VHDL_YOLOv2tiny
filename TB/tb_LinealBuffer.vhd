LIBRARY IEEE;
USE IEEE.Std_logic_1164.ALL;
USE IEEE.Numeric_Std.ALL;

ENTITY LinealBuffer_tb IS
END;

ARCHITECTURE bench OF LinealBuffer_tb IS

    COMPONENT LinealBuffer
        GENERIC (
            L : INTEGER := 10;
            W : INTEGER := 10
        );
        PORT (
            clk : IN STD_LOGIC;
            reset : IN STD_LOGIC;
            enable_LBuffer : IN STD_LOGIC;
            input : IN STD_LOGIC_VECTOR((W - 1) DOWNTO 0);
            output : OUT STD_LOGIC_VECTOR((W - 1) DOWNTO 0)
        );
    END COMPONENT;

    SIGNAL clk,reset : STD_LOGIC;
    SIGNAL enable_LBuffer : STD_LOGIC;
    SIGNAL input : STD_LOGIC_VECTOR(1 DOWNTO 0);
    SIGNAL output : STD_LOGIC_VECTOR(1 DOWNTO 0);

    CONSTANT clock_period : TIME := 10 ns;
    SIGNAL stop_the_clock : BOOLEAN;

BEGIN

    -- Insert values for generic parameters !!
    uut : LinealBuffer GENERIC MAP(
        L => 4,
        W => 2)
    PORT MAP(
        clk => clk,
        reset => reset,
        enable_LBuffer => enable_LBuffer,
        input => input,
        output => output);

    stimulus : PROCESS
    BEGIN

        -- Put initialisation code here
        reset <= '0';
        enable_LBuffer <= '0';
        input <= (OTHERS => '0');
        WAIT FOR clock_period;

        -- Put test bench stimulus code here
        reset <= '1';
        enable_LBuffer <= '1';
        input <= "00";
        WAIT FOR clock_period;
        enable_LBuffer <= '1';
        input <= "11";
        WAIT FOR clock_period;
        enable_LBuffer <= '1';
        input <= "00";
        WAIT FOR clock_period;
        enable_LBuffer <= '0';
        input <= "00";
        WAIT FOR clock_period;
        enable_LBuffer <= '1';
        input <= "01";
        WAIT FOR clock_period;
        enable_LBuffer <= '0';
        input <= "00";
        WAIT FOR clock_period;
        enable_LBuffer <= '1';
        input <= "00";
        WAIT FOR clock_period;
        enable_LBuffer <= '1';
        input <= "11";
        WAIT FOR clock_period;
        enable_LBuffer <= '1';
        input <= "00";
        WAIT FOR clock_period;
        enable_LBuffer <= '0';
        input <= "00";
        WAIT FOR clock_period;
        enable_LBuffer <= '1';
        input <= "01";
        WAIT FOR clock_period;
        enable_LBuffer <= '0';
        input <= "00";
        WAIT FOR clock_period;
        stop_the_clock <= true;
        WAIT;
    END PROCESS;

    clocking : PROCESS
    BEGIN
        WHILE NOT stop_the_clock LOOP
            clk <= '0', '1' AFTER clock_period / 2;
            WAIT FOR clock_period;
        END LOOP;
        WAIT;
    END PROCESS;

END;