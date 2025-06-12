----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06/06/2025 06:06:55 AM
-- Design Name: 
-- Module Name: set_sht3x - Behavioral
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


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;


-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity set_sht3x is
    port(clock      :  in       std_logic;
         reset_push :  in       std_logic;
         ex_signal  :  in       std_logic;
         led        :  out      std_logic;
         scl        :  out      std_logic;
         sda        :  inout    std_logic
        );
end set_sht3x;

architecture Behavioral of set_sht3x is

    component i2c
        generic(
            NUM_COUNTER : integer := 250;
            BIT_ADDRESS : integer := 7
        );
        port(
            clock        : in    std_logic;
            reset        : in    std_logic;
            rw           : in    std_logic;
            run          : in    std_logic;
            address      : in    std_logic_vector(10 downto 0);
            number_data  : in    std_logic_vector(6  downto 0);
            w_data       : in    std_logic_vector(31 downto 0);
            r_data       : out   std_logic_vector(31 downto 0);
            error_ack    : out   std_logic;
            busy         : out   std_logic;
            scl          : out   std_logic;
            sda          : inout std_logic;
            led          : out   std_logic
        );
    end component;
    
    -- Signals to connect to the UUT
    
    signal reset_sig     : std_logic := '1';
    signal rw_sig        : std_logic := '0'; -- write = '0'
    signal run_sig       : std_logic := '0';
    signal address_sig   : std_logic_vector(10 downto 0) := (others => '0');
    signal number_data_sig : std_logic_vector(6 downto 0) := (others => '0');
    signal w_data_sig    : std_logic_vector(31 downto 0) := (others => '0');
    signal r_data_sig    : std_logic_vector(31 downto 0);
    signal error_ack_sig : std_logic;
    signal busy_sig      : std_logic;
    signal led_sig       : std_logic;
    signal old_ex_signal : std_logic;

begin
    
    -- Instantiate the Unit Under Test (UUT)
    uut: i2c
        generic map(
            NUM_COUNTER => 250,
            BIT_ADDRESS => 7
        )
        port map(
            clock        => clock,
            reset        => reset_sig,
            rw           => rw_sig,
            run          => run_sig,
            address      => address_sig,
            number_data  => number_data_sig,
            w_data       => w_data_sig,
            r_data       => r_data_sig,
            error_ack    => error_ack_sig,
            busy         => busy_sig,
            scl          => scl,
            sda          => sda,
            led          => led_sig
        );

    main_pro : process(clock)
    begin
        if(rising_edge(clock))then
            old_ex_signal <= ex_signal;
       --     led <= led_s;
            
            if(old_ex_signal = '1'  and  ex_signal = '0')then
                
--   --             led <= '1';
                reset_sig <= '1';
                rw_sig <= '0';
                run_sig <= '1';
                address_sig <= "00001000101";
                number_data_sig <= "0000001";
                
            end if;
            if(reset_push = '0')then
    --            led <= '0';
                reset_sig <= '0';
                rw_sig <= '1';
                run_sig <= '0';
                address_sig <= "00000000000";
                number_data_sig <= "0000001";
                  
            end if;
        end if;
    end process;        
        
        
        
        

end Behavioral;







