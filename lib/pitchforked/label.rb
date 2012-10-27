require_relative 'album'

class Label 
  attr_accessor :id, :name

  def initialize
    self.class.all << self
  end

  def self.all
    @@labels ||= []
  end
end