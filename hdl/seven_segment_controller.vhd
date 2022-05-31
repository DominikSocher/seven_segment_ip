-----------------------------------------------------------------------------
--Company: TEIS
--Engineer: Dominik Socher
--Created Date: Wednesday, March 24th 2021
-----------------------------------------------------------------------------
--File: c:\Users\Dominik\Documents\TEIS\ip_projects\seven_segment_ip\seven_segment_controller.vhd
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
--        This is the statemachine to decde all OP-codes
--        
--        
--        
-----------------------------------------------------------------------------
--    
-----------------------------------------------------------------------------
--verified with the DE10-Lite board 
-----------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity seven_segment_controller is
    port (
        ckl_in          : in std_logic;
        rst_n_in        : in std_logic;
        data_in         : in std_logic_vector(15 downto 0);
        data_out        : out std_logic_vector(7 downto 0);
        ena_display_out : out std_logic_vector(2 downto 0)  
    );
end entity seven_segment_controller;

architecture rtl of seven_segment_controller is

    --building enumerated type for state machine
    type state_controller is(fetch,decode,execute_off,
                            execute_on, execute_display_a, execute_display_b, execute_display_c, execute_display_all,execute_test_on,execute_test_off);
    --register holds current state
    signal state_s : state_controller;

    --opcodes seven segment controller
    --activate/activate controller
    constant controller_off : std_logic_vector(7 downto 0) := x"00";
    constant controller_on  : std_logic_vector(7 downto 0) := x"01";
    --choose display
    constant display_a_on   : std_logic_vector(7 downto 0) := x"11";
    constant display_b_on   : std_logic_vector(7 downto 0) := x"21";
    constant display_c_on   : std_logic_vector(7 downto 0) := x"41";
    constant display_all_on : std_logic_vector(7 downto 0) := x"f1";
    --diplay self test
    constant display_test_on    : std_logic_vector(7 downto 0) := x"f9";
    constant display_test_off   : std_logic_vector(7 downto 0) := x"08";
    --register
    signal data_reg_s : std_logic_vector(7 downto 0);
    signal inst_reg_s : std_logic_vector(7 downto 0);
    signal on_s       : std_logic;
   
begin

    state_machine: process(ckl_in, rst_n_in)
    begin
        if rst_n_in = '0' then
            on_s            <= '0';
            data_out        <= (others => '0');
            ena_display_out <= (others => '0');
            data_reg_s      <= (others => '0');  
            inst_reg_s      <= (others => '0');
        elsif rising_edge(ckl_in) then
            case state_s is
                when fetch =>
                    inst_reg_s <= data_in (15 downto 8);
                    data_reg_s <= data_in (7 downto 0);
                    state_s <= decode; 
                when decode =>
                    case inst_reg_s is
                        when controller_off =>
                            state_s <= execute_off;
                        when controller_on =>
                            state_s <= execute_on;
                        when display_a_on =>
                            state_s <= execute_display_a;
                        when display_b_on =>
                            state_s <= execute_display_b;  
                        when display_c_on =>
                            state_s <= execute_display_c;      
                        when display_all_on =>
                            state_s <= execute_display_all;    
                        when display_test_on =>
                            state_s <= execute_test_on;  
                        when display_test_off =>
                            state_s <= execute_test_off;                       
                        when others =>
                            state_s <= fetch;       
                    end case;
                when execute_off =>
                    state_s <= fetch;
                    on_s    <= '0';
                    ena_display_out <= "000";
                    data_out <= x"00";
                when execute_on =>
                    state_s <= fetch;
                    on_s <= '1';
                when execute_display_a =>
                    if on_s = '1' then
                        ena_display_out <= "001";
                        data_out <= data_reg_s;
                        state_s <= fetch;
                    else 
                        state_s <= execute_off;      
                    end if;
                when execute_display_b =>
                    if on_s = '1'then
                        ena_display_out <= "010";
                        data_out <= data_reg_s;
                        state_s <= fetch;
                    else 
                        state_s <= execute_off;      
                    end if;
                when execute_display_c =>
                    if on_s = '1'then
                        ena_display_out <= "100";
                        data_out <= data_reg_s;
                        state_s <= fetch;
                    else 
                        state_s <= execute_off;      
                    end if;
                when execute_display_all =>
                    if on_s = '1'then
                        ena_display_out <= "111";
                        data_out <= data_reg_s;
                        state_s <= fetch;
                    else 
                        state_s <= execute_off;      
                    end if;
                when execute_test_on =>
                    if on_s = '1' then
                        ena_display_out <= "111";
                        data_out <= x"11";
                        state_s <= fetch;
                    else 
                        state_s <= execute_off;
                    end if;     
                when execute_test_off =>
                    if on_s = '1' then
                        ena_display_out <= "000";
                        data_out <= x"00";
                        state_s <= fetch;
                    else
                        state_s <= execute_off;
                    end if;
                when others =>
                    state_s <= fetch;            
            end case;          
        end if;
    end process state_machine;  
end architecture rtl;