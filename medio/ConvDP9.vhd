LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

LIBRARY work;
USE work.YOLO_pkg.ALL;

ENTITY ConvDP IS
    GENERIC (layer : INTEGER := 1);
    PORT (
        clk : IN STD_LOGIC;
        reset : IN STD_LOGIC;

        datain : IN STD_LOGIC_VECTOR((grid(Layer) * 6) - 1 DOWNTO 0); --datos de 6
        Weights : IN STD_LOGIC_VECTOR((8 * grid(Layer)) - 1 DOWNTO 0); --pesos de 8 bits
        Ynorm : IN signed(15 DOWNTO 0);
        Bnorm : IN signed(15 DOWNTO 0);

        startLbuffer : IN STD_LOGIC;
        enableLbuffer : IN STD_LOGIC;

        dataout : OUT STD_LOGIC_VECTOR(15 DOWNTO 0) --salida de 16
    );
END ENTITY ConvDP;

ARCHITECTURE rtl OF ConvDP IS

    CONSTANT bits : INTEGER := 14;--mas?
    CONSTANT grid : INTEGER := grid(layer);--mas?
    CONSTANT WL : INTEGER := bufferwidth(layer); -- Word Length
    CONSTANT columns : INTEGER := columns(layer);--mas?

    COMPONENT ternaryAdder
        GENERIC (N : INTEGER);
        PORT (
            A, B, C : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
            dataout : OUT STD_LOGIC_VECTOR(N + 1 DOWNTO 0)
        );
    END COMPONENT;

    COMPONENT DelayMem
        GENERIC (
            BL : INTEGER := 1; -- Buffer Length
            WL : INTEGER := 1 -- Word Length
        );
        PORT (
            clk : IN STD_LOGIC;
            reset : IN STD_LOGIC;
            validIn : IN STD_LOGIC;
            Din : IN STD_LOGIC_VECTOR((WL - 1) DOWNTO 0);
            Dout : OUT STD_LOGIC_VECTOR((WL - 1) DOWNTO 0)
        );
    END COMPONENT;

    COMPONENT LeakyReLU
        PORT (
            datain : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            dataout : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
        );
    END COMPONENT;

    SIGNAL Sdatain : SIGNED(53 DOWNTO 0);
    SIGNAL Sweights : SIGNED(71 DOWNTO 0);

    SIGNAL sout_weight_mul : SIGNED(125 DOWNTO 0);
    SIGNAL out_weight_mul : STD_LOGIC_VECTOR(125 DOWNTO 0);

    SIGNAL out_teradder1 : STD_LOGIC_VECTOR(3*16 - 1 DOWNTO 0);

    SIGNAL out_teradder2 : STD_LOGIC_VECTOR(17 DOWNTO 0);
    SIGNAL sout_teradder2 : signed(17 DOWNTO 0);

    SIGNAL out_mux_buffer : STD_LOGIC_VECTOR(WL - 1 DOWNTO 0);
    SIGNAL sout_mux_buffer : signed (WL - 1 DOWNTO 0);

    SIGNAL in_buffer : STD_LOGIC_VECTOR(WL - 1 DOWNTO 0);
    SIGNAL out_buffer : STD_LOGIC_VECTOR(WL - 1 DOWNTO 0);
    SIGNAL sout_buffer : SIGNED(WL - 1 DOWNTO 0);

    SIGNAL sout_MUL : signed(16 + WL - 1 DOWNTO 0);
    SIGNAL out_MUL : STD_LOGIC_VECTOR(16 + WL - 1 DOWNTO 0);
    SIGNAL qout_MUL : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL out_leakyReLU : STD_LOGIC_VECTOR(15 DOWNTO 0);

    SIGNAL out_add : STD_LOGIC_VECTOR(15 DOWNTO 0);
BEGIN

    sDataIn <= signed(datain);
    sWeights <= signed(Weights);

    WeightMUL : FOR I IN 0 TO 8 GENERATE
        sout_weight_mul(((I + 1) * 14) - 1 DOWNTO (I * 14)) <= SdataIn(((I + 1) * 6) - 1 DOWNTO (I * 6)) * sWeights(((I + 1) * 8) - 1 DOWNTO (I * 8));
    END GENERATE WeightMUL;

    out_weight_mul <= STD_LOGIC_VECTOR(sout_weight_mul);

    ter_add1 : ternaryAdder
    GENERIC MAP(N => bits)
    PORT MAP(
        A => out_signedInverse(bits - 1 DOWNTO 0),
        B => out_signedInverse(2 * bits - 1 DOWNTO bits),
        C => out_signedInverse(3 * bits - 1 DOWNTO 2 * bits),
        dataout => out_teradder1(15 DOWNTO 0) --param??
    );

    ter_add2 : ternaryAdder
    GENERIC MAP(N => bits)
    PORT MAP(
        A => out_signedInverse(4 * bits - 1 DOWNTO 3 * bits),
        B => out_signedInverse(5 * bits - 1 DOWNTO 4 * bits),
        C => out_signedInverse(6 * bits - 1 DOWNTO 5 * bits),
        dataout => out_teradder1(31 DOWNTO 16) --param??
    );

    ter_add3 : ternaryAdder
    GENERIC MAP(N => bits)
    PORT MAP(
        A => out_signedInverse(7 * bits - 1 DOWNTO 6 * bits),
        B => out_signedInverse(8 * bits - 1 DOWNTO 7 * bits),
        C => out_signedInverse(9 * bits - 1 DOWNTO 8 * bits),
        dataout => out_teradder1(47 DOWNTO 32) --param??
    );

    ter_add4 : ternaryAdder
    GENERIC MAP(N => bits + 2)
    PORT MAP(
        A => out_teradder1(15 DOWNTO 0),
        B => out_teradder1(31 DOWNTO 16),
        C => out_teradder1(47 DOWNTO 32),
        dataout => out_teradder2
    );

    sout_teradder2 <= SIGNED(out_teradder2);

    muxBuffer : PROCESS (startLbuffer, out_buffer)
    BEGIN
        CASE startLbuffer IS
            WHEN '1' =>
                out_mux_buffer <= (OTHERS => '0');
            WHEN OTHERS =>
                out_mux_buffer <= out_buffer;
        END CASE;
    END PROCESS muxBuffer;

    sout_mux_buffer <= SIGNED(out_mux_buffer);

    in_buffer <= STD_LOGIC_VECTOR(sout_teradder2 + sout_mux_buffer);

    LinBuff : DelayMem
    GENERIC MAP(
        BL => columns - 1, WL => WL)
    PORT MAP(
        clk => clk,
        reset => reset,
        validIn => enableLbuffer,
        Din => in_buffer,
        Dout => out_buffer
    );

    sout_MUL <= signed(out_buffer) * Ynorm;
    out_MUL <= STD_LOGIC_VECTOR(sout_MUL);
    qout_MUL <= out_MUL(16 + WL - 1 DOWNTO 16 + WL - 16);

    f_act : LeakyReLU
    PORT MAP(
        datain => qout_MUL,
        dataout => out_leakyReLU
    );

    out_add <= STD_LOGIC_VECTOR(signed(out_leakyReLU) + Bnorm);

    dataout <= out_add(15 DOWNTO 10);

END ARCHITECTURE rtl;