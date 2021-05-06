LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE IEEE.math_real.ALL;

LIBRARY work;
USE work.YOLO_pkg.ALL;

--Bloque de datapath para la memoria de la capa 0(input) a la 8

ENTITY MemDP IS
    GENERIC (
        layer : INTEGER := 4);
    PORT (
        clk : IN STD_LOGIC;
        reset : IN STD_LOGIC;

        rMem : IN INTEGER;
        rMemOdd : IN STD_LOGIC;
        address0 : IN INTEGER;
        address1 : IN INTEGER;
        address2 : IN INTEGER;
        padding : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        kernelCol : IN INTEGER;
        kernelRow : IN INTEGER;
        ValidIN : IN STD_LOGIC;

        Din : IN STD_LOGIC_VECTOR((9 * 6) - 1 DOWNTO 0);
        we : IN STD_LOGIC;
        wMemOdd : IN STD_LOGIC;
        wBank : IN INTEGER;
        waddress : IN INTEGER;

        Dout : OUT STD_LOGIC_VECTOR((9 * 6) - 1 DOWNTO 0);

        Weightaddress : IN INTEGER;
        Weights : OUT STD_LOGIC_VECTOR((9 * weightbits(layer + 1)) - 1 DOWNTO 0));
END MemDP;

ARCHITECTURE arch OF MemDP IS

    CONSTANT bits : INTEGER := 6; --bits de datos
    CONSTANT bitsAddress : INTEGER := bitsAddress(layer);

    CONSTANT weightbits : INTEGER := (9 * weightbits(layer + 1)); --bits de pesos para la siguiente etapa
    CONSTANT weightbitaddress : INTEGER := weightsbitsAddress(layer + 1);

    COMPONENT MemToKernel
        GENERIC (
            layer : INTEGER := 1);
        PORT (
            clk : IN STD_LOGIC;
            reset : IN STD_LOGIC;
            oe : IN STD_LOGIC;

            padding : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            kernelCol : IN INTEGER;
            kernelRow : IN INTEGER;

            Din : IN STD_LOGIC_VECTOR((grid(layer) * bits) - 1 DOWNTO 0);
            Dout : OUT STD_LOGIC_VECTOR((grid(layer) * bits) - 1 DOWNTO 0));
    END COMPONENT;

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

    SIGNAL DataOutRAM : STD_LOGIC_VECTOR((grid(layer) * bits) - 1 DOWNTO 0);
    TYPE vectordataOutRAM IS ARRAY (kernels(layer) - 1 DOWNTO 0) OF STD_LOGIC_VECTOR((grid(layer) * bits) - 1 DOWNTO 0);

    SIGNAL vDataOutRAModd : vectordataOutRAM;
    SIGNAL vDataOutRAMeven : vectordataOutRAM;
    SIGNAL vDataOutRAM : vectordataOutRAM;
    SIGNAL weRAModd : STD_LOGIC_VECTOR(8 DOWNTO 0);
    SIGNAL weEXT : STD_LOGIC_VECTOR(8 DOWNTO 0);
    SIGNAL rmemoddEXT : STD_LOGIC_VECTOR(8 DOWNTO 0);
    SIGNAL wMemOddEXT : STD_LOGIC_VECTOR(8 DOWNTO 0);
    SIGNAL weRAMeven : STD_LOGIC_VECTOR(8 DOWNTO 0);
    SIGNAL weBank : STD_LOGIC_VECTOR(8 DOWNTO 0);

    SIGNAL std_waddress : STD_LOGIC_VECTOR(bitsAddress - 1 DOWNTO 0);
    SIGNAL std_raddress : STD_LOGIC_VECTOR((9 * bitsAddress) - 1 DOWNTO 0);
    SIGNAL std_address0 : STD_LOGIC_VECTOR(bitsAddress - 1 DOWNTO 0);
    SIGNAL std_address1 : STD_LOGIC_VECTOR(bitsAddress - 1 DOWNTO 0);
    SIGNAL std_address2 : STD_LOGIC_VECTOR(bitsAddress - 1 DOWNTO 0);
    SIGNAL std_wadd : STD_LOGIC_VECTOR(bitsAddress - 1 DOWNTO 0);
BEGIN

    std_wadd <= STD_LOGIC_VECTOR(TO_UNSIGNED(Weightaddress, weightbitaddress));
    weEXT <= (OTHERS => we);
    wMemOddEXT <= (OTHERS => wmemodd);
    weRAModd <= weEXT AND weBank AND wMemOddEXT;
    weRAMeven <= weEXT AND weBank AND NOT(wMemOddEXT);

    std_waddress <= STD_LOGIC_VECTOR(to_unsigned(waddress, bitsAddress));

    std_address0 <= STD_LOGIC_VECTOR(to_unsigned(address0, bitsAddress));
    std_address1 <= STD_LOGIC_VECTOR(to_unsigned(address1, bitsAddress));
    std_address2 <= STD_LOGIC_VECTOR(to_unsigned(address2, bitsAddress));

    std_raddress <= std_address2 & std_address2 & std_address2 & std_address1 & std_address1 & std_address1 & std_address0 & std_address0 & std_address0;

    --KERNEL
    MemToKernelBlock : MemToKernel
    GENERIC MAP(Layer => Layer)
    PORT MAP(
        clk => clk, reset => reset, oe => ValidIN, padding => padding,
        kernelCol => kernelCol, kernelRow => kernelRow, Din => DataOutRam, Dout => Dout);

    --BLOQUES DE MEMORIA
    block_gen : FOR I IN 0 TO kernels(layer) - 1 GENERATE

        --BANCOS DE MEMORIA
        mem_gen : FOR J IN 0 TO 8 GENERATE
            --IMPAR
            mem_odd : RAM GENERIC MAP(WL => bits, bitsAddress => bitsAddress)
            PORT MAP(
                clk => clk, we => weRAModd(J),
                Din => Din((I + 1) * bits - 1 DOWNTO I * bits),
                rAddr => std_raddress((J + 1) * bitsAddress - 1 DOWNTO J * bitsAddress),
                wAddr => std_waddress,
                Dout => vDataOutRAModd(I)(((J + 1) * bits) - 1 DOWNTO J * bits));

            --PAR
            mem_even : RAM GENERIC MAP(WL => bits, bitsAddress => bitsAddress)
            PORT MAP(
                clk => clk, we => weRAMeven(J),
                Din => Din((I + 1) * bits - 1 DOWNTO I * bits),
                rAddr => std_raddress((J + 1) * bitsAddress - 1 DOWNTO J * bitsAddress),
                wAddr => std_waddress,
                Dout => vDataOutRAMeven(I)(((J + 1) * bits) - 1 DOWNTO J * bits));
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

    dataout_proc : PROCESS (rmemodd, vDataOutRAModd, vDataOutRAMeven)
    BEGIN
        CASE rmemodd IS
            WHEN '1' =>
                vDataOutRAM <= vDataOutRAModd;
            WHEN '0' =>
                vDataOutRAM <= vDataOutRAMeven;
            WHEN OTHERS =>
                vDataOutRAM <= (OTHERS => (OTHERS => '0'));
        END CASE;
    END PROCESS dataout_proc;

    DataOutRAM <= vDataOutRAM(RMEM);

    --MEMORIA DE PESOS

    mem_weights : RAM
    GENERIC MAP(WL => weightbits, bitsAddress => weightbitaddress)
    PORT MAP(
        clk => clk, we => '0',
        Din => (OTHERS => '0'),
        rAddr => std_wadd,
        wAddr => (OTHERS => '0'),
        Dout => Weights);

END arch;