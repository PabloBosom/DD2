library ieee;
use ieee.std_logic_1164.all;

entity prototipo_medida_TH is
generic(fdc_timer_2_5ms: natural := 250000);
port(clk:           in     std_logic;
     nRst:          in     std_logic;
     seg:           buffer std_logic_vector(6 downto 0);
     mux_disp:      buffer std_logic_vector(4 downto 0);
     SDA:           inout  std_logic;
     SCL:           inout  std_logic);          
end entity;

architecture estructural of prototipo_medida_TH is
  signal tic_2_5ms:  std_logic;
  signal tic_0_25s:  std_logic;
  signal tic_5s:     std_logic;

  signal we:         std_logic;
  signal rd:         std_logic;
  signal add:        std_logic_vector(1 downto 0);
  signal dato_in:    std_logic_vector(7 downto 0);
  signal dato_out:   std_logic_vector(7 downto 0);

  signal temp_BCD:   std_logic_vector(11 downto 0);
  signal humd_BCD:   std_logic_vector(11 downto 0);
  signal sgn_T:      std_logic;    


begin
  U0: entity work.timer_medida(rtl)
      generic map(fdc_timer_2_5ms => fdc_timer_2_5ms)
      port map(clk          => clk,
               nRst         => nRst,   
               tic_2_5ms    => tic_2_5ms,
               tic_0_25s    => tic_0_25s,
               tic_5s       => tic_5s);

  U1: entity work.periferico_i2c(estructural)
      port map(clk          => clk,
               nRst         => nRst,
               we           => we,
               rd           => rd,
               add          => add,
               dato_in      => dato_in,
               dato_out     => dato_out,
               SDA          => SDA,
               SCL          => SCL);

  U2: entity work.procesador_medida(rtl)
      port map(clk          => clk,
               nRst         => nRst,
               tic_0_25s    => tic_0_25s,
               we           => we,
               rd           => rd,
               add          => add,
               dato_w       => dato_in,
               dato_r       => dato_out,
               temp_BCD     => temp_BCD,
               humd_BCD     => humd_BCD,
               sgn_T        => sgn_T);

  U3: entity work.presentacion_medida(rtl)
      port map(clk         => clk,
               nRst        => nRst,
               tic_2_5ms   => tic_2_5ms,
               tic_5s      => tic_5s,
               temp_BCD    => temp_BCD,
               humd_BCD    => humd_BCD,
               sgn_T       => sgn_T,
               seg         => seg,
               mux_disp    => mux_disp);

end estructural;