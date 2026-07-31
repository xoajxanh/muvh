local cfg_puzzle_hole = {
  [1] = {
    id = 1,
    unlockLevel = 0,
    position = {
      15,
      22,
      23,
      29,
      30,
      31,
      32,
      33,
      39,
      40,
      47
    },
    cost = "230100020#2"
  },
  [2] = {
    id = 2,
    unlockLevel = 1,
    position = {
      14,
      16,
      21,
      24
    },
    cost = "230100020#3"
  },
  [3] = {
    id = 3,
    unlockLevel = 2,
    position = {
      38,
      41,
      46,
      48
    },
    cost = "230100020#4"
  },
  [4] = {
    id = 4,
    unlockLevel = 3,
    position = {
      7,
      8,
      13,
      20
    },
    cost = "230100020#6"
  },
  [5] = {
    id = 5,
    unlockLevel = 4,
    position = {
      9,
      10,
      17,
      25
    },
    cost = "230100020#8"
  },
  [6] = {
    id = 6,
    unlockLevel = 5,
    position = {
      34,
      42,
      49,
      54,
      55
    },
    cost = "230100020#8"
  },
  [7] = {
    id = 7,
    unlockLevel = 6,
    position = {
      28,
      37,
      45,
      52,
      53
    },
    cost = "230100020#8"
  },
  [8] = {
    id = 8,
    unlockLevel = 7,
    position = {
      1,
      2,
      6,
      12,
      19
    }
  },
  [9] = {
    id = 9,
    unlockLevel = 8,
    position = {
      4,
      5,
      11,
      18,
      26
    }
  },
  [10] = {
    id = 10,
    unlockLevel = 9,
    position = {
      43,
      50,
      56,
      60,
      61
    }
  },
  [11] = {
    id = 11,
    unlockLevel = 10,
    position = {
      36,
      44,
      51,
      57,
      58
    }
  },
  [12] = {
    id = 12,
    unlockLevel = 11,
    position = {
      3,
      27,
      35,
      59
    },
    cost = ""
  }
}
local defaults = {
  cost = "230100020#9",
  condition = ""
}
local mt = {__index = defaults}
for _, v in pairs(cfg_puzzle_hole) do
  setmetatable(v, mt)
end
return cfg_puzzle_hole
