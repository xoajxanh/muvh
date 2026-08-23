local cfg_GoodComment = {
  {id = 11, link = ""},
  {id = 14, link = ""},
  {
    id = 15,
    link = "https://appgallery.huawei.com/#/app/C106458455"
  },
  {id = 16, link = ""},
  {
    id = 17,
    link = "https://game.vivo.com.cn/index.html#/detail/112576"
  },
  {
    id = 18,
    link = "https://sj.qq.com/appdetail/com.tencent.tmgp.yonghenglianmeng"
  },
  {
    id = 49,
    link = "https://www.taptap.com/app/236611"
  },
  {
    id = 48,
    link = "https://app.biligame.com/page/detail_share.html?id=109238&sourceFrom=23006&_1663467092861"
  },
  {
    id = 50,
    link = "https://www.3839.com/a/144837.htm?from=hykb"
  },
  {
    id = 19,
    link = "https://game.wali.com/game/62357725"
  },
  {
    id = 20,
    link = "https://ldzs.ldmnq.com/game.html?system=LDZS&gameid=6872"
  },
  {
    id = 21,
    link = "https://a.9game.cn/yonghenglianmeng/"
  },
  {
    id = 46,
    link = "http://app.yeshen.com/games/single/18110"
  },
  {
    id = 44,
    link = "https://apps.galaxyappstore.com/preorder/000006399270"
  },
  {
    id = 39,
    link = "https://app.flyme.cn/games/public/detail?package_name=com.shenghe.yhlm.mz"
  },
  {
    id = 42,
    link = "https://m-appstore.nubia.com/detailedness.html?SoftId=1742659&SoftItemId=4798718"
  },
  {
    id = 47,
    link = "http://a.4399.cn/mobile/239613.html?from=yxh"
  },
  {
    id = 40,
    link = "https://3g.lenovomm.com/redsea/com.shenghe.yhlm.lenovo?rank_code=search_1_%E6%B0%B8%E6%81%92%E8%81%94%E7%9B%9F&num=1"
  },
  {
    id = 13,
    content = "GoodComment_4#GoodComment_5#GoodComment_6",
    ui = "Activity_GoodCommentWxUI",
    giftId = 2200002
  },
  {
    id = 23,
    content = "GoodComment_4#GoodComment_5#GoodComment_6",
    ui = "Activity_GoodCommentWxUI",
    giftId = 2200002
  },
  {
    id = 24,
    content = "GoodComment_4#GoodComment_5#GoodComment_6",
    ui = "Activity_GoodCommentWxUI",
    giftId = 2200002
  },
  {
    id = 29,
    content = "GoodComment_4#GoodComment_5#GoodComment_6",
    ui = "Activity_GoodCommentWxUI",
    giftId = 2200002
  },
  {
    id = 61,
    content = "GoodComment_4#GoodComment_5#GoodComment_6",
    ui = "Activity_GoodCommentWxUI",
    giftId = 2200002
  },
  {
    id = 63,
    content = "GoodComment_4#GoodComment_5#GoodComment_6",
    ui = "Activity_GoodCommentWxUI",
    giftId = 2200002
  },
  {
    id = 28,
    content = "GoodComment_4#GoodComment_5#GoodComment_6",
    ui = "Activity_GoodCommentWxUI",
    giftId = 2200002
  },
  {
    id = 122,
    content = "GoodComment_4#GoodComment_5#GoodComment_6",
    ui = "Activity_GoodCommentWxUI",
    giftId = 2200002
  }
}
local defaults = {
  content = "GoodComment_1#GoodComment_2#GoodComment_3",
  ui = "Activity_GoodCommentUI",
  giftId = 2200001,
  link = "http://ht.fgqj.db9k.com/redirect/code?code=GoodCommentWx"
}
local mt = {__index = defaults}
for _, v in ipairs(cfg_GoodComment) do
  setmetatable(v, mt)
end
return cfg_GoodComment
