local CrystalNucleusBagItemTemplate = {}

function CrystalNucleusBagItemTemplate:Init()
  self:InitControls()
end

function CrystalNucleusBagItemTemplate:InitControls()
  self.ima_Icon = self:GetControl("ima_Icon")
  self.dragHide = self:GetControl("dragHide")
  self.img_QualityIcon = self:GetControl("dragHide/grid_qualityIcon")
  self.lab_Strengthen = self:GetControl("dragHide/lab_strengthen")
  self.img_Select = self:GetControl("dragHide/img_select")
  self.img_isEquip = self:GetControl("dragHide/img_isEquip")
  self.this = self:GetControl()
end

function CrystalNucleusBagItemTemplate:OnDragStart(_eventData)
  self.ima_Icon.transform:SetParent(self.rootUI.DragParent.transform, false)
  self.dragHide:SetActive(false)
  self:ResetHitData()
end

function CrystalNucleusBagItemTemplate:OnUpdateDrag(_eventData)
  local hitObj = CS.Framework.PhysicsEx.MouseRaycast(UIManager.uiCamera)
  if hitObj == nil then
    self:ResetHitData()
    return
  end
  if hitObj and hitObj.name and string.contains(hitObj.name, "crystalNucleus") then
    local nameTab = string.split(hitObj.name, "_")
    if nameTab == nil then
      self:ResetHitData()
      return
    end
    local hitPoint = CrystalNucleusManager:GetPedestalPointByIndex(tonumber(nameTab[2]))
    if hitPoint == nil then
      self:ResetHitData()
      return
    end
    self.putIn, self.hitPointList = CrystalNucleusManager:CheckPutIn(hitPoint, self.data.m_ItemConfig.shapPosition)
    EventManager.Dispatch(Event.CrystalNucleusHitResultRefresh, self.hitPointList)
  else
    self:ResetHitData()
    return
  end
end

function CrystalNucleusBagItemTemplate:OnDragEnd(_eventData)
  if self.putIn and table.count(self.hitPointList) > 0 then
    CrystalNucleusPointController.ReqPutOnNucleus(self.hitPointList[1].m_Row, self.hitPointList[1].m_Column, self.data.m_ServerInfo.id)
  end
  self.dragHide:SetActive(true)
  self:ResetPosition()
  self:ResetHitData()
  EventManager.Dispatch(Event.CrystalNucleusHitResultReset)
end

function CrystalNucleusBagItemTemplate:Refresh(_data, _ui)
  if _data == nil or _ui == nil then
    return
  end
  self.data = _data
  self.rootUI = _ui
  self.this:SetActive(true)
  self:ResetView()
  self:RefreshIcon()
  self:RefreshQuality()
  self:RefreshStrengthen()
  self:RefreshIsEquip()
end

function CrystalNucleusBagItemTemplate:RefreshIcon()
  local scale = self.data.m_ItemConfig.pngSize / 100
  self.ima_Icon:SetScale(Vector3(scale, scale, scale))
  self.iconCoroutine = self.rootUI:SetSprite("Atlas_Common", self.data.m_ItemConfig.icon, self.ima_Icon, true)
end

function CrystalNucleusBagItemTemplate:RefreshQuality()
  local quality = self.data.m_ItemConfig.quality
  local globalEffect = GlobalConfig.GetGlobalConfig(64000004)
  if string.isNullOrEmpty(globalEffect) then
    return
  end
  local tab = string.split(globalEffect, "&")
  for i, v in pairs(tab) do
    local iconTab = string.split(v, "#")
    if iconTab and tonumber(iconTab[1]) == quality then
      self.qualityIconCoroutine = self.rootUI:SetSprite("Atlas_Common", iconTab[2], self.img_QualityIcon, true)
      return
    end
  end
end

function CrystalNucleusBagItemTemplate:RefreshStrengthen()
  self.lab_Strengthen:SetActive(self.data.m_ServerInfo.nucleusLevel > 0)
  self.lab_Strengthen:SetText(string.format("+%s", self.data.m_ServerInfo.nucleusLevel))
end

function CrystalNucleusBagItemTemplate:RefreshIsEquip()
  if not UIManager.IsVisibleOrCorrelation(UIID.Puzzle_JH_QianghuaUI, self) then
    return
  end
  self.img_isEquip:SetActive(CrystalNucleusManager:CheckIsPutOnEquipById(self.data.m_ServerInfo.id))
end

function CrystalNucleusBagItemTemplate:ResetView()
  self.dragHide:SetActive(true)
  self.ima_Icon:SetActive(false)
  self.lab_Strengthen:SetActive(false)
  self.img_Select:SetActive(false)
  self.img_isEquip:SetActive(false)
end

function CrystalNucleusBagItemTemplate:ResetPosition()
  self.ima_Icon.transform:SetParent(self.this.transform, false)
  self.ima_Icon.rectTransform.position = self.this.rectTransform.position
end

function CrystalNucleusBagItemTemplate:ResetHitData()
  self.putIn = false
  self.hitPointList = nil
end

function CrystalNucleusBagItemTemplate:Recycle()
  if self.iconCoroutine then
    Coroutine.Stop(self.iconCoroutine)
    self.iconCoroutine = nil
  end
  if self.qualityIconCoroutine then
    Coroutine.Stop(self.qualityIconCoroutine)
    self.qualityIconCoroutine = nil
  end
  self.data = nil
  self.rootUI = nil
  self:ResetView()
  self:ResetHitData()
  self:ResetPosition()
  self.this:SetActive(false)
end

function CrystalNucleusBagItemTemplate:SetSelectState(_state)
  if _state == nil then
    return
  end
  self.img_Select:SetActive(_state)
end

return CrystalNucleusBagItemTemplate
