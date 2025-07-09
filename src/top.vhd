library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity top is
    port (
        -- inputs
        clk_100MHz : in std_logic;
        right : in std_logic_vector (3 downto 0);
        left  : in std_logic_vector (3 downto 0);
        -- outputs
        an : out std_logic_vector (3 downto 0); -- controls which sections of 7 segment displays are on
        segments : out std_logic_vector (6 downto 0)
    );
end top;

architecture Behavioral of top is
-- this is where signals and components go
-- signals
signal clk_2kHz : std_logic := '0';

-- components
--component clk_divider 
--    port (
--        clk_100MHz : in std_logic;
--        clk_2kHz   : out std_logic
--    );
--end component;

component seven_segment
    port (
        d : in std_logic_vector (3 downto 0);
        segments : out std_logic_vector (6 downto 0)
    );
end component;

begin -- begin architecture

-- clock divider instantiation
--get_clk_2kHz : clock_divider
--    port map (
--        clk_100MHz => clk_100MHz,
--        clk_2kHz => clk_2kHz
--    );

-- seven segment instantiation
seven_segment_instance_1 : seven_segment
    port map (
        d => right,
        segments => segments
    );

-- main process 

-- main_process : process (clk_100MHz)

-- begin 


-- end process;

an(0) <= '0';
an(1) <= '1';
an(2) <= '1';
an(3) <= '1';

end Behavioral;
