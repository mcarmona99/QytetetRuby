#encoding: utf-8
# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

require_relative "casilla"
require_relative "tipo_casilla"
require_relative "titulo_propiedad"
require_relative "calle"

module ModeloQytetet
  class Tablero
    def initialize
      @casillas = Array.new
      @carcel = nil
      inicializar
    end

    def esCasillaCarcel(numeroCasilla)
      return (casillas[numeroCasilla].tipo == TipoCasilla::CARCEL)
    end

      # Métodos get implicitos
    attr_reader :casillas, :carcel

    def getCasillas
      return @casillas
    end
    
    def inicializar
      @casillas << Casilla.new(0, 0, TipoCasilla::SALIDA)
      @casillas << Calle.new(1,500, TituloPropiedad.new("Memphis", 500, 50, -0.2, 150, 250))
      @casillas << Calle.new(2,550, TituloPropiedad.new("Abu Simbel", 550, 55, -0.15, 200, 300))
      @casillas << Casilla.new(3,0, TipoCasilla::SORPRESA)  
      @casillas << Calle.new(4,600, TituloPropiedad.new("Cairo", 600, 60, -0.10, 250, 350))
      @casillas << Casilla.new(5, 300, TipoCasilla::IMPUESTO)
      @casillas << Calle.new(6, 650, TituloPropiedad.new("Amarha", 650, 65, 0.1, 300, 400))
      @casillas << Calle.new(7, 700, TituloPropiedad.new("Karnak", 700, 70, 0.15, 350, 450))
      @casillas << Calle.new(8, 750, TituloPropiedad.new("Koptos", 750, 75, 0.2, 400, 500))
      @casillas << Casilla.new(9, 0, TipoCasilla::SORPRESA)  
      @casillas << Calle.new(10, 1000, TituloPropiedad.new("Nagada", 1000, 100, 0.2, 1000, 750))
      @casillas << Casilla.new(11, 0, TipoCasilla::JUEZ)
      @casillas << Calle.new(12, 800, TituloPropiedad.new("Abydos", 800, 80, 0.1, 450, 550))
      @casillas << Calle.new(13, 850, TituloPropiedad.new("Rosetta", 850, 85, 0.1, 500, 600))
      @casillas << Casilla.new(14, 0, TipoCasilla::PARKING)
      @casillas << Calle.new(15, 900, TituloPropiedad.new("Alejandría", 900, 90, 0.15, 750, 700))
      @carcel = Casilla.new(16, 0, TipoCasilla::CARCEL)    
      @casillas << @carcel
      @casillas << Calle.new(17, 950, TituloPropiedad.new("Luxor", 950, 90, 0.2, 900, 750))
      @casillas << Casilla.new(18, 0, TipoCasilla::SORPRESA)   
      @casillas << Calle.new(19, 1000, TituloPropiedad.new("Giza", 1000, 100, 0.2, 1000, 750))
    end

    def obtenerCasillaFinal(casilla, desplazamiento)
      nuevapos = (casilla.numeroCasilla + desplazamiento) % casillas.size
      return casillas[nuevapos]
    end

    def obtenerCasillaNumero(numeroCasilla)
      return casillas[numeroCasilla]
    end

    def to_s
      i = @casillas.size
      resultado = "Tablero\n"
      # Loops
      j = 0
      while j < i
        resultado = resultado + @casillas[j].to_s
        j += 1
      end
      return resultado
    end  
    
  private :inicializar
  
  end
end