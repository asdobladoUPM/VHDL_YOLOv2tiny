LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY MaxPoolLayer IS
    GENERIC (
        L_buffer : INTEGER := 10;
        W_buffer : INTEGER := 6
    );
    PORT (
        clk, reset : IN STD_LOGIC;
        col_odd, row_odd : IN STD_LOGIC;
        input : IN STD_LOGIC_VECTOR((W_buffer-1) DOWNTO 0);
        output : OUT STD_LOGIC_VECTOR((W_buffer-1)  DOWNTO 0)
    );
END ENTITY MaxPoolLayer;

ARCHITECTURE rtl OF MaxPoolLayer IS

    COMPONENT LinealBuffer
        GENERIC (
            L : INTEGER;
            W : INTEGER
        );
        PORT (
            clk : IN STD_LOGIC;
            reset : IN STD_LOGIC;
            enable_LBuffer : IN STD_LOGIC;
            input : IN STD_LOGIC_VECTOR((W - 1) DOWNTO 0);
            output : OUT STD_LOGIC_VECTOR((W - 1) DOWNTO 0)
        );
    END COMPONENT;

    CONSTANT rst_val : STD_LOGIC := '0';

    SIGNAL s_input, max1, max2 : STD_LOGIC_VECTOR((W_buffer-1)  DOWNTO 0);

    SIGNAL d1, d2, LBo : STD_LOGIC_VECTOR((W_buffer-1)  DOWNTO 0);
    SIGNAL s_ENBuffer : STD_LOGIC;

BEGIN

    s_ENBuffer <= NOT(col_odd);
    s_input <= input;

    LB : LinealBuffer
    GENERIC MAP(L => L_buffer, W => W_Buffer)
    PORT MAP(
        clk => clk,
        reset => reset,
        enable_LBuffer => s_ENBuffer,
        input => max1,
        output => LBo);

    sec : PROCESS (clk, reset)
    BEGIN
        IF reset = rst_val THEN
            d1 <= (OTHERS => '0');
            d2 <= (OTHERS => '0');
        ELSIF rising_edge(clk) THEN

            IF (col_odd = '1') THEN
                d1 <= s_input;
            END IF;

            IF (col_odd = '1' NOR row_odd = '1') THEN
                d2 <= max2;
            END IF;
        END IF;
    END PROCESS sec;

    pmax1 : PROCESS (d1, s_input)
    BEGIN
        IF (d1 > s_input) THEN
            max1 <= d1;
        ELSE
            max1 <= s_input;
        END IF;
    END PROCESS pmax1;

    pmax2 : PROCESS (LBo, max1)
    BEGIN
        IF (LBo > max1) THEN
            max2 <= LBo;
        ELSE
            max2 <= max1;
        END IF;
    END PROCESS pmax2;

    output <= d2;
END ARCHITECTURE rtl;