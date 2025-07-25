library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
-- use ieee.numeric_std.all;

entity seven_segment is
    port (
        -- inputs
        d : in std_logic_vector (3 downto 0);
        -- outputs
        segments : out std_logic_vector (6 downto 0)
    );
end seven_segment;

architecture Behavioral of seven_segment is

    signal temp_segments : std_logic_vector(6 downto 0);

begin

    process(d) is
    begin
        case d is
            when "0000" => -- 0
                temp_segments <= "1111110";
            when "0001" => -- 1
                temp_segments <= "0110000";
            when "0010" => -- 2
                temp_segments <= "1101101";
            when "0011" => -- 3
                temp_segments <= "1111001";
            when "0100" => -- 4
                temp_segments <= "0110011";
            when "0101" => -- 5
                temp_segments <= "1011011";
            when "0110" => -- 6
                temp_segments <= "1011111";
            when "0111" => -- 7
                temp_segments <= "1110000";
            when "1000" => -- 8
                temp_segments <= "1111111";
            when "1001" => -- 9
                temp_segments <= "1110011";
            when "1010" => -- A
                temp_segments <= "1110111";
            when "1011" => -- b
                temp_segments <= "0011111";
            when "1100" => -- C
                temp_segments <= "1001110";
            when "1101" => -- d
                temp_segments <= "0111101";
            when "1110" => -- E
                temp_segments <= "1001111";
            when "1111" => -- F
                temp_segments <= "1000111";
            when others =>
                temp_segments <= "1111110"; -- display 0 if invalid
        end case;
    end process;


    segments <= not temp_segments;

end Behavioral;