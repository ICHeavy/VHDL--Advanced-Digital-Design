library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity COMP is
  Port (
    ALUOp : in std_logic_vector(1 downto 0);
    A   : in std_logic;
    B   : in std_logic;
    CARRY : in std_logic;
    S : in std_logic;
    R : out std_logic_vector(31 downto 0)
  );
end COMP;

architecture Structural of COMP is

  signal tempguy : std_logic_vector(5 downto 0);
  
begin
  -- setting temp to the 6 table bits and filling R with zeros
  tempguy <= ALUOp & A & B & S & CARRY;
  
  -- comparing the 6 bits
  R <= 
  X"00000001" when std_match(tempguy, "10001-") else
  X"00000001" when std_match(tempguy, "10111-") else
  X"00000001" when std_match(tempguy, "1010--") else
  X"00000001" when std_match(tempguy, "11---0") else
  X"00000000";
  
end Structural;
