def valid?(state, x, y)
  0.upto(8) do |i|
    return false if i != y and state[x][i] == state[x][y]
    return false if i != x and state[i][y] == state[x][y]
  end

  x_from = (x / 3) * 3
  y_from = (y / 3) * 3
  x_from.upto(x_from + 2) do |xx|
    y_from.upto(y_from + 2) do |yy|
      return false if (xx != x or yy != y) and state[xx][yy] == state[x][y]
    end
  end

  true
end


def next_state(state, x, y)
  y = 0 and x = x + 1 if y == 9
  return true if x == 9

  unless state[x][y].zero?
    return false unless valid?(state, x, y)
    return next_state(state, x, y + 1)
  else
    1.upto(9) do |i|
    state[x][y] = i
      return true if valid?(state, x, y) and next_state(state, x, y + 1)
    end
  end

  state[x][y] = 0
  false
end

def deep_copy(o)
  Marshal.load(Marshal.dump(o))
end

board = [
  [ 0, 0, 0, 4, 0, 5, 0, 0, 1 ],
  [ 0, 7, 0, 0, 0, 0, 0, 3, 0 ],
  [ 0, 0, 4, 0, 0, 0, 9, 0, 0 ],
  [ 0, 0, 3, 5, 0, 4, 1, 0, 0 ],
  [ 0, 0, 7, 0, 0, 0, 4, 0, 0 ],
  [ 0, 0, 8, 9, 0, 1, 0, 0, 0 ],
  [ 0, 0, 9, 0, 0, 0, 6, 0, 0 ],
  [ 0, 8, 0, 0, 0, 0, 0, 2, 0 ],
  [ 4, 0, 0, 2, 0, 0, 0, 0, 0 ]
]

# Pre-optimization
board_test = deep_copy board
next_state(board_test, 0, 0)

times = []
1.upto(5) do
  state = deep_copy board
  before = Time.now
  next_state(state, 0, 0)
  times.push Time.now - before
end
avg_time = (times.instance_eval { reduce(:+) / size.to_f } * 1000).to_i
puts "Completed in #{avg_time}ms."
