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
           clock        : in    STD_LOGIC;
           reset        : in    STD_LOGIC;
           rw           : in    STD_LOGIC;      -- rw = '1' --> read       rw = '0' --> write
           run          : in    STD_LOGIC;
           address      : in    STD_LOGIC_VECTOR (10 downto 0);
           num_data_tx  : in    STD_LOGIC_VECTOR (3  downto 0);
           num_data_rx  : in    STD_LOGIC_VECTOR (3  downto 0);
           w_data_1     : in    STD_LOGIC_VECTOR (7 downto 0);
           w_data_2     : in    STD_LOGIC_VECTOR (7 downto 0);
           w_data_3     : in    STD_LOGIC_VECTOR (7 downto 0);
           w_data_4     : in    STD_LOGIC_VECTOR (7 downto 0);
           w_data_5     : in    STD_LOGIC_VECTOR (7 downto 0);
           w_data_6     : in    STD_LOGIC_VECTOR (7 downto 0);
           r_data_1     : out   STD_LOGIC_VECTOR (7 downto 0);
           r_data_2     : out   STD_LOGIC_VECTOR (7 downto 0);
           r_data_3     : out   STD_LOGIC_VECTOR (7 downto 0);
           r_data_4     : out   STD_LOGIC_VECTOR (7 downto 0);
           r_data_5     : out   STD_LOGIC_VECTOR (7 downto 0);
           r_data_6     : out   STD_LOGIC_VECTOR (7 downto 0);
           error_ack    : out   STD_LOGIC;
           busy         : out   STD_LOGIC;
           scl          : out   STD_LOGIC;
           sda          : inout STD_LOGIC;
           led          : out   std_logic := '1'
            
        );
    end component;
    
    -- Signals to connect to the UUT
    
    signal reset_sig         : std_logic := '1';
    signal rw_sig            : std_logic := '0'; -- write = '0'
    signal run_sig           : std_logic := '0';
    signal address_sig       : std_logic_vector (10 downto 0):= (others => '0');
    signal num_data_tx_sig   : std_logic_vector (3 downto 0) := (others => '0');
    signal num_data_rx_sig   : std_logic_vector (3 downto 0) := (others => '0');
    signal w_data_1_sig      : std_logic_vector (7 downto 0) := (others => '0');
    signal w_data_2_sig      : std_logic_vector (7 downto 0) := (others => '0');
    signal w_data_3_sig      : std_logic_vector (7 downto 0) := (others => '0');
    signal w_data_4_sig      : std_logic_vector (7 downto 0) := (others => '0');
    signal w_data_5_sig      : std_logic_vector (7 downto 0) := (others => '0');
    signal w_data_6_sig      : std_logic_vector (7 downto 0) := (others => '0');
    signal r_data_1_sig      : std_logic_vector (7 downto 0);
    signal r_data_2_sig      : std_logic_vector (7 downto 0);
    signal r_data_3_sig      : std_logic_vector (7 downto 0);
    signal r_data_4_sig      : std_logic_vector (7 downto 0);
    signal r_data_5_sig      : std_logic_vector (7 downto 0);
    signal r_data_6_sig      : std_logic_vector (7 downto 0);
    signal error_ack_sig     : std_logic;
    signal busy_sig          : std_logic;
    signal led_sig           : std_logic;
    signal old_ex_signal     : std_logic;
    signal counter_time      : unsigned (20 downto 0) := (others => '0');
    signal let_rx            : std_logic := '0';

begin
    
    -- Instantiate the Unit Under Test (UUT)
    uut: i2c
        generic map(
            NUM_COUNTER => 250,
            BIT_ADDRESS => 7
        )
        port map(
            clock          => clock,
            reset          => reset_sig,
            rw             => rw_sig,
            run            => run_sig,
            address        => address_sig,
            num_data_tx    => num_data_tx_sig,
            num_data_rx    => num_data_rx_sig,
            w_data_1       => w_data_1_sig,
            w_data_2       => w_data_2_sig,
            w_data_3       => w_data_3_sig,
            w_data_4       => w_data_4_sig,
            w_data_5       => w_data_5_sig,
            w_data_6       => w_data_6_sig,
            r_data_1       => r_data_1_sig,
            r_data_2       => r_data_2_sig,
            r_data_3       => r_data_3_sig,
            r_data_4       => r_data_4_sig,
            r_data_5       => r_data_5_sig,
            r_data_6       => r_data_6_sig,
            error_ack      => error_ack_sig,
            busy           => busy_sig,
            scl            => scl,
            sda            => sda,
            led            => led
        );

    main_pro : process(clock)
    begin
        if(rising_edge(clock))then
            old_ex_signal <= ex_signal;
       --     led <= led_s;
            run_sig <= '0';
            if(old_ex_signal = '1'  and  ex_signal = '0')then
                
--   --             led <= '1';
                reset_sig <= '1';
                rw_sig <= '0';
                run_sig <= '1';
                address_sig <= "00001000100";
                num_data_tx_sig <= "0010";
                
                
                w_data_1_sig <= X"2c";
                w_data_2_sig <= X"06";
--                w_data_3_sig <= X"25";
--                w_data_4_sig <= X"36";
--                w_data_5_sig <= X"47";
--                w_data_6_sig <= X"58";

                let_rx  <= '1';
                counter_time <= (others => '0');
                
            end if;
            
            if(let_rx = '1')then
            counter_time <= counter_time + 1;
                if(counter_time = to_unsigned(1000000,20))then
                    let_rx <= '0';
                    rw_sig <= '1';
                    run_sig <= '1';
                    address_sig <= "00001000100";
                    num_data_rx_sig <= "0110";
                end if;
            end if;
            
            
            
            
            if(reset_push = '0')then
    --            led <= '0';
                reset_sig <= '0';
                rw_sig <= '1';
                run_sig <= '0';
                address_sig <= "00000000000";
                num_data_tx_sig <= "0000";
                num_data_rx_sig <= "0000";
                let_rx  <= '0';
                
            end if;
        end if;
    end process;        
        
        
        
        

end Behavioral;







