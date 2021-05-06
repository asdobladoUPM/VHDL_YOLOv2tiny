LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

LIBRARY work;
USE work.YOLO_pkg.ALL;

--Bloque de datapath para la memoria de la capa 9
--no tiene memoria de pesos
--no tiene kernel
--saca un dato a la vez
--saca un dato solo una vez

ENTITY MemDPLL IS
    GENERIC (
        layer : INTEGER := 4);
    PORT (
        clk : IN STD_LOGIC;
        reset : IN STD_LOGIC;

        oe : IN STD_LOGIC;
        rMem : IN INTEGER;
        rbank : IN INTEGER;

        rMemOdd : IN STD_LOGIC;
        raddress : IN INTEGER;

        Din : IN STD_LOGIC_VECTOR((kernels(layer) * bits(layer)) - 1 DOWNTO 0);

        we : IN STD_LOGIC;
        wMemOdd : IN STD_LOGIC;
        wBank : IN INTEGER;
        waddress : IN INTEGER;

        DataOut : OUT STD_LOGIC_VECTOR(bits(layer) - 1 DOWNTO 0));
END MemDPLL;

ARCHITECTURE arch OF MemDPLL IS

    CONSTANT bits : INTEGER := bits(layer);
    CONSTANT bitsAddress : INTEGER := bitsAddress(layer);

    COMPONENT RAM
        GENERIC (
            WL : INTEGER := 8; -- Word Length
            bitsAddress : INTEGER := 64); -- Address Length
        PORT (
            clk : IN STD_LOGIC;

            we : IN STD_LOGIC;

            Din : IN STD_LOGIC_VECTOR(WL - 1 DOWNTO 0);
            rAddr : IN STD_LOGIC_VECTOR(bitsAddress - 1 DOWNTO 0);
            wAddr : IN STD_LOGIC_VECTOR(bitsAddress - 1 DOWNTO 0);

            Dout : OUT STD_LOGIC_VECTOR(WL - 1 DOWNTO 0));
    END COMPONENT;

    TYPE vectordataOutRAM IS ARRAY (kernels(layer) - 1 DOWNTO 0) OF STD_LOGIC_VECTOR((9 * bits) - 1 DOWNTO 0);

    SIGNAL DataOutRAModd : vectordataOutRAM;
    SIGNAL DataOutRAMeven : vectordataOutRAM;
    SIGNAL DataOutRAM : vectordataOutRAM;

    SIGNAL weRAModd : STD_LOGIC_VECTOR(8 DOWNTO 0);
    SIGNAL weEXT : STD_LOGIC_VECTOR(8 DOWNTO 0);
    SIGNAL rmemoddEXT : STD_LOGIC_VECTOR(8 DOWNTO 0);
    SIGNAL wMemOddEXT : STD_LOGIC_VECTOR(8 DOWNTO 0);
    SIGNAL weRAMeven : STD_LOGIC_VECTOR(8 DOWNTO 0);
    SIGNAL weBank : STD_LOGIC_VECTOR(8 DOWNTO 0);

    SIGNAL std_waddress : STD_LOGIC_VECTOR(bitsAddress - 1 DOWNTO 0);
    SIGNAL std_raddress : STD_LOGIC_VECTOR((9 * bitsAddress) - 1 DOWNTO 0);

BEGIN
    weEXT <= (OTHERS => we);
    wMemOddEXT <= (OTHERS => wmemodd);
    weRAModd <= weEXT AND weBank AND wMemOddEXT;
    weRAMeven <= weEXT AND weBank AND NOT(wMemOddEXT);

    std_waddress <= STD_LOGIC_VECTOR(to_unsigned(waddress, bitsAddress));

    std_raddress <= STD_LOGIC_VECTOR(to_unsigned(raddress, bitsAddress));

    block_gen : FOR I IN 0 TO kernels(layer) - 1 GENERATE
    
        mem_gen : FOR J IN 0 TO 8 GENERATE

            mem_odd : RAM GENERIC MAP(WL => bits, bitsAddress => bitsAddress)
            PORT MAP(
                clk => clk, we => weRAModd(J),
                Din => Din((I + 1) * bits - 1 DOWNTO I * bits),
                rAddr => std_raddress,
                wAddr => std_waddress,
                Dout => DataOutRAModd(I)(((J + 1) * bits) - 1 DOWNTO J * bits));

            mem_even : RAM GENERIC MAP(WL => bits, bitsAddress => bitsAddress)
            PORT MAP(
                clk => clk, we => weRAMeven(J),
                Din => Din((I + 1) * bits - 1 DOWNTO I * bits),
                rAddr => std_raddress,
                wAddr => std_waddress,
                Dout => DataOutRAMeven(I)(((J + 1) * bits) - 1 DOWNTO J * bits));
        END GENERATE mem_gen;
    END GENERATE block_gen;

        --CONVERSION WEBANK A VECTOR

    webank_proc : PROCESS (wBank, we)
    BEGIN
        CASE wbank IS
            WHEN 0 => webank <= "000000001";
            WHEN 1 => webank <= "000000010";
            WHEN 2 => webank <= "000000100";
            WHEN 3 => webank <= "000001000";
            WHEN 4 => webank <= "000010000";
            WHEN 5 => webank <= "000100000";
            WHEN 6 => webank <= "001000000";
            WHEN 7 => webank <= "010000000";
            WHEN 8 => webank <= "100000000";
            WHEN OTHERS => webank <= (OTHERS => '0');
        END CASE;
    END PROCESS webank_proc;

    --SELECCION DE SALIDA 

    dataout_proc : PROCESS (rmemodd, DataOutRAModd, DataOutRAMeven)
    BEGIN
        CASE rmemodd IS
            WHEN '1' =>
                DataOutRAM <= DataOutRAModd;
            WHEN '0' =>
                DataOutRAM <= DataOutRAMeven;
            WHEN OTHERS =>
                DataOutRAM <= (OTHERS => (OTHERS => '0'));
        END CASE;
    END PROCESS dataout_proc;

    DataOut <= DataOutRAM(Rmem)(((Rbank + 1) * bits) - 1 DOWNTO Rbank * bits);
END arch;