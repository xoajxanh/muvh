local cfg_Platform_channel = {
  {
    id = 1010101,
    operationId = 101,
    operationName = "\237\133\140\236\138\164\237\138\184",
    platformId = 101,
    platformName = "\237\133\140\236\138\164\237\138\184"
  },
  {
    id = 1090007,
    operationId = 109,
    operationName = "JIUZHOU(\236\164\145\234\181\173)",
    platformId = 7,
    platformName = "JIUZHOU(\236\164\145\234\181\173)"
  },
  {
    id = 1110010,
    operationId = 111,
    operationName = "XY3",
    platformId = 10,
    platformName = "XY3"
  },
  {
    id = 1140013,
    operationId = 114,
    operationName = "WANXIN3(\236\164\145\234\181\173)",
    platformId = 13,
    platformName = "WANXIN3(\236\164\145\234\181\173)"
  },
  {
    id = 1120011,
    platformId = 11,
    platformName = "MHA \236\151\176\235\167\185(\236\164\145\234\181\173)"
  },
  {
    id = 1120015,
    platformId = 15,
    platformName = "HUAWEI"
  },
  {
    id = 1120016,
    platformId = 16,
    platformName = "oppo(\236\164\145\234\181\173)"
  },
  {
    id = 1120017,
    platformId = 17,
    platformName = "vivo(\236\164\145\234\181\173)"
  },
  {
    id = 1120018,
    platformId = 18,
    platformName = "YINGYONGBAO"
  },
  {
    id = 1150014,
    operationId = 115,
    operationName = "MHA \236\151\176\235\167\1852(\236\164\145\234\181\173)",
    platformId = 14,
    platformName = "MHA \236\151\176\235\167\1852(\236\164\145\234\181\173)"
  },
  {
    id = 1150019,
    operationId = 115,
    operationName = "MHA \236\151\176\235\167\1852(\236\164\145\234\181\173)",
    platformId = 19,
    platformName = "XIAOMI"
  },
  {
    id = 1150020,
    operationId = 115,
    operationName = "MHA \236\151\176\235\167\1852(\236\164\145\234\181\173)",
    platformId = 20,
    platformName = "LEIDIAN"
  },
  {
    id = 1150021,
    operationId = 115,
    operationName = "MHA \236\151\176\235\167\1852(\236\164\145\234\181\173)",
    platformId = 21,
    platformName = "JIUYOU"
  },
  {
    id = 1160022,
    operationId = 116,
    operationName = "TANWAN3(\236\164\145\234\181\173)",
    platformId = 22,
    platformName = "TANWAN3(\236\164\145\234\181\173)"
  },
  {
    id = 1170023,
    operationId = 117,
    operationName = "WANXIN4(\236\164\145\234\181\173)",
    platformId = 23,
    platformName = "WANXIN4(\236\164\145\234\181\173)"
  },
  {
    id = 1180024,
    operationId = 118,
    operationName = "WANXIN5(\236\164\145\234\181\173)",
    platformId = 24,
    platformName = "WANXIN5(\236\164\145\234\181\173)"
  },
  {
    id = 1230029,
    operationId = 123,
    operationName = "WANXIN6(\236\164\145\234\181\173)",
    platformId = 29,
    platformName = "WANXIN6(\236\164\145\234\181\173)"
  },
  {
    id = 1240030,
    operationId = 124,
    operationName = "XY4(\236\164\145\234\181\173)",
    platformId = 30,
    platformName = "XY4(\236\164\145\234\181\173)"
  },
  {
    id = 1250031,
    operationId = 125,
    operationName = "\236\164\145\236\130\1722",
    platformId = 31,
    platformName = "\236\164\145\236\130\1722"
  },
  {
    id = 1210027,
    operationId = 121,
    operationName = "IOSXY(\236\164\145\234\181\173)",
    platformId = 27,
    platformName = "IOSXY(\236\164\145\234\181\173)",
    type = 2
  },
  {
    id = 1220028,
    operationId = 122,
    operationName = "IOSWANXIN(\236\164\145\234\181\173)",
    platformId = 28,
    platformName = "IOSWANXIN(\236\164\145\234\181\173)",
    type = 2
  }
}
local defaults = {
  operationId = 112,
  operationName = "MHA \236\151\176\235\167\185(\236\164\145\234\181\173)",
  type = 1,
  bannedLabel = "is_autoOperationH#is_emulatorSync5m#is_autoOperationWidely#is_autoOperationCustom#is_hooked#\237\134\181\236\139\160 \236\164\145\235\139\168",
  punish = 0,
  bannedTime = "903#7",
  bannedType = 1,
  bannedMoney = 0,
  blackHome = 1,
  blackHomeTime = "21600#31536000",
  accountNumber = "2",
  mailId = 2550001
}
local mt = {__index = defaults}
for _, v in ipairs(cfg_Platform_channel) do
  setmetatable(v, mt)
end
return cfg_Platform_channel
