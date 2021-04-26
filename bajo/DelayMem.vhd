--Delay implemented with memories.

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.MATH_REAL.ALL;

library work;
use work.Components.ALL;

entity DelayMem is
	generic(	
	  WL: integer:= 8;			-- Word Length
	  BL: integer:= 64);		   -- Buffer Length
	port(
	  rst:  in  std_logic;
	  clk:  in  std_logic;
	  Din:  in  std_logic_vector(WL -1 downto 0); 
	  Dout: out std_logic_vector(WL -1 downto 0));
end DelayMem;


architecture arch of DelayMem is

begin 

   NoDelay: if BL = 0 generate   
         Dout <= Din;
   end generate;

   GenMem: if BL > 0 generate
      
      type memory is array (nextPow2(BL) -1 downto 0) of std_logic_vector(WL -1 downto 0);
      signal mem: memory;      
      signal rdData:  std_logic_vector(WL - 1 downto 0);
      signal counter: unsigned(bits(BL-1) -1 downto 0);
   
   begin   
   
      Control: process(rst, clk)
         begin
            if rst = '1' then
               counter <= (others => '0');
            elsif rising_edge(clk) then
               if counter = to_unsigned(BL -1 -1,bits(BL-1)) then  
                  counter <= (others =>'0');
               else
                  counter <= counter + 1;
               end if;
            end if;
      end process;
         
   
      RW: process(clk)
         begin
            if rising_edge(clk) then
               mem(to_integer(counter)) <= Din;
               Dout <= rdData; 	            
            end if;
      end process;
          
      rdData <= mem(to_integer(counter));               
   
   end generate;

end arch;
