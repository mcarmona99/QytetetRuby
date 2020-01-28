#encoding: utf-8
# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.


require_relative "controlador_qytetet"

module Vistatextualqytetet
  class VistaTextualQytetet
    
    @@controlador = Controladorqytetet::ControladorQytetet.instance
    
    def self.obtenerNombreJugadores
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
    
    def self.elegirCasilla(opcionMenu)
      casillasValidas = Array.new
      casillasValidas = @@controlador.obtenerCasillasValidas(opcionMenu)
      if(casillasValidas.size == 0)
        elegida = -1
      else
        lista = Array.new
        i = 0
        j = casillasValidas.size
        while i < j
          lista << casillasValidas[i].to_s
          i = i + 1 
        end
        operacionS = leerValorCorrectoCasilla(lista)
        elegida = operacionS.to_i
      end
      return elegida
    end
    
    def self.leerValorCorrectoCasilla(valoresCorrectos)
      introducido = " "
      puts "Introduce número de casilla para operación indicada\n"
      i = 0
      j = valoresCorrectos.size
      while i < j
        aux = valoresCorrectos[i].to_i
        puts "Numero de casilla: " + aux.to_s + "\n"
        i = i + 1
      end
      introducido = gets.chomp
      
      while not valoresCorrectos.include? introducido
        puts "Introduce número de casilla para operación indicada\n"
        i = 0
        j = valoresCorrectos.size
        while i < j
          aux = valoresCorrectos[i].to_i
          puts "Numero de casilla: " + aux.to_s + "\n"
          i = i + 1
        end
        introducido = gets.chomp
      end
      return introducido
    end
    
    def self.leerValorCorrectoOperacion(valoresCorrectos)
      introducido = " "
      if (@@controlador.getModelo.getJugadores.size == 0)
        nombre = "(juego no iniciado)"
        casillaDeJugador = " "
      else
        nombre = @@controlador.getModelo.getJugadorActual.getNombre
        casillaDeJugador = @@controlador.getModelo.getJugadorActual.getCasillaActual.getNumeroCasilla
      end
      while not valoresCorrectos.include? introducido
        puts "Jugador: #{nombre} en casilla #{casillaDeJugador} --> Elige una opcion\n"
        i = 0
        j = valoresCorrectos.size
        while i < j
          aux = valoresCorrectos[i].to_i
          opcion = Controladorqytetet::OpcionMenu[aux]
          puts "Opcion #{aux} #{opcion} \n"
          i = i + 1
        end
        introducido = gets.chomp
      end
      return introducido
    end    
    
    def self.elegirOperacion
      casillasValidas = Array.new
      listaValidas = Array.new
      casillasValidas = @@controlador.obtenerOperacionesJuegoValidas()
      i = 0
      j = casillasValidas.size
      while i < j
        listaValidas << casillasValidas[i].to_s
        i = i + 1
      end
      operacionS = leerValorCorrectoOperacion(listaValidas)
      operacion = operacionS.to_i
      return operacion
    end
    
    def self.main
      @@controlador.setNombreJugadores(obtenerNombreJugadores)
      casillaElegida = 0
      while true
        operacionElegida = elegirOperacion
        necesitaElegirCasilla = @@controlador.necesitaElegirCasilla(operacionElegida)
        if (necesitaElegirCasilla)
          casillaElegida = elegirCasilla(operacionElegida)
        end
        if (!necesitaElegirCasilla || casillaElegida >= 0)
          realizar = @@controlador.realizarOperacion(operacionElegida, casillaElegida)
          puts realizar
        end
        
      end
    end
  end    
  
  VistaTextualQytetet.main  
  
end
