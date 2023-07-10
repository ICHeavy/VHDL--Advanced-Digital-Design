library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity SRreg is
  Port (
    D : in std_logic_vector(31 downto 0);
    clk : in std_logic;
    rst : in std_logic;
    en : in std_logic;
    load : in std_logic;
    Q : out std_logic_vector(31 downto 0)
  );
end SRreg;

architecture Sequential of SRreg is

signal temp : std_logic_vector(31 downto 0);

begin

  process (rst, clk)
  
  begin
  --rst
    if rst = '1' then
      temp <= (others => '0');
   
  --on rising edge
    elsif (clk'event and clk = '1') then
      -- no shift
      if (load = '1' and en = '1') then
        temp <= D;
       -- unsigned SR
      elsif (load = '0' and en = '1') then
        temp <= '0' & temp(31 downto 1);
      end if;
    end if;
  end process;
  Q <= temp;
  
end Sequential;
