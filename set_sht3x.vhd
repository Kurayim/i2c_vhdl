----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06/23/2025 11:53:37 PM
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
    port(
        clock      :  in       std_logic;
        reset_push :  in       std_logic;
        ex_signal  :  in       std_logic;
        scl        :  out      std_logic;
        sda        :  inout    std_logic;
        led        :  out      std_logic
    );
end set_sht3x;

architecture Behavioral of set_sht3x is

    component ila_0 
    port(
        clk    : in std_logic;
        probe0 : in std_logic;
        probe1 : in std_logic;
        probe2 : in std_logic;
        probe3 : in std_logic;
        probe4 : in STD_LOGIC_VECTOR (7  downto 0);
        probe5 : in STD_LOGIC_VECTOR (7  downto 0);
        probe6 : in STD_LOGIC_VECTOR (7  downto 0);
        probe7 : in STD_LOGIC_VECTOR (7  downto 0);
        probe8 : in STD_LOGIC_VECTOR (7  downto 0);
        probe9 : in STD_LOGIC_VECTOR (7  downto 0);
        probe10 : in STD_LOGIC_VECTOR (31  downto 0);
        probe11 : in STD_LOGIC_VECTOR (31  downto 0);
        probe12 : in STD_LOGIC_VECTOR (31  downto 0);
        probe13 : in STD_LOGIC_VECTOR (31  downto 0);
        probe14 : in STD_LOGIC_VECTOR (7  downto 0);
        probe15 : in STD_LOGIC_VECTOR (7  downto 0);
        probe16 : in STD_LOGIC_VECTOR (7  downto 0);
        probe17 : in STD_LOGIC_VECTOR (7  downto 0);
        probe18 : in STD_LOGIC_VECTOR (15  downto 0);
        probe19 : in STD_LOGIC_VECTOR (7  downto 0);
        probe20 : in STD_LOGIC_VECTOR (7  downto 0);
        probe21 : in std_logic_vector (35 downto 0)
    );
    end component;
    
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
           w_data_1     : in    STD_LOGIC_VECTOR (7  downto 0);
           w_data_2     : in    STD_LOGIC_VECTOR (7  downto 0);
           w_data_3     : in    STD_LOGIC_VECTOR (7  downto 0);
           w_data_4     : in    STD_LOGIC_VECTOR (7  downto 0);
           w_data_5     : in    STD_LOGIC_VECTOR (7  downto 0);
           w_data_6     : in    STD_LOGIC_VECTOR (7  downto 0);
           r_data_1     : out   STD_LOGIC_VECTOR (7  downto 0);
           r_data_2     : out   STD_LOGIC_VECTOR (7  downto 0);
           r_data_3     : out   STD_LOGIC_VECTOR (7  downto 0);
           r_data_4     : out   STD_LOGIC_VECTOR (7  downto 0);
           r_data_5     : out   STD_LOGIC_VECTOR (7  downto 0);
           r_data_6     : out   STD_LOGIC_VECTOR (7  downto 0);
           error_ack    : out   STD_LOGIC;
           busy         : out   STD_LOGIC;
           ready_data   : out   std_logic;
           scl          : out   STD_LOGIC;
           sda          : inout STD_LOGIC
        );
    end component;
    
    
    component seven_segment
    generic(clk_freq    : integer :=  50000000; 
            num_segment : integer :=  5
         );
    Port ( clk       : in  std_logic;
           reset     : in  std_logic;
           bit_seg   : in  std_logic_vector  (((Num_segment*4) - 1)  downto 0);
           bit_point : in  std_logic_vector  ((Num_segment - 1)      downto 0);
           seg_en    : out std_logic_vector ((num_segment - 1)      downto 0);
           seg_led   : out std_logic_vector (7 downto 0)
         );
    end component;
    
    
    
    
        component crc_8
        port(
            clk     : in  std_logic;
            rst     : in  std_logic;
            run     : in  std_logic;
            data_in : in  std_logic_vector(7  downto 0);
            ready   : out std_logic;
            crc     : out std_logic_vector(7  downto 0)
        );
    end component;
    
    component fixed_to_float
        port (
          aclk                   : in std_logic;
          aresetn                : in std_logic;
          s_axis_a_tvalid        : in std_logic;
          s_axis_a_tready        : out std_logic;
          s_axis_a_tdata         : in std_logic_vector(31 downto 0);
          m_axis_result_tvalid   : out std_logic;
          m_axis_result_tready   : in std_logic;
          m_axis_result_tdata    : out std_logic_vector(31 downto 0)
        );
     end component;
     
     component add_subtract 
        port (
            aclk                      : in std_logic;
            aresetn                   : in std_logic;
            s_axis_a_tvalid           : in std_logic;
            s_axis_a_tready           : out std_logic;
            s_axis_a_tdata            : in std_logic_vector(31 downto 0);
            s_axis_b_tvalid           : in std_logic;
            s_axis_b_tready           : out std_logic;
            s_axis_b_tdata            : in std_logic_vector(31 downto 0);
            s_axis_operation_tvalid   : in std_logic;
            s_axis_operation_tready   : out std_logic;
            s_axis_operation_tdata    : in std_logic_vector(5 downto 0);
            m_axis_result_tvalid      : out std_logic;
            m_axis_result_tready      : in std_logic;
            m_axis_result_tdata       : out std_logic_vector(31 downto 0)
        );
        end component;
        
     component multiply 
        port (
            aclk                      : in std_logic;
            aresetn                   : in std_logic;
            s_axis_a_tvalid           : in std_logic;
            s_axis_a_tready           : out std_logic;
            s_axis_a_tdata            : in std_logic_vector(31 downto 0);
            s_axis_b_tvalid           : in std_logic;
            s_axis_b_tready           : out std_logic;
            s_axis_b_tdata            : in std_logic_vector(31 downto 0);
            m_axis_result_tvalid      : out std_logic;
            m_axis_result_tready      : in std_logic;
            m_axis_result_tdata       : out std_logic_vector(31 downto 0)
        );
        end component;   
        
        component divide 
        port (
            aclk                      : in std_logic;
            aresetn                   : in std_logic;
            s_axis_a_tvalid           : in std_logic;
            s_axis_a_tready           : out std_logic;
            s_axis_a_tdata            : in std_logic_vector(31 downto 0);
            s_axis_b_tvalid           : in std_logic;
            s_axis_b_tready           : out std_logic;
            s_axis_b_tdata            : in std_logic_vector(31 downto 0);
            m_axis_result_tvalid      : out std_logic;
            m_axis_result_tready      : in std_logic;
            m_axis_result_tdata       : out std_logic_vector(31 downto 0)
        );
        end component;
        
        component float_to_fixed 
        port (
          aclk                   : in std_logic;
          aresetn                : in std_logic;
          s_axis_a_tvalid        : in std_logic;
          s_axis_a_tready        : out std_logic;
          s_axis_a_tdata         : in std_logic_vector(31 downto 0);
          m_axis_result_tvalid   : out std_logic;
          m_axis_result_tready   : in std_logic;
          m_axis_result_tdata    : out std_logic_vector(31 downto 0)
        );
        end component;
       

    
    
    
    signal led_sig  :   std_logic;
    

    
    
    type controller_type is (CU_IDEL, CU_START, CU_IIC, CU_CRC, CU_CALCULATE, CU_DISPLAY, CU_END);
    signal cu_state : controller_type := CU_IDEL; 

    type iic_type is (IIC_IDEL, IIC_SEND_COMMAND, IIC_READ_DATA);
    signal iic_state : iic_type := IIC_IDEL;    
    
    
    type crc_type is (CRC_IDEL, CRC_START, CRC_DATA_1, CRC_DATA_2, CRC_CHECK, CRC_END);
    signal crc_state : crc_type := CRC_IDEL; 
    
    type cal_type is (CAL_IDEL, CAL_START,
    CAL_RESET_XT, CAL_GIVE_XT, CAL_GET_XT,CAL_RESET_XH, CAL_GIVE_XH, CAL_GET_XH,
    CAL_MULTI_RESET_T, CAL_MULTI_GIVE_T, CAL_MULTI_GET_T,
    CAL_DIVID_RESET_T, CAL_DIVID_GIVE_T, CAL_DIVID_GET_T,
    CAL_SUB_RESET_T, CAL_SUB_GIVE_T, CAL_SUB_GET_T,
    CAL_LTX_RESET_T, CAL_LTX_GIVE_T, CAL_LTX_GET_T,
    CAL_DIVID_RESET_H, CAL_DIVID_GIVE_H, CAL_DIVID_GET_H,
    CAL_MULTI_RESET_H, CAL_MULTI_GIVE_H, CAL_MULTI_GET_H,
    CAL_LTX_RESET_H, CAL_LTX_GIVE_H, CAL_LTX_GET_H,
    CAL_EXTRACT_CHAR,
    CAL_END);
    signal cal_state : cal_type := CAL_IDEL; 
    
    type dis_type is (DIS_IDEL, DIS_RESET, DIS_GIVE, DIS_END);
    signal dis_state : dis_type := DIS_IDEL; 
    
    


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
    signal crc_temp_sig      : std_logic_vector (15 downto 0);
    signal crc_humi_sig      : std_logic_vector (15 downto 0);
    signal error_ack_sig     : std_logic;
    signal busy_sig          : std_logic;
    signal old_ex_signal     : std_logic;
    signal counter_time      : unsigned (20 downto 0) := (others => '0');
    signal let_rx            : std_logic;
    signal ready_data_sig    : std_logic;
    signal rst_crc           : std_logic;
    signal run_crc           : std_logic;
    signal data_in_crc_1       : std_logic_vector (7 downto 0);
    signal data_in_crc_2       : std_logic_vector (7 downto 0);
    signal ready_crc_1         : std_logic;
    signal ready_crc_2         : std_logic;
    signal old_ready_crc_1     : std_logic;
    signal old_ready_crc_2     : std_logic;
    signal temp_crc          : std_logic_vector (7 downto 0);
    signal humi_crc          : std_logic_vector (7 downto 0);
    signal out_crc_1           : std_logic_vector (7 downto 0);
    signal out_crc_2         : std_logic_vector (7 downto 0);
    signal Num_step          : unsigned (3 downto 0);
    signal Num_step_debug    : std_logic_vector (7 downto 0);
    signal Num_step_debug_1    : std_logic_vector (7 downto 0);
    
    signal old_ready_iic   : std_logic;
    
    
    
    signal crc_counter_clk    : unsigned (15 downto 0);
    signal crc_clock          : std_logic;
    
    signal cu_requst_iic     : std_logic;
    signal old_iic_requst   : std_logic;
    
    signal iic_respond_cu    : std_logic;
    signal old_iic_respond   : std_logic;

    signal cu_requst_crc     : std_logic;
    signal old_crc_requst   : std_logic;

    signal crc_respond_cu    : std_logic;
    signal old_crc_respond   : std_logic;
    
    signal crc_check_ok      : std_logic;
    
    
    
    signal cu_requst_cal     : std_logic;
    signal old_cal_requst    : std_logic;

    signal cal_respond_cu    : std_logic;
    signal old_cal_respond   : std_logic;
    
    signal cu_requst_dis     : std_logic;
    signal old_dis_requst    : std_logic;

    signal dis_respond_cu    : std_logic;
    signal old_dis_respond   : std_logic;
    
    

    -- fix to float
    signal fix_float_reset         :   std_logic;
    signal fix_float_valid         :   std_logic;
    signal fix_float_ready         :   std_logic;
    signal fix_float_data          :   std_logic_vector (31 downto 0);
    signal fix_float_result_valid  :   std_logic;
    signal fix_float_result_ready  :   std_logic;
    signal fix_float_result_data   :   std_logic_vector (31 downto 0);
    
    -- float to fix
    signal float_fix_reset         :   std_logic;
    signal float_fix_valid         :   std_logic;
    signal float_fix_ready         :   std_logic;
    signal float_fix_data          :   std_logic_vector (31 downto 0);
    signal float_fix_result_valid  :   std_logic;
    signal float_fix_result_ready  :   std_logic;
    signal float_fix_result_data   :   std_logic_vector (31 downto 0);
    
    -- substrac
    signal sub_reset         :   std_logic;
    signal sub_a_valid       :   std_logic;
    signal sub_a_ready       :   std_logic;
    signal sub_a_data        :   std_logic_vector (31 downto 0);
    signal sub_b_valid       :   std_logic;
    signal sub_b_ready       :   std_logic;
    signal sub_b_data        :   std_logic_vector (31 downto 0);
    signal sub_oper_valid    :   std_logic;
    signal sub_oper_ready    :   std_logic;
    signal sub_oper_data     :   std_logic_vector (5 downto 0);
    signal sub_result_valid  :   std_logic;
    signal sub_result_ready  :   std_logic;
    signal sub_result_data   :   std_logic_vector (31 downto 0);
    
    -- divide
    signal divi_reset         :   std_logic;
    signal divi_a_valid       :   std_logic;
    signal divi_a_ready       :   std_logic;
    signal divi_a_data        :   std_logic_vector (31 downto 0);
    signal divi_b_valid       :   std_logic;
    signal divi_b_ready       :   std_logic;
    signal divi_b_data        :   std_logic_vector (31 downto 0);
    signal divi_result_valid  :   std_logic;
    signal divi_result_ready  :   std_logic;
    signal divi_result_data   :   std_logic_vector (31 downto 0);
    
    -- multiply
    signal multi_reset         :   std_logic;
    signal multi_a_valid       :   std_logic;
    signal multi_a_ready       :   std_logic;
    signal multi_a_data        :   std_logic_vector (31 downto 0);
    signal multi_b_valid       :   std_logic;
    signal multi_b_ready       :   std_logic;
    signal multi_b_data        :   std_logic_vector (31 downto 0);
    signal multi_result_valid  :   std_logic;
    signal multi_result_ready  :   std_logic;
    signal multi_result_data   :   std_logic_vector (31 downto 0);
    
    signal step_extract_ch     :   unsigned (7 downto 0);

    

    
    
    
    
    
    
    
    
    
    
    
    
    
    signal tempratuer_bits          :   std_logic_vector (31 downto 0);
    signal humidity_bits            :   std_logic_vector (31 downto 0);
    
    signal tempratuer_fix          :   std_logic_vector (31 downto 0);
    signal humidity_fix            :   std_logic_vector (31 downto 0);
    signal tempratuer_cal          :   std_logic_vector (31 downto 0);
    
    signal tempratuer_bits_float    :   std_logic_vector (31 downto 0);
    signal humidity_bits_float      :   std_logic_vector (31 downto 0);
    
    signal result_calculate_A       :   std_logic_vector (31 downto 0);
    signal result_calculate_B       :   std_logic_vector (31 downto 0);
    
    
    signal integer_temp       :   unsigned (15 downto 0);
    signal decimal_temp       :   unsigned (35 downto 0);
    signal integer_humi       :   unsigned (15 downto 0);
    
    signal ch_temp_one       :   std_logic_vector (7 downto 0);
    signal ch_temp_two       :   std_logic_vector (7 downto 0);
    signal ch_temp_three     :   std_logic_vector (7 downto 0);
    signal ch_humi_one       :   std_logic_vector (7 downto 0);
    signal ch_humi_two       :   std_logic_vector (7 downto 0);
    
    
    signal sevg_reset             :   std_logic;
    signal sevg_bit_seg           :   std_logic_vector(19 downto 0);
    signal sevg_bit_point         :   std_logic_vector(4  downto 0);
    signal sevg_seg_en            :   std_logic_vector(4  downto 0);
    signal sevg_led               :   std_logic_vector(7  downto 0);
    
    
    
    
    
    constant const_float_45    : std_logic_vector := x"c2340000";
    constant const_float_175   : std_logic_vector := x"432f0000";
    constant const_float_100   : std_logic_vector := x"42c80000";
    constant const_float_65535 : std_logic_vector := x"477fff00";













begin

        led <= led_sig;

    uut : ila_0 
    port map(
        clk     => clock,
        probe0  => cu_requst_crc,
        probe1  => cu_requst_cal,
        probe2  => cal_respond_cu,
        probe3  => crc_check_ok,
        probe4  => r_data_1_sig,
        probe5  => r_data_2_sig,
        probe6  => r_data_3_sig,
        probe7  => r_data_4_sig,
        probe8  => r_data_5_sig,
        probe9  => ch_humi_one,
        probe10 => result_calculate_B,
        probe11 => tempratuer_fix,
        probe12 => tempratuer_bits_float,
        probe13 => tempratuer_bits,
        probe14 => Num_step_debug,
        probe15 => Num_step_debug_1,
        probe16 => ch_temp_one,
        probe17 => ch_temp_two,
        probe18 => std_logic_vector(integer_temp),
        probe19 => ch_temp_three,
        probe20 => ch_humi_two,
        probe21 => std_logic_vector(decimal_temp)
    );
    
    i2c_0: i2c
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
            ready_data     => ready_data_sig,
            scl            => scl,
            sda            => sda
        );
        
        
    sev_seg : seven_segment
    generic map(clk_freq    => 50000000,
                num_segment => 5
         )
    port map ( 
           clk          => clock,
           reset        => sevg_reset,      --1 BIT
           bit_seg      => sevg_bit_seg,    --20 BIT
           bit_point    => sevg_bit_point,  --5 BIT
           seg_en       => sevg_seg_en,     --5 BIT
           seg_led      => sevg_led         --8 BIT
         );
        

        
        
        
    crc_1  : crc_8
        port map(
            clk     => clock,
            rst     => rst_crc,
            run     => run_crc,
            data_in => data_in_crc_1,
            ready   => ready_crc_1,
            crc     => out_crc_1
        );
        
        
    crc_2  : crc_8
        port map(
            clk     => clock,
            rst     => rst_crc,
            run     => run_crc,
            data_in => data_in_crc_2,
            ready   => ready_crc_2,
            crc     => out_crc_2
        );
        
        
    xtl: fixed_to_float
        port map (
          aclk                 => clock,
          aresetn              => fix_float_reset,          --IN
          s_axis_a_tvalid      => fix_float_valid,          --IN
          s_axis_a_tready      => fix_float_ready,          --OUT
          s_axis_a_tdata       => fix_float_data,           --IN
          m_axis_result_tvalid => fix_float_result_valid,   --OUT
          m_axis_result_tready => fix_float_result_ready,   --IN
          m_axis_result_tdata  => fix_float_result_data     --IN
        );
        
       
     sub: add_subtract 
        port map (
            aclk                        => clock,                    
            aresetn                     => sub_reset,         --IN   
            s_axis_a_tvalid             => sub_a_valid,       --IN
            s_axis_a_tready             => sub_a_ready,       --OUT
            s_axis_a_tdata              => sub_a_data,        --IN
            s_axis_b_tvalid             => sub_b_valid,       --IN
            s_axis_b_tready             => sub_b_ready,       --OUT
            s_axis_b_tdata              => sub_b_data,        --IN
            s_axis_operation_tvalid     => sub_oper_valid,    --IN
            s_axis_operation_tready     => sub_oper_ready,    --OUT
            s_axis_operation_tdata      => sub_oper_data,     --IN
            m_axis_result_tvalid        => sub_result_valid,  --OUT
            m_axis_result_tready        => sub_result_ready,  --IN
            m_axis_result_tdata         => sub_result_data    --OUT
        );
        
     divi: divide 
        port map (
            aclk                        => clock,                    
            aresetn                     => divi_reset,          --IN
            s_axis_a_tvalid             => divi_a_valid,        --IN
            s_axis_a_tready             => divi_a_ready,        --OUT
            s_axis_a_tdata              => divi_a_data,         --IN
            s_axis_b_tvalid             => divi_b_valid,        --IN
            s_axis_b_tready             => divi_b_ready,        --OUT
            s_axis_b_tdata              => divi_b_data,         --IN
            m_axis_result_tvalid        => divi_result_valid,   --OUT
            m_axis_result_tready        => divi_result_ready,   --IN
            m_axis_result_tdata         => divi_result_data     --OUT
        );

    multi: multiply 
        port map (
            aclk                        => clock,                           
            aresetn                     => multi_reset,         --IN     
            s_axis_a_tvalid             => multi_a_valid,       --IN
            s_axis_a_tready             => multi_a_ready,       --OUT
            s_axis_a_tdata              => multi_a_data,        --IN
            s_axis_b_tvalid             => multi_b_valid,       --IN
            s_axis_b_tready             => multi_b_ready,       --OUT
            s_axis_b_tdata              => multi_b_data,        --IN
            m_axis_result_tvalid        => multi_result_valid,  --OUT
            m_axis_result_tready        => multi_result_ready,  --IN
            m_axis_result_tdata         => multi_result_data    --OUT
        );

      ltx: float_to_fixed
        port map (
          aclk                 => clock,
          aresetn              => float_fix_reset,          --IN
          s_axis_a_tvalid      => float_fix_valid,          --IN
          s_axis_a_tready      => float_fix_ready,          --OUT
          s_axis_a_tdata       => float_fix_data,           --IN
          m_axis_result_tvalid => float_fix_result_valid,   --OUT
          m_axis_result_tready => float_fix_result_ready,   --IN
          m_axis_result_tdata  => float_fix_result_data     --OUT
        );







        
    

    clock_manage : process(clock)
    begin
        if(rising_edge(clock))then
            crc_counter_clk <= crc_counter_clk + 1;
            
            
            
            if(crc_counter_clk >= to_unsigned(50,16))then
                crc_counter_clk <= (others => '0');
                if(crc_clock = '1')then
                    crc_clock <= '0';
                else
                    crc_clock <= '1';
                end if;
            end if;
            
            
        end if;
    end process;





  controller : process(clock)
    begin
        if(rising_edge(clock))then
            
            old_iic_respond <= iic_respond_cu;
            old_crc_respond <= crc_respond_cu;
            old_cal_respond <= cal_respond_cu;
            old_dis_respond <= dis_respond_cu;
            old_ex_signal   <= ex_signal;
            
            case(cu_state) is
                when CU_IDEL =>
                    Num_step_debug_1 <= x"00";
                   -- led_sig <= '1';
                    cu_requst_iic <= '0';
                    cu_requst_crc <= '0';
                    cu_requst_cal <= '0';
                    if(old_ex_signal = '1'  and  ex_signal = '0')then
                        Num_step_debug_1 <= x"01";
                        cu_state <= CU_START;
                    end if; 
                            
                when CU_START =>
                    cu_state <= CU_IIC;
                    Num_step_debug_1 <= x"02";
                            
                when CU_IIC =>
                    Num_step_debug_1 <= x"03";
                    cu_requst_iic <= '1';
                    if(old_iic_respond = '0' and iic_respond_cu = '1')then
                        Num_step_debug_1 <= x"04";
                        if(error_ack_sig = '1')then
                            Num_step_debug_1 <= x"05";
                            cu_state <= CU_IDEL;
                        else
                            cu_state <= CU_CRC;
                            Num_step_debug_1 <= x"06";
                        end if;
                        cu_requst_iic <= '0';
                    end if; 
                            
                when CU_CRC =>
                    cu_requst_crc <= '1';
                    Num_step_debug_1 <= x"07";
                    if(old_crc_respond = '0'  and  crc_respond_cu = '1')then
                        Num_step_debug_1 <= x"08";
                        cu_requst_crc <= '0';
                        if(crc_check_ok = '1')then
                            Num_step_debug_1 <= x"09";
                            cu_state <= CU_CALCULATE;
                        else
                            Num_step_debug_1 <= x"10";
                            cu_state <= CU_END;
                        end if;
                    end if; 
                
                when CU_CALCULATE =>
                    Num_step_debug_1 <= x"11";
                    cu_requst_cal <= '1';
                --    led_sig <= '0';
                    if(old_cal_respond = '0' and  cal_respond_cu = '1')then
                        Num_step_debug_1 <= x"12";
                       -- led_sig <= '0';
                        cu_requst_cal <= '0';
                        cu_state <= CU_DISPLAY;
                        
                    end if;
                    
                when CU_DISPLAY =>
                    Num_step_debug_1 <= x"13";
                    cu_requst_dis <= '1';
                    if(old_dis_respond = '0' and  dis_respond_cu = '1')then
                        Num_step_debug_1 <= x"14";
                        cu_requst_dis <= '0';
                        cu_state <= CU_END;
                    
                    end if;
                    
                when CU_END =>
                    Num_step_debug_1 <= x"15";
                    cu_state <= CU_IDEL;
                when others =>
                    Num_step_debug_1 <= x"16";
                    cu_state <= CU_IDEL;
            end case;

        end if;
    end process;



 
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    iic_unit : process(clock)
    begin
        if(rising_edge(clock))then
            
            old_iic_requst <= cu_requst_iic;
            old_ready_iic  <= ready_data_sig;
            
            case(iic_state) is
                when IIC_IDEL =>
                    address_sig <= "00001000100";
                    reset_sig <= '1';
                    iic_state <= IIC_SEND_COMMAND;
                --    Num_step_debug <= x"00";
                    
                    
                when IIC_SEND_COMMAND =>
                --    Num_step_debug <= x"01";
                    rw_sig          <= '0';
                    num_data_tx_sig <= std_logic_vector(to_unsigned(2,4));
                    w_data_1_sig    <= X"2c";
                    w_data_2_sig    <= X"06";
                    w_data_3_sig    <= X"00";
                    w_data_4_sig    <= X"00";
                    w_data_5_sig    <= X"00";
                    w_data_6_sig    <= X"00";
                    counter_time    <= (others => '0');
                    if(old_iic_requst = '0'  and  cu_requst_iic = '1')then
               --         Num_step_debug <= x"02";
                        iic_state <= IIC_READ_DATA;
                        iic_respond_cu <= '0';
                        run_sig <= '1';
                        
                    end if;
                    
                when IIC_READ_DATA =>
               --     Num_step_debug <= x"03";
                    counter_time <= counter_time + 1;
                    run_sig <= '0';
                    if(old_ready_iic = '0'  and  ready_data_sig = '1')then
                 --       Num_step_debug <= x"04";
                        iic_state <= IIC_IDEL;
                        iic_respond_cu <= '1';
                    elsif(counter_time = to_unsigned(1000000,20))then
                 --       Num_step_debug <= x"05";
                        rw_sig          <= '1';
                        run_sig         <= '1';
                        address_sig     <= "00001000100";
                        num_data_rx_sig <= "0110";
                        counter_time    <= (others => '0');
                    end if;
                    
                when others =>
                    iic_state <= IIC_IDEL;
            end case;
        end if;
    end process;
    
    
    
    

    crc_unit : process(clock)
    begin
        if(rising_edge(clock))then
            old_crc_requst <= cu_requst_crc;
            old_ready_crc_1  <= ready_crc_1;
            old_ready_crc_2  <= ready_crc_2;
            
            case(crc_state) is
                when CRC_IDEL =>
                    crc_state <= CRC_START;
                    run_crc     <= '0';
                    rst_crc     <= '0';
                    
                when CRC_START =>
                    if(old_crc_requst = '0'  and  cu_requst_crc = '1')then
                        crc_state      <= CRC_DATA_1;
                        crc_respond_cu <= '0';
                        crc_check_ok   <= '0';
                        rst_crc        <= '1';
                        run_crc        <= '1';
                        data_in_crc_1  <= r_data_1_sig;
                        data_in_crc_2  <= r_data_4_sig;
                    end if;
                    
                when CRC_DATA_1 =>
                    run_crc <= '0';
                    if(ready_crc_1 = '1'  and   ready_crc_2 <= '1')then
                        rst_crc        <= '1';
                        run_crc        <= '1';
                        data_in_crc_1  <= r_data_2_sig;
                        data_in_crc_2  <= r_data_5_sig;
                    end if;
                    if((old_ready_crc_1 = '1'  and  ready_crc_1 = '0')  or  (old_ready_crc_2 = '1'  and  ready_crc_2 = '0'))then
                        crc_state      <= CRC_DATA_2;
                    end if;
                
                when CRC_DATA_2 =>
                    run_crc <= '0';
                    if(ready_crc_1 = '1'  and   ready_crc_2 <= '1')then
                        crc_state      <= CRC_CHECK;
                        rst_crc        <= '1';
                        run_crc        <= '1';
                        data_in_crc_1  <= r_data_2_sig;
                        data_in_crc_2  <= r_data_5_sig;
                    end if;
                    
                when CRC_CHECK =>
                        crc_state <= CRC_END;
                    if(out_crc_1 = r_data_3_sig  and  out_crc_2 = r_data_6_sig)then
                        crc_check_ok   <= '1';
                    else
                        crc_check_ok   <= '0';
                    end if;
                        
                when CRC_END =>
                    crc_respond_cu <= '1';
                    crc_state      <= CRC_IDEL;    
                when others =>
                    crc_state <= CRC_IDEL;
            end case;
        end if;    
    end process;
    
        
        
        
    cal_unit : process(clock)
    begin
        if(rising_edge(clock))then
            old_cal_requst <= cu_requst_cal;
            
            case(cal_state) is
                when CAL_IDEL =>
                    cal_state              <= CAL_START;
                    fix_float_reset        <= '0';
                    fix_float_valid        <= '0';
                    fix_float_data         <= (others => '0');
                    fix_float_result_ready <= '0';
                    tempratuer_bits_float  <= (others => '0');
                    humidity_bits_float    <= (others => '0');
                    --
                    multi_reset            <= '0';
                    multi_a_valid          <= '0';
                    multi_a_data           <= (others => '0');
                    multi_b_valid          <= '0';
                    multi_b_data           <= (others => '0');
                    multi_result_ready     <= '0';
                    --
                    divi_reset          <= '0';
                    divi_a_valid        <= '0';
                    divi_a_data         <= (others => '0');
                    divi_b_valid        <= '0';
                    divi_b_data         <= (others => '0');
                    divi_result_ready   <= '0';
                    --
                    sub_reset           <= '0';
                    sub_a_valid         <= '0';
                    sub_a_data          <= (others => '0');
                    sub_b_valid         <= '0';
                    sub_b_data          <= (others => '0');
                    sub_oper_valid      <= '0';
                    sub_oper_data       <= (others => '0');
                    sub_result_ready    <= '0';
                    --
                    float_fix_reset <= '0';   
                    float_fix_valid <= '0';  
                    float_fix_data  <= (others => '0');
                    float_fix_result_ready <= '0';

                    integer_temp    <= (others => '0');
                    decimal_temp    <= (others => '0');
                    integer_humi    <= (others => '0');
                    ch_temp_one     <= (others => '0');
                    ch_temp_two     <= (others => '0');
                    ch_temp_three   <= (others => '0');
                    ch_humi_one     <= (others => '0');
                    ch_humi_two     <= (others => '0');
                    
                    
                    
                    
                    
                    
                            
                    
                    Num_step_debug <= x"00";
                      
                when CAL_START =>
                    Num_step_debug <= x"01";
                    if(old_cal_requst = '0'  and  cu_requst_cal = '1')then
                        tempratuer_fix                <= (others => '0');
                        humidity_fix                  <= (others => '0');
                        tempratuer_bits(15 downto 8)  <= r_data_1_sig;
                        tempratuer_bits(7 downto 0)   <= r_data_2_sig;
                        humidity_bits(15 downto 8)    <= r_data_4_sig;
                        humidity_bits(7 downto 0)     <= r_data_5_sig;
                        cal_respond_cu                 <= '0';
                        cal_state                      <= CAL_RESET_XT;
                        --led_sig <= '1';
                        Num_step_debug <= x"02";
                    end if;
                    
                when CAL_RESET_XT =>
                    Num_step_debug <= x"03";
                    fix_float_reset <= '0';
                    cal_state       <= CAL_GIVE_XT;
                    
                when CAL_GIVE_XT =>
                    Num_step_debug <= x"04";
                    fix_float_reset <= '1';
                    fix_float_valid <= '1';
                    fix_float_data  <= tempratuer_bits;
                    if(fix_float_ready = '1')then
                        Num_step_debug <= x"05";
                        cal_state <= CAL_GET_XT;
                    end if;
                    
                when CAL_GET_XT =>
                    Num_step_debug <= x"06";
                    if(fix_float_result_valid = '1')then
                        Num_step_debug <= x"07";
                        fix_float_result_ready <= '1';
                    --    led_sig <= '0';
                        tempratuer_bits_float  <= fix_float_result_data;
                        cal_state              <= CAL_RESET_XH;
                    end if;
                    
                    
                   
                   
                    
                when CAL_RESET_XH =>
                    Num_step_debug <= x"08";
                    fix_float_reset        <= '0';
                    fix_float_valid        <= '0';
                    fix_float_data         <= (others => '0');
                    fix_float_result_ready <= '0';
                    if(fix_float_reset = '0')then
                        Num_step_debug <= x"09";
                        cal_state              <= CAL_GIVE_XH;

                    end if;
                when CAL_GIVE_XH =>
                    Num_step_debug <= x"10";
                    fix_float_reset <= '1';
                    fix_float_valid <= '1';
                    fix_float_data  <= humidity_bits;
                    if(fix_float_ready = '1')then
                        Num_step_debug <= x"12";
                        cal_state <= CAL_GET_XH;
                    end if;
                    
                when CAL_GET_XH =>
                    Num_step_debug <= x"13";
                    if(fix_float_result_valid = '1')then
                        Num_step_debug <= x"14";
                   --     cal_respond_cu <= '1';
                        fix_float_result_ready <= '1';
                        humidity_bits_float    <= fix_float_result_data;
                        cal_state              <= CAL_MULTI_RESET_T;
                    end if;
                    
                    
                    
                    
                    
                    
                    
                    
                    
                when CAL_MULTI_RESET_T =>
                    Num_step_debug <= x"15";
                    multi_reset <= '0';
                    if(multi_reset = '0')then
                        Num_step_debug <= x"16";
                        cal_state <= CAL_MULTI_GIVE_T;
                    end if;
                when CAL_MULTI_GIVE_T =>
                    Num_step_debug <= x"17";
                    result_calculate_A  <= (others => '0');
                    multi_reset         <= '1';
                    multi_a_valid       <= '1';
                    multi_b_valid       <= '1';
                    multi_a_data        <= const_float_175;
                    multi_b_data        <= tempratuer_bits_float;
                    if(multi_a_ready = '1'  and  multi_b_ready = '1')then
                        Num_step_debug <= x"18";
                        cal_state <= CAL_MULTI_GET_T;
                    end if;
                    
                when CAL_MULTI_GET_T =>
                    Num_step_debug <= x"18";
                    if(multi_result_valid = '1')then
                        Num_step_debug <= x"19";
                        result_calculate_A <= multi_result_data;
                        multi_result_ready <= '1';
                        cal_state          <= CAL_DIVID_RESET_T;
                    end if;





                when CAL_DIVID_RESET_T =>
                    float_fix_reset <= '1';
                    Num_step_debug <= x"20";
                    divi_reset <= '0';
                    if(divi_reset = '0')then
                        Num_step_debug <= x"21";
                        cal_state <= CAL_DIVID_GIVE_T;
                    end if;
                when CAL_DIVID_GIVE_T =>
                    Num_step_debug <= x"22";
                    result_calculate_B  <= (others => '0');
                    divi_reset          <= '1';
                    divi_a_valid        <= '1';
                    divi_b_valid        <= '1';
                    divi_a_data         <= result_calculate_A;
                    divi_b_data         <= const_float_65535;
                    if(divi_a_ready = '1'  and  divi_b_ready = '1')then
                        Num_step_debug <= x"23";
                        cal_state <= CAL_DIVID_GET_T;
                    end if;
                when CAL_DIVID_GET_T =>
                    Num_step_debug <= x"24";
                    if(divi_result_valid = '1')then
                        Num_step_debug <= x"25";
                        divi_result_ready <= '1';
                        result_calculate_B <= divi_result_data;
                        cal_state          <= CAL_SUB_RESET_T;
                    end if;
                
                
            

                
                when CAL_SUB_RESET_T =>
                    float_fix_reset <= '0';
                    Num_step_debug <= x"26";
                    sub_reset <= '0';
                    if(sub_reset = '0')then
                        Num_step_debug <= x"27";
                        cal_state <= CAL_SUB_GIVE_T;
                    end if;
                
                when CAL_SUB_GIVE_T =>
                    Num_step_debug <= x"28";
                    tempratuer_bits_float <= (others => '0');
                    sub_reset          <= '1';
                    sub_a_valid        <= '1';
                    sub_b_valid        <= '1';
                    sub_oper_valid     <= '1'; 
                    sub_a_data         <= result_calculate_B;
                    sub_b_data         <= const_float_45;
                    sub_oper_data      <= "000000";
                    if(sub_a_ready = '1'  and  sub_b_ready = '1')then
                        Num_step_debug <= x"29";
                        cal_state <= CAL_SUB_GET_T;
                    end if;
                when CAL_SUB_GET_T =>
                    Num_step_debug <= x"30";
                    if(sub_result_valid = '1')then
                        Num_step_debug <= x"31";
                        sub_result_ready <= '1';
                        tempratuer_bits_float <= sub_result_data;
                        cal_state             <= CAL_LTX_RESET_T;
                    end if;
                
                
                
                
                
                
                
                when CAL_LTX_RESET_T =>
                    Num_step_debug <= x"32";
                    float_fix_reset <= '0';
                    tempratuer_bits <= (others => '0');
                    if(float_fix_reset <= '0')then
                        Num_step_debug <= x"33";
                        cal_state <= CAL_LTX_GIVE_T;
                    end if;     
                when CAL_LTX_GIVE_T =>
                    Num_step_debug <= x"34";
                    tempratuer_bits <= (others => '0');
                    float_fix_reset <= '1';
                    float_fix_valid <= '1';
                    float_fix_data  <= tempratuer_bits_float;
                    if(float_fix_ready = '1')then
                        Num_step_debug <= x"35";
                        cal_state <= CAL_LTX_GET_T;
                    end if;
                    
                when CAL_LTX_GET_T =>
                    Num_step_debug <= x"36";
                    if(float_fix_result_valid = '1')then
                        Num_step_debug <= x"37";
                        float_fix_result_ready <= '1';
                        tempratuer_fix         <= float_fix_result_data;
                        cal_state              <= CAL_DIVID_RESET_H;
                    end if;
                    
                

                
                
                
 
                when CAL_DIVID_RESET_H =>
                    Num_step_debug <= x"38";
                    divi_reset <= '0';
                    if(divi_reset = '0')then
                        Num_step_debug <= x"39";
                        result_calculate_B  <= (others => '0');
                        result_calculate_A  <= (others => '0');
                        cal_state           <= CAL_DIVID_GIVE_H;
                    end if;
                when CAL_DIVID_GIVE_H =>        
                    Num_step_debug <= x"40";
                    divi_reset          <= '1';
                    divi_a_valid        <= '1';
                    divi_b_valid        <= '1';
                    divi_a_data         <= humidity_bits_float;
                    divi_b_data         <= const_float_65535;
                    if(divi_a_ready = '1'  and  divi_b_ready = '1')then
                        Num_step_debug <= x"41";
                        cal_state <= CAL_DIVID_GET_H;
                    end if;
                when CAL_DIVID_GET_H =>
                    Num_step_debug <= x"42";
                    if(divi_result_valid = '1')then
                        Num_step_debug <= x"43";
                        divi_result_ready  <= '1';
                        result_calculate_A <= divi_result_data;
                        cal_state          <= CAL_MULTI_RESET_H;
                    end if;
                
                
                
                
                when CAL_MULTI_RESET_H =>
                    Num_step_debug <= x"44";
                    multi_reset <= '0';
                    if(multi_reset = '0')then
                        Num_step_debug <= x"45";
                        cal_state <= CAL_MULTI_GIVE_H;
                    end if;
                when CAL_MULTI_GIVE_H =>
                    Num_step_debug <= x"46";
                    result_calculate_B  <= (others => '0');
                    multi_reset         <= '1';
                    multi_a_valid       <= '1';
                    multi_b_valid       <= '1';
                    multi_a_data        <= result_calculate_A;
                    multi_b_data        <= const_float_100;
                    if(multi_a_ready = '1'  and  multi_b_ready = '1')then
                        Num_step_debug <= x"47";
                        cal_state <= CAL_MULTI_GET_H;
                    end if;
                    
                when CAL_MULTI_GET_H =>
                    Num_step_debug <= x"48";
                    if(multi_result_valid = '1')then
                        Num_step_debug <= x"49";
                        result_calculate_B <= multi_result_data;
                        multi_result_ready <= '1';
                        cal_state          <= CAL_LTX_RESET_H;
                    end if;
                
                
                
                
                when CAL_LTX_RESET_H =>                
                    Num_step_debug <= x"50";
                    float_fix_reset <= '0';
                    if(float_fix_reset <= '0')then
                        Num_step_debug <= x"51";
                        cal_state <= CAL_LTX_GIVE_H;
                    end if;     
                when CAL_LTX_GIVE_H =>
                    Num_step_debug <= x"52";
                    humidity_bits <= (others => '0');
                    float_fix_reset <= '1';
                    float_fix_valid <= '1';
                    float_fix_data  <= result_calculate_B;
                    if(float_fix_ready = '1')then
                        Num_step_debug <= x"53";
                        cal_state <= CAL_LTX_GET_H;
                    end if;
                    
                when CAL_LTX_GET_H =>
                    Num_step_debug <= x"54";
                    if(float_fix_result_valid = '1')then
                        Num_step_debug <= x"55";
                        float_fix_result_ready <= '1';
                        humidity_fix        <= float_fix_result_data;
                        cal_state              <= CAL_EXTRACT_CHAR;
                        step_extract_ch <= (others => '0');
                    end if;
                
                
                when CAL_EXTRACT_CHAR =>
                    if(step_extract_ch = x"00")then
                        Num_step_debug <= x"56";
                        step_extract_ch <= step_extract_ch + 1;
                       -- integer_humi <= std_logic_vector(unsigned(humidity_fix) and x"ffff0000");
                        integer_temp <= unsigned(tempratuer_fix(31 downto 16));
                        
                    elsif(step_extract_ch = x"01")then
                        Num_step_debug <= x"57";
                        step_extract_ch <= step_extract_ch + 1;
                        integer_humi <= unsigned(humidity_fix(31 downto 16)); 
                        ch_temp_one <= std_logic_vector(integer_temp(7 downto 0) / 10);
                        ch_temp_two <= std_logic_vector(integer_temp(7 downto 0) mod 10);
                         
                    elsif(step_extract_ch = x"02")then
                        Num_step_debug <= x"58";
                        step_extract_ch <= step_extract_ch + 1;
                        ch_humi_one <= std_logic_vector(unsigned(integer_humi(7 downto 0)) / X"0a");
                        ch_humi_two <= std_logic_vector(unsigned(integer_humi(7 downto 0)) mod X"0a");
                        tempratuer_cal <= tempratuer_fix  and  X"0000ffff";
                        --integer_temp <= unsigned(tempratuer_bits(15 downto 0));
                        
                    elsif(step_extract_ch = x"03")then
                        Num_step_debug <= x"59";
                        step_extract_ch <= step_extract_ch + 1;
                        decimal_temp <= unsigned(tempratuer_cal) * to_unsigned(10,4);
                        --decimal_temp <= integer_temp  *  to_unsigned(10,4);
                        
                    elsif(step_extract_ch = x"04")then
                        Num_step_debug <= x"60";
                        step_extract_ch <= step_extract_ch + 1;
                        ch_temp_three <= std_logic_vector(decimal_temp(23 downto 16));
                        cal_state <= CAL_END;
                        
                    end if;

                when CAL_END =>
                    Num_step_debug <= x"FF";
                    cal_respond_cu <= '1';
                    cal_state      <= CAL_IDEL;
                when others =>
                    cal_state <= CAL_IDEL;
            end case;
        end if;
    end process;


   display : process(clock)
   begin
        if(rising_edge(clock))then 
            
            old_dis_requst <= cu_requst_dis;
            
            
            case(dis_state) is
            
                when DIS_RESET =>
                    sevg_reset <= '0';
                    sevg_bit_seg <= (others => '0');
                    sevg_bit_point <= (others => '0');
                    
                when DIS_IDEL =>
                    
                    if(old_dis_requst = '0'  and  cu_requst_dis = '1')then
                        sevg_reset     <= '1';
                        dis_respond_cu <= '0';
                        dis_state      <= DIS_RESET;
                    end if;
                                   
                when DIS_GIVE =>
                    sevg_bit_seg(3 downto 0)   <= ch_temp_one(3 downto 0);
                    sevg_bit_seg(3 downto 0)   <= ch_temp_two(3 downto 0);
                    sevg_bit_seg(3 downto 0)   <= ch_temp_three(3 downto 0);
                    sevg_bit_seg(3 downto 0)   <= ch_humi_one(3 downto 0);
                    sevg_bit_seg(3 downto 0)   <= ch_humi_two(3 downto 0);
                    sevg_bit_point <= "00010";
                    dis_state      <= DIS_END;
                    
                when DIS_END =>
                    dis_respond_cu <= '1';
                    dis_state      <= DIS_IDEL;
                    
                when others =>
                    dis_state <= DIS_IDEL;
            end case;
            
            
        end if;
   end process;





end Behavioral;
