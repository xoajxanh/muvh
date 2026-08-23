GraveHead3DMesh = class()

function GraveHead3DMesh:ctor(grave, data)
  self:RefreshData(grave, data)
end

function GraveHead3DMesh:RefreshData(grave, data)
  self.grave = grave
  self.data = data
  self:ShowHead()
end

function GraveHead3DMesh:Update()
end

function GraveHead3DMesh:ShowHead()
  self:Destroy()
  if TranScriptData.InTranscriptData and TranScriptData.InTranscriptData.type == TranScriptType.PersonKaLiMa then
    return
  end
  local offsetY = 0.5
  if self.trans == nil then
    self.gameObj = CS.Framework.ResourceManager.Instantiate("HUD/toplogoGrave.prefab", Vector3(0, offsetY, 0), HUDSetting.Rotation, self.grave.transform)
    self.trans = self.gameObj.transform
    self.trans.localPosition = Vector3(0, offsetY, 0)
    self.trans.localRotation = CS.UnityEngine.Quaternion.Euler(HUDSettingRotationXYZ.X, HUDSettingRotationXYZ.Y - self.data.rotateY, HUDSettingRotationXYZ.Z)
  end
  if self.nameLabel == nil then
    self.nameLabel = self.trans:Find("Label", typeof(CS.CSLabel))
  end
  self.gameObj:SetActive(true)
  self:SetCountdown()
end

function GraveHead3DMesh:SetCountdown()
  local timeCounter = math.floor((self.data.reliveTime - Time.GetServerTime()) / 1000)
  if timeCounter <= 0 then
    return
  end
  self:RefreshCountDown(timeCounter)
  self.countDownTimer = Timer.StartLoop(1, timeCounter, function()
    timeCounter = timeCounter - 1
    self:RefreshCountDown(timeCounter)
  end)
end

function GraveHead3DMesh:RefreshCountDown(timeCounter)
  local minutes = Mathf.Floor(timeCounter / 60)
  local seconds = Mathf.Floor(timeCounter % 60)
  local lab_time = string.format("%02d: %02d", minutes, seconds)
  local fontColorTab = Color.red
  if self.nameLabel ~= nil then
    self.nameLabel.text = lab_time
    self.nameLabel.color = fontColorTab
  end
end

function GraveHead3DMesh:Destroy()
  if self.gameObj ~= nil then
    if self.nameLabel ~= nil then
      self.nameLabel.rightIndex = 0
    end
    CS.Framework.ResourceManager.Recycle(self.gameObj)
    self.gameObj = nil
    self.trans = nil
    self.nameLabel = nil
  end
  if self.countDownTimer then
    Timer.Stop(self.countDownTimer)
  end
  self.mTitle = nil
end
