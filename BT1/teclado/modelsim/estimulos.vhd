--------------------------------------------------------------------------------------------------
-- Autor: DTE
-- Version:3.0
-- Fecha: 17-02-2021
--------------------------------------------------------------------------------------------------
-- Estimulos para el test del controlador de teclado.
-- El reloj y el reset asíncrono se aplican directamente en elnivel superior de la jerarquia del
-- test
--------------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use work.pack_test_teclado.all;

entity estimulos is port(
  clk: in std_logic;
  tic: in std_logic;
  duracion_test: buffer time;
  tecla_test: buffer std_logic_vector(3 downto 0);
  tecla_id: buffer std_logic_vector(3 downto 0);
  pulsar_tecla: buffer std_logic
  );
end entity;

architecture test of estimulos is

begin

stim: process
  begin
    tecla_id <= (others => '0');
    pulsar_tecla <= '0';
    wait for 30*T_CLK;
    wait until clk'event and clk = '1';
    -- Para completar por los estudiantes (inicio)
    -- ...


-- Pulsación corta de tecla 0x0
    report "  - Pulsando tecla 0x0 (corta)" severity note;
    pulsa_tecla(clk, x"0", pulsacion_corta, tecla_test, duracion_test, pulsar_tecla);
    espera_TIC(clk, tic, 3);

 -- Pulsación corta de tecla 0x1
    report "  - Pulsando tecla 0x1 (corta)" severity note;
    pulsa_tecla(clk, x"1", pulsacion_corta, tecla_test, duracion_test, pulsar_tecla);
    espera_TIC(clk, tic, 3);

 -- Pulsación corta de tecla 0xF
    report "  - Pulsando tecla 0xF (corta)" severity note;
    pulsa_tecla(clk, x"F", pulsacion_corta, tecla_test, duracion_test, pulsar_tecla);
    espera_TIC(clk, tic, 5);

report "TEST 2: Pulsaciones LARGAS de teclas básicas" severity note;
    
    -- Pulsación larga de tecla 0x2
    report "  - Pulsando tecla 0x2 (larga)" severity note;
    pulsa_tecla(clk, x"2", pulsacion_larga, tecla_test, duracion_test, pulsar_tecla);
    espera_TIC(clk, tic, 3);
    
    -- Pulsación larga de tecla 0x6
    report "  - Pulsando tecla 0x6 (larga)" severity note;
    pulsa_tecla(clk, x"6", pulsacion_larga, tecla_test, duracion_test, pulsar_tecla);
    espera_TIC(clk, tic, 3);

 report "TEST 10: Recuperación tras inactividad PROLONGADA (20 TICs)" severity note;
    
    report "  - Esperando 20 TICs sin pulsación" severity note;
    espera_TIC(clk, tic, 20);
    
    report "  - Pulsando tecla 0x7 (corta) después de inactividad" severity note;
    pulsa_tecla(clk, x"7", pulsacion_corta, tecla_test, duracion_test, pulsar_tecla);
    espera_TIC(clk, tic, 3);
    
    report "  - Pulsando tecla 0x8 (larga) después de inactividad" severity note;
    pulsa_tecla(clk, x"8", pulsacion_larga, tecla_test, duracion_test, pulsar_tecla);
    espera_TIC(clk, tic, 10);
	
    -- Para completar por los estudiantes (fin) 
    assert(false) report "******************************Fin del test************************" severity failure;
  end process;

end test;