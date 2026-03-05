
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Tb_inputDecoder is
end Tb_inputDecoder;

architecture Behavioral of Tb_inputDecoder is
    signal tb_internalWin: std_logic := '0';
    signal tb_inport:std_logic_vector(8 downto 0):=(others =>'0');
    signal tb_cellGames:std_logic_vector(17 downto 0) :=(others => '0');
    signal tb_sqrSel:std_logic_vector(8 downto 0);
begin
    uut:entity work.inputDecoder 
    port map(
        internalWin => tb_internalWin,
        inport => tb_inport,
        cellGames => tb_cellGames,
        sqrSel => tb_sqrSel
    );
    process
    begin
        --test bench here
        tb_inPort      <= "000000010"; 
        tb_cellGames   <= "000000000000000000"; 
        wait for 100 ns;
        
        wait;
        
    end process;
end Behavioral;
