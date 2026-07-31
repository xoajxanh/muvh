Activity_SiegeProgressUI = class(BaseUI)
Activity_SiegeProgressUI.layer = UILayer.Dialog
Activity_SiegeProgressUI.orderInLayer = 1
Activity_SiegeProgressUI.hideType = UIHideType.WaitDestroy
Activity_SiegeProgressUI.hideFunc = UIHideFunc.MoveOutOfScreen
Activity_SiegeProgressUI.escClose = UIEscClose.DontClose

function Activity_SiegeProgressUI:InitControls()
  self.lab_warAlliancName = self:GetControl("img_Bg/lab_warAlliancName")
  self.lab_progress = self:GetControl("img_Bg/sl_hp/lab_progress")
  self.sl_hp = self:GetControl("img_Bg/sl_hp")
end

function Activity_SiegeProgressUI:OnPreLoad()
end

function Activity_SiegeProgressUI:Init()
end

function Activity_SiegeProgressUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Activity_SiegeProgressUI:InitUI()
end

function Activity_SiegeProgressUI:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function Activity_SiegeProgressUI:OnHide()
  if self.processAnim then
    Coroutine.Stop(self.processAnim)
    self.processAnim = nil
  end
end

function Activity_SiegeProgressUI:OnDestroy()
end

function Activity_SiegeProgressUI:RegistUIEvents()
end

function Activity_SiegeProgressUI:RegistEvents()
  self:RegistEvent(Event.RefreshSiegeProcess, self.Refresh, self)
end

function Activity_SiegeProgressUI:Refresh()
  local occlusionUnion = Activity_LuoLanSiegeData.GetCurOccupationUnion()
  self.lab_warAlliancName:SetText("<color=#279C3B>" .. occlusionUnion.name .. "</color>" .. "\196\144ang chi\225\186\191m")
  local totalTime = tonumber(ClientTable.cfg_Activity_globalManager:TryGetValue(100355).effect)
  if Activity_LuoLanSiegeData.holdUnionId == Activity_LuoLanSiegeData.curHaveUnionId and Activity_LuoLanSiegeData.holdUnionId ~= 0 then
    self.lab_progress:SetText(Mathf.Floor(totalTime / 1000) .. "/" .. Mathf.Floor(totalTime / 1000))
    self.lab_warAlliancName:SetText("<color=#279C3B>" .. occlusionUnion.name .. "</color>" .. "\196\144\195\163 chi\225\186\191m")
    self.sl_hp:SetValue(1)
  else
    local occTime = Activity_LuoLanSiegeData.siegeData.holdTime[occlusionUnion.unionId]
    self.sl_hp:SetValue(occTime / totalTime)
    self.lab_progress:SetText(Mathf.Floor(occTime / 1000) .. "/" .. Mathf.Floor(totalTime / 1000))
    
    local function UpdateProcess()
      while true do
        occTime = occTime + Time.deltaTime * 1000
        self.sl_hp:SetValue(occTime / totalTime)
        self.lab_progress:SetText(Mathf.Floor(occTime / 1000) .. "/" .. Mathf.Floor(totalTime / 1000))
        if occTime >= totalTime then
          self.sl_hp:SetValue(1)
          self.lab_progress:SetText(Mathf.Floor(totalTime / 1000) .. "/" .. Mathf.Floor(totalTime / 1000))
          self.lab_warAlliancName:SetText("<color=#279C3B>" .. occlusionUnion.name .. "</color>" .. "\196\144\195\163 chi\225\186\191m")
          Coroutine.Break()
        end
        Coroutine.WaitForEndOfFrame()
      end
    end
    
    if self.processAnim then
      Coroutine.Stop(self.processAnim)
    end
    self.processAnim = Coroutine.Start(UpdateProcess)
  end
end
