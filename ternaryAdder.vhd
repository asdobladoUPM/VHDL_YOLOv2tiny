LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY ternaryAdder IS
  GENERIC (
    BITS : INTEGER:=4
  );
  PORT (
    A, B, C : IN STD_LOGIC_VECTOR(bits - 1 DOWNTO 0);
    Output : OUT STD_LOGIC_VECTOR(bits + 1 DOWNTO 0)
  );
END ternaryAdder;

ARCHITECTURE rtl OF ternaryAdder IS

  COMPONENT FA
    PORT (
      in_b1 : IN STD_LOGIC;
      in_b2 : IN STD_LOGIC;
      Cin : IN STD_LOGIC;
      S : OUT STD_LOGIC;
      Cout : OUT STD_LOGIC);
  END COMPONENT;

  COMPONENT HA
    PORT (
      in_b1 : IN STD_LOGIC;
      in_b2 : IN STD_LOGIC;
      S : OUT STD_LOGIC;
      Cout : OUT STD_LOGIC
    );
  END COMPONENT;

  SIGNAL carry : STD_LOGIC_VECTOR(BITS - 1 DOWNTO 0);
  SIGNAL m_carry : STD_LOGIC_VECTOR(BITS - 1 DOWNTO 0);
  SIGNAL m_output : STD_LOGIC_VECTOR(BITS - 1 DOWNTO 0);
BEGIN

  FAL : FOR I IN 0 TO (BITS - 1) GENERATE

    UX: FA PORT MAP(
      in_b1 => A(I),
      in_b2 => B(I),
      Cin => C(I),
      S => m_output(I),
      Cout => m_carry(I)
    );
  END GENERATE FAL;

  VMA : FOR I IN 1 TO BITS GENERATE
    LOWER_BIT : IF (I = 1) GENERATE
      UT: HA PORT MAP(
        in_b1 => m_carry(I - 1),
        in_b2 => m_output(I),
        S => Output(I),
        Cout => carry(I - 1)
      );
    END GENERATE LOWER_BIT;

    MIDDLE_BITS : IF ((I > 1) AND (I < BITS)) GENERATE
     UM: FA PORT MAP(
        in_b1 => carry(I - 2),
        in_b2 => m_carry(I - 1),
        Cin => m_output(I),
        S => output(I),
        Cout => m_carry(I - 1)
      );
    END GENERATE MIDDLE_BITS;

    UPPER_BIT : IF (I = BITS) GENERATE
    UT:  HA PORT MAP(
        in_b1 => m_carry(I - 1),
        in_b2 => carry(I - 2),
        S => Output(I),
        Cout => Output(I + 1)
      );
    END GENERATE UPPER_BIT;

  END GENERATE VMA;

  output(0) <= m_output(0);
END rtl;