----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06/04/2025 06:27:59 AM
-- Design Name: 
-- Module Name: i2c - Behavioral
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

entity i2c is
    generic(NUM_COUNTER : integer := 500
            );
    Port ( clock        : in    STD_LOGIC;
           reset        : in    STD_LOGIC;
           rw           : in    STD_LOGIC;
           run          : in    STD_LOGIC;
           address      : in    STD_LOGIC_VECTOR (10 downto 0);
           number_data  : in    STD_LOGIC_VECTOR (2  downto 0);
           r_data       : in    STD_LOGIC_VECTOR (31 downto 0);
           w_data       : out   STD_LOGIC_VECTOR (31 downto 0);
           error_ack    : out   STD_LOGIC;
           busy         : out   STD_LOGIC;
           scl          : out   STD_LOGIC;
           sda          : inout STD_LOGIC
           );
end i2c;

architecture Behavioral of i2c is
    
    signal CounterClock_1 : unsigned(8 downto 0) := (others => '0');  -- 9-Bit counter for scl timing    
    signal scl_internal   : std_logic   := '1';
    signal sda_internal   : std_logic   := '1';
    signal scl_en         : std_logic   := '0';
    signal sda_en         : std_logic   := '0';
    signal flag_pro1      : std_logic   := '0';
    signal flag_pro2      : std_logic   := '0';
    signal flag_pro3      : std_logic   := '0';
    signal flag_pro4      : std_logic   := '0';
    signal flag_pro5      : std_logic   := '0';
    
    type state_type is (S_IDEL, S_READY, S_START, S_ADDRESS, S_SLV_ACK1, S_READ, S_WRITE, S_END);
    signal state : state_type := S_IDEL;
    
begin
    
    
 --================ Process control i2c unit =================
    PRO_0 : process(clock)
    begin
        if(rising_edge(clock))then
            if(reset = '0')then
                state <= S_IDEL;
            end if;
         --   if()
        end if;
    end process;
    
--================ Process begin , ready , start , end =================    
    PRO_1 : process(clock)
    begin
        flag_pro1 <= '0';
        if(rising_edge(clock))then
            if(state = S_IDEL   or  state = S_READY  or  state = S_START  or  state = S_END)then
                
            end if;
        end if;
    end process;
    
--================ Process address and ACK/NACK =================
    PRO_2 : process(clock)
    begin
        flag_pro2 <= '0';
        if(rising_edge(clock))then
            if(state = S_ADDRESS   or   state = S_SLV_ACK1)then
                
            end if;
        end if;
    end process;

--================ Process data write from slave =================
    PRO_3 : process(clock)
    begin
        flag_pro3 <= '0';
        if(rising_edge(clock))then
            if(state = S_ADDRESS)then
                
            end if;
        end if;
    end process;

--================ Process data read from slave =================
    PRO_4 : process(clock)
    begin
        flag_pro4 <= '0';
        if(rising_edge(clock))then
            if(state = S_ADDRESS)then
                
            end if;
        end if;
    end process;
    

    
--================ Process generate scl =================    
    PRO_5 : process(clock)
    begin
        if(rising_edge(clock))then
            if(to_integer( CounterClock_1) >= NUM_COUNTER )then
                scl_internal <= not scl_internal;
                CounterClock_1 <= (others => '0');
            else
                CounterClock_1 <= CounterClock_1 + 1;
            end if;
        end if;
    end process;
    
    scl <=  scl_internal    when    scl_en = '1'    else    'Z' ;
    sda <=  sda_internal    when    sda_en = '1'    else    'Z' ;   
    
    
    
    
end Behavioral;




















