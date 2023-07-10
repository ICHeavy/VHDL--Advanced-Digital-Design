library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ALUShift is
    Port ( A : in STD_LOGIC_VECTOR (31 downto 0);
           SHAMT : in STD_LOGIC_VECTOR (4 downto 0);
           ALUop : in STD_LOGIC_VECTOR (1 downto 0);
           R : out STD_LOGIC_VECTOR (31 downto 0));
end ALUShift;

architecture Behavioral of ALUShift is

begin
PROCESS(A, SHAMT, ALUop)
BEGIN
    CASE ALUop IS 
        WHEN "00" => R <= STD_LOGIC_VECTOR(UNSIGNED(A) SLL TO_INTEGER(UNSIGNED(SHAMT)));
        WHEN "01" => R <= STD_LOGIC_VECTOR(UNSIGNED(A) ROL TO_INTEGER(UNSIGNED(SHAMT)));
        WHEN "10" => R <= STD_LOGIC_VECTOR(UNSIGNED(A) SRL TO_INTEGER(UNSIGNED(SHAMT)));
        WHEN "11" => R <= STD_LOGIC_VECTOR(UNSIGNED(A) ROR TO_INTEGER(UNSIGNED(SHAMT)));
        WHEN OTHERS => NULL;
    END CASE;
END PROCESS;
end Behavioral;
