local ConnectionGiftUITemp = {}

function ConnectionGiftUITemp:Init(data)
  self.root = data.root
  self.Tip_taskPanel = data.Tip_taskPanel
  self.Btn_ConnectionTask = data.Btn_ConnectionTask
  self.itemShow = data.itemShow
  self.AllTaskRewardShow = data.AllTaskRewardShow
  self:InitControls()
  self:BindEvents()
  self.root.Tip_taskPanelTemp = luaTemplateManager.GetNewTemplate(self.Tip_taskPanel, LuaComponentTemplates.Tip_taskPanelTemp, self, {
    Tip_taskPanel = self.root.Tip_taskPanel,
    root = self.root,
    itemShow = self.itemShow,
    AllTaskRewardShow = self.AllTaskRewardShow
  })
end

function ConnectionGiftUITemp:InitControls()
  self.taskLab_name = self:GetControl("lab_name")
  self.checkLab_name = self:GetControl("Check/lab_name")
  self.Check = self:GetControl("Check")
end

function ConnectionGiftUITemp:BindEvents()
  self.Btn_ConnectionTask:SetOnClick(self, self.StrengthenBtnOnClick)
  self:UIControl():SetOnClick(self, function()
    self:StrengthenBtnOnClick()
  end)
end

function ConnectionGiftUITemp:StrengthenBtnOnClick()
  self.Tip_taskPanel:SetActive(true)
  self.itemShow:SetActive(false)
  self.AllTaskRewardShow:SetActive(false)
  self.root.Tip_taskPanelTemp:Refresh()
end

function ConnectionGiftUITemp:Refresh(data)
  self.data = data
  if not self.data then
    return
  end
  self:RefreshItemData(self.data)
end

function ConnectionGiftUITemp:RefreshItemData(data)
  self.Check:SetActive(false)
  if data then
    local taskGoal = ClientTable.cfg_Task_goalManager:TryGetValue(tonumber(data.task), "goalId")
    self.taskLab_name:SetText(data.taskShowParameter)
    self.checkLab_name:SetText(taskGoal.goalTips)
    if data.isBol then
      self.Check:SetActive(data.isBol)
    end
  end
end

return ConnectionGiftUITemp
