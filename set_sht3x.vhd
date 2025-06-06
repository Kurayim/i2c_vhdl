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
         reset      :  in       std_logic;
         ex_signal  :  in       std_logic;
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
            sda          : inout std_logic
        );
    end component;
    
    -- Signals to connect to the UUT
    signal clock_s        : std_logic := '0';
    signal reset_s        : std_logic := '0';
    signal rw_s           : std_logic := '0';
    signal run_s          : std_logic := '0';
    signal address_s      : std_logic_vector(10 downto 0) := (others => '0');
    signal number_data_s  : std_logic_vector(6  downto 0) := (others => '0');
    signal w_data_s       : std_logic_vector(31 downto 0) := (others => '0');
    signal r_data_s       : std_logic_vector(31 downto 0);
    signal error_ack_s    : std_logic;
    signal busy_s         : std_logic;
    signal old_ex_signal   : std_logic;

begin
    
    -- Instantiate the Unit Under Test (UUT)
    uut: i2c
        generic map(
            NUM_COUNTER => 250,
            BIT_ADDRESS => 7
        )
        port map(
            clock        => clock_s,
            reset        => reset_s,
            rw           => rw_s,
            run          => run_s,
            address      => address_s,
            number_data  => number_data_s,
            w_data       => w_data_s,
            r_data       => r_data_s,
            error_ack    => error_ack_s,
            busy         => busy_s,
            scl          => scl,
            sda          => sda
        );

    main_pro : process(clock)
    begin
        if(rising_edge(clock))then
            old_ex_signal <= ex_signal;
            if(old_ex_signal = '1'  and  ex_signal = '0')then
                
                reset_s <= '1';
                rw_s <= '0';
                run_s <= '1';
                address_s <= "0000100101";
                number_data_s <= X"01";
                
            end if;
            if(reset = '0')then
                reset_s <= '0';
                rw_s <= '1';
                run_s <= '0';
                address_s <= "0000000000";
                number_data_s <= X"00";
                 
            end if;
        end if;
    end process;        
        
        
        
        

end Behavioral;







