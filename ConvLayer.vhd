LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

LIBRARY work;
USE work.YOLO_pkg.ALL;

ENTITY ConvLayer IS
    GENERIC (L : INTEGER := 0);
    PORT (
        clk : IN STD_LOGIC;
        reset : IN STD_LOGIC;

        datain : IN STD_LOGIC_VECTOR((grid(L) * 6) - 1 DOWNTO 0);

        padding : IN STD_LOGIC_VECTOR(grid(L) - 1 DOWNTO 0);
        startLbuffer : IN STD_LOGIC;
        enableLbuffer : IN STD_LOGIC;

        Weights : IN STD_LOGIC_VECTOR(grid(L) - 1 DOWNTO 0);
        Ynorm : IN signed(15 DOWNTO 0);
        Bnorm : IN signed(15 DOWNTO 0);

        dataout : OUT STD_LOGIC_VECTOR(5 DOWNTO 0)
    );
END ENTITY ConvLayer;

ARCHITECTURE rtl OF ConvLayer IS

    COMPONENT signedInverse
        PORT (
            datain : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
            Weights : IN STD_LOGIC;
            dataout : OUT STD_LOGIC_VECTOR(5 DOWNTO 0)
        );

    END COMPONENT;

    COMPONENT ternaryAdder
        GENERIC (N : INTEGER);
        PORT (
            A, B, C : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
            dataout : OUT STD_LOGIC_VECTOR(N + 1 DOWNTO 0)
        );
    END COMPONENT;

    COMPONENT LinealBuffer
        GENERIC (
            L : INTEGER;
            W : INTEGER);
        PORT (
            clk : IN STD_LOGIC;
            reset : IN STD_LOGIC;
            enable_LBuffer : IN STD_LOGIC;
            datain : IN STD_LOGIC_VECTOR((W - 1) DOWNTO 0);
            dataout : OUT STD_LOGIC_VECTOR((W - 1) DOWNTO 0)
        );
    END COMPONENT;

    COMPONENT LeakyReLU
        PORT (
            datain : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            dataout : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
        );
    END COMPONENT;

    SIGNAL out_padding : STD_LOGIC_VECTOR((grid(L) * 6) - 1 DOWNTO 0);
    SIGNAL out_signedInverse : STD_LOGIC_VECTOR((grid(L) * 6) - 1 DOWNTO 0);

    SIGNAL out_teradder1 : STD_LOGIC_VECTOR(23 DOWNTO 0);

    SIGNAL out_teradder2 : STD_LOGIC_VECTOR(9 DOWNTO 0);
    SIGNAL sout_teradder2 : signed(9 DOWNTO 0);

    SIGNAL out_mux_buffer : STD_LOGIC_VECTOR(bufferwidth(L)-1 DOWNTO 0); 
    SIGNAL sout_mux_buffer : signed (bufferwidth(L)-1 DOWNTO 0); 

    SIGNAL in_buffer : STD_LOGIC_VECTOR(bufferwidth(L)-1 DOWNTO 0); 
    SIGNAL out_buffer : STD_LOGIC_VECTOR(bufferwidth(L)-1 DOWNTO 0); 
    SIGNAL sout_buffer : SIGNED(bufferwidth(L)-1 DOWNTO 0); 

    SIGNAL sout_MUL : signed(16 + bufferwidth(L) - 1 DOWNTO 0); 
    SIGNAL out_MUL : STD_LOGIC_VECTOR(16 + bufferwidth(L) - 1 DOWNTO 0);
    SIGNAL qout_MUL : STD_LOGIC_VECTOR(15 DOWNTO 0);


    SIGNAL out_leakyReLU : STD_LOGIC_VECTOR(15 DOWNTO 0);

    SIGNAL out_add : STD_LOGIC_VECTOR(15 DOWNTO 0);
BEGIN

    proc_padding : PROCESS (padding, datain)
    BEGIN
        FOR I IN 1 TO 9 LOOP
            CASE padding(I - 1) IS
                WHEN '1' =>
                    out_padding((I * 6) - 1 DOWNTO (I * 6) - 6) <= datain((I * 6) - 1 DOWNTO (I * 6) - 6);
                WHEN OTHERS =>
                    out_padding((I * 6) - 1 DOWNTO (I * 6) - 6) <= (OTHERS => '0');
            END CASE;
        END LOOP;
    END PROCESS proc_padding;

    sig_inv : FOR I IN 1 TO 9 GENERATE
        UX : signedInverse PORT MAP(
            datain => out_padding((I * 6) - 1 DOWNTO (I * 6) - 6),
            Weights => Weights(I - 1),
            dataout => out_signedInverse((I * 6) - 1 DOWNTO (I * 6) - 6)
        );
    END GENERATE sig_inv;

    ter_add1 : ternaryAdder
    GENERIC MAP(N => 6)
    PORT MAP(
        A => out_signedInverse(5 DOWNTO 0),
        B => out_signedInverse(11 DOWNTO 6),
        C => out_signedInverse(17 DOWNTO 12),
        dataout => out_teradder1(7 DOWNTO 0)
    );

    ter_add2 : ternaryAdder
    GENERIC MAP(N => 6)
    PORT MAP(
        A => out_signedInverse(23 DOWNTO 18),
        B => out_signedInverse(29 DOWNTO 24),
        C => out_signedInverse(35 DOWNTO 30),
        dataout => out_teradder1(15 DOWNTO 8)
    );

    ter_add3 : ternaryAdder
    GENERIC MAP(N => 6)
    PORT MAP(
        A => out_signedInverse(41 DOWNTO 36),
        B => out_signedInverse(47 DOWNTO 42),
        C => out_signedInverse(53 DOWNTO 48),
        dataout => out_teradder1(23 DOWNTO 16)
    );

    ter_add4 : ternaryAdder
    GENERIC MAP(N => 8)
    PORT MAP(
        A => out_teradder1(7 DOWNTO 0),
        B => out_teradder1(15 DOWNTO 8),
        C => out_teradder1(23 DOWNTO 16),
        dataout => out_teradder2
    );

    LB : LinealBuffer
    GENERIC MAP(L => 1, W => 1) --añadir funciones
    PORT MAP(
        clk => clk,
        reset => reset,
        enable_LBuffer => '1',
        datain => in_buffer,
        dataout => out_buffer
    );

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
    sout_teradder2 <= SIGNED(out_teradder2);

    in_buffer <= STD_LOGIC_VECTOR(sout_teradder2 + sout_mux_buffer);

    sout_MUL <= signed(out_buffer) * Ynorm;
    out_MUL <= STD_LOGIC_VECTOR(sout_MUL);
    qout_MUL <= out_MUL(16 + bufferwidth(L) - 1 DOWNTO 16 + bufferwidth(L) - 16);

    f_act : LeakyReLU
    PORT MAP(
        datain => qout_MUL,
        dataout => out_leakyReLU
    );

    out_add <= STD_LOGIC_VECTOR(signed(out_leakyReLU) + Bnorm);

    dataout <= out_add(15 DOWNTO 10);
END ARCHITECTURE rtl;