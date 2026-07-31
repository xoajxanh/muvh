TransferSelectUI = class(BaseUI)
TransferSelectUI.layer = UILayer.Tip
TransferSelectUI.orderInLayer = 7
TransferSelectUI.hideType = UIHideType.WaitDestroy
TransferSelectUI.hideFunc = UIHideFunc.MoveOutOfScreen
TransferSelectUI.escClose = UIEscClose.DontClose

function TransferSelectUI:InitControls()
  self.btn_closeBg = self:GetControl("btn_closeBg")
  self.choCha = self:GetControl("choCha")
  self.occupationTitleLeft = self:GetControl("choCha/content/occupationOne/occupationTitle")
  self.occupationImageLeft = self:GetControl("choCha/content/occupationOne/occupationImage")
  self.attributeLeft = self:GetControl("choCha/content/occupationOne/attributeTips/attribute")
  self.descLeft = self:GetControl("choCha/content/occupationOne/occupationTip/desc")
  self.Onetip1 = self:GetControl("choCha/content/occupationOne/occupationImage/tip1")
  self.Onetip2 = self:GetControl("choCha/content/occupationOne/occupationImage/tip2")
  self.Onetip3 = self:GetControl("choCha/content/occupationOne/occupationImage/tip3")
  self.Onetip4 = self:GetControl("choCha/content/occupationOne/occupationImage/tip4")
  self.Onetip5 = self:GetControl("choCha/content/occupationOne/occupationImage/tip5")
  self.btnYes_Brains = self:GetControl("choCha/content/occupationOne/btnYes_Brains")
  self.occupationTitleRight = self:GetControl("choCha/content/occupationTwo/occupationTitle")
  self.occupationImageRight = self:GetControl("choCha/content/occupationTwo/occupationImage")
  self.attributeRight = self:GetControl("choCha/content/occupationTwo/attributeTips/attribute")
  self.descRight = self:GetControl("choCha/content/occupationTwo/occupationTip/desc")
  self.twotip1 = self:GetControl("choCha/content/occupationTwo/occupationImage/tip1")
  self.twotip2 = self:GetControl("choCha/content/occupationTwo/occupationImage/tip2")
  self.twotip3 = self:GetControl("choCha/content/occupationTwo/occupationImage/tip3")
  self.twotip4 = self:GetControl("choCha/content/occupationTwo/occupationImage/tip4")
  self.twotip5 = self:GetControl("choCha/content/occupationTwo/occupationImage/tip5")
  self.btnYes_Agility = self:GetControl("choCha/content/occupationTwo/btnYes_Agility")
  self.plane_top = self:GetControl("plane_top")
end

function TransferSelectUI:OnPreLoad()
end

function TransferSelectUI:Init()
end

function TransferSelectUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function TransferSelectUI:InitUI()
end

function TransferSelectUI:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function TransferSelectUI:OnHide()
end

function TransferSelectUI:OnDestroy()
end

function TransferSelectUI:RegistUIEvents()
  self.btn_closeBg:SetOnClick(self, self.btn_closeBgOnClick)
  self.btnYes_Brains:SetOnClick(self, self.btnYes_BrainsOnClick)
  self.btnYes_Agility:SetOnClick(self, self.btnYes_AgilityOnClick)
end

function TransferSelectUI:btn_closeBgOnClick(control)
  UIManager.Hide(UIID.TransferSelectUI)
end

function TransferSelectUI:btnYes_BrainsOnClick(control)
  EventManager.Dispatch(Event.Select_AgilityArcher)
  self:btn_closeBgOnClick()
end

function TransferSelectUI:btnYes_AgilityOnClick(control)
  EventManager.Dispatch(Event.Select_BrainsArcher)
  self:btn_closeBgOnClick()
end

function TransferSelectUI:RegistEvents()
end

function TransferSelectUI:Refresh()
  local Selectleft = self:SetSpriteSelec(2500014)
  if Selectleft ~= nil then
    self:SetSprite("Atlas_Language", Selectleft[1], self.occupationTitleLeft)
    self:SetSprite("Atlas_Common", Selectleft[2], self.occupationImageLeft)
    self.attributeLeft:SetText(Selectleft[3])
    self.descLeft:SetText(Selectleft[4])
    self.Onetip1:SetText(Selectleft[5])
    self.Onetip2:SetText(Selectleft[6])
    self.Onetip3:SetText(Selectleft[7])
    self.Onetip4:SetText(Selectleft[8])
    self.Onetip5:SetText(Selectleft[9])
  end
  local SelectRight = self:SetSpriteSelec(2500015)
  if SelectRight ~= nil then
    self:SetSprite("Atlas_Language", SelectRight[1], self.occupationTitleRight)
    self:SetSprite("Atlas_Common", SelectRight[2], self.occupationImageRight)
    self.attributeRight:SetText(SelectRight[3])
    self.descRight:SetText(SelectRight[4])
    self.twotip1:SetText(SelectRight[5])
    self.twotip2:SetText(SelectRight[6])
    self.twotip3:SetText(SelectRight[7])
    self.twotip4:SetText(SelectRight[8])
    self.twotip5:SetText(SelectRight[9])
  end
end

function TransferSelectUI:SetSpriteSelec(id)
  local Select
  self.Select = ClientTable.cfg_Global_globalManager:TryGetValue(id).effect
  local Selecttable = string.split(self.Select, "|")
  for i, v in ipairs(Selecttable) do
    local globaltable = ClientTable.cfg_Global_globalManager:TryGetValue(tonumber(v)).effect
    if globaltable == nil then
      logError("cfg_Global_global:" .. tonumber(v) .. "L\225\187\151i ID n\225\187\153i dung!")
      return
    end
    local Selecttablecareer = string.split(globaltable, "&")
    if Selecttablecareer and tonumber(Selecttablecareer[1] % 10) == ViewData.meData.career % 10 then
      Select = string.split(Selecttablecareer[2], "#")
      return Select
    end
  end
  return Select
end
