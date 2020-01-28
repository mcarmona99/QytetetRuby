#encoding: utf-8
# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

require "singleton"

module ModeloQytetet
  class Dado
    include Singleton

    def initialize
    end

    def tirar
      @valor = 1 +rand(6)
    end

    attr_reader :valor

  end
end