LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

LIBRARY work;
USE work.YOLO_pkg.ALL;

ENTITY L2WROM IS
    PORT (
        weight : OUT STD_LOGIC_VECTOR(8 DOWNTO 0);
        address : IN unsigned(weightsbitsAddress(2) DOWNTO 0));
END L2WROM;

ARCHITECTURE RTL OF L2WROM IS

    TYPE ROM_mem IS ARRAY (0 TO 511) OF STD_LOGIC_VECTOR(8 DOWNTO 0);

    CONSTANT ROM_content : ROM_mem := (0 => "111111110",
    1 => "100111100",
    2 => "111011000",
    3 => "111111000",
    4 => "111111101",
    5 => "000111111",
    6 => "010011010",
    7 => "101100000",
    8 => "111100100",
    9 => "010011010",
    10 => "000011010",
    11 => "010000010",
    12 => "000111111",
    13 => "010010010",
    14 => "000000010",
    15 => "111111101",
    16 => "000000001",
    17 => "000000000",
    18 => "111111111",
    19 => "000000000",
    20 => "000111011",
    21 => "001011011",
    22 => "110000000",
    23 => "001000001",
    24 => "111111011",
    25 => "111011011",
    26 => "101111111",
    27 => "110011101",
    28 => "000000000",
    29 => "011110011",
    30 => "110000000",
    31 => "000000000",
    32 => "000001111",
    33 => "000011011",
    34 => "101000000",
    35 => "101001110",
    36 => "000001011",
    37 => "100001110",
    38 => "101100000",
    39 => "100001011",
    40 => "000001011",
    41 => "100010001",
    42 => "000001111",
    43 => "000001011",
    44 => "110100100",
    45 => "001001011",
    46 => "110110100",
    47 => "100001001",
    48 => "110110011",
    49 => "001101100",
    50 => "100011001",
    51 => "110011001",
    52 => "011001001",
    53 => "001100111",
    54 => "000000000",
    55 => "100110011",
    56 => "100011001",
    57 => "111010000",
    58 => "011011001",
    59 => "100100010",
    60 => "001000111",
    61 => "001100001",
    62 => "100100110",
    63 => "111010010",
    64 => "100000111",
    65 => "111100000",
    66 => "001001111",
    67 => "001111100",
    68 => "000011111",
    69 => "111001001",
    70 => "100001001",
    71 => "111000000",
    72 => "101000001",
    73 => "110000001",
    74 => "010010000",
    75 => "100000001",
    76 => "000001111",
    77 => "110000000",
    78 => "111100000",
    79 => "101001001",
    80 => "001001111",
    81 => "010110110",
    82 => "111111011",
    83 => "111111011",
    84 => "000011101",
    85 => "001011011",
    86 => "000100000",
    87 => "101000101",
    88 => "110111001",
    89 => "110101010",
    90 => "110111010",
    91 => "000101100",
    92 => "000000100",
    93 => "111111110",
    94 => "111010000",
    95 => "111111110",
    96 => "110111010",
    97 => "101000001",
    98 => "011011011",
    99 => "011011010",
    100 => "111000101",
    101 => "111100011",
    102 => "000000000",
    103 => "100111100",
    104 => "000111001",
    105 => "000000000",
    106 => "111000000",
    107 => "000000000",
    108 => "110110000",
    109 => "101000001",
    110 => "010000011",
    111 => "110110000",
    112 => "000000001",
    113 => "111110000",
    114 => "000000000",
    115 => "000000000",
    116 => "000000010",
    117 => "101111110",
    118 => "000000010",
    119 => "111101111",
    120 => "111100111",
    121 => "100111010",
    122 => "111011010",
    123 => "100011010",
    124 => "111111111",
    125 => "111111110",
    126 => "111010101",
    127 => "000000001",
    128 => "110110000",
    129 => "111000000",
    130 => "110110000",
    131 => "000110010",
    132 => "101000000",
    133 => "111000000",
    134 => "000011111",
    135 => "000111001",
    136 => "111000000",
    137 => "010011001",
    138 => "111000000",
    139 => "001000001",
    140 => "000000111",
    141 => "110010000",
    142 => "000010110",
    143 => "110010011",
    144 => "101101111",
    145 => "000000000",
    146 => "000000000",
    147 => "001001000",
    148 => "000000010",
    149 => "110100000",
    150 => "000100000",
    151 => "100101111",
    152 => "000000001",
    153 => "101111101",
    154 => "101110110",
    155 => "011011111",
    156 => "111111111",
    157 => "101111110",
    158 => "111101101",
    159 => "111111000",
    160 => "011100001",
    161 => "110001110",
    162 => "001110100",
    163 => "011100101",
    164 => "110100001",
    165 => "000011100",
    166 => "000001010",
    167 => "001110100",
    168 => "011110001",
    169 => "000011100",
    170 => "110100011",
    171 => "011100001",
    172 => "100000011",
    173 => "001110001",
    174 => "101011100",
    175 => "011110101",
    176 => "000000000",
    177 => "111111111",
    178 => "000110000",
    179 => "111111111",
    180 => "110101111",
    181 => "000011110",
    182 => "010000111",
    183 => "000000000",
    184 => "000000000",
    185 => "100100010",
    186 => "000111110",
    187 => "011011011",
    188 => "111111111",
    189 => "000001000",
    190 => "111101001",
    191 => "111111010",
    192 => "111111101",
    193 => "000000000",
    194 => "000000000",
    195 => "010011011",
    196 => "111000000",
    197 => "001011011",
    198 => "001001000",
    199 => "000011000",
    200 => "011101100",
    201 => "111111110",
    202 => "111100100",
    203 => "111111111",
    204 => "011000111",
    205 => "011011010",
    206 => "111011011",
    207 => "011000100",
    208 => "010100110",
    209 => "100010010",
    210 => "100100001",
    211 => "110010011",
    212 => "101100010",
    213 => "111010100",
    214 => "011011010",
    215 => "010100101",
    216 => "101101010",
    217 => "100101010",
    218 => "101100010",
    219 => "010110101",
    220 => "101101001",
    221 => "010001000",
    222 => "010011101",
    223 => "101101101",
    224 => "100100100",
    225 => "011011011",
    226 => "101100100",
    227 => "011001001",
    228 => "000000001",
    229 => "101100111",
    230 => "001001000",
    231 => "110110100",
    232 => "100100100",
    233 => "111001111",
    234 => "110101111",
    235 => "000000000",
    236 => "001001001",
    237 => "111111101",
    238 => "011101111",
    239 => "001001001",
    240 => "011001001",
    241 => "111001000",
    242 => "100101100",
    243 => "000101001",
    244 => "100000110",
    245 => "111001000",
    246 => "000000000",
    247 => "011001000",
    248 => "001001000",
    249 => "011001000",
    250 => "101111000",
    251 => "011001000",
    252 => "000000111",
    253 => "011001001",
    254 => "011001001",
    255 => "111101001",
    256 => "111000000",
    257 => "000000111",
    258 => "001000111",
    259 => "111000111",
    260 => "111000111",
    261 => "111010001",
    262 => "000111000",
    263 => "111111000",
    264 => "111000000",
    265 => "110001011",
    266 => "111000111",
    267 => "001100100",
    268 => "110000111",
    269 => "000000010",
    270 => "000111000",
    271 => "111000110",
    272 => "000001111",
    273 => "111001000",
    274 => "001001111",
    275 => "110110111",
    276 => "101001101",
    277 => "111110011",
    278 => "101011000",
    279 => "101001001",
    280 => "000001111",
    281 => "111110111",
    282 => "001001001",
    283 => "111111111",
    284 => "111001000",
    285 => "001001001",
    286 => "000000001",
    287 => "110110110",
    288 => "110100111",
    289 => "000110110",
    290 => "011001000",
    291 => "111000100",
    292 => "000001011",
    293 => "010110000",
    294 => "000100000",
    295 => "000100110",
    296 => "111100011",
    297 => "000110100",
    298 => "000110110",
    299 => "000011010",
    300 => "000100010",
    301 => "110110110",
    302 => "100110000",
    303 => "000110110",
    304 => "111000000",
    305 => "000001111",
    306 => "111100000",
    307 => "000001111",
    308 => "000000000",
    309 => "101011111",
    310 => "100001011",
    311 => "111100000",
    312 => "111000000",
    313 => "001001110",
    314 => "000000100",
    315 => "110100011",
    316 => "000000111",
    317 => "101000001",
    318 => "111101111",
    319 => "000001111",
    320 => "111110000",
    321 => "000000111",
    322 => "000000111",
    323 => "000000111",
    324 => "110100010",
    325 => "110110000",
    326 => "000000000",
    327 => "111111110",
    328 => "111111000",
    329 => "001011011",
    330 => "110110100",
    331 => "110010000",
    332 => "110100000",
    333 => "010010010",
    334 => "000011111",
    335 => "100000000",
    336 => "000111111",
    337 => "110010100",
    338 => "111000000",
    339 => "111001000",
    340 => "111001001",
    341 => "001100111",
    342 => "001001100",
    343 => "000110111",
    344 => "000111111",
    345 => "001101110",
    346 => "111110111",
    347 => "001100111",
    348 => "111001000",
    349 => "101100110",
    350 => "000000100",
    351 => "001101000",
    352 => "000000101",
    353 => "000010010",
    354 => "111111111",
    355 => "000000000",
    356 => "000111011",
    357 => "111111000",
    358 => "110101101",
    359 => "111101011",
    360 => "111011111",
    361 => "101000001",
    362 => "010000000",
    363 => "111101000",
    364 => "111111111",
    365 => "101101101",
    366 => "100000111",
    367 => "000000000",
    368 => "100100100",
    369 => "000101001",
    370 => "111011011",
    371 => "001001111",
    372 => "001001010",
    373 => "101101101",
    374 => "000000011",
    375 => "110110110",
    376 => "110110110",
    377 => "110110100",
    378 => "101000101",
    379 => "100100100",
    380 => "001101001",
    381 => "111000111",
    382 => "011000001",
    383 => "100101110",
    384 => "011010101",
    385 => "010101001",
    386 => "111010110",
    387 => "001100100",
    388 => "010100100",
    389 => "011011110",
    390 => "001001100",
    391 => "101010010",
    392 => "011010101",
    393 => "101110010",
    394 => "010010101",
    395 => "110011101",
    396 => "100010001",
    397 => "100010100",
    398 => "101001010",
    399 => "110010010",
    400 => "011011001",
    401 => "100100110",
    402 => "100110111",
    403 => "100110110",
    404 => "000000100",
    405 => "101000111",
    406 => "000000000",
    407 => "011011001",
    408 => "011001101",
    409 => "000000100",
    410 => "001000110",
    411 => "100100111",
    412 => "100100110",
    413 => "111101100",
    414 => "111011111",
    415 => "001100100",
    416 => "001011111",
    417 => "110100100",
    418 => "111001000",
    419 => "111100100",
    420 => "110100110",
    421 => "100001011",
    422 => "100000001",
    423 => "001011011",
    424 => "001011011",
    425 => "000000001",
    426 => "111111110",
    427 => "001100101",
    428 => "110000000",
    429 => "101001101",
    430 => "100001001",
    431 => "101000010",
    432 => "011100111",
    433 => "100111100",
    434 => "110011001",
    435 => "100110001",
    436 => "100110011",
    437 => "101001110",
    438 => "101000100",
    439 => "011100110",
    440 => "001110011",
    441 => "000110001",
    442 => "000110001",
    443 => "110001110",
    444 => "011000001",
    445 => "111100011",
    446 => "110001110",
    447 => "001100011",
    448 => "011010011",
    449 => "100111100",
    450 => "000000001",
    451 => "111000111",
    452 => "010110000",
    453 => "011011011",
    454 => "001001001",
    455 => "011011011",
    456 => "001001001",
    457 => "001101101",
    458 => "100100100",
    459 => "000100000",
    460 => "100100100",
    461 => "111000111",
    462 => "110110110",
    463 => "001001001",
    464 => "000111101",
    465 => "111000000",
    466 => "111100000",
    467 => "000111111",
    468 => "100000000",
    469 => "111000111",
    470 => "101000000",
    471 => "000000010",
    472 => "000010010",
    473 => "001000000",
    474 => "101111111",
    475 => "100000000",
    476 => "111000100",
    477 => "101111111",
    478 => "111111111",
    479 => "111000111",
    480 => "101101100",
    481 => "011001001",
    482 => "100111100",
    483 => "000111101",
    484 => "100100100",
    485 => "011011011",
    486 => "000100100",
    487 => "101101101",
    488 => "101101101",
    489 => "000110011",
    490 => "111100100",
    491 => "001001001",
    492 => "001111101",
    493 => "101101101",
    494 => "100100110",
    495 => "000011101",
    496 => "101111111",
    497 => "011011111",
    498 => "000011011",
    499 => "000011011",
    500 => "100000000",
    501 => "111101011",
    502 => "111100101",
    503 => "000111100",
    504 => "001011011",
    505 => "101000000",
    506 => "000000001",
    507 => "110010000",
    508 => "110100100",
    509 => "101111100",
    510 => "100011110",
    511 => "010110010");

BEGIN
    weight <= ROM_content(to_integer(address));
END RTL;