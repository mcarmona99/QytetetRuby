#encoding: utf-8
# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

require_relative "sorpresa"
require_relative "dado"
require_relative "jugador"
require_relative "estado_juego"
require_relative "metodo_salir_carcel"
require_relative "tablero"
require "singleton"

module ModeloQytetet
  class Qytetet
    include Singleton
    include Comparable

    def initialize
      @@MAX_JUGADORES = 4
      @@NUM_SORPRESAS = 10
      @@NUM_CASILLAS = 20
      @@PRECIO_LIBERTAD = 200
      @@SALDO_SALIDA = 1000
      @mazo = Array.new
      @tablero = Tablero.new
      @cartaActual = nil
      @dado = Dado.instance
      @jugadores = Array.new
      @jugadorActual = nil
      @estado = nil
      @indiceJA
    end
    # Métodos get implicitos
    attr_reader :cartaActual, :dado, :jugadorActual, :jugadores, :mazo, :tablero, :estado
    attr_writer :cartaActual, :estado

    def getCartaActual
      @cartaActual
    end

    def getEstadoJuego
      @estado
    end
      
    def getTablero
      @tablero
    end
      
    def getDado
      @dado
    end

    def getMazo
      @mazo
    end
      
    def getJugadorActual
      @jugadorActual
    end

    def setJugadorActual (jugador)
      @jugadorActual = jugador
    end
      
    def setEstadoJuego (estado)
      @estado = estado
    end      
      
    def getJugadores
      @jugadores;
    end
    
    def actuarSiEnCasillaEdificable
      deboPagar = @jugadorActual.deboPagarAlquiler
      if (deboPagar)
        @jugadorActual.pagarAlquiler     
        if(getJugadorActual.getSaldo<=0)
          setEstadoJuego(EstadoJuego::ALGUNJUGADORENBANCARROTA)
        end
      end
      casilla = obtenerCasillaJugadorActual
      tengoPropietario = casilla.tengoPropietario
      if (tengoPropietario)
        setEstadoJuego(EstadoJuego::JA_PUEDEGESTIONAR)
      else
        setEstadoJuego(EstadoJuego::JA_PUEDECOMPRAROGESTIONAR)
      end
    end

    def actuarSiEnCasillaNoEdificable
      setEstadoJuego(EstadoJuego::JA_PUEDEGESTIONAR)
      casillaActual = @jugadorActual.casillaActual
      if (casillaActual.tipo == TipoCasilla::IMPUESTO)
        @jugadorActual.pagarImpuesto
        if (getJugadorActual.getSaldo <= 0)
          setEstadoJuego(EstadoJuego::ALGUNJUGADORENBANCARROTA)
        end
      else
        if (casillaActual.tipo == TipoCasilla::JUEZ)
          encarcelarJugador
        else
          if (casillaActual.tipo == TipoCasilla::SORPRESA)
            @cartaActual = getMazo[0]
            @mazo.delete_at(0)
            setEstadoJuego(EstadoJuego::JA_CONSORPRESA)
          end
        end
      end
    end

    def aplicarSorpresa
      cartaActual = @cartaActual
      valor = cartaActual.valor
      setEstadoJuego(EstadoJuego::JA_PUEDEGESTIONAR)
      if (cartaActual.tipo == TipoSorpresa::SALIRCARCEL)
        @jugadorActual.setCartaLibertad(cartaActual)
      else
        @mazo << cartaActual
      
        if (cartaActual.tipo == TipoSorpresa::PAGARCOBRAR)
          @jugadorActual.modificarSaldo(valor)
          if (@jugadorActual.saldo <= 0)
            setEstadoJuego(EstadoJuego::ALGUNJUGADORENBANCARROTA)
          end
        else
          if (cartaActual.tipo == TipoSorpresa::IRACASILLA)
            casillaCarcel = @tablero.esCasillaCarcel(valor)
            if (casillaCarcel)
              encarcelarJugador
            else
              mover(valor)
            end
          else
            if (cartaActual.tipo == TipoSorpresa::PORCASAHOTEL)
              numeroTotal = @jugadorActual.cuantasCasasHotelesTengo
              @jugadorActual.modificarSaldo(valor * numeroTotal)
              if (@jugadorActual.saldo <= 0)
                setEstadoJuego(EstadoJuego::ALGUNJUGADORENBANCARROTA)
              end
            else
              if (cartaActual.tipo == TipoSorpresa::PORJUGADOR)
                i = 0
                j = @jugadores.size
                while (i < j)
                  jugador = @jugadores[i]
                  if (jugador != @jugadorActual)
                    jugador.modificarSaldo(-valor)
                    if (jugador.saldo <= 0)
                      setEstadoJuego(EstadoJuego::ALGUNJUGADORENBANCARROTA)
                    end
                    @jugadorActual.modificarSaldo(valor)
                    if (@jugadorActual.saldo <= 0)
                      setEstadoJuego(EstadoJuego::ALGUNJUGADORENBANCARROTA)
                    end
                  end
                  i=i+1
                end
              else
                if (cartaActual.tipo == TipoSorpresa::CONVERTIRME)
                  nuevo = @jugadorActual.convertirme(valor)
                  @jugadores[@indiceJA] = nuevo
                  @jugadorActual = nuevo
                end
              end
            end
          end
        end
      end
    end

    def cancelarHipoteca(numeroCasilla)
      casilla = @tablero.obtenerCasillaNumero(numeroCasilla)
      titulo = casilla.titulo
      cancelada = @jugadorActual.cancelarHipoteca(titulo)
      setEstadoJuego(EstadoJuego::JA_PUEDEGESTIONAR)
      return cancelada
    end

    def comprarTituloPropiedad
      comprado= getJugadorActual.comprarTituloPropiedad
      if (comprado)
        setEstadoJuego(EstadoJuego::JA_PUEDEGESTIONAR)
      end 
      return comprado
    end

    def edificarCasa(numeroCasilla)
      edificada=false
      casilla=getTablero.obtenerCasillaNumero(numeroCasilla)
      titulo= casilla.getTitulo
      edificada=getJugadorActual.edificarCasa(titulo)
      if (edificada)
        setEstadoJuego(EstadoJuego::JA_PUEDEGESTIONAR)
      end 
      return edificada 
    end

    def edificarHotel(numeroCasilla)
      edificada=false
      casilla=getTablero.obtenerCasillaNumero(numeroCasilla)
      titulo= casilla.getTitulo
      edificada=getJugadorActual.edificarHotel(titulo)
      if (edificada)
        setEstadoJuego(EstadoJuego::JA_PUEDEGESTIONAR)
      end
      return edificada
    end

    def encarcelarJugador
      if (@jugadorActual.deboIrACarcel)
        casillaCarcel = @tablero.carcel
        @jugadorActual.irACarcel(casillaCarcel)
        setEstadoJuego(EstadoJuego::JA_ENCARCELADO)
      else
        carta = @jugadorActual.devolverCartaLibertad
        @mazo << carta
        setEstadoJuego(EstadoJuego::JA_PUEDEGESTIONAR)
      end
    end

    def getValorDado
      @dado.valor
    end

    def hipotecarPropiedad(numeroCasilla)
      casilla = @tablero.obtenerCasillaNumero(numeroCasilla)
      titulo = casilla.titulo
      @jugadorActual.hipotecarPropiedad(titulo)
      setEstadoJuego(EstadoJuego::JA_PUEDEGESTIONAR)
    end

    def inicializarCartasSorpresa
      @mazo << Sorpresa.new("Has encontrado la tumba de Tutankamón, saqueas su tesoro. Ganas 500.", 500, TipoSorpresa::PAGARCOBRAR)
      @mazo << Sorpresa.new("Te has perdido en el desierto y te han robado unos nómadas. Pierdes 1000.", -1000, TipoSorpresa::PAGARCOBRAR)
      @mazo << Sorpresa.new("Enhorabuena, tienes una audiencia con el faraón. Ve a la casilla 5.", 5, TipoSorpresa::IRACASILLA)
      @mazo << Sorpresa.new("Has sugerido que la tierra podria ser redonda. Vas a la carcel.", @tablero.carcel.numeroCasilla, TipoSorpresa::IRACASILLA)
      @mazo << Sorpresa.new("Te apetece hacer turismo, y visitas las piramides de Giza. Vas a Giza.", 19, TipoSorpresa::IRACASILLA)
      @mazo << Sorpresa.new("Nunca viene mal ser el cuñado del Faraón. Carta Libertad.", 0, TipoSorpresa::SALIRCARCEL)
      @mazo << Sorpresa.new("La sequia de este año ha echado a perder tus cosechas. Pierdes 100 por cada edificación.", -100, TipoSorpresa::PORCASAHOTEL)
      @mazo << Sorpresa.new("El dios Ra te ha bendecido con buenas cosechas. Ganas 200 por cada edificación.", 200, TipoSorpresa::PORCASAHOTEL)
      @mazo << Sorpresa.new("Durante tu viaje a Giza, tus vecinos aprovecharon para robarte. Pierdes 100 por cada jugador.", -100, TipoSorpresa::PORJUGADOR)
      @mazo << Sorpresa.new("Te haces pasar por el faraón y cobras impuestos a tus vecinos. Ganas 100 por cada jugador.", 100, TipoSorpresa::PORJUGADOR)
      @mazo << Sorpresa.new("Te gusta demasiado el dinero, ahora eres un especulador", 3000, TipoSorpresa::CONVERTIRME)
      @mazo << Sorpresa.new("¿Quien dice que no puede haber una burbuja inmobiliaria en el Antiguo Egipto? Ahora eres un especulador", 5000, TipoSorpresa::CONVERTIRME)
      @mazo.shuffle!
    end

    def inicializarJuego(nombres)
      inicializarJugadores(nombres)
      inicializarCartasSorpresa
      salidaJugadores
    end

    def inicializarJugadores(nombres)
      i = nombres.size
      # Loops  
      j = 0   
      while j < i
        @jugadores << Jugador.nuevo(nombres[j])
        j += 1
      end
    end

    def intentarSalirCarcel(metodo)
      if (metodo == MetodoSalirCarcel::TIRANDODADO)
        resultado = @dado.tirar
        if (resultado >= 5)
          @jugadorActual.setEncarcelado(false)
        end
      else
        if (metodo == MetodoSalirCarcel::PAGANDOLIBERTAD)
          @jugadorActual.pagarLibertad(@@PRECIO_LIBERTAD)
        end
      end
      encarcelado = @jugadorActual.encarcelado
      if (encarcelado)
        setEstadoJuego(EstadoJuego::JA_ENCARCELADO)
      else
        setEstadoJuego(EstadoJuego::JA_PREPARADO)
      end
      return !encarcelado
    end

    def jugar
      valorDado= tirarDado
      casillaFinal = getTablero.obtenerCasillaFinal(getJugadorActual.getCasillaActual, valorDado)
      mover(casillaFinal.getNumeroCasilla)
    end

    def mover(numCasillaDestino)
      casillaInicial = obtenerCasillaJugadorActual
      casillaFinal = getTablero.obtenerCasillaNumero(numCasillaDestino)
      getJugadorActual.setCasillaActual(casillaFinal)

      if (numCasillaDestino<casillaInicial.getNumeroCasilla())
        getJugadorActual.modificarSaldo(@@SALDO_SALIDA)
      end    
      if (casillaFinal.soyEdificable)
        actuarSiEnCasillaEdificable
      else
        actuarSiEnCasillaNoEdificable
      end
    end

    def obtenerCasillaJugadorActual
      casilla = @jugadorActual.getCasillaActual
      return casilla;
    end

    def obtenerCasillasTablero
      return (@tablero.casillas)
    end

    def obtenerPropiedadesJugador
      titulos = getJugadorActual.getPropiedades
      propiedades = Array.new
      cuantos=titulos.size
      i=0
      j=0
      while (i<cuantos && j<getTablero.getCasillas.size)
        if (getTablero.getCasillas[j].tipo == TipoCasilla::CALLE)
          if (getTablero.getCasillas[j].getTitulo == titulos[i] )
            propiedades << (getTablero.getCasillas[j].getNumeroCasilla)
            i=i+1
          end
        end
        j=j+1
      end
      return propiedades;
    end

    def obtenerPropiedadesJugadorSegunEstadoHipoteca(estado)
      titulos = getJugadorActual.getPropiedades
      propiedades = Array.new
      cuantos=titulos.size
      i=0
      j=0
      while (i<cuantos && j<getTablero.getCasillas.size)
        if (getTablero.getCasillas[j].tipo == TipoCasilla::CALLE)
          if (getTablero.getCasillas[j].getTitulo == titulos[i] )
            if (titulos[i].getHipotecada == estado )
              propiedades << (getTablero.getCasillas[j].getNumeroCasilla)
            end
            i=i+1
          end
        end
        j=j+1

      end
      return propiedades;
    end
    
    def setCartaActual(cartaActual)
      @cartaActual = cartaActual;
    
    end
    
    def obtenerRanking
      @jugadores=@jugadores.sort
      i = getJugadores.size
      jugadores = ""
      # Loops
      j = 0
      while j < i
        jugadores = jugadores + getJugadores[j].to_s
        j += 1
      end
      puts jugadores
    end

    def obtenerSaldoJugadorActual
      getJugadorActual.getSaldo
    end

    def salidaJugadores
      for t in @jugadores
        t.setCasillaActual(getTablero.obtenerCasillaNumero(0))
      end

      jugador_sorteado=rand(getJugadores.size)
      setJugadorActual(getJugadores[jugador_sorteado])
      @indiceJA=jugador_sorteado
      setEstadoJuego(EstadoJuego::JA_PREPARADO)
    end

    def siguienteJugador
      @indiceJA=((@indiceJA + 1) % getJugadores.size)
      setJugadorActual(getJugadores[@indiceJA])
      if(getJugadorActual.getEncarcelado)
        setEstadoJuego(EstadoJuego::JA_ENCARCELADOCONOPCIONDELIBERTAD)
      else
        setEstadoJuego(EstadoJuego::JA_PREPARADO)
      end
    end

    def tirarDado
      getDado.tirar
    end

    def venderPropiedad(numeroCasilla)
      casilla=tablero.obtenerCasillaNumero(numeroCasilla)
      getJugadorActual.venderPropiedad(casilla)
      setEstadoJuego(EstadoJuego::JA_PUEDEGESTIONAR)
      
    end

    #def jugadorActualEnCalleLibre
    #  getJugadorActual().estoyEnCalleLibre()
    #end  

    #def jugadorActualEncarcelado
    #  getJugadorActual().encarcelado
    #end
    
    #LOS DOS METODOS ANTERIORES ELIMINADOS
    #EN LA VERSION 5 DEL GUION P3

    def to_s
      i = @jugadores.size
      jugadores = ""
      # Loops
      j = 0
      while j < i
        jugadores = jugadores + @jugadores[j].to_s
        j += 1
      end
      i = @mazo.size
      mazo = ""
      # Loops
      j = 0
      while j < i
        mazo = mazo + @mazo[j].to_s
        j += 1
      end    
      "\nQYTETET: #{@tablero} \n\nMAX JUGADORES=#{@@MAX_JUGADORES}, NUM SORPRESAS=#{@@NUM_SORPRESAS}, NUM CASILLAS=#{@@NUM_CASILLAS}, PRECIO LIBERTAD=#{@@PRECIO_LIBERTAD}, SALDO SALIDA=#{@@SALDO_SALIDA}
      \nJUGADORES: #{jugadores}\nMAZO: #{mazo}"
    end  

    private :encarcelarJugador, :inicializarCartasSorpresa,
      :inicializarJugadores, :salidaJugadores, :setCartaActual
  end
end