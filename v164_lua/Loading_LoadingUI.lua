Loading_LoadingUI = class(BaseUI)
Loading_LoadingUI.layer = UILayer.Loading
Loading_LoadingUI.orderInLayer = 0
Loading_LoadingUI.hideType = UIHideType.Hide
Loading_LoadingUI.hideFunc = UIHideFunc.MoveOutOfScreen
Loading_LoadingUI.escClose = UIEscClose.DontClose

function Loading_LoadingUI:InitControls()
  self.RawImage_Background = self:GetControl("RawImage_Background")
  self.lab_Message = self:GetControl("lab_Message")
  self.slider_progress = self:GetControl("slider_progress")
  self.Viewport = self:GetControl("slider_progress/Viewport")
end

function Loading_LoadingUI:OnPreLoad()
end

function Loading_LoadingUI:Init()
  self.progress = 0
  self.tempProgress = 0
  local globalInfo = ClientTable.cfg_Global_globalManager:TryGetValue(2250001)
  self.tipKeys = string.split(globalInfo.effect, "&")
end

function Loading_LoadingUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Loading_LoadingUI:InitUI()
  self.sliderWidth, self.sliderHeight = self.Viewport:GetSizeDelta()
  self:Reset()
end

function Loading_LoadingUI:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function Loading_LoadingUI:OnHide()
  self:Reset()
  UIManager.Hide(UIID.WaitingUI)
end

function Loading_LoadingUI:OnDestroy()
end

local Input = CS.UnityEngine.Input
local KeyCode = CS.UnityEngine.KeyCode

function Loading_LoadingUI:Update()
  self:UpdateProgress()
  if Input.GetKeyDown(KeyCode.Tab) and LoginData.isWhite then
    UIManager.Show(UIID.GM_ToolUI)
  end
end

function Loading_LoadingUI:RegistUIEvents()
end

function Loading_LoadingUI:RegistEvents()
end

local resProcess = 0
local step = 0
local minRatio = 0.01
local defaultStep = 5.0E-4
local initProgress = 0.35

function Loading_LoadingUI:Refresh()
  local isLoginLoading = SceneData.textureType == "loading"
  minRatio = isLoginLoading and 0.01 or 0.06
  self.lab_Message:SetActive(isLoginLoading)
  self.slider_progress:SetActive(isLoginLoading)
  self.RawImage_Background:SetTexture(SceneData.texture2D)
  if isLoginLoading then
    UIManager.HideAll({
      UIID.LoadingUI
    })
    self:SetLayer(UILayer.Tooltip)
  else
    self:SetLayer(UILayer.Loading)
  end
  PreLoadManager.StopCatlikeLoad()
  if PreLoadManager.NeedPreLoadOnLoading(SceneData.preMapId) then
    PreLoadManager.LoadingLoad()
  end
end

function Loading_LoadingUI:OnShowTip()
  local progressInt = Time.time
  if progressInt > self.progressInt then
    self.progressInt = progressInt + 5
    local tipIndex = Mathf.Random(1, #self.tipKeys)
    self.lab_Message:SetText(LocalizationUtility.GetContentByKey(self.tipKeys[tipIndex]))
  end
end

function Loading_LoadingUI:SetProgress(progress)
  self.tempProgress = progress
  if self.tempProgress > self.progress then
    step = minRatio
  else
    step = defaultStep
  end
  self.progress = self.progress + step
  if self.slider_progress:GetActive() then
    self.Viewport:SetSizeDelta(self.progress * self.sliderWidth, self.sliderHeight)
    self:OnShowTip()
  end
  if self.progress > 0.999 and SceneData.mapLoaded and 0.99 <= resProcess then
    PreLoadManager.SetPreloadState(true)
    UIManager.Hide(UIID.WaitingUI)
    EventManager.Dispatch(Event.Load_PreLoadEnd)
  end
end

function Loading_LoadingUI:UpdateProgress()
  local radio = SceneData.mapLoaded and 1 or 0.9
  resProcess = PreloadResourceData.totalCount == 0 and 1 or PreloadResourceData.preCount / PreloadResourceData.totalCount
  local progress = radio * resProcess
  progress = math.max(initProgress, progress)
  self:SetProgress(progress)
end

function Loading_LoadingUI:Reset()
  self.Viewport:SetSizeDelta(0, self.sliderHeight)
  self.progress = 0
  self.progressInt = 0
  self.tempProgress = 0
  self.lab_Message:SetText("")
end
