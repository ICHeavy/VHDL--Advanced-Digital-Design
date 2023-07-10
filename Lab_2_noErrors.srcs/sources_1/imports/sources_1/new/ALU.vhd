library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- I TOOK A LOT OF THIS 
-- FROM LAST YEARS CODE
-- GLAD IT WORKS SORTA

entity ALU is
    Port ( A : in STD_LOGIC_VECTOR (31 downto 0);
           B : in STD_LOGIC_VECTOR (31 downto 0);
           ALUOp : in STD_LOGIC_VECTOR (3 downto 0);
           SHAMT : in STD_LOGIC_VECTOR (4 downto 0);
           R : out STD_LOGIC_VECTOR (31 downto 0);
           ZERO : out STD_LOGIC;
           OVERFLOW : out STD_LOGIC);
end ALU;

architecture Behavioral of ALU is

COMPONENT LOGIC is
  Port ( 
    A, B : in std_logic_vector (31 downto 0);
    Op : in std_logic_vector (1 downto 0);
    S : out std_logic_vector (31 downto 0)
  );
end COMPONENT;

COMPONENT COMP is
  Port (
    ALUOp : in std_logic_vector(1 downto 0);
    A   : in std_logic;
    B   : in std_logic;
    CARRY : in std_logic;
    S : in std_logic;
    R : out std_logic_vector(31 downto 0)
  );
END COMPONENT;

COMPONENT SHIFT is
  Port (
    A : in std_logic_vector(31 downto 0);
    SHAMT : in std_logic_vector(4 downto 0);
    Op: in std_logic_vector(1 downto 0);
    R : out std_logic_vector(31 downto 0)
  );
 end component;

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

COMPONENT MUXMAN is
  Port (
    LR, AR, CR, SR : in std_logic_vector(31 downto 0);
    Op : in std_logic_vector(1 downto 0);
    R : out std_logic_vector(31 downto 0)
  );
END COMPONENT;
SIGNAL ALUopA, ALUopB : STD_LOGIC_VECTOR(1 DOWNTO 0);
SIGNAL CARRY, ATEMP, BTEMP, STEMP : STD_LOGIC;
SIGNAL LOGGER, MATH, COMPER, SHIFTER : STD_LOGIC_VECTOR(31 DOWNTO 0);

begin
    ALUopA <= ALUOp(3 DOWNTO 2);
    ALUopB <=  ALUOp(1 DOWNTO 0);
    ATEMP <= A(31);
    BTEMP <= B(31);
    STEMP <= MATH(31);
    LOGICGUY : LOGIC port map (A, B, ALUopB, LOGGER);
    ARITHGUY : Arith_Unit port map (A, B, ALUopB, CARRY, OVERFLOW, MATH, ZERO);
   COMPGUY : COMP port map (ALUopB, ATEMP, BTEMP, STEMP, CARRY, COMPER);
  SHIFTGUY : SHIFT port map (A, SHAMT, ALUopB, SHIFTER);
   MUXGUY : MUXMAN port map (LOGGER, MATH, COMPER, SHIFTER,  ALUopA, R);
   
end Behavioral;
