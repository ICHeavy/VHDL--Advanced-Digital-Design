library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity register_file is
  Port ( 
    addrA, addrB, addrW: in std_logic_vector(4 downto 0);
    data_in : in std_logic_vector(31 downto 0);
    enWrite, rst, clk : in std_logic;
    readA, readB : out std_logic_vector(31 downto 0)
  );
end register_file;

architecture Structural of register_file is
-- MAKE ARRAY OF 32X32BITS
  type regs is array (0 to 31) of std_logic_vector(31 downto 0);
  signal selW, selA, selB : integer range 0 to 31;
  signal reg_arr : regs;
 
begin
-- MAP INPUTS
  selW <= to_integer(unsigned(addrW));
  selA <= to_integer(unsigned(addrA));
  selB <= to_integer(unsigned(addrB));
  
  readA <= reg_arr(selA);
  readB <= reg_arr(selB);

--ONLY WORK ON clk & RST
  process (rst, clk, enWrite) begin
    if rst = '1' then
      reg_arr <= (others => (others => '0'));
    elsif (clk'event and clk = '1') then
      if (enWrite ='1') then
        reg_arr(selW) <= data_in;
      end if;
    end if;
  end process;
             
end Structural;
