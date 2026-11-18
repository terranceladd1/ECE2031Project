-- TIMER.VHD (a peripheral module for SCOMP)
-- 2003.04.24
--
-- Timer returns a 16 bit counter value with a resolution of the CLOCK period.
-- Writing any value to timer resets to 0x0000, but the timer continues to run.
-- The counter value rolls over to 0x0000 after a clock tick at 0xFFFF.

LIBRARY IEEE;
LIBRARY LPM;

USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE LPM.LPM_COMPONENTS.ALL;


ENTITY TIMER IS
	PORT(
    CLOCK       : IN    STD_LOGIC;
    RESETN      : IN    STD_LOGIC;
    CS          : IN    STD_LOGIC := '1';
    IO_WRITE    : IN    STD_LOGIC;
    IO_READ     : IN    STD_LOGIC;
    IO_ADDR     : IN    STD_LOGIC_VECTOR(10 DOWNTO 0);
    IO_DATA     : INOUT STD_LOGIC_VECTOR(15 DOWNTO 0);
    CLK_100HZ   : IN    STD_LOGIC := '0';
    CLK_10HZ    : IN    STD_LOGIC := '0';
    CLK_1HZ     : IN    STD_LOGIC := '0'
	);
END TIMER;

ARCHITECTURE a OF TIMER IS
	-- Drive Stuff
  SIGNAL io_read_data   : STD_LOGIC_VECTOR(15 DOWNTO 0);
  SIGNAL io_drive_en    : STD_LOGIC;
  SIGNAL cs_timer       : STD_LOGIC;
  SIGNAL addr_sel       : STD_LOGIC_VECTOR(1 DOWNTO 0);

	-- Counter Stuff
  SIGNAL cd_val_reg     : STD_LOGIC_VECTOR(15 DOWNTO 0) := x"0000";
  SIGNAL cd_ctrl_reg    : STD_LOGIC_VECTOR(15 DOWNTO 0) := x"0000";
  SIGNAL int_period_reg : STD_LOGIC_VECTOR(15 DOWNTO 0) := x"0000";
  SIGNAL timer_scale_reg: STD_LOGIC_VECTOR(15 DOWNTO 0) := x"0001";

	BEGIN

	cs_timer <= '1' WHEN (IO_ADDR(10 DOWNTO 2) = "000011100") ELSE '0';
	addr_sel <= IO_ADDR(1 DOWNTO 0);

	io_drive_en <= '1' WHEN (cs_timer = '1' AND CS = '1' AND IO_READ = '1') ELSE '0';

	-- Use LPM function to create bidirection I/O data bus
	IO_BUS: lpm_bustri
	GENERIC MAP ( lpm_width =>; 16 )
  PORT MAP (
		data => io_read_data,
    enabledt => io_drive_en,
    tridata => IO_DATA
  );

	WITH addr_sel SELECT
		io_read_data <= cd_val_reg WHEN "00",
										cd_ctrl_reg WHEN "01",
										int_period_reg WHEN "10",
										timer_scale_reg WHEN "11",
										x"0000" WHEN OTHERS;

	PROCESS (CLOCK, RESETN, IO_ADDR, IO_READ)
	BEGIN
		IF (RESETN = '0' OR ((IO_ADDR = "00000000010") AND (IO_WRITE = '1'))) THEN
			COUNT <= x"0000";
		ELSIF (rising_edge(CLOCK)) THEN
			COUNT <= COUNT + 1;
		END IF;
	END PROCESS;
	
	-- Drive IO_DATA when requested.
	IO_EN <=
		'1' WHEN (IO_ADDR = "00000000010") AND (IO_READ = '1')
		ELSE '0';

END a;

