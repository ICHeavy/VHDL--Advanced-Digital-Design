library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity SHIFT is
  Port (
    A : in std_logic_vector(31 downto 0);
    SHAMT : in std_logic_vector(4 downto 0);
    Op: in std_logic_vector(1 downto 0);
    R : out std_logic_vector(31 downto 0)
  );
end SHIFT;

architecture Structural of SHIFT is
    signal L0, L1, L2, L3, L4, R0, R1, R2, R3, R4, FILLGUY : std_logic_vector(31 downto 0);
begin

  -- Shift left flow
  L0 <= A(30 downto 0) & "0" when SHAMT(0) = '1' else A;
  L1 <= L0(29 downto 0) & "00" when SHAMT(1) = '1' else L0;
  L2 <= L1(27 downto 0) & "0000" when SHAMT(2) = '1' else L1;
  L3 <= L2(23 downto 0) & "00000000" when SHAMT(3) = '1' else L2;
  L4 <= L3(15 downto 0) & "0000000000000000" when SHAMT(4) = '1' else L3;
  
  -- Check Op(0) with FILL
  FILLGUY <= (others => Op(0) and A(31));
  
  -- Shift right flow
  R0 <= FILLGUY(0) & A(31 downto 1) when SHAMT(0)='1' else A;
  R1 <= FILLGUY(1 downto 0) & R0(31 downto 2) when SHAMT(1) = '1' else R0;
  R2 <= FILLGUY(3 downto 0) & R1(31 downto 4) when SHAMT(2) = '1' else R1;
  R3 <= FILLGUY(7 downto 0) & R2(31 downto 8) when SHAMT(3) = '1' else R2;
  R4 <= FILLGUY(15 downto 0) & R3(31 downto 16) when SHAMT(4) = '1' else R3;
  
  -- Check Op(1) and assign R
  R <= R4 when Op(1) = '1' else L4;

end Structural;
