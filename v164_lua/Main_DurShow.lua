Main_DurShow = class(BaseUI)
Main_DurShow.layer = UILayer.Background
Main_DurShow.orderInLayer = 0
Main_DurShow.hideType = UIHideType.WaitDestroy
Main_DurShow.hideFunc = UIHideFunc.MoveOutOfScreen
Main_DurShow.escClose = UIEscClose.DontClose

function Main_DurShow:InitControls()
  self.go_dur = self:GetControl("go_dur")
  self.img_icon = self:GetControl("go_dur/img_icon")
  self.go_progress = self:GetControl("go_dur/go_progress")
  self.img_ground = self:GetControl("go_dur/go_progress/img_ground")
end

function Main_DurShow:OnPreLoad()
end

function Main_DurShow:Init()
  self.showData = nil
end

function Main_DurShow:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Main_DurShow:InitUI()
end

function Main_DurShow:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function Main_DurShow:OnHide()
  self.showData = nil
end

function Main_DurShow:OnDestroy()
end

function Main_DurShow:RegistUIEvents()
end

function Main_DurShow:RegistEvents()
  self:RegistEvent(Event.Dur_Show, self.showDur, self)
  self:RegistEvent(Event.Dur_Update, self.UpdateDur, self)
end

function Main_DurShow:showDur(_, data)
  if data.isShow then
    self.showData = ViewData.meData.equipsData:GetEquipByIndex(ERoleEquipPosition.pet)
  else
    self.showData = nil
  end
  self:DoShowDur()
end

function Main_DurShow:UpdateDur(_)
  if self.showData then
    self:DoSetProgress(self.showData)
  end
end

function Main_DurShow:DoShowDur()
  if self.showData then
    self:SetSprite("Atlas_Icon", tostring(self.showData.tblItem.icon), self.img_icon)
    self:DoSetProgress(self.showData)
  else
    self.img_icon:SetActive(false)
  end
  self.go_dur:SetActive(self.showData ~= nil)
end

function Main_DurShow:DoSetProgress(itemData)
  local totalDurability = itemData.tblEquip.durability
  local curDurability = Mathf.Floor(itemData.durability)
  local progress = curDurability / totalDurability
  self.img_ground:SetFillAmount(progress)
end

function Main_DurShow:Refresh()
  self.showData = ViewData.meData.equipsData:GetEquipByIndex(ERoleEquipPosition.pet)
  self:DoShowDur()
end
