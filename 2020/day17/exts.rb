class Vector
  def x; self[0]; end
  def x=(val); self[0] = val; end
  def y; self[1]; end
  def y=(val); self[1] = val; end
  def z; self[2]; end
  def z=(val); self[2] = val; end
  def w; self[3]; end
  def w=(val); self[3] = val; end

  def neighbours
    NEIGHBOUR_DIFFS.map do |n|
      self + n
    end
  end
end
