library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity sign_extend is
  Port (
    s_In : in std_logic_vector(15 downto 0);
    s_Out : out std_logic_vector(31 downto 0)
  );
end sign_extend;

architecture Structural of sign_extend is

begin

  with s_In(15) select
    s_Out <= x"FFFF" & s_In when '1',
             x"0000" & s_In when '0',
             x"AAAAAAAA" when others; -- EZ DEBUG

end Structural;
