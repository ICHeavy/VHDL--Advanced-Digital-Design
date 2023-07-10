library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ALUComp is
    Port ( A : in STD_LOGIC;
           B : in STD_LOGIC;
           S : in STD_LOGIC;
           CO : in STD_LOGIC;
           ALUop : in STD_LOGIC_VECTOR (1 downto 0);
           R : out STD_LOGIC_VECTOR (31 downto 0));
end ALUComp;

architecture Behavioral of ALUComp is

SIGNAL TEMP: STD_LOGIC_VECTOR(3 DOWNTO 0);

begin
TEMP <= A & B & S & CO;

PROCESS(A, CO, ALUop, A, B, S, TEMP)
BEGIN
    CASE TEMP IS 
    --  "-" IS DC VALUE
        WHEN "001X" |"111X" | "10XX" | "XXX0" => R <=  "-------------------------------" & "1";
        WHEN OTHERS => R <=  "-------------------------------" & "1";
    END CASE;
END PROCESS;
end Behavioral;
