LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

LIBRARY work;
USE work.YOLO_pkg.ALL;

ENTITY L4BNROM IS
    PORT (
        weight : OUT STD_LOGIC_VECTOR(11 DOWNTO 0); -- Instruction bus
        address : IN unsigned(6 DOWNTO 0));
END L4BNROM;

ARCHITECTURE RTL OF L4BNROM IS

    TYPE ROM_mem IS ARRAY (0 TO 127) OF STD_LOGIC_VECTOR(31 DOWNTO 0);

    CONSTANT ROM_content : ROM_mem :=
    (0=>"0000101001101111"&"0010010111010110",
    1=>"0011110000100100"&"0001101101000100",
    2=>"0011000111111110"&"0001110101001010",
    3=>"0000011111100000"&"0010111001011001",
    4=>"1111110110111000"&"0010101000101000",
    5=>"0000110111100101"&"0010101000001100",
    6=>"0001000111010110"&"0010101010101101",
    7=>"0001100110011100"&"0010100000000010",
    8=>"0000110011001110"&"0010101010001110",
    9=>"1111011001110101"&"0011000100000010",
    10=>"0000010000101111"&"0010101000011011",
    11=>"0000000011011011"&"0011000111001101",
    12=>"1101100010111010"&"0010000011101011",
    13=>"0000000010100101"&"0011011101101011",
    14=>"1111111010111011"&"0011000011000010",
    15=>"0011100101111110"&"0010010101000010",
    16=>"0001010111110101"&"0001110010101101",
    17=>"0000011001010111"&"0001110011101110",
    18=>"0000100010000001"&"0010011001001111",
    19=>"0000110010101001"&"0010100010010010",
    20=>"0010101110001101"&"0001011110100000",
    21=>"1011110010100001"&"0011000101110101",
    22=>"1000111111110001"&"0100001000011110",
    23=>"0000101101101011"&"0011000101110110",
    24=>"1111101000001011"&"0010101001110010",
    25=>"1111001110000100"&"0011010100111100",
    26=>"0000100101010010"&"0010111011111000",
    27=>"1111011100000001"&"0011001101010010",
    28=>"0000100010101011"&"0001110101101101",
    29=>"1111101111111010"&"0010011111111010",
    30=>"0001001111001001"&"0011001001101001",
    31=>"0000101110111101"&"0010000110000011",
    32=>"1111100011100010"&"0010010010010010",
    33=>"1111101010001010"&"0010101011010011",
    34=>"0000001011000111"&"0011000111111010",
    35=>"1111001000011101"&"0010001001100000",
    36=>"1110010001010011"&"0011000010001110",
    37=>"0010100110000111"&"0010100100100011",
    38=>"0001000000001000"&"0010111101100011",
    39=>"0010100101101100"&"0001111100000101",
    40=>"0000000100000010"&"0010101001000110",
    41=>"0000101111100101"&"0010010111010010",
    42=>"0000010011100000"&"0010101011111111",
    43=>"0000001000011111"&"0010011000101110",
    44=>"0001111100011000"&"0011001000111000",
    45=>"1111110000011001"&"0010000101011011",
    46=>"1110000111001111"&"0010011011000111",
    47=>"0010011100101110"&"0001111111101101",
    48=>"1111101111111010"&"0010110100101010",
    49=>"0010011110100100"&"0010110000010001",
    50=>"1111111000110011"&"0010101011101011",
    51=>"0000110010000110"&"0011011001010000",
    52=>"1111110001011001"&"0010100011011010",
    53=>"1101110110010100"&"0001011000111101",
    54=>"1111010110101111"&"0001101011010011",
    55=>"0011001101010101"&"0010111000011100",
    56=>"1111111101010010"&"0010011011001110",
    57=>"0000010100110011"&"0010101100001000",
    58=>"1111100000100110"&"0011010001001010",
    59=>"1101111010000110"&"0011001010101000",
    60=>"1011001101110111"&"0010011111001000",
    61=>"1101110100010001"&"0011110001101111",
    62=>"1111010001100011"&"0011010101101011",
    63=>"1111111001001100"&"0010010010100111",
    64=>"0000010100011101"&"0001110011001110",
    65=>"1111000111111010"&"0010111000010011",
    66=>"1111110000100111"&"0010011101001110",
    67=>"1101010011000101"&"0011011011101011",
    68=>"1111011110111101"&"0010100110110110",
    69=>"0000000011101000"&"0011000011100101",
    70=>"1100011001011101"&"0011010000110001",
    71=>"0000101011101110"&"0010001100110001",
    72=>"0000110011110101"&"0001101110011101",
    73=>"0000110110110011"&"0001111001111110",
    74=>"1111110101100000"&"0010001111010010",
    75=>"1011110010010110"&"0001011101101111",
    76=>"0000101011101011"&"0010010011101000",
    77=>"1111110101000111"&"0001101111011100",
    78=>"1110111000111000"&"0010010011001000",
    79=>"0001101111010111"&"0001110000011011",
    80=>"1111110011101011"&"0010011111100001",
    81=>"0001001010111110"&"0010101001010001",
    82=>"1110001001001001"&"0001100110001110",
    83=>"1111011010010010"&"0010100001101111",
    84=>"0000100000010010"&"0011000100010111",
    85=>"0011100110110001"&"0010111110000110",
    86=>"1111000011110101"&"0011010111010000",
    87=>"1110010101110001"&"0100000011100101",
    88=>"0000100011010111"&"0010101111110100",
    89=>"1111010010001110"&"0010110100001101",
    90=>"1111001101000001"&"0011100010011100",
    91=>"1111011110011011"&"0010100011010101",
    92=>"0000000100110000"&"0010010010101011",
    93=>"0010101111111111"&"0010000110101011",
    94=>"0001011001100011"&"0010110001111000",
    95=>"1110100110101011"&"0010101101001011",
    96=>"1111011010110100"&"0010110001000100",
    97=>"1110001001000101"&"0011001000111011",
    98=>"0010100110000010"&"0001111001000011",
    99=>"0001011001001101"&"0001011111100100",
    100=>"0000011100110111"&"0010101111001011",
    101=>"1011000001010110"&"0010010001001001",
    102=>"1111001110111111"&"0010101101010111",
    103=>"1111001100000010"&"0010101000010000",
    104=>"0001110101111000"&"0010010111000001",
    105=>"0010100111110011"&"0010110011011000",
    106=>"0000111010101101"&"0010101100101001",
    107=>"0000100100100100"&"0011000000011000",
    108=>"0000111001010100"&"0010010001011001",
    109=>"1110010001000000"&"0011010111000011",
    110=>"1111100001110010"&"0010011010111111",
    111=>"0000101000010101"&"0010110111011001",
    112=>"0001010010011101"&"0001110100110101",
    113=>"1111000011010101"&"0010110101011110",
    114=>"0000100101010110"&"0001110110101111",
    115=>"0001000011111101"&"0001011011111001",
    116=>"1111000101101100"&"0010011011100010",
    117=>"1001010110101001"&"0010110101011010",
    118=>"0000000111110111"&"0010011101110000",
    119=>"1111111101100000"&"0010101110011110",
    120=>"0000001111110000"&"0010000010001000",
    121=>"0000111110101111"&"0010100110110101",
    122=>"0001110110100110"&"0010001110010100",
    123=>"0001011001101010"&"0001011011000000",
    124=>"1111110001111010"&"0011001101101010",
    125=>"0001000001001000"&"0010011010011101",
    126=>"0010000010101101"&"0010110011111101",
    127=>"0010100111111000"&"0010011011101000");
    
BEGIN
    weight <= ROM_content(to_integer(address));
END RTL;