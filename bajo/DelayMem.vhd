--Delay implemented with memories.

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE IEEE.MATH_REAL.ALL;

LIBRARY work;
USE work.Components.ALL;
USE work.YOLO_pkg.ALL;

ENTITY DelayMem IS
   GENERIC (Layer : INTEGER := 1);
   PORT (
      reset : IN STD_LOGIC;
      clk : IN STD_LOGIC;
      enable : IN STD_LOGIC;
      Din : IN STD_LOGIC_VECTOR(bufferwidth(layer) - 1 DOWNTO 0);
      Dout : OUT STD_LOGIC_VECTOR(bufferwidth(layer) - 1 DOWNTO 0));
END DelayMem;
ARCHITECTURE arch OF DelayMem IS

   CONSTANT WL : INTEGER := bufferwidth(layer); -- Word Length
   CONSTANT BL : INTEGER := channels(layer); -- Buffer Length
BEGIN

   NoDelay : IF BL = 0 GENERATE
      Dout <= Din;
   END GENERATE;

   GenMem : IF BL > 0 GENERATE

      TYPE memory IS ARRAY (nextPow2(BL) - 1 DOWNTO 0) OF STD_LOGIC_VECTOR(WL - 1 DOWNTO 0);
      SIGNAL mem : memory;
      SIGNAL rdData : STD_LOGIC_VECTOR(WL - 1 DOWNTO 0);
      SIGNAL counter : unsigned(bits(BL - 1) - 1 DOWNTO 0);

   BEGIN

      Control : PROCESS (reset, clk)
      BEGIN
         IF reset = '0' THEN
            counter <= (OTHERS => '0');
         ELSIF rising_edge(clk) THEN
            IF enable = '1' THEN
               IF counter = to_unsigned(BL - 1 - 1, bits(BL - 1)) THEN
                  counter <= (OTHERS => '0');
               ELSE
                  counter <= counter + 1;
               END IF;
            END IF;
         END IF;
      END PROCESS;
      RW : PROCESS (clk)
      BEGIN
         IF rising_edge(clk) THEN
            IF enable = '1' THEN
               mem(to_integer(counter)) <= Din;
            END IF;
            Dout <= rdData;
         END IF;
      END PROCESS;

      rdData <= mem(to_integer(counter));

   END GENERATE;

END arch;