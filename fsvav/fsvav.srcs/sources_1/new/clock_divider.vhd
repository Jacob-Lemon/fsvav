library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity clock_divider is
    port (
        -- inputs
        clk_100MHz : in std_logic;
        -- outputs
        clk_2khz : out std_logic
    );
end clock_divider;

architecture Behavioral of clock_divider is
-- signals
signal count : integer := 1;
signal temp  : std_logic := '0';

-- processes
begin

-- main clock divider process
process (clk_100MHz)
    begin
        if rising_edge(clk_100MHz) then
            if count = 25_000 then  -- adjust to 25_000 for 2 kHz from 100 MHz
                temp <= not temp;
                count <= 1;
            else
                count <= count + 1;
            end if;
        end if;
        clk_2khz <= temp;
    end process;

end Behavioral;
