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
        clk   : in std_logic;
        right : in std_logic_vector (3 downto 0);
        left  : in std_logic_vector (3 downto 0);
        -- outputs
        an : out std_logic_vector (1 downto 0); -- controls which sections of 7 segment displays are on
        a : out std_logic;
        b : out std_logic;
        c : out std_logic;
        d : out std_logic;
        e : out std_logic;
        f : out std_logic;
        g : out std_logic;
    );
end top;

architecture Behavioral of top is

begin


end Behavioral;
