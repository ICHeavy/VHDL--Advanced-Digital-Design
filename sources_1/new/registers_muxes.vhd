library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity registers_muxes is
  Port (
    enMult, enA, enB, enMem, enALUOut, rst, clk : in std_logic;
    Ain, Bin, Mem_in, ALUOut_in : in std_logic_vector(31 downto 0);
    MultRegsIn : in std_logic_vector(63 downto 0);
    mult_Hi_out, mult_Lo_out, Aout, Bout, MemD_out, ALUOut_out : out std_logic_vector(31 downto 0)
  );
end registers_muxes;

architecture Sequential of registers_muxes is

begin
  process (rst, clk) begin
    if rst = '1' then
      Aout <= (others => '0');
      Bout <= (others => '0');
      MemD_out <= (others => '0');
      ALUOut_out <= (others => '0');
      mult_Hi_out <= (others => '0');
      mult_Lo_out <= (others => '0');
      
    elsif (clk'event and clk = '1') then
      if (enA = '1') then
        Aout <= Ain;
      end if;
      
      if (enB = '1') then
        Bout <= Bin;
      end if;
      
      if (enMem = '1') then
        MemD_out <= Mem_in;
      end if;
      
      if (enALUOut = '1') then
        ALUOut_out <= ALUOut_in;
      end if;

      if (enMult = '1') then
        mult_Hi_out <= MultRegsIn(63 downto 32);
        mult_Lo_out <= MultRegsIn(31 downto 0);
      end if;
    end if;
  end process;

end Sequential;
