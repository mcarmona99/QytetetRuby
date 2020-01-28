#encoding: utf-8

require_relative "casilla"
require_relative "tipo_casilla"
require_relative "titulo_propiedad"

module ModeloQytetet
  class Calle < Casilla
    def initialize(numeroCas, coste,titulo)
      super(numeroCas, coste, TipoCasilla::CALLE)
      @titulo=titulo
    end
    attr_reader :titulo
    def getTitulo
      @titulo
    end
  
    def asignarPropietario(jugador)
      @titulo.setPropietario(jugador)
      return @titulo
    end
  
    def pagarAlquiler
      costeAlquiler= getTitulo.pagarAlquiler
    end
  
    def setTitulo(titulo)
      @titulo = titulo
      setCoste(titulo.precioCompra)
    end
  
    def tengoPropietario
      return titulo.tengoPropietario
    end
  
    def to_s
      "\nCalle:" + super + @titulo.to_s
    end
    
    private :setTitulo
  end
end