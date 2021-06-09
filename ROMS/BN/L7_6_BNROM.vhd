LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

LIBRARY work;
USE work.YOLO_pkg.ALL;

ENTITY L7_6_BNROM IS
  PORT (
    coefs : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    address : IN unsigned(6 DOWNTO 0));
END L7_6_BNROM;

ARCHITECTURE RTL OF L7_6_BNROM IS

  TYPE ROM_mem IS ARRAY (0 TO 127) OF STD_LOGIC_VECTOR(31 DOWNTO 0);

  CONSTANT ROM_content : ROM_mem :=

  --Contenido bias || scale
  (0=>"1111111011010110"&"0010001010111011",
  1=>"1110011100001111"&"0010010011000110",
  2=>"1110111011101000"&"0010100100001010",
  3=>"1101110010000100"&"0010110100000110",
  4=>"1110110101110111"&"0010111101111000",
  5=>"1110011101001111"&"0010000101011101",
  6=>"1111001000000111"&"0010010110001110",
  7=>"0000000011101000"&"0010100000010011",
  8=>"1110111000100110"&"0010010001000111",
  9=>"1110010010110011"&"0010110010110111",
  10=>"1111000001001010"&"0010100010111110",
  11=>"1111100011100110"&"0010011011000111",
  12=>"1111001101000110"&"0010010100000111",
  13=>"1111001100010000"&"0010001110000100",
  14=>"1110111110011001"&"0010001101001101",
  15=>"0000001000001010"&"0010010010011101",
  16=>"1111001111100101"&"0010111100011000",
  17=>"1111000001010100"&"0010011100101100",
  18=>"1111010111110010"&"0010000100010001",
  19=>"1111100111000100"&"0010001001101111",
  20=>"1110101001000101"&"0010111110101101",
  21=>"1111110001001110"&"0010010000001101",
  22=>"1111100101011000"&"0010101100001110",
  23=>"1110010100001000"&"0010000101101001",
  24=>"1110101101000111"&"0010010101111000",
  25=>"1111110101110101"&"0010011001110101",
  26=>"1110100000010111"&"0010010001100111",
  27=>"1111101101111101"&"0010001101110101",
  28=>"1111010100110010"&"0010000101100010",
  29=>"1101110110111011"&"0010011010100111",
  30=>"1111010100010110"&"0010011100011100",
  31=>"1111100000101001"&"0010000000101011",
  32=>"1111001010101011"&"0010000011011100",
  33=>"1111001100000100"&"0010011111010110",
  34=>"1111010110100101"&"0010100111101110",
  35=>"1110111111011000"&"0010100010011111",
  36=>"1111000000101100"&"0010000100110101",
  37=>"1110111101110000"&"0010100111100000",
  38=>"1111000100011101"&"0010100011101101",
  39=>"1110101000001011"&"0010010111101110",
  40=>"1110100011011011"&"0010100111001000",
  41=>"1111110100111010"&"0001111011011000",
  42=>"1110101111100001"&"0010001110100000",
  43=>"1101111000000011"&"0010100000111110",
  44=>"1111100010010100"&"0010010101101011",
  45=>"1111001100010010"&"0010001100001111",
  46=>"1111001010000011"&"0010010101011001",
  47=>"1110011100011101"&"0010100011110110",
  48=>"1110010010001100"&"0010011000010010",
  49=>"1111101110111110"&"0010101010000011",
  50=>"1111100000100111"&"0010000101110110",
  51=>"1111010010111001"&"0001110111011110",
  52=>"1101111100101010"&"0010010010011010",
  53=>"1111010111111101"&"0010001111101010",
  54=>"1111011000001011"&"0010010111011001",
  55=>"1111010000110100"&"0010011000011011",
  56=>"1110101110110111"&"0010000110011011",
  57=>"1111010111011011"&"0010101011010111",
  58=>"0000000111000001"&"0010001101111010",
  59=>"1110110111111111"&"0010011001010101",
  60=>"1110111001001100"&"0010001000101101",
  61=>"1111100001010110"&"0001100110111110",
  62=>"1111100001101101"&"0010100101011110",
  63=>"1111000111101111"&"0010011001011001",
  64=>"1110100101010001"&"0010001000010000",
  65=>"1110000011011110"&"0010101000110100",
  66=>"1111100010101100"&"0010011010110110",
  67=>"1111011011000111"&"0010100011010010",
  68=>"1111001011110101"&"0010011011000101",
  69=>"1111100011001001"&"0010100101010111",
  70=>"1110110010111000"&"0010001000011001",
  71=>"1111101000001100"&"0010010001011000",
  72=>"1111011010010100"&"0010011001111011",
  73=>"1111011110100101"&"0010001110010011",
  74=>"1111100011000001"&"0010001100000110",
  75=>"1110000001000101"&"0010011101101111",
  76=>"1111000011111100"&"0010010111010011",
  77=>"1110001100001010"&"0010011100011110",
  78=>"1110110111100011"&"0010010110110101",
  79=>"1110110011001001"&"0010001011111101",
  80=>"1110101110111011"&"0010010101110100",
  81=>"1110101110101100"&"0010010101010000",
  82=>"1110100010110001"&"0010011111101111",
  83=>"1111101010110001"&"0010010110111010",
  84=>"1110011010100110"&"0010010010011000",
  85=>"1111101010100101"&"0010000011000101",
  86=>"0000000000010101"&"0010100010101001",
  87=>"1111010100101011"&"0010001101100110",
  88=>"1110101100000001"&"0010100011101010",
  89=>"1110111101100101"&"0010000101111111",
  90=>"1110110011110101"&"0010011101101000",
  91=>"1110110001001001"&"0010011001101011",
  92=>"1110000111101010"&"0010111111110101",
  93=>"1101101110011101"&"0010001111101000",
  94=>"1111100111001001"&"0010011010110011",
  95=>"1110111100011010"&"0010010011000010",
  96=>"1111010001011010"&"0010001010000001",
  97=>"1110100011111110"&"0001111011110100",
  98=>"1110110101100000"&"0010011111111111",
  99=>"1110111001110101"&"0010011110111111",
  100=>"1111010101011101"&"0010010010110100",
  101=>"1110011101000010"&"0010100100011110",
  102=>"1111010100010110"&"0010010101111111",
  103=>"1110011011101011"&"0010010110101101",
  104=>"1110100001001111"&"0010000111110000",
  105=>"1110111010110110"&"0010001111101101",
  106=>"1110010110101010"&"0010011010001001",
  107=>"1110110111110101"&"0010010110011000",
  108=>"1101100101100110"&"0010011011110000",
  109=>"1111100100010100"&"0010010111100100",
  110=>"1111100011000111"&"0010001010101100",
  111=>"1110111111111010"&"0010110110100010",
  112=>"1110110110001111"&"0010011010111101",
  113=>"1110101111000010"&"0010010100111000",
  114=>"1110011011010010"&"0010100000011110",
  115=>"1111000001111110"&"0010100001101001",
  116=>"1111011000111000"&"0010100001111000",
  117=>"1111000000001111"&"0010010111101101",
  118=>"0000011011011101"&"0010111011001000",
  119=>"1111000011100011"&"0010001101100001",
  120=>"1110011010011001"&"0010010000011010",
  121=>"1111000111010110"&"0010111001000110",
  122=>"1101110010101111"&"0010100110010101",
  123=>"1101100010000100"&"0010010111001011",
  124=>"1110101011100101"&"0010010001110101",
  125=>"1111000011010011"&"0010011001100010",
  126=>"1111000111100000"&"0010001101010001",
  127=>"1110100101110001"&"0010011100010101");

BEGIN
  coefs <= ROM_content(to_integer(address));
END RTL;