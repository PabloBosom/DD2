library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity timer_medida is
generic(fdc_timer_2_5ms: natural := 250000); 
port(clk:       in     std_logic;
     nRst:      in     std_logic;
     tic_2_5ms: buffer std_logic;
     tic_0_25s: buffer std_logic;
     tic_5s:    buffer std_logic
    );          
end entity;

architecture rtl of timer_medida is
  signal cnt_timer_2_5ms:   std_logic_vector(17 downto 0);

  signal cnt_timer_0_25s:   std_logic_vector(6 downto 0);
  constant fdc_timer_0_25s: natural := 100;

  signal cnt_timer_5s:   std_logic_vector(4 downto 0);
  constant fdc_timer_5s: natural := 20;

begin

  --Timer 2.5 ms (clk = 100 MHz)
  process(clk, nRst)
  begin
    if nRst = '0' then
      cnt_timer_2_5ms <= (0 => '1', others => '0');

    elsif clk'event and clk = '1' then
      if tic_2_5ms = '1' then
        cnt_timer_2_5ms <= (0 => '1', others => '0');
		  
      else
        cnt_timer_2_5ms <= cnt_timer_2_5ms + 1;

      end if;
    end if;
  end process;

  tic_2_5ms <= '1' when cnt_timer_2_5ms = fdc_timer_2_5ms else
               '0';

  --Timer 0.25 s (tic = 2.5 ms)
  process(clk, nRst)
  begin
    if nRst = '0' then
      cnt_timer_0_25s <= (0 => '1', others => '0');

    elsif clk'event and clk = '1' then
      if tic_0_25s = '1' then
        cnt_timer_0_25s <= (0 => '1', others => '0');
		  
      elsif tic_2_5ms = '1' then
        cnt_timer_0_25s <= cnt_timer_0_25s + 1;

      end if;
    end if;
  end process;

  tic_0_25s <= '1' when cnt_timer_0_25s = fdc_timer_0_25s and tic_2_5ms = '1' else
               '0';

  --Timer 5 s (tic = 0.5 s)
  process(clk, nRst)
  begin
    if nRst = '0' then
      cnt_timer_5s <= (0 => '1', others => '0');

    elsif clk'event and clk = '1' then
      if tic_5s = '1' then
        cnt_timer_5s <= (0 => '1', others => '0');
		  
      elsif tic_0_25s = '1' then
        cnt_timer_5s <= cnt_timer_5s + 1;

      end if;
    end if;
  end process;

  tic_5s <= '1' when cnt_timer_5s = fdc_timer_5s and tic_0_25s = '1' else
            '0';

end rtl;