#encoding: utf-8
# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.


require "singleton"
require_relative "qytetet"
require_relative "estado_juego"
require_relative "metodo_salir_carcel"
require_relative "opcionmenu"

module Controladorqytetet
  class ControladorQytetet
    
    include Singleton
    
    def initialize
      @modelo= ModeloQytetet::Qytetet.instance
      @nombreJugadores=Array.new
    end
    
    def setNombreJugadores(jugadores)
        @nombreJugadores = jugadores;
    end
    
    def getModelo
      @modelo
    end
    
    def obtenerOperacionesJuegoValidas
        operaciones = Array.new
        if (@modelo.getJugadores.size == 0) 
            operaciones << (OpcionMenu.index(:INICIARJUEGO))
        else 

            case (@modelo.getEstadoJuego) 

            when ModeloQytetet::EstadoJuego::JA_PREPARADO
                  operaciones << (OpcionMenu.index(:JUGAR))
                  #operaciones << (OpcionMenu.index(:OBTENERRANKING))
                  operaciones << (OpcionMenu.index(:MOSTRARJUGADORACTUAL))
                  operaciones << (OpcionMenu.index(:MOSTRARJUGADORES))
                  operaciones << (OpcionMenu.index(:MOSTRARTABLERO))
                  

            when  ModeloQytetet::EstadoJuego::ALGUNJUGADORENBANCARROTA
                  operaciones << (OpcionMenu.index(:OBTENERRANKING))
                    #ops.add("TerminarJuego");
            
            when ModeloQytetet::EstadoJuego::JA_ENCARCELADO
                  operaciones << (OpcionMenu.index(:PASARTURNO))
                  #operaciones << (OpcionMenu.index(:OBTENERRANKING))
                  operaciones << (OpcionMenu.index(:MOSTRARJUGADORACTUAL))
                  operaciones << (OpcionMenu.index(:MOSTRARJUGADORES))
                  operaciones << (OpcionMenu.index(:MOSTRARTABLERO))

            when ModeloQytetet::EstadoJuego::JA_CONSORPRESA
                  operaciones << (OpcionMenu.index(:APLICARSORPRESA))
                  #operaciones << (OpcionMenu.index(:OBTENERRANKING))
                  operaciones << (OpcionMenu.index(:MOSTRARJUGADORACTUAL))
                  operaciones << (OpcionMenu.index(:MOSTRARJUGADORES))
                  operaciones << (OpcionMenu.index(:MOSTRARTABLERO))

            when ModeloQytetet::EstadoJuego::JA_PUEDEGESTIONAR
                  operaciones << (OpcionMenu.index(:PASARTURNO))
                  operaciones << (OpcionMenu.index(:VENDERPROPIEDAD))
                  operaciones << (OpcionMenu.index(:CANCELARHIPOTECA))
                  operaciones << (OpcionMenu.index(:HIPOTECARPROPIEDAD))
                  operaciones << (OpcionMenu.index(:EDIFICARCASA))
                  operaciones << (OpcionMenu.index(:EDIFICARHOTEL))
                  #operaciones << (OpcionMenu.index(:OBTENERRANKING))
                  operaciones << (OpcionMenu.index(:MOSTRARJUGADORACTUAL))
                  operaciones << (OpcionMenu.index(:MOSTRARJUGADORES))
                  operaciones << (OpcionMenu.index(:MOSTRARTABLERO))


            when ModeloQytetet::EstadoJuego::JA_PUEDECOMPRAROGESTIONAR
                  operaciones << (OpcionMenu.index(:PASARTURNO))
                  operaciones << (OpcionMenu.index(:COMPRARTITULOPROPIEDAD))
                  operaciones << (OpcionMenu.index(:VENDERPROPIEDAD))
                  operaciones << (OpcionMenu.index(:CANCELARHIPOTECA))
                  operaciones << (OpcionMenu.index(:HIPOTECARPROPIEDAD))
                  operaciones << (OpcionMenu.index(:EDIFICARCASA))
                  operaciones << (OpcionMenu.index(:EDIFICARHOTEL))
                  #operaciones << (OpcionMenu.index(:OBTENERRANKING))
                  operaciones << (OpcionMenu.index(:MOSTRARJUGADORACTUAL))
                  operaciones << (OpcionMenu.index(:MOSTRARJUGADORES))
                  operaciones << (OpcionMenu.index(:MOSTRARTABLERO))
                    

            when ModeloQytetet::EstadoJuego::JA_ENCARCELADOCONOPCIONDELIBERTAD
                  operaciones << (OpcionMenu.index(:INTENTARSALIRCARCELPAGANDOLIBERTAD))
                  operaciones << (OpcionMenu.index(:INTENTARSALIRCARCELTIRANDODADO))
                  #operaciones << (OpcionMenu.index(:OBTENERRANKING))
                  operaciones << (OpcionMenu.index(:MOSTRARJUGADORACTUAL))
                  operaciones << (OpcionMenu.index(:MOSTRARJUGADORES))
                  operaciones << (OpcionMenu.index(:MOSTRARTABLERO))


            end
            operaciones << (OpcionMenu.index(:TERMINARJUEGO))
        end
        return operaciones
    end
    
    def necesitaElegirCasilla(opcionMenu)    
        opcion = OpcionMenu[opcionMenu]
        necesita = false
        if ((opcion == :HIPOTECARPROPIEDAD) || 
              (opcion == :CANCELARHIPOTECA) || 
              (opcion == :EDIFICARCASA)     || 
              (opcion == :EDIFICARHOTEL)    || 
              (opcion == :VENDERPROPIEDAD)) 
              
            necesita = true
        end
        return necesita

    end
    
    def obtenerCasillasValidas(opcionMenu) 
        opcion = OpcionMenu[opcionMenu]
        casillasValidas = Array.new
        if (opcion == :HIPOTECARPROPIEDAD) 
            casillasValidas = @modelo.obtenerPropiedadesJugadorSegunEstadoHipoteca(false)
        else if (opcion == :CANCELARHIPOTECA) 
            casillasValidas = @modelo.obtenerPropiedadesJugadorSegunEstadoHipoteca(true)
             
        else if ((opcion == :EDIFICARCASA) || 
                (opcion == :EDIFICARHOTEL) || 
                (opcion == :VENDERPROPIEDAD)) 
            casillasValidas = @modelo.obtenerPropiedadesJugador
             end
             
          end
        end
        return casillasValidas;
    end
    
    def realizarOperacion(opcionElegida, casillaElegida)
        opcion = OpcionMenu[opcionElegida]
        resultado = ""
        case (opcion) 
          
        when :INICIARJUEGO
          @modelo.inicializarJuego(@nombreJugadores)
          resultado = "\nJuego iniciado\n"
                
        when :JUGAR
          @modelo.jugar
          resultado = "\nValor del dado: #{@modelo.getValorDado} Casilla actual: #{@modelo.getJugadorActual}\n"
          
        when :APLICARSORPRESA
          @modelo.aplicarSorpresa
          resultado = @modelo.getJugadorActual.to_s
          
        when :INTENTARSALIRCARCELPAGANDOLIBERTAD
                if (@modelo.intentarSalirCarcel(ModeloQytetet::MetodoSalirCarcel::PAGANDOLIBERTAD))
                    resultado = "\nSe ha salido de la cárcel.\n"
                else 
                    resultado = "\nNO se ha salido de la cárcel.\n"
                end
        
        when :INTENTARSALIRCARCELTIRANDODADO
                if (@modelo.intentarSalirCarcel(ModeloQytetet::MetodoSalirCarcel::TIRANDODADO)) 
                    resultado = "\nSe ha salido de la cárcel.\n"
                else 
                    resultado = "\nNO se ha salido de la cárcel.\n"
                end
               
        when :COMPRARTITULOPROPIEDAD
                if (@modelo.comprarTituloPropiedad)
                    resultado = "\nSe ha comprado la propiedad.\n"
                else
                    resultado = "\nNO se ha comprado la propiedad.\n"
                end

        when :HIPOTECARPROPIEDAD
                @modelo.hipotecarPropiedad(casillaElegida)
                resultado = "\nSe ha hipotecado la propiedad.\n"
  
        when :CANCELARHIPOTECA
                if (@modelo.cancelarHipoteca(casillaElegida)) 
                    resultado = "\nSe ha cancelado la hipoteca.\n"
                else 
                    resultado = "\nNO se ha cancelado la hipoteca.\n"
                end

        when :EDIFICARCASA
                if (@modelo.edificarCasa(casillaElegida)) 
                    resultado = "\nSe ha edificado una casa.\n"
                else 
                    resultado = "\nNO se ha edificado casa.\n"
                end
                
        when :EDIFICARHOTEL
                if (@modelo.edificarHotel(casillaElegida))
                    resultado = "\nSe ha edificado un hotel.\n"
                else
                    resultado = "\nNO se ha edificado hotel.\n"
                end

        when :VENDERPROPIEDAD
                @modelo.venderPropiedad(casillaElegida)
                resultado = "\nSe ha vendido la propiedad.\n"

        when :PASARTURNO
                @modelo.siguienteJugador
                resultado = "\nPasando turno.\n"

        when :OBTENERRANKING
                @modelo.obtenerRanking
                resultado = "\nMostrando Ranking...\n"

        when :TERMINARJUEGO
                @modelo.obtenerRanking
                resultado = "\nJuego acabado.\n"
                exit(0)
                
        when :MOSTRARJUGADORES
                puts @modelo.getJugadores
                resultado = "\nMostrando jugadores...\n"
         
        when :MOSTRARJUGADORACTUAL
                puts @modelo.getJugadorActual
                resultado = "\nMostrando jugador actual...\n"
       
        when :MOSTRARTABLERO
                puts @modelo.getTablero
                resultado = "\nMostrando tablero...\n"
         
        end
        return resultado
    end
                
  end
end