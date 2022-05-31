--------------------------------------------------------------------------------
--
--   Filena_inme:         binary_to_bcd.vhd
--   Dependencies:     binary_to_bcd_digit.vhd
--   Design Software:  Quartus II 64-bit Version 13.1.0 Build 162 SJ Web Edition
--
--   HDL CODE IS PROVIDED "AS IS."  DIGI-KEY EXPRESSLY DISCLAIMS ANY
--   WARRANTY OF ANY KIND, WHETHER EXPRESS OR IMPLIED, INCLUDING BUT NOT
--   LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
--   PARTICULAR PURPOSE, OR NON-INFRINGEMENT. IN NO EVENT SHALL DIGI-KEY
--   BE LIABLE FOR ANY INCIDENTAL, SPECIAL, INDIRECT OR CONSEQUENTIAL
--   DAMAGES, LOST PROFITS OR LOST DATA, HARM TO YOUR EQUIPMENT, COST OF
--   PROCUREMENT OF SUBSTITUTE GOODS, TECHNOLOGY OR SERVICES, ANY CLAIMS
--   BY THIRD PARTIES (INCLUDING BUT NOT LIMITED TO ANY DEFENSE THEREOF),
--   ANY CLAIMS FOR INDEMNITY OR CONTRIBUTION, OR OTHER SIMILAR COSTS.
--
--   Version History
--   Version 1.0 6/15/2017 Scott Larson
--     Initial Public Release
--   Version 1.1 6/23/2017 Scott Larson
--     Fixed small corner-case bug
--   Version 1.2 1/16/2018 Scott Larson
--     Fixed reset logic to include resetting the state machine
--    
--------------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY binary_to_bcd IS
    PORT(
        clk_in      :   IN      STD_LOGIC;                                          --system clock
        rst_n_in    :   IN      STD_LOGIC;                                          --active low asynchronus reset
        ena_in      :   IN      STD_LOGIC;                                          --latches in new binary number and starts conversion
        binary_in   :   IN      STD_LOGIC_VECTOR(7 DOWNTO 0);           --binary number to convert
        busy_out    :   OUT STD_LOGIC;                                          --indicates conversion in progress
        bcd_a_out   :   OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
        ena_out     :   OUT std_logic;
        bcd_b_out   :   OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
        );  --resulting BCD number
END binary_to_bcd;

ARCHITECTURE logic OF binary_to_bcd IS
    TYPE        machine IS(idle, convert);                                              --needed states
    SIGNAL  state               :  machine;                                         --state machine
    SIGNAL  binary_reg          :   STD_LOGIC_VECTOR(7 DOWNTO 0);       --latched in binary number
    SIGNAL  bcd_reg             :   STD_LOGIC_VECTOR(7 DOWNTO 0);   --bcd result register
    SIGNAL  converter_ena_in        :   STD_LOGIC;
    SIGNAL  converter_inputs    :   STD_LOGIC_VECTOR(2 DOWNTO 0);       --inputs into each BCD single digit converter

    --binary to BCD single digit converter component
    COMPONENT binary_to_bcd_digit IS
        PORT(
            clk_in      :   IN          STD_LOGIC;
            rst_n_in    :   IN          STD_LOGIC;
            ena_in      :   IN          STD_LOGIC;
            binary      :   IN          STD_LOGIC;
            c_out       :   BUFFER  STD_LOGIC;
            bcd         :   BUFFER  STD_LOGIC_VECTOR(3 DOWNTO 0));
    END COMPONENT binary_to_bcd_digit;
    
BEGIN

    PROCESS(rst_n_in, clk_in)
        VARIABLE bit_count :    INTEGER RANGE 0 TO 10 := 0;  --counts the binary bits shifted into the converters
    BEGIN
        IF(rst_n_in = '0') THEN                     --asynchronous reset asserted
            bit_count        := 0;                             --reset bit counter
            busy_out         <= '1';                                    --indicate not available
            converter_ena_in <= '0';                        --disable the converter
            bcd_a_out        <= (OTHERS => '0');                     --clear BCD result port
            bcd_b_out        <= (OTHERS => '0'); 
            ena_out          <= '0';
            binary_reg       <= (others => '0');
            state            <= idle;                                  --reset state machine
        ELSIF rising_edge(clk_in) THEN       --system clock rising edge
            CASE state IS
            
                WHEN idle =>                            --idle state
                    IF(ena_in = '1') THEN                   --converter is ena_inbled
                        busy_out <= '1';                            --indicate conversion in progress
                        converter_ena_in <= '1';                --ena_inble the converter
                        binary_reg <= binary_in;                --latch in binary number for conversion
                        bit_count := 0;                     --reset bit counter
                        state <= convert;                       --go to convert state
                        ena_out <= '1';
                    ELSE                                        --converter is not ena_inbled
                        busy_out <= '0';                            --indicate available
                        converter_ena_in <= '0';                --disable the converter
                        state <= idle;                          --remain in idle state
                        ena_out <= '0';
                    END IF;
                
                WHEN convert =>                                                 --convert state
                    IF(bit_count < 9) THEN                                 --not all bits shifted in
                        bit_count := bit_count + 1;                                 --increment bit counter
                        converter_inputs(0) <= binary_reg(7);               --shift next bit into converter
                        binary_reg <= binary_reg(6 DOWNTO 0) & '0';        --shift binary number register
                        state <= convert;                                                   --remain in convert state
                    ELSE                                                                    --all bits shifted in
                        busy_out <= '0';                                                        --indicate conversion is complete
                        converter_ena_in <= '0';                                            --disable the converter
                        bcd_a_out <= bcd_reg(3 downto 0);   
                        bcd_b_out <= bcd_reg(7 downto 4);                                                --output result
                        state <= idle;                                                      --return to idle state
                    END IF;             
            END CASE;   
        END IF;
    END PROCESS;
    
    --instantiate the converter logic for the specified number of digits
    bcd_digits: FOR i IN 1 to 2 GENERATE
        digit_0: binary_to_bcd_digit
            PORT MAP (clk_in, rst_n_in, converter_ena_in, converter_inputs(i-1), converter_inputs(i), bcd_reg(i*4-1 DOWNTO i*4-4)); 
    END GENERATE;

END logic;

