library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity presentacion_medida is
port(clk:           in     std_logic;
     nRst:          in     std_logic;
     tic_2_5ms:     in     std_logic;
     tic_5s:        in     std_logic;
     temp_BCD:      in     std_logic_vector(11 downto 0);
     humd_BCD:      in     std_logic_vector(11 downto 0);
     sgn_T:         in     std_logic;
     seg:           buffer std_logic_vector(6 downto 0);
     mux_disp:      buffer std_logic_vector(4 downto 0));
          
end entity;

architecture rtl of presentacion_medida is
  -- Multiplexacion de displays:
  signal cnt_mux: std_logic_vector(4 downto 0);

  -- Segnales auxiliares (ceros no significativos y posicion bit de signo)
  signal cero_c:    std_logic;
  signal cero_d:    std_logic;

  signal pos_sgn_d: std_logic;
  signal pos_sgn_c: std_logic;

  -- Constantes decodificacion
  constant symb_grados:     std_logic_vector(3 downto 0) := "1010";
  constant symb_por_ciento: std_logic_vector(3 downto 0) := "1011";
  constant symb_T:          std_logic_vector(3 downto 0) := "1100";
  constant symb_H:          std_logic_vector(3 downto 0) := "1101";
  constant symb_menos:      std_logic_vector(3 downto 0) := "1110";
  constant symb_apagado:    std_logic_vector(3 downto 0) := "1111";

  signal BCD: std_logic_vector(3 downto 0);
  
  signal sel_TH:   std_logic;
  signal dato_sel: std_logic_vector(11 downto 0);

begin
  -- Control sel_TH
  process(clk, nRst)
  begin
    if nRst = '0' then
      sel_TH <= '0';

    elsif clk'event and clk = '1' then
      if tic_5s = '1' then      
        sel_TH <= not sel_TH;

      end if;
    end if;
  end process;

  dato_sel <= temp_BCD when sel_TH = '0' else
              humd_BCD;

  -- Control multiplexacion de displays
  process(clk, nRst)
  begin
    if nRst = '0' then
      cnt_mux <= (0 => '1', others => '0');

    elsif clk'event and clk = '1' then
      if tic_2_5ms = '1' then      
        cnt_mux <= cnt_mux(3 downto 0)&cnt_mux(4);

      end if;
    end if;
  end process;

  -- Segnales de multiplexacion
  mux_disp <= not cnt_mux; -- Activas a nivel bajo


  -- Eliminacion de ceros no significativos
     cero_c <= not dato_sel(8);                                                  -- Se elimina el 0 de centenas si not centena
     cero_d <= cero_c when dato_sel(7 downto 4) = 0 else                         -- Se elimina el cero de decenas cuando centenas 
               '0';                                                              -- y decenas son 0 

  -- Posicion del signo (en disp de centenas o de decenas)
     pos_sgn_d <= '1' when cero_d =  '1' and sgn_T = '1' and sel_TH = '0' else
                  '0';
     pos_sgn_c <= '1' when cero_d =  '0' and sgn_T = '1' and sel_TH = '0' else
                  '0';

  -- Mux decodificador BCD-7seg
  BCD <= symb_grados           when sel_TH    = '0' and cnt_mux = 1  else
         symb_por_ciento       when sel_TH    = '1' and cnt_mux = 1  else
         dato_sel(3 downto 0)  when                     cnt_mux = 2  else
         dato_sel(7 downto 4)  when cero_d    = '0' and cnt_mux = 4  else
         symb_menos            when pos_sgn_d = '1' and cnt_mux = 4  else
         symb_apagado          when cero_d    = '1' and cnt_mux = 4  else
         dato_sel(11 downto 8) when cero_c    = '0' and cnt_mux = 8  else
         symb_menos            when pos_sgn_c = '1' and cnt_mux = 8  else
         symb_apagado          when cero_c    = '1' and cnt_mux = 8  else
         symb_T                when sel_TH    = '0' and cnt_mux = 16 else
         symb_H                when                     cnt_mux = 16 else
         symb_apagado;
                                          
  -- Decodificador BCD (ampliado) a 7 segmentos: salidas activas a nivel alto
  process(BCD)
  begin
    case BCD is            --abcdefg
      when "0000" => seg <= "1111110"; -- 0 
      when "0001" => seg <= "0110000"; -- 1
      when "0010" => seg <= "1101101"; -- 2 
      when "0011" => seg <= "1111001"; -- 3
      when "0100" => seg <= "0110011"; -- 4
      when "0101" => seg <= "1011011"; -- 5
      when "0110" => seg <= "1011111"; -- 6
      when "0111" => seg <= "1110000"; -- 7
      when "1000" => seg <= "1111111"; -- 8
      when "1001" => seg <= "1110011"; -- 9
      when "1010" => seg <= "0001101"; -- Grados (c)
      when "1011" => seg <= "0000101"; -- Por ciento (r)
      when "1100" => seg <= "0001111"; -- Temp (t)
      when "1101" => seg <= "0110111"; -- Hum  (H)
      when "1110" => seg <= "0000001"; -- sgn - 
      when "1111" => seg <= "0000000"; -- Apagado
      when others => seg <= "XXXXXXX";
  
    end case;
  end process;


end rtl;