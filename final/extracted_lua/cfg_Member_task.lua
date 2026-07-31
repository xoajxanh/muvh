local cfg_Member_task = {
  {
    id = 1001,
    sort = 1,
    vipTaskCondition = {
      {
        {101, 110}
      }
    },
    showRequire = "C\225\186\165p \196\145\225\186\161t Lv110 m\225\187\159",
    count = 2442001,
    vipExp = "1000120#36",
    goals = "8100006",
    taskdes = "Ho\195\160n th\195\160nh 1 l\225\186\167n Nhi\225\187\135m V\225\187\165 D\197\169ng S\196\169",
    param1 = "2480100"
  },
  {
    id = 1002,
    sort = 2,
    vipTaskCondition = {
      {
        {101, 80}
      }
    },
    showRequire = "C\225\186\165p \196\145\225\186\161t Lv80 m\225\187\159",
    count = 2442002,
    vipExp = "1000120#60",
    goals = "8100012",
    taskdes = "Ho\195\160n th\195\160nh 1 l\225\186\167n Huy\225\186\191t L\195\162u",
    openWay = 2,
    param1 = "1003009"
  },
  {
    id = 1003,
    sort = 3,
    vipTaskCondition = {
      {
        {101, 80}
      }
    },
    showRequire = "C\225\186\165p \196\145\225\186\161t Lv80 m\225\187\159",
    count = 2442003,
    vipExp = "1000120#60",
    goals = "8100013",
    taskdes = "Ho\195\160n th\195\160nh 1 l\225\186\167n Qu\225\186\163ng Tr\198\176\225\187\157ng Qu\225\187\183",
    openWay = 2,
    param1 = "1004006"
  },
  {
    id = 1004,
    sort = 4,
    vipTaskCondition = {
      {
        {101, 80}
      }
    },
    showRequire = "C\225\186\165p \196\145\225\186\161t Lv80 m\225\187\159",
    count = 2442004,
    vipExp = "1000120#36",
    goals = "8100002",
    taskdes = "Ti\195\170u di\225\187\135t 1 BOSS Hoang D\195\163",
    param1 = "2440101"
  },
  {
    id = 1005,
    sort = 5,
    vipTaskCondition = {
      {
        {101, 401},
        {3101, 108},
        {3104, 408}
      }
    },
    showRequire = "C\225\186\165p \196\145\225\186\161t Lv401 m\225\187\159",
    count = 2442005,
    vipExp = "1000120#120",
    goals = "8100003",
    taskdes = "Ti\195\170u di\225\187\135t 1 BOSS Ph\195\186c L\225\187\163i",
    param1 = "2440701"
  },
  {
    id = 1006,
    sort = 6,
    vipTaskCondition = {
      {
        {101, 801},
        {3101, 208},
        {3104, 508}
      }
    },
    showRequire = "C\225\186\165p \196\145\225\186\161t Lv801 m\225\187\159",
    count = 2442006,
    goals = "8100010",
    taskdes = "Ti\195\170u di\225\187\135t 1 BOSS Trang S\225\187\169c",
    param1 = "2440902"
  },
  {
    id = 1007,
    sort = 7,
    vipTaskCondition = {
      {
        {101, 1201},
        {3101, 308},
        {3104, 608}
      }
    },
    showRequire = "C\225\186\165p \196\145\225\186\161t Lv1201 m\225\187\159",
    count = 2442007,
    goals = "8100011",
    taskdes = "Ti\195\170u di\225\187\135t 1 BOSS Th\195\173 Luy\225\187\135n",
    param1 = "2440904"
  },
  {
    id = 1008,
    sort = 8,
    vipTaskCondition = {
      {
        {101, 401},
        {3101, 408}
      }
    },
    showRequire = "C\225\186\165p \196\145\225\186\161t Lv401 m\225\187\159",
    count = 2442008,
    vipExp = "1000120#120",
    goals = "8100003",
    taskdes = "Ti\195\170u di\225\187\135t 1 BOSS Ph\195\186c L\225\187\163i",
    param1 = "2440701"
  },
  {
    id = 1009,
    sort = 9,
    vipTaskCondition = {
      {
        {101, 801},
        {3101, 508}
      }
    },
    showRequire = "C\225\186\165p \196\145\225\186\161t Lv801 m\225\187\159",
    count = 2442009,
    goals = "8100010",
    taskdes = "Ti\195\170u di\225\187\135t 1 BOSS Trang S\225\187\169c",
    param1 = "2440902"
  },
  {
    id = 1010,
    sort = 10,
    vipTaskCondition = {
      {
        {101, 1201},
        {3101, 608}
      }
    },
    showRequire = "C\225\186\165p \196\145\225\186\161t Lv1201 m\225\187\159",
    count = 2442010,
    goals = "8100011",
    taskdes = "Ti\195\170u di\225\187\135t 1 BOSS Th\195\173 Luy\225\187\135n",
    param1 = "2440904"
  }
}
local defaults = {
  vipExp = "1000120#180",
  name = "",
  openWay = 3,
  param2 = ""
}
local mt = {__index = defaults}
for _, v in ipairs(cfg_Member_task) do
  setmetatable(v, mt)
end
return cfg_Member_task
