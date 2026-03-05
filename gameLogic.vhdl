library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity gameLogic is
    port(
        inPort   : in  std_logic_vector(8 downto 0);
        reset    : in  std_logic;
        clk      : in  std_logic;
        hsync    : out std_logic;
        vsync    : out std_logic;
        rgb      : out std_logic_vector(11 downto 0);
        winState : out std_logic
    );
end gameLogic; 

architecture structural of gameLogic is
    signal sqrSel      : std_logic_vector(8 downto 0);
    signal cellGames   : std_logic_vector(17 downto 0);
    signal prevIn      : std_logic_vector(8 downto 0) := (others => '0');
    signal myIn        : std_logic_vector(8 downto 0) := (others => '0');
    signal turnReg     : std_logic := '0';
    signal colorSig    : std_logic_vector(8 downto 0); 
    signal internalWin : std_logic;
    

    -- fluck
    component cellLogic
        port(
            clk   : in  std_logic;
            sel   : in  std_logic;
            turn  : in  std_logic;
            reset : in  std_logic;
            state : out std_logic_vector(1 downto 0)
        );
    end component;
    
    -- scarlet
    component gameState
        port(
            clk       : in  std_logic;
            reset     : in  std_logic;
            cellState : in  std_logic_vector(17 downto 0);
            winState  : out std_logic;
            colorCell : out std_logic_vector(8 downto 0)
        );
    end component;
    
    -- phai
    component videoElement
        port(
            clk       : in  std_logic;
            hsync     : out std_logic;
            vsync     : out std_logic;
            rgb       : out std_logic_vector(11 downto 0); 
            cellGames : in  std_logic_vector(17 downto 0);
            colorCell : in  std_logic_vector(8 downto 0)
        );
    end component;

    component inputDecoder
        port(
        internalWin:in std_logic;
        inPort:in std_logic_vector(8 downto 0);
        cellGame:in std_logic_vector(17 downto 0);
        SqrSel:out std_logic_vector(8 downto 0);
    );
    end component;
begin

    winState <= internalWin;
     
    process(clk)
    begin
        
        --อย่ากดปุ่มค้าง
        if falling_edge(clk) then
            if (prevIn /= myIn and myIn /= "000000000") then
                turnReg <= not turnReg;
            end if;
            prevIn <= myIn;
            myIn   <= inPort;
        end if;
    end process;
    
    INPUT_DEC :inputDecoder
                port map(
                    internalWin => internalWin,inport=>inport,cellGames=>cellGames,sqrSel=>sqrSel
                );

    STATE_INST : gameState 
        port map (clk => clk, reset => reset, cellState => cellGames, winState => internalWin, colorCell => colorSig);

    VGA_INST : videoElement
        port map (clk => clk, hsync => hsync, vsync => vsync, rgb => rgb, cellGames => cellGames, colorCell => colorSig);

    GEN_CELLS: for i in 0 to 8 generate
        CELL_I : cellLogic
            port map(
                clk   => clk,
                reset => reset,
                turn  => turnReg,
                sel   => sqrSel(i),
                state => cellGames((i*2)+1 downto i*2)
            ); 
    end generate;
              
end structural;