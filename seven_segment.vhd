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
    Port ( clk       : in STD_LOGIC;
           reset     : in STD_LOGIC;
           bit_seg   : in STD_LOGIC_VECTOR  (((Num_segment*5) - 1)  downto 0);
           bit_point : in STD_LOGIC_VECTOR  ((Num_segment - 1)      downto 0);
           seg_en    : out STD_LOGIC_VECTOR ((num_segment - 1)      downto 0);
           seg_led   : out STD_LOGIC_VECTOR (7 downto 0)
         );
end seven_segment;

architecture Behavioral of seven_segment is
    
    constant NUM_COUNTER    :   integer := clk_freq / 100;
    
    signal counter_clk      :   unsigned(15 downto 0);
    signal num_seg          :   unsigned((num_segment - 1) downto 0);
    
    
    
begin
    
    
    select_seg : process(clk)
    begin
        if(rising_edge(clk))then
        
            if(reset = '0')then
                seg_en(0) <= '0';
                seg_en(1) <= '0';
                seg_en(2) <= '0';
                seg_en(3) <= '0';
                seg_en(4) <= '0';
                
                seg_led <= (others => '0');
                
            elsif(num_seg = to_unsigned(0,num_segment))then
                seg_en(0) <= '1';
                seg_en(1) <= '0';
                seg_en(2) <= '0';
                seg_en(3) <= '0';
                seg_en(4) <= '0';
                
                
                case(bit_seg(3 downto 0)) is
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
                
                seg_led(7) <= bit_seg(4); 
                
                        
            elsif(num_seg = to_unsigned(1,num_segment))then
                seg_en(0) <= '0';
                seg_en(1) <= '1';
                seg_en(2) <= '0';
                seg_en(3) <= '0';
                seg_en(4) <= '0';
                
                case(bit_seg(8 downto 5)) is
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
                
                seg_led(7) <= bit_seg(9);
                
            elsif(num_seg = to_unsigned(2,num_segment))then
                seg_en(0) <= '0';
                seg_en(1) <= '0';
                seg_en(2) <= '1';
                seg_en(3) <= '0';
                seg_en(4) <= '0';
                
                case(bit_seg(13 downto 10)) is
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
                
                seg_led(7) <= bit_seg(14);
                                
            elsif(num_seg = to_unsigned(3,num_segment))then
                seg_en(0) <= '0';
                seg_en(1) <= '0';
                seg_en(2) <= '0';
                seg_en(3) <= '1';
                seg_en(4) <= '0';
                
                case(bit_seg(18 downto 15)) is
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
                
                seg_led(7) <= bit_seg(19);
                                
            elsif(num_seg = to_unsigned(4,num_segment))then
                seg_en(0) <= '0';
                seg_en(1) <= '0';
                seg_en(2) <= '0';
                seg_en(3) <= '0';
                seg_en(4) <= '1';
                
                case(bit_seg(23 downto 20)) is
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
                        
                    seg_led(7) <= bit_seg(24);
                    
                end case;
                                
            end if;
            
            
            
            
            
        end if;
    end process; 
    
    
    
    
    clock : process(clk)
    begin
        if(rising_edge(clk))then
            
            counter_clk <= counter_clk + 1;
            
            
            if(reset = '1')then
                num_seg <= (others => '0');
                counter_clk <= (others => '0');
            elsif(counter_clk >= NUM_COUNTER)then
                counter_clk <= (others => '0');
                num_seg <= num_seg + 1;
                if(num_seg >= num_segment)then
                    num_seg <= (others => '0');
                end if;
            end if;
        end if;
    end process;
    
    
end Behavioral;















