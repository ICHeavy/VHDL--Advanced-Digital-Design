library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity LOGIC is
  Port ( 
    A, B : in std_logic_vector (31 downto 0);
    Op : in std_logic_vector (1 downto 0);
    S : out std_logic_vector (31 downto 0)
  );
end LOGIC;

architecture Behavioral of LOGIC is
begin
    PROCESS(A,B,Op)
        BEGIN
            Case Op is 
                when "00" => S <= A and B;
                when "01" => S <= A or B;
                when "10" => S <= A xor B;
                when "11" => S <= A nor B;
                when others => NULL;
        END CASE;
    END PROCESS;
end Behavioral;
