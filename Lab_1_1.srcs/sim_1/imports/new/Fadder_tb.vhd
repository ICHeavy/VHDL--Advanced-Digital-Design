library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity Fadder_tb is
--  Port ( );
end Fadder_tb;

architecture Behavioral of Fadder_tb is

constant WIDTH : Integer := 32;
  signal A, B, S : std_logic_vector(WIDTH-1 downto 0);
  signal Cin, Cout : std_logic;
  signal TEMP : std_logic_vector(WIDTH downto 0);
  
  component Fadder is
    GENERIC ( WIDTH : Integer := 32 );
    PORT (
    A : in STD_LOGIC_VECTOR(WIDTH-1 downto 0);
    B : in STD_LOGIC_VECTOR(WIDTH-1 downto 0);
    SUB : in STD_LOGIC;
    Cout : out STD_LOGIC;
    S : out STD_LOGIC_VECTOR(WIDTH-1 downto 0)
    );
  end component;

begin

ADDGUY : Fadder generic map ( WIDTH => WIDTH )
                port map (A, B, Cin, Cout, S);
    
PROCESS
    variable S0, S1: positive;
    variable R0, R1: real;
    variable RNG : real := real(2**4-1);
    variable RAND0, RAND1 : std_logic_vector(WIDTH-1 downto 0); 
BEGIN
    for i in 0 to 5 loop
    -- GENRATE AND TURN TO BITS
       uniform(S0, S1, R0);
       uniform(S0, S1, R1);
       RAND0 := std_logic_vector(to_unsigned(integer(R0*RNG), 32));
       RAND1 := std_logic_vector(to_unsigned(integer(R1*RNG), 32));
       -- ASSIGN 
       A <= RAND0;
       B <= RAND1;
       Cin <= '0';
       wait for 10 ns; 
       -- FOR ERROR CHECK
       TEMP <= std_logic_vector(unsigned('0'& A) + unsigned('0' & B));
       wait for 10 ns;
       assert(S = TEMP(31 downto 0)) report "ERROR, YOURE BAD AT ADDING";
    end loop;  
    
    wait for 20 ns;
    

    for i in 0 to 5 loop
    -- GENRATE AND TURN TO BITS
       uniform(S0, S1, R0);
       uniform(S0, S1, R1);
       RAND0 := std_logic_vector(to_unsigned(integer(R0*RNG), 32));
       RAND1 := std_logic_vector(to_unsigned(integer(R1*RNG), 32));
       -- ASSIGN 
       A <= RAND0;
       B <= RAND1;
       Cin <= '1';
       wait for 10 ns; 
       -- FOR ERROR CHECK
       TEMP <= std_logic_vector(unsigned('0'& A) - unsigned('0' & B));
       WAIT for 10 ns;
       ASSERT(S = TEMP(31 DOWNTO 0)) REPORT "ERROR, YOURE BAD AT SUBTRACTING";
    END LOOP; 
    
    wait for 10 ns;
    
    A <= x"FFFFFFFF";
    B <= x"00000001";
    Cin <= '0';
    WAIT for 10 ns;
    TEMP <= std_logic_vector(unsigned('0'& A) - unsigned('0' & B));
    WAIT for 10 ns;

    ASSERT(S = TEMP(31 DOWNTO 0)) REPORT "ERROR, YOURE BAD AT SUBTRACTING";
    
    
    
    REPORT "SIM GUY FINISHED!";
    WAIT;
END PROCESS; 
end Behavioral;
