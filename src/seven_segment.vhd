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
begin

    process(d) is
    begin
        case d is
            when "0000" => -- 0
                segments <= "1111110";
            when "0001" => -- 1
                segments <= "0110000";
            when "0010" => -- 2
                segments <= "1101101";
            when "0011" => -- 3
                segments <= "1111001";
            when "0100" => -- 4
                segments <= "0110011";
            when "0101" => -- 5
                segments <= "1011011";
            when "0110" => -- 6
                segments <= "1011111";
            when "0111" => -- 7
                segments <= "1110000";
            when "1000" => -- 8
                segments <= "1111111";
            when "1001" => -- 9
                segments <= "1110011";
            when others =>
                segments <= "1111110"; -- display 0 if invalid
        end case;
    end process;

end Behavioral;