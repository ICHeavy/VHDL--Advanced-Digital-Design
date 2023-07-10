LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY flipflop IS
   PORT( 
      X   : IN     std_logic_VECTOR(63 DOWNTO 0);
      CLK : IN     std_logic;
      EN  : IN     std_logic;
      RST : IN     std_logic;
      Y   : OUT    std_logic_VECTOR(63 DOWNTO 0)
   );

-- Declarations

END flipflop ;

--
ARCHITECTURE flipflop OF flipflop IS
BEGIN
     CLKD : process(CLK, RST)
     begin
        if(RST = '1') then
           Y <= (others => '0');
        elsif(CLK'event AND CLK = '1') then
           if(EN = '1') then
              Y <= X;
           end if;
        end if;
     end process CLKD;
END flipflop;
