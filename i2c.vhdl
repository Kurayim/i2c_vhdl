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
           number_data  : in    STD_LOGIC_VECTOR (3  downto 0);
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
    signal let_data        : std_logic   := '1';
    signal scl_en          : std_logic   := '0';
    signal sda_en          : std_logic   := '0';
    signal old_scl         : std_logic   := '0';
    signal old_run         : std_logic   := '0';

    

    
    type state_type is (S_IDEL, S_READY, S_START, S_ADDRESS, S_SLV_ACK1, S_WRITE, S_SLV_ACK2, S_READ, S_mas_ACK1, S_END);
    signal state : state_type := S_IDEL;
    
    
begin
    
    

    
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
                    
                when S_READY =>
                    busy   <= '0';
                    if(old_run = '0'  and  run = '1')then
                        state <= S_START;
                        num_bit      <= to_unsigned(BIT_ADDRESS,7);
                    end if;
                    
                when S_START =>
                    busy         <= '1';
                    let_data     <= '1';
                    r_data_1       <= (others => '0');
                    r_data_2       <= (others => '0');
                    r_data_3       <= (others => '0');
                    r_data_4       <= (others => '0');
                    r_data_5       <= (others => '0');
                    r_data_6       <= (others => '0');
                    error_ack    <= '0';
                    scl_en       <= '1';
                    sda_en       <= '1';
                    sda_internal <= '0';
                    num_bit      <= (others => '0');
                    state        <= S_ADDRESS;
                    num_bit <= num_bit - 1;  --  Counting written bits
                          
                    
                when S_ADDRESS =>
                    if(scl_internal = '0' and  CounterClock_1 = 50)then  --  When we need to write the address bits
                        
                        num_bit <= num_bit - 1;  --  Counting written bits
                        
                        if(num_bit = "1111111")then
                            sda_internal <= rw;
                        elsif(num_bit = "1111110")then
                            num_bit <= (others => '0');
                            state <= S_SLV_ACK1;
                            sda_en       <= '0';
                        else
                            sda_internal <= address(to_integer(num_bit));  -- here we write address bits
                        end if;
                    end if;
                    
                    
                when S_SLV_ACK1 =>
                    if(scl_internal = '1' and  CounterClock_1 >= 50)then    -- Start sampling.
                        if(sda = '1')then    
                            cal_one <= cal_one + 1;  -- here we counting zeros and ones 
                        else
                            cal_zero <= cal_zero + 1;
                        end if;
                    end if;
                    if(old_scl = '1'  and  scl_internal = '0')then   -- Now we have to underastand ack
                        if(cal_zero > cal_one)then      -- ack
                            sda_en       <= '1';
                            cal_zero <= (others => '0');
                            cal_one  <= (others => '0');
                            if(rw = '1')then        
                                state   <= S_READ;    -- we want to read data from slave
                            else
                                state   <= S_WRITE;   -- we want to write data for slave
                                num_bit <= X"07";
                            end if; 
                        else                            -- nack
                            state       <= S_END;
                            error_ack   <= '1';
                        end if;
                    end if;
                    
                when S_WRITE =>
                    led <= '1';
                    if(scl_internal = '0' and  CounterClock_1 = 50)then
                        
                        num_bit <= num_bit - 1;
                        if(num_byte = unsigned(number_data))then
                            state <= S_END;
                        elsif(num_bit = "111111")then
                            state <= S_SLV_ACK2;
                        elsif(num_byte = X"01")then
                            sda_internal <= w_data_1(to_integer(num_bit));
                        elsif(num_byte = X"02")then
                            sda_internal <= w_data_2(to_integer(num_bit));
                        elsif(num_byte = X"03")then
                            sda_internal <= w_data_2(to_integer(num_bit));
                        elsif(num_byte = X"04")then
                            sda_internal <= w_data_2(to_integer(num_bit));
                        elsif(num_byte = X"04")then
                            sda_internal <= w_data_2(to_integer(num_bit));
                        elsif(num_byte = X"05")then
                            sda_internal <= w_data_2(to_integer(num_bit));
                        elsif(num_byte = X"06")then
                            sda_internal <= w_data_2(to_integer(num_bit));
                        end if;
                        
                        
                        
                        if((num_bit = 8  or  num_bit = 16  or  num_bit = 24  or  num_bit = 32) and let_data = '0')then
                            state <= S_SLV_ACK2;
                        else
                        --    sda_internal <= w_data(to_integer(num_bit));
                            num_bit <= num_bit + 1;
                            let_data     <= '0';
                        end if;
                        
                        
                    end if;
                when S_SLV_ACK2 =>
                    let_data     <= '1';
                    if(scl_internal = '1' and  CounterClock_1 >= 50)then    -- Start sampling.
                        if(sda = '1')then    
                            cal_one <= cal_one + 1;  -- here we counting zeros and ones 
                        else
                            cal_zero <= cal_zero + 1;
                        end if;
                    end if;
                    if(old_scl = '1'  and  scl_internal = '0')then   -- Now we have to underastand ack
                        if(cal_zero < cal_one)then      -- ack
                            cal_zero <= (others => '0');
                            cal_one  <= (others => '0');
                            if(num_bit >= unsigned(number_data))then
                                state <= S_END;
                            else
                                state <= S_WRITE;
                                num_byte <= num_byte + 1;
                                num_bit <= X"07";
                            end if;          
                        else                            -- nack
                            state       <= S_END;
                            error_ack   <= '1';
                        end if;
                    end if;
                    
                when S_READ =>
                    
                when S_mas_ACK1 =>
                    
                when S_END =>
                    state <= S_IDEL;
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
           number_data  : in    STD_LOGIC_VECTOR (3  downto 0);
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
    signal let_data        : std_logic   := '1';
    signal scl_en          : std_logic   := '0';
    signal sda_en          : std_logic   := '0';
    signal old_scl         : std_logic   := '0';
    signal old_run         : std_logic   := '0';

    

    
    type state_type is (S_IDEL, S_READY, S_START, S_ADDRESS, S_SLV_ACK1, S_WRITE, S_SLV_ACK2, S_READ, S_mas_ACK1, S_END);
    signal state : state_type := S_IDEL;
    
    
begin
    
    

    
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
                    
                when S_READY =>
                    busy   <= '0';
                    if(old_run = '0'  and  run = '1')then
                        state <= S_START;
                        num_bit      <= to_unsigned(BIT_ADDRESS,7);
                    end if;
                    
                when S_START =>
                    busy         <= '1';
                    let_data     <= '1';
                    r_data_1       <= (others => '0');
                    r_data_2       <= (others => '0');
                    r_data_3       <= (others => '0');
                    r_data_4       <= (others => '0');
                    r_data_5       <= (others => '0');
                    r_data_6       <= (others => '0');
                    error_ack    <= '0';
                    scl_en       <= '1';
                    sda_en       <= '1';
                    sda_internal <= '0';
                    num_bit      <= (others => '0');
                    state        <= S_ADDRESS;
                    num_bit <= num_bit - 1;  --  Counting written bits
                          
                    
                when S_ADDRESS =>
                    if(scl_internal = '0' and  CounterClock_1 = 50)then  --  When we need to write the address bits
                        
                        num_bit <= num_bit - 1;  --  Counting written bits
                        
                        if(num_bit = "1111111")then
                            sda_internal <= rw;
                        elsif(num_bit = "1111110")then
                            num_bit <= (others => '0');
                            state <= S_SLV_ACK1;
                            sda_en       <= '0';
                        else
                            sda_internal <= address(to_integer(num_bit));  -- here we write address bits
                        end if;
                    end if;
                    
                    
                when S_SLV_ACK1 =>
                    if(scl_internal = '1' and  CounterClock_1 >= 50)then    -- Start sampling.
                        if(sda = '1')then    
                            cal_one <= cal_one + 1;  -- here we counting zeros and ones 
                        else
                            cal_zero <= cal_zero + 1;
                        end if;
                    end if;
                    if(old_scl = '1'  and  scl_internal = '0')then   -- Now we have to underastand ack
                        if(cal_zero > cal_one)then      -- ack
                            sda_en       <= '1';
                            cal_zero <= (others => '0');
                            cal_one  <= (others => '0');
                            if(rw = '1')then        
                                state   <= S_READ;    -- we want to read data from slave
                            else
                                state   <= S_WRITE;   -- we want to write data for slave
                                num_bit <= X"07";
                            end if; 
                        else                            -- nack
                            state       <= S_END;
                            error_ack   <= '1';
                        end if;
                    end if;
                    
                when S_WRITE =>
                    led <= '1';
                    if(scl_internal = '0' and  CounterClock_1 = 50)then
                        
                        num_bit <= num_bit - 1;
                        if(num_byte = unsigned(number_data))then
                            state <= S_END;
                        elsif(num_bit = "111111")then
                            state <= S_SLV_ACK2;
                        elsif(num_byte = X"01")then
                            sda_internal <= w_data_1(to_integer(num_bit));
                        elsif(num_byte = X"02")then
                            sda_internal <= w_data_2(to_integer(num_bit));
                        elsif(num_byte = X"03")then
                            sda_internal <= w_data_2(to_integer(num_bit));
                        elsif(num_byte = X"04")then
                            sda_internal <= w_data_2(to_integer(num_bit));
                        elsif(num_byte = X"04")then
                            sda_internal <= w_data_2(to_integer(num_bit));
                        elsif(num_byte = X"05")then
                            sda_internal <= w_data_2(to_integer(num_bit));
                        elsif(num_byte = X"06")then
                            sda_internal <= w_data_2(to_integer(num_bit));
                        end if;
                        
                        
                        
                        if((num_bit = 8  or  num_bit = 16  or  num_bit = 24  or  num_bit = 32) and let_data = '0')then
                            state <= S_SLV_ACK2;
                        else
                        --    sda_internal <= w_data(to_integer(num_bit));
                            num_bit <= num_bit + 1;
                            let_data     <= '0';
                        end if;
                        
                        
                    end if;
                when S_SLV_ACK2 =>
                    let_data     <= '1';
                    if(scl_internal = '1' and  CounterClock_1 >= 50)then    -- Start sampling.
                        if(sda = '1')then    
                            cal_one <= cal_one + 1;  -- here we counting zeros and ones 
                        else
                            cal_zero <= cal_zero + 1;
                        end if;
                    end if;
                    if(old_scl = '1'  and  scl_internal = '0')then   -- Now we have to underastand ack
                        if(cal_zero < cal_one)then      -- ack
                            cal_zero <= (others => '0');
                            cal_one  <= (others => '0');
                            if(num_bit >= unsigned(number_data))then
                                state <= S_END;
                            else
                                state <= S_WRITE;
                                num_byte <= num_byte + 1;
                                num_bit <= X"07";
                            end if;          
                        else                            -- nack
                            state       <= S_END;
                            error_ack   <= '1';
                        end if;
                    end if;
                    
                when S_READ =>
                    
                when S_mas_ACK1 =>
                    
                when S_END =>
                    state <= S_IDEL;
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




















