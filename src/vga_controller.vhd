-- this is vga_controller.vhd

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity vga_controller is
    port (
        -- system inputs
        clk_100MHz : in std_logic;
        reset : in std_logic;
        -- outputs
        video_on : out std_logic;
        hsync : out std_logic;
        vsync : out std_logic;
        p_tick : out std_logic;
        x : out std_logic_vector (9 downto 0);
        y : out std_logic_vector (9 downto 0)
    
    
    );
end vga_controller;

architecture Behavioral of vga_controller is
-- this is where signals and components go
-- signals

-- constants
constant mything : std_logic_vector (4 downto 0) := "10011";
-- Total horizontal width of the screenn is 800 pixels, partitioned into sections
constant HD : integer := 640;               -- horizontal display area width in pixels
constant HF : integer := 48;                -- horizontal front porch width in pixels
constant HB : integer := 16;                -- horizontal back porch width in pixels
constant HR : integer := 96;                -- horizontal retrace width in pixels;
constant HMAX : integer := HD+HF+HB+HR-1;   -- max value of horizontal counter = 799
-- Total vertical length of the screen is 525 pixels, partitioned into sections
constant VD : integer := 480;               -- vertical display area length in pixels
constant VF : integer := 10;                -- vertical front porch length in pixels
constant VB : integer := 33;                -- vertical back porch length in pixels
constant VR : integer := 2;                 -- vertical retrace length in pixels
constant VMAX : integer := VD+VF+VB+VR-1;   -- max  value of vertical counter = 524

-- components
-- we either instantiate the clock divider, do it here, or just pass in a divided clock to the module




begin -- begin architecture behavioral of

process(clk_25MHz) is
begin
    if (rising_edge(clk_25MHz)) begin
        if (reset) begin
            
        end
    end
end process;












