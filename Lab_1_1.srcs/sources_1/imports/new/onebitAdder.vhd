library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity oneBitAdder is
    Port (  A : in STD_LOGIC;
            B : in STD_LOGIC;
            Cin : in STD_LOGIC;
            Sub : in STD_LOGIC;
            S : out STD_LOGIC;
            Cout : out STD_LOGIC
            );
end oneBitAdder;


architecture Behavioral of oneBitAdder is

signal SUBBER, T0, T1, T2 : STD_LOGIC;

begin
-- FULL ADDER XOR-ING PORTS: SUB , B
    -- BEFORE B ENTERS FULL ADDER 
    SUBBER <= (B xor SUB);
    T0 <= A xor SUBBER;
    T1 <= Cin and T0;
    T2 <= A and SUBBER;
    S <= T0 xor Cin;
    Cout <= T1 or T2; 
end Behavioral;