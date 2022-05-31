-----------------------------------------------------------------------------
--Company: TEIS
--Engineer: Dominik Socher
--Created Date: Friday, March 26th 2021
-----------------------------------------------------------------------------
--File: c:\Users\Dominik\Documents\TEIS\ip_projects\seven_segment_ip\display_driver.vhdl
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
--        File instanciate all the components
--        
--        
--        
-----------------------------------------------------------------------------
    
-----------------------------------------------------------------------------
--verified with the DE10-Lite board 
-----------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity display_driver is
    port (
        clk_in        : in std_logic;
        rst_n_in      : in std_logic;
        data_in       : in std_logic_vector(15 downto 0);
        busy_display  : out std_logic_vector(2 downto 0);
        seven_seg_out : out std_logic_vector(41 downto 0)      
    );
end entity display_driver;

architecture rtl of display_driver is

component seven_segment_controller is
    port (
        ckl_in          : in std_logic;
        rst_n_in        : in std_logic;
        data_in         : in std_logic_vector(15 downto 0);
        data_out        : out std_logic_vector(7 downto 0);
        ena_display_out : out std_logic_vector(2 downto 0)
    );
end component;

component seven_segment_decoder 
    port (
        clk_in    : in std_logic;                    -- system clock
        rst_n_in  : in std_logic;                    -- asynchronous reset
        digit_in  : in std_logic_vector(3 downto 0); -- bcd digit 
        ena_in    : in std_logic;                    -- enable bit for component
        seg_out   : out std_logic_vector(6 downto 0) -- ouput to segement 
    );
end component;


component binary_to_bcd   
    port (
        clk_in    : in std_logic;                     -- system clock input
        rst_n_in  : in std_logic;                     -- reset asynchronus active low
        ena_in    : in std_logic;                     -- enable input
        binary_in : in std_logic_vector(7 downto 0);  -- 8 bit binary input to convert
        bcd_a_out : out std_logic_vector(3 downto 0); -- binary coced decimal
        bcd_b_out : out std_logic_vector(3 downto 0); -- binary coced decimal
        ena_out   : out std_logic;
        busy_out  : out std_logic                     -- component is busy     
    );
end component;

--register
signal display_a_s   : std_logic_vector(3 downto 0); 
signal display_b_s   : std_logic_vector(3 downto 0); 
signal display_c_s   : std_logic_vector(3 downto 0); 
signal display_d_s   : std_logic_vector(3 downto 0); 
signal display_e_s   : std_logic_vector(3 downto 0); 
signal display_f_s   : std_logic_vector(3 downto 0); 


 signal data_reg_s   : std_logic_vector(7 downto 0);
 signal decoder_on_s : std_logic_vector(2 downto 0);
 signal display_on_s : std_logic_vector(2 downto 0);
     
begin

    controller_inst : seven_segment_controller 
    port map (
        ckl_in          => clk_in,
        rst_n_in        => rst_n_in,
        data_in         => data_in,
        data_out        => data_reg_s,
        ena_display_out => display_on_s 
    );

    binary_to_bcd_inst_a : binary_to_bcd
    port map (
        clk_in    => clk_in,         -- system clock input
        rst_n_in  => rst_n_in,       -- reset asynchronus active low
        ena_in    => display_on_s(0), -- enable input
        binary_in => data_reg_s,        -- 8 bit binary input to convert
        bcd_a_out => display_a_s,    -- binary coced decimal
        bcd_b_out => display_b_s,    -- binary coced decimal
        ena_out   => decoder_on_s(0),      -- enable corosponding displays
        busy_out  => busy_display(0) -- component is busy     
    );
    
    binary_to_bcd_inst_b : binary_to_bcd
    port map (
        clk_in    => clk_in,         -- system clock input
        rst_n_in  => rst_n_in,       -- reset asynchronus active low
        ena_in    => display_on_s(1), -- enable input
        binary_in => data_reg_s,        -- 8 bit binary input to convert
        bcd_a_out => display_c_s,    -- binary coced decimal
        bcd_b_out => display_d_s,    -- binary coced decimal
        ena_out   => decoder_on_s(1),      -- enable corosponding displays
        busy_out  => busy_display(1) -- component is busy     
    );

    binary_to_bcd_inst_c : binary_to_bcd
    port map (
        clk_in    => clk_in,         -- system clock input
        rst_n_in  => rst_n_in,       -- reset asynchronus active low
        ena_in    => display_on_s(2), -- enable input
        binary_in => data_reg_s,        -- 8 bit binary input to convert
        bcd_a_out => display_e_s,    -- binary coced decimal
        bcd_b_out => display_f_s,    -- binary coced decimal
        ena_out   => decoder_on_s(2),      -- enable corosponding displays
        busy_out  => busy_display(2) -- component is busy     
    );

    u0: seven_segment_decoder
    port map (
        clk_in    => clk_in,                     -- system clock
        rst_n_in  => rst_n_in,                   -- asynchronous reset
        digit_in  => display_a_s,                -- bcd digit 
        ena_in    => decoder_on_s(0),            -- enable bit for component
        seg_out   => seven_seg_out(6 downto 0)   -- ouput to segement 
    );

    u1: seven_segment_decoder
        port map (
            clk_in    => clk_in,                      -- system clock
            rst_n_in  => rst_n_in,                    -- asynchronous reset
            digit_in  => display_b_s,                 -- bcd digit 
            ena_in    => decoder_on_s(0),             -- enable bit for component
            seg_out   => seven_seg_out(13 downto 7)   -- ouput to segement 
        );

    u2: seven_segment_decoder
        port map (
            clk_in    => clk_in,                     -- system clock
            rst_n_in  => rst_n_in,                   -- asynchronous reset
            digit_in  => display_c_s,                -- bcd digit 
            ena_in    => decoder_on_s(1),            -- enable bit for component
            seg_out   => seven_seg_out(20 downto 14) -- ouput to segement 
        );

    u3: seven_segment_decoder
        port map (
            clk_in    => clk_in,                      -- system clock
            rst_n_in  => rst_n_in,                    -- asynchronous reset
            digit_in  => display_d_s,                 -- bcd digit 
            ena_in    => decoder_on_s(1),             -- enable bit for component
            seg_out   => seven_seg_out(27 downto 21)  -- ouput to segement 
        );

    u4: seven_segment_decoder
        port map (
            clk_in    => clk_in,                     -- system clock
            rst_n_in  => rst_n_in,                   -- asynchronous reset
            digit_in  => display_e_s,                -- bcd digit 
            ena_in    => decoder_on_s(2),            -- enable bit for component
            seg_out   => seven_seg_out(34 downto 28) -- ouput to segement 
        );

    u5: seven_segment_decoder
        port map (
            clk_in    => clk_in,                      -- system clock
            rst_n_in  => rst_n_in,                    -- asynchronous reset
            digit_in  => display_f_s,                 -- bcd digit 
            ena_in    => decoder_on_s(2),             -- enable bit for component
            seg_out   => seven_seg_out(41 downto 35)  -- ouput to segement 
        );
  
end architecture rtl;