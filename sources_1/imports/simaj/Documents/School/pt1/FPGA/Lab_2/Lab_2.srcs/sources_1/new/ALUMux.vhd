library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ALUMux is
    Port ( A : in STD_LOGIC_VECTOR (31 downto 0);
           B : in STD_LOGIC_VECTOR (31 downto 0);
           C : in STD_LOGIC_VECTOR (31 downto 0);
           ALUop : in STD_LOGIC_VECTOR (1 downto 0);
           R : out STD_LOGIC_VECTOR (31 downto 0);
           D : in STD_LOGIC_VECTOR (31 downto 0));
end ALUMux;

architecture Behavioral of ALUMux is

begin
PROCESS(A,B,C,D,ALUop)
    BEGIN
        CASE ALUop IS 
            WHEN "00" => R <= A;
            WHEN "01" => R <= B;
            WHEN "10" => R <= C;
            WHEN "11" => R <= D;
            WHEN OTHERS => NULL;
        END CASE;
   END PROCESS;
end Behavioral;
