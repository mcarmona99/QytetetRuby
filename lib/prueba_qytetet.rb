#encoding: utf-8
# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

require_relative "qytetet"
require_relative "casilla"
require_relative "tablero"

module ModeloQytetet
  
  class PruebaQytetet
    @@juego = Qytetet.instance

      # Método que devuelve vector de sorpresas positivas
      def self.positivos
        mazoPos = Array.new
        # Loops  
        for s in @@juego.mazo
          if s.valor > 0
            mazoPos << s
          end
        end
        mazoPos
       end

      # Método que devuelve vector de sorpresas tipo IRACASILLA
      def self.movimientosacasilla
        mazoMov = Array.new
        # Loops  
        for s in @@juego.mazo
          if s.tipo == TipoSorpresa::IRACASILLA
            mazoMov << s
          end
        end
        mazoMov
       end      
      
       # Método que devuelve vector de sorpresas del tipo especificado en el parametro
      def self.sorpresastipo (param)
        mazoTipo = Array.new
        # Loops  
        for s in @@juego.mazo
          if s.tipo == param
            mazoTipo << s
          end
        end
        mazoTipo
       end     
       
      def self.getNombreJugadores
        nombres = Array.new
        numero_jugadores = 0
        while ((numero_jugadores < 2) || (numero_jugadores > 4))
          puts "Introduzca numero de jugadores (2 a 4): "
          numero_jugadores = gets.to_i
        end
        # Loops  
        j = 0  
        while j < numero_jugadores
          puts "Introduzca el nombre del jugador #{j + 1}: "
          nombres << gets
          j += 1  
        end   
        return nombres
      end
            
      def self.main
        nombres = getNombreJugadores
        @@juego.inicializarJuego(nombres)
        
        puts "\n\n----------ELEGIR OPCION-----------\n\n"
        opcion = 0
        while (opcion != -1)
            puts "\n\n\n\n"
            puts "1: Prueba el método mover\n"
            puts "2: Prueba el método pagarAlquiler\n"  
            puts "3: Prueba las sorpresas\n"
            puts "4: Pruebas con titulo de propiedad (hipotecar, cancelar hipoteca y vender):\n"
            puts "5: Prueba a salir de la carcel\n"    
            puts "6: Ranking\n"
            puts "7: Pruebas con tipo casilla impuesto y juez\n" 
            puts "8: Prueba con especulador y construcciones\n"
            puts "0: Exit\n"
            opcion = gets.to_i
            case opcion
            when 1
              puts "Prueba el método mover\n" 
              puts "Estado inicial de jugadores:\n"
              i = @@juego.getJugadores.size
              jugadores = ""
              # Loops
              j = 0
              while j < i
                jugadores = jugadores + @@juego.getJugadores[j].to_s
                j += 1
              end
              puts jugadores
              puts "Un movimiento de cada jugador:\n"
              @@juego.jugar
              @@juego.siguienteJugador
              @@juego.jugar
              jugadores = ""
              # Loops
              j = 0
              while j < i
                jugadores = jugadores + @@juego.getJugadores[j].to_s
                j += 1
              end
              puts jugadores
              puts "Otro movimiento de cada jugador:\n"
              @@juego.siguienteJugador
              @@juego.jugar
              @@juego.siguienteJugador
              @@juego.jugar
              jugadores = ""
              # Loops
              j = 0
              while j < i
                jugadores = jugadores + @@juego.getJugadores[j].to_s
                j += 1
              end
              puts jugadores         
            when 2
              puts "Prueba el método pagarAlquiler\n" 
              puts "Estado inicial de jugadores:\n"
              i = @@juego.getJugadores.size
              jugadores = ""
              # Loops
              j = 0
              while j < i
                jugadores = jugadores + @@juego.getJugadores[j].to_s
                j += 1
              end
              puts jugadores
              @@juego.mover(10)
              @@juego.comprarTituloPropiedad
              @@juego.siguienteJugador
              @@juego.mover(10)
              puts "Estado final de jugadores:\n"              
              jugadores = ""
              # Loops
              j = 0
              while j < i
                jugadores = jugadores + @@juego.getJugadores[j].to_s
                j += 1
              end
              puts jugadores 
              puts "Prueba con casas/hoteles edificados\n"
              @@juego.siguienteJugador
              @@juego.edificarCasa(10)
              @@juego.edificarHotel(10)
              @@juego.siguienteJugador
              @@juego.mover(10)
              jugadores = ""
              # Loops
              j = 0
              while j < i
                jugadores = jugadores + @@juego.getJugadores[j].to_s
                j += 1
              end
              puts jugadores 
              
            when 3
              puts "Prueba las sorpresas\n" 
              puts @@juego.getJugadorActual.to_s
              i = 12
              j = 0
              while j < i
                @@juego.mover(3)
                @@juego.aplicarSorpresa
                puts "Sorpresa #{j}\n"
                puts @@juego.getCartaActual.to_s
                puts @@juego.getJugadorActual.to_s
                j = j + 1
              end
            when 4
              puts "Pruebas con titulo de propiedad (hipotecar, cancelar hipoteca y vender):\n"
              @@juego.edificarCasa(10) #LAS CASAS SE EDIFICAN ANTES DE COMPRAR EL TITULO!!!!
              @@juego.mover(10)
              @@juego.comprarTituloPropiedad
              puts @@juego.getJugadorActual.to_s
              @@juego.hipotecarPropiedad(10)
              puts @@juego.getJugadorActual.to_s
              @@juego.cancelarHipoteca(10)
              puts @@juego.getJugadorActual.to_s
              @@juego.venderPropiedad(10)
              puts @@juego.getJugadorActual.to_s
          
            when 5
              puts "Prueba a salir de la carcel\n"  
              @@juego.mover(11)
              puts "Jugador tras caer en juez\n"
              puts @@juego.getJugadorActual.to_s
              if (@@juego.intentarSalirCarcel(MetodoSalirCarcel::TIRANDODADO))
                puts "Jugador sale de carcel tirando dado\n"
              else
                puts "Jugador no sale de carcel tirando dado\n"
              end
              puts @@juego.getJugadorActual.to_s
              
              @@juego.mover(11)
              
              if (@@juego.intentarSalirCarcel(MetodoSalirCarcel::PAGANDOLIBERTAD))
                puts "Jugador sale de carcel pagando libertad\n"
              else
                puts "Jugador no sale de carcel pagando libertad\n"
              end
              puts @@juego.getJugadorActual.to_s

            when 6
              puts "Ranking\n"     
              @@juego.getJugadorActual.setCasillaActual(@@juego.getTablero.obtenerCasillaNumero(10))
              @@juego.comprarTituloPropiedad
              @@juego.siguienteJugador
              @@juego.mover(10)
              @@juego.obtenerRanking
            when 7
              puts "Pruebas con tipo casilla impuesto y juez\n"
              @@juego.mover(5)
              puts "Jugador tras pagar impuesto\n"
              puts @@juego.getJugadorActual.to_s  
              @@juego.mover(11)
              puts "Jugador tras caer en juez\n"
              puts @@juego.getJugadorActual.to_s
            when 8
              puts "Pruebas con especulador y construir\n"
              @@juego.mover(3)
              @@juego.aplicarSorpresa
              puts @@juego.getJugadorActual.to_s 
              @@juego.mover(1)
              @@juego.comprarTituloPropiedad
              @@juego.edificarCasa(1)
              @@juego.edificarCasa(1)
              @@juego.edificarHotel(1)
              puts "Jugador tras construir 2 casas y 1 hotel\n"
              puts @@juego.getJugadorActual.to_s       
              @@juego.edificarCasa(1)
              @@juego.edificarCasa(1)
              @@juego.edificarCasa(1)
              @@juego.edificarHotel(1)
              @@juego.edificarCasa(1)
              @@juego.edificarCasa(1)
              @@juego.edificarCasa(1)
              @@juego.edificarCasa(1)
              @@juego.edificarHotel(1)
              @@juego.edificarCasa(1)
              @@juego.edificarCasa(1)
              @@juego.edificarCasa(1)
              @@juego.edificarCasa(1)
              @@juego.edificarCasa(1)              
              puts "Jugador tras construir 6 casas y 2 hotel\n"    
              puts @@juego.getJugadorActual.to_s 
            when 0
              opcion = -1
              puts "Exit\n"              
            end
        end     
      end
    end
    
    PruebaQytetet.main 
      
  end