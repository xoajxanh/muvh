local HeadTemplate = {}
HeadTemplate.CampPlayerInfo = nil
HeadTemplate.IsChoose = nil
HeadTemplate._baseUI = nil
HeadTemplate._reviveDesFormat = "%d gi\195\162y "

function HeadTemplate:Init()
  self:InitComponent()
  self:BindEvent()
end

function HeadTemplate:InitComponent()
  self.enemyName = self:GetControl("enemyName")
  self.headImg = self:GetControl("headBg/headImg")
  self.img_chosen = self:GetControl("headBg/img_chosen")
  self.headBg = self:GetControl("headBg")
  self.img_dead = self:GetControl("headBg/img_dead")
  self.count_rebirth = self:GetControl("headBg/count_rebirth")
  self.txt_away = self:GetControl("headBg/txt_away")
  self.img_offline = self:GetControl("headBg/img_offline")
  self.txt_offline = self:GetControl("headBg/txt_offline")
end

function HeadTemplate:BindEvent()
  self:UIControl():SetOnToggleChanged(self, self.HeadOnClick)
end

function HeadTemplate:HeadOnClick(control, isOn)
  self.IsChoose = isOn
  if ThreeVsThreeUtility.IsFilterChoose() then
    return
  end
  local PlayerCampPosition = QuickFind:GetThreeVsThreeDataMgr():GetPlayerCampPositionInfo(self.CampPlayerInfo:GetId())
  if isOn and PlayerCampPosition then
    local player = RoleManager.GetRoleById(self.CampPlayerInfo:GetId())
    if player then
      RoleManager.me:SetTarget(player)
      ThreeVsThreeUtility.SetChooseEnemyLid(self.CampPlayerInfo:GetId(), true)
    end
  else
    ThreeVsThreeUtility.SetChooseEnemyLid(nil)
    RoleManager.me:SetTarget(nil)
  end
end

function HeadTemplate:Refresh(data, baseUI)
  if not data then
    return
  end
  self:GetControl():SetActive(true)
  self.CampPlayerInfo = data
  self._baseUI = baseUI
  self:RefreshHead()
  self:RefreshName()
  self:RefreshState()
  self:RefreshChoose()
end

function HeadTemplate:RefreshSimple(data)
  self.CampPlayerInfo = data
  self:RefreshState()
  self:RefreshChoose()
end

function HeadTemplate:RefreshHead()
  local career = RoleUtility.GetBasicCareer(self.CampPlayerInfo:GetCareer())
  self._baseUI:SetSprite("Atlas_headPortrait", career, self.headImg)
end

function HeadTemplate:RefreshName()
  self.enemyName:SetText(self.CampPlayerInfo:GetName())
end

function HeadTemplate:RefreshState()
  local state = self.CampPlayerInfo:GetState()
  local PlayerCampPosition = QuickFind:GetThreeVsThreeDataMgr():GetPlayerCampPositionInfo(self.CampPlayerInfo:GetId())
  self.img_offline:SetActive(state == EThreeVSThreePlayerState.OffLine)
  self.txt_offline:SetActive(state == EThreeVSThreePlayerState.OffLine)
  self.img_dead:SetActive(state == EThreeVSThreePlayerState.Die)
  self.count_rebirth:SetActive(state == EThreeVSThreePlayerState.Die)
  local handImage = self.CampPlayerInfo._serverData.groupType == 1 and "3V3HeadBg01" or "3V3HeadBg02"
  self._baseUI:SetSprite("Atlas_Common", handImage, self.headBg)
  self.txt_away:SetActive(not PlayerCampPosition)
  if self.IsChoose and state ~= EThreeVSThreePlayerState.ALive then
    ThreeVsThreeUtility.SetChooseEnemyLid(nil, true)
  end
  self:UIControl():SetInteractable(state == EThreeVSThreePlayerState.ALive)
end

function HeadTemplate:RefreshChoose()
  if self.IsChoose ~= ThreeVsThreeUtility.IsChooseLid(self.CampPlayerInfo:GetId()) then
    self:SetIsChoose(ThreeVsThreeUtility.GetChooseEnemyLid() == self.CampPlayerInfo:GetId())
  end
end

function HeadTemplate:SetIsChoose(choose)
  self:UIControl():SetIsOn(choose)
end

function HeadTemplate:Update()
  if self.CampPlayerInfo == nil then
    return
  end
  local PlayerCampPosition = QuickFind:GetThreeVsThreeDataMgr():GetPlayerCampPositionInfo(self.CampPlayerInfo:GetId())
  self.txt_away:SetActive(not PlayerCampPosition)
  if self.CampPlayerInfo:GetState() ~= EThreeVSThreePlayerState.Die then
    return
  else
    self.count_rebirth:SetText(string.format(self._reviveDesFormat, self.CampPlayerInfo:GetReviveRemainTime()))
  end
end

return HeadTemplate
