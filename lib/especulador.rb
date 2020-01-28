#encoding: utf-8
# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.


module ModeloQytetet
  class Jugador
  end
  
  class Especulador < Jugador
    def initialize(jugador, fianza)
      super(jugador.getNombre, jugador.getEncarcelado, jugador.getSaldo, jugador.getPropiedades, jugador.getCasillaActual, jugador.getCartaLibertad)
      @fianza = fianza
    end
    
    def self.copia(otrojugador, fianza)
      new(otrojugador, fianza)
    end
    
    def convertirme (fianza)
      return self
    end
    
    def setSaldo (nuevoSaldo)
      @saldo = nuevoSaldo
    end

    def setFianza (fianza)
      @fianza = fianza
    end
    
    def getFianza
      return @fianza
    end
    
    def pagarImpuesto
      aPagar = @casillaActual.coste / 2
      @saldo = @saldo - aPagar
    end    
    
    def deboIrACarcel
      deboir = true
      if (self.tengoCartaLibertad)
        deboir = false
      else
        deboir = !(self.pagarFianza)
      end
      return deboir
    end
    
    def pagarFianza
      pagado = false
      if (getSaldo > getFianza)
        setSaldo(getSaldo - getFianza)
        pagado = true
      end
      return pagado
    end
    
    def puedoEdificarCasa(titulo)
      puedoconstruir = false
      numCasas = titulo.getNumCasas
      costeEdificarCasa = titulo.getPrecioEdificar
      if (numCasas < 8 && self.tengoSaldo(costeEdificarCasa))
        puedoconstruir = true
      end
      return puedoconstruir
    end
    
    def puedoEdificarHotel(titulo)
      puedoconstruir = false
      numCasas = titulo.getNumCasas
      numHoteles = titulo.getNumHoteles
      costeEdificarHotel = titulo.getPrecioEdificar
      if (numCasas >= 4 && numHoteles < 8 && self.tengoSaldo(costeEdificarHotel))
        puedoconstruir = true
      end
      return puedoconstruir
    end        
        
    def to_s
      super + " fianza: #{@fianza}\n"
    end      
  end
end
