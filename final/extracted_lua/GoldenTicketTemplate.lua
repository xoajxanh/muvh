local GoldenTicketTemplate = {}

function GoldenTicketTemplate:Init(data)
  self:InitControls()
  self:InitTemplates()
  self:InitUIEvents()
end

function GoldenTicketTemplate:InitControls()
  self.btn_receiveTicket = self:GetControl("btn_receiveTicket")
  self.Eff_UI_annuikuang03 = self:GetControl("btn_receiveTicket/Eff_UI_annuikuang03")
  self.img_get = self:GetControl("btn_receiveTicket/img_get")
  self.img_get_grey = self:GetControl("btn_receiveTicket/img_get_grey")
  self.img_bg_grey = self:GetControl("img_bg_grey")
  self.img_received = self:GetControl("btn_receiveTicket/img_received")
  self.lab_title = self:GetControl("lab_title")
  self.btn_Item = self:GetControl("btn_Item")
end

function GoldenTicketTemplate:InitTemplates()
  self.rewardItemTemplate = UIUtility.BindUIContainerTemp(self.btn_Item, LuaComponentTemplates.UIItemTemplate, self.root, {
    isShowTips = true,
    stencil = 2,
    maskType = 5
  })
end

function GoldenTicketTemplate:InitUIEvents()
  self.btn_receiveTicket:SetOnClick(self, self.Btn_receiveTicketClick)
end

function GoldenTicketTemplate:Btn_receiveTicketClick()
  self:InitBaseUIState()
  self.img_get_grey:SetActive(false)
  self.img_received:SetActive(true)
  networkRequest.ReqSubmitTask(self.data.taskId)
end

function GoldenTicketTemplate:Refresh(data, ui)
  if table.isNullOrEmpty(data) then
    return
  end
  self.data = data
  self.ui = ui
  self.ItemTbl = QuickFind:GetTask_EarlyGoldManager():GetBoxItemTbl({
    data.tasks
  })
  if self.ItemTbl then
    self.rewardItemTemplate:SetData(self.ItemTbl)
  end
  self:InitBaseUIState()
  self:RefreshViewUI()
end

function GoldenTicketTemplate:InitBaseUIState()
  self.img_bg_grey:SetActive(true)
  self.img_get_grey:SetActive(true)
  self.img_get:SetActive(false)
  self.Eff_UI_annuikuang03:SetActive(false)
  self.btn_receiveTicket:SetInteractable(false)
  self.img_received:SetActive(false)
end

function GoldenTicketTemplate:RefreshViewUI()
  local goalTxt = QuickFind:GetTask_EarlyGoldManager():GetTaskGoal(self.data.tasks.goals)
  self.lab_title:SetText(goalTxt.goalTips)
  local taskState = self.data.task and tonumber(self.data.task.state)
  local dataState = tonumber(self.data.state)
  local finalState = taskState or dataState
  if not finalState then
    return
  end
  self:UpdateUIByState(finalState)
end

function GoldenTicketTemplate:UpdateUIByState(state)
  if state == 2 then
    self.Eff_UI_annuikuang03:SetActive(true)
    self.btn_receiveTicket:SetInteractable(true)
    self.img_get:SetActive(true)
    self.img_bg_grey:SetActive(false)
    self.img_get_grey:SetActive(false)
  elseif state == 3 then
    self.img_received:SetActive(true)
    self.img_get_grey:SetActive(false)
  end
end

return GoldenTicketTemplate
