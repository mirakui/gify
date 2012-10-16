class Gif
  def initialize(path)
    @path = Pathname(path.to_s)
  end

  def to_s
    @path.to_s
  end
end
