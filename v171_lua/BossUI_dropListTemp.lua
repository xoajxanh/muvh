local BossUI_dropListTemp = {}

function BossUI_dropListTemp:Init(data)
  if data then
    self.baseUI = data.baseUI
  end
  self.des = self:GetControl("des")
  self.btn_wild3DItem = self:GetControl("awardScroll/Viewport/wildBossContent/btn_wild3DItem")
  self.btn_wild3DItemList = UIUtility.BindUIContainerTemp(self.btn_wild3DItem, LuaComponentTemplates.BossUI_dropItemTemp, self.baseUI)
end

function BossUI_dropListTemp:Refresh(data)
  if data == nil then
    return
  end
  self.des:SetText(data.title)
  self.btn_wild3DItemList:SetData(data.tabReward)
end

return BossUI_dropListTemp
