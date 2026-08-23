local ExperienceBonusViewUnitTemplate = {}

function ExperienceBonusViewUnitTemplate:GetExperienceBonusMgr()
  if gameMgr:GetAvatarManager() and gameMgr:GetAvatarManager():GetMainPlayer() then
    return gameMgr:GetAvatarManager():GetMainPlayer():GetExperienceBonusMgr()
  end
end

function ExperienceBonusViewUnitTemplate:GetMemberDataMgr()
  if gameMgr:GetAvatarManager() and gameMgr:GetAvatarManager():GetMainPlayer() then
    return gameMgr:GetAvatarManager():GetMainPlayer():GetMemberDataMgr()
  end
end

function ExperienceBonusViewUnitTemplate:Init()
  self:InitParams()
  self:InitControls()
  self:BindUIEvent()
end

function ExperienceBonusViewUnitTemplate:InitParams()
  self.experienceBounsData = nil
  self.expBonusTimer = nil
  self.colorTbl = {
    [true] = "#1ADD1F",
    [false] = "#999999"
  }
end

function ExperienceBonusViewUnitTemplate:InitControls()
  self.img_expUpOrangeBg = self:GetControl("img_expUpOrangeBg")
  self.lab_expUpSource = self:GetControl("lab_expUpSource")
  self.lab_expUpValue = self:GetControl("lab_expUpSource/lab_expUpValue")
  self.lab_timeUpValue = self:GetControl("lab_expUpSource/lab_timeUpValue")
  self.btn_plus = self:GetControl("btn_plus")
end

function ExperienceBonusViewUnitTemplate:BindUIEvent()
  self:UIControl():SetOnClick(self, self.ClickAddCallBack)
end

function ExperienceBonusViewUnitTemplate:ClickAddCallBack()
  if self.btn_plus == nil or IsNil(self.btn_plus.gameObject) or not self.btn_plus.gameObject.activeSelf then
    return
  end
  if self.experienceBounsData and self.experienceBounsData.behaviour then
    local navTbl = ClientTable.cfg_Navigation_barManager:TryGetValue(tonumber(self.experienceBounsData.behaviour))
    if GradData.GoToNavi(navTbl) then
      NavigationUtility.OpenPanel(navTbl)
    end
  end
end

function ExperienceBonusViewUnitTemplate:Refresh(data, ui)
  self.id = data
  self.experienceBounsData = self:GetExperienceBonusMgr():GetExperienceBonusData(self.id)
  self:RefreshView()
end

function ExperienceBonusViewUnitTemplate:RefreshView()
  if self.experienceBounsData == nil then
    return
  end
  if self.experienceBounsData.id == ExperienceAdditionIdEnum.VipMapAddition then
    local isVipMap = ClientTable.cfg_Map_mapManager:IsVipMap(SceneData.mapId)
    self.lab_expUpSource:SetText(string.GetColorText(self.experienceBounsData.str, self.colorTbl[isVipMap]))
    self.lab_expUpValue:SetText(string.GetColorText(self.experienceBounsData.value .. "%", self.colorTbl[isVipMap]))
  else
    self.lab_expUpSource:SetText(string.GetColorText(self.experienceBounsData.str, self.colorTbl[self.experienceBounsData.value > 0]))
    self.lab_expUpValue:SetText(string.GetColorText(self.experienceBounsData.value .. "%", self.colorTbl[self.experienceBounsData.value > 0]))
  end
  self.img_expUpOrangeBg:SetActive(self.experienceBounsData.value > 0)
  self:RefreshTimeView()
  self:RefreshAddBtnView()
end

function ExperienceBonusViewUnitTemplate:RefreshTimeView()
  self:RemoveTimer()
  if self.experienceBounsData.endTime ~= nil then
    self.time = TimeUtility.RefreshSec(self.experienceBounsData.endTime / 1000)
    if self.time ~= 0 then
      self.expBonusTimer = Timer.StartLoopForever(1, self.UpdataTime, self)
      return
    end
  end
  self.lab_timeUpValue:SetText("")
end

function ExperienceBonusViewUnitTemplate:RefreshAddBtnView()
  local state = false
  if self.experienceBounsData.addShowType == ExperienceBonusAddTypeEnum.Vip then
    state = not self:GetMemberDataMgr() or not self:GetMemberDataMgr():CheckMax()
  elseif self.experienceBounsData.addShowType == ExperienceBonusAddTypeEnum.Time then
    state = self.time <= 0
  elseif self.experienceBounsData.addShowType == ExperienceBonusAddTypeEnum.AlwaysShow then
    state = true
  end
  self.btn_plus:SetActive(state)
end

function ExperienceBonusViewUnitTemplate:UpdataTime()
  if self.time ~= nil and self.time >= 0 then
    self.time = self.time - 1
    local secs = math.floor(self.time / 60)
    self.lab_timeUpValue:SetText(string.GetColorText(secs .. " m", self.colorTbl[true]))
  else
    self:RemoveTimer()
    self:TimeEndCallBack()
    self.lab_timeUpValue:SetText("")
  end
end

function ExperienceBonusViewUnitTemplate:RemoveTimer()
  if self.expBonusTimer then
    Timer.Stop(self.expBonusTimer)
    self.expBonusTimer = nil
  end
end

function ExperienceBonusViewUnitTemplate:TimeEndCallBack()
  if self.experienceBounsData.addShowType == ExperienceBonusAddTypeEnum.Time then
    self:RefreshAddBtnView()
  end
end

function ExperienceBonusViewUnitTemplate:OnDestruct()
  self:RemoveTimer()
end

return ExperienceBonusViewUnitTemplate
