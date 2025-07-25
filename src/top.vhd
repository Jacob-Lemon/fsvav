-- this is top.vhd

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity top is
    port (
        -- system
        clk_100MHz : in std_logic;  -- 100 MHz clock from basys3
        reset : in std_logic;       -- reset from a button of basys3
        switches : in std_logic_vector (15 downto 0);
        -- vga
        hsync : out std_logic;
        vsync : out std_logic;
        rgb : out std_logic_vector (11 downto 0)
    );
end top;


architecture Behavioral of top is
-- this is where signals and components go
-- signals
signal w_video_on : std_logic;
signal w_p_tick : std_logic;
signal w_x : std_logic;
signal w_y : std_logic;
-- signal rgb_reg : std_logic_vector (11 downto 0); -- this may not be necessary if we aren't doing pipelining stuff


-- components
--component vga_controller
--    port (
--        -- port list of vga controller
--    );
--end component;

component pixel_generation
    port (
        -- inputs
        clk : in std_logic;
        reset : in std_logic;
        video_on : in std_logic;
        x, y : in std_logic_vector (9 downto 0);
        -- outputs
        rgb : out std_logic_vector (11 downto 0)
        );
end component;



begin -- begin architecture
-- this is where you actually instantiate things

-- things to add here
-- instantiate:
--      pixel_generation
--      vga_controller
-- then just match the signals

-- instantiation of pixel_generation
pixel_generation_in_top : pixel_generation
    port map (
        clk => clk_100MHz,
        reset => reset,
        video_on => w_video_on,
        x => w_x,
        y => x_y,
        rgb => rgb -- does this work without the pipelining
    );


--process(clk) is
--begin
--    if (rising_edge(clk)) begin
        
--    end
--end process;









end Behavioral;