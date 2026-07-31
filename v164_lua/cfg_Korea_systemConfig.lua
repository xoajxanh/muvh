local cfg_Korea_systemConfig = {
  {
    id = 1,
    android = "notice",
    ios = "notice"
  },
  {
    id = 2,
    android = "event",
    ios = "event"
  },
  {
    id = 3,
    android = "cs",
    ios = "cs",
    pc = "https://alpha-mumonarch2.webzen.co.kr/support",
    pcLive = "https://mumonarch2.webzen.co.kr/support"
  },
  {
    id = 4,
    android = "faq",
    ios = "faq"
  },
  {
    id = 5,
    android = "coupon",
    ios = "coupon"
  },
  {
    id = 6,
    android = "post",
    ios = "post"
  },
  {
    id = 7,
    android = "community",
    ios = "community",
    pc = "https://alpha-mumonarch2.webzen.co.kr/main",
    pcLive = "https://mumonarch2.webzen.co.kr/main"
  },
  {
    id = 8,
    android = "https://play.google.com/store/apps/details?id=com.webzen.mumonarch2.google",
    ios = "https://play.google.com/store/apps/details?id=com.webzen.mumonarch2.google",
    pc = "https://play.google.com/store/apps/details?id=com.webzen.mumonarch2.google",
    pcLive = "https://play.google.com/store/apps/details?id=com.webzen.mumonarch2.google"
  },
  {
    id = 9,
    android = "https://apps.apple.com/app/id6478943981?mt=8",
    ios = "https://apps.apple.com/app/id6478943981?mt=8",
    pc = "https://apps.apple.com/app/id6478943981?mt=8",
    pcLive = "https://apps.apple.com/app/id6478943981?mt=8"
  },
  {
    id = 10,
    android = "tos",
    ios = "tos",
    pc = "https://alpha-mumonarch2.webzen.co.kr/board/300/detail/14280",
    pcLive = "https://mumonarch2.webzen.co.kr/board/752/detail/257210"
  },
  {
    id = 11,
    android = "random",
    ios = "random",
    pc = "https://alpha-mumonarch2.webzen.co.kr/gameinfo/guide",
    pcLive = "https://mumonarch2.webzen.co.kr/gameinfo/guide/detail/2475"
  },
  {
    id = 12,
    android = "main",
    ios = "main"
  },
  {
    id = 13,
    android = "",
    ios = "",
    pc = "payment",
    pcLive = "payment"
  }
}
local defaults = {pc = "", pcLive = ""}
local mt = {__index = defaults}
for _, v in ipairs(cfg_Korea_systemConfig) do
  setmetatable(v, mt)
end
return cfg_Korea_systemConfig
