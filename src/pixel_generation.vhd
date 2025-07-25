-- this is pixel_generation.vhd

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
-- use ieee.numeric_std.all;


entity pixel_generation is
    port (
        -- inputs
        clk        : in  std_logic;
        reset      : in  std_logic;
        video_on   : in  std_logic;
        x, y       : in  std_logic_vector(9 downto 0);
        -- outputs
        rgb        : out std_logic_vector(11 downto 0)
    );
end pixel_generation;


architecture Behavioral of pixel_generation is

    -- constant syntax
    constant blue : std_logic_vector(11 downto 0) := x"00F";

begin

    pixel_gen_proc: process(clk, reset)
    begin
        if (reset = '1') then
            rgb <= x"000";

        elsif rising_edge(clk) then
            
            if (video_on = '1') then
                -- if video on output color
                rgb <= blue;
            else
                -- ptherwise output black when screen is off
                rgb <= x"000";
            end if;

        end if;
    end process pixel_gen_proc;

end Behavioral;