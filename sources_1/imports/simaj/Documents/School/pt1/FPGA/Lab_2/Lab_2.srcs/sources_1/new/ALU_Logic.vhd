library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ALU_Logic is
    Port ( A : in STD_LOGIC_VECTOR (31 downto 0);
           B : in STD_LOGIC_VECTOR (31 downto 0);
       ALUop : in STD_LOGIC_VECTOR (1 downto 0);
           S : out STD_LOGIC_VECTOR (31 downto 0));
end ALU_Logic;

architecture Behavioral of ALU_Logic is
begin
    PROCESS(A,B,ALUop)
        BEGIN
            Case ALUop is 
                when "00" => S <= A and B;
                when "01" => S <= A or B;
                when "10" => S <= A xor B;
                when "11" => S <= A nor B;
                when others => NULL;
        END CASE;
    END PROCESS;
end Behavioral;
