LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

LIBRARY work;
USE work.YOLO_pkg.ALL;

ENTITY L1BNROM IS
  PORT (
    weight : OUT STD_LOGIC_VECTOR(11 DOWNTO 0); -- Instruction bus
    address : IN unsigned(3 DOWNTO 0));
END L1BNROM;

ARCHITECTURE RTL OF L1BNROM IS

  TYPE ROM_mem IS ARRAY (0 TO 15) OF STD_LOGIC_VECTOR(31 DOWNTO 0);

  CONSTANT ROM_content : ROM_mem := (0 => "0001000011011110" & "0001100111111011",
  1 => "1001111000111000" & "0001001011100110",
  2 => "0000010100100011" & "0000100011111111",
  3 => "0000010111010000" & "0000101001111011",
  4 => "1101111010000111" & "0011101111101101",
  5 => "0001111101100100" & "0100110011100110",
  6 => "1101011000010100" & "0100101100100111",
  7 => "0001001000110111" & "0011111000110001",
  8 => "0001001011110010" & "0010101110111000",
  9 => "0000100000010100" & "0001100101111111",
  10 => "0000100101000100" & "0001101111110101",
  11 => "0000100010110100" & "0001101000001100",
  12 => "0000011101100111" & "0000101111011100",
  13 => "1111111101011010" & "0010101111100011",
  14 => "0000110010000001" & "0001101111001001",
  15 => "0000100100110001" & "0000111000100011");

BEGIN
  weight <= ROM_content(to_integer(address));
END RTL;