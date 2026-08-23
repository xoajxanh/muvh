bit = bit32 or {
  band = function(a, b)
    return a & b
  end,
  bnot = function(a)
    return ~a
  end,
  bor = function(a, b)
    return a | b
  end,
  bxor = function(a, b)
    return a ~ b
  end,
  lshift = function(a, n)
    return a << n
  end,
  rshift = function(a, n)
    return a >> n
  end
}
