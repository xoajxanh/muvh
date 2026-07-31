GuideManager = {}
local this = GuideManager
GuideManager.GuideEff = {}
GuideManager.GuidePrompt = {}
GuideManager.AwaitGuidEff = {}
GuideManager.GuideBtn = {}
local cfgGroupData = {}
local cfgStepData = {}
local taskGroupData = {}
local cfgGuideNumData = {}
local CoerceTimer, AutoTimer, MainUIState
GuideManager.isCoerceGuide = false

function GuideManager.Init()
  this.InitCfgData()
end

function GuideManager.InitCfgData()
  cfgGroupData = ClientTable.cfg_Guide_groupManager:GetDic()
  cfgStepData = ClientTable.cfg_Guide_stepManager:GetDic()
  for k, v in pairs(cfgGroupData) do
    if v.guideParam == "Task_TaskUI" and v.step ~= "" then
      table.insert(taskGroupData, v)
    end
  end
  for k, v in pairs(cfgGroupData) do
    if v.guideNum ~= 0 then
      table.insert(cfgGuideNumData, v)
    end
  end
end

function GuideManager.OnEnterGame()
  this.RegistEvents()
  TipData.OnLeaveGame()
end

function GuideManager.OnLeaveGame()
  if this.eventContainer then
    this.eventContainer:UnRegistAll()
  end
  this.CloseGuide()
  TipData.OnLeaveGame()
end

function GuideManager.Update()
end

function GuideManager.RegistEvents()
  this.eventContainer = EventContainer(EventManager)
  this.eventContainer:Regist(Event.Load_Guide, this.Load_Guide)
  this.eventContainer:Regist(Event.Role_MyLvChanged, this.OnRole_MyLvChanged)
  this.eventContainer:Regist(Event.UI_Show, this.UI_Show)
  this.eventContainer:Regist(Event.UI_Hide, this.UI_Hide)
  this.eventContainer:Regist(Event.AddCreatObj, this.AddCreatObj)
  this.eventContainer:Regist(Event.Task_Update, this.Task_Update)
  this.eventContainer:Regist(Event.Bag_ResBagChange, this.Bag_ResBagChange)
  this.eventContainer:Regist(Event.Bag_CoinChanged, this.Bag_CoinChanged)
  this.eventContainer:Regist(Event.Role_OnArrive, this.RoleMeOnArrivePos)
  this.eventContainer:Regist(Event.Logic_ActiveMainUI, this.OnActiveMainUI)
  this.eventContainer:Regist(Event.Task_DisPlayEffect, this.TaskEffExclude)
  this.eventContainer:Regist(Event.SetGuideParent, this.SetGuideParent)
end

function GuideManager.OnActiveMainUI(_, state)
  MainUIState = state
end

function GuideManager.UI_Show(id, msg)
  if not this.InGame() then
    return
  end
  
  local function waitExe()
    Coroutine.Wait(0.1)
    this.specialUI(msg.name)
    if this.AwaitGuidEff[msg.name] ~= nil and table.count(this.AwaitGuidEff[msg.name]) > 0 then
      for k, v in pairs(this.AwaitGuidEff) do
        if msg.name == k then
          for kk, vv in pairs(v) do
            local parent = this.GetEffectParent(vv)
            if parent ~= nil and this.GetCondition(this.GetGroupTab(vv.uiName, vv.order)) then
              this.SetCreatEffect(vv, parent, false)
              this.AwaitGuidEff[k][kk] = nil
            end
          end
        end
      end
    end
    local groupIDTab = this.GetIsHaveEffect(msg.name)
    if table.count(groupIDTab) > 0 then
      for k, v in pairs(groupIDTab) do
        this.EffectSwitch(v, OpenGuideEffType.uiShow)
      end
    end
    local groupRelateIDTab = this.GetRelateEffect(msg.name)
    if table.count(groupRelateIDTab) > 0 then
      for k, v in pairs(groupRelateIDTab) do
        this.EffectSwitchInRelate(v)
      end
    end
  end
  
  Coroutine.Start(waitExe, self)
end

function GuideManager.UI_Hide(id, msg)
  if UIManager.IsVisible(UIID.GuideMaskUI) then
    UIManager.Hide(UIID.GuideMaskUI)
  end
  if msg.name == "GuideMaskUI" then
    this.isCoerceGuide = false
  end
end

function GuideManager.AddCreatObj(id, msg)
  if msg.taskId ~= nil then
    this.AddTaskObj()
  elseif this.AwaitGuidEff[msg.name] ~= nil and table.count(this.AwaitGuidEff[msg.name]) > 0 then
    for k, v in pairs(this.AwaitGuidEff[msg.name]) do
      if v.uiAddress == msg.objName and v.dynamicId == msg.index and this.GetCondition(this.GetGroupTab(v.uiName, v.order)) then
        this.SetCreatEffect(v, this.GetEffectParent(v))
        this.AwaitGuidEff[msg.name][k] = nil
      end
    end
  end
end

function GuideManager.AddTaskObj()
  for k, v in pairs(taskGroupData) do
    for kk, vv in pairs(this.GetTaskIdTab(v.step)) do
      for kt, vt in pairs(GuideUtility.TaskObj) do
        if tonumber(vv) == vt.taskId and this.GetCondition(v) then
          local stepData = this.GetStepTab(v.guideParam, v.order)
          this.SetCreatEffect(stepData, vt.obj)
        elseif this.GuideEff[v.guideParam] and this.GuideEff[v.guideParam][v.order] and this.GetCondition(v) == false then
          this.GuideEff[v.guideParam][v.order]:SetActive(false)
          this.GuidePrompt[v.guideParam][v.order]:SetActive(false)
        end
      end
    end
  end
end

function GuideManager.Task_Update(id, taskId)
  for k, v in pairs(cfgGroupData) do
    if v.step ~= "" then
      for kk, vv in pairs(this.GetTaskIdTab(v.step)) do
        if this.GetTaskState(tonumber(vv)) then
          if UIManager.IsVisible(v.guideParam) then
            local msgData = {
              name = v.guideParam
            }
            this.UI_Show(nil, msgData)
          end
        else
          if this.GuidePrompt[v.guideParam] and this.GuidePrompt[v.guideParam][v.order] then
            this.GuidePrompt[v.guideParam][v.order]:SetActive(false)
          end
          if this.GuideEff[v.guideParam] and this.GuideEff[v.guideParam][v.order] then
            this.GuideEff[v.guideParam][v.order]:SetActive(false)
          end
        end
      end
    end
  end
  this.isRejectTask(taskId)
end

function GuideManager.Bag_ResBagChange(id, msg)
  this.AddTaskObj()
  if msg and msg.showItems then
    for k, v in pairs(msg.showItems) do
      for kk, vv in pairs(cfgGroupData) do
        if v.itemId == vv.itemId then
          this.EffectSwitch(vv, OpenGuideEffType.itemChange)
        end
      end
    end
  end
end

function GuideManager.Bag_CoinChanged(id, msg)
  for k, v in pairs(msg.coins) do
    for kk, vv in pairs(cfgGroupData) do
      if v.itemId == vv.itemId then
        this.EffectSwitch(vv, OpenGuideEffType.coinChange)
      end
    end
  end
end

function GuideManager.RoleMeOnArrivePos(_, pos)
  for k, v in pairs(cfgGroupData) do
    if v.position ~= "" then
      local posTab = string.split(v.position, "#")
      for kk, vv in pairs(posTab) do
        local position = string.split(vv, "_")
        local posCheck = {
          x = tonumber(position[1]),
          y = tonumber(position[2])
        }
        local isArrive = this.IsDetectionRangePoint(pos, posCheck, 5)
        if isArrive then
          this.EffectSwitch(v, OpenGuideEffType.arrivePoint)
        end
      end
    end
  end
end

function GuideManager.IsDetectionRangePoint(centralPoint, checkPoint, range)
  if centralPoint and checkPoint then
    range = range == nil and 1 or range
    return this.Compare(centralPoint.x, checkPoint.x, range) and this.Compare(centralPoint.y, checkPoint.y, range)
  end
end

function GuideManager.Compare(a, b, range)
  range = range == nil and 1 or range
  return range >= Mathf.Abs(a - b)
end

function GuideManager.Load_Guide()
  for k, v in pairs(cfgStepData) do
    this.SetGuideIdType(v)
  end
end

function GuideManager.OnRole_MyLvChanged()
  this.LevelToJudge()
end

function GuideManager.SetGuideIdType(GuideStepData)
  if not this.LevelToJudge() then
    return
  end
  if GuideStepData then
    local isMeetTask
    local parent = this.GetEffectParent(GuideStepData)
    local GroupData = this.GetGroupTab(GuideStepData.uiName, GuideStepData.order)
    if GroupData ~= nil then
      isMeetTask = this.GetSwitch(GroupData.step, GroupData.itemId)
    else
      isMeetTask = false
    end
    if parent == nil or not isMeetTask then
      if this.AwaitGuidEff[GuideStepData.uiName] == nil then
        this.AwaitGuidEff[GuideStepData.uiName] = {}
      end
      print("\230\143\144\231\164\186~~~", GuideStepData.uiName, GuideStepData.name)
      this.AwaitGuidEff[GuideStepData.uiName][GuideStepData.order or 1] = GuideStepData
      return
    end
    this.SetCreatEffect(GuideStepData, parent)
  end
end

function GuideManager.GetEffectParent(GuideStepData)
  local UIName = GuideStepData.uiName
  local uiAddress = GuideStepData.uiAddress
  local dynamicId = GuideStepData.dynamicId or 0
  local Parent
  if uiAddress == "" then
    EventManager.Dispatch(Event.GetGuideParent, GuideStepData)
  else
    for k, v in pairs(UIManager.sortedUIs) do
      if v.name == UIName then
        for kk, vv in pairs(v) do
          if kk == uiAddress and dynamicId == 0 then
            Parent = vv
            break
          end
        end
      end
    end
    if Parent == nil and dynamicId ~= 0 then
      for k, v in pairs(GuideUtility.CreateObj) do
        if k == UIName then
          for kk, vv in pairs(GuideUtility.CreateObj[k]) do
            if kk == uiAddress then
              for kt, vt in pairs(GuideUtility.CreateObj[k][kk]) do
                if kt == dynamicId then
                  Parent = vt
                  break
                end
              end
            end
          end
          break
        end
      end
    end
    if Parent == nil then
      for k, v in pairs(GuideUtility.CreateNameObj) do
        if k == UIName then
          for kk, vv in pairs(GuideUtility.CreateNameObj[k]) do
            if vv.gameObject.name == uiAddress then
              Parent = vv
              break
            end
          end
          break
        end
      end
    end
  end
  return Parent
end

function GuideManager.SetGuideParent(_, msg)
  if not this.InGame() then
    return
  end
  if this.AwaitGuidEff[msg.data.uiName] ~= nil and table.count(this.AwaitGuidEff[msg.data.uiName]) > 0 then
    for k, v in pairs(this.AwaitGuidEff) do
      if msg.data.uiName == k then
        local parent = msg.parent
        if parent ~= nil then
          this.SetCreatEffect(msg.data, parent)
          this.AwaitGuidEff[k][msg.data.order] = nil
        end
      end
    end
  end
end

function GuideManager.SetCreatEffect(data, gameObject, isSetActive)
  if not this.InGame() then
    return
  end
  if not this.LevelToJudge() then
    return
  end
  if data == nil or gameObject == nil then
    return
  end
  this.CreatEff(data, gameObject)
  this.CreatPrompt(data, gameObject)
  if isSetActive == nil or isSetActive == true then
    for k, v in pairs(cfgGroupData) do
      if data.order == v.order and data.uiName == v.guideParam then
        this.EffectSwitch(v, OpenGuideEffType.init)
      end
    end
  end
end

function GuideManager.CreatEff(data, gameObject)
  local isCoerce
  local strPos = string.sub(data.position, 2)
  local pos = string.split(strPos, "#")
  local scale = string.split(data.scale, "#")
  if this.GetGroupTab(data.uiName, data.order) == nil or this.GetGroupTab(data.uiName, data.order).guideType ~= GuideType.coerceGuide or not this.GetSwitch(this.GetGroupTab(data.uiName, data.order).step) then
    isCoerce = false
  else
    isCoerce = true
  end
  if this.GuideEff[data.uiName] and this.GuideEff[data.uiName][data.order] then
    this.GuideEff[data.uiName][data.order]:SetParent(gameObject.transform)
    this.GuideEff[data.uiName][data.order]:SetPosition(pos[1], pos[2], 0)
    this.GuideBtn[data.uiName][data.order] = {
      isCoerce = isCoerce,
      obj = gameObject,
      isActive = this.GuideBtn[data.uiName][data.order].isActive,
      isRecord = true
    }
  else
    local effectData = {
      name = data.effParam,
      model = data.effParam,
      parent = gameObject.transform,
      modelType = EEffectModelType.UI,
      posX = tonumber(pos[1]),
      posY = tonumber(pos[2]),
      ScaleX = tonumber(scale[1]),
      ScaleY = tonumber(scale[2])
    }
    local Effect = GuideEffect(effectData)
    Effect:SetActive(false)
    if this.GuideEff[data.uiName] == nil then
      this.GuideEff[data.uiName] = {}
    end
    if this.GuideBtn[data.uiName] == nil then
      this.GuideBtn[data.uiName] = {}
    end
    this.GuideEff[data.uiName][data.order] = Effect
    this.GuideBtn[data.uiName][data.order] = {
      isCoerce = isCoerce,
      obj = gameObject,
      isActive = true,
      isRecord = true
    }
  end
end

function GuideManager.CreatPrompt(data, gameObject)
  if data and data.guideWord ~= "" then
    local text = data.guideWord
    text = string.replace(text, "\\n", "\n")
    local strPosPrompt = string.sub(data.positionPrompt, 2)
    local pos = string.split(strPosPrompt, "#")
    local leftPosSca = string.split(data.scalePrompt, "#")
    local rightPosSca = string.split(data.scalePromptRight, "#")
    if this.GuidePrompt[data.uiName] and this.GuidePrompt[data.uiName][data.order] then
      this.GuidePrompt[data.uiName][data.order]:SetParent(gameObject.transform)
      this.GuidePrompt[data.uiName][data.order]:SetPosition(pos[3], pos[4], pos[5])
    else
      local ok
      local posZ = tonumber(pos[5])
      if data.order == 700101 or data.order == 2200101 then
        ok = this.OpenSell
      end
      local PromptData = {
        isGuide = true,
        ok = ok,
        okArgs = this,
        arrows = data.arrowPosition,
        text = text,
        parent = gameObject.transform,
        posX = tonumber(pos[3]),
        posY = tonumber(pos[4]),
        posZ = posZ,
        ScaleX = tonumber(pos[1]),
        ScaleY = tonumber(pos[2]),
        posXLeft = leftPosSca[1],
        posYLeft = leftPosSca[2],
        posZLeft = leftPosSca[3],
        ScaleXLeft = leftPosSca[4],
        ScaleYLeft = leftPosSca[5],
        RolationZLeft = leftPosSca[6],
        posXRight = rightPosSca[1],
        posYRight = rightPosSca[2],
        posZRight = rightPosSca[3],
        ScaleXRight = rightPosSca[4],
        ScaleYRight = rightPosSca[5],
        RolationZRight = rightPosSca[6],
        sortOrder = 0 < posZ and posZ or -posZ
      }
      local Prompt = TextPrompt(PromptData)
      if this.GuidePrompt[data.uiName] == nil then
        this.GuidePrompt[data.uiName] = {}
      end
      this.GuidePrompt[data.uiName][data.order] = Prompt
    end
  elseif data and not string.isNullOrEmpty(data.cancelOrder) then
    local temppanel = string.split(data.cancelOrder, "#")
    if 1 < #temppanel and this.GuidePrompt[temppanel[1]] and this.GuidePrompt[temppanel[1]][tonumber(temppanel[2])] then
      this.GuidePrompt[temppanel[1]][tonumber(temppanel[2])]:SetActive(false)
    end
  end
end

function GuideManager.TaskEffExclude()
  local TaskEff = {}
  if this.GuideEff and this.GuideEff.Task_TaskUI then
    for k, v in pairs(this.GuideEff.Task_TaskUI) do
      v:SetActive(false)
      if this.GuidePrompt and this.GuidePrompt.Task_TaskUI and this.GuidePrompt.Task_TaskUI[k] then
        this.GuidePrompt.Task_TaskUI[k]:SetActive(false)
      end
      table.insert(TaskEff, k)
    end
    for k, v in pairs(TaskEff) do
      local groupData = this.GetGroupTab("Task_TaskUI", v)
      this.EffectSwitch(groupData, OpenGuideEffType.init)
    end
  end
end

function GuideManager.EffectSwitch(data, openType)
  this.SetEffectSwitch(data, openType)
end

function GuideManager.EffectSwitchInRelate(data)
  if not this.LevelToJudge() then
    return
  end
  if UIManager.IsVisible(data.uiName) and this.GuideEff[data.relateParam] and this.GuideEff[data.relateParam][data.order] then
    this.GuideEff[data.relateParam][data.order]:SetActive(true)
  elseif this.GuideEff[data.relateParam] and this.GuideEff[data.relateParam][data.order] then
    this.GuideEff[data.relateParam][data.order]:SetActive(false)
  end
end

function GuideManager.SetEffectSwitch(v, openType)
  if this.GuideEff[v.guideParam] == nil or this.GuideEff[v.guideParam][v.order] == nil then
    return
  end
  local taskState = this.GetCondition(v)
  local btnActive = true
  local delayTime = 0.5
  
  local function SetProMpt()
    Coroutine.Wait(delayTime)
    this.SetRelateEffect(v.relateParam, v.order, taskState)
    if this.GuideEff[v.guideParam] and this.GuideEff[v.guideParam][v.order] then
      this.GuideEff[v.guideParam][v.order]:SetActive(taskState and btnActive)
    end
    local guide_step = ClientTable.cfg_Guide_stepManager:TryGetValue(v.order)
    if guide_step and not string.isNullOrEmpty(guide_step.cancelOrder) then
      local temppanel = string.split(guide_step.cancelOrder, "#")
      if 1 < #temppanel and this.GuidePrompt[temppanel[1]] and this.GuidePrompt[temppanel[1]][tonumber(temppanel[2])] then
        this.GuidePrompt[temppanel[1]][tonumber(temppanel[2])]:SetActive(false)
      end
    elseif this.GuidePrompt[v.guideParam] and this.GuidePrompt[v.guideParam][v.order] then
      this.GuidePrompt[v.guideParam][v.order]:SetActive(taskState and btnActive)
    end
  end
  
  if this.GuideBtn[v.guideParam] and this.GuideBtn[v.guideParam][v.order] then
    btnActive = this.GuideBtn[v.guideParam][v.order].isActive
  end
  if v.guideType == GuideType.TaskID then
    Coroutine.Start(SetProMpt, self)
  elseif v.guideType == GuideType.coerceGuide then
    Coroutine.Start(SetProMpt, self)
    if taskState == true then
      for k, vv in pairs(cfgStepData) do
        local btn = this.GuideBtn[v.guideParam][v.order]
        if vv.uiName == v.guideParam and vv.order == v.order and btn.isCoerce and not UIManager.IsVisible(UIID.GuideMaskUI) and not this.isCoerceGuide then
          do
            local function SetCoerce()
              if this.GuideBtn[v.guideParam][v.order] and UIManager.IsVisible(vv.uiName) then
                UIManager.Show(UIID.GuideMaskUI, {
                  obj = btn.obj,
                  
                  guideWord = vv.guideWord
                })
                this.SetCoerceGuide(btn, vv)
              else
                this.isCoerceGuide = false
              end
              EventManager.Dispatch(Event.SetCoerceGuide, this.isCoerceGuide)
            end
            
            this.isCoerceGuide = true
            CoerceTimer = Timer.Start(0.25, SetCoerce)
          end
        end
      end
    end
  else
    Coroutine.Start(SetProMpt, self)
  end
  for k, _v in pairs(cfgGuideNumData) do
    if _v.order == v.order and this.GuideEff[v.guideParam][v.order] and taskState then
      this.GuideBtn[v.guideParam][v.order].obj:SetOnPointerClick(self, function()
        if AutoTimer ~= nil then
          Timer.Stop(AutoTimer)
          AutoTimer = nil
        end
        if v.guideNum ~= 0 and (v.order == 2500101 or v.order == 900101) then
          this.hideClickGuide(v)
        end
        if UIManager.IsVisible(UIID.GuideMaskUI) and v.guideParam ~= "Task_TaskUI" then
          UIManager.Hide(UIID.GuideMaskUI)
        end
      end)
    end
  end
end

function GuideManager.SetAutoClick(btn, StepData)
end

function GuideManager.SetCoerceGuide(btn, StepData)
  this.SetAutoClick(btn, StepData)
  btn.obj:SetOnPointerClick(self, function()
    if AutoTimer ~= nil then
      Timer.Stop(AutoTimer)
      AutoTimer = nil
    end
    this.coerceGuideBtnOnClick(btn, StepData)
  end)
end

function GuideManager.coerceGuideBtnOnClick(btn, StepData)
  UIManager.Hide(UIID.GuideMaskUI)
  this.isCoerceGuide = false
  btn.isCoerce = false
  EventManager.Dispatch(Event.SetCoerceGuide, this.isCoerceGuide)
  if StepData.uiName == "Main_MapDetailUI" then
    this.hideClickGuide(this.GetGroupTab(StepData.uiName, StepData.order))
  end
  if StepData.uiName ~= "Task_TaskUI" then
    this.UI_Show(nil, {
      name = StepData.uiName
    })
  end
end

function GuideManager.IsGroupFinish(groupData, isHide)
  if isHide then
    this.hideClickGuide(groupData)
  end
  local isRecord = false
  local groupTab = this.GetGuideNumTab(groupData.guideNum)
  for k, v in pairs(groupTab) do
    if this.GuideBtn[v.guideParam] and this.GuideBtn[v.guideParam][v.order] then
      if not isHide then
        this.GuideBtn[v.guideParam][v.order].isActive = true
      end
      if this.GuideBtn[v.guideParam][v.order].isActive and this.GuideBtn[v.guideParam] and this.GuideBtn[v.guideParam][v.order] and AutoTimer == nil and isHide then
        local btn = this.GuideBtn[v.guideParam][v.order]
        this.SetAutoClick(btn, this.GetStepTab(v.guideParam, v.order))
      end
      if this.GuideBtn[v.guideParam][v.order].isRecord then
        isRecord = true
      end
    else
      isRecord = true
    end
  end
  if not isRecord then
    this.CloseGuideNum(groupTab, isRecord)
  elseif not isHide then
    local isOpen = false
    for k, v in pairs(groupTab) do
      if this.GuideEff[v.guideParam] and this.GuideEff[v.guideParam][v.order] and this.GetCondition(v) then
        isOpen = true
        break
      end
    end
    if isOpen then
      for k, v in pairs(groupTab) do
        if this.GuidePrompt[v.guideParam] and this.GuidePrompt[v.guideParam][v.order] then
          this.GuidePrompt[v.guideParam][v.order]:SetActive(isRecord)
        end
        if this.GuideEff[v.guideParam] and this.GuideEff[v.guideParam][v.order] then
          this.GuideEff[v.guideParam][v.order]:SetActive(isRecord)
          if this.GuideBtn[v.guideParam] and this.GuideBtn[v.guideParam][v.order] and AutoTimer == nil then
            local btn = this.GuideBtn[v.guideParam][v.order]
            this.SetAutoClick(btn, this.GetStepTab(v.guideParam, v.order))
          end
        end
      end
    end
  end
end

function GuideManager.hideClickGuide(groupData)
  if groupData.guideNum == 0 then
    return
  end
  if this.GuideEff[groupData.guideParam] and this.GuideEff[groupData.guideParam][groupData.order] then
    this.GuideEff[groupData.guideParam][groupData.order]:SetActive(false)
    this.GuideBtn[groupData.guideParam][groupData.order].isActive = false
  end
  if this.GuidePrompt[groupData.guideParam] and this.GuidePrompt[groupData.guideParam][groupData.order] then
    this.GuidePrompt[groupData.guideParam][groupData.order]:SetActive(false)
  end
end

function GuideManager.CloseGuideNum(groupTab, isRecord)
end

function GuideManager.GetCondition(groupData)
  return this.GetSwitch(groupData.step, groupData.itemId, groupData.position, groupData.guideNum, groupData.order)
end

function GuideManager.GetSwitch(taskID, itemID, positionTab, guideNum, order)
  local isTask = false
  local isItem = false
  local isPosition = false
  local isGuideNum = false
  local taskId = this.GetTaskIdTab(taskID)
  local taskNum = table.count(taskId)
  if taskNum <= 0 then
    isTask = true
  else
    for i = 1, #taskId do
      local task = TaskData.GetTaskById(tonumber(taskId[i]))
      if task and task:GetState() == TaskStateType.Accept then
        isTask = true
      end
    end
  end
  if itemID and itemID ~= 0 then
    local count = BagInfoData.GetItemTotalCountByItemId(itemID)
    isItem = 0 < count
  else
    isItem = true
  end
  if positionTab and positionTab ~= "" then
    local posTab = string.split(positionTab, "#")
    for k, v in pairs(posTab) do
      local position = string.split(v, "_")
      local posCheck = {
        x = tonumber(position[1]),
        y = tonumber(position[2])
      }
      local isArrive = this.IsDetectionRangePoint(RoleManager.me.cellPos, posCheck, 5)
      if isArrive then
        isPosition = true
        break
      end
    end
  else
    isPosition = true
  end
  if guideNum and guideNum ~= 0 and RoleManager and RoleManager.me then
    local data = string.format("%d-%d", RoleManager.me.id, order)
    local num = PlayerPrefs.GetInt(data)
    isGuideNum = num ~= 1
  else
    isGuideNum = true
  end
  if isTask and isItem and isPosition and isGuideNum then
    return true
  end
  return false
end

function GuideManager.GetIsVisibleRelateUI(relateParam)
  if relateParam ~= "" and not UIManager.IsVisible(relateParam) then
    return false
  end
  return true
end

function GuideManager.GetIsHaveEffect(EffName)
  local GuideEff = {}
  for k, v in pairs(cfgGroupData) do
    if v.guideParam == EffName then
      table.insert(GuideEff, v)
    end
  end
  return GuideEff
end

function GuideManager.GetRelateEffect(EffName)
  local GuideEff = {}
  for k, v in pairs(cfgGroupData) do
    if v.relateParam and v.relateParam == EffName then
      table.insert(GuideEff, v)
    end
  end
  return GuideEff
end

function GuideManager.SetRelateEffect(EffName, order, state)
  for k, v in pairs(cfgGroupData) do
    if v.relateParam == EffName and this.GuideEff[EffName] ~= nil and this.GuideEff[EffName] and this.GuideEff[EffName][order] then
      this.GuideEff[EffName][order]:SetActive(state)
    end
  end
end

function GuideManager.GetGuideNumTab(guideNum)
  local groupTab = {}
  for k, v in pairs(cfgGuideNumData) do
    if v.guideNum == guideNum then
      table.insert(groupTab, v)
    end
  end
  return groupTab
end

function GuideManager.GetTaskIdTab(step)
  local taskTab = string.split(step, "#")
  return taskTab
end

function GuideManager.GetStepTab(name, orderId)
  for k, v in pairs(cfgStepData) do
    if v.uiName == name and v.order == orderId then
      return v
    end
  end
  return nil
end

function GuideManager.GetGroupTab(name, orderId)
  for k, v in pairs(cfgGroupData) do
    if v.guideParam == name and v.order == orderId then
      return v
    end
  end
  return nil
end

function GuideManager.InGame()
  if not LoginData.InGame then
    if CoerceTimer then
      Timer.Stop(CoerceTimer)
      CoerceTimer = nil
    end
    if AutoTimer then
      Timer.Stop(AutoTimer)
      AutoTimer = nil
    end
    this.CloseGuide()
    return false
  end
  return true
end

function GuideManager.LevelToJudge()
  if ViewData.meData.level > ClientTable.cfg_Global_globalManager:GetAutoTaskLevel() then
    this.CloseGuide()
    return false
  end
  return true
end

function GuideManager.OnBack2ChooseRole()
  this.CloseGuide()
end

function GuideManager.CloseGuide()
  for k, v in pairs(this.GuideEff) do
    for kk, vv in pairs(v) do
      vv:Destroy()
    end
  end
  for k, v in pairs(this.GuidePrompt) do
    for kk, vv in pairs(v) do
      vv:Destroy()
    end
  end
  this.GuideEff = {}
  this.GuidePrompt = {}
  this.AwaitGuidEff = {}
  this.GuideBtn = {}
  GuideUtility.ClearData({})
end

GuideManager.Init()

function GuideManager.GetTaskState(taskId)
  if TaskData.GetTaskById(taskId) and (TaskData.GetTaskById(taskId):GetState() == TaskStateType.Acceptable or TaskData.GetTaskById(taskId):GetState() == TaskStateType.Accept) then
    return true
  end
  return false
end

local RecyclingGuide = {
  [1] = 100061,
  [2] = 10018
}

function GuideManager.specialUI(uiName)
  if uiName == "Bag_SellInfoUI" then
    if AutoTimer then
      Timer.Stop(AutoTimer)
      AutoTimer = nil
    end
    
    local function CloseGuideNum()
      Coroutine.Wait(0.5)
      if this.GetTaskState(RecyclingGuide[1]) then
        this.CloseGuideNum(this.GetGuideNumTab(22), false)
      end
      if this.GetTaskState(RecyclingGuide[2]) then
        this.CloseGuideNum(this.GetGuideNumTab(7), false)
      end
    end
    
    Coroutine.Start(CloseGuideNum, self)
  end
end

function GuideManager.CloseGuideNumInMap()
  if AutoTimer then
    Timer.Stop(AutoTimer)
    AutoTimer = nil
  end
  
  local function CloseGuideNum()
    Coroutine.Wait(0.5)
    if ViewData.meData.level < 25 then
      this.CloseGuideNum(this.GetGuideNumTab(8), false)
    else
      this.CloseGuideNum(this.GetGuideNumTab(9), false)
    end
  end
  
  Coroutine.Start(CloseGuideNum, self)
end

function GuideManager.OpenSell()
  local openDir = PlayerControlForceData.BagSellIsOpen()
  if openDir then
    UIManager.Show(UIID.BagSellInfoUI)
  else
    TipUtility.ShowSellOpenPrompt()
  end
end

function GuideManager.GetGuideTextPromptActive()
  if table.count(this.GuidePrompt) < 1 then
    return false
  end
  for k, v in pairs(this.GuidePrompt) do
    for kk, vv in pairs(v) do
      if vv:GetActive() == true then
        return true
      end
    end
  end
  return false
end

function GuideManager.isRejectTask(taskId)
  if taskId == 10024 or taskId == 100331 then
    if this.GetTaskState(taskId) then
      EventManager.Dispatch(Event.Scene_SmallBossShow, false)
    else
      EventManager.Dispatch(Event.Scene_SmallBossShow, true)
    end
  end
  if this.GetGuideTextPromptActive() == false then
    TextPromptUtility.ShowTextPrompt()
  end
end
