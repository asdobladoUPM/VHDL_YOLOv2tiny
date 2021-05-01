LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE IEEE.MATH_REAL.ALL;

LIBRARY work;
USE work.YOLO_pkg.ALL;

ENTITY MemControl IS
    GENERIC (
        layer : INTEGER := 4);
    PORT (
        clk : IN STD_LOGIC;
        reset : IN STD_LOGIC;
        start : IN STD_LOGIC;

        we : IN STD_LOGIC;

        rMem : OUT INTEGER;
        rMemOdd : OUT STD_LOGIC;
        address0 : OUT INTEGER;
        address1 : OUT INTEGER;
        address2 : OUT INTEGER;
        padding : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
        kernelCol : OUT INTEGER;
        kernelRow : OUT INTEGER;
        validOut : OUT STD_LOGIC;

        weightaddress : OUT INTEGER;

        weRAM : OUT STD_LOGIC;
        wMemOdd : OUT STD_LOGIC;
        wBank : OUT INTEGER;
        waddress : OUT INTEGER);
END MemControl;

ARCHITECTURE arch OF MemControl IS

    --constantes
    CONSTANT Hc : INTEGER := columns(layer + 1);
    CONSTANT Hr : INTEGER := rows(layer + 1);
    CONSTANT Ch : INTEGER := filters(layer);
    CONSTANT K : INTEGER := kernels(layer);

    CONSTANT Fnext : INTEGER := filters(layer + 1);
    CONSTANT Knext : INTEGER := kernels(layer + 1);

    --señal de delay
    SIGNAL count_delay : INTEGER;
    SIGNAL delay : INTEGER;

    --señales lectura
    SIGNAL oe : STD_LOGIC;

    SIGNAL s_kernelCol : INTEGER;
    SIGNAL s_kernelRow : INTEGER;
    SIGNAL s_rmem : INTEGER;

    --señales lectura contadores
    SIGNAL rcount_col : INTEGER;
    SIGNAL rcount_row : INTEGER;
    SIGNAL rcount_ch : INTEGER;
    SIGNAL rcount_chMEM : INTEGER;
    SIGNAL rcount_fil : INTEGER;

    SIGNAL count_validout : INTEGER;

    --señales lectura dirección
    SIGNAL raddress : INTEGER;
    SIGNAL rbase : INTEGER;
    SIGNAL rdir_deadline : INTEGER;
    CONSTANT raddOffset : INTEGER := (INTEGER(ceil(real(Hc/3))) + 1) * (Ch/K);
    SIGNAL addrOffrow0 : INTEGER;
    SIGNAL addrOffrow1 : INTEGER;
    SIGNAL addcount_row : INTEGER;

    signal sweightaddress: INTEGER;

    --señales escritura
    SIGNAL s_wbank : INTEGER;
    SIGNAL s_waddress : INTEGER;
    SIGNAL waddressoffset : INTEGER;
    SIGNAL s_wmemodd : STD_LOGIC;

    --señales escritura contadores
    SIGNAL wcount_col : INTEGER;
    SIGNAL wcount_ch : INTEGER;
    SIGNAL wcount_row : INTEGER;
    SIGNAL wcount_data : INTEGER;

    --señales escritura bancos
    SIGNAL wbankOffset : INTEGER;

BEGIN

    --ESCRITURA
    weRAM <= we;
    wBank <= s_wbank;
    wmemodd <= s_wmemodd;
    waddress <= s_waddress;

    --LECTURA
    kernelCol <= s_kernelCol;
    kernelrow <= s_kernelRow;
    rmem <= s_rmem;
    rmemodd <= NOT(s_wmemodd);

    address0 <= raddress + addrOffrow0;
    address1 <= raddress + addrOffrow1;
    address2 <= raddress;
    weightaddress <= sweightaddress;

    clk_proc : PROCESS (clk, reset)
    BEGIN
        IF reset = '0' THEN

            Sweightaddress <= 0;

            count_delay <= 0;
            delay <=(layer + 1) * delaymem(layer);

            --lectura
            validOut <= '0';

            oe <= '0';

            rcount_col <= - 2; --desfase
            rcount_ch <= 0;
            rcount_chMEM <= 0;

            rcount_fil <= 0;
            rcount_row <= 0;
            count_validout <= 0;

            s_rmem <= 0;
            s_kernelCol <= 2; --desfase
            s_kernelrow <= 1; --el cero esta en la f1 del kernel

            raddress <= 0;
            rbase <= 0;
            rdir_deadline <= - 2;
            addcount_row <= 0;

            --escritura
            wcount_col <= 0;
            wcount_ch <= 0;
            wcount_data <= 0;

            s_wmemodd <= '1'; --empezamos en la impar
            s_waddress <= 0;
            s_wbank <= 0;
            wbankOffset <= 0;
            waddressoffset <= 0;

        ELSIF rising_edge(clk) THEN

            IF START = '1' THEN
                count_delay <= count_delay + 1;
                IF count_delay = delay - 1 THEN
                    delay <= delaymem(layer);
                    oe <= '1';
                    s_wmemodd <= NOT(s_wmemodd);
                    count_delay <= 0;
                END IF;
            END IF;

            --escritura
            IF we = '1' THEN

                s_wbank <= s_wbank + 1;
                wcount_col <= wcount_col + 1;
                wcount_data <= wcount_data + 1;

                IF s_wbank = wbankOffset + 2 THEN --final del bloque
                    s_wbank <= wbankOffset;
                    s_waddress <= s_waddress + 1;
                END IF;

                IF wcount_data = (Hr * Hc) * (Ch/K) - 1 THEN --ultimo dato
                    wcount_data <= 0;
                    wcount_ch <= 0;
                    wcount_col <= 0;
                    s_waddress <= 0;
                    wbankOffset <= 0;
                    s_wbank <= 0;
                ELSIF wcount_col = Hc - 1 THEN -- final del canal
                    wcount_col <= 0;
                    s_wbank <= wbankOffset;
                    s_waddress <= s_waddress + 1;
                    wcount_ch <= wcount_ch + 1;
                    IF wcount_ch = (Ch/K) - 1 THEN --final de la fila
                        wbankOffset <= wbankOffset + 3;
                        s_wbank <= wbankOffset + 3;
                        s_waddress <= waddressoffset;
                        wcount_ch <= 0;
                        IF wbankOffset = 6 THEN --cada 3 filas
                            s_wbank <= 0; --vuelta al banco 0
                            wbankOffset <= 0;
                            waddressoffset <= s_waddress + 1;
                            s_waddress <= s_waddress + 1;
                        END IF;
                    END IF;
                END IF;
            END IF;
            --lectura

            IF oe = '1' THEN
                --validOut
                count_validout <= count_validout + 1;
                IF rcount_col = (Hc - 1) THEN
                    validOut <= '0';
                ELSIF count_validout >= 1 THEN
                    validOut <= '1';
                    count_validout <= 1;
                END IF;

                --direccionymem
                rdir_deadline <= rdir_deadline + 1;

                IF rdir_deadline = 2 THEN
                    raddress <= raddress + 1;
                    rdir_deadline <= 0;
                END IF;

                IF rcount_col = Hc - 1 THEN --cambia de canal (ya incluye +1 col de padding)
                    raddress <= raddress + 1;
                    rdir_deadline <= - 1;
                    rcount_chMEM <= rcount_chMEM + 1;
                    IF rcount_chMEM = Ch/K - 1 THEN --cambia de memoria AQUI ESTA EL PROBLEMA NO ES SOLO F/K -1 SINO TODOS LOS MÚLTIPLOS
                        rcount_chMEM <= 0;
                        raddress <= rbase;
                        rdir_deadline <= - 1;
                        s_rmem <= s_rmem + 1;
                        IF s_rmem = K - 1 THEN ---cambia de fila y de memoria
                            raddress <= rbase;
                            rdir_deadline <= - 1;
                            s_rmem <= 0;
                            IF rcount_fil = Fnext/Knext - 1 THEN

                                addcount_row <= addcount_row + 1;
                                IF addcount_row = 2 THEN
                                    rbase <= raddress + 1;
                                    addcount_row <= 0;
                                END IF;
                                IF rcount_row = Hr - 1 THEN -- ultimo dato
                                    rbase <= 0;
                                    raddress <= 0;
                                    rdir_deadline <= - 2;
                                    addcount_row <= 0;
                                END IF;
                            END IF;
                        END IF;

                    END IF;
                END IF;

                --contadores lectura
                rcount_col <= rcount_col + 1;
                IF rcount_col = Hc - 1 THEN --cambia de canal (incluye +1 col de padding)
                    rcount_col <= - 1;
                    rcount_ch <= rcount_ch + 1;
                    Sweightaddress <= Sweightaddress + 1;

                    IF rcount_ch = Ch - 1 THEN --cambia de filtro
                        rcount_ch <= 0;
                        rcount_fil <= rcount_fil + 1;
                        
                        IF rcount_fil = Fnext/Knext - 1 THEN ---cambia de fila 
                            rcount_row <= rcount_row + 1;
                            Sweightaddress <= 0;

                            rcount_fil <= 0;
                            IF rcount_row = Hr - 1 THEN -- ultimo dato
                                rcount_row <= 0;
                                rcount_col <= - 2;
                                rcount_ch <= 0;
                                Sweightaddress <= 0;
                                s_rmem <= 0;
                                count_validout <= 0;
                                validOut <= '0';
                                oe <= '0';
                            END IF;
                        END IF;
                    END IF;
                END IF;

                --kernelCol y Row
                CASE s_kernelCol IS
                    WHEN 0 => s_kernelCol <= 1;
                    WHEN 1 => s_kernelCol <= 2;
                    WHEN 2 => s_kernelCol <= 0;
                    WHEN OTHERS => s_kernelCol <= 0;
                END CASE;

                IF rcount_col = Hc - 1 THEN --cambia de canal
                    s_kernelCol <= 0;
                END IF;

                IF s_rmem = K - 1 AND rcount_fil = (Fnext/Knext) - 1 AND rcount_ch = Ch - 1 AND rcount_col = Hc - 1 THEN ---cambia de fila
                    s_kernelrow <= s_kernelrow - 1;
                    IF s_kernelrow = 0 THEN
                        s_kernelrow <= 2;
                    END IF;
                    IF rcount_row = Hr - 1 THEN -- ultimo dato
                        s_kernelrow <= 1;
                        s_kernelCol <= 2;
                    END IF;
                END IF;
            ELSE
                validOut <= '0';
            END IF;
        END IF;
    END PROCESS clk_proc;

    --ReadingAddressOffsets
    addressOffsets : PROCESS (s_kernelRow, rcount_row)
    BEGIN

        CASE s_kernelRow IS
            WHEN 0 =>
                addrOffrow0 <= 0;
                addrOffrow1 <= 0;
            WHEN 1 =>
                addrOffrow0 <= raddOffset;
                addrOffrow1 <= raddOffset;
            WHEN 2 =>
                addrOffrow0 <= raddOffset;
                addrOffrow1 <= 0;
            WHEN OTHERS =>
                addrOffrow0 <= 0;
                addrOffrow1 <= 0;
        END CASE;

        IF rcount_row = 0 THEN
            addrOffrow0 <= 0;
            addrOffrow1 <= 0;
        END IF;
    END PROCESS addressOffsets;

    --padding
    padding_proc : PROCESS (rcount_row, rcount_col, rcount_ch, s_rmem)
    BEGIN
        IF rcount_col =- 2 THEN
            padding <= "111";
        ELSIF rcount_col = Hc - 1 THEN
            padding <= "111";
        ELSIF rcount_row = 0 THEN
            padding <= "100";
            IF rcount_col = Hc THEN
                padding <= "000";
            END IF;
        ELSIF rcount_row = Hr - 1 THEN
            padding <= "001";
            IF rcount_col = Hc THEN
                padding <= "001";
                IF rcount_ch = Ch/K - 1 AND s_rmem = K - 1 THEN
                    padding <= "100";
                END IF;
            END IF;
        ELSIF rcount_row = Hr - 2 AND rcount_col = Hc THEN
            padding <= "001";
        ELSE
            padding <= "000";
        END IF;

    END PROCESS padding_proc;
END arch;