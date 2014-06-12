class Testclass
  def self.all
    ObjectSpace.each_object(self).each {|x| p x.methods}
  end
  def self.all_names
   p ObjectSpace.each_object(self).collect {|x|  x.to_s}
   p ObjectSpace.each_object(self).collect {|x|  x.inspect}

  end
  def self.descendants
    ObjectSpace.each_object(Class).select { |klass| klass < self }
  end
end