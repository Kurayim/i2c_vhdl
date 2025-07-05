----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06/19/2025 12:22:57 AM
-- Design Name: 
-- Module Name: seven_segment - Behavioral
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

entity seven_segment is
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
end seven_segment;

architecture Behavioral of seven_segment is
    
    constant NUM_COUNTER    :   integer := clk_freq / 100;
    
    signal counter_clk      :   unsigned(15 downto 0);
    signal num_seg          :   unsigned((num_segment - 1) downto 0);
    
    signal segmant_en       :   std_logic_vector((num_segment - 1) downto 0);
    signal segmant_bit      :   unsigned(((num_segment*4) - 1) downto 0);
    signal points           :   unsigned((num_segment - 1) downto 0);
    
    signal flag_next        : std_logic;
    signal old_flag_next    : std_logic;
    
    
    
begin
    
    
    seg_en <= segmant_en;
    
    enable_seg : process(clk)
    begin
        if(rising_edge(clk))then
            
            
            
            if(reset = '0')then
                segmant_en <= std_logic_vector(to_unsigned(1,num_segment));
            elsif(old_flag_next = '0'  and  flag_next = '1')then
                segmant_en <= std_logic_vector(unsigned(segmant_en)  ror  1);
            end if;
            
        end if;
    end process;
    
    select_segment : process(clk)
    begin
        if(rising_edge(clk))then
            
            if(reset = '0')then
                --segmant_en <= std_logic_vector(to_unsigned(1,num_segment));
                
                
                
            elsif(old_flag_next = '0'  and  flag_next = '1')then
                if(num_seg = to_unsigned(0,num_segment))then
                    segmant_bit <= unsigned(bit_seg);
                    points      <= unsigned(bit_point);
                else
                    segmant_bit <= unsigned(segmant_bit) ror 4;
                    points <= unsigned(points) ror 1;
                end if;
            end if;
                
                seg_led(7) <= points(0);
                case(segmant_bit(3 downto 0)) is 
                    when "0000" =>
                        seg_led(6 downto 0) <= "1000000";
                    when "0001" =>
                        seg_led(6 downto 0) <= "1111001";
                    when "0010" =>
                        seg_led(6 downto 0) <= "0100100";
                    when "0011" =>
                        seg_led(6 downto 0) <= "0110000";
                    when "0100" =>
                        seg_led(6 downto 0) <= "0011001";
                    when "0101" =>
                        seg_led(6 downto 0) <= "0010010";
                    when "0110" =>
                        seg_led(6 downto 0) <= "0000011";
                    when "0111" =>
                        seg_led(6 downto 0) <= "1111000";
                    when "1000" =>
                        seg_led(6 downto 0) <= "0000000";
                    when "1001" =>
                        seg_led(6 downto 0) <= "0011000";
                    when others =>
                        seg_led(6 downto 0) <= "1111111";
                end case;
            
        end if;
    end process;   
    
    
    

    
    
    
    clock : process(clk)
    begin
        if(rising_edge(clk))then
            
            counter_clk <= counter_clk + 1;
            old_flag_next <= flag_next;
            
            
            if(counter_clk > to_unsigned(7,3))then
                flag_next   <= '0';
            end if;
            
            if(reset = '0')then
                flag_next <= '0';
                num_seg <= (others => '0');
                counter_clk <= (others => '0');
            elsif(counter_clk >= NUM_COUNTER)then
                counter_clk <= (others => '0');
                flag_next   <= '1';
                num_seg     <= num_seg + 1;
                if(num_seg >= num_segment - 1)then
                    num_seg <= (others => '0');
                end if;
                
            end if;
            
        end if;
    end process;
    
    
end Behavioral;















