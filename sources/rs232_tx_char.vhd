---------------------------------------------------------------------------------------------------
-- 
-- rs232_tx_char.vhd
--
-- Pierre Langlois
-- v. 1.0 2020-07-23 inspiré de plusieurs modules précédents
-- v. 1.1 2022-03-06 pour le labo #2 de INF3500, hiver 2022
-- 					   
-- Transmission d'un caractère
-- taux de symboles (baud rate) ajustable
-- 8 bits, pas de parité, 1 bit d'arrêt
--
-- voir https://fr.wikipedia.org/wiki/RS-232 
--
-- TODO : modifier le code pour paramétrer la nombre de bits, la parité et le nombre de bits d'arrêt
--
---------------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rs232_tx_char is
    generic (
        f_clk_ref : positive := 100e6;  -- fréquence de l'horloge de référence, en Hz
        baud_rate : positive := 9600    -- taux de transmission de symboles par seconde, ici des bits; voir https://fr.wikipedia.org/wiki/Baud_(mesure)
    );
    port(
        reset : in std_logic;
        clk_ref : in std_logic;         -- horloge de référence
        le_caractere : in character;    -- caractère à transmettre
        load : in std_logic;            -- il faut charger le caractère et débuter la transmission
        ready : out std_logic;          -- le système est prêt à transmettre un nouveau caractère
        rs232_tx : out std_logic        -- signal de transmission RS-232
    );
end rs232_tx_char;

architecture arch of rs232_tx_char is

constant start_bit : std_logic := '0';
constant stop_bit : std_logic := '1';
constant n_data_bits : positive := 8;

signal clk_bits : std_logic := '0';
signal registre : std_logic_vector(n_data_bits - 1 downto 0);

type etat_type is (attente, transmission);
signal etat : etat_type := attente;

begin      
    
    process(all)
    variable compteur : natural range 0 to n_data_bits + 1;
    begin
        if reset = '1' then
            ready <= '0';
            rs232_tx <= stop_bit;
            etat <= attente;
        elsif rising_edge(clk_bits) then
            case etat is
                when attente =>
                ready <= '1';
                rs232_tx <= stop_bit;
                if load = '1' then
                    compteur := n_data_bits + 1;
                    registre <= std_logic_vector(to_unsigned(character'pos(le_caractere), 8));
                    ready <= '0';
                    rs232_tx <= start_bit;
                    etat <= transmission;
                end if;
                
                when transmission =>
                ready <= '0';
                rs232_tx <= registre(0);
                registre <= stop_bit & registre(7 downto 1);
                compteur := compteur - 1;
                if compteur = 0 then
                    ready <= '1';
                    rs232_tx <= stop_bit;
                    etat <= attente;
                end if;
            end case;
        end if;
    end process;
    
    -- générer le signal d'horloge pour les bits
    process (all)
    constant clkRatio : positive := f_clk_ref / baud_rate / 2;
    variable compteur : natural range 0 to clkRatio - 1 := clkRatio - 1;
    begin
        if rising_edge(clk_ref) then
            if (compteur = 0) then
                compteur := clkRatio - 1;
                clk_bits <= not(clk_bits);
            else
                compteur := compteur - 1;
            end if;
        end if;
    end process;

end arch;
