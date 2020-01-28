#encoding: utf-8
# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

require_relative "tipo_sorpresa"

module ModeloQytetet
  class Sorpresa
    # Constructor con parametros
    def initialize(texto, valor, tipo)
      @texto = texto
      @valor = valor 
      @tipo = tipo
    end

    # Métodos get implicitos
    attr_reader :texto, :valor, :tipo

    # Método to_string
    def to_s
      "\nTexto: #{@texto} \nValor: #{@valor} \nTipo: #{@tipo}\n"
    end
  end
end