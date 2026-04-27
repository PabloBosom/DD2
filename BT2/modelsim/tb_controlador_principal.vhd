library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use work.all;

entity tb_controlador_principal is
end entity;

architecture testbench of tb_controlador_principal is

    -- Componente
    component controlador_principal is
    port(	
        clk: in std_logic;
        nRst: in std_logic;
        tecla: in std_logic_vector (3 downto 0);
        tecla_pulsada: in std_logic;

        inicio_cal: buffer std_logic;
       
        
        op1_sgn: buffer std_logic;
        op2_sgn: buffer std_logic;

        OP : buffer  std_logic_vector(1 downto 0);
        op1_bcd : buffer  std_logic_vector(11 downto 0);
        op2_bcd : buffer  std_logic_vector(11 downto 0)
    );
    end component;

    -- Señales de prueba
    signal clk : std_logic := '0';
    signal nRst : std_logic := '1';
    signal tecla : std_logic_vector(3 downto 0) := "0000";
    signal tecla_pulsada : std_logic := '0';
    signal inicio_cal : std_logic;
    
    signal op1_sgn : std_logic;
    signal op2_sgn : std_logic;
    signal OP : std_logic_vector(1 downto 0);
    signal op1_bcd : std_logic_vector(11 downto 0);
    signal op2_bcd : std_logic_vector(11 downto 0);

    -- Constante de periodo de reloj
    constant CLK_PERIOD : time := 10 ns;

begin

    -- Instancia del DUT (Device Under Test)
    DUT: controlador_principal
    port map(
        clk => clk,
        nRst => nRst,
        tecla => tecla,
        tecla_pulsada => tecla_pulsada,
        inicio_cal => inicio_cal,
        op1_sgn => op1_sgn,
        op2_sgn => op2_sgn,
        OP => OP,
        op1_bcd => op1_bcd,
        op2_bcd => op2_bcd
    );

    -- Generador de reloj
    clk_process: process
    begin
        clk <= '0';
        wait for CLK_PERIOD/2;
        clk <= '1';
        wait for CLK_PERIOD/2;
    end process;

    -- Proceso de estímulos
    stimulus: process
    begin
        -- Reset
        nRst <= '0';
        wait for 20 ns;
        nRst <= '1';
        wait for 20 ns;

        report "TEST 1: Introducir numero 123 en op1";
        -- Presionar 1
        tecla <= X"1";
        tecla_pulsada <= '1';
        wait for CLK_PERIOD;
        tecla_pulsada <= '0';
        wait for CLK_PERIOD;
        report "op1_bcd despues de pulsar 1: " & integer'image(to_integer(unsigned(op1_bcd)));

        -- Presionar 2
        tecla <= X"2";
        tecla_pulsada <= '1';
        wait for CLK_PERIOD;
        tecla_pulsada <= '0';
        wait for CLK_PERIOD;
        report "op1_bcd despues de pulsar 2: " & integer'image(to_integer(unsigned(op1_bcd)));

        -- Presionar 3
        tecla <= X"3";
        tecla_pulsada <= '1';
        wait for CLK_PERIOD;
        tecla_pulsada <= '0';
        wait for CLK_PERIOD;
        report "op1_bcd despues de pulsar 3: " & integer'image(to_integer(unsigned(op1_bcd)));

        wait for 20 ns;

        report "TEST 2: Presionar operacion SUMA (0xA)";
        tecla <= X"A";
        tecla_pulsada <= '1';
        wait for CLK_PERIOD;
        tecla_pulsada <= '0';
        wait for CLK_PERIOD;
        report "OP (suma): " & integer'image(to_integer(unsigned(OP)));

        wait for 20 ns;

        report "TEST 3: Introducir numero 456 en op2";
        -- Presionar 4
        tecla <= X"4";
        tecla_pulsada <= '1';
        wait for CLK_PERIOD;
        tecla_pulsada <= '0';
        wait for CLK_PERIOD;
        report "op2_bcd despues de pulsar 4: " & integer'image(to_integer(unsigned(op2_bcd)));

        -- Presionar 5
        tecla <= X"5";
        tecla_pulsada <= '1';
        wait for CLK_PERIOD;
        tecla_pulsada <= '0';
        wait for CLK_PERIOD;
        report "op2_bcd despues de pulsar 5: " & integer'image(to_integer(unsigned(op2_bcd)));

        -- Presionar 6
        tecla <= X"6";
        tecla_pulsada <= '1';
        wait for CLK_PERIOD;
        tecla_pulsada <= '0';
        wait for CLK_PERIOD;
        report "op2_bcd despues de pulsar 6: " & integer'image(to_integer(unsigned(op2_bcd)));

        wait for 20 ns;

        report "TEST 4: Presionar boton igual (0xB)";
        tecla <= X"B";
        tecla_pulsada <= '1';
        wait for CLK_PERIOD;
        tecla_pulsada <= '0';
        wait for CLK_PERIOD;
        report "inicio_cal: " & std_logic'image(inicio_cal);

        wait for 20 ns;

        report "TEST 5: Prueba de signo negativo con 0xC";
        tecla <= X"C";
        tecla_pulsada <= '1';
        wait for CLK_PERIOD;
        tecla_pulsada <= '0';
        wait for CLK_PERIOD;
        report "op1_sgn despues de pulsar C: " & std_logic'image(op1_sgn);

        wait for 20 ns;

        report "TEST 6: Prueba de RESTA (0xD)";
        tecla <= X"D";
        tecla_pulsada <= '1';
        wait for CLK_PERIOD;
        tecla_pulsada <= '0';
        wait for CLK_PERIOD;
        report "OP (resta): " & integer'image(to_integer(unsigned(OP)));

        wait for 20 ns;

        report "TEST 7: Prueba de MULTIPLICACION (0xE)";
        tecla <= X"E";
        tecla_pulsada <= '1';
        wait for CLK_PERIOD;
        tecla_pulsada <= '0';
        wait for CLK_PERIOD;
        report "OP (mult): " & integer'image(to_integer(unsigned(OP)));

        wait for 20 ns;
report "TEST 7: Prueba de MULTIPLICACION (0xE)";
        tecla <= X"B";
        tecla_pulsada <= '1';
        wait for CLK_PERIOD;
        tecla_pulsada <= '0';
        wait for CLK_PERIOD;

          wait for 20 ns;
        report "FIN DE PRUEBAS";
         

    wait;
report "Simulacion finalizada" 
severity failure;
end process;
end architecture;
