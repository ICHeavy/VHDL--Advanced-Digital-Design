library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity SLreg is
  Port (
    D : in std_logic_vector(31 downto 0);
    clk : in std_logic; 
    rst : in std_logic;
    en : in std_logic;
    load : in std_logic;
    Q : out std_logic_vector(63 downto 0)
  );
end SLreg;

architecture Sequential of SLreg is

signal TEMPGUY : std_logic_vector(63 downto 0);

begin
  process (CLK, RST) 
  begin
  --rst
    if (rst = '1') then
      TEMPGUY <= (others => '0');
     
    elsif (clk'event and clk = '1') then
        -- on rising edge
      if (load = '1' and en = '1') then
      -- no shift
        TEMPGUY <= X"00000000" & D; -- D + extra bits
      elsif (load = '0' and en = '1') then
        -- Unsigned SL
        TEMPGUY <= TEMPGUY(62 downto 0) & '0';
      end if;
    end if;
  end process;
  Q <= TEMPGUY;
  
end Sequential;
