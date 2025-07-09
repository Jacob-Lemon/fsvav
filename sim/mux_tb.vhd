library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux_tb is
    -- Empty entity for testbench
end mux_tb;

architecture Behavioral of mux_tb is

    -- DUT signals (updated to std_logic)
    signal d0   : std_logic := '0';
    signal d1   : std_logic := '0';
    signal sel  : std_logic := '0';
    signal mout : std_logic;

    -- Component declaration of the DUT (updated to std_logic)
    component mux
        port (
            d0   : in  std_logic;
            d1   : in  std_logic;
            sel  : in  std_logic;
            mout : out std_logic
        );
    end component;

begin

    -- Instantiate the DUT
    uut: mux
        port map (
            d0   => d0,
            d1   => d1,
            sel  => sel,
            mout => mout
        );

    -- Stimulus process
    stim_proc: process
    begin
        -- Apply all 8 combinations of d0, d1, sel

        -- Test 1: sel = '0', d0 = '0', d1 = '0' ? mout should be '0'
        d0 <= '0'; d1 <= '0'; sel <= '0';
        wait for 10 ns;

        -- Test 2: sel = '0', d0 = '1', d1 = '0' ? mout should be '1'
        d0 <= '1'; d1 <= '0'; sel <= '0';
        wait for 10 ns;

        -- Test 3: sel = '0', d0 = '0', d1 = '1' ? mout should be '0'
        d0 <= '0'; d1 <= '1'; sel <= '0';
        wait for 10 ns;

        -- Test 4: sel = '1', d0 = '0', d1 = '0' ? mout should be '0'
        d0 <= '0'; d1 <= '0'; sel <= '1';
        wait for 10 ns;

        -- Test 5: sel = '1', d0 = '1', d1 = '0' ? mout should be '0'
        d0 <= '1'; d1 <= '0'; sel <= '1';
        wait for 10 ns;

        -- Test 6: sel = '1', d0 = '0', d1 = '1' ? mout should be '1'
        d0 <= '0'; d1 <= '1'; sel <= '1';
        wait for 10 ns;

        -- Test 7: sel = '0', d0 = '1', d1 = '1' ? mout should be '1'
        d0 <= '1'; d1 <= '1'; sel <= '0';
        wait for 10 ns;

        -- Test 8: sel = '1', d0 = '1', d1 = '1' ? mout should be '1'
        d0 <= '1'; d1 <= '1'; sel <= '1';
        wait for 10 ns;

        -- End simulation
        wait;
    end process;

end Behavioral;
