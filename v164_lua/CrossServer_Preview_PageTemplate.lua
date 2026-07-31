local CrossServer_Preview_PageTemplate = {}

function CrossServer_Preview_PageTemplate:Init(rootUI)
  self:InitControls(rootUI)
  self:BindUIEvent()
end

function CrossServer_Preview_PageTemplate:InitControls(rootUI)
  self.rootUI = rootUI
  self.nowControl = self:GetControl()
  self.Text = self:GetControl("Text")
end

function CrossServer_Preview_PageTemplate:InitContainer()
end

function CrossServer_Preview_PageTemplate:InitData()
  self.state = nil
end

function CrossServer_Preview_PageTemplate:BindUIEvent()
  self:UIControl():SetOnToggleChanged(self, self.ToggleCallBack)
end

function CrossServer_Preview_PageTemplate:ToggleCallBack(control)
  local controlState = control:GetIsOn()
  if self.state ~= controlState then
    self.state = controlState
    local msg = {
      funcId = self.data.id,
      state = controlState
    }
    EventManager.Dispatch(Event.CrossServerPreviewTabStateChange, {
      funcId = self.data.id,
      state = controlState
    })
  end
end

function CrossServer_Preview_PageTemplate:Refresh(data)
  self.data = data
  self.Text:SetText(data.previewName)
end

function CrossServer_Preview_PageTemplate:Exit()
end

function CrossServer_Preview_PageTemplate:GetMiracleBattlePassMgr()
  if gameMgr:GetGlobalActivityDataManager() ~= nil then
    return gameMgr:GetGlobalActivityDataManager():GetActivityManger(ActivityBaseType.CommerceActivity):GetActivityData(CommerceActivityIdType.MiracleBattlePass)
  end
end

return CrossServer_Preview_PageTemplate
