Arrest_BossUI = class(BaseUI)
Arrest_BossUI.layer = UILayer.Dialog
Arrest_BossUI.orderInLayer = 0
Arrest_BossUI.hideType = UIHideType.WaitDestroy
Arrest_BossUI.hideFunc = UIHideFunc.MoveOutOfScreen
Arrest_BossUI.escClose = UIEscClose.DontClose

function Arrest_BossUI:InitControls()
  self.btnClose = self:GetControl("img_Bg2/btnClose")
  self.plane_left = self:GetControl("plane_left")
  self.plane_right = self:GetControl("plane_right")
  self.plane_top = self:GetControl("plane_top")
  self.ArrestPanel = self:GetControl("ArrestPanel")
  self.ContentGold = self:GetControl("ArrestPanel/levelScroll/Viewport/ContentGold")
  self.ArrestMonster = self:GetControl("ArrestPanel/levelScroll/Viewport/ContentGold/ArrestMonster")
  self.subMenu = self:GetControl("ArrestPanel/levelScroll/Viewport/ContentGold/ArrestMonster/subTbl/subMenu")
  self.BossItem = self:GetControl("ArrestPanel/bossScroll/Viewport/BossItem")
  self.btn_goKill = self:GetControl("ArrestPanel/bossScroll/Viewport/BossItem/btn_goKill")
  self.lab_goKill = self:GetControl("ArrestPanel/bossScroll/Viewport/BossItem/btn_goKill/lab_goKill")
  self.Img_finish = self:GetControl("ArrestPanel/bossScroll/Viewport/BossItem/Img_finish")
  self.bossScrollContent = self:GetControl("ArrestPanel/bossScroll/Viewport/bossScrollContent")
  self.goldBossContent = self:GetControl("ArrestPanel/grid_rewardsInfo/goldBossContent")
  self.btn_gold3DItem = self:GetControl("ArrestPanel/grid_rewardsInfo/goldBossContent/btn_gold3DItem")
  self.Img_unfinish = self:GetControl("ArrestPanel/grid_rewardsInfo/Img_unfinish")
  self.Img_finshGet = self:GetControl("ArrestPanel/grid_rewardsInfo/Img_finshGet")
  self.btn_get_item = self:GetControl("ArrestPanel/grid_rewardsInfo/btn_get_item")
end

function Arrest_BossUI:Init()
end

function Arrest_BossUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Arrest_BossUI:InitUI()
  self.messageContainer = EventContainer(NetManager)
end

function Arrest_BossUI:RegistUIEvents()
  self.btnClose:SetOnClick(self, self.btnCloseOnClick)
  self.btn_get_item:SetOnClick(self, self.btn_getItemOnClick)
end

function Arrest_BossUI:RegistEvents()
  self.messageContainer:Regist(TaskMessage.ResTask, self.Task_Update, self)
end

function Arrest_BossUI.Task_Update(ui, id, msg)
  if not UIManager.IsVisible(UIID.Arrest_BossUI) then
    return
  end
  local taskId = ui.curTaskData and ui.curTaskData:GetId() or 0
  if msg and taskId == msg.taskId then
    local task = Task(msg)
    ui.curTaskData = task
  end
  ui:Refresh()
end

function Arrest_BossUI:btnCloseOnClick(control)
  UIManager.Hide(UIID.Arrest_BossUI)
end

function Arrest_BossUI:MainMenuOnClick(control)
  if control == nil then
    return
  end
  if self.lastMain_clickeffect ~= nil then
    self.lastMain_clickeffect.gameObject:SetActive(false)
  end
  self.lastMain_clickeffect = UIControl(control.transform, "img_clickeffect")
  self.lastMain_clickeffect:SetActive(true)
  if self.last_SubContainer ~= nil then
    self.last_SubContainer:SetTopGridMaxCount(0)
  end
  self.last_SubContainer = UIControl(control.transform, "subTbl")
  self:SetSubTagContainer(control, control.param.taskDatas)
  self:SetMainMenuTagPos(control.param.mainMenuIndex)
end

function Arrest_BossUI:SetMainMenuTagPos(_clickIndex)
  local mainCount = self.ContentGold.Top_gridContainer.MaxCount
  local subCount = self.last_SubContainer.Top_gridContainer.MaxCount
  local subHeight = self.last_SubContainer:GetTopGridCellHeight()
  local mainHeight = self.ContentGold:GetTopGridCellHeight()
  local offsetY = self.ArrestMonster.transform.localPosition.y
  for i = 1, mainCount do
    local mMainMenuTrans = self.ContentGold:GetTopGridObjectList()[i - 1].transform
    mMainMenuTrans.localPosition = Vector3(mMainMenuTrans.localPosition.x, offsetY - mainHeight * (i - 1), mMainMenuTrans.localPosition.z)
  end
  for i = 1, mainCount do
    if _clickIndex < i then
      local mMainMenuTrans = self.ContentGold:GetTopGridObjectList()[i - 1].transform
      mMainMenuTrans.localPosition = Vector3(mMainMenuTrans.localPosition.x, mMainMenuTrans.localPosition.y - subHeight * subCount, mMainMenuTrans.localPosition.z)
    end
  end
end

function Arrest_BossUI:subMenuOnClick(control)
  if self.lastSub_clickeffect ~= nil then
    self.lastSub_clickeffect.gameObject:SetActive(false)
  end
  self.lastSub_clickeffect = UIControl(control.transform, "img_clickeffect")
  self.lastSub_clickeffect:SetActive(true)
  self.curTaskData = control.param
  self:RefreshRightView()
  self:RefreshReward()
end

function Arrest_BossUI:btn_getItemOnClick(control)
  if self.curTaskData == nil then
    return
  end
  if self.curTaskData.state == TaskStateType.Completed then
    EventManager.Dispatch(Event.Task_BtnSubmitClick, self.curTaskData:GetId())
  end
end

function Arrest_BossUI:OnShow()
  self:RegistEvents()
  self:SetDefalutData()
  self:Refresh()
end

function Arrest_BossUI:OnHide()
  if self.monsterModelPri then
    for k, v in pairs(self.monsterModelPri) do
      v:DestroyGameObject()
    end
  end
  self.monsterModelPri = {}
  self.messageContainer:UnRegist(TaskMessage.ResTask, self.Task_Update, self)
end

function Arrest_BossUI:Refresh()
  self:SetTagContainer()
  self:RefreshReward()
end

function Arrest_BossUI:SetDefalutData()
  if self.args and self.args.openSecondTab then
    self.leftMainIndex = self.args.openSecondTab
    self.leftSubTaskId = self.args.subPosition or 0
  else
    local curOpenTaskData = TaskData:OpenRewardsTask(IndexerEnum.get)
    if curOpenTaskData == nil then
      curOpenTaskData = TaskData:GetRewardTask()
    end
    self.leftMainIndex = curOpenTaskData and curOpenTaskData.subType or 1
    self.leftSubTaskId = curOpenTaskData and curOpenTaskData:GetId() or 0
  end
end

function Arrest_BossUI:SetTagContainer()
  local taskList = TaskData.GetRewardsTask()
  local taskDic = {}
  for index, value in pairs(taskList) do
    if taskDic[value.subType] == nil then
      taskDic[value.subType] = {}
    end
    table.insert(taskDic[value.subType], value)
  end
  local taskDataCount = table.count(taskDic)
  self.ContentGold:SetTopGridMaxCount(taskDataCount)
  local index = 1
  local defalutObj
  for key, value in pairs(taskDic) do
    local goFirstTemp = self.ContentGold:GetTopGridObjectList()[index - 1].transform
    local lab_name = UIControl(goFirstTemp, "lab_name")
    local img_clickeffect = UIControl(goFirstTemp, "img_clickeffect")
    img_clickeffect:SetActive(false)
    local subType = value[1].subType
    if subType == 1 then
      lab_name:SetText("Treo Th\198\176\225\187\159ng Qu\195\161i")
    elseif subType == 2 then
      lab_name:SetText("Treo Th\198\176\225\187\159ng Qu\195\161i")
    end
    local goFirst = UIControl(goFirstTemp)
    local paramArray = {taskDatas = value, mainMenuIndex = index}
    goFirst:SetOnClickParam(self, self.MainMenuOnClick, paramArray)
    if key == self.leftMainIndex then
      goFirst.param = paramArray
      defalutObj = goFirst
    end
    index = index + 1
  end
  self.leftMainIndex = 1
  self:MainMenuOnClick(defalutObj)
end

function Arrest_BossUI:SetSubTagContainer(_goFirstTemp, _taskDatas)
  local subTbl = UIControl(_goFirstTemp.transform, "subTbl")
  local goalDataCount = table.count(_taskDatas)
  subTbl:SetTopGridMaxCount(goalDataCount)
  local defalutObj
  for i = 1, goalDataCount do
    local goSecondTemp = subTbl:GetTopGridObjectList()[i - 1].transform
    local mTaskData = _taskDatas[i]
    local cfg_Task = ClientTable.cfg_Task_taskManager:TryGetValue(mTaskData.taskId)
    local name = UIControl(goSecondTemp, "name")
    local img_clickeffect = UIControl(goSecondTemp, "img_clickeffect")
    img_clickeffect:SetActive(false)
    name:SetText(tostring(cfg_Task.name))
    local goSecond = UIControl(goSecondTemp)
    goSecond:SetOnClickParam(self, self.subMenuOnClick, mTaskData)
    if i == 1 then
      goSecond.param = mTaskData
      defalutObj = goSecond
    end
    if self.leftSubTaskId ~= 0 and mTaskData.taskId == self.leftSubTaskId then
      goSecond.param = mTaskData
      defalutObj = goSecond
    end
  end
  self.leftSubTaskId = 0
  self:subMenuOnClick(defalutObj)
end

function Arrest_BossUI:RefreshRightView()
  self:SetModelActiveState()
  local monsterInfos, monsterCount, taskId = self:GetAllTaskMonsters()
  self.bossScrollContent:SetTopGridMaxCount(monsterCount)
  local taskGoalDic = TaskData:RewardsTaskGoal(IndexerEnum.get)
  local curGoalTbl = taskGoalDic[taskId]
  local index = 1
  if self.recordDic == nil then
    self.recordDic = {}
  end
  for key1, goalDetailData in pairs(monsterInfos) do
    local GetCurFinishCount = goalDetailData.goalData:GetCurFinishCount() or 0
    local GetCount = goalDetailData.goalData:GetCount() or 0
    for key2, value2 in pairs(goalDetailData.monsetrs) do
      local go = self.bossScrollContent:GetTopGridObjectList()[index - 1].transform
      if self.recordDic[go] == nil then
        self.recordDic[go] = luaTemplateManager.GetNewTemplate(go, LuaComponentTemplates.Arrest_BossTemplates)
      end
      local templateData = {
        GetCurFinishCount = 0,
        GetCount = 0,
        curGoalTbl = {},
        cfg_monster = {}
      }
      templateData.GetCurFinishCount = GetCurFinishCount
      templateData.GetCount = GetCount
      templateData.goalTbl = goalDetailData.goalData.goalTbl
      templateData.curGoalTbl = curGoalTbl
      templateData.cfg_monster = value2
      self.recordDic[go]:Refresh(templateData)
      local positionx, positiony, positionz = ClientTable.cfg_Monster_monsterManager:GetPositionUi(templateData.cfg_monster)
      local position = Vector3(positionx, positiony, positionz)
      local scale = Vector3(templateData.cfg_monster.scaleUi, templateData.cfg_monster.scaleUi, templateData.cfg_monster.scaleUi)
      local monsterModel = UIControl(go, "monsterModel")
      self:ShowMonsterModel(goalDetailData.goalData.goalTbl.goalId, templateData.cfg_monster, monsterModel.transform, scale, position)
      index = index + 1
    end
  end
end

function Arrest_BossUI:SetModelActiveState()
  if self.monsterModelPri == nil then
    self.monsterModelPri = {}
  end
  for k, v in pairs(self.monsterModelPri) do
    v:SetHide()
  end
end

function Arrest_BossUI:GetAllTaskMonsters()
  if self.curTaskData == nil then
    return
  end
  local monsterInfos = {}
  local monsterCount = 0
  for key, value in pairs(self.curTaskData.goals) do
    local goalParamArray = string.split(value.goalTbl.goalParam, "#")
    local goalDetailData = {
      goalData = {},
      monsetrs = {}
    }
    for j = 1, table.count(goalParamArray) do
      local cfg_monsetr = ClientTable.cfg_Monster_monsterManager:TryGetValue(tonumber(goalParamArray[j]))
      monsterCount = monsterCount + 1
      table.insert(goalDetailData.monsetrs, cfg_monsetr)
    end
    goalDetailData.goalData = value
    table.insert(monsterInfos, goalDetailData)
  end
  return monsterInfos, monsterCount, self.curTaskData.taskId
end

function Arrest_BossUI:ShowMonsterModel(goalId, monsterTbl, parent, scale, position)
  local monster
  if self.monsterModelPri and self.monsterModelPri[goalId] == nil then
    monster = UIMonsterUtility(monsterTbl.id, parent, scale * 150, Vector3(position.x, position.y, position.z), Vector3(0, -180, 0))
    self.monsterModelPri[goalId] = monster
  else
    monster = self.monsterModelPri[goalId]
    monster:SetParent(parent)
    monster:SetLocalPosition(Vector3(position.x, -300, 0))
  end
  monster.gameObject:SetActive(true)
end

local function InitRewardItemControls(item)
  local itemCellData = ItemCellData()
  item.itemCellData = itemCellData
end

local function ItemRewardRefresh(item, _, rewards, ui)
  local itemInfo = ItemUtility.GenerateItemData(tonumber(rewards.itemID))
  itemInfo.count = rewards.itemNum
  item.itemCellData:RefreshData(itemInfo)
  ItemUtility.ShowItemCell(item, item.itemCellData, ui, true)
end

function Arrest_BossUI:RefreshReward()
  if not self.rewardItemTemp then
    self.rewardItemTemp = UIContainer(self.btn_gold3DItem, self, InitRewardItemControls, ItemRewardRefresh)
  end
  local taskList = TaskData.GetRewardsTask()
  local isContains = false
  for key, value in pairs(taskList) do
    if self.curTaskData ~= nil and value.taskId == self.curTaskData.taskId then
      isContains = true
    end
  end
  local taskData = self.curTaskData
  if taskData and taskData.state == TaskStateType.Completed then
    self.Img_unfinish:SetActive(false)
    self.Img_finshGet:SetActive(false)
    self.btn_get_item:SetActive(true)
  elseif taskData and taskData.state == TaskStateType.Submitted then
    self.Img_unfinish:SetActive(false)
    self.Img_finshGet:SetActive(true)
    self.btn_get_item:SetActive(false)
  else
    self.Img_unfinish:SetActive(true)
    self.Img_finshGet:SetActive(false)
    self.btn_get_item:SetActive(false)
  end
  if isContains == false then
    self.Img_unfinish:SetActive(false)
    self.Img_finshGet:SetActive(true)
    self.btn_get_item:SetActive(false)
  end
  if taskData == nil then
    return
  end
  local rewards = taskData:GetRewards()
  local allRewards = {}
  for k, v in pairs(rewards) do
    table.insert(allRewards, {itemID = k, itemNum = v})
  end
  self.rewardItemTemp:SetData(allRewards)
end
