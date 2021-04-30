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

    COMPONENT MemDP
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

            Din : IN STD_LOGIC_VECTOR((kernels(layer) * bits(layer)) - 1 DOWNTO 0);
            we : IN STD_LOGIC;
            wMemOdd : IN STD_LOGIC;
            wBank : IN INTEGER;
            waddress : IN INTEGER;

            Dout : OUT STD_LOGIC_VECTOR((9 * bits(layer)) - 1 DOWNTO 0));
    END COMPONENT;

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

BEGIN

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

END ARCHITECTURE rtl;