LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

LIBRARY work;
USE work.YOLO_pkg.ALL;

ENTITY MemLayer IS
    GENERIC (
        layer : INTEGER := 4);
    PORT (
        clk : IN STD_LOGIC;
        reset : IN STD_LOGIC;

        oe : IN STD_LOGIC;
        rMem : IN INTEGER;
        rMemOdd : IN STD_LOGIC;
        address0 : IN INTEGER;
        address1 : IN INTEGER;
        address2 : IN INTEGER;

        padding : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        kernelCol : IN INTEGER;
        kernelRow : IN INTEGER;

        Din : IN STD_LOGIC_VECTOR((kernels(layer) * bits(layer)) - 1 DOWNTO 0);
        we : IN STD_LOGIC;
        wMemOdd : IN STD_LOGIC;
        wBank : IN INTEGER;
        waddress : IN INTEGER;

        Dout : OUT STD_LOGIC_VECTOR((9 * bits(layer)) - 1 DOWNTO 0));
END MemLayer;

ARCHITECTURE arch OF MemLayer IS

    CONSTANT bits : INTEGER := bits(layer);
    CONSTANT bitsAddress : INTEGER := bitsAddress(layer);

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
            oe : IN STD_LOGIC;
            we : IN STD_LOGIC;

            Din : IN STD_LOGIC_VECTOR(WL - 1 DOWNTO 0);
            rAddr : IN STD_LOGIC_VECTOR(bitsAddress - 1 DOWNTO 0);
            wAddr : IN STD_LOGIC_VECTOR(bitsAddress - 1 DOWNTO 0);

            Dout : OUT STD_LOGIC_VECTOR(WL - 1 DOWNTO 0));
    END COMPONENT;

    SIGNAL DataOutRAM : STD_LOGIC_VECTOR((grid(layer) * bits) - 1 DOWNTO 0);
    SIGNAL DataOutRAModd : STD_LOGIC_VECTOR((grid(layer) * bits) - 1 DOWNTO 0);
    SIGNAL DataOutRAMeven : STD_LOGIC_VECTOR((grid(layer) * bits) - 1 DOWNTO 0);

    SIGNAL oeRAModd : STD_LOGIC_VECTOR(8 DOWNTO 0);
    SIGNAL oeRAMeven : STD_LOGIC_VECTOR(8 DOWNTO 0);
    SIGNAL oeEXT : STD_LOGIC_VECTOR(8 DOWNTO 0);

    SIGNAL weRAModd : STD_LOGIC_VECTOR(8 DOWNTO 0);
    SIGNAL weEXT : STD_LOGIC_VECTOR(8 DOWNTO 0);
    SIGNAL rmemoddEXT : STD_LOGIC_VECTOR(8 DOWNTO 0);
    SIGNAL wMemOddEXT : STD_LOGIC_VECTOR(8 DOWNTO 0);
    SIGNAL weRAMeven : STD_LOGIC_VECTOR(8 DOWNTO 0);
    SIGNAL weBank : STD_LOGIC_VECTOR(8 DOWNTO 0);

    SIGNAL std_waddress : STD_LOGIC_VECTOR(bitsAddress - 1 DOWNTO 0);
    SIGNAL std_raddress : STD_LOGIC_VECTOR((9 * bitsAddress) - 1 DOWNTO 0);
    SIGNAL std_rmem : STD_LOGIC_VECTOR(8 DOWNTO 0);
    SIGNAL std_address0 : STD_LOGIC_VECTOR(bitsAddress - 1 DOWNTO 0);
    SIGNAL std_address1 : STD_LOGIC_VECTOR(bitsAddress - 1 DOWNTO 0);
    SIGNAL std_address2 : STD_LOGIC_VECTOR(bitsAddress - 1 DOWNTO 0);

BEGIN
    oeEXT <= (OTHERS => oe);
    rmemoddEXT <= (OTHERS => rmemodd);
    oeRAModd <= oeEXT AND rmemoddEXT AND std_rmem;
    oeRAMeven <= oeEXT AND (NOT(rmemoddEXT)) AND std_rmem;

    weEXT <= (OTHERS => we);
    wMemOddEXT <= (OTHERS => wmemodd);
    weRAModd <= weEXT AND weBank AND wMemOddEXT;
    weRAMeven <= weEXT AND weBank AND NOT(wMemOddEXT);

    std_waddress <= STD_LOGIC_VECTOR(to_unsigned(waddress, bitsAddress));

    std_address0 <= STD_LOGIC_VECTOR(to_unsigned(address0, bitsAddress ));
    std_address1 <= STD_LOGIC_VECTOR(to_unsigned(address1, bitsAddress ));
    std_address2 <= STD_LOGIC_VECTOR(to_unsigned(address2, bitsAddress ));

    std_raddress <= std_address2 & std_address2 & std_address2 & std_address1 & std_address1 & std_address1 & std_address0 & std_address0 & std_address0;

    MemToKernelBlock : MemToKernel
    GENERIC MAP(Layer => Layer)
    PORT MAP(
        clk => clk, reset => reset, oe => oe, padding => padding,
        kernelCol => kernelCol, kernelRow => kernelRow, Din => DataOutRam, Dout => Dout);

    block_gen : FOR I IN 0 TO kernels(layer) - 1 GENERATE
        mem_gen : FOR J IN 0 TO 8 GENERATE

            mem_odd : RAM GENERIC MAP(WL => bits, bitsAddress => bitsAddress)
            PORT MAP(
                clk => clk, oe => oeRAModd(I), we => weRAModd(J),
                Din => Din((I + 1) * bits - 1 DOWNTO I * bits),
                rAddr => std_raddress((J + 1) * bits - 1 DOWNTO J * bits),
                wAddr => std_waddress,
                Dout => DataOutRAModd(((J + 1) * bits) - 1 DOWNTO J * bits));

            mem_even : RAM GENERIC MAP(WL => bits, bitsAddress => bitsAddress)
            PORT MAP(
                clk => clk, oe => oeRAMeven(I), we => weRAMeven(J),
                Din => Din((I + 1) * bits - 1 DOWNTO I * bits),
                rAddr => std_raddress((J + 1) * bits - 1 DOWNTO J * bits),
                wAddr => std_waddress,
                Dout => DataOutRAMeven(((J + 1) * bits) - 1 DOWNTO J * bits));
        END GENERATE mem_gen;
    END GENERATE block_gen;

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

    rmem_proc : PROCESS (rmem)
    BEGIN
        CASE rmem IS
            WHEN 0 => std_rmem <= "000000001";
            WHEN 1 => std_rmem <= "000000010";
            WHEN 2 => std_rmem <= "000000100";
            WHEN 3 => std_rmem <= "000001000";
            WHEN 4 => std_rmem <= "000010000";
            WHEN 5 => std_rmem <= "000100000";
            WHEN 6 => std_rmem <= "001000000";
            WHEN 7 => std_rmem <= "010000000";
            WHEN 8 => std_rmem <= "100000000";
            WHEN OTHERS => std_rmem <= (OTHERS => '0');
        END CASE;
    END PROCESS rmem_proc;

    dataout_proc : PROCESS (rmemodd)
    BEGIN
        CASE rmemodd IS
            WHEN '1' =>
                DataOutRAM <= DataOutRAModd;
            WHEN '0' =>
                DataOutRAM <= DataOutRAMeven;
            WHEN OTHERS =>
                DataOutRAM <= (OTHERS => '0');
        END CASE;
    END PROCESS dataout_proc;
END arch;