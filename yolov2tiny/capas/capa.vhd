LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

LIBRARY work;
USE work.YOLO_pkg.ALL;

ENTITY capa IS
    GENERIC (layer : INTEGER := 2);
    PORT (
        clk : IN STD_LOGIC;
        reset : IN STD_LOGIC;

        start : IN STD_LOGIC);
END capa;

ARCHITECTURE rtl OF capa IS

    CONSTANT rst_val : STD_LOGIC := '0';

    COMPONENT MemControl
        GENERIC (
            layer : INTEGER);
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

            weRAM : OUT STD_LOGIC;
            wMemOdd : OUT STD_LOGIC;
            wBank : OUT INTEGER;
            waddress : OUT INTEGER);
    END COMPONENT;

    COMPONENT ConvControl
        GENERIC (
            layer : INTEGER
        );
        PORT (
            clk : IN STD_LOGIC;
            reset : IN STD_LOGIC;

            validIn : IN STD_LOGIC;

            startLBuffer : OUT STD_LOGIC;
            enableLBuffer : OUT STD_LOGIC;

            validOut : OUT STD_LOGIC
        );

    END COMPONENT;

    COMPONENT MPcontrol
        GENERIC (
            Layer : INTEGER
        );
        PORT (
            clk : IN STD_LOGIC;
            reset : IN STD_LOGIC;

            validIn : IN STD_LOGIC;

            val_d1 : OUT STD_LOGIC;
            enLBuffer : OUT STD_LOGIC;

            validOut : OUT STD_LOGIC
        );
    END COMPONENT;

    SIGNAL outmem : STD_LOGIC;
    SIGNAL outCV : STD_LOGIC;
    SIGNAL outMP : STD_LOGIC;

    SIGNAL read_count : INTEGER;
    SIGNAL write_count : INTEGER;
BEGIN

    Rmem : MemControl
    GENERIC MAP(LAYER => LAYER - 1)
    PORT MAP(
        clk => clk, reset => reset,
        start => start, we => '0',
        rmem => OPEN,
        rmemodd => OPEN,
        address0 => OPEN,
        address1 => OPEN,
        address2 => OPEN,
        padding => OPEN,
        kernelCol => OPEN,
        kernelrow => OPEN,
        validout => outmem,
        weram => OPEN,
        wmemodd => OPEN,
        wBank => OPEN,
        waddress => OPEN
    );

    ConvLX : ConvControl
    GENERIC MAP(Layer => Layer)
    PORT MAP(
        clk => clk, reset => reset,
        validIn => outmem,
        startLBuffer => OPEN, enableLBuffer => OPEN,
        validOut => outCV);

    MPL : MPControl
    GENERIC MAP(Layer => layer) --X EL NUMERO DE F
    PORT MAP(
        clk => clk,
        reset => reset,
        validIn => outCV,
        val_d1 => OPEN, enLBuffer => OPEN,
        validOut => outMP
    );
    Wmem : MemControl
    GENERIC MAP(LAYER => LAYER)
    PORT MAP(
        clk => clk, reset => reset,
        start => start, we => outMP,
        rmem => OPEN,
        rmemodd => OPEN,
        address0 => OPEN,
        address1 => OPEN,
        address2 => OPEN,
        padding => OPEN,
        kernelCol => OPEN,
        kernelrow => OPEN,
        validout => OPEN,
        weram => OPEN,
        wmemodd => OPEN,
        wBank => OPEN,
        waddress => OPEN
    );

    proc_name : PROCESS (clk, reset)
    BEGIN
        IF reset = '0' THEN
            read_count <= 0;
            write_count <= 0;
        ELSIF rising_edge(clk) THEN


            IF outMP = '1' THEN
                write_count <= write_count + 1;
            END IF;
        END IF;
    END PROCESS proc_name;
END ARCHITECTURE rtl;