local Instance_KalimaCastlePageTemplate = {}

function Instance_KalimaCastlePageTemplate:Init(data)
  self.goCallBack = data.goCallBack
  self.normalBg = data.normalBg
  self:InitParams()
  self:InitControls()
  self:BindUIEvent()
end

function Instance_KalimaCastlePageTemplate:InitParams()
  self.parentTbl = nil
  self.duplicateId = nil
  self.CenterModel = ItemCellData()
end

function Instance_KalimaCastlePageTemplate:InitControls()
  self.lab_instancename = self:GetControl("lab_instancename")
  self.btn_Tog3DItem = self:GetControl("btn_Tog3DItem")
  self.img_target = self:GetControl("img_target")
  self.img_click_putong = self:GetControl("img_click_putong")
end

function Instance_KalimaCastlePageTemplate:BindUIEvent()
  self.img_target:SetOnClick(self, self.ClickGoCallBack)
end

function Instance_KalimaCastlePageTemplate:ClickGoCallBack()
  if self.data ~= nil and self.goCallBack then
    self.goCallBack(self)
  end
end

function Instance_KalimaCastlePageTemplate:Refresh(data, ui)
  self.parentTbl = ui
  self.data = data
  self.duplicateId = data and data.instanceTbl and data.instanceTbl.mapId or nil
  self:RefreshView()
end

function Instance_KalimaCastlePageTemplate:RefreshView()
  if self.data == nil or self.data.instanceTbl == nil then
    return
  end
  self.lab_instancename:SetText(self.data.instanceTbl.name)
  self:RefreshBgView(self.normalBg)
  if self.CenterModel then
    self.CenterModel:RecycleRes()
  end
  local itemData = ItemUtility.GenerateItemData(self.data.instanceTbl.unique)
  self.CenterModel:RefreshData(itemData)
  ItemUtility.ShowItemCell(self.btn_Tog3DItem, self.CenterModel, self.parentTbl, true)
end

function Instance_KalimaCastlePageTemplate:RefreshBgView(bgName, ui)
  if self.img_target.image.sprite and self.img_target.image.sprite.name == bgName then
    return
  end
  self.parentTbl = self.parentTbl == nil and ui or self.parentTbl
  if self.parentTbl then
    self.parentTbl:SetSprite("Atlas_Common", bgName, self.img_target, false)
    self.parentTbl:SetSprite("Atlas_Common", bgName .. "se", self.img_click_putong, false)
  end
end

function Instance_KalimaCastlePageTemplate:RefresPageEffectView(targetId)
  if self.img_click_putong == nil then
    return
  end
  self.img_click_putong:SetActive(targetId == self.duplicateId)
end

return Instance_KalimaCastlePageTemplate
