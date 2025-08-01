-- this is vga_controller.vhd

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity vga_controller is
    port (
        -- system inputs
        clk_25MHz : in std_logic;
        reset : in std_logic;
        -- outputs
        video_on : out std_logic;
        hsync : out std_logic;
        vsync : out std_logic;
        -- p_tick : out std_logic;
        x : out std_logic_vector (9 downto 0);
        y : out std_logic_vector (9 downto 0)
    );
end vga_controller;

architecture Behavioral of vga_controller is
    -- this is where signals and components go
    -- signals
    -- signal x_count : std_logic_vector (9 downto 0);
    -- signal y_count : std_logic_vector (9 downto 0);
    
    
    -- constants
    -- Total horizontal width of the screenn is 800 pixels, partitioned into sections
    constant H_DISPLAY : integer := 640;               -- horizontal display area width in pixels
    constant H_FRONT   : integer := 48;                -- horizontal front porch width in pixels
    constant H_BACK    : integer := 16;                -- horizontal back porch width in pixels
    constant H_RETRACE : integer := 96;                -- horizontal retrace width in pixels;
    constant H_MAX     : integer := H_DISPLAY+H_FRONT+H_BACK+H_RETRACE-1;   -- max value of horizontal counter = 799
    -- Total vertical length of the screen is 525 pixels, partitioned into sections
    constant V_DISPLAY : integer := 480;               -- vertical display area length in pixels
    constant V_FRONT   : integer := 10;                -- vertical front porch length in pixels
    constant V_BACK    : integer := 33;                -- vertical back porch length in pixels
    constant V_RETRACE : integer := 2;                 -- vertical retrace length in pixels
    constant V_MAX     : integer := V_DISPLAY+V_FRONT+V_BACK+V_RETRACE-1;   -- max  value of vertical counter = 524
    
    -- signals
    signal x_count : integer range 0 to H_MAX := 0;
    signal y_count : integer range 0 to V_MAX := 0;
    
begin -- begin architecture behavioral of
    
    counter : process(clk_25MHz, reset)
    begin
        if (reset = '1') then
            x_count <= 0;
            y_count <= 0;
        elsif (rising_edge(clk_25MHz)) then
            if (x_count = H_MAX) then
                x_count <= 0;
                if (y_count = V_MAX) then
                    y_count <= 0;
                else
                    y_count <= y_count + 1;
                end if;
            else 
                x_count <= x_count + 1;
            end if;
        end if;
    end process counter;
    
    -- x <= x_count;
    -- y <= y_count;
    
    x <= std_logic_vector(to_unsigned(x_count, x'length));
    y <= std_logic_vector(to_unsigned(y_count, y'length));
    
    video_on <= '1' when (x_count < H_DISPLAY and y_count < V_DISPLAY) else '0';
    
    -- hsync active low during horizontal retrace region
    hsync <= '0' when (x_count >= (H_DISPLAY + H_FRONT) and x_count < (H_DISPLAY + H_FRONT + H_RETRACE)) else '1';

    -- vsync active low during vertical retrace region
    vsync <= '0' when (y_count >= (V_DISPLAY + V_FRONT) and y_count < (V_DISPLAY + V_FRONT + V_RETRACE)) else '1';


end Behavioral;
