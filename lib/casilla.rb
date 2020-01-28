#encoding: utf-8
# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

require_relative "tipo_casilla"
require_relative "titulo_propiedad"

module ModeloQytetet
  class Casilla
    def initialize(numeroCas, coste, tipocasilla)
      @numeroCasilla = numeroCas
      @coste = coste
      @tipo = tipocasilla
    end

       
    def getNumeroCasilla
      return @numeroCasilla
    end
    
    #def self.crearCalle(numeroCas, titulo)
    #  new(numeroCas, titulo.precioCompra, TipoCasilla::CALLE, titulo)
    #end

    #def self.crearNoCalle(numeroCas, tipo)
    #  new(numeroCas, 0, tipo, nil)
    #end 
    
    #def self.crearCasillaImpuesto(numeroCas, coste)
    #  new(numeroCas, coste, TipoCasilla::IMPUESTO, nil)
    #end

    
   
    def getCoste
      return @coste
    end

    def setCoste(coste)
      @coste=coste
    end

    def soyEdificable
      return tipo==TipoCasilla::CALLE
    end

    

      # Métodos get implicitos
    attr_reader :numeroCasilla, :tipo, :coste#, :titulo

    # Para usar de constructor solo los metodos crearCalle y crearNoCalle privatizamos el new
    #private_class_method :new

      # Método to_string
      def to_s
        #if @tipo == TipoCasilla::CALLE
          "\nCasilla: NumeroCasilla #{@numeroCasilla} \nCoste: #{@coste} \nTipoCasilla: #{@tipo}"
        #else "\nCasilla: NumeroCasilla #{@numeroCasilla} \nTipoCasilla: #{@tipo}"
        #end
      end
  end
end