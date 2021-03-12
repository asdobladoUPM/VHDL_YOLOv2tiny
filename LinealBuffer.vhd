LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY LinealBuffer IS
    GENERIC (
        L : INTEGER:=10;
        W : INTEGER:=10
    );
    PORT (
        clk : IN STD_LOGIC;
        enable_LBuffer : IN STD_LOGIC;
        input : IN STD_LOGIC_VECTOR((W - 1) DOWNTO 0);

        output : OUT STD_LOGIC_VECTOR((W - 1) DOWNTO 0)
    );
END ENTITY LinealBuffer;

ARCHITECTURE rtl OF LinealBuffer IS

    TYPE mem_t IS ARRAY(0 TO (L - 1)) OF STD_LOGIC_VECTOR((W - 1) DOWNTO 0);

    SIGNAL content_LB : mem_t;

BEGIN

    moving : PROCESS (clk)
    BEGIN
        IF rising_edge(clk) THEN
            IF (enable_LBuffer = '1') THEN

                FOR I IN 0 TO (L - 2) LOOP
                    content_LB((L-1)-I) <= content_LB((L-1)-(I+1));
                END LOOP;

                content_LB(0) <= input;
            END IF;

            output <= content_LB(L - 1);

        END IF;

    END PROCESS moving;
END ARCHITECTURE rtl;