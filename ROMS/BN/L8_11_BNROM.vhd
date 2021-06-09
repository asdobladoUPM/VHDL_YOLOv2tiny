LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

LIBRARY work;
USE work.YOLO_pkg.ALL;

ENTITY L8_11_BNROM IS
  PORT (
    coefs : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    address : IN unsigned(5 DOWNTO 0));
END L8_11_BNROM;

ARCHITECTURE RTL OF L8_11_BNROM IS

  TYPE ROM_mem IS ARRAY (0 TO 63) OF STD_LOGIC_VECTOR(31 DOWNTO 0);

  CONSTANT ROM_content : ROM_mem :=

  --Contenido bias || scale
  (0=>"0010001000010011"&"0010000000100101",
  1=>"0001001000101101"&"0001111111110011",
  2=>"0000010111111110"&"0010011010100111",
  3=>"1111111101011011"&"0010001010010000",
  4=>"1111111100010000"&"0010001100110100",
  5=>"0001100111110011"&"0010010011001110",
  6=>"1111101101111010"&"0010000110101100",
  7=>"0001110010011001"&"0010010110101010",
  8=>"0001100110100011"&"0010000111000011",
  9=>"0000000010110011"&"0001111000000011",
  10=>"0001011101100000"&"0010100100111101",
  11=>"0000111111101011"&"0010011010010110",
  12=>"0001011111101101"&"0001101101001000",
  13=>"0001101010011110"&"0001111101001111",
  14=>"0010000110101100"&"0010000111100011",
  15=>"0001110000110001"&"0010000001001101",
  16=>"1111111010111100"&"0001111001111011",
  17=>"0001001101001001"&"0010011010011110",
  18=>"0010001101100101"&"0010010101001011",
  19=>"0010011010111111"&"0001100101111111",
  20=>"0001110010001010"&"0010010001110111",
  21=>"0000101110110000"&"0010001111111110",
  22=>"0010110000101001"&"0001110110011010",
  23=>"0000111000110101"&"0010011010000111",
  24=>"0010110011001001"&"0010001100000111",
  25=>"0001101111000110"&"0010100010100001",
  26=>"0001101010000010"&"0010010001010000",
  27=>"0001000100010100"&"0001111111111010",
  28=>"0010010101110101"&"0010010111011010",
  29=>"0001011100111101"&"0010001100010000",
  30=>"0001011110000101"&"0010000010001000",
  31=>"0000110100110011"&"0001111011110001",
  32=>"0010011011011110"&"0001110100110001",
  33=>"0001110111111101"&"0010001111010110",
  34=>"0000110011000001"&"0010010011001010",
  35=>"0000010001001010"&"0010000000000100",
  36=>"0010011110111100"&"0010010101001000",
  37=>"0001111110101010"&"0010011001011000",
  38=>"0001101011100010"&"0010000111110110",
  39=>"0000001101010101"&"0010000110111010",
  40=>"0001001111010111"&"0010001110000100",
  41=>"0001101000110100"&"0010010001011101",
  42=>"0001011111001101"&"0010000100111000",
  43=>"0000000110001100"&"0001101000101000",
  44=>"0000111010000011"&"0001110100101101",
  45=>"0001011001101110"&"0010001011000110",
  46=>"1111101011011010"&"0001011000100000",
  47=>"0010001111100000"&"0010010100100110",
  48=>"0000100101000101"&"0010000110101110",
  49=>"0000111100000011"&"0010001111111101",
  50=>"0001100100111000"&"0010010010001101",
  51=>"1111101011001011"&"0001100100001011",
  52=>"0010111000111110"&"0010001000111011",
  53=>"0000101101110111"&"0010011011011101",
  54=>"0010011100101100"&"0010001111011100",
  55=>"0001110101111011"&"0010001111000110",
  56=>"0010100010011101"&"0010000110101010",
  57=>"0011010000000110"&"0001111110111110",
  58=>"0000001100101100"&"0001100010010011",
  59=>"1111101001111011"&"0001111100111011",
  60=>"0000110101001000"&"0010001111101110",
  61=>"0000110010101000"&"0010001101111111",
  62=>"0001010010100010"&"0010000111001100",
  63=>"0000110111010001"&"0001101001000010");

BEGIN
  coefs <= ROM_content(to_integer(address));
END RTL;