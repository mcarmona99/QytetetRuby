#encoding: utf-8
# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.


module ModeloQytetet
  class TituloPropiedad
    # Constructor con parametros
    def initialize(nombre1, precioCompra1, alquilerBase1, factorRevalorizacion1, hipotecaBase1, precioEdificar1)
          @nombre = nombre1;
          @hipotecada = false;
          @precioCompra = precioCompra1;
          @alquilerBase = alquilerBase1;
          @factorRevalorizacion = factorRevalorizacion1;
          @hipotecaBase = hipotecaBase1;
          @precioEdificar = precioEdificar1;
          @numHoteles = 0;
          @numCasas = 0;
          @propietario = nil
    end

    # Métodos get implicitos
    attr_reader :nombre, :hipotecada, :precioCompra, :alquilerBase, :factorRevalorizacion, :hipotecaBase, :precioEdificar, :numHoteles, :numCasas, :propietario

    def getNombre
      @nombre
    end

    def getPropietario
      @propietario
    end
    
    def getHipotecada
      @hipotecada
    end

    def getAlquilerBase
      @alquilerBase
    end

    def getPrecioCompra
      @precioCompra
    end

    def getFactorRevalorizacion
      @factorRevalorizacion
    end

    def getHipotecaBase
      @hipotecaBase
    end

    def getPrecioEdificar
      @precioEdificar
    end

    def getNumHoteles
      @numHoteles
    end

    def getNumCasas
      @numCasas
    end

    def setNombre(nombre)
      @nombre=nombre
    end

    def setHipotecada(hipotecada)
      @hipotecada=hipotecada
    end

    def setAlquilerBase(alquilerBase)
      @alquilerBase=alquilerBase
    end

    def setPrecioCompra(precioCompra)
      @precioCompra=precioCompra
    end

    def setFactorRevalorizacion(factorRevalorizacion)
      @factorRevalorizacion=factorRevalorizacion
    end

    def setHipotecaBase(ipotecaBase)
      @hipotecaBase=hipotecaBase
    end

    def setPrecioEdificar(precioEdificar)
     @precioEdificar=precioEdificar
    end

    def setNumHoteles(numHoteles)
     @numHoteles=numHoteles
    end

    def setNumCasas(numCasas)
     @numCasas=numCasas
    end    
    
    def calcularCosteCancelar
      costeCancelar = calcularCosteHipotecar + (calcularCosteHipotecar / 10)
      return costeCancelar
    end

    def calcularCosteHipotecar
      costeHipoteca = @hipotecaBase + (@numCasas * (@hipotecaBase / 2)) + (@numHoteles * @hipotecaBase)
      return costeHipoteca
    end

    def calcularImporteAlquiler
        costeAlquiler = @alquilerBase + (100 * (@numCasas / 2 + @numHoteles * 2))
        return costeAlquiler
    end

    def calcularPrecioVenta
      precioVenta= (getPrecioCompra()+(getNumCasas() + getNumHoteles()) * getPrecioEdificar() * getFactorRevalorizacion())
    end

    def cancelarHipoteca
      @hipotecada = false
    end

    def edificarCasa
      setNumCasas(@numCasas+1)
    end

    def edificarHotel
      setNumHoteles(@numHoteles+1)
    end

    def hipotecar
      @hipotecada = true
      costeHipoteca = calcularCosteHipotecar
      return costeHipoteca
    end

    def pagarAlquiler
      costeAlquiler= calcularImporteAlquiler
      getPropietario.modificarSaldo(costeAlquiler)
      return costeAlquiler
    end

    def propietarioEncarcelado
      return getPropietario.getEncarcelado
    end

    def setHipotecada(hipotecada)
      @hipotecada = hipotecada
    end

    def setPropietario(propietario)
      @propietario = propietario
    end

    def tengoPropietario
      return (@propietario != nil)
    end

    # Método to_string
    def to_s
      if (tengoPropietario)
        "\nTituloPropiedad: Nombre: #{@nombre}, Propietario: #{@propietario.nombre}, Hipotecada: #{@hipotecada},
       precioCompra: #{@precioCompra}, alquilerBase: #{@alquilerBase},
       factorRevalorarizacion: #{@factorRevalorizacion}, hipotecaBase: #{@hipotecaBase},
       precioEdificar: #{@precioEdificar}, numHoteles: #{@numHoteles}, numCasas: #{@numCasas}"
      else "\nTituloPropiedad: Nombre: #{@nombre}, Hipotecada: #{@hipotecada},
       precioCompra: #{@precioCompra}, alquilerBase: #{@alquilerBase},
       factorRevalorarizacion: #{@factorRevalorizacion}, hipotecaBase: #{@hipotecaBase},
       precioEdificar: #{@precioEdificar}, numHoteles: #{@numHoteles}, numCasas: #{@numCasas}"
      end
    end

  end
end