library ieee;
use ieee.std_logic_1164.all;
use work.all;

entity rs232_tx_char_TB is
end rs232_tx_char_TB;

architecture arch_tb of rs232_tx_char_TB is

constant message : string := "voici quelques caractères ! FINI *";

signal reset : std_logic := '1';
signal clk : std_logic := '0';
signal load : std_logic := '0';
signal le_caractere : character;
signal ready, rs232_tx_data : std_logic;

type etat_type is (attend_ready, attend_ack);
signal etat : etat_type := attend_ready;

constant periode : time := 10 ns;

begin

	clk <= not(clk) after periode / 2;
	reset <= '1' after 0 ns, '0' after periode * 9 / 4;

    UUT : entity rs232_tx_char(arch)
		generic map (100e6, 1e6)
		port map (reset, clk, le_caractere, load, ready, rs232_tx_data);
		
	-- stimulation seulement, pas de vérification
	process (clk)
	variable compte : natural range 1 to message'length + 1 := 1;
	begin
        if reset = '1' then
            load <= '0';
            le_caractere <= NUL;
            compte := 1;
            etat <= attend_ready;
		elsif (falling_edge(clk)) then
            case etat is
                when attend_ready =>
			    if ready = '1' then
        			if compte = message'length + 1 then
                        report "simulation terminée" severity failure;
                    end if;                
		    		le_caractere <= message(compte);
		    		load <= '1';
		    		compte := compte + 1;
                    etat <= attend_ack;
                end if;
                
                when attend_ack =>
                if ready = '0' then
		    		le_caractere <= nul;
		    		load <= '0';
                    etat <= attend_ready;
                end if;
            end case;
		end if;
	end process;
		
end arch_tb;
