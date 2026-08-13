local NightFightMeRankTemplate = {}
setmetatable(NightFightMeRankTemplate, LuaComponentTemplates.NightFightRankTemplate)

function NightFightMeRankTemplate:Refresh(data, ui)
  self:RunBaseFunction("Refresh", data, ui)
  self:UIControl():SetActive(data ~= nil)
end

function NightFightMeRankTemplate:InitRewardContainer()
  if self.itemContainer == nil and self.btn_giftItem and not IsNil(self.btn_giftItem.transform) then
    self.itemContainer = UIUtility.BindUIContainerTemp(self.btn_giftItem, LuaComponentTemplates.UIItemTemplate, self.parentTbl, {
      isShowTips = true,
      stencil = 3,
      maskType = 5
    })
  end
end

function NightFightMeRankTemplate:IsShowRankIcon()
  return false
end

return NightFightMeRankTemplate
