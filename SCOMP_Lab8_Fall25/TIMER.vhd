-- TIMER.VHD (a peripheral module for SCOMP)
-- 2003.04.24
--
-- Timer returns a 16 bit counter value with a resolution of the CLOCK period.
-- Writing any value to timer resets to 0x0000, but the timer continues to run.
-- The counter value rolls over to 0x0000 after a clock tick at 0xFFFF.

LIBRARY IEEE;
LIBRARY LPM;

USE IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

ENTITY TIMER IS
	generic (CLOCK_HZ : positive := 10000000);
	PORT(
    CLOCK       : IN    STD_LOGIC;
    RESETN      : IN    STD_LOGIC;
    IO_WRITE    : IN    STD_LOGIC;
    IO_READ     : IN    STD_LOGIC;
    IO_ADDR     : IN    STD_LOGIC_VECTOR(10 DOWNTO 0);
    IO_DATA     : INOUT STD_LOGIC_VECTOR(15 DOWNTO 0)
	);
END TIMER;

architecture rtl of TIMER is

    -- addresses 070 through 073
    constant CD_VAL      : std_logic_vector(10 downto 0) := "00001110000";
    constant CD_CTRL     : std_logic_vector(10 downto 0) := "00001110001";
    constant INT_PERIOD  : std_logic_vector(10 downto 0) := "00001110010";
    constant TIMER_SCALE : std_logic_vector(10 downto 0) := "00001110011";
    signal read_data : std_logic_vector(15 downto 0);

    signal remaining, preset : unsigned(15 downto 0);
    signal running, done : std_logic;
    signal period, interval_left : unsigned(15 downto 0);
    signal pending : std_logic;
    signal scale : unsigned(1 downto 0);
    signal cd_phase : natural range 0 to CLOCK_HZ - 1;       -- countdown tick progress
    signal int_phase : natural range 0 to CLOCK_HZ / 10 - 1; -- periodic tick progress
    signal cd_limit : positive range 1 to CLOCK_HZ;          -- cycles needed per countdown tick
begin
    -- check that dividing the clock into 0.01 s ticks gives a whole number
    assert CLOCK_HZ >= 100 and CLOCK_HZ mod 100 = 0
        report "CLOCK_HZ must be a multiple of 100 Hz" severity failure;
    -- select how many clock cycles make one countdown tick
    with scale select cd_limit <=
        CLOCK_HZ when "00", -- 1 second
        CLOCK_HZ / 10 when "01", -- 0.1 seconds
        CLOCK_HZ / 100 when others; -- 0.01 seconds for scale 2

    with IO_ADDR select read_data <=
        std_logic_vector(remaining) when CD_VAL, 
        (15 downto 1 => '0') & done when CD_CTRL,       
        (15 downto 1 => '0') & pending when INT_PERIOD, 
        (15 downto 2 => '0') & std_logic_vector(scale) when TIMER_SCALE, 
        (others => '0') when others; 
    
    IO_DATA <= read_data when RESETN = '1' and IO_READ = '1' and IO_WRITE = '0'
        and (IO_ADDR = CD_VAL or IO_ADDR = CD_CTRL
             or IO_ADDR = INT_PERIOD or IO_ADDR = TIMER_SCALE)
        else (others => 'Z'); -- release the bus so other devices can use it

    process (CLOCK, RESETN)
    begin
        if RESETN = '0' then
            remaining <= (others => '0');
            preset <= (others => '0');
            running <= '0';
            done <= '0';
            period <= (others => '0');
            interval_left <= (others => '0');
            pending <= '0';
            scale <= "01";
            cd_phase <= 0;
            int_phase <= 0;
        elsif rising_edge(CLOCK) then
            if running = '1' then
                if cd_phase = cd_limit - 1 then
                    cd_phase <= 0;
                    remaining <= remaining - 1;
                    if remaining = 1 then
                        running <= '0';
                        done <= '1';
                    end if;
                else
                    cd_phase <= cd_phase + 1;
                end if;
            end if;

            if IO_READ = '1' and IO_WRITE = '0' and IO_ADDR = INT_PERIOD then
                pending <= '0'; -- reading clears the old event
            end if;
            if period /= 0 then
                if int_phase = CLOCK_HZ / 10 - 1 then
                    int_phase <= 0;
                    if interval_left = 1 then
                        interval_left <= period;
                        pending <= '1'; -- keep a new event if a read happens too
                    else
                        interval_left <= interval_left - 1;
                    end if;
                else
                    int_phase <= int_phase + 1;
                end if;
            end if;

            -- writes below take priority over a tick on the same edge
            if IO_WRITE = '1' then
                case IO_ADDR is
                    when CD_VAL =>
                        preset <= unsigned(IO_DATA);
                        remaining <= unsigned(IO_DATA);
                        cd_phase <= 0;
                        if IO_DATA = x"0000" then
                            running <= '0';
                            done <= '1';
                        else
                            running <= '1';
                            done <= '0';
                        end if;
                    when CD_CTRL =>
                        case IO_DATA is
                            when x"0000" => -- pause
                                running <= '0';
                                remaining <= remaining; -- cancel a same-edge tick
                                cd_phase <= cd_phase;
                                done <= done;
                            when x"0001" => -- resume
                                if remaining /= 0 and running = '0' then
                                    running <= '1';
                                end if;
                            when x"0002" => -- reload
                                remaining <= preset;
                                cd_phase <= 0;
                                if preset = 0 then
                                    running <= '0';
                                    done <= '1';
                                else
                                    running <= '1';
                                    done <= '0';
                                end if;
                            when x"0003" => -- clear
                                remaining <= (others => '0');
                                cd_phase <= 0;
                                running <= '0';
                                done <= '0';
                            when others => null;
                        end case;
                    when INT_PERIOD =>
                        period <= unsigned(IO_DATA);
                        interval_left <= unsigned(IO_DATA);
                        int_phase <= 0;
                        pending <= '0';
                    when TIMER_SCALE =>
                        if unsigned(IO_DATA) <= 2 then
                            scale <= unsigned(IO_DATA(1 downto 0));
                            if unsigned(IO_DATA(1 downto 0)) /= scale then
                                cd_phase <= 0; -- start a full tick at the new scale
                                remaining <= remaining;
                                running <= running;
                                done <= done;
                            end if;
                        end if;
                    when others => null;
                end case;
            end if;
        end if;
    end process;
end rtl;

