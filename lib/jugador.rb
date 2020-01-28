#encoding: utf-8
# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

require_relative "sorpresa"
require_relative "titulo_propiedad"
require_relative "casilla"
require_relative "especulador"


module ModeloQytetet
  class Jugador
    def initialize(nombre, encarcelado, saldo, propiedades, casillaActual, cartaLibertad)
      @encarcelado = encarcelado
      @nombre = nombre
      @saldo = saldo
      @propiedades = propiedades
      @casillaActual = casillaActual
      @cartaLibertad = cartaLibertad
    end
    
    def self.nuevo(nombre)
      new(nombre, false, 7500, Array.new, nil, nil)
    end
    
    def self.copia(otro)
      new(otro.getNombre, otro.getEncarcelado, otro.getSaldo, otro.getPropiedades, otro.getCasillaActual, otro.getCartaLibertad)
    end
    
    def convertirme(fianza)
      Especulador.copia(self, fianza)
    end

    attr_reader :cartaLibertad, :encarcelado, :nombre, :propiedades, :casillaActual, :saldo
    attr_writer :cartaLibertad, :casillaActual

    def setCasillaActual (casilla)
      @casillaActual = casilla
    end
    
    def getCartaLibertad
      @cartaLibertad
    end

    def setCartaLibertad(carta)
      @cartaLibertad = carta
    end
    
    def getCasillaActual
      @casillaActual
    end

    def getEncarcelado
      @encarcelado
    end

    def getNombre
      @nombre
    end

    def getPropiedades
      @propiedades
    end

    def getSaldo
      @saldo
    end    
    
    def <=>(otroJugador)
      otroJugador.obtenerCapital <=> obtenerCapital
    end

    def cancelarHipoteca(titulo)
      costeCancelar = titulo.calcularCosteCancelar
      tengoSaldo = tengoSaldo(costeCancelar)
      if (tengoSaldo)
        titulo.cancelarHipoteca
        modificarSaldo(- costeCancelar)
      end
      return !(titulo.hipotecada)
    end
    
    def puedoEdificarCasa(titulo)
      puedoconstruir = false
      numCasas = titulo.getNumCasas
      costeEdificarCasa = titulo.getPrecioEdificar
      if ((numCasas < 4) && (self.tengoSaldo(costeEdificarCasa)))
        puedoconstruir = true
      end
      return puedoconstruir
    end
    
    def puedoEdificarHotel(titulo)
      puedoconstruir = false
      numCasas = titulo.getNumCasas
      numHoteles = titulo.getNumHoteles
      costeEdificarHotel = titulo.getPrecioEdificar
      if (numCasas >= 4 && numHoteles < 4 && self.tengoSaldo(costeEdificarHotel))
        puedoconstruir = true
      end
      return puedoconstruir
    end    

    def comprarTituloPropiedad
      comprado=false
      costeCompra=getCasillaActual.getCoste
      if (costeCompra < getSaldo)
        titulo = getCasillaActual.asignarPropietario(self)
        comprado=true
        getPropiedades << titulo
        modificarSaldo(-costeCompra)
      end
      return comprado
    end

    def cuantasCasasHotelesTengo
      contador = 0
      j = @propiedades.size
      i = 0
      while i < j
        contador = contador + @propiedades[i].numCasas + @propiedades[i].numHoteles
        i = i + 1
      end
      return contador
    end

    def deboPagarAlquiler
      esDeMiPropiedad= esDeMiPropiedad(getCasillaActual.titulo)
      tienePropietario = false
      encarcelado = false
      estaHipotecada=false
      deboPagar=false
      if (!esDeMiPropiedad)
        tienePropietario = getCasillaActual.tengoPropietario
      end
      if ((!esDeMiPropiedad) & (tienePropietario))
        encarcelado=getCasillaActual.getTitulo.propietarioEncarcelado
        estaHipotecada=getCasillaActual.getTitulo.getHipotecada
      end
      deboPagar= ((!esDeMiPropiedad) & (tienePropietario) & (!encarcelado) & (!estaHipotecada)) 
      return deboPagar;
    end

    def devolverCartaLibertad
      carta = @cartaLibertad
      @cartaLibertad = nil
      return carta
    end

    def edificarCasa(titulo)
      edificada=false 
      if (self.puedoEdificarCasa(titulo))
        costeEdificarCasa=titulo.getPrecioEdificar
        titulo.edificarCasa
        modificarSaldo(-costeEdificarCasa)
        edificada=true
      end
      return edificada
    end

    def edificarHotel(titulo)
      edificada=false
      if (self.puedoEdificarHotel(titulo))
        costeEdificarHotel=titulo.getPrecioEdificar
        titulo.edificarHotel
        modificarSaldo(-costeEdificarHotel)
        edificada=true
        titulo.setNumCasas(titulo.getNumCasas - 4)
      end
      return edificada
    end

    def eliminarDeMisPropiedades(titulo)
      getPropiedades.delete(titulo)
      titulo.setPropietario(nil)
    end

    # Cierto si el jugador tiene entre sus propiedades el título de propiedad pasado como argumento.
    def esDeMiPropiedad(titulo)
      condicion = false
      numprops = @propiedades.size
      i = 0
      while ((!condicion) && (i < numprops))
        if (@propiedades[i] == titulo)
          condicion = true
        end
        i = i + 1
      end
      return condicion
    end

    def estoyEnCalleLibre
      return ((getCasillaActual.soyEdificable == true ) && ((getCasillaActual.titulo.getPropietario == nil) || (getCasillaActual().getTitulo()== nil))) 
    end

    def setEncarcelado(encarcelado)
      @encarcelado = encarcelado
    end

    def hipotecarPropiedad(titulo)
      costeHipoteca = titulo.hipotecar
      modificarSaldo(costeHipoteca)
      return titulo.hipotecada
    end

    def irACarcel(casilla)
      @casillaActual = casilla
      setEncarcelado(true)
    end

    # Añade al saldo la cantidad del argumento. Si el argumento es negativo, 
    # el saldo quedará reducido. Devuelve el nuevo saldo.
    def modificarSaldo(cantidad)
      @saldo = @saldo + cantidad
      return @saldo
    end

    def obtenerCapital
      numprop = @propiedades.size
      i = 0
      capitalpropiedades = 0
      while i < numprop
        valorpropiedad = 0
        valorpropiedad = valorpropiedad + ((@propiedades[i].numCasas + @propiedades[i].numHoteles) * @propiedades[i].precioEdificar)
        valorpropiedad = valorpropiedad + @propiedades[i].precioCompra
        if @propiedades[i].hipotecada
          valorpropiedad = valorpropiedad - propiedades[i].hipotecaBase
        end
        capitalpropiedades = capitalpropiedades + valorpropiedad
        i = i + 1
      end
      (@saldo + capitalpropiedades)
    end

    # Devuelve los títulos de propiedad del jugadorActual según el estado de hipotecado indicado (true o false)
    def obtenerPropiedades(hipotecada)
      nuevo = Array.new
      numprop = @propiedades.size
      i = 0
      while i < numprop    
        if (@propiedades[i].hipotecada == hipotecada)
          nuevo << @propiedades[i]
        end
        i = i + 1
      end
      return nuevo
    end

    def pagarAlquiler
      costeAlquiler= getCasillaActual.pagarAlquiler
      modificarSaldo(-costeAlquiler)
    end

    # Se reduce el saldo en la cantidad indicada en el atributo coste de la casillaActual.
    def pagarImpuesto
      aPagar = @casillaActual.coste
      @saldo = @saldo - aPagar
    end
    
    def deboIrACarcel
      return !(self.tengoCartaLibertad)
    end

    def pagarLibertad(cantidad)
      tengoSaldo = tengoSaldo(cantidad)
      if (tengoSaldo)
        @encarcelado = false
        modificarSaldo(- cantidad)
      end
    end

    # Cierto sólo si cartaLibertad no es nula.
    def tengoCartaLibertad
      (@cartaLibertad != nil)
    end

    # Devuelve verdadero si el saldo del jugador es superior a cantidad.
    def tengoSaldo(cantidad)
      return (@saldo > cantidad)
    end

    def venderPropiedad(casilla)
      titulo=casilla.getTitulo
      eliminarDeMisPropiedades(titulo)
      precioVenta=titulo.calcularPrecioVenta
      modificarSaldo(precioVenta)
        
    end

    def to_s
      capital = obtenerCapital
      prop=""
      for t in @propiedades
        prop=prop + t.to_s + "\n"
      end
      if @cartaLibertad == nil
        "Jugador:#{@nombre}\nEncarcelado=#{@encarcelado}, saldo=#{@saldo}, capital=#{capital}, casilla actual=#{@casillaActual}, carta de libertad=NO\n
        Propiedades:\n[#{prop}]\n"
      else "Jugador:#{@nombre}\nEncarcelado=#{@encarcelado}, saldo=#{@saldo}, capital=#{capital}, casilla actual=#{@casillaActual}, carta de libertad=#{@cartaLibertad.to_s}\n
            Propiedades:\n[#{prop}]\n"
      end
    end  
  
    private :eliminarDeMisPropiedades, :esDeMiPropiedad
  end
end