---------------------------------------------------------------------------------------------------
-- 
-- racine_carree.vhd
--
-- v. 1.0 Pierre Langlois 2022-02-25 laboratoire #4 INF3500 - code de base
--
---------------------------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;
use work.all;

entity racine_carree is
    generic (
        N : positive := 16;                     -- nombre de bits de A
        M : positive := 8;                      -- nombre de bits de X
        kmax : positive := 10                   -- nombre d'itérations à faire
    );
    port (
        reset, clk : in std_logic;
        A : in unsigned(N - 1 downto 0);        -- le nombre dont on cherche la racine carrée
        go : in std_logic;                      -- commande pour débuter les calculs
        X : out unsigned(M - 1 downto 0);       -- la racine carrée de A, telle que X * X = A
        fini : out std_logic                    -- '1' quand les calculs sont terminés ==> la valeur de X est stable et correcte
    );
end racine_carree;

architecture newton of racine_carree is
    
    constant W_frac : integer := 14;               -- pour le module de division, nombre de bits pour exprimer les réciproques
    
    type etat_type is (attente, calculs);
    signal etat : etat_type := attente;
    
--- votre code ici

begin
    
--    diviseur : entity division_par_reciproque(arch)
--        generic map (N, M, W_frac)
--        port map (un-signal-ici, un-signal-ici, un-signal-ici, un-signal-ici);

    X <= to_unsigned(255, X'length); -- code bidon
    fini <= '1'; -- code bidon

    -- votre code ici
    
end newton;
