LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

LIBRARY work;
USE work.YOLO_pkg.ALL;

ENTITY L5BNROM IS
    PORT (
        weight : OUT STD_LOGIC_VECTOR(11 DOWNTO 0); -- Instruction bus
        address : IN unsigned(8 DOWNTO 0));
END L5BNROM;

ARCHITECTURE RTL OF L5BNROM IS

    TYPE ROM_mem IS ARRAY (0 TO 511) OF STD_LOGIC_VECTOR(31 DOWNTO 0);

    CONSTANT ROM_content : ROM_mem :=
    (0=>"1110000110101010"&"0011100001100101",
    1=>"1111000100100111"&"0010101101000110",
    2=>"1111101000111100"&"0010010110101111",
    3=>"1111011111100011"&"0011110000100001",
    4=>"1110110011110100"&"0011111100111110",
    5=>"1101010101100000"&"0100000011111010",
    6=>"1111101010110111"&"0001110100010010",
    7=>"1111100100000101"&"0010111010110100",
    8=>"1111100101110101"&"0011000001010010",
    9=>"1110110111010111"&"0011110011000101",
    10=>"1111100011110110"&"0010110100000111",
    11=>"1110110101001110"&"0011110010111101",
    12=>"1111010000110001"&"0010100111011010",
    13=>"1110011110011100"&"0011011000001101",
    14=>"1110100011111000"&"0100010000110011",
    15=>"1111111101011110"&"0010001010100011",
    16=>"1110101000011011"&"0100000000000000",
    17=>"1111011001111000"&"0010111011001001",
    18=>"1111101100000000"&"0010101011100110",
    19=>"1111001111100111"&"0010110110100111",
    20=>"1111111110100110"&"0011000101000010",
    21=>"1111100111001011"&"0010010111110111",
    22=>"1110110000010101"&"0011000111110011",
    23=>"1111000011100110"&"0011010011000100",
    24=>"1111001111001001"&"0011111001100010",
    25=>"1110101110011010"&"0011100101001001",
    26=>"1111000001100000"&"0010101111110101",
    27=>"1110100000100101"&"0100001100101000",
    28=>"0000000110101000"&"0010000110000111",
    29=>"1111000111101111"&"0100010000000001",
    30=>"1111010110000111"&"0011100101000001",
    31=>"1110100001011101"&"0011111101001000",
    32=>"1101111001001100"&"0011111111001101",
    33=>"1110010101101001"&"0100101011011001",
    34=>"1111100101110111"&"0011010110000011",
    35=>"1110000000000100"&"0100101100101011",
    36=>"1111000110100011"&"0011010011100101",
    37=>"1110100111011010"&"0011101010011111",
    38=>"1110011100000111"&"0011011000001101",
    39=>"1110001110011011"&"0011100111010110",
    40=>"1110011001011011"&"0100010100001000",
    41=>"1110100100100110"&"0010001100100010",
    42=>"0000001101100100"&"0010100100110010",
    43=>"1110100001110110"&"0011111000011001",
    44=>"1111100100000010"&"0010111110000111",
    45=>"1111101111000101"&"0011011011001001",
    46=>"1110101100001110"&"0011001101011000",
    47=>"1110011111001000"&"0011100111010100",
    48=>"1110111101010001"&"0011111001011001",
    49=>"1111100010101111"&"0001110101110010",
    50=>"1111000001110010"&"0010110110110110",
    51=>"1110010110011010"&"0011101010100000",
    52=>"1111010110101001"&"0010100100111000",
    53=>"1111010000010100"&"0010111010000100",
    54=>"1101111011100001"&"0011011001101010",
    55=>"1110010011010000"&"0100010000000011",
    56=>"1111011010100010"&"0011000111100110",
    57=>"1110110111101010"&"0011011011010100",
    58=>"0000000011000000"&"0001011011100010",
    59=>"1110011110001101"&"0011010001100101",
    60=>"1111100110010001"&"0010011110010000",
    61=>"1110010101001110"&"0010111110100100",
    62=>"1111000001001000"&"0011111010010101",
    63=>"0000000001101001"&"0010001001000111",
    64=>"1101000110100101"&"0100100001111001",
    65=>"1111010110000110"&"0010111000011010",
    66=>"1111001110010100"&"0011010011011010",
    67=>"1110111000111110"&"0011111011110101",
    68=>"1111001101010101"&"0011001100111101",
    69=>"1111010100011100"&"0010011110101110",
    70=>"1110100001111000"&"0011000110011011",
    71=>"1110000100101001"&"0010110001111111",
    72=>"1111000001110100"&"0011011100010111",
    73=>"0000001110110010"&"0010010111011000",
    74=>"1111000111100110"&"0011010011000100",
    75=>"1101101010101011"&"0100110110100101",
    76=>"1111101001111101"&"0011001111001010",
    77=>"1111000111110011"&"0011010101110110",
    78=>"1110111001100000"&"0011001011101110",
    79=>"1111011101101101"&"0010100101101010",
    80=>"1111010001000010"&"0010100001010001",
    81=>"1111000011011111"&"0011111010100100",
    82=>"1101100011001101"&"0011110100011010",
    83=>"1110100000010100"&"0011110000000111",
    84=>"1111101101011100"&"0001110100001011",
    85=>"1110001011000011"&"0011001010001110",
    86=>"1101010010100011"&"0100001101001010",
    87=>"1111101000011101"&"0010011000110100",
    88=>"1111000110110100"&"0011100001000111",
    89=>"1111010110011100"&"0010100000011111",
    90=>"1111010111010101"&"0011101111111000",
    91=>"1110101010011010"&"0011011101000110",
    92=>"1111111100110100"&"0010000001010100",
    93=>"1111001001111000"&"0010010011110111",
    94=>"1110100111010010"&"0100100110011011",
    95=>"1110010101011110"&"0100000110100100",
    96=>"1111110101100000"&"0011000000110010",
    97=>"1111001010100100"&"0010110000001001",
    98=>"1110010010111001"&"0011110001000011",
    99=>"1111001011000100"&"0010000100011101",
    100=>"1110010110101111"&"0011101001010011",
    101=>"1110010000100100"&"0100000010111010",
    102=>"1110111000000001"&"0011000111000000",
    103=>"1111000111011011"&"0011001111010110",
    104=>"1111010100101010"&"0010101001111100",
    105=>"0000000000101110"&"0010111010101101",
    106=>"1111010010010010"&"0010110000100111",
    107=>"1110101101110110"&"0010100100011001",
    108=>"1110100111100000"&"0100001001110111",
    109=>"1110110010011010"&"0011010011111001",
    110=>"1111101010101100"&"0010011101111111",
    111=>"1110110000110000"&"0010111001010000",
    112=>"1111001010100101"&"0010111010111000",
    113=>"1110100101011110"&"0011011101110100",
    114=>"1111100101100100"&"0010101101111111",
    115=>"1110000101100000"&"0100000011011110",
    116=>"1111001011101110"&"0010100101011101",
    117=>"1111001101010001"&"0011001110010010",
    118=>"1111100100101000"&"0010011100010011",
    119=>"1111000110111001"&"0010000110001001",
    120=>"1111000101101100"&"0011001010101100",
    121=>"1110010011000111"&"0100100111011110",
    122=>"1101111100100110"&"0011101000110110",
    123=>"1111100011110111"&"0010001111110110",
    124=>"1110111001101011"&"0011000011101010",
    125=>"1101100100111010"&"0011010001111101",
    126=>"1110010100001110"&"0011011000000100",
    127=>"1111010010011110"&"0001111101010110",
    128=>"1111101010111001"&"0010001100000100",
    129=>"1101110110001011"&"0100001111000110",
    130=>"1110111000111011"&"0011001011011011",
    131=>"1110111111011001"&"0011001110111100",
    132=>"1111010001100010"&"0011001011001100",
    133=>"1101101010111110"&"0011110101101110",
    134=>"1110101101011101"&"0100111011110101",
    135=>"1111001101000011"&"0010100010100111",
    136=>"1111010001001111"&"0010111100001110",
    137=>"1111001100000111"&"0010111011111100",
    138=>"1111100011011101"&"0010010000100011",
    139=>"1110010011101010"&"0011100010100101",
    140=>"1110101000100110"&"0100000110000011",
    141=>"1111101100001011"&"0010111011011011",
    142=>"1101111110111010"&"0100110001001111",
    143=>"1110100100001111"&"0011000010001111",
    144=>"1111111110111000"&"0001101111110100",
    145=>"1111101100011100"&"0010000101101100",
    146=>"1110010110000000"&"0011000011111011",
    147=>"1110000001000001"&"0100001011001001",
    148=>"1110100101010101"&"0011001000100001",
    149=>"1110101110010101"&"0010111011000000",
    150=>"1111010001000011"&"0010000101000001",
    151=>"1110101011100011"&"0011000110111010",
    152=>"1101010110000010"&"0011011111001011",
    153=>"1101111011001111"&"0101001100100000",
    154=>"1111000011111111"&"0011010011111110",
    155=>"1111101011100110"&"0010101110110110",
    156=>"1110100011010110"&"0011110100110000",
    157=>"1101011100000001"&"0100010000001101",
    158=>"1110110000000001"&"0011110001011101",
    159=>"1111010101101001"&"0010110100101000",
    160=>"1110000110110111"&"0011101000100110",
    161=>"1110110111111111"&"0100000001000001",
    162=>"1111111110111011"&"0010000001110100",
    163=>"1110111111110100"&"0011010000111011",
    164=>"1110100010011110"&"0011010111100111",
    165=>"1110010100100111"&"0100010000101001",
    166=>"0000000010010100"&"0010000110010011",
    167=>"1111011100010000"&"0010101101100110",
    168=>"1011001101110111"&"0011101101000100",
    169=>"1111001101100011"&"0001110101110101",
    170=>"1110100000001000"&"0010011100100010",
    171=>"0000000100101011"&"0010010111110001",
    172=>"1111001111010110"&"0011001011111001",
    173=>"1110011101100100"&"0011101110010111",
    174=>"1110110110010101"&"0011111001001100",
    175=>"1110011010100110"&"0011011111111000",
    176=>"1110100110101100"&"0010001011011111",
    177=>"1111000110101110"&"0011101011011111",
    178=>"0000111100101111"&"0010001010100011",
    179=>"1110101101001110"&"0011010110011011",
    180=>"1101110001000011"&"0100000011111101",
    181=>"1111000000101011"&"0011000111100110",
    182=>"1111011111111110"&"0001110111111100",
    183=>"1110101101011101"&"0011100100110010",
    184=>"1101001100011000"&"0101010010000001",
    185=>"1111100001100000"&"0010011000010010",
    186=>"1101111010001110"&"0011001111000000",
    187=>"1110010110010100"&"0011101101100011",
    188=>"1111010111000110"&"0011000000011011",
    189=>"1111011000001000"&"0011010011110111",
    190=>"1101011101101011"&"0101000000001101",
    191=>"1111001100101100"&"0010111000011110",
    192=>"1111010110111000"&"0011000001001010",
    193=>"1111001111001111"&"0011111100011111",
    194=>"1111000001010110"&"0010110110100000",
    195=>"1110100110001111"&"0010110001010111",
    196=>"1111110101000001"&"0010100000011111",
    197=>"1111011111000001"&"0001110011000100",
    198=>"1101110001001100"&"0100100111010001",
    199=>"1110111000000000"&"0011011010111000",
    200=>"1110000010101001"&"0011101001101000",
    201=>"1110110101111011"&"0010111010111110",
    202=>"1101000001000011"&"0100101010111000",
    203=>"1111000000000111"&"0010110100000100",
    204=>"1110101100100111"&"0100000110010010",
    205=>"1110110101011000"&"0011001110010001",
    206=>"1110111100101000"&"0011000000101101",
    207=>"1101110111100110"&"0010111011111010",
    208=>"1110100100001001"&"0010111101101011",
    209=>"1110011110111011"&"0011001101110111",
    210=>"1111000000100101"&"0010111001101100",
    211=>"1110111011111111"&"0010100000101010",
    212=>"1111100000110001"&"0010111000011100",
    213=>"1111001001000000"&"0100010000011111",
    214=>"1111001100001011"&"0010000111111111",
    215=>"1101010010101001"&"0100111010011011",
    216=>"1110111100100111"&"0011011000010000",
    217=>"1100101010000111"&"0101010001010010",
    218=>"1110111101110011"&"0010101001001100",
    219=>"1110110101000011"&"0011010100000000",
    220=>"1110100101111001"&"0011100101011100",
    221=>"1101011000111000"&"0011111110011000",
    222=>"0000011000000110"&"0001111011010010",
    223=>"1101111011111000"&"0011100101100100",
    224=>"1111111001100001"&"0001110111100111",
    225=>"1111010010011101"&"0010101110100010",
    226=>"1110011101101100"&"0011100101100111",
    227=>"1110111011110001"&"0011000010100011",
    228=>"1110010001011101"&"0011110010111010",
    229=>"1110110011100111"&"0011111000000011",
    230=>"1110100100101011"&"0100000111001110",
    231=>"1110010000001010"&"0100001011001100",
    232=>"1110111010100001"&"0011011100111111",
    233=>"1111010010011100"&"0010111011000000",
    234=>"1110110100011001"&"0100001001110010",
    235=>"1110010100000110"&"0011111011110111",
    236=>"1111111010010101"&"0001111111000111",
    237=>"1111001111110011"&"0010100000110110",
    238=>"1111101011011010"&"0011000010101111",
    239=>"1111010000111011"&"0010100011110000",
    240=>"1110100010010011"&"0100011101010100",
    241=>"1110011000101000"&"0011100110111111",
    242=>"1110101010111100"&"0011010100111010",
    243=>"1110011010010111"&"0011001000001111",
    244=>"1110110010100010"&"0011011010101011",
    245=>"1101011100101101"&"0100101101101010",
    246=>"1111100100101111"&"0011000110011100",
    247=>"1111001011110010"&"0011000000111101",
    248=>"1110111111000010"&"0010100111110101",
    249=>"1111001010010001"&"0010010100001101",
    250=>"1110110100000000"&"0010000010100000",
    251=>"1110111000000001"&"0010111001001000",
    252=>"1110111001111100"&"0011011001111100",
    253=>"1101101001010110"&"0100000010010010",
    254=>"1111001101110101"&"0010110100000001",
    255=>"1101101000000110"&"0100110011111000",
    256=>"1110100110101011"&"0010110101100000",
    257=>"1101100010100100"&"0011000111100101",
    258=>"1101111101000101"&"0011110000011011",
    259=>"1110100100011100"&"0011010111010011",
    260=>"1101111100010011"&"0100110010001000",
    261=>"1111111010001111"&"0011011011001000",
    262=>"1101111100111101"&"0100111010000000",
    263=>"1101001110110100"&"0100100010000010",
    264=>"1110111001111100"&"0011101110011000",
    265=>"1110010101010110"&"0011000011010110",
    266=>"1111010001011111"&"0011010101101111",
    267=>"1110111101111111"&"0011110010001110",
    268=>"1111001011011100"&"0010110010100010",
    269=>"1111000101001001"&"0011001101100001",
    270=>"1110001000011111"&"0100010100100100",
    271=>"1110001101010100"&"0011101001111000",
    272=>"1101111111011010"&"0011101000000001",
    273=>"1110101010111111"&"0010110110100110",
    274=>"1111100010001001"&"0010011111111000",
    275=>"1110111110110001"&"0011000110101101",
    276=>"1110110111101010"&"0010111101111011",
    277=>"1110111011000011"&"0011001010000110",
    278=>"1111101101011000"&"0011001001100100",
    279=>"1110110010001000"&"0011001110000001",
    280=>"0000100111111101"&"0010011101111001",
    281=>"1110101110110000"&"0100010011110000",
    282=>"1111011001100101"&"0010101100101010",
    283=>"1111001111001011"&"0010110111011101",
    284=>"1111100011011000"&"0011010101000110",
    285=>"1111100001010011"&"0010101111101101",
    286=>"1111000101011001"&"0010010001010010",
    287=>"0000011001101001"&"0011000000001010",
    288=>"1110001010010010"&"0011111101011011",
    289=>"1110110011000110"&"0011111001011111",
    290=>"1110100010010011"&"0011110000011010",
    291=>"1110001100011010"&"0011111100001110",
    292=>"1101100010001101"&"0100101010110011",
    293=>"1110101001011110"&"0011101010110111",
    294=>"1110110111001010"&"0011001001101101",
    295=>"1110011101101100"&"0011101011111010",
    296=>"1110111010101110"&"0011011010001011",
    297=>"0000010101001000"&"0010010000011010",
    298=>"1110010011010101"&"0011100001010111",
    299=>"0000000101100100"&"0010010111001011",
    300=>"1111000111011011"&"0011000100110100",
    301=>"1110110100111000"&"0011001101111101",
    302=>"1110000010011101"&"0010100001101000",
    303=>"1110001011100010"&"0010010110111000",
    304=>"1111101111001000"&"0011000110111011",
    305=>"1111010111101111"&"0010101000000100",
    306=>"1111011011100111"&"0011011001000110",
    307=>"1110110000111011"&"0011110000001110",
    308=>"1110111101011011"&"0011010110101101",
    309=>"1110110001001001"&"0011010001000011",
    310=>"1101110100110100"&"0011011101101000",
    311=>"1110101100101110"&"0011100000001111",
    312=>"1110110100001001"&"0010100011101110",
    313=>"1110100100010100"&"0011110011101000",
    314=>"1111000111000011"&"0010110001110101",
    315=>"1110110000001000"&"0011000101000011",
    316=>"1111000001010101"&"0010011111101000",
    317=>"1110100100011011"&"0011001100110100",
    318=>"1111101111000010"&"0010111100010111",
    319=>"1110100101111001"&"0011010100110111",
    320=>"1111001111111100"&"0010100110011010",
    321=>"1111011100010001"&"0011111001101011",
    322=>"1111100011000111"&"0011001000011101",
    323=>"1111110100100000"&"0011010101100010",
    324=>"1110101101001010"&"0011101010010001",
    325=>"1111000011010001"&"0011010010011010",
    326=>"1110101111000010"&"0010100111110000",
    327=>"1111010010000011"&"0010100000011110",
    328=>"1110111101111110"&"0010000001011111",
    329=>"1111111001110111"&"0010101111111010",
    330=>"1111001001100000"&"0100000001001100",
    331=>"1110110011101010"&"0011111001000101",
    332=>"1111010110111010"&"0010111101011001",
    333=>"1111011100100110"&"0010110100100000",
    334=>"1110011011001110"&"0011101101110001",
    335=>"1110110111000110"&"0011000001110101",
    336=>"1110011101101000"&"0011011000001010",
    337=>"1100111011101011"&"0100011010110000",
    338=>"1111011011000011"&"0011000100000011",
    339=>"1111001001110001"&"0011001010100001",
    340=>"1111100110011111"&"0010110101001100",
    341=>"1111110011000100"&"0001111101110101",
    342=>"1111001100001110"&"0011000101001001",
    343=>"1111110111000100"&"0010011111000101",
    344=>"1111110110011100"&"0011011101010000",
    345=>"1111001110110111"&"0010010111000011",
    346=>"1111010011000010"&"0010111100010110",
    347=>"1110000100101111"&"0100101110000010",
    348=>"1111001010110000"&"0010011000101111",
    349=>"1111101110101110"&"0010000100010100",
    350=>"1111001111010011"&"0011100001010100",
    351=>"1110110101111001"&"0100011001010110",
    352=>"1110011101110100"&"0011010100110111",
    353=>"1111110101111111"&"0010001001101110",
    354=>"1110111001001000"&"0011100010000000",
    355=>"1111101000101011"&"0010011010110010",
    356=>"1111110111000000"&"0010110000011010",
    357=>"1111000101010010"&"0001110100111111",
    358=>"1111001101001101"&"0010010100101100",
    359=>"1110001101010001"&"0011011110001011",
    360=>"1111000101100100"&"0100000110000101",
    361=>"1110000001000011"&"0100001110000101",
    362=>"1111101111110010"&"0010100001101010",
    363=>"1110110001001001"&"0011000101111010",
    364=>"1111011000011110"&"0011000011000001",
    365=>"1110011000111100"&"0011111011101011",
    366=>"1110101110011000"&"0010111001100111",
    367=>"1110111011100100"&"0010010010001001",
    368=>"1110011000010001"&"0010101101010011",
    369=>"1110101100001100"&"0010100000011110",
    370=>"1111000000011101"&"0011011110000010",
    371=>"1111111011111001"&"0010111110111000",
    372=>"1110100111000111"&"0011000100011011",
    373=>"1101001010111001"&"0100100011101100",
    374=>"1110111010010100"&"0011100011000101",
    375=>"1110011111010101"&"0011001010111000",
    376=>"1111011110010010"&"0010001111111111",
    377=>"1111011110111001"&"0010011110001010",
    378=>"1111111110111001"&"0010011010100001",
    379=>"1110111111000001"&"0011101111000111",
    380=>"1110100101111100"&"0011011000011110",
    381=>"1111010001111000"&"0100001001001111",
    382=>"1110010100101100"&"0011001000100101",
    383=>"1111110010111100"&"0010001010011010",
    384=>"1110010001001101"&"0011101101101111",
    385=>"1110110101011101"&"0011101010101111",
    386=>"1111011110110010"&"0010011011100001",
    387=>"1111110100001001"&"0010110000001111",
    388=>"1111100100001001"&"0011010010110110",
    389=>"1110110111011101"&"0010110101010101",
    390=>"1110111101100101"&"0011110001011110",
    391=>"1110001111011010"&"0011101000110111",
    392=>"0000010101011010"&"0010010011101110",
    393=>"1110011001101000"&"0100001101101000",
    394=>"1111001100011011"&"0011010100000010",
    395=>"1111100000000011"&"0011001100101110",
    396=>"0000110011010011"&"0010100101110111",
    397=>"1110110111101100"&"0011010101101011",
    398=>"1110110010110000"&"0011110000010111",
    399=>"1110111100000011"&"0010101110110101",
    400=>"1111010010010110"&"0001101011100010",
    401=>"1111011101010111"&"0011010011101110",
    402=>"1111100110110011"&"0011000101100001",
    403=>"1111010000111101"&"0010010111010100",
    404=>"1111110100111111"&"0011000010011100",
    405=>"1111001101110010"&"0010001101010011",
    406=>"1101011110001111"&"0100010010100101",
    407=>"1110101011010001"&"0011010100001110",
    408=>"1111111000010100"&"0010110001000111",
    409=>"1111010100000111"&"0011101000110000",
    410=>"1110010010011111"&"0100011000111111",
    411=>"1111010110011110"&"0100000111010010",
    412=>"1110111010110110"&"0011001111111011",
    413=>"1111011010110000"&"0011001101111100",
    414=>"1111001011101101"&"0010110100111101",
    415=>"1111000000101110"&"0010111010011101",
    416=>"1111000000100000"&"0011000001000110",
    417=>"1110111011101110"&"0011010110111001",
    418=>"1100111110111011"&"0100101010101011",
    419=>"1111001010010101"&"0010011100101001",
    420=>"1100010011100101"&"0101100110010000",
    421=>"1111110011011110"&"0010110110000111",
    422=>"1111100011010010"&"0010100111001001",
    423=>"1111101001011010"&"0010110010110100",
    424=>"1110101010101001"&"0010101101111111",
    425=>"1110001111111000"&"0100000010001111",
    426=>"1111010100101111"&"0011001101111001",
    427=>"1111101001111000"&"0010111110101011",
    428=>"1110110111000000"&"0010000111101000",
    429=>"1101000001001000"&"0100010000111000",
    430=>"1110010000111010"&"0011101100101011",
    431=>"1111010010101011"&"0010111010110011",
    432=>"1110111000100111"&"0011001111010000",
    433=>"0000000101001111"&"0010011101000101",
    434=>"1110100111011010"&"0010110101110110",
    435=>"1111101100100000"&"0010010101101010",
    436=>"1111000010011100"&"0011000101111001",
    437=>"1101010001011100"&"0100101101100101",
    438=>"1101001011111011"&"0110010001011011",
    439=>"1111000010111110"&"0010101010100111",
    440=>"1110100001010000"&"0010110001001011",
    441=>"1111000100000111"&"0010110101010011",
    442=>"1101100000011011"&"0011101111000100",
    443=>"1101100010011011"&"0100111010011101",
    444=>"1111111001010101"&"0010101010000011",
    445=>"1101010001011011"&"0101011011111100",
    446=>"1110111001110000"&"0010110010111001",
    447=>"1101110111110001"&"0011000000100100",
    448=>"1111000001011111"&"0011000100010011",
    449=>"0000011101001100"&"0010001011000000",
    450=>"1111110010100001"&"0000110111000010",
    451=>"1111000101101111"&"0010100010110010",
    452=>"1100111010010100"&"0101000110101011",
    453=>"1110000001110010"&"0100011100011001",
    454=>"1110010100111100"&"0010110001110110",
    455=>"1110100011111111"&"0011001001111001",
    456=>"1101111110100111"&"0011100101100001",
    457=>"1110111000111101"&"0011110001110101",
    458=>"1101101000111111"&"0010101000110011",
    459=>"1110110110001101"&"0010110011001000",
    460=>"1110100110100111"&"0011000010101111",
    461=>"1111110001110010"&"0010110111101101",
    462=>"1110100000111101"&"0011011111000000",
    463=>"1111011100011111"&"0011101110001100",
    464=>"1110110010100001"&"0010110000100010",
    465=>"1111101101111110"&"0011110111110111",
    466=>"1110111111110000"&"0011100001101100",
    467=>"1111100001101101"&"0010100111000000",
    468=>"1111001010110110"&"0011101000101110",
    469=>"1101011001000000"&"0100011011111010",
    470=>"1110011110110001"&"0011001111101010",
    471=>"1111010011010100"&"0010110101111000",
    472=>"1110000100010001"&"0010111001011111",
    473=>"1111000100101111"&"0010110100100010",
    474=>"1111001111000111"&"0010101111110011",
    475=>"1101101010001001"&"0100100011001011",
    476=>"1110111001100001"&"0011011010010111",
    477=>"1110110001000011"&"0011110001000110",
    478=>"1111000111110111"&"0010111101110111",
    479=>"1110110000001100"&"0011000111010000",
    480=>"1111001010110000"&"0010101011101010",
    481=>"1110100100001011"&"0011001111001110",
    482=>"1111001010011101"&"0011000111100010",
    483=>"1110010101111010"&"0011111101110000",
    484=>"1111110011111110"&"0010101001001111",
    485=>"1110111111100100"&"0011100001100011",
    486=>"1110000110100111"&"0011110010011010",
    487=>"1111001010010110"&"0010010101110101",
    488=>"1110100111111100"&"0011101000100110",
    489=>"1111000010010010"&"0011011101001111",
    490=>"1101101101010001"&"0100100111100100",
    491=>"1111010010000100"&"0011001001110000",
    492=>"1110100100010100"&"0011110111011011",
    493=>"1110110110110001"&"0011000001110101",
    494=>"0000011111001111"&"0010000001001101",
    495=>"1111000111000001"&"0100000001110111",
    496=>"1110100101001110"&"0010010100100010",
    497=>"1111101100111111"&"0010111000001011",
    498=>"1110101101001101"&"0011100001101110",
    499=>"1111000111000110"&"0010100000101111",
    500=>"1111100111100110"&"0011000011110001",
    501=>"1110100011001110"&"0010111110101010",
    502=>"1111000100110101"&"0011100010010110",
    503=>"1110000111001100"&"0100000101100000",
    504=>"1110001100101000"&"0011011001011110",
    505=>"1101110101101000"&"0010110100011001",
    506=>"1111101101100011"&"0011001011111111",
    507=>"0000010001111110"&"0010001100010001",
    508=>"1111001010001101"&"0011011110011000",
    509=>"1111010101000100"&"0011011001100101",
    510=>"1110110110010110"&"0010110100101101",
    511=>"1111000010001110"&"0011100011110011");
    
BEGIN
    weight <= ROM_content(to_integer(address));
END RTL;