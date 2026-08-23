GraveHead = class()

function GraveHead:ctor(grave, data)
  self:RefreshData(grave, data)
end

function GraveHead:RefreshData(grave, data)
  self.grave = grave
  self.data = data
  self:ShowHead()
end

function GraveHead:Update()
end

function GraveHead:ShowHead()
  self:Destroy()
  if self.mTitleIns == nil then
    local offsetY = 0.5
    self.mTitleIns = CS.Framework.HUDTitleInfo.HUDTitleRender.Instance:RegisterTitle(self.grave.transform, offsetY, false)
  end
  self.mTitle = CS.Framework.HUDTitleInfo.HUDTitleRender.Instance:GetTitle(self.mTitleIns)
  if self.mTitle ~= nil then
    self.mTitle:ShowTitle(true)
    self:SetCountdown()
  end
end

function GraveHead:SetCountdown()
  local timeCounter = math.floor((self.data.reliveTime - Time.GetServerTime()) / 1000)
  if timeCounter <= 0 then
    return
  end
  self.countDownTimer = Timer.StartLoop(1, timeCounter, function()
    timeCounter = timeCounter - 1
    local minutes = Mathf.Floor(timeCounter / 60)
    local seconds = Mathf.Floor(timeCounter % 60)
    local lab_time = string.format("%02d: %02d", minutes, seconds)
    self.mTitle:Clear()
    self.mTitle:BeginTitle()
    local fontColorTab = ColorUtility.ColorToColor32(Color.red)
    self.titleIndex = self.mTitle:PushCustomColorTitle(lab_time, HUDTitleStyle.PlayerName, fontColorTab, 0)
    self.mTitle:EndTitle()
  end)
end

function GraveHead:Destroy()
  if self.countDownTimer then
    Timer.Stop(self.countDownTimer)
  end
  if self.mTitleIns then
    CS.Framework.HUDTitleInfo.HUDTitleRender.Instance:ReleaseTitle(self.mTitleIns)
    self.mTitleIns = nil
  end
  self.mTitle = nil
end
