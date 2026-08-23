local CrossServerDesRewardTemplate = {}

function CrossServerDesRewardTemplate:Init(rootPanel)
  self.rootPanel = rootPanel.rootPanel
  self:InitControls()
  self:InitUI()
end

function CrossServerDesRewardTemplate:InitUI()
  self:InitContent()
end

function CrossServerDesRewardTemplate:InitControls()
  self.btn_first = self:GetControl("sw_victoriousLeaderReward/Viewport/Content/btn_first")
  self.this = self:GetControl()
end

function CrossServerDesRewardTemplate:Refresh(data)
  if not data then
    return
  end
  self.this:SetActive(true)
  self.data = data
  self:RefreshRewardShow(data)
end

function CrossServerDesRewardTemplate:RefreshRewardShow()
  self:UIControl():SetText(self.data.rankText)
  self.RewardDataTempate:SetData(self.data.reward)
end

function CrossServerDesRewardTemplate:InitContent()
  self.RewardDataTempate = UIUtility.BindUIContainerTemp(self.btn_first, LuaComponentTemplates.UIItemTemplate, self.rootPanel, {isShowTips = true})
end

return CrossServerDesRewardTemplate
