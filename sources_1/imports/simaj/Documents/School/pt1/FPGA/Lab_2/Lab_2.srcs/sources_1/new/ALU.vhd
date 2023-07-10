library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- I TOOK A LOT OF THIS 
-- FROM LAST YEARS CODE
-- GLAD IT WORKS SORTA

entity ALU is
    Port ( A : in STD_LOGIC_VECTOR (31 downto 0);
           B : in STD_LOGIC_VECTOR (31 downto 0);
           ALUOp : in STD_LOGIC_VECTOR (31 downto 0);
           SHAMT : in STD_LOGIC_VECTOR (4 downto 0);
           R : out STD_LOGIC_VECTOR (31 downto 0);
           ZERO : out STD_LOGIC;
           OVERFLOW : out STD_LOGIC);
end ALU;

architecture Behavioral of ALU is

COMPONENT ALU_Logic is
    Port ( A : in STD_LOGIC_VECTOR (31 downto 0);
           B : in STD_LOGIC_VECTOR (31 downto 0);
       ALUop : in STD_LOGIC_VECTOR (1 downto 0);
           S : out STD_LOGIC_VECTOR (31 downto 0));
END COMPONENT;

COMPONENT ALUComp is
    Port ( A : in STD_LOGIC;
           B : in STD_LOGIC;
           S : in STD_LOGIC;
           CO : in STD_LOGIC;
           ALUop : in STD_LOGIC_VECTOR (1 downto 0);
           R : out STD_LOGIC_VECTOR (31 downto 0));
END COMPONENT;

COMPONENT ALUShift is
    Port ( A : in STD_LOGIC_VECTOR (31 downto 0);
           SHAMT : in STD_LOGIC_VECTOR (4 downto 0);
           ALUop : in STD_LOGIC_VECTOR (1 downto 0);
           R : out STD_LOGIC_VECTOR (31 downto 0));
END COMPONENT;

COMPONENT Arith_Unit IS
   GENERIC (
      n       : positive := 32);
   PORT( 
      A       : IN     std_logic_vector (n-1 DOWNTO 0);
      B       : IN     std_logic_vector (n-1 DOWNTO 0);
      C_op    : IN     std_logic_vector (1 DOWNTO 0);
      CO      : OUT    std_logic;
      OFL     : OUT    std_logic;
      S       : OUT    std_logic_vector (n-1 DOWNTO 0);
      Z       : OUT    std_logic);
END COMPONENT;

COMPONENT ALUMux is
    Port ( A : in STD_LOGIC_VECTOR (31 downto 0);
           B : in STD_LOGIC_VECTOR (31 downto 0);
           C : in STD_LOGIC_VECTOR (31 downto 0);
           ALUop : in STD_LOGIC_VECTOR (1 downto 0);
           R : out STD_LOGIC_VECTOR (31 downto 0);
           D : in STD_LOGIC_VECTOR (31 downto 0));
END COMPONENT;
SIGNAL ALUopTOP, ALUopBOT : STD_LOGIC_VECTOR(1 DOWNTO 0);
SIGNAL CARRY, AT,BT,ST : STD_LOGIC;
SIGNAL LOG, MATH, COMP, SHIFT : STD_LOGIC_VECTOR(31 DOWNTO 0);

begin
    ALUopTOP <= ALUOp(3 DOWNTO 2);
    ALUopBOT <=  ALUOp(1 DOWNTO 0);
    AT <= A(31);
    BT <= B(31);
    ST <= MATH(31);
    lOGIC : ALU_Logic port map (A, B, ALUopBOT, LOG);
    ARITH : Arith_Unit port map (A, B, ALUopBOT, CARRY, OVERFLOW, MATH, ZERO);
  COMPGUY : ALUComp port map (AT, BT, ST, CARRY, ALUopBOT, COMP);
  SHIFTER : ALUShift port map (A, SHAMT,ALUopBOT, SHIFT);
   MUXGUY : ALUMux port map (LOG, MATH, COMP, ALUopTOP, R, SHIFT);
   
end Behavioral;
