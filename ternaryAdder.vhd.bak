LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY ternaryAdder IS
  GENERIC (N : INTEGER := 4);
  PORT (
    A, B, C : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
    Output : OUT STD_LOGIC_VECTOR(N + 1 DOWNTO 0)
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

  SIGNAL carry : STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
  SIGNAL m_carry : STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
  SIGNAL m_output : STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
BEGIN

  FALINE : FOR I IN 0 TO (N - 1) GENERATE

    UX : FA PORT MAP(
      in_b1 => A(I),
      in_b2 => B(I),
      Cin => C(I),
      S => m_output(I),
      Cout => m_carry(I)
    );
  END GENERATE FALINE;

  VMA_LOWER_BIT : HA
  PORT MAP(
    in_b1 => m_carry(0),
    in_b2 => m_output(1),
    S => Output(1),
    Cout => carry(0)
  );
  VMA_UPPER_BIT : HA
  PORT MAP(
    in_b1 => m_carry(N - 1),
    in_b2 => carry(N - 2),
    S => Output(N),
    Cout => Output(N + 1)
  );

  GEN_VMA_MIDDLE : FOR I IN 0 TO (N - 3) GENERATE

    VMA_MIDDLE : FA PORT MAP(
      in_b1 => carry(I),
      in_b2 => m_carry(I+1),
      Cin => m_output(I + 2),
      S => output(I + 2),
      Cout => carry(I+1)
    );
  END GENERATE GEN_VMA_MIDDLE;


output(0) <= m_output(0);
END rtl;