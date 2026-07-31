local Activity_CommercialCombineTaskTemplate = {}
Activity_CommercialCombineTaskTemplate.activityData = nil

function Activity_CommercialCombineTaskTemplate:Init(data)
  self.root = data
  self:InitControls()
end

function Activity_CommercialCombineTaskTemplate:InitControls()
  self.txt_lastTimeGift = self:GetControl("txt_lastTimeGift")
  self.go_task = self:GetControl("sw_Task/Viewport/Content/go_task")
  self.levelScroll = self:GetControl("sw_Task")
end

function Activity_CommercialCombineTaskTemplate:RefreshTableView(selectIndex)
  if self.TableView == nil then
    self.TableView = UITableView:CreateTableView(self.levelScroll, self.go_task, self.TaskTblList, EScrollViewDireEnum.Vertical, self.UpdateCellCallBack, self)
  end
  if self.TableView ~= nil then
    local smallSelectIndex = 0
    if 3 < selectIndex then
      smallSelectIndex = selectIndex - 2
    else
      smallSelectIndex = 1
    end
    self.TableView:ReloadData(smallSelectIndex)
    local obj = self.TableView:GetLoadedCell(selectIndex)
  end
end

function Activity_CommercialCombineTaskTemplate:UpdateCellCallBack(index)
  if type(self.TaskTblList) ~= "table" or next(self.TaskTblList) == nil then
    return
  end
  if self.TaskTblList[index] ~= nil then
    local cell = self.TableView:GetLoadedCell(index)
    self:RefreshTaskOption(self.TaskTblList[index], cell, index)
  end
end

function Activity_CommercialCombineTaskTemplate:RefreshTaskOption(data, ctr, index)
  self:OnTaskItemCreate(ctr)
  self:OnTaskItemRefresh(ctr, data, index)
end

function Activity_CommercialCombineTaskTemplate:OnTaskItemCreate(ctr)
  if ctr.PeriodicalReward == nil then
    ctr.PeriodicalReward = {
      [1] = UIControl(ctr.transform, "PeriodicalReward_1"),
      [2] = UIControl(ctr.transform, "PeriodicalReward_2"),
      [3] = UIControl(ctr.transform, "PeriodicalReward_3"),
      [4] = UIControl(ctr.transform, "PeriodicalReward_4"),
      [5] = UIControl(ctr.transform, "PeriodicalReward_5")
    }
  end
  if ctr.lab_task == nil then
    ctr.lab_task = UIControl(ctr.transform, "lab_task")
    ctr.lab_unfinish = UIControl(ctr.transform, "lab_unfinish")
    ctr.btn_go = UIControl(ctr.transform, "btn_go")
    ctr.lab_draw = UIControl(ctr.transform, "btn_go/lab_draw")
    ctr.lab_received = UIControl(ctr.transform, "btn_go/lab_received")
  end
end

function Activity_CommercialCombineTaskTemplate:OnTaskItemRefresh(ctr, data)
  ctr.lab_task:SetText(data.taskCfg.goalTips)
  local boxTable = {}
  local giftCfg = ClientTable.cfg_Gift_giftManager:TryGetValue(data.sCfg.giftId)
  if giftCfg then
    boxTable = ClientTable.cfg_Box_boxManager:TryGetTabListByType(giftCfg.reward, "boxId")
  end
  for i = 1, #ctr.PeriodicalReward do
    if boxTable[i] then
      ctr.PeriodicalReward[i]:SetActive(true)
      if ctr.PeriodicalReward[i].itemCellData == nil then
        ctr.PeriodicalReward[i].itemCellData = ItemCellData()
      end
      local itemInfo = ItemUtility.GenerateItemData(boxTable[i].itemId)
      itemInfo.count = boxTable[i].count
      ctr.PeriodicalReward[i].itemCellData:RefreshData(itemInfo)
      local item = UIControl(ctr.PeriodicalReward[i].transform, "PeriodicalReward_Item")
      ItemUtility.ShowItemCell(item, ctr.PeriodicalReward[i].itemCellData, self.data, true)
    else
      ctr.PeriodicalReward[i]:SetActive(false)
    end
  end
  if data.status == 1 then
    ctr.btn_go:SetActive(false)
    ctr.lab_unfinish:SetActive(true)
  else
    ctr.btn_go:SetActive(true)
    ctr.lab_unfinish:SetActive(false)
    if data.status == 2 then
      ctr.lab_draw:SetActive(true)
      ctr.lab_received:SetActive(false)
      ctr.btn_go:SetOnClick(self, function()
        gameMgr:GetGlobalActivityDataManager():GetActivityManger(ActivityBaseType.CommerceActivity):GetActivityData(CommerceActivityIdType.CombineTask):GetTask(data.sCfg.id)
      end)
    else
      ctr.lab_draw:SetActive(false)
      ctr.lab_received:SetActive(true)
      ctr.btn_go:SetOnClick(self, function()
      end)
    end
  end
end

function Activity_CommercialCombineTaskTemplate:Refresh(data)
  local dataManager = gameMgr:GetGlobalActivityDataManager():GetActivityManger(ActivityBaseType.CommerceActivity):GetActivityData(CommerceActivityIdType.CombineTask)
  self.txt_lastTimeGift:SetText(dataManager:GetRemainTimeDes())
  self.TaskTblList = dataManager:GetTaskList()
  self:RefreshTableView(1)
end

return Activity_CommercialCombineTaskTemplate
