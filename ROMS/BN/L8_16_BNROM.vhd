LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

LIBRARY work;
USE work.YOLO_pkg.ALL;

ENTITY L8_16_BNROM IS
  PORT (
    coefs : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    address : IN unsigned(5 DOWNTO 0));
END L8_16_BNROM;

ARCHITECTURE RTL OF L8_16_BNROM IS

  TYPE ROM_mem IS ARRAY (0 TO 63) OF STD_LOGIC_VECTOR(31 DOWNTO 0);

  CONSTANT ROM_content : ROM_mem :=

  --Contenido bias || scale
  (0 => "0000000101001011" & "0010001100101000",
  1 => "0001111010010101" & "0010001011111000",
  2 => "0001100100110010" & "0010000010011110",
  3 => "0000011111001010" & "0010001101101100",
  4 => "0000100111101001" & "0001111000011101",
  5 => "0010010111010011" & "0010001100010100",
  6 => "1111001110110111" & "0010001011011111",
  7 => "0001110011111101" & "0001110010110010",
  8 => "1111101011100111" & "0010000110000011",
  9 => "1111110110111001" & "0010000001000101",
  10 => "0001000010001100" & "0010010000110101",
  11 => "0001000001001001" & "0010000111000001",
  12 => "0000111011111111" & "0010000000100110",
  13 => "1111111101100000" & "0010010110001001",
  14 => "0001110100010110" & "0010011001110110",
  15 => "0000110010011011" & "0001111001110100",
  16 => "0000101001100110" & "0001010101110000",
  17 => "0001001011011000" & "0010011100000010",
  18 => "0000011010110111" & "0010011010100000",
  19 => "0001011101011000" & "0010000111011111",
  20 => "0001011010111010" & "0010000111110110",
  21 => "0001000000110011" & "0010010101010000",
  22 => "0001011100111110" & "0010000110000111",
  23 => "0001011010111101" & "0010001101111010",
  24 => "0010001110001001" & "0001110111100111",
  25 => "0000010000001111" & "0010010110100010",
  26 => "0001010010100110" & "0010001000000010",
  27 => "0010000000100110" & "0010010101000101",
  28 => "0000000100000000" & "0001110101001111",
  29 => "0000101010111001" & "0010010001011111",
  30 => "0001011100101100" & "0001111111101101",
  31 => "0001011111100010" & "0010011011000010",
  32 => "0010110110101010" & "0010001011110111",
  33 => "0001010100010101" & "0010001010101001",
  34 => "0011011001011010" & "0010001111111000",
  35 => "0010011000000111" & "0001111011011110",
  36 => "1110101001100001" & "0001110000111110",
  37 => "1101111000010111" & "0001111000010010",
  38 => "0000111111001100" & "0010010111010110",
  39 => "0001000111100000" & "0010010001000001",
  40 => "0001010111111111" & "0010000001001011",
  41 => "0001101111001101" & "0001111011111001",
  42 => "0010010111001011" & "0010010101000001",
  43 => "0000110110100010" & "0010100100001011",
  44 => "0001101110110010" & "0010000100010101",
  45 => "0001110101111111" & "0010000100110000",
  46 => "0000001111000000" & "0010010000000110",
  47 => "0010010111000001" & "0010001011010110",
  48 => "0000110000111000" & "0001111110101001",
  49 => "0010100000111110" & "0010000101110001",
  50 => "0000101011010101" & "0010010011101000",
  51 => "0010011011101101" & "0010000011000010",
  52 => "0001110100001101" & "0001110111011011",
  53 => "0001111110110110" & "0010001101110101",
  54 => "0010010010011110" & "0010010010110001",
  55 => "0000101110100110" & "0010000010111100",
  56 => "0000111111010000" & "0010001001100100",
  57 => "0000010100101100" & "0001110000100100",
  58 => "0001001011000010" & "0010011001110110",
  59 => "0001110010001001" & "0010001100101100",
  60 => "0001010100011111" & "0010000101011110",
  61 => "0010110011010001" & "0010010010000101",
  62 => "0001000110100000" & "0010010111100010",
  63 => "0001000011011000" & "0001111111011101");

BEGIN
  coefs <= ROM_content(to_integer(address));
END RTL;