LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

LIBRARY work;
USE work.YOLO_pkg.ALL;

ENTITY L8_13_BNROM IS
  PORT (
    coefs : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    address : IN unsigned(5 DOWNTO 0));
END L8_13_BNROM;

ARCHITECTURE RTL OF L8_13_BNROM IS

  TYPE ROM_mem IS ARRAY (0 TO 63) OF STD_LOGIC_VECTOR(31 DOWNTO 0);

  CONSTANT ROM_content : ROM_mem :=

  --Contenido bias || scale
  (0=>"0000011110000110"&"0010010100110100",
  1=>"0001101100011011"&"0010000100011110",
  2=>"0000001110100100"&"0001111110000100",
  3=>"0010011001100000"&"0010011101001011",
  4=>"0000000010101110"&"0010010101011010",
  5=>"0010011110110001"&"0001110001110000",
  6=>"0001001011000110"&"0001111011110000",
  7=>"0001000110111101"&"0010000110010100",
  8=>"0000111011011100"&"0010100001010010",
  9=>"0001111000100010"&"0010001100101101",
  10=>"0010001010011111"&"0010001001111000",
  11=>"0010010011100000"&"0010001111101001",
  12=>"0001011000011010"&"0010001011100111",
  13=>"0000011011010011"&"0010001111010000",
  14=>"0000101110010011"&"0010001100101101",
  15=>"0010000111100011"&"0001111011110010",
  16=>"0001000000011011"&"0010000110110011",
  17=>"0001100011110010"&"0010010110101011",
  18=>"0010000010100000"&"0010001110100011",
  19=>"0001100100001100"&"0010001000010101",
  20=>"0000000010110110"&"0001111011110100",
  21=>"0000110101111001"&"0010000101101100",
  22=>"0000101010100011"&"0010011011111101",
  23=>"0001010000000101"&"0010001000101011",
  24=>"0001001000010000"&"0010010001100110",
  25=>"0001011011100100"&"0010010010010011",
  26=>"0000110001101111"&"0010001110111001",
  27=>"1111101110110110"&"0010010001101010",
  28=>"0010000101110000"&"0010010111010100",
  29=>"0000110111101100"&"0010010010000111",
  30=>"0000001010001001"&"0010011000110101",
  31=>"0001001000111100"&"0001110010110110",
  32=>"0000110001000100"&"0010010010101101",
  33=>"0001010001001101"&"0010011001101000",
  34=>"0001010111100111"&"0001111101011111",
  35=>"1111011011001010"&"0001110001000011",
  36=>"0001110101011010"&"0010000111010001",
  37=>"0001010001110100"&"0010011101001110",
  38=>"0001010001000001"&"0010010001000010",
  39=>"0000100101101001"&"0010011000010101",
  40=>"0001100011101011"&"0010000111100101",
  41=>"0000110101010001"&"0010010100011101",
  42=>"0001111000101000"&"0010010001101100",
  43=>"0000110100000000"&"0010001100101000",
  44=>"0010001001011000"&"0010001101011000",
  45=>"0000010111010111"&"0001110101110011",
  46=>"1111010001100000"&"0010000010100101",
  47=>"0001101110110011"&"0010000100100110",
  48=>"0001110000010111"&"0010010110010011",
  49=>"0010100011100000"&"0010001011110110",
  50=>"0000011001001100"&"0010010001101011",
  51=>"0000010011001011"&"0010001100101101",
  52=>"0001101001101110"&"0001110010101010",
  53=>"0001011111111100"&"0010011000100001",
  54=>"0001000111101100"&"0001111010100010",
  55=>"0001010101010001"&"0010000001001001",
  56=>"0001011100000111"&"0010010000111101",
  57=>"0001110001100011"&"0001110000100111",
  58=>"0001110100101011"&"0010000011101010",
  59=>"0000100011100001"&"0010100000110100",
  60=>"0001000110110111"&"0010010101110111",
  61=>"0000001100111101"&"0001101000101010",
  62=>"0010000110100111"&"0010011111111000",
  63=>"0001010010110000"&"0001111101100110");

BEGIN
  coefs <= ROM_content(to_integer(address));
END RTL;