-- this is pixel_generation.vhd

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
-- use ieee.numeric_std.all;


entity pixel_generation is
    port (
        -- inputs
        clk : in std_logic;
        reset : in std_logic;
        video_on : in std_logic;
        x, y : in std_logic_vector (9 downto 0);
        -- outputs
        rgb : out std_logic_vector (11 downto 0)
    );
end pixel_generation;


architecture Behavioral of pixel_generation is

    signal video_active : std_logic;
    signal color_data_rgb : std_logic_vector(11 downto 0);

begin

    color_data_rgb <= x"001";

    process(clk, reset) is
    begin
        if rising_edge(clk) then
            if (reset)
                video_active <= 0;
            else
                video_active <= video_on;
            end if;
        end if;
    end process;

    process(clk, reset) is
    begin
        if rising_edge(clk) then
            if (reset)
                rbg <= x"000";
            else
                rbg <= color_data_rgb;
            end if;
        end if;
    end process;


end Behavioral;