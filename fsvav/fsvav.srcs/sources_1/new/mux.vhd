library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

----------

entity mux is
    port (
        -- d0, d1, sel    : in bit;
        d0   : in std_logic;
        d1   : in std_logic;
        sel  : in std_logic;
        mout : out std_logic
    );
end mux;

architecture Behavioral of mux is
begin
   --  mout <= d1 when (sel = '1') else d0;
    process (d0, d1, sel) is
    begin
        mout <= (not sel and d0) or (sel and d1); -- mux logic
    end process;



end Behavioral;
