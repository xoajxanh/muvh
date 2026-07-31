LockScreenUI = class(BaseUI)
LockScreenUI.layer = UILayer.Prompt
LockScreenUI.orderInLayer = 7
LockScreenUI.hideType = UIHideType.WaitDestroy
LockScreenUI.hideFunc = UIHideFunc.MoveOutOfScreen
LockScreenUI.escClose = UIEscClose.DontClose

function LockScreenUI:InitControls()
  self.change_fill = self:GetControl("bg_LockScreenBg/change_fill")
  self.lockTime = self:GetControl("bg_LockScreenBg/lockTime")
end

function LockScreenUI:OnPreLoad()
end

function LockScreenUI:Init()
end

function LockScreenUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function LockScreenUI:InitUI()
end

function LockScreenUI:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function LockScreenUI:OnHide()
  LockScreenState = false
end

function LockScreenUI:OnDestroy()
end

local detailTime = 0.02
local time = 0

function LockScreenUI:Update()
  self.lockTime:SetText(os.date("%X"))
end

function LockScreenUI:RegistUIEvents()
  self.change_fill:SetOnSliderValueChanged(self, self.SliderValueChanged)
  self.change_fill:SetOnPointerDown(self, self.ChangeOnPointerDown)
  self.change_fill:SetOnPointerUp(self, self.ChangeOnPointerUp)
  self.change_fill:SetOnDrag(self, self.SliderOnDrag)
end

function LockScreenUI:SliderOnDrag(control, eventData)
  if not self.isCanOpenLock then
    self.isCanOpenLock = true
  end
end

function LockScreenUI:SliderValueChanged(control, value)
  if value < 7 then
    self.change_fill:SetValue(7)
  end
end

function LockScreenUI:ChangeOnPointerDown(control, eventData)
  self.isCanOpenLock = false
end

function LockScreenUI:ChangeOnPointerUp(control, eventData)
  if self.change_fill:GetValue() < 48 then
    self.change_fill:SetValue(7)
  elseif self.isCanOpenLock then
    self:VoiceSettingRefresh(true)
    self:ModeSettingRefresh(true)
    UIManager.Hide(UIID.LockScreenUI)
  else
    self.change_fill:SetValue(7)
  end
end

function LockScreenUI:RegistEvents()
end

function LockScreenUI:Refresh()
  LockScreenState = true
  self.change_fill:SetValue(7)
  self.lockTime:SetText(os.date("%X"))
  self.settingsDataCache = {}
  self:VoiceSettingRefresh(false)
  self:ModeSettingRefresh(false)
end

function LockScreenUI:VoiceSettingRefresh(isRecover)
  if isRecover then
    AudioManager.SetVolume(AudioGroup.Music, GameSettingsData.musicVolume)
    AudioManager.SetVolume(AudioGroup.Sound, GameSettingsData.soundVolume)
  else
    local value = 0
    AudioManager.SetVolume(AudioGroup.Music, value)
    AudioManager.SetVolume(AudioGroup.Sound, value)
  end
end

function LockScreenUI:ModeSettingRefresh(isRecover)
  if isRecover then
    GameSettingsController.ApplyDisplaySettings(table.clone(self.recoverSettingData))
    GameSettingsController.SetGamingSettings(table.clone(self.recoverSettingData))
    GameSettingsData = table.clone(self.recoverSettingData)
  else
    self.recoverSettingData = table.clone(GameSettingsData)
    local defaultDisplaySettings = C_DefaultGameSettings.PerformanceConfig[EPerformanceQuality.Low]
    GameSettingsController.SetGamingSettings(defaultDisplaySettings)
    GameSettingsController.ApplyDisplaySettings(defaultDisplaySettings)
    GameSettingsController.SetSettings(defaultDisplaySettings)
  end
end
