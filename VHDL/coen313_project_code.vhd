
library ieee;
use ieee.std_logic_1164.all;
entity comb_lock is
port(
        ld1 : IN STD_LOGIC;
        ld2 : IN STD_LOGIC;
        ld3 : IN STD_LOGIC;
        enter : IN STD_LOGIC;
        reset : IN STD_LOGIC;
        value : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        clk : IN STD_LOGIC;
        unlock : Out STD_LOGIC);
end comb_lock ;


architecture comb_lock_arch of comb_lock is
type state_type is (s1, s2, s3, s4, error);
signal state_reg, state_next: state_type;
signal C1, C2, C3: std_logic_vector(3 downto 0);

begin
process(clk, reset)
begin
        -- state register process
        if reset = '1' then
                state_reg <= s1;
        elsif clk'event and clk = '1' then
                state_reg <= state_next;
        end if;
end process;


process(ld1, ld2, ld3)
begin
       
        if ld1='1' then
                C1 <= "0011";
        elsif ld2='1' then
                C2 <= "0001";
        elsif ld3='1' then
                C3 <= "0011";
        end if ;
end process;

-- next-state logic
process(state_reg, enter)
	begin
	case state_reg is
	when s1 =>
		if enter= '1' then
		--compare c1 to 011 (value), then assign next state
			if C1 = value then
			 state_next <= s2;
			else
			 state_next <= error;
			end if;
		else
		 state_next <= s1;
		end if;
		
	when s2 =>
		if enter= '1' then
		
		--compare c2 to 001 (value), then assign next state
			if C2 = value then
			 state_next <= s3;
			else
			 state_next <= error;
			end if;
		else
		 state_next <= s2;
		end if;
		
	when s3 =>
		if enter= '1' then
		--compare c3 to 011 (value), then assign next state
			if C3 = value then
			 state_next <= s4;
			else
			 state_next <= error;
			end if;
		else
		 state_next <= s3;
		end if;
		
	when s4 =>
		if enter= '1' then
		 state_next <= s1;
		else
		 state_next <= s4; 
		end if;
		
	when error =>
		 state_next <= s1;
	end case;
 end process;
 
-- moore output logic
unlock <= '1' when state_reg=s4 else '0';

end comb_lock_arch;