-- A Moore machine's outputs are dependent only on the current state.
-- The output is written only when the state changes.  (State
-- transitions are synchronous.)

-- USING MOORE
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.std_logic_arith.all;

entity moore_4s is
	port(
    A : in std_logic_vector(31 downto 0);
    rst: in std_logic;
    clk : in std_logic;
    en: out std_logic;
    done: out std_logic;
    load : out std_logic
  );
end entity;

architecture rtl of moore_4s is

	-- Build an enumerated type for the state machine
	type state_type is (s0, s1, s2);
	
	-- Register to hold the current state
	signal prev, nxt   : state_type;
	signal count: integer range 0 to 32;

begin

	-- Logic to advance to the next state
	process (clk, rst)
	begin
		if (rst = '1') then
			prev <= S0;
            count <= 0;
		elsif (clk'event and clk = '1') then
			prev <= nxt;
            count <= count + 1;
        end if;
	end process;
	
	-- Output depends solely on the current state
	process (prev,clk)
	begin
		case prev is
		--base
			when s0 =>
				done <= '0';
                load <= '1';
                en <= '0';
                nxt <= S1;
        --adding state   
			when s1 =>
				load <= '0';
                if (count <= 32) then
                  if (A(0) = '1') then
                    en <= '1';
                  -- add
                  else
                    en <= '0';
                    load <= '0';
                  end if;
                else
                  -- done 
                  en <= '0';
                  nxt <= S2;
                end if;
			when s2 =>
				load <= '0';
                nxt <= S2;
                done <= '1';
              when others =>
                done <= '1';
            end case;
	end process;
end rtl;
