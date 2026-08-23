OnHookData = {}
local this = OnHookData
OnHookData.isOpenHookPanel = false
OnHookData.onHookId = 0
OnHookData.OnLineData = {
  onHookTime = 0,
  expInfoTbl = {}
}
OnHookData.OffLineData = {
  onHookTime = 0,
  expInfoTbl = {}
}
OnHookData.items = {}
OnHookData.logs = {}
OnHookData.getExpInfoList = {}

function OnHookData.NewExpInfo(exp, additionExp, commerceExp)
  local expInfo = {}
  expInfo.onHookEXP = exp and exp.EXP or 0
  expInfo.additionExp = additionExp and additionExp.EXP or 0
  expInfo.commerceExp = commerceExp and commerceExp.EXP or 0
  return expInfo
end

function OnHookData.NewGetExpInfo(expType, getExpType, exp, money)
  local getExpInfo = {}
  getExpInfo.exp = exp and exp or {time = 0, EXP = 0}
  getExpInfo.money = money and money or 0
  getExpInfo.expType = expType and expType or 0
  getExpInfo.getExpType = getExpType and getExpType or 0
  return getExpInfo
end

function OnHookData.TryInsertGetExpInfoList(expType, getExpType, exp, money)
  if expType == nil or getExpType == nil or exp == nil or exp.EXP <= 0 then
    return
  end
  local getExpInfo = OnHookData.NewGetExpInfo(expType, getExpType, exp, money)
  table.insert(OnHookData.getExpInfoList, getExpInfo)
end

function OnHookData.Reset()
  this.logs = {}
  for i = #OnHookData.getExpInfoList, 1, -1 do
    table.remove(OnHookData.getExpInfoList)
  end
  OnHookData.OnLineData.onHookTime = 0
  OnHookData.OnLineData.expInfoTbl = {}
  OnHookData.OffLineData.onHookTime = 0
  OnHookData.OnLineData.expInfoTbl = {}
end

function OnHookData.InitOnHookData(data)
  if not data then
    return
  end
  this.logs = data.log
  if not OnHookData.ExpAddBuffInfo then
    OnHookData.ExpAddBufferInfoTbl()
  end
  for i = #OnHookData.getExpInfoList, 1, -1 do
    table.remove(OnHookData.getExpInfoList)
  end
  OnHookData.TryInsertGetExpInfoList(OnHookExpTypeEnum.Rein, OnHookGetExpEnum.Exp, data.canGetEXP)
  OnHookData.TryInsertGetExpInfoList(OnHookExpTypeEnum.Rein, OnHookGetExpEnum.CoinExp, data.moneyEXP, data.money)
  OnHookData.TryInsertGetExpInfoList(OnHookExpTypeEnum.Rein, OnHookGetExpEnum.MedicineExp, data.buffEXP)
  OnHookData.TryInsertGetExpInfoList(OnHookExpTypeEnum.Holy, OnHookGetExpEnum.Exp, data.canGetRingEXP)
  OnHookData.TryInsertGetExpInfoList(OnHookExpTypeEnum.Holy, OnHookGetExpEnum.CoinExp, data.moneyRingEXP, data.moneyRing)
  OnHookData.TryInsertGetExpInfoList()
  OnHookData.OnLineData.onHookTime = data.fight and data.fight.time or 0
  OnHookData.OnLineData.expInfoTbl[OnHookExpTypeEnum.Rein] = OnHookData.NewExpInfo(data.fight, nil, data.fightCommerceExp)
  OnHookData.OnLineData.expInfoTbl[OnHookExpTypeEnum.Holy] = OnHookData.NewExpInfo(data.fightRing, nil, nil)
  OnHookData.OffLineData.onHookTime = data.stand and data.stand.time or 0
  OnHookData.OffLineData.expInfoTbl[OnHookExpTypeEnum.Rein] = OnHookData.NewExpInfo(data.stand, data.standBuff, data.standCommerceExp)
  OnHookData.OffLineData.expInfoTbl[OnHookExpTypeEnum.Holy] = OnHookData.NewExpInfo(data.standRing, data.standRingBuff, nil)
  OnHookData.ExpAddBufferInfoTbl()[OnHookExpTypeEnum.Rein].value = tostring(math.floor(data.expRate / 100))
  OnHookData.ExpAddBufferInfoTbl()[OnHookExpTypeEnum.Holy].value = tostring(math.floor(data.ringExpRate / 100))
  EventManager.Dispatch(Event.RP_RedPointRefresh, {
    index = ERedPointType.hookProfit,
    state = true
  })
  if UIManager.IsVisible(UIID.OnHook) then
    EventManager.Dispatch(Event.RefreshOnHookInfo)
  else
    if (not OnHookData.getExpInfoList or #OnHookData.getExpInfoList <= 0) and (not OnHookData.logs or #OnHookData.logs == 0) then
      return
    end
    EventManager.Dispatch(Event.InsertAutoPopUI, UIID.OnHook)
  end
end

function OnHookData.IsHasOffLineData()
  if (not OnHookData.getExpInfoList or #OnHookData.getExpInfoList <= 0) and (not OnHookData.logs or #OnHookData.logs == 0) then
    return false
  end
  return true
end

function OnHookData.CheckRedPointState()
  local flag = false
  for i, getExpInfo in ipairs(OnHookData.getExpInfoList) do
    if getExpInfo.getExpType == OnHookGetExpEnum.Exp then
      if getExpInfo.exp and getExpInfo.exp.EXP > 0 then
        flag = true
      end
    elseif getExpInfo.getExpType == OnHookGetExpEnum.CoinExp then
      local ownGold = BagInfoData.GetItemTotalCountByItemId(ECoinsType.integral)
      if ownGold >= getExpInfo.money then
        flag = true
      end
    elseif getExpInfo.getExpType == OnHookGetExpEnum.MedicineExp then
      local medTime = ExpAddData.MultipleTime and ExpAddData.MultipleTime or 0
      local timer = math.floor(medTime)
      if timer >= getExpInfo.exp.time then
        flag = true
      end
    end
  end
  return flag
end

function OnHookData.IsReachLinePoint()
  if RoleManager.me then
    local pos = RoleManager.me.serverCoord
    local cfgs = ConfigManager.FindConfigs("cfg_OnHook_OnLinePoint", "mapId", SceneData.groupId)
    for _, v in ipairs(cfgs) do
      local nums = string.splitToNumbers(v.position)
      local range = Mathf.Max(Mathf.Abs(nums[1] - pos.x), Mathf.Abs(nums[2] - pos.y))
      if range <= v.bornRange then
        return true
      end
    end
  end
  return false
end

this.hookRange = 6

function OnHookData.GetLinePoint()
  if RoleManager.me then
    local pos = RoleManager.me.serverCoord
    local cfgs = ConfigManager.FindConfigs("cfg_OnHook_OnLinePoint", "mapId", SceneData.groupId)
    for _, v in ipairs(cfgs) do
      local nums = string.splitToNumbers(v.position)
      local range = Mathf.Max(Mathf.Abs(nums[1] - pos.x), Mathf.Abs(nums[2] - pos.y))
      if range <= v.bornRange then
        return Vector2(nums[1], nums[2])
      end
    end
  end
end

function OnHookData.IsKillMonsterCardLinePoint()
  if RoleManager.me then
    local pos = RoleManager.me.serverCoord
    local cfgs = ConfigManager.FindConfigs("cfg_OnHook_OnLinePoint", "mapId", SceneData.groupId)
    for _, v in ipairs(cfgs) do
      local nums = string.splitToNumbers(v.position)
      local range = Mathf.Max(Mathf.Abs(nums[1] - pos.x), Mathf.Abs(nums[2] - pos.y))
      local res1, res2
      if range <= v.bornRange then
        res1 = true
      end
      if range <= this.hookRange then
        res2 = true
      end
      if res1 or res2 then
        return res1, res2
      end
    end
  end
  return false, false
end

function OnHookData.ExpAddBufferInfoTbl()
  if not OnHookData.ExpAddBuffInfo then
    local info = table.DeepCopy(ClientTable.cfg_Ui_wordManager:GetExpAddBufferInfoTbl())
    OnHookData.ExpAddBuffInfo = info
    return info
  end
  return OnHookData.ExpAddBuffInfo
end
