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
    generic(NUM_COUNTER : integer := 250;
            BIT_ADDRESS : integer := 7
            );
    Port ( clock        : in    STD_LOGIC;
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
end i2c;

architecture Behavioral of i2c is
    
    signal CounterClock_1  : unsigned(8 downto 0) := (others => '0');  -- 9-Bit counter for scl timing 
    signal num_bit         : unsigned(6 downto 0) := (others => '0');  -- Counting data bit
    signal num_byte        : unsigned(3 downto 0) := (others => '0');  
    signal cal_zero        : unsigned(8 downto 0) := (others => '0');
    signal cal_one         : unsigned(8 downto 0) := (others => '0'); 
    signal scl_internal    : std_logic   := '1';
    signal sda_internal    : std_logic   := '1';
    signal scl_en          : std_logic   := '0';
    signal sda_en          : std_logic   := '0';
    signal old_scl         : std_logic   := '0';
    signal old_run         : std_logic   := '0';
    signal r_data_1_ila      : std_logic_vector (7 downto 0);
    signal r_data_2_ila      : std_logic_vector (7 downto 0);
    signal r_data_3_ila      : std_logic_vector (7 downto 0);
    signal r_data_4_ila      : std_logic_vector (7 downto 0);
    signal r_data_5_ila      : std_logic_vector (7 downto 0);
    signal r_data_6_ila      : std_logic_vector (7 downto 0);

    

    
    type state_type is (S_IDEL, S_READY, S_START, S_ADDRESS, S_SLV_ACK1, S_WRITE, S_SLV_ACK2, S_READ, S_mas_ACK1, S_END);
    signal state : state_type := S_IDEL;
    
    
    component ila_0
    port (
        clk    : in  std_logic;
        probe0 : in  std_logic_vector(7 downto 0);
        probe1 : in  std_logic_vector(7 downto 0);
        probe2 : in  std_logic_vector(7 downto 0);
        probe3 : in  std_logic_vector(7 downto 0);
        probe4 : in  std_logic_vector(7 downto 0);
        probe5 : in  std_logic_vector(7 downto 0)
    );
end component;
    
    
    
     
    
begin
    
    ila_inst : ila_0
   port map (
     clk    => clock,
     probe0 => r_data_1_ila,
     probe1 => r_data_2_ila,
     probe2 => r_data_3_ila,
     probe3 => r_data_4_ila,
     probe4 => r_data_5_ila,
     probe5 => r_data_6_ila
   );
   
   
   
   
    r_data_1 <= r_data_1_ila;
    r_data_2 <= r_data_2_ila;
    r_data_3 <= r_data_3_ila;
    r_data_4 <= r_data_4_ila;
    r_data_5 <= r_data_5_ila;
    r_data_6 <= r_data_6_ila;
    
    
--================ Process operation =================    
    PRO_1 : process(clock)
    begin
        
        if(rising_edge(clock))then
            old_scl <= scl_internal;
            old_run <= run;
            
            led <= '0';
        
            if(reset = '0')then
                state <= S_IDEL;
            end if;
            
--            if(run = '1')then
--                led <= '1';
--            else
--                led <= '0';
--            end if;
           led <= '1';
            
            case(state) is
                when S_IDEL =>
                    state <= S_READY;
                    scl_en <= '0';
                    sda_en <= '0'; 
                    sda_internal <= '0';
                    busy   <= '0';                   
                    
                when S_READY =>
                    if(old_run = '0'  and  run = '1')then
                        state   <= S_START;
                        num_bit <= to_unsigned(BIT_ADDRESS,7);
                    end if;
                    
                when S_START =>
                    busy         <= '1';
                    r_data_1_ila     <= (others => '0');
                    r_data_2_ila     <= (others => '0');
                    r_data_3_ila     <= (others => '0');
                    r_data_4_ila     <= (others => '0');
                    r_data_5_ila     <= (others => '0');
                    r_data_6_ila     <= (others => '0');
                    cal_zero     <= (others => '0');
                    cal_one      <= (others => '0');
                    error_ack    <= '0';
                    scl_en       <= '1';
                    sda_en       <= '1';
                    sda_internal <= '0';
                    state        <= S_ADDRESS;
                    num_bit      <= num_bit - 1;  --  Counting written bits
                          
                    
                when S_ADDRESS =>
                    if(scl_internal = '0' and  CounterClock_1 = 50)then  --  When we need to write the address bits
                        
                        num_bit <= num_bit - 1;  --  Counting written bits
                        
                        if(num_bit = "1111111")then
                            sda_internal <= rw;
                        elsif(num_bit = "1111110")then
                            num_bit <= (others => '0');
                            state <= S_SLV_ACK1;
                            sda_en <= '0';
                        else
                            sda_internal <= address(to_integer(num_bit));  -- here we write address bits
                        end if;
                    end if;
                    
                    
                when S_SLV_ACK1 =>
                    if(scl_internal = '1' and  CounterClock_1 >= 50)then    -- Start sampling.
                        if(sda = '1')then    
                            cal_one  <= cal_one + 1;  -- here we counting zeros and ones 
                        else
                            cal_zero <= cal_zero + 1;
                        end if;
                    end if;
                    if(old_scl = '1'  and  scl_internal = '0')then   -- Now we have to underastand ack
                        if(cal_zero > cal_one)then      -- ack
                            cal_zero <= (others => '0');
                            cal_one  <= (others => '0');
                            num_bit  <= to_unsigned(7,7);
                            num_byte <= to_unsigned(1,4);
                            if(rw = '1')then        
                                state    <= S_READ;    -- we want to read data from slave
                                sda_en   <= '0';
                            else
                                state    <= S_WRITE;   -- we want to write data for slave
                                sda_en   <= '1';
                            end if; 
                        else                            -- nack
                            state       <= S_END;
                            sda_en      <= '1';
                            error_ack   <= '1';
                        end if;
                    end if;
                    
                when S_WRITE =>
                    led <= '1';
                    if(scl_internal = '0' and  CounterClock_1 = 50)then
                        
                        num_bit <= num_bit - 1;

                        if(num_bit = to_unsigned(127,7))then
                            state <= S_SLV_ACK2;
                            sda_en       <= '0';
                        elsif(num_byte = to_unsigned(1,4))then
                            sda_internal <= w_data_1(to_integer(num_bit));
                        elsif(num_byte = to_unsigned(2,4))then
                            sda_internal <= w_data_2(to_integer(num_bit));
                        elsif(num_byte = to_unsigned(3,4))then
                            sda_internal <= w_data_3(to_integer(num_bit));
                        elsif(num_byte = to_unsigned(4,4))then
                            sda_internal <= w_data_4(to_integer(num_bit));
                        elsif(num_byte = to_unsigned(5,4))then
                            sda_internal <= w_data_5(to_integer(num_bit));
                        elsif(num_byte = to_unsigned(6,4))then
                            sda_internal <= w_data_6(to_integer(num_bit));
                        end if;

                    end if;
                    
                when S_SLV_ACK2 =>
                    if(scl_internal = '1' and  CounterClock_1 >= 50)then    -- Start sampling.
                        if(sda = '1')then    
                            cal_one <= cal_one + 1;  -- here we counting zeros and ones 
                        else
                            cal_zero <= cal_zero + 1;
                        end if;
                    end if;
                    if(old_scl = '1'  and  scl_internal = '0')then   -- Now we have to underastand ack
                        if(cal_zero > cal_one)then      -- ack
                            cal_zero <= (others => '0');
                            cal_one  <= (others => '0');
                            if(num_byte >= unsigned(num_data_tx))then
                                state   <= S_END;
                                sda_en  <= '1';
                            else
                                state    <= S_WRITE;
                                sda_en   <= '1';
                                num_byte <= num_byte + 1;
                                num_bit  <= to_unsigned(7,7);
                            end if;          
                        else                            -- nack
                            state       <= S_END;
                            sda_en      <= '1';
                            error_ack   <= '1';
                        end if;
                    end if;
                    
                    
                    
                when S_READ =>
                
                    if(scl_internal = '1' and  CounterClock_1 >= 50)then
                        if(sda = '1')then    
                            cal_one <= cal_one + 1;  
                        else
                            cal_zero <= cal_zero + 1;
                        end if;
                    end if;
                    if(old_scl = '1'  and  scl_internal = '0')then
                        cal_zero <= (others => '0');
                        cal_one  <= (others => '0');
                        num_bit  <= num_bit - 1;
                        if(cal_zero < cal_one)then     
                           if(num_byte = to_unsigned(1,4))then
                               r_data_1_ila(to_integer(num_bit)) <= '1';               
                           elsif(num_byte = to_unsigned(2,4))then
                               r_data_2_ila(to_integer(num_bit)) <= '1';
                           elsif(num_byte = to_unsigned(3,4))then
                               r_data_3_ila(to_integer(num_bit)) <= '1';
                           elsif(num_byte = to_unsigned(4,4))then
                               r_data_4_ila(to_integer(num_bit)) <= '1';
                           elsif(num_byte = to_unsigned(5,4))then
                               r_data_5_ila(to_integer(num_bit)) <= '1';
                           elsif(num_byte = to_unsigned(6,4))then
                               r_data_6_ila(to_integer(num_bit)) <= '1';
                           end if;
                        else    
                            if(num_byte = to_unsigned(1,4))then
                               r_data_1_ila(to_integer(num_bit)) <= '0';               
                           elsif(num_byte = to_unsigned(2,4))then
                               r_data_2_ila(to_integer(num_bit)) <= '0';
                           elsif(num_byte = to_unsigned(3,4))then
                               r_data_3_ila(to_integer(num_bit)) <= '0';
                           elsif(num_byte = to_unsigned(4,4))then
                               r_data_4_ila(to_integer(num_bit)) <= '0';
                           elsif(num_byte = to_unsigned(5,4))then
                               r_data_5_ila(to_integer(num_bit)) <= '0';
                           elsif(num_byte = to_unsigned(6,4))then
                               r_data_6_ila(to_integer(num_bit)) <= '0';
                           end if;
                        end if;
                        if(num_bit = to_unsigned(0,7))then
                            state <= S_mas_ACK1;
                        end if;
                    end if;
                    
                when S_mas_ACK1 =>
                    if(scl_internal = '0' and  CounterClock_1 = 50)then
                        sda_internal <= '0';
                        sda_en   <= '1';
                    end if;
                    if(old_scl = '1'  and  scl_internal = '0')then
                        if(num_byte >= unsigned(num_data_rx))then
                            state <= S_END;
                            sda_en   <= '1';
                        else
                            state <= S_READ;
                            sda_en   <= '0';
                            num_byte <= num_byte + 1;
                            num_bit  <= to_unsigned(7,7);
                        end if;
                    end if;
                when S_END =>
                    sda_internal <= '0';
                    if(scl_internal = '1' and  CounterClock_1 >= 50)then
                        state        <= S_IDEL;
                        sda_internal <= '1';
                        scl_en       <= '0';
                        sda_en       <= '0';
                    end if;
                when others =>
                    state <= S_IDEL;
            end case;
        end if;
    end process;
    


    
--================ Process generate scl =================    
    PRO_2 : process(clock)
    begin
        if(rising_edge(clock))then
            if(scl_en = '0')then
                CounterClock_1  <= (others => '0');
                scl_internal    <= '1';
            else
                if(to_integer( CounterClock_1) >= NUM_COUNTER )then
                    scl_internal    <= not scl_internal;
                    CounterClock_1  <= (others => '0');
                else
                    CounterClock_1  <= CounterClock_1 + 1;
                end if;
            end if;
        end if;
    end process;
    
    scl <=  scl_internal    when    scl_en = '1'    else    'Z' ;
    sda <=  sda_internal    when    sda_en = '1'    else    'Z' ;   
    
    
    
    
end Behavioral;




















