local Go_itemTemplate = {}

function Go_itemTemplate:Init(data)
  self:InitControls()
  self:InitTemplates()
  self:InitUIEvents()
end

function Go_itemTemplate:InitControls()
  self.lab_name = self:GetControl("lab_name")
  self.btn_goKill = self:GetControl("btn_goKill")
  self.btn_complete = self:GetControl("btn_complete/lab")
  self.btn_cpmPleTed = self:GetControl("btn_cpmpleted")
  self.PeriodicalReward_Item = self:GetControl("PeriodicalReward/btn_Item")
  self.xianShiReward_btn_buy = self:GetControl("xianshiReward_btn_buy")
  self.Eff_UI_annUiKuAng03 = self:GetControl("xianshiReward_btn_buy/Eff_UI_annuikuang03")
  self.xianShiReward_getItem = self:GetControl("xianshiReward_getItem")
  self.img_icon = self:GetControl("img_icon")
  self.btn_cpmPleTed:SetActive(false)
  self.xianShiReward_getItem:SetActive(false)
end

function Go_itemTemplate:InitTemplates()
  self.rewardItemTemplate = UIUtility.BindUIContainerTemp(self.PeriodicalReward_Item, LuaComponentTemplates.UIItemTemplate, self.root, {
    isShowTips = true,
    stencil = 2,
    maskType = 5
  })
end

function Go_itemTemplate:InitUIEvents()
  self.btn_goKill:SetOnClick(self, self.btn_goKillClick)
  self.xianShiReward_btn_buy:SetOnClick(self, self.xianShiRewardClick)
end

function Go_itemTemplate:btn_goKillClick()
  PathFinderManager.FlyTransferScene(100175, 1, {npcId = 1001027}, Purpose.ClickNpc, function()
  end)
  self.ui:btn_closeOnClick()
end

function Go_itemTemplate:xianShiRewardClick()
  self.xianShiReward_btn_buy:SetActive(false)
  self.Eff_UI_annUiKuAng03:SetActive(false)
  self.xianShiReward_getItem:SetActive(true)
  networkRequest.ReqSubmitTask(self.data.taskId)
end

function Go_itemTemplate:Refresh(data, ui)
  if table.isNullOrEmpty(data) then
    return
  end
  self.data = data
  self.ui = ui
  local tbl = {}
  table.insert(tbl, data.tasks)
  self.ItemTbl = QuickFind:GetTask_EarlyGoldManager():GetBoxItemTbl(tbl)
  if self.ItemTbl then
    self.rewardItemTemplate:SetData(self.ItemTbl)
  end
  self:RefreshModel()
  self.btn_goKill:SetActive(false)
  self.xianShiReward_btn_buy:SetActive(false)
  self.Eff_UI_annUiKuAng03:SetActive(false)
  self.xianShiReward_getItem:SetActive(false)
  self.btn_cpmPleTed:SetActive(false)
  self:RefreshViewBtnKill()
  self:RefreshViewBtn()
end

function Go_itemTemplate:RefreshViewBtnKill()
  local GoldenDragonReward = QuickFind:GetTask_EarlyGoldManager():GetGoldenDragonReward()
  if GoldenDragonReward == nil then
    return
  end
  for i, v in pairs(GoldenDragonReward) do
    if v.taskId == 80001 then
      self.state1 = v.state
    end
    if v.taskId == 80002 then
      self.state2 = v.state
    end
    if v.taskId == 80003 then
      self.state6 = v.state
    end
    if v.task ~= nil then
      self.task = v.task
      if v.task.taskId == 80001 then
        self.state3 = v.task.state
      end
      if v.task.taskId == 80002 then
        self.state4 = v.task.state
      end
      if v.task.taskId == 80003 then
        self.state5 = v.task.state
      end
    else
      self.task = nil
      self.state3 = nil
      self.state4 = nil
      self.state5 = nil
    end
  end
  if tonumber(self.state1) == 1 then
    if self.data.taskId == 80001 then
      self.btn_goKill:SetActive(true)
    end
  elseif tonumber(self.state1) == 2 or tonumber(self.state1) == 3 then
    if self.data.taskId == 80001 then
      self.btn_cpmPleTed:SetActive(true)
    end
    if tonumber(self.state2) == 2 or tonumber(self.state2) == 3 then
      if self.data.taskId == 80003 then
        self.btn_goKill:SetActive(true)
      end
      if self.data.taskId == 80002 then
        self.btn_cpmPleTed:SetActive(true)
      end
      if (tonumber(self.state6) == 2 or tonumber(self.state6) == 3) and self.data.taskId == 80003 then
        self.btn_goKill:SetActive(false)
        self.btn_cpmPleTed:SetActive(true)
      end
    elseif tonumber(self.state2) == 1 and self.data.taskId == 80002 then
      self.btn_goKill:SetActive(true)
    end
  end
  if self.task ~= nil then
    if tonumber(self.state3) == 2 or tonumber(self.state3) == 3 then
      if self.data.taskId == 80001 then
        self.btn_goKill:SetActive(false)
        self.btn_cpmPleTed:SetActive(true)
      end
      if self.data.taskId == 80002 then
        self.btn_goKill:SetActive(true)
      end
    end
    if tonumber(self.state4) == 2 or tonumber(self.state4) == 3 then
      if self.data.taskId == 80002 then
        self.btn_goKill:SetActive(false)
        self.btn_cpmPleTed:SetActive(true)
      end
      if self.data.taskId == 80003 then
        self.btn_goKill:SetActive(true)
      end
    end
    if (tonumber(self.state5) == 2 or tonumber(self.state5) == 3) and self.data.taskId == 80003 then
      self.btn_goKill:SetActive(false)
      self.btn_cpmPleTed:SetActive(true)
    end
  end
end

function Go_itemTemplate:RefreshViewBtn()
  if tonumber(self.data.state) == 2 then
    self.xianShiReward_btn_buy:SetActive(true)
    self.Eff_UI_annUiKuAng03:SetActive(true)
  elseif tonumber(self.data.state) == 3 then
    self.xianShiReward_getItem:SetActive(true)
  end
  if self.data.task == nil then
    return
  end
  if tonumber(self.data.task.state) == 2 then
    self.xianShiReward_btn_buy:SetActive(true)
    self.Eff_UI_annUiKuAng03:SetActive(true)
  elseif tonumber(self.data.task.state) == 3 then
    self.xianShiReward_btn_buy:SetActive(false)
    self.Eff_UI_annUiKuAng03:SetActive(false)
    self.xianShiReward_getItem:SetActive(true)
  end
end

function Go_itemTemplate:RefreshModel()
  local goalTxt = QuickFind:GetTask_EarlyGoldManager():GetTaskGoal(self.data.tasks.goals)
  local monsterTbl = QuickFind:GetTask_EarlyGoldManager():GetMonster(goalTxt.goalParam)
  self.lab_name:SetText(monsterTbl.name)
  if self.data.count then
    self.str = string.format(goalTxt.goalTips, self.data.count)
  else
    self.str = string.format(goalTxt.goalTips, "1")
  end
  if self.data.task and self.data.task.count then
    self.str = string.format(goalTxt.goalTips, self.data.task.count)
  end
  self.btn_complete:SetText(self.str)
  local scale = Vector3(tonumber(16), tonumber(16), tonumber(16))
  local position = Vector3(tonumber(0), tonumber(-60), -100)
  self:ShowMonsterModel(monsterTbl, self.img_icon, scale, position)
end

function Go_itemTemplate:ShowMonsterModel(monsterTbl, parent, scale, position)
  local monster
  monster = UIMonsterUtility(monsterTbl.id, parent, scale, position, Vector3(0, -180, 0))
end

return Go_itemTemplate
