-- Copyright (C) 2018  Intel Corporation. All rights reserved.
-- Your use of Intel Corporation's design tools, logic functions 
-- and other software and tools, and its AMPP partner logic 
-- functions, and any output files from any of the foregoing 
-- (including device programming or simulation files), and any 
-- associated documentation or information are expressly subject 
-- to the terms and conditions of the Intel Program License 
-- Subscription Agreement, the Intel Quartus Prime License Agreement,
-- the Intel FPGA IP License Agreement, or other applicable license
-- agreement, including, without limitation, that your use is for
-- the sole purpose of programming logic devices manufactured by
-- Intel and sold by Intel or its authorized distributors.  Please
-- refer to the applicable agreement for further details.

-- ***************************************************************************
-- This file contains a Vhdl test bench template that is freely editable to   
-- suit user's needs .Comments are provided in each section to help the user  
-- fill out necessary details.                                                
-- ***************************************************************************
-- Generated on "03/29/2021 09:59:51"
                                                            
-- Vhdl Test Bench template for design  :  seven_segment_ip
-- 
-- Simulation tool : ModelSim-Altera (VHDL)
-- 

LIBRARY ieee;                                               
USE ieee.std_logic_1164.all;                                

ENTITY seven_segment_ip_vhd_tst IS
END seven_segment_ip_vhd_tst;
ARCHITECTURE seven_segment_ip_arch OF seven_segment_ip_vhd_tst IS
-- constants   
CONSTANT clock_50 : TIME := 20 ns;                                              
-- signals                                                   
SIGNAL addr_in : STD_LOGIC_VECTOR(1 DOWNTO 0);
SIGNAL clk_in : STD_LOGIC;
SIGNAL cs_n_in : STD_LOGIC;
SIGNAL d_in : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL d_out : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL HEX0 : STD_LOGIC_VECTOR(6 DOWNTO 0);
SIGNAL HEX1 : STD_LOGIC_VECTOR(6 DOWNTO 0);
SIGNAL HEX2 : STD_LOGIC_VECTOR(6 DOWNTO 0);
SIGNAL HEX3 : STD_LOGIC_VECTOR(6 DOWNTO 0);
SIGNAL HEX4 : STD_LOGIC_VECTOR(6 DOWNTO 0);
SIGNAL HEX5 : STD_LOGIC_VECTOR(6 DOWNTO 0);
SIGNAL read_n_in : STD_LOGIC;
SIGNAL rst_n_in : STD_LOGIC;
SIGNAL write_n_in : STD_LOGIC;
COMPONENT seven_segment_ip
	PORT (
	addr_in : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
	clk_in : IN STD_LOGIC;
	cs_n_in : IN STD_LOGIC;
	d_in : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
	d_out : BUFFER STD_LOGIC_VECTOR(31 DOWNTO 0);
	HEX0 : BUFFER STD_LOGIC_VECTOR(6 DOWNTO 0);
	HEX1 : BUFFER STD_LOGIC_VECTOR(6 DOWNTO 0);
	HEX2 : BUFFER STD_LOGIC_VECTOR(6 DOWNTO 0);
	HEX3 : BUFFER STD_LOGIC_VECTOR(6 DOWNTO 0);
	HEX4 : BUFFER STD_LOGIC_VECTOR(6 DOWNTO 0);
	HEX5 : BUFFER STD_LOGIC_VECTOR(6 DOWNTO 0);
	read_n_in : IN STD_LOGIC;
	rst_n_in : IN STD_LOGIC;
	write_n_in : IN STD_LOGIC
	);
END COMPONENT;
BEGIN
	i1 : seven_segment_ip
	PORT MAP (
-- list connections between master ports and signals
	addr_in => addr_in,
	clk_in => clk_in,
	cs_n_in => cs_n_in,
	d_in => d_in,
	d_out => d_out,
	HEX0 => HEX0,
	HEX1 => HEX1,
	HEX2 => HEX2,
	HEX3 => HEX3,
	HEX4 => HEX4,
	HEX5 => HEX5,
	read_n_in => read_n_in,
	rst_n_in => rst_n_in,
	write_n_in => write_n_in
	);

	-- pull main reset line
	rst_n_in <= '0', '1' after 125 ns;

	--process generates 50MHz system clock
	clock_p1:process
	begin
		--clock period
		clk_in  <= '0';
		wait for clock_50/2;
		clk_in  <= '1';
		wait for clock_50/2;
	end process clock_p1;  

	test_p2:process
	begin
		--set signal
		cs_n_in <= '0';
		read_n_in <= '1';
		--write to device
		write_n_in <= '0';
		--address
		addr_in <= "01";
		--activate device
		d_in <= x"01000000";
		wait for 200 ns;
		--setting device into self test mode
		d_in <= x"F9000000";
		wait for 125 ns;
		--deactivate self test mode
		d_in <= x"08000000";
		wait for 125 ns;
		--write data to all displays
		d_in <= x"f1110000";
		wait for 125 ns;
		-- deactivate device
		d_in <= x"00000000";
		--end simulation
		wait;
	end process test_p2;
                                      
END seven_segment_ip_arch;
