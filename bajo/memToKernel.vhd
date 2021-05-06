LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

LIBRARY work;
USE work.YOLO_pkg.ALL;

--Este componente recibe los datos de memoria y los ordena según requiera el kernel (incluye el padding)

ENTITY MemToKernel IS
    GENERIC (
        layer : INTEGER := 1);
    PORT (
        clk : IN STD_LOGIC;
        reset : IN STD_LOGIC;
        oe : IN STD_LOGIC;

        padding : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        kernelCol : IN unsinged(1 DOWNTO 0);
        kernelRow : IN unsinged(1 DOWNTO 0);

        Din : IN STD_LOGIC_VECTOR((grid(layer) * bits(layer)) - 1 DOWNTO 0);
        Dout : OUT STD_LOGIC_VECTOR(((grid(layer) * bits(layer))) - 1 DOWNTO 0));
END MemToKernel;

ARCHITECTURE arch OF MemToKernel IS
    SIGNAL dataCol0, dataCol1, dataCol2 : STD_LOGIC_VECTOR(bits(layer) - 1 DOWNTO 0);
    SIGNAL dataRow0, dataRow1, dataRow2 : STD_LOGIC_VECTOR(bits(layer) - 1 DOWNTO 0);
    SIGNAL dataPad0, dataPad1, dataPad2 : STD_LOGIC_VECTOR(bits(layer) - 1 DOWNTO 0);

    SIGNAL D0, D1, D3, D4, D6, D7 : STD_LOGIC_VECTOR(bits(layer) - 1 DOWNTO 0);
BEGIN

    mux1 : PROCESS (kernelCol, Din)
    BEGIN
        CASE kernelCol IS
            WHEN "00" => --MEM 0 MEM 3 MEM 6
                dataCol0 <= Din(bits(layer) - 1 DOWNTO 0);
                dataCol1 <= Din(4 * bits(layer) - 1 DOWNTO 3 * bits(layer));
                dataCol2 <= Din(7 * bits(layer) - 1 DOWNTO 6 * bits(layer));
            WHEN "01" => --MEM 1 MEM 4 MEM 7
                dataCol0 <= Din(2 * bits(layer) - 1 DOWNTO bits(layer));
                dataCol1 <= Din(5 * bits(layer) - 1 DOWNTO 4 * bits(layer));
                dataCol2 <= Din(8 * bits(layer) - 1 DOWNTO 7 * bits(layer));
            WHEN "10" => --MEM 2 MEM 5 MEM 8
                dataCol0 <= Din(3 * bits(layer) - 1 DOWNTO 2 * bits(layer));
                dataCol1 <= Din(6 * bits(layer) - 1 DOWNTO 5 * bits(layer));
                dataCol2 <= Din(9 * bits(layer) - 1 DOWNTO 8 * bits(layer));
            WHEN OTHERS =>
                dataCol0 <= (OTHERS => '0');
                dataCol1 <= (OTHERS => '0');
                dataCol2 <= (OTHERS => '0');
        END CASE;

    END PROCESS mux1;

    mux2 : PROCESS (kernelRow, dataCol0, dataCol1, dataCol2)
    BEGIN
        CASE kernelRow IS --ordena filaMem-filaKernel
            WHEN "00" => -- 0-0 1-1 2-2
                dataRow0 <= dataCol0;
                dataRow1 <= dataCol1;
                dataRow2 <= dataCol2;
            WHEN "01" => -- 0-2 1-0 2-1
                dataRow0 <= dataCol1;
                dataRow1 <= dataCol2;
                dataRow2 <= dataCol0;
            WHEN "10" => -- 0-1 1-2 2-0
                dataRow0 <= dataCol2;
                dataRow1 <= dataCol0;
                dataRow2 <= dataCol1;
            WHEN OTHERS =>
                dataRow0 <= (OTHERS => '0');
                dataRow1 <= (OTHERS => '0');
                dataRow2 <= (OTHERS => '0');
        END CASE;
    END PROCESS mux2;

    padding_proc : PROCESS (padding, dataRow0, dataRow1, dataRow2) --el padding se aplica al final de la seleccion de datos
    BEGIN

        CASE padding IS
            WHEN "111" => --anula la fila de arriba - columna derecha - fila de abajo
                dataPad0 <= (OTHERS => '0');
                dataPad1 <= (OTHERS => '0');
                dataPad2 <= (OTHERS => '0');
            WHEN "100" => --anula la fila de arriba
                dataPad0 <= (OTHERS => '0');
                dataPad1 <= dataRow1;
                dataPad2 <= dataRow2;
            WHEN "001" => --anula la fila de abajo
                dataPad0 <= dataRow0;
                dataPad1 <= dataRow1;
                dataPad2 <= (OTHERS => '0');
            WHEN OTHERS =>
                dataPad0 <= dataRow0;
                dataPad1 <= dataRow1;
                dataPad2 <= dataRow2;
        END CASE;
    END PROCESS padding_proc;

    kernelmem : PROCESS (clk, reset) --una vez ordenado los datos e implementado el padding se meten al kernel
    BEGIN
        IF reset = '0' THEN
            D0 <= (OTHERS => '0');
            D1 <= (OTHERS => '0');
            D3 <= (OTHERS => '0');
            D4 <= (OTHERS => '0');
            D6 <= (OTHERS => '0');
            D7 <= (OTHERS => '0');
        ELSIF rising_edge(clk) THEN
            IF oe = '1' THEN
                D0 <= D1;
                D3 <= D4;
                D6 <= D7;
                D1 <= dataPad0;
                D4 <= dataPad1;
                D7 <= dataPad2;
            END IF;
        END IF;
    END PROCESS kernelmem;

    Dout <= dataPad2 & D7 & D6 & dataPad1 & D4 & D3 & dataPad0 & D1 & D0; --salida final

END arch;