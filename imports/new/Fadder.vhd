library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Fadder is
    GENERIC ( WIDTH : Integer := 32 );
    PORT (
    A : in STD_LOGIC_VECTOR(WIDTH-1 downto 0);
    B : in STD_LOGIC_VECTOR(WIDTH-1 downto 0);
    SUB : in STD_LOGIC;
    Cout : out STD_LOGIC;
    S : out STD_LOGIC_VECTOR(WIDTH-1 downto 0)
    );
end Fadder;

architecture Behavioral of Fadder is

    SIGNAL CARRYBUS : STD_LOGIC_VECTOR(WIDTH-1 downto 0);
    
    COMPONENT  oneBitAdder is
    Port (  A : in STD_LOGIC;
            B : in STD_LOGIC;
            Cin : in STD_LOGIC;
            Sub : in STD_LOGIC;
            S : out STD_LOGIC;
            Cout : out STD_LOGIC
            );
    END COMPONENT ;

begin

    FULLADDGEN : FOR i IN 0 TO WIDTH-1 GENERATE
    
        INST0: IF (i=0) GENERATE
            BIT0: oneBitAdder PORT MAP(A(0), B(0), SUB, SUB, S(0), CARRYBUS(0));
        END GENERATE;
            -- EXCLUDING 0, EACH ADDER EXCEPT LAST (WHICH GETS COUT) GETS A CIN 
            -- STORED IN CARRYBUS
            -- FIRST IS USED FOR 0 INSTANCE
            
        INSTi: IF (i /= 0) GENERATE
            BITSi: oneBitAdder PORT MAP(A(i), B(i),CARRYBUS(i-1) ,SUB,  S(i),CARRYBUS(i));
        END GENERATE;
        
    END GENERATE;
    -- LEAVING LAST FOR COUT
    Cout <= CARRYBUS(WIDTH-1);
    
end Behavioral;
