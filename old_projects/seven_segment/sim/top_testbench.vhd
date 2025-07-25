library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity top_testbench is
    -- empty for testbench
end top_testbench;

architecture Behavioral of top_testbench is
    -- DUT signals
    -- inputs   
    signal clk_100MHz : std_logic := '0';
    signal right : std_logic_vector (3 downto 0);
    signal left  : std_logic_vector (3 downto 0);
    -- outputs
    signal an : std_logic_vector (3 downto 0);
    signal segments : std_logic_vector (6 downto 0);

    -- component of the top module
    component top
        port (
            -- inputs
            clk_100MHz : in std_logic;
            right : in std_logic_vector (3 downto 0);
            left  : in std_logic_vector (3 downto 0);
            -- outputs
            an : out std_logic_vector (3 downto 0); -- controls which sections of 7 segment displays are on
            segments : out std_logic_vector (6 downto 0)
        );
    end component;

begin
    -- instantiate the DUT
    uut: top
        port map (
            clk_100MHz => clk_100MHz,
            right => right,
            left => left,
            an => an,
            segments => segments
        );
    
    -- stimulus 
    stim_proc: process
        variable i : integer := 0;
    begin
    clk_100MHz <= '0';


    for i in 0 to 15 loop
        right <= std_logic_vector(to_unsigned(i,4));
        clk_100MHz <= not clk_100MHz;
        wait for 10 ns; 
    end loop;
    wait;
    
    end process;




end Behavioral;
