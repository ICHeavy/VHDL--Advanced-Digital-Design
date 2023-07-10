library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity MULT_TOP is
port (
        A : in std_logic_vector(31 downto 0);
        B : in std_logic_vector(31 downto 0);
        clk : in std_logic;
        rst : in std_logic;
        done : out std_logic;
        R : out std_logic_vector(63 downto 0)
     );
end MULT_TOP;

architecture Behavioral of MULT_TOP is
component moore_4s is
	port(
    A : in std_logic_vector(31 downto 0);
    rst: in std_logic;
    clk : in std_logic;
    en: out std_logic;
    done: out std_logic;
    load : out std_logic
  );
end component;


component Fadder is
    GENERIC ( WIDTH : Integer := 64 );
    PORT (
    A : in STD_LOGIC_VECTOR(WIDTH-1 downto 0);
    B : in STD_LOGIC_VECTOR(WIDTH-1 downto 0);
    SUB : in STD_LOGIC;
    Cout : out STD_LOGIC;
    S : out STD_LOGIC_VECTOR(WIDTH-1 downto 0)
    );
 end component;    
    
component SRreg is
  Port (
    D : in std_logic_vector(31 downto 0);
    clk : in std_logic;
    rst : in std_logic;
    en : in std_logic;
    load : in std_logic;
    Q : out std_logic_vector(31 downto 0)
  );
end component;  

component SLreg is
  Port (
    D : in std_logic_vector(31 downto 0);
    clk : in std_logic; 
    rst : in std_logic;
    en : in std_logic;
    load : in std_logic;
    Q : out std_logic_vector(63 downto 0)
  );
end component;

component flipflop IS
   PORT( 
      X   : IN     std_logic_VECTOR(63 DOWNTO 0);
      CLK : IN     std_logic;
      EN  : IN     std_logic;
      RST : IN     std_logic;
      Y   : OUT    std_logic_VECTOR(63 DOWNTO 0)
   );
END component ;

SIGNAL EN, LOAD, XX : STD_LOGIC;
SIGNAL RIGHT : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL LEFT, ADDR, REGGIE : STD_LOGIC_VECTOR(63 DOWNTO 0);
begin

REGGR: flipflop PORT MAP (ADDR, CLK, EN, RST, REGGIE);
SR : SRreg PORT MAP (A, CLK, RST, EN, LOAD, RIGHT);
SL : SLreg PORT MAP (B, CLK, RST, EN, LOAD, LEFT);
ADDRGUY: Fadder PORT MAP (REGGIE, LEFT, '0', XX, ADDR); --a,b, sub,cout, S
FSM : moore_4s PORT MAP (RIGHT, RST, CLK, EN, DONE, LOAD);
R <= REGGIE;
end Behavioral;
