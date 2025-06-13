----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06/13/2025 09:41:19 AM
-- Design Name: 
-- Module Name: mux - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity mux is
    port (
        -- d0, d1, sel    : in bit;
        d0   : in bit;
        d1   : in bit;
        sel  : in bit;
        mout : out bit;
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
