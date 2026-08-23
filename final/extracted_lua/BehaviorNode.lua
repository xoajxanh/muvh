BehaviorNode = class()

function BehaviorNode:ctor(children)
  self.parent = nil
  self.kind = BehaviorNodeEnum.BehaviourNode
  self.children = children
  self.owner = nil
  self.status = BehaviorStatusEnum.READY
  self.lastResult = BehaviorStatusEnum.READY
  if children then
    for _, child in ipairs(children) do
      child.parent = self
    end
  end
end

function BehaviorNode:SetOwner(owner)
  self.owner = owner
  if self.children then
    for k, child in ipairs(self.children) do
      child:SetOwner(owner)
    end
  end
end

function BehaviorNode:IsKindOf(k)
  return self.kind == k
end

function BehaviorNode:Visit()
end

function BehaviorNode:Step()
  if self.status ~= BehaviorStatusEnum.RUNNING then
    self:Reset()
  elseif self.children then
    for k, v in ipairs(self.children) do
      v:Step()
    end
  end
end

function BehaviorNode:Reset()
  if self.status ~= BehaviorStatusEnum.READY then
    self.status = BehaviorStatusEnum.READY
    if self.children then
      for _, child in ipairs(self.children) do
        child:Reset()
      end
    end
  end
end

function BehaviorNode:Stop()
  if self.children then
    for _, child in ipairs(self.children) do
      child:Stop()
    end
  end
end

function BehaviorNode:SaveStatus()
  self.lastResult = self.status
  if self.children then
    for k, v in ipairs(self.children) do
      v:SaveStatus()
    end
  end
end

ConditionNode = class(BehaviorNode)

function ConditionNode:ctor(func)
  BehaviorNode.ctor(self)
  self.kind = BehaviorNodeEnum.ConditionNode
  self.func = func
end

function ConditionNode:Visit()
  if self.func and self.func() then
    self.status = BehaviorStatusEnum.SUCCESS
  else
    self.status = BehaviorStatusEnum.FAILED
  end
end

ActionNode = class(BehaviorNode)

function ActionNode:ctor(action, resetFnc)
  BehaviorNode.ctor(self)
  self.kind = BehaviorNodeEnum.ActionNode
  self.action = action
  self.resetFnc = resetFnc
end

function ActionNode:Reset()
  BehaviorNode.Reset(self)
  if self.resetFn then
    self.resetFn()
  end
end

function ActionNode:Visit()
  if self.action then
    self.action()
  end
  self.status = BehaviorStatusEnum.SUCCESS
end

SequenceNode = class(BehaviorNode)

function SequenceNode:ctor(children)
  BehaviorNode.ctor(self, children)
  self.kind = BehaviorNodeEnum.SequenceNode
  self.index = 1
end

function SequenceNode:Reset()
  self.index = 1
  BehaviorNode.Reset(self)
end

function SequenceNode:Visit()
  if self.status ~= BehaviorStatusEnum.RUNNING then
    self.index = 1
  end
  local count = #self.children
  local child, status
  while count >= self.index do
    child = self.children[self.index]
    child:Visit()
    status = child.status
    if status == BehaviorStatusEnum.RUNNING or status == BehaviorStatusEnum.FAILED then
      self.status = status
      return
    end
    self.index = self.index + 1
  end
  self.status = BehaviorStatusEnum.SUCCESS
end

SelectorNode = class(BehaviorNode)

function SelectorNode:ctor(children)
  BehaviorNode.ctor(self, children)
  self.kind = BehaviorNodeEnum.SelectorNode
  self.index = 1
end

function SelectorNode:Reset()
  self.index = 1
  BehaviorNode.Reset(self)
end

function SelectorNode:Visit()
  if self.status ~= BehaviorStatusEnum.RUNNING then
    self.index = 1
  end
  local count = #self.children
  local child, status
  while count >= self.index do
    child = self.children[self.index]
    child:Visit()
    status = child.status
    if status == BehaviorStatusEnum.SUCCESS or status == BehaviorStatusEnum.RUNNING then
      self.status = status
      return
    end
    self.index = self.index + 1
  end
  self.status = BehaviorStatusEnum.FAILED
end

ParallelNode = class(BehaviorNode)

function ParallelNode:ctor(children)
  BehaviorNode.ctor(self, children)
  self.kind = BehaviorNodeEnum.ParallelNode
  self.stopOnAnyComplete = nil
end

function ParallelNode:Step()
  if self.status ~= BehaviorStatusEnum.RUNNING then
    self:Reset()
  elseif self.children then
    for i, child in ipairs(self.children) do
      if self:IsKindOf(BehaviorNodeEnum.ConditionNode) and child.status == BehaviorStatusEnum.SUCCESS then
        child:Reset()
      end
    end
  end
end

function ParallelNode:Visit()
  local done = true
  local any_done = false
  for _, child in ipairs(self.children) do
    if child:IsKindOf(BehaviorNodeEnum.ConditionNode) then
      child:Reset()
    end
    if child.status ~= BehaviorStatusEnum.SUCCESS then
      child:Visit()
      if child.status == BehaviorStatusEnum.FAILED then
        self.status = BehaviorStatusEnum.FAILED
        return
      end
    end
    if child.status == BehaviorStatusEnum.RUNNING then
      done = false
    else
      any_done = true
    end
  end
  if done or self.stopOnAnyComplete and any_done then
    self.status = BehaviorStatusEnum.SUCCESS
  else
    self.status = BehaviorStatusEnum.RUNNING
  end
end

IfNode = class(SequenceNode)

function IfNode:ctor(condFunc, node)
  local children = {
    ConditionNode(condFunc),
    node
  }
  SequenceNode.ctor(self, children)
  self.kind = BehaviorNodeEnum.IfNode
end

PickupItemNode = class(BehaviorNode)

function PickupItemNode:ctor()
  BehaviorNode.ctor(self)
  self.kind = BehaviorNodeEnum.PickupItemNode
end

function PickupItemNode:IsCanPickUpDropItem(dropItem)
  if RoleManager.me.serverCoord == dropItem.serverCoord and RoleManager.me:IsStillState() then
    PickupManager.StartCountDown()
    self.status = BehaviorStatusEnum.SUCCESS
    return true
  end
  return false
end

function PickupItemNode:PickUpDropItem(dropItem)
  local targetCell = Vector2Int(dropItem.serverCoord.x, dropItem.serverCoord.y)
  if targetCell == RoleManager.me.cellPos and targetCell ~= RoleManager.me.serverCoord and RoleManager.me:IsStillState() then
    RoleManager.me:MoveTo(RoleManager.me.serverCoord)
    return
  end
  RoleManager.me:MoveTo(targetCell)
end

function PickupItemNode:Visit()
  local dropItem
  if QiJiHelperData.autoPickupDelay and Time.GetServerTime() < QiJiHelperData.autoPickupDelay then
    self.status = BehaviorStatusEnum.READY
    return
  end
  dropItem = DropItemManager.GetNearestDropItem()
  if not dropItem then
    self.status = BehaviorStatusEnum.FAILED
    return
  end
  if self.status == BehaviorStatusEnum.READY then
    if self:IsCanPickUpDropItem(dropItem) then
    else
      self.status = BehaviorStatusEnum.RUNNING
      self:PickUpDropItem(dropItem)
    end
  elseif self.status ~= BehaviorStatusEnum.RUNNING or self:IsCanPickUpDropItem(dropItem) then
  elseif RoleManager.me:IsStillState() then
    self.status = BehaviorStatusEnum.FAILED
  end
end

PickupItemHookNode = class(PickupItemNode)

function PickupItemHookNode:ctor(hookFight)
  BehaviorNode.ctor(self)
  self.hookFight = hookFight
  self.kind = BehaviorNodeEnum.PickupItemNode
end

function PickupItemHookNode:Visit()
  local dropItem
  if QiJiHelperData.autoPickupDelay and Time.GetServerTime() < QiJiHelperData.autoPickupDelay then
    self.status = BehaviorStatusEnum.READY
    return
  end
  dropItem = DropItemManager.GetNearestDropItemInHookRange(self.hookFight.onHookPoint)
  if not dropItem then
    self.status = BehaviorStatusEnum.FAILED
    return
  end
  if self.status == BehaviorStatusEnum.READY then
    if self:IsCanPickUpDropItem(dropItem) then
    else
      self.status = BehaviorStatusEnum.RUNNING
      self:PickUpDropItem(dropItem)
    end
  elseif self.status ~= BehaviorStatusEnum.RUNNING or self:IsCanPickUpDropItem(dropItem) then
  elseif RoleManager.me:IsStillState() then
    self.status = BehaviorStatusEnum.FAILED
  end
end

GroupSkillNode = class(BehaviorNode)

function GroupSkillNode:ctor()
  BehaviorNode.ctor(self)
  self.kind = BehaviorNodeEnum.GroupSkillNode
end

function GroupSkillNode:ReleaseGroupSkill()
  if QiJiHelperData.groupSkillId then
    self.status = BehaviorStatusEnum.SUCCESS
    SkillMgr.RequestSkillTest(QiJiHelperData.groupSkillId)
  else
    self.status = BehaviorStatusEnum.FAILED
  end
end

function GroupSkillNode:ReleaseSkillWhenMonsterInMyRange()
  local target = RoleManager.me.TargetAvatar
  local meCell = RoleManager.me.serverCoord
  local range = Mathf.Max(Mathf.Abs(target.serverCoord.x - meCell.x), Mathf.Abs(target.serverCoord.y - meCell.y))
  local tblSkill = ClientTable.cfg_Skill_skillManager:TryGetValue(QiJiHelperData.groupSkillId)
  local releaseDistance = tblSkill.releaseDistance
  local serverArrive = range <= releaseDistance
  local res = serverArrive
  if res then
    self:ReleaseGroupSkill()
  end
  return res
end

function GroupSkillNode:MovePosWhenMonsterNotInMyRange()
  local target = RoleManager.me.TargetAvatar
  local tblSkill = ClientTable.cfg_Skill_skillManager:TryGetValue(QiJiHelperData.groupSkillId)
  local releaseDistance = tblSkill.releaseDistance
  local targetCell = Vector2Int(target.serverCoord.x, target.serverCoord.y)
  RoleManager.me:MoveTo(targetCell, releaseDistance)
end

function GroupSkillNode:ReleaseSkillWhenMeLocateCorrectPos(targetCell)
  local res = RoleManager.me.serverCoord == targetCell and RoleManager.me:IsStillState()
  if res then
    self:ReleaseGroupSkill()
    return true
  end
  return false
end

function GroupSkillNode:MovePosWhenMeNotLocateCorrectPos(targetCell)
  RoleManager.me:MoveTo(targetCell)
end

SpecialGroupSkillNode = class(GroupSkillNode)

function SpecialGroupSkillNode:Visit()
  local clickMonster, skillPosOrMonster, targetType
  if RoleManager.me.TargetAvatar and not RoleManager.me.TargetAvatar.isDead then
    skillPosOrMonster, targetType = AutoFightFindTargetManager.IsHasMoreThanOneSpMonsterInSkillRangePosNew(RoleManager.me.TargetAvatar)
  else
    skillPosOrMonster, targetType = AutoFightFindTargetManager.IsHasMoreThanOneMonsterInSkillRangePosNew()
    clickMonster = skillPosOrMonster
  end
  if not skillPosOrMonster then
    self.status = BehaviorStatusEnum.FAILED
    return
  end
  if self.status == BehaviorStatusEnum.READY then
    RoleManager.me:StopMove()
    self.status = BehaviorStatusEnum.RUNNING
    if targetType == "Pos" then
      self:ReleaseGroupSkill()
    elseif targetType == "Monster" then
      if clickMonster then
        RoleManager.me:SetTarget(clickMonster)
      end
      local res = self:ReleaseSkillWhenMonsterInMyRange()
      if not res then
        self:MovePosWhenMonsterNotInMyRange()
      end
    end
  end
  if self.status == BehaviorStatusEnum.RUNNING then
    if targetType == "Pos" then
      self:ReleaseGroupSkill()
    elseif targetType == "Monster" then
      if clickMonster then
        RoleManager.me:SetTarget(clickMonster)
      end
      if self:ReleaseSkillWhenMonsterInMyRange() then
      elseif RoleManager.me:IsStillState() then
        self.status = BehaviorStatusEnum.FAILED
      end
    end
  end
end

HookGroupSkillNode = class(SpecialGroupSkillNode)

function HookGroupSkillNode:ctor(hookFight)
  BehaviorNode.ctor(self)
  self.hookFight = hookFight
  self.kind = BehaviorNodeEnum.GroupSkillNode
end

function HookGroupSkillNode:Visit()
  local clickMonster, skillPosOrMonster, targetType
  if RoleManager.me.TargetAvatar and not RoleManager.me.TargetAvatar.isDead then
    skillPosOrMonster, targetType = AutoFightFindTargetManager.IsHasMoreThanOneSpMonsterInSkillRangePosHook(RoleManager.me.TargetAvatar, self.hookFight.onHookPoint)
  else
    skillPosOrMonster, targetType = AutoFightFindTargetManager.IsHasMoreThanOneMonsterInSkillRangeHook(self.hookFight.onHookPoint)
    clickMonster = skillPosOrMonster
  end
  if not skillPosOrMonster then
    self.status = BehaviorStatusEnum.FAILED
    return
  end
  if self.status == BehaviorStatusEnum.READY then
    RoleManager.me:StopMove()
    self.status = BehaviorStatusEnum.RUNNING
    if targetType == "Pos" then
      if RoleManager.me:IsStillState() then
        self:ReleaseGroupSkill()
      end
    elseif targetType == "Monster" then
      if clickMonster then
        RoleManager.me:SetTarget(clickMonster)
      end
      local res = self:ReleaseSkillWhenMonsterInMyRange()
      if not res then
        self:MovePosWhenMonsterNotInMyRange()
      end
    end
  end
  if self.status == BehaviorStatusEnum.RUNNING then
    if targetType == "Pos" then
      if RoleManager.me:IsStillState() then
        self:ReleaseGroupSkill()
      end
    elseif targetType == "Monster" then
      if clickMonster then
        RoleManager.me:SetTarget(clickMonster)
      end
      if self:ReleaseSkillWhenMonsterInMyRange() then
      elseif RoleManager.me:IsStillState() then
        self.status = BehaviorStatusEnum.FAILED
      end
    end
  end
end

PressSkillGroupSkillNode = class(BehaviorNode)

function PressSkillGroupSkillNode:ctor()
  BehaviorNode.ctor(self)
  self.kind = BehaviorNodeEnum.PressSkillGroupSkillNode
end

function PressSkillGroupSkillNode:Visit()
  local tblSkill = ClientTable.cfg_Skill_skillManager:TryGetValue(QiJiHelperData.pressSkillId)
  local tblAction = ConfigManager.GetConfig("cfg_actionLogic", tblSkill.actionId, "groupId")
  if not tblAction then
    logError("ID K\225\187\185 N\196\131ng l\195\160" .. tblSkill.id .. "action c\225\187\167a k\225\187\185 n\196\131ng tr\225\187\145ng")
    self.status = BehaviorStatusEnum.FAILED
    return
  end
  if tblAction.needTarget and tblAction.needTarget == 1 then
    if ConditionalMgr:CanReleaseSkill(tblSkill, tblAction) then
      SkillMgr.RequestSkillTest(QiJiHelperData.pressSkillId)
      self.status = BehaviorStatusEnum.SUCCESS
      if tblSkill.summonId ~= 0 then
        QiJiHelperData.SetSummonMonsterId(tblSkill.summonId)
      end
      if not QiJiHelperData.isAutoFight then
        RoleManager.me:MainUICloseAutoFightStart()
        Coroutine.Break()
      end
    else
      self.status = BehaviorStatusEnum.FAILED
    end
  else
    self.status = BehaviorStatusEnum.FAILED
  end
end

XiFChiSkillNode = class(BehaviorNode)

function XiFChiSkillNode:ctor()
  BehaviorNode.ctor(self)
  self.isCanUse = false
  self.kind = BehaviorNodeEnum.XiFChiSkillNode
end

function XiFChiSkillNode:Visit()
  local skillId = RoleManager.me.skills[11110100].sid
  local tblSkill = ClientTable.cfg_Skill_skillManager:TryGetValue(skillId)
  local tblaction = ConfigManager.GetConfig("cfg_actionLogic", tblSkill.actionId, "groupId")
  if not ConditionalMgr:CanReleaseSkillNoCd(tblSkill, tblaction) then
    self.status = BehaviorStatusEnum.FAILED
    return
  end
  if not RoleManager.me.TargetAvatar or RoleManager.me.TargetAvatar.isDead then
    self.status = BehaviorStatusEnum.FAILED
    return
  end
  if self.status == BehaviorStatusEnum.READY and SkillUtility.GetXIFChiSurplusCount() == SkillUtility.GetChargingTimes(tblSkill) then
    self.isCanUse = true
  end
  if self.status == BehaviorStatusEnum.READY then
    if SkillUtility.GetXIFChiSurplusCount() == 0 then
      self.status = BehaviorStatusEnum.FAILED
      self.isCanUse = false
    elseif self.isCanUse then
      SkillMgr.RequestSkillTest(skillId)
      self.status = BehaviorStatusEnum.SUCCESS
    else
      self.status = BehaviorStatusEnum.FAILED
    end
  end
end

IndividualSkillNode = class(BehaviorNode)

function IndividualSkillNode:ctor()
  BehaviorNode.ctor(self)
  self.kind = BehaviorNodeEnum.IndividualSkillNode
end

function IndividualSkillNode:ReleaseIndividualSkill()
  for i, v in pairs(QiJiHelperData.selfSelSkillTab) do
    local tblSkill = ClientTable.cfg_Skill_skillManager:TryGetValue(v.id)
    if QiJiHelperData.IsIndSkill(v.id) then
      local tblAction = ConfigManager.GetConfig("cfg_actionLogic", tblSkill.actionId, "groupId")
      if ConditionalMgr:CanReleaseSkill(tblSkill, tblAction) and QiJiHelperData.IsNotAutoUseSkill(tblSkill) and AutoFightFindTargetManager.IsCanAttackTargetTypeAutoGoTargetSkill(v.id) and RoleTargetManager.IsTargetHasBuff(RoleManager.me.TargetAvatar, tblSkill.buff, tblSkill.buffSkillAuto) then
        self.status = BehaviorStatusEnum.SUCCESS
        SkillMgr.RequestSkillTest(v.id)
        return 1
      end
    end
  end
  return 0
end

function IndividualSkillNode:NoXFCReleaseIndividualSkill()
  for i, v in pairs(QiJiHelperData.selfSelSkillTab) do
    local tblSkill = ClientTable.cfg_Skill_skillManager:TryGetValue(v.id)
    if QiJiHelperData.IsIndSkill(v.id) then
      local tblAction = ConfigManager.GetConfig("cfg_actionLogic", tblSkill.actionId, "groupId")
      if ConditionalMgr:CanReleaseSkill(tblSkill, tblAction) and QiJiHelperData.IsNotAutoUseSkill(tblSkill) and tblSkill.groupId ~= 11110100 and AutoFightFindTargetManager.IsCanAttackTargetTypeAutoGoTargetSkill(v.id) and RoleTargetManager.IsTargetHasBuff(RoleManager.me.TargetAvatar, tblSkill.buff) then
        self.status = BehaviorStatusEnum.SUCCESS
        SkillMgr.RequestSkillTest(v.id)
        return 1
      end
    end
  end
  return 0
end

function IndividualSkillNode:Visit()
  local res = self:NoXFCReleaseIndividualSkill()
  if res == 1 then
    self.status = BehaviorStatusEnum.SUCCESS
  elseif res == 0 then
    self.status = BehaviorStatusEnum.FAILED
  end
end

ReturnHomeNode = class(BehaviorNode)

function ReturnHomeNode:ctor()
  BehaviorNode.ctor(self)
  self.kind = BehaviorNodeEnum.ReturnHomeNode
end

function ReturnHomeNode:Visit()
  local nextReturnTime = QiJiHelperData.nextReturnHomeTime
  if nextReturnTime > Time.GetServerSecondTime() then
    self.status = BehaviorStatusEnum.FAILED
    return
  end
  local targetCell = QiJiHelperData.meCellPos
  if self.status == BehaviorStatusEnum.READY then
    self.status = BehaviorStatusEnum.RUNNING
    if RoleManager.me.serverCoord == targetCell and RoleManager.me:IsStillState() then
      self.status = BehaviorStatusEnum.SUCCESS
      QiJiHelperController.ResetReturnHomeTime()
      return
    end
    RoleManager.me:MoveTo(targetCell)
  end
  if self.status == BehaviorStatusEnum.RUNNING then
    if RoleManager.me.serverCoord == targetCell and RoleManager.me:IsStillState() then
      self.status = BehaviorStatusEnum.SUCCESS
      QiJiHelperController.ResetReturnHomeTime()
      return
    end
    if RoleManager.me:IsStillState() then
      self.status = BehaviorStatusEnum.FAILED
    end
  end
end

BtnPlayerCommonSkillNode = class(IndividualSkillNode)

function BtnPlayerCommonSkillNode:Visit()
  local res = self:ReleaseIndividualSkill()
  if res == 1 then
    self.status = BehaviorStatusEnum.FAILED
  elseif res == 0 then
    self.status = BehaviorStatusEnum.FAILED
  end
end

BtnMonsterCommonSkillNode = class(IndividualSkillNode)

function BtnMonsterCommonSkillNode:Visit()
  local res = self:ReleaseIndividualSkill()
  if res == 1 then
    self.status = BehaviorStatusEnum.SUCCESS
  elseif res == 0 then
    self.status = BehaviorStatusEnum.FAILED
  end
end

SummonSkillNode = class(BehaviorNode)

function SummonSkillNode:ctor()
  BehaviorNode.ctor(self)
  self.kind = BehaviorNodeEnum.SummonSkillNode
end

function SummonSkillNode:Visit()
  if RoleUtility.GetBasicCareer(RoleManager.me.career) ~= ERoleCareer.Archer then
    self.status = BehaviorStatusEnum.FAILED
    return
  end
  local summonSkill = QiJiHelperData.SettingData.selfSelSummonSkill
  if not summonSkill or summonSkill == 0 then
    self.status = BehaviorStatusEnum.FAILED
    return
  end
  local tblSkill = ClientTable.cfg_Skill_skillManager:TryGetValue(summonSkill)
  local tblAction = ConfigManager.GetConfig("cfg_actionLogic", tblSkill.actionId, "groupId")
  if not ConditionalMgr:CanReleaseSkill(tblSkill, tblAction) then
    self.status = BehaviorStatusEnum.FAILED
    return
  end
  if RoleManager.me.summonMonster and 0 < RoleManager.me.summonMonster.hp then
    local monsterConfig = ClientTable.cfg_Monster_monsterManager:TryGetValue(RoleManager.me.summonMonster.data.configId)
    local skillTblMonsterConfig = ClientTable.cfg_Monster_monsterManager:TryGetValue(tblSkill.summonId)
    local qijiHelperMonsterConfig = ClientTable.cfg_Monster_monsterManager:TryGetValue(QiJiHelperData.summonMonsterId)
    if skillTblMonsterConfig ~= nil and monsterConfig.subType == skillTblMonsterConfig.subType then
      self.status = BehaviorStatusEnum.FAILED
    elseif qijiHelperMonsterConfig ~= nil and monsterConfig.subType == qijiHelperMonsterConfig.subType then
      self.status = BehaviorStatusEnum.FAILED
    else
      SkillMgr.RequestSkillTest(summonSkill)
      self.status = BehaviorStatusEnum.SUCCESS
      QiJiHelperData.SetSummonMonsterId(0)
    end
  else
    SkillMgr.RequestSkillTest(summonSkill)
    self.status = BehaviorStatusEnum.SUCCESS
    QiJiHelperData.SetSummonMonsterId(0)
  end
end

UseHpMedNode = class(BehaviorNode)

function UseHpMedNode:ctor()
  BehaviorNode.ctor(self)
  self.recoverHpItems = {}
  local hpPriority = string.split(ClientTable.cfg_Global_globalManager:GetGlobalItemEffect(2390004), "&")
  for i = 1, #hpPriority do
    self.recoverHpItems[i] = tonumber(hpPriority[i])
  end
  self.HpItemsCount = #self.recoverHpItems
  self.kind = BehaviorNodeEnum.UseHpMedNode
end

function UseHpMedNode:Visit()
  if not RoleManager.me or RoleManager.me.isDead or LoginData.reconnectState then
    self.status = BehaviorStatusEnum.FAILED
    return
  end
  if RoleManager.me.hp / RoleManager.me.maxHp >= QiJiHelperData.SettingData.recoverHp then
    self.status = BehaviorStatusEnum.SUCCESS
  else
    for i, v in ipairs(self.recoverHpItems) do
      local hpItem = BagInfoData.GetItemByConfigID(v)
      if hpItem and ConditionalMgr:CanUseItem(v) then
        local useItemTbl = {
          useCount = 1,
          useItemId = hpItem.id,
          configId = v,
          useParam = hpItem.tblItem.useParam,
          params = nil
        }
        PlayerControlForceData.ComparePromptBuyDrugState(v)
        ItemUtility.UseItem(useItemTbl)
        self.status = BehaviorStatusEnum.SUCCESS
        return
      end
    end
    self.status = BehaviorStatusEnum.FAILED
    if PlayerControlForceData.autoBuyDrugState then
      local buy = 0
      for i, v in pairs(self.recoverHpItems) do
        if not BagInfoData.GetItemByConfigID(v) then
          buy = buy + 1
        end
      end
      if buy == self.HpItemsCount then
        CommercializeData.AutomaticHpBuydrug(self.recoverHpItems)
      end
    end
  end
end

UseMpMedNode = class(BehaviorNode)

function UseMpMedNode:ctor()
  BehaviorNode.ctor(self)
  self.recoverMpItems = {}
  local mpPriority = string.split(ClientTable.cfg_Global_globalManager:GetGlobalItemEffect(2390005), "&")
  for i = 1, #mpPriority do
    self.recoverMpItems[i] = tonumber(mpPriority[i])
  end
  self.MPItemsCount = #self.recoverMpItems
  self.kind = BehaviorNodeEnum.UseMpMedNode
end

function UseMpMedNode:Visit()
  if not RoleManager.me or RoleManager.me.isDead or LoginData.reconnectState then
    self.status = BehaviorStatusEnum.FAILED
    return
  end
  if RoleManager.me.mp / RoleManager.me.maxMp >= QiJiHelperData.SettingData.recoverMp then
    self.status = BehaviorStatusEnum.SUCCESS
  else
    for i, v in ipairs(self.recoverMpItems) do
      local mpItem = BagInfoData.GetItemByConfigID(v)
      if mpItem and ConditionalMgr:CanUseItem(v) then
        local useItemTbl = {
          useCount = 1,
          useItemId = mpItem.id,
          configId = v,
          useParam = mpItem.tblItem.useParam,
          params = nil
        }
        ItemUtility.UseItem(useItemTbl)
        self.status = BehaviorStatusEnum.SUCCESS
        return
      end
    end
    self.status = BehaviorStatusEnum.FAILED
    if PlayerControlForceData.autoBuyDrugState then
      local buy = 0
      for i, v in pairs(self.recoverMpItems) do
        if not BagInfoData.GetItemByConfigID(v) then
          buy = buy + 1
        end
      end
      if buy == self.MPItemsCount then
        CommercializeData.AutomaticMpBuydrug(self.recoverMpItems)
      end
    end
  end
end

FindNearestMonsterNode = class(BehaviorNode)

function FindNearestMonsterNode:ctor()
  BehaviorNode.ctor(self)
  self.kind = BehaviorNodeEnum.FindNearestMonsterNode
end

function FindNearestMonsterNode:GetMonster()
  local monster = RoleTargetManager.GetMostRareMonsterTarget(false)
  return monster
end

function FindNearestMonsterNode:IsArrive(skillRange)
  local meCell = RoleManager.me.serverCoord
  local target = RoleManager.me.TargetAvatar
  local range = Mathf.Max(Mathf.Abs(target.serverCoord.x - meCell.x), Mathf.Abs(target.serverCoord.y - meCell.y))
  local serverArrive = skillRange >= range
  return serverArrive
end

function FindNearestMonsterNode:GetSkillRange()
  for i, v in pairs(QiJiHelperData.selfSelSkillTab) do
    local tblSkill = ClientTable.cfg_Skill_skillManager:TryGetValue(v.id)
    if QiJiHelperData.IsIndSkill(v.id) then
      local tblAction = ConfigManager.GetConfig("cfg_actionLogic", tblSkill.actionId, "groupId")
      if ConditionalMgr:CanReleaseSkillNoSkillRange(tblSkill, tblAction) and AutoFightFindTargetManager.IsCanAttackTargetTypeAutoGoTargetSkill(v.id) and RoleTargetManager.IsTargetHasBuff(RoleManager.me.TargetAvatar, tblSkill.buff) then
        return tblSkill.releaseDistance
      end
    end
  end
  return 0
end

function FindNearestMonsterNode:Visit()
  if RoleManager.me.TargetAvatar == nil or RoleManager.me.TargetAvatar.isDead then
    local monster = self:GetMonster()
    if monster == nil then
      self.status = BehaviorStatusEnum.FAILED
      return
    end
    RoleManager.me:SetTarget(monster)
  else
    if RoleManager.me.TargetAvatar.RoleType == ERoleType.Player and not RoleUtility.TargetIsFitMyPkMode(RoleManager.me.TargetAvatar) then
      self.status = BehaviorStatusEnum.FAILED
      RoleManager.me:SetAutoTaskFight(AutoFightStrKey.None)
      return
    end
    local stopRange = self:GetSkillRange()
    if not self:IsArrive(stopRange) then
      local reachable, path = Scene.SearchTilePath(RoleManager.me.cellPos, RoleManager.me.TargetAvatar.serverCoord, stopRange, true)
      if not reachable then
        RoleManager.me:SetTarget(nil)
        self.status = BehaviorStatusEnum.FAILED
        return
      end
    end
  end
  self.status = BehaviorStatusEnum.SUCCESS
end

FindMonsterAttackNode = class(FindNearestMonsterNode)

function FindMonsterAttackNode:GetSkillRange()
  for i, v in pairs(QiJiHelperData.selfSelSkillTab) do
    local tblSkill = ClientTable.cfg_Skill_skillManager:TryGetValue(v.id)
    if QiJiHelperData.IsIndSkill(v.id) then
      local tblAction = ConfigManager.GetConfig("cfg_actionLogic", tblSkill.actionId, "groupId")
      if ConditionalMgr:CanReleaseSkillNoSkillRange(tblSkill, tblAction) and AutoFightFindTargetManager.IsCanAttackTargetTypeAutoGoTargetSkill(v.id) and RoleTargetManager.IsTargetHasBuff(RoleManager.me.TargetAvatar, tblSkill.buff) then
        return tblSkill.releaseDistance
      end
    end
  end
  return 0
end

function FindMonsterAttackNode:Visit()
  if RoleManager.me.TargetAvatar == nil or RoleManager.me.TargetAvatar.isDead then
    local monster = self:GetMonster()
    if monster == nil then
      self.status = BehaviorStatusEnum.FAILED
      return
    end
    RoleManager.me:SetTarget(monster)
  else
    if RoleManager.me.TargetAvatar.RoleType == ERoleType.Player and not RoleUtility.TargetIsFitMyPkMode(RoleManager.me.TargetAvatar) then
      self.status = BehaviorStatusEnum.FAILED
      return
    end
    local stopRange = self:GetSkillRange()
    local reachable, path = Scene.SearchTilePath(RoleManager.me.cellPos, RoleManager.me.TargetAvatar.serverCoord, stopRange, true)
    if not reachable then
      RoleManager.me:SetTarget(nil)
      self.status = BehaviorStatusEnum.FAILED
      return
    end
  end
  self.status = BehaviorStatusEnum.SUCCESS
end

FindKillScopeNode = class(FindMonsterAttackNode)

function FindKillScopeNode:ctor()
  BehaviorNode.ctor(self)
  self.kind = BehaviorNodeEnum.FindNearestMonsterNode
end

function FindKillScopeNode:GetMonster()
  return RoleTargetManager.GetMonsterUnderRules()
end

function FindKillScopeNode:IsArrive(skillRange)
  local meCell = RoleManager.me.serverCoord
  local target = RoleManager.me.TargetAvatar
  local range = Mathf.Max(Mathf.Abs(target.serverCoord.x - meCell.x), Mathf.Abs(target.serverCoord.y - meCell.y))
  local serverArrive = skillRange >= range
  return serverArrive
end

function FindKillScopeNode:Visit()
  if RoleManager.me.TargetAvatar == nil or RoleManager.me.TargetAvatar.isDead then
    local monster
    monster = self:GetMonster()
    if monster == nil then
      self.status = BehaviorStatusEnum.FAILED
      return
    end
    RoleManager.me:SetTarget(monster)
  else
    if RoleManager.me.TargetAvatar.RoleType == ERoleType.Player and not RoleUtility.TargetIsFitMyPkMode(RoleManager.me.TargetAvatar) then
      self.status = BehaviorStatusEnum.FAILED
      return
    end
    local stopRange = self:GetSkillRange()
    if not self:IsArrive(stopRange) then
      local reachable, path = Scene.SearchTilePath(RoleManager.me.cellPos, RoleManager.me.TargetAvatar.serverCoord, stopRange, true)
      if not reachable then
        RoleManager.me:SetTarget(nil)
        self.status = BehaviorStatusEnum.FAILED
        return
      end
    end
  end
  self.status = BehaviorStatusEnum.SUCCESS
end

FindKillScopeHookNode = class(FindKillScopeNode)

function FindKillScopeHookNode:GetMonster()
  return RoleTargetManager.GetMostRareMonsterTargetOnHook()
end

FindPressSkillMonsterNode = class(FindKillScopeNode)

function FindPressSkillMonsterNode:GetSkillRange()
  if not QiJiHelperData.pressSkillId then
    return 0
  end
  local tblSkill = ClientTable.cfg_Skill_skillManager:TryGetValue(QiJiHelperData.pressSkillId)
  local tblAction = ConfigManager.GetConfig("cfg_actionLogic", tblSkill.actionId, "groupId")
  if ConditionalMgr:CanReleaseSkillNoSkillRange(tblSkill, tblAction) then
    return tblSkill.releaseDistance
  end
  return 0
end

function FindPressSkillMonsterNode:Visit()
  if not RoleManager.me.TargetAvatar or RoleManager.me.TargetAvatar.isDead then
    if SkillUtility.IsDontNeedTargetSkill(QiJiHelperData.pressSkillId) then
      self.status = BehaviorStatusEnum.SUCCESS
      return
    end
    local monster
    monster = self:GetMonster()
    if monster == nil then
      self.status = BehaviorStatusEnum.FAILED
      return
    end
    RoleManager.me:SetTarget(monster)
  else
    if not SkillUtility.IsDontNeedTargetSkill(QiJiHelperData.pressSkillId) and RoleManager.me.TargetAvatar.RoleType == ERoleType.Player and not RoleUtility.TargetIsFitMyPkMode(RoleManager.me.TargetAvatar) then
      self.status = BehaviorStatusEnum.FAILED
      return
    end
    local stopRange = self:GetSkillRange()
    if not self:IsArrive(stopRange) then
      local reachable, path = Scene.SearchTilePath(RoleManager.me.cellPos, RoleManager.me.TargetAvatar.serverCoord, stopRange, true)
      if not reachable then
        self.status = BehaviorStatusEnum.FAILED
        return
      end
    end
  end
  self.status = BehaviorStatusEnum.SUCCESS
end

MoveNode = class(BehaviorNode)

function MoveNode:ctor(target)
  BehaviorNode.ctor(self)
  self.target = target
  self.range = 1
  self.kind = BehaviorNodeEnum.MoveNode
end

function MoveNode:IsArrive()
  local meCell = RoleManager.me.serverCoord
  local range = Mathf.Max(Mathf.Abs(self.target.serverCoord.x - meCell.x), Mathf.Abs(self.target.serverCoord.y - meCell.y))
  local serverArrive = range <= self.range
  return serverArrive
end

function MoveNode:Visit()
  if self.target then
    local targetCell = self.target.serverCoord
    if self.status == BehaviorStatusEnum.READY then
      QiJiHelperData.targetCell = targetCell:Clone()
      if self:IsArrive() then
        self.status = BehaviorStatusEnum.SUCCESS
        RoleManager.me:StopMove()
      elseif Main_JoyStickUI.movingWithJoyStick then
        self.status = BehaviorStatusEnum.FAILED
      else
        self.status = BehaviorStatusEnum.RUNNING
        if RoleManager.me.serverCoord ~= RoleManager.me.cellPos then
          local serverCoord = RoleManager.me.serverCoord:Clone()
          RoleManager.me:MoveTo(serverCoord)
          return
        end
        local releaseDistance = self.range == 1 and 1 or self.range
        RoleManager.me:MoveTo(targetCell, releaseDistance)
      end
    elseif self.status == BehaviorStatusEnum.RUNNING then
      if self:IsArrive() then
        self.status = BehaviorStatusEnum.SUCCESS
        RoleManager.me:StopMove()
      elseif QiJiHelperData.targetCell ~= targetCell then
        self.status = BehaviorStatusEnum.SUCCESS
        QiJiHelperData.targetCell = Vector2Int(targetCell.x, targetCell.y)
        local releaseDistance = self.range == 1 and 1 or self.range
        RoleManager.me:MoveTo(targetCell, releaseDistance)
      elseif RoleManager.me:IsStillState() then
        self.status = BehaviorStatusEnum.FAILED
      end
    end
  else
    self.status = BehaviorStatusEnum.FAILED
  end
end

MoveSkillRangeNode = class(MoveNode)

function MoveSkillRangeNode:Visit()
  self.range = self:GetSkillRange()
  self.target = RoleManager.me.TargetAvatar
  if self.range == 0 then
    self:GetTestSkillRange()
    self.status = BehaviorStatusEnum.FAILED
    return
  end
  MoveNode.Visit(self)
end

function MoveSkillRangeNode:GetTestSkillRange()
  for i, v in pairs(QiJiHelperData.selfSelSkillTab) do
    local tblSkill = ClientTable.cfg_Skill_skillManager:TryGetValue(v.id)
    if QiJiHelperData.IsIndSkill(v.id) then
      local tblAction = ConfigManager.GetConfig("cfg_actionLogic", tblSkill.actionId, "groupId")
      local res, name = ConditionalMgr:CanReleaseSkillNoSkillRange(tblSkill, tblAction)
      if not res then
      end
    end
  end
end

function MoveSkillRangeNode:GetSkillRange()
  for i, v in pairs(QiJiHelperData.selfSelSkillTab) do
    local tblSkill = ClientTable.cfg_Skill_skillManager:TryGetValue(v.id)
    if QiJiHelperData.IsIndSkill(v.id) then
      local tblAction = ConfigManager.GetConfig("cfg_actionLogic", tblSkill.actionId, "groupId")
      if ConditionalMgr:CanReleaseSkillNoSkillRange(tblSkill, tblAction) and AutoFightFindTargetManager.IsCanAttackTargetTypeAutoGoTargetSkill(v.id) and RoleTargetManager.IsTargetHasBuff(RoleManager.me.TargetAvatar, tblSkill.buff) and QiJiHelperData.IsNotAutoUseSkill(tblSkill) then
        return tblSkill.releaseDistance
      end
    end
  end
  return 0
end

MoveAutoSkillRangeNode = class(MoveSkillRangeNode)

function MoveAutoSkillRangeNode:Visit()
  MoveSkillRangeNode.Visit(self)
end

function MoveAutoSkillRangeNode:GetSkillRange()
  for i, v in pairs(QiJiHelperData.selfSelSkillTab) do
    local tblSkill = ClientTable.cfg_Skill_skillManager:TryGetValue(v.id)
    if QiJiHelperData.IsIndSkill(v.id) and QiJiHelperData.IsNotAutoUseSkill(tblSkill) then
      local tblAction = ConfigManager.GetConfig("cfg_actionLogic", tblSkill.actionId, "groupId")
      local res, name = ConditionalMgr:CanReleaseSkillNoSkillRange(tblSkill, tblAction)
      if res and AutoFightFindTargetManager.IsCanAttackTargetTypeAutoGoTargetSkill(v.id) and RoleTargetManager.IsTargetHasBuff(RoleManager.me.TargetAvatar, tblSkill.buff) then
        if RoleManager.me.skills[11110100] then
          local specialSkillId = RoleManager.me.skills[11110100].sid
          if v.id ~= specialSkillId then
            return tblSkill.releaseDistance
          else
            local count = SkillUtility.GetXIFChiSurplusCount()
            if count == SkillUtility.GetChargingTimes(tblSkill) then
              return tblSkill.releaseDistance
            end
          end
        else
          return tblSkill.releaseDistance
        end
      end
    end
  end
  return 0
end

MovePressSkillRangeNode = class(MoveSkillRangeNode)

function MovePressSkillRangeNode:Visit()
  if SkillUtility.IsDontNeedTargetSkill(QiJiHelperData.pressSkillId) then
    self.status = BehaviorStatusEnum.SUCCESS
    return
  end
  self.range = self:GetSkillRange()
  self.target = RoleManager.me.TargetAvatar
  if self.range == 0 then
    self.status = BehaviorStatusEnum.FAILED
    return
  end
  MoveSkillRangeNode.Visit(self)
end

function MovePressSkillRangeNode:GetSkillRange()
  if not QiJiHelperData.pressSkillId then
    return 0
  end
  local tblSkill = ClientTable.cfg_Skill_skillManager:TryGetValue(QiJiHelperData.pressSkillId)
  local tblAction = ConfigManager.GetConfig("cfg_actionLogic", tblSkill.actionId, "groupId")
  if ConditionalMgr:CanReleaseSkillNoSkillRange(tblSkill, tblAction) then
    return gameMgr:GetAvatarManager():GetMainPlayer():GetSkillManager():GetSKillGroupAdditionManager():GetSkillAfterAdditionValue(tblSkill.id, ESkillGroupAdditionType.RANGE)
  end
  return 0
end

ReleasePressSkillNode = class(BehaviorNode)

function ReleasePressSkillNode:ctor()
  BehaviorNode.ctor(self)
  self.kind = BehaviorNodeEnum.ReleasePressSkillNode
end

function ReleasePressSkillNode:ReleasePressSkill()
  if not QiJiHelperData.pressSkillId then
    return 0
  end
  local tblSkill = ClientTable.cfg_Skill_skillManager:TryGetValue(QiJiHelperData.pressSkillId)
  local tblAction = ConfigManager.GetConfig("cfg_actionLogic", tblSkill.actionId, "groupId")
  if ConditionalMgr:CanReleaseSkill(tblSkill, tblAction) then
    SkillMgr.RequestSkillTest(QiJiHelperData.pressSkillId)
    return 1
  end
  return 0
end

function ReleasePressSkillNode:Visit()
  local res = self:ReleasePressSkill()
  if res == 1 then
    self.status = BehaviorStatusEnum.FAILED
  elseif res == 0 then
    self.status = BehaviorStatusEnum.FAILED
  end
end

AutoReleasePressSkillNode = class(ReleasePressSkillNode)

function AutoReleasePressSkillNode:ReleasePressSkill()
  local tblSkill = ClientTable.cfg_Skill_skillManager:TryGetValue(QiJiHelperData.pressSkillId)
  local tblAction = ConfigManager.GetConfig("cfg_actionLogic", tblSkill.actionId, "groupId")
  local res, name = ConditionalMgr:CanReleaseSkill(tblSkill, tblAction)
  if res then
    SkillMgr.RequestSkillTest(QiJiHelperData.pressSkillId)
    if not QiJiHelperData.isAutoFight then
      RoleManager.me:MainUICloseAutoFightStart()
      Coroutine.Break()
    end
    return 1
  else
    logPurple("K\225\187\185 n\196\131ng kh\195\180ng th\225\187\131 s\225\187\173 d\225\187\165ng:", res, name)
  end
  return 0
end

function AutoReleasePressSkillNode:Visit()
  local res = self:ReleasePressSkill()
  if res == 1 then
    self.status = BehaviorStatusEnum.SUCCESS
  elseif res == 0 then
    self.status = BehaviorStatusEnum.FAILED
  end
end

BuffSkillNode = class(BehaviorNode)

function BuffSkillNode:ctor()
  BehaviorNode.ctor(self)
  self.kind = BehaviorNodeEnum.BuffSkillNode
end

function BuffSkillNode:HasBuff(buffStr)
  local buffIds = string.split(buffStr, "#")
  for i = 1, #buffIds do
    if BuffData.IsHasBuff(RoleManager.me.id, tonumber(buffIds[i])) then
      return true
    end
  end
  return false
end

function BuffSkillNode:ReleaseBuffSkill()
  for i, v in pairs(RoleManager.me.skills) do
    local skillData = ClientTable.cfg_Skill_skillManager:TryGetValue(v.sid)
    if skillData.autoSkillType == AutoSkillEnum.BuffSkill then
      local isOpen = QiJiHelperData.GetBuffSkill(skillData.groupId).isOpen
      if isOpen and not self:HasBuff(skillData.buff) and QiJiHelperData.IsNotAutoUseSkill(skillData) then
        local tblSkill = ClientTable.cfg_Skill_skillManager:TryGetValue(skillData.id)
        local tblAction = ConfigManager.GetConfig("cfg_actionLogic", tblSkill.actionId, "groupId")
        if ConditionalMgr:CanReleaseSkill(tblSkill, tblAction) then
          SkillMgr.RequestSkillToMe(skillData.id)
          return 1
        end
      end
    end
  end
  return 0
end

function BuffSkillNode:Visit()
  local res = self:ReleaseBuffSkill()
  if res == 1 then
    self.status = BehaviorStatusEnum.SUCCESS
  elseif res == 0 then
    self.status = BehaviorStatusEnum.FAILED
  end
end

SetReleaseSkillNode = class(BehaviorNode)

function SetReleaseSkillNode:ctor()
  BehaviorNode.ctor(self)
  self.kind = BehaviorNodeEnum.SetReleaseSkillNode
end

function SetReleaseSkillNode:Visit()
  if QiJiHelperData.pressSkillId then
    QiJiHelperData.SetPressSkill()
    self.status = BehaviorStatusEnum.SUCCESS
  else
    self.status = BehaviorStatusEnum.FAILED
  end
  if not QiJiHelperData.isAutoFight then
    RoleManager.me:MainUICloseAutoFightStart()
    Coroutine.Break()
  end
end

FindNotBuffTeammateNode = class(BehaviorNode)

function FindNotBuffTeammateNode:ctor()
  BehaviorNode.ctor(self)
  self.kind = BehaviorNodeEnum.FindNotBuffTeammateNode
end

function FindNotBuffTeammateNode:Visit()
  for i = 1, #TeamData.membersList do
    local member = TeamData.membersList[i]
    local roleId = member.rid
    local role = RoleManager.GetRoleById(roleId)
    if role and not role.isDead and role.id ~= RoleManager.me.id and not RoleUtility.TargetIsFitMyPkMode(role) and RoleUtility.IsInTheRangeOfScope(role, QiJiHelperData.SettingData.KillMonsterScope) and QiJiHelperData.IsCanSetBuffSkillToTeammate(role) then
      QiJiHelperData.SetBuffTeammateRole(roleId)
      self.status = BehaviorStatusEnum.SUCCESS
      return
    end
  end
  self.status = BehaviorStatusEnum.FAILED
end

MoveToBuffTeammateNode = class(MoveNode)

function MoveToBuffTeammateNode:ctor()
  BehaviorNode.ctor(self)
  self.kind = BehaviorNodeEnum.MoveToBuffTeammateNode
end

function MoveToBuffTeammateNode:Visit()
  self.range = self:GetSkillRange()
  self.target = RoleManager.GetRoleById(QiJiHelperData.teammateRoleId)
  if self.range == 0 then
    self.status = BehaviorStatusEnum.FAILED
    return
  end
  MoveNode.Visit(self)
end

function MoveToBuffTeammateNode:GetSkillRange()
  local tblSkill = ClientTable.cfg_Skill_skillManager:TryGetValue(QiJiHelperData.teammateBuffSkillId)
  return tblSkill.releaseDistance
end

AddBuffToTeammateNode = class(BehaviorNode)

function AddBuffToTeammateNode:ctor()
  BehaviorNode.ctor(self)
  self.kind = BehaviorNodeEnum.AddBuffToTeammate
end

function AddBuffToTeammateNode:ReleaseTeammateBuffSkill()
  if not QiJiHelperData.teammateBuffSkillId then
    return 0
  end
  local tblSkill = ClientTable.cfg_Skill_skillManager:TryGetValue(QiJiHelperData.teammateBuffSkillId)
  local tblAction = ConfigManager.GetConfig("cfg_actionLogic", tblSkill.actionId, "groupId")
  if ConditionalMgr:CanReleaseSkill(tblSkill, tblAction) then
    SkillMgr.RequestSkillToOthersRole(QiJiHelperData.teammateBuffSkillId, QiJiHelperData.teammateRoleId)
    return 1
  end
  return 0
end

function AddBuffToTeammateNode:Visit()
  local res = self:ReleaseTeammateBuffSkill()
  if res == 1 then
    self.status = BehaviorStatusEnum.SUCCESS
  elseif res == 0 then
    self.status = BehaviorStatusEnum.FAILED
  end
end
