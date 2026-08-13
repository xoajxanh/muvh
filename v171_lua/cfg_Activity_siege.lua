local cfg_Activity_siege = {
  {
    id = 1001,
    warChapter = 1,
    target = "100313#100312#100314",
    desc = "Ph\195\161 h\225\187\167y c\225\187\149ng th\195\160nh ngo\195\160i",
    walkto = {
      103100107,
      103100106,
      103100108
    },
    noDamage = 1
  },
  {
    id = 1002,
    warChapter = 2,
    target = "100318",
    desc = "Ph\195\161 h\225\187\167y T\198\176\225\187\163ng \196\144\195\161 Th\225\187\167 H\225\187\153 A",
    walkto = 103100112,
    noDamage = 2
  },
  {
    id = 1003,
    warChapter = 3,
    target = "100319",
    desc = "Ph\195\161 h\225\187\167y T\198\176\225\187\163ng \196\144\195\161 Th\225\187\167 H\225\187\153 B",
    walkto = 103100113,
    noDamage = 3
  },
  {
    id = 1004,
    warChapter = 4,
    target = "100315#100316",
    desc = "Ph\195\161 h\225\187\167y c\225\187\149ng th\195\160nh gi\225\187\175a",
    walkto = {103100109, 103100110},
    noDamage = 4
  },
  {
    id = 1005,
    warChapter = 5,
    target = "100320",
    desc = "Ph\195\161 h\225\187\167y T\198\176\225\187\163ng \196\144\195\161 Th\225\187\167 H\225\187\153 C",
    walkto = 103100114,
    noDamage = 5
  },
  {
    id = 1006,
    warChapter = 6,
    target = "100317",
    desc = "Ph\195\161 h\225\187\167y c\225\187\149ng th\195\160nh trong",
    walkto = 103100111,
    noDamage = 6
  },
  {
    id = 1007,
    warChapter = 7,
    target = "100321",
    desc = "Ph\195\161 h\225\187\167y T\198\176\225\187\163ng \196\144\195\161 Th\225\187\167 H\225\187\153 D",
    walkto = 103100115,
    noDamage = 7
  },
  {
    id = 1008,
    warChapter = 8,
    type = 301,
    target = "",
    desc = "Chi\225\186\191m V\198\176\198\161ng Mi\225\187\135n Loren",
    walkto = 103100116,
    noDamage = 0
  },
  {
    id = 2001,
    warChapter = 1,
    camp = 2,
    type = 201,
    target = "100313#100312#100314",
    desc = "Th\225\187\167 H\225\187\153 C\225\187\149ng Th\195\160nh Ngo\195\160i",
    walkto = {
      103100107,
      103100106,
      103100108
    },
    noDamage = 1
  },
  {
    id = 2002,
    warChapter = 2,
    camp = 2,
    type = 201,
    target = "100318",
    desc = "T\198\176\225\187\163ng \196\144\195\161 Th\225\187\167 H\225\187\153 A",
    walkto = 103100112,
    noDamage = 2
  },
  {
    id = 2003,
    warChapter = 3,
    camp = 2,
    type = 201,
    target = "100319",
    desc = "T\198\176\225\187\163ng \196\144\195\161 Th\225\187\167 H\225\187\153 B",
    walkto = 103100113,
    noDamage = 3
  },
  {
    id = 2004,
    warChapter = 4,
    camp = 2,
    type = 201,
    target = "100315#100316",
    desc = "Th\225\187\167 H\225\187\153 C\225\187\149ng Th\195\160nh Gi\225\187\175a",
    walkto = {103100109, 103100110},
    noDamage = 4
  },
  {
    id = 2005,
    warChapter = 5,
    camp = 2,
    type = 201,
    target = "100320",
    desc = "T\198\176\225\187\163ng \196\144\195\161 Th\225\187\167 H\225\187\153 C",
    walkto = 103100114,
    noDamage = 5
  },
  {
    id = 2006,
    warChapter = 6,
    camp = 2,
    type = 201,
    target = "100317",
    desc = "Th\225\187\167 H\225\187\153 C\225\187\149ng Th\195\160nh Trong",
    walkto = 103100111,
    noDamage = 6
  },
  {
    id = 2007,
    warChapter = 7,
    camp = 2,
    type = 201,
    target = "100321",
    desc = "T\198\176\225\187\163ng \196\144\195\161 Th\225\187\167 H\225\187\153 D",
    walkto = 103100115,
    noDamage = 7
  },
  {
    id = 2008,
    warChapter = 8,
    camp = 2,
    type = 301,
    target = "",
    desc = "V\198\176\198\161ng Mi\225\187\135n Loren Th\225\187\167 H\225\187\153",
    walkto = 103100116,
    noDamage = 0
  }
}
local defaults = {camp = 1, type = 101}
local mt = {__index = defaults}
for _, v in ipairs(cfg_Activity_siege) do
  setmetatable(v, mt)
end
return cfg_Activity_siege
