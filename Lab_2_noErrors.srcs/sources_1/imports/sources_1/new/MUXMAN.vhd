library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MUXMAN is
  Port (
    LR, AR, CR, SR : in std_logic_vector(31 downto 0);
    Op : in std_logic_vector(1 downto 0);
    R : out std_logic_vector(31 downto 0)
  );
end MUXMAN;

architecture Structural of MUXMAN is

begin
  with Op select R <=
    LR when "00",
    AR when "01",
    CR when "10",
    SR when "11",
    X"00000000" when others;

end Structural;
