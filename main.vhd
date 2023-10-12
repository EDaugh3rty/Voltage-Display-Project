----------------------------------------------------------------------------------
-- Company: Letourneau University
-- Engineer: Ethan Daugherty
-- 
-- Create Date:    23:38:40 10/25/2022 
-- Design Name: 
-- Module Name:    VOLTAGE_DISPLAY - Behavioral 
-- Project Name: Voltage Display Project
-- Target Devices: Xilinx XC9572XL-10VQG44C
-- Tool versions: 
-- Description: Have LEDS light up depending on which mode and what speed the CPLD is running
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
use ieee.numeric_std.ALL;
use ieee.std_logic_unsigned.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity VOLTAGE_DISPLAY is
    Port ( LD0		: out  STD_LOGIC;
           LD1		: out  STD_LOGIC;
           LD2		: out  STD_LOGIC;
           LD3		: out  STD_LOGIC;
           LD4		: out  STD_LOGIC;
           LD5		: out  STD_LOGIC;
           LD6		: out  STD_LOGIC;
           LD7		: out  STD_LOGIC;
			  
			  RD		: out	 STD_LOGIC;
			  CS		: out  STD_LOGIC;
			  
           SW0		: in  STD_LOGIC;
           SW1		: in  STD_LOGIC;
           SW2		: in  STD_LOGIC;
           SW3		: in  STD_LOGIC;
           SW4		: in  STD_LOGIC;
           SW5		: in  STD_LOGIC;
           SW6		: in  STD_LOGIC;
           SW7		: in  STD_LOGIC;
			  
			  ADC	: in	STD_LOGIC_VECTOR(7 downto 0);

			  CLK		: in	STD_LOGIC;	
			  
           BUTTON : in  STD_LOGIC);
end VOLTAGE_DISPLAY;

architecture Behavioral of VOLTAGE_DISPLAY is
				signal	Clock0	:	STD_LOGIC;
				signal	Clock1	:	STD_LOGIC;
				signal	Clock2	:	STD_LOGIC;
				signal	ClK_DIV	:	STD_LOGIC_VECTOR(26 downto 0);
				
				
				signal	MODE0		:	STD_LOGIC;
				signal	MODE1		:	STD_LOGIC;
				signal	MODE2		:	STD_LOGIC;
				signal	MODE3		:	STD_LOGIC;
				
				signal	SPEED0	:	STD_LOGIC;
				signal	SPEED1	:	STD_LOGIC;
				signal	SPEED2	:	STD_LOGIC;
				signal	SPEED3	:	STD_LOGIC;
				
				signal	PAUSE		:	STD_LOGIC := '1';
				signal	pause_time :	STD_LOGIC := '0';
				signal	Blink		:	STD_LOGIC;
				signal	ADC_COMP	:	integer;

begin
	process(CLK) -- CLOCK DIVIDER
		begin
			if (CLK'event and CLK = '1') then
				CLK_DIV <= CLK_DIV + '1';
			end if;
		end process;
	
	Clock0 <= CLK_DIV(20); -- Divides the clock into a frequency to be used for switches
	Clock2 <= CLK_DIV(14); -- Divides the Clock to be used for debouncing the button
	
	CS <= '0'; --Sets CS to 0 to activate ADC
	RD <= CLK_DIV(12); --Sets RD on a clock at 7800Hz to activate ADC
	
	process(BUTTON) --debounces button
		begin
			if(rising_edge(BUTTON) and Clock2 = '1') then
					while(BUTTON = '1') loop
						pause_time <= '1';
					end loop;
					pause_time <= '0';
				
					Pause <= not Pause;
			end if;
	end process;
					
				
	
	process(Clock0)
		begin		--Divides clock into desired frequencies
			
				SPEED0 <= SW0;
				SPEED1 <= SW1;
				SPEED2 <= SW2;
				SPEED3 <= SW3;
			
				if(SPEED0 = '0' and SPEED1 = '0' and SPEED2 = '0' and SPEED3 = '0') then
					Clock1 <= CLK_DIV(26); --Sets clock to approximately .5Hz
				
			
				elsif(SPEED0 = '1' and SPEED1 = '0' and SPEED2 = '0' and SPEED3 = '0') then
					Clock1 <= CLK_DIV(25); --Sets clock to approximately 1HZ
				
			
				elsif(SPEED0 = '0' and SPEED1 = '1' and SPEED2 = '0' and SPEED3 = '0') then
					Clock1 <= CLK_DIV(23); --Sets clock to approximately 3.8Hz
				
			
				elsif(SPEED0 = '1' and SPEED1 = '1' and SPEED2 = '0' and SPEED3 = '0') then
					Clock1 <= CLK_DIV(12); --Sets clock to approximately 7800Hz
				end if;
	end process;
	

	process(Clock1, Pause)
		begin
			while Pause = '1' loop
				MODE0 	<= SW4;
				MODE1		<= SW5;
				MODE2		<= SW6;
				MODE3		<= SW7;
				ADC_COMP	<= to_integer(unsigned(ADC));
				
				
				if(MODE0 = '1' and MODE1 = '0' and MODE2 = '0' and MODE3 = '0') then
					--Absolute Value Mode
					--Turns LEDs on according to the voltage read from the ADC
					if(ADC_COMP >= 32) then
						LD0 <= '1'; --Turns light on at approximately .625V
					else 
						LD0 <= '0';
					end if;
					
					if(ADC_COMP >= 64) then
						LD1 <= '1'; --Turns light on at approximately 1.25V
					else
						LD1 <= '0';
					end if;
					
					if(ADC_COMP >= 96) then
						LD2 <= '1'; --Turns light on at approximately 1.875V
					else
						LD2 <= '0';
					end if;
					
					if(ADC_COMP >= 128) then
						LD3 <= '1'; --Turns light on at approximately 2.5V
					else 
						LD3 <= '0';
					end if;
					
					if(ADC_COMP >= 160) then
						LD4 <= '1'; --Turns light on at approximately 3.125V
					else
						LD4 <= '0';
					end if;
					
					if(ADC_COMP >= 192) then
						LD5 <= '1'; --Turns light on at approximately 3.75V
					else 
						LD5 <= '0';
					end if;
					
					if(ADC_COMP >= 224) then
						LD6 <= '1'; --Turns light on at approximately 4.375V
					else
						LD6 <= '0';
					end if;
					
					if(ADC_COMP >= 255) then
						LD7 <= '1'; --Turns light on at approximately 5V
					else
						LD7 <= '0';
					end if;
				
				
				elsif(MODE0 = '1' and MODE1 = '0' and MODE2 = '1' and MODE3 = '0') then
					--Binary Value Read 
					--Displays the binary output of the ADC
					LD0 <= ADC(0);
					LD1 <= ADC(1);
					LD2 <= ADC(2);
					LD3 <= ADC(3);
					LD4 <= ADC(4);
					LD5 <= ADC(5);
					LD6 <= ADC(6);
					LD7 <= ADC(7);
				
				
				elsif(MODE0 = '0' and MODE1 = '1' and MODE2 = '0' and MODE3 = '0') then
					--Center point
					--Input is referenced at 2.5V
					if(ADC_COMP <= 64) then
						LD0 <= '1'; --Turns light on at approximately .625V
					else
						LD0 <= '0';
					end if;
					
					if(ADC_COMP <= 96) then
						LD1 <= '1'; --Turns light on at approximately 1.25V
					else
						LD1 <= '0';
					end if;
					
					if(ADC_COMP <= 128) then
						LD2 <= '1'; --Turns light on at approximately 1.875V
					else
						LD2 <= '0';
					end if;
					
					if(ADC_COMP <= 128 or ADC_COMP >= 128) then
						LD3 <= '1'; --Turns light on at approximately 2.5V
					else
						LD3 <= '0';
					end if;
					
					if(ADC_COMP >= 160) then
						LD4 <= '1'; --Turns light on at approximately 3.125V
					else
						LD4 <= '0';
					end if;
					
					if(ADC_COMP >= 192) then
						LD5 <= '1'; --Turns light on at approximately 3.75V
					else
						LD5 <= '0';
					end if;
					
					if(ADC_COMP >= 224) then
						LD6 <= '1'; --Turns light on at approximately 4.375V
					else 
						LD6 <= '0';
					end if;
					
					if(ADC_COMP >= 255) then
						LD7 <= '1'; --Turns light on at approximately 5V
					else
						LD7 <= '0';
					end if;
								
				
				elsif(MODE0 = '1' and MODE1 = '1' and MODE2 = '0' and MODE3 = '0') then
						--Diagnostics 
						--Blinks the LEDs in a certain pattern
							Blink <= Clock1;
							
							LD0 <= Blink;
							LD1 <= Blink;
							LD2 <= not Blink;
							LD3 <= Blink;
							LD4 <= Blink;
							LD5 <= not Blink;
							LD6 <= Blink;
							LD7 <= Blink;
				
				
				elsif(MODE0 = '0' and MODE1 = '0' and MODE2 = '0' and MODE3 = '0') then
						--All LEDs off
						LD0 <= '0';
						LD1 <= '0';
						LD2 <= '0';
						LD3 <= '0';
						LD4 <= '0';
						LD5 <= '0';
						LD6 <= '0';
						LD7 <= '0';
						
				
				
				elsif(MODE0 = '1' and MODE1 = '1' and MODE2 = '1' and MODE3 = '0') then
						--All LEDs on
						LD0 <= '1';
						LD1 <= '1';
						LD2 <= '1';
						LD3 <= '1';
						LD4 <= '1';
						LD5 <= '1';
						LD6 <= '1';
						LD7 <= '1';
						
				end if;
								
			end loop;	
		end process;			
			
end Behavioral;

