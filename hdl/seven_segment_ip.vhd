-----------------------------------------------------------------------------
--Company: TEIS
--Engineer: Dominik Socher
--Created Date: Wednesday, March 24th 2021
-----------------------------------------------------------------------------
--File: c:\Users\Dominik\Documents\TEIS\ip_projects\seven_segment_ip\seven_segment_ip.vhd
--Project: c:\Users\Dominik\Documents\TEIS\ip_projects\seven_segment_ip
--Target Device: 10M50DAF484C7G
--Tool version: Quartus 18.1 and ModelSim 10.5b
--Testbench file: seven_segment_ip.vht
--Do file: do.do
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
--24.05.2021    DS      Changed line 119 preveous code genereated temporary latches.
-----------------------------------------------------------------------------
--Description:
--        7 segment display controller for three pair of two seven segment  
--        displays.
--        The component is intendet to use with the Intel NIOS II processor
--        and the Intel Avalon Bus.
--        The component is capable of several functions:
--        Writing to data in MSB sets the device into the following operation
--        mode:
--             opcode | description
--             -------|---------------
--             x01    | activate device  
--             x00    | deactivate device
--             x11    | activate group one
--             x21    | activate group two
--             x41    | activate group three    
--             xf1    | activate all groups
--             xf9    | self test on
--             xf8    | self test off  
--      Writing data to 8 bit lsb is the binary data converted to BCD shown
--      on the display.
-----------------------------------------------------------------------------
-- 
-----------------------------------------------------------------------------
--verified with the DE10-Lite board 
-----------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity seven_segment_ip is
    PORT (
        --avalon bus interface
        clk_in     : in std_logic;                      -- system clock
        rst_n_in   : in std_logic;                      -- asynch reset active low
        cs_n_in    : in std_logic;                      -- chip select
        write_n_in : in std_logic;                      -- write reqeust
        read_n_in  : in std_logic;                      -- read request
        addr_in    : in std_logic_vector(1 downto 0);   --address input
        d_in       : in std_logic_vector(31 downto 0);  -- data input
        d_out      : out std_logic_vector(31 downto 0); -- data output
        ------------------------------------------------
        HEX0       : out std_logic_vector(6 downto 0);  -- output to seven-segement-display
        HEX1       : out std_logic_vector(6 downto 0);  -- output to seven-segement-display
        HEX2       : out std_logic_vector(6 downto 0);  -- output to seven-segement-display
        HEX3       : out std_logic_vector(6 downto 0);  -- output to seven-segement-display
        HEX4       : out std_logic_vector(6 downto 0);  -- output to seven-segement-display
        HEX5       : out std_logic_vector(6 downto 0)   -- output to seven-segement-display
    );
end entity seven_segment_ip;

architecture rtl of seven_segment_ip is

    component display_driver is
        port (
            clk_in        : in std_logic;
            rst_n_in      : in std_logic;
            data_in       : in std_logic_vector(15 downto 0);
            busy_display  : out std_logic_vector(2 downto 0);
            seven_seg_out : out std_logic_vector(41 downto 0)      
        );
    end component;

--============================================================================
--              REGISTER
--============================================================================
    signal display_number_s : std_logic_vector (41 downto 0);
    signal control_reg_s    : std_logic_vector(15 downto 0);
    signal data_reg_s       : std_logic_vector(2 downto 0);
--============================================================================
--              HARDWARE FUNCTION
--============================================================================
begin

    --===============================================
    --      AVALON BUS INTERFACE PROTOCOL
    --===============================================
    bus_register_wirte_process: process(clk_in, rst_n_in)
    begin
        if rst_n_in = '0' then
            control_reg_s <= (others => '0');
        elsif rising_edge(clk_in) then
            if (cs_n_in = '0' and write_n_in = '0' and addr_in = "01") then
                control_reg_s <= d_in (31 downto 16);
            else
                null;
            end if;
        else
            null;
        end if;
    end process bus_register_wirte_process;

    bus_register_read_process: process(cs_n_in, read_n_in, addr_in, data_reg_s)
    begin
        if (cs_n_in = '0' and read_n_in = '0' and addr_in = "00") then
            d_out(31 downto 29) <= data_reg_s;
            d_out(28 downto 0) <= (others=>'0');
        else
            d_out <= (others => '0');
        end if;
    end process bus_register_read_process;

    display_inst : display_driver
        port map (
            clk_in        => clk_in,
            rst_n_in      => rst_n_in,
            data_in       => control_reg_s,
            busy_display  => data_reg_s,
            seven_seg_out => display_number_s      
        );
   
    HEX0 <= display_number_s (6 downto 0);
    HEX1 <= display_number_s (13 downto 7);
    HEX2 <= display_number_s (20 downto 14);
    HEX3 <= display_number_s (27 downto 21);
    HEX4 <= display_number_s (34 downto 28);
    HEX5 <= display_number_s (41 downto 35);
   
end architecture rtl;