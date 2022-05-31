-----------------------------------------------------------------------------
--Company: TEIS
--Engineer: Dominik Socher
--Created Date: Friday, March 26th 2021
-----------------------------------------------------------------------------
--File: c:\Users\Dominik\Documents\TEIS\ip_projects\seven_segment_decoder.vhd
--Project: c:\Users\Dominik\Documents\TEIS\ip_projects
--Target Device: 10M50DAF484C7G
--Tool version: Quartus 18.1 and ModelSim 10.5b
--Testbench file:
-----------------------------------------------------------------------------
--
-----------------------------------------------------------------------------
--Copyright (c) 2021 TEIS
-----------------------------------------------------------------------------
--
-----------------------------------------------------------------------------
--HISTORY:
--Date          By     Comments
------------    ---    ------------------------------------------------------
--
-----------------------------------------------------------------------------
--Description:
--        
--        
--        
--        
-----------------------------------------------------------------------------
--In Signals:
--        
--        
--Out Signals:
--        
--        
-----------------------------------------------------------------------------
--verified with the DE10-Lite board 
-----------------------------------------------------------------------------
-----------------------------------------------------------------------------
--Company: TEIS
--Engineer: Dominik Socher
--Created Date: Wednesday, March 24th 2021
-----------------------------------------------------------------------------
--File: c:\Users\Dominik\Documents\TEIS\ip_projects\seven_segment_ip\seven_segment_decoder.vhd
--Project: c:\Users\Dominik\Documents\TEIS\ip_projects\seven_segment_ip
--Target Device: 10M50DAF484C7G
--Tool version: Quartus 18.1 and ModelSim 10.5b
--Testbench file:
-----------------------------------------------------------------------------
--
-----------------------------------------------------------------------------
--Copyright (c) 2021 TEIS
-----------------------------------------------------------------------------
--
-----------------------------------------------------------------------------
--HISTORY:
--Date          By     Comments
------------    ---    ------------------------------------------------------
--
-----------------------------------------------------------------------------
--Description:
--        Decoder for 8-4-2-1-BCD-Code.
--        Pseudo-tetraden are not used for this project. 
--        
--        
-----------------------------------------------------------------------------
--  
-----------------------------------------------------------------------------
--verified with the DE10-Lite board 
-----------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity seven_segment_decoder is
    port (
        clk_in    : in std_logic;                    -- system clock
        rst_n_in  : in std_logic;                    -- asynchronous reset
        ena_in    : in std_logic;
        digit_in  : in std_logic_vector(3 downto 0); -- bcd digit 
        seg_out : out std_logic_vector (6 downto 0)
        );
end entity seven_segment_decoder;

architecture rtl of seven_segment_decoder is

    signal decoded_digit_s : std_logic_vector(6 downto 0);
    
begin
    
--============================================================================
--              DECODER PROCESS
--              Decoder for 8-4-2-1-BCD-Code.
--============================================================================
    decoder: process(clk_in, rst_n_in)
    begin
        if rst_n_in = '0' then
            decoded_digit_s <= (others => '0');
            seg_out         <= (others => '1');
        elsif rising_edge(clk_in) then
            if ena_in = '1' then 
                case digit_in is
    -----------------------TETRADEN------------------------               
                    when "0000" =>
                        decoded_digit_s <= "1000000"; -- 0
                    when "0001" =>
                        decoded_digit_s <= "1111001"; -- 1
                    when "0010" =>
                        decoded_digit_s <= "0100100"; -- 2
                    when "0011" =>
                        decoded_digit_s <= "0110000"; -- 3
                    when "0100" =>
                        decoded_digit_s <= "0011001"; -- 4
                    when "0101" =>
                        decoded_digit_s <= "0010010"; -- 5
                    when "0110" =>
                        decoded_digit_s <= "0000010"; -- 6
                    when "0111" =>
                        decoded_digit_s <= "1111000"; -- 7
                    when "1000" =>
                        decoded_digit_s <= "0000000"; -- 8
                    when "1001" =>
                        decoded_digit_s <= "0011000"; -- 9
    -----------------------PSEUDO-TETRADEN-----------------    
    --                when 1010 =>
    --                    decoded_digit_s <= "0001000"; -- A
    --                when 1011 =>
    --                    decoded_digit_s <= "0000011"; -- B
    --                when 1100 => 
    --                    decoded_digit_s <= "1000110"; -- C
    --                when 1101 =>
    --                    decoded_digit_s <= "0100001"; -- D
    --                when 1110 =>
    --                    decoded_digit_s <= "0000110"; -- E
    --                when 1111 =>
    --                    decoded_digit_s <= "0001110";  -- F
                    when others =>
                        decoded_digit_s <= "1111111"; -- 0      
                end case;
            else
                decoded_digit_s <= "1111111";
            end if;
            --allocate data to segment
            seg_out <= decoded_digit_s;
        end if;
    end process decoder;  
end architecture rtl;