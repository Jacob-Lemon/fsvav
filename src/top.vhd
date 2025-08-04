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
    signal clk_25MHz : std_logic := '0'; -- output of clock divider
    signal clock_counter : integer := 0;
    signal w_video_on : std_logic;
    signal w_x : std_logic_vector (9 downto 0);
    signal w_y : std_logic_vector (9 downto 0);
    -- signal rgb_reg : std_logic_vector (11 downto 0); -- this may not be necessary if we aren't doing pipelining stuff


    -- components
    component vga_controller
        port (
            -- system inputs
            clk_25MHz : in std_logic;
            reset : in std_logic;
            -- outputs
            video_on : out std_logic;
            hsync : out std_logic;
            vsync : out std_logic;
            x : out std_logic_vector (9 downto 0);
            y : out std_logic_vector (9 downto 0)
    );
    end component;

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


    clock_divider: process(clk_100MHz, reset) is
    begin
        if (reset = '1') then
            clock_counter <= 0;
            clk_25MHz <= '0';

        elsif rising_edge(clk_100MHz) then
            if (clock_counter = 1) then -- every other rising edge which is a 4th
                clk_25MHz <= not clk_25MHz;
                clock_counter <= 0;
            else
                clock_counter <= clock_counter + 1;
            end if;

        end if;

    end process clock_divider;


    -- instantiation of vga_controller
    vga_controller_in_top : vga_controller
        port map (
            clk_25MHz => clk_25MHz,
            reset => reset,
            video_on => w_video_on,
            hsync => hsync,
            vsync => vsync,
            x => w_x,
            y => w_y
        );


    -- instantiation of pixel_generation
    pixel_generation_in_top : pixel_generation
        port map (
            clk => clk_25MHz,
            reset => reset,
            video_on => w_video_on,
            x => w_x,
            y => w_y,
            rgb => rgb -- does this work without the pipelining
        );

    -- w_video_on <= video_on; -- skipping all pipelining
    -- w_x <= x;
    -- w_y <= y;


end Behavioral;