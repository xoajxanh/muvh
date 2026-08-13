NavigationUtility = {}
local this = NavigationUtility

function NavigationUtility.ClickNavigationByNavId(navId)
  if type(navId) ~= "number" then
    return
  end
  local navTbl = ClientTable.cfg_Navigation_barManager:TryGetValue(navId)
  if navTbl == nil then
    return
  end
  NavigationUtility.ClickNavigation(navTbl)
end

function NavigationUtility.ClickNavigation(navTal)
  if navTal.type == TaskNavigationType.DirectlyOpen and this.OpenPanrlCondition(navTal) then
    this.OpenPanel(navTal)
  end
  if navTal.type == TaskNavigationType.FindNpc then
    PathFinderManager.FlyTransferScene(tonumber(navTal.transferId), nil, {
      npcId = tonumber(navTal.target)
    }, Purpose.ClickNpc)
  end
  if navTal.type == TaskNavigationType.FindPos then
    PathFinderManager.JumpMapToMoveToPos(navTal.target, navTal.position1, navTal.transferId)
  end
  if navTal.type == TaskNavigationType.JumpPos then
    PathFinderManager.FlyTransferScene(tonumber(navTal.transferId), nil, nil, nil, function()
      RoleManager.me:SetAutoTaskFight(AutoFightStrKey.AutoFight)
    end)
  end
  if navTal.type == TaskNavigationType.OpenPromptBox then
    this.OpenPromptBoxPanel(navTal)
  end
  if navTal.type == TaskNavigationType.OpenGiftByObtainId then
    ClientTable.cfg_Obtain_obtainManager:JumpByObtainId(navTal.position)
  end
end

function NavigationUtility.GetNavTblForId(navId)
  if navId <= 0 then
    return
  end
  local navTal = ClientTable.cfg_Navigation_barManager:TryGetValue(tonumber(navId), "id")
  return navTal
end

function NavigationUtility.OpenPanel(navTal)
  UIManager.JumpShow(UIPanelType.SortAndHide, navTal.route, {
    openFirstTab = navTal.subSubType,
    openSecondTab = navTal.position,
    subPosition = navTal.subPosition,
    target = navTal.target,
    taskType = navTal.mainType
  })
end

function NavigationUtility.OpenPanrlCondition(navTal)
  if navTal.functionId ~= 0 and FucShowOrHideController.FuncSystemIsOpen(navTal.functionId, true) == false then
    return false
  end
  return true
end

function NavigationUtility.OpenPanelForId(navId)
  local navTal = this.GetNavTblForId(navId)
  this.OpenPanel(navTal)
end

function NavigationUtility.IsShowBtn(navTal)
  if navTal.btnCondition == TaskAddBarType.RewardConditions then
    return this.IsShowReward(navTal)
  end
  if navTal.btnCondition == TaskAddBarType.PersonageConditions then
    return this.IsShowPersonage(navTal)
  end
  if navTal.btnCondition == TaskAddBarType.BossLandConditions then
    return this.IsShowBossLand(navTal)
  end
  if navTal.btnCondition == TaskAddBarType.WarAllianceTaskConditions then
    return this.IsShowWarAllianceTask(navTal)
  end
  if navTal.btnCondition == TaskAddBarType.FirstImpactConditions then
    return this.IsShowFirstImpact(navTal)
  end
  if navTal.btnCondition == TaskAddBarType.CrossServerConditions then
    return this.IsShowCrossServerWar(navTal)
  end
end

function NavigationUtility.IsShowReward(navTal)
  local isShow = false
  for l, t in pairs(TaskData.allMonsterLevel) do
    if t <= ViewData.meData.level then
      local ifNotFinish = TaskData.GetCurMonsterLevelFinish(t)
      if ifNotFinish then
        isShow = true
      end
    end
  end
  return isShow
end

function NavigationUtility.IsShowPersonage(navTal)
  local isShow = false
  if TranScriptData.GetBossIsCdTime() then
    isShow = true
  end
  return isShow
end

function NavigationUtility.IsShowBossLand(navTal)
  local isShow = false
  if TranScriptData.GetSecretBossState() then
    isShow = true
  end
  return isShow
end

function NavigationUtility.IsShowWarAllianceTask(navTal)
  local isShow = false
  if WarAllianceData.IsHaveUnion then
    isShow = true
  end
  return isShow
end

function NavigationUtility.IsShowFirstImpact(navTal)
  local isShow = false
  if navTal.subSubType ~= nil and RechargeData.IsReceive(navTal.subSubType) then
    isShow = true
  end
  return isShow
end

function NavigationUtility.IsShowCrossServerWar(navTal)
  if navTal.functionId then
    local isShow = false
    local condition = ClientTable.cfg_Function_functionManager:TryGetValue(navTal.functionId, "id").condition
    if condition and ConditionManager.Check4D(condition) then
      isShow = true
    end
    return isShow
  end
end

function NavigationUtility.OpenPromptBoxPanel(navTal)
  if navTal.functionId ~= 0 then
    local condition = ClientTable.cfg_Function_functionManager:TryGetValue(navTal.functionId, "id").condition
    if not ConditionManager.Check4D(condition) then
      local title = ClientTable.cfg_Ui_wordManager:GetUi_wordCount("taskNav_1")
      FloatingTipUtility.QuickMsg(title)
    elseif navTal.subPosition == PromptBoxPanel.AddWarAlliance then
      local title = ClientTable.cfg_Ui_wordManager:GetUi_wordCount("TaskReward_1")
      local content = ClientTable.cfg_Ui_wordManager:GetUi_wordCount("warAllianceJoin_text")
      local okText = ClientTable.cfg_Ui_wordManager:GetUi_wordCount("warAllianceJoin_btn")
      UIManager.Show(UIID.PromptTipUI, {
        title = title,
        textContent = content,
        okText = okText,
        cancel = function()
          UIManager.Hide(UIID.PromptTipUI)
        end,
        ok = function()
          NetManager.Send(UnionMessage.ReqJoinUnion, {id = 0, join = true})
        end
      })
    end
  end
end
