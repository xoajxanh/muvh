MeAutoFightState = class()

function MeAutoFightState:ctor(autoFightManager)
  self.autoFightManager = autoFightManager
  self:InitAutoFight()
end

function MeAutoFightState:InitAutoFight()
end

function MeAutoFightState:Start()
end

function MeAutoFightState:Stop()
end

function MeAutoFightState:IsUpdateIn()
end

HookAutoFightState = class(MeAutoFightState)

function HookAutoFightState:InitAutoFight()
  self.onHookPoint = nil
  
  local function IsHasStartAutoFight()
    return QiJiHelperData.isAutoFight and LoginData.reconnectState == false
  end
  
  local function IsNotUseSkill()
    return RoleManager.me.usingSkillId == nil
  end
  
  local function IsUseXiFChiSkill()
    if not RoleManager.me.skills[11110100] then
      return false
    end
    for i, v in pairs(QiJiHelperData.selfSelSkillTab) do
      local tblSkill = ClientTable.cfg_Skill_skillManager:TryGetValue(v.id)
      local tblaction = ConfigManager.GetConfig("cfg_actionLogic", tblSkill.actionId, "groupId")
      if tblSkill.groupId ~= 11110100 and ConditionalMgr:CanReleaseSkill(tblSkill, tblaction) then
        return false
      elseif tblSkill.groupId == 11110100 then
        return true
      end
    end
    return false
  end
  
  local function IsAttackBoss()
    local target = RoleManager.me.TargetAvatar
    if target and not target.isDead then
      if target.RoleType == ERoleType.Player then
        return true
      elseif target.RoleType == ERoleType.Monster then
        return target:IsBoss()
      end
    end
  end
  
  local function IsHasTargetNearBy()
    if RoleManager.me.TargetAvatar and not RoleManager.me.TargetAvatar.isDead then
      if RoleManager.me.TargetAvatar.RoleType == ERoleType.Player then
        if not RoleUtility.TargetIsFitMyPkMode(RoleManager.me.TargetAvatar) then
          return false
        end
        if PKData.ScramblePlayerId == RoleManager.me.TargetAvatar.id then
          return true
        end
        if QiJiHelperData.selectRoleId == RoleManager.me.TargetAvatar.id then
          local returnHomeRange = tonumber(ClientTable.cfg_Global_globalManager:GetGlobalItemEffect(1190002))
          if RoleUtility.IsLessThanRangeInTheBetween(QiJiHelperData.meCellPos, RoleManager.me.TargetAvatar.serverCoord, returnHomeRange) then
            return true
          else
            RoleManager.me:SetTarget(nil)
            return false
          end
        end
        return false
      elseif RoleManager.me.TargetAvatar.RoleType == ERoleType.Monster then
        if RoleManager.me.TargetAvatar:IsBoss() then
          RoleManager.me:SetTarget(nil)
          return false
        end
        if Vector2.DistancePow(RoleManager.me.TargetAvatar.serverCoord, self.onHookPoint) > OnHookData.hookRange * OnHookData.hookRange then
          RoleManager.me:SetTarget(nil)
          return false
        end
      end
      return true
    end
    local target
    target = RoleTargetManager.GetMostRareMonsterTargetOnHook()
    if not target then
      return false
    end
    return true
  end
  
  local function IsArcher()
    local basicCareer = RoleUtility.GetBasicCareer(RoleManager.me.career)
    if basicCareer == ERoleCareer.Archer then
      return true
    end
    return false
  end
  
  local function IsHasTeam()
    return #TeamData.membersList > 1
  end
  
  local function IsNeedReturnHome()
    local limitLevel = tonumber(ClientTable.cfg_Global_globalManager:GetGlobalItemEffect(2390016))
    return (limitLevel <= RoleManager.me.level or QiJiHelperData.openReturnHome) and QiJiHelperData.SettingData.ReturnHome.IsReturn and (not RoleManager.me.TargetAvatar or RoleManager.me.TargetAvatar.isDead)
  end
  
  local root = SequenceNode({
    ConditionNode(function()
      return IsHasStartAutoFight()
    end),
    SelectorNode({
      IfNode(function()
        return IsNotUseSkill()
      end, PickupItemHookNode(self)),
      IfNode(function()
        return IsNotUseSkill()
      end, SummonSkillNode()),
      IfNode(function()
        return IsNeedReturnHome() and IsNotUseSkill()
      end, ReturnHomeNode()),
      IfNode(function()
        return IsNotUseSkill()
      end, BuffSkillNode()),
      IfNode(function()
        local res = IsArcher() and IsHasTeam() and QiJiHelperData.SettingData.AddBuffToTeammate and IsNotUseSkill()
        return res
      end, SequenceNode({
        FindNotBuffTeammateNode(),
        MoveToBuffTeammateNode(),
        AddBuffToTeammateNode()
      })),
      SequenceNode({
        IfNode(function()
          return IsNotUseSkill()
        end, IfNode(function()
          return IsHasTargetNearBy()
        end, SelectorNode({
          IfNode(function()
            return not IsAttackBoss()
          end, HookGroupSkillNode(self)),
          SequenceNode({
            FindKillScopeHookNode(),
            MoveAutoSkillRangeNode(),
            SelectorNode({
              IfNode(function()
                return IsUseXiFChiSkill()
              end, XiFChiSkillNode()),
              IndividualSkillNode()
            })
          })
        })))
      })
    })
  })
  self.hookAutoFightBt = BehaviorTree(root, self)
end

function HookAutoFightState:Start()
  if not self.hookAutoFightBt:IsUpdateIn() then
    self.onHookPoint = OnHookData.GetLinePoint()
    if not self.onHookPoint then
      FloatingWordUtility.QuickMsg("Hi\225\187\135n t\225\186\161i kh\195\180ng \225\187\159 khu v\225\187\177c treo m\195\161y kh\195\180ng th\225\187\131 b\225\186\175t \196\145\225\186\167u treo m\195\161y")
      return
    end
    QiJiHelperData.SetAutoFightData(true)
    self.hookAutoFightBt:Reset()
    self.hookAutoFightBt:Start()
  end
end

function HookAutoFightState:IsUpdateIn()
  return self.hookAutoFightBt:IsUpdateIn()
end

function HookAutoFightState:Stop()
  if self.autoFightManager:GetAutoFightState() ~= AutoFightStateEnum.Pause and not QiJiHelperData.pressSkillId then
    QiJiHelperData.SetAutoFightData(false)
  end
  self.hookAutoFightBt:Cancel()
end

RealAutoFightState = class(MeAutoFightState)

function RealAutoFightState:InitAutoFight()
  local function IsHasStartAutoFight()
    return QiJiHelperData.isAutoFight and LoginData.reconnectState == false
  end
  
  local function IsNeedReturnHome()
    local limitLevel = tonumber(ClientTable.cfg_Global_globalManager:GetGlobalItemEffect(2390016))
    return (limitLevel <= RoleManager.me.level or QiJiHelperData.openReturnHome) and QiJiHelperData.SettingData.ReturnHome.IsReturn and (not RoleManager.me.TargetAvatar or RoleManager.me.TargetAvatar.hp <= 0)
  end
  
  local function IsNotUseSkill()
    return RoleManager.me.usingSkillId == nil
  end
  
  local function IsUseXiFChiSkill()
    if not RoleManager.me.skills[11110100] then
      return false
    end
    for i, v in pairs(QiJiHelperData.selfSelSkillTab) do
      local tblSkill = ClientTable.cfg_Skill_skillManager:TryGetValue(v.id)
      local tblaction = ConfigManager.GetConfig("cfg_actionLogic", tblSkill.actionId, "groupId")
      if tblSkill.groupId ~= 11110100 and ConditionalMgr:CanReleaseSkill(tblSkill, tblaction) then
        return false
      elseif tblSkill.groupId == 11110100 then
        return true
      end
    end
    return false
  end
  
  local function IsAttackBoss()
    local target = RoleManager.me.TargetAvatar
    if target and not target.isDead then
      if target.RoleType == ERoleType.Player then
        return true
      elseif target.RoleType == ERoleType.Monster then
        return target:IsBoss()
      end
    end
  end
  
  local function IsHasTargetNearBy()
    if RoleManager.me.TargetAvatar and not RoleManager.me.TargetAvatar.isDead then
      if RoleManager.me.TargetAvatar.RoleType == ERoleType.Player then
        if not RoleUtility.TargetIsFitMyPkMode(RoleManager.me.TargetAvatar) then
          return false
        end
        if PKData.ScramblePlayerId == RoleManager.me.TargetAvatar.id then
          return true
        end
        return false
      end
      return true
    end
    local target, priority
    target, priority = RoleTargetManager.GetMonsterUnderRules()
    if not target then
      return false
    elseif target and 1 < priority or target:IsBoss() then
      RoleManager.me:SetTarget(target)
    end
    return true
  end
  
  local function IsHasPressSkill()
    if QiJiHelperData.pressSkillId then
      return true
    else
      return false
    end
  end
  
  local function IsArcher()
    local basicCareer = RoleUtility.GetBasicCareer(RoleManager.me.career)
    if basicCareer == ERoleCareer.Archer then
      return true
    end
    return false
  end
  
  local function IsHasTeam()
    return #TeamData.membersList > 1
  end
  
  local root = SequenceNode({
    ConditionNode(function()
      return IsHasStartAutoFight()
    end),
    SelectorNode({
      IfNode(function()
        return IsNotUseSkill() and IsHasPressSkill()
      end, SelectorNode({
        PressSkillGroupSkillNode(),
        SequenceNode({
          FindPressSkillMonsterNode(),
          MovePressSkillRangeNode(),
          AutoReleasePressSkillNode()
        })
      })),
      IfNode(function()
        return IsNotUseSkill() and IsHasPressSkill()
      end, SetReleaseSkillNode()),
      IfNode(function()
        return IsNotUseSkill() and not IsHasPressSkill()
      end, PickupItemNode()),
      IfNode(function()
        return IsNotUseSkill() and not IsHasPressSkill()
      end, SummonSkillNode()),
      IfNode(function()
        return IsNeedReturnHome() and IsNotUseSkill() and not IsHasPressSkill()
      end, ReturnHomeNode()),
      IfNode(function()
        return IsNotUseSkill() and not IsHasPressSkill()
      end, BuffSkillNode()),
      IfNode(function()
        local res = IsArcher() and IsHasTeam() and QiJiHelperData.SettingData.AddBuffToTeammate and IsNotUseSkill() and not IsHasPressSkill()
        return res
      end, SequenceNode({
        FindNotBuffTeammateNode(),
        MoveToBuffTeammateNode(),
        AddBuffToTeammateNode()
      })),
      SequenceNode({
        IfNode(function()
          return IsNotUseSkill() and not IsHasPressSkill()
        end, IfNode(function()
          return IsHasTargetNearBy()
        end, SelectorNode({
          IfNode(function()
            return not IsAttackBoss()
          end, SpecialGroupSkillNode()),
          SequenceNode({
            FindKillScopeNode(),
            MoveAutoSkillRangeNode(),
            SelectorNode({
              IfNode(function()
                return IsUseXiFChiSkill()
              end, XiFChiSkillNode()),
              IndividualSkillNode()
            })
          })
        })))
      })
    })
  })
  self.autoFightBt = BehaviorTree(root, self)
end

function RealAutoFightState:Start()
  if RoleManager.me.isDead then
    return
  end
  if ClientTable.cfg_Global_globalManager:CheckHideAppearanceByCurMap() then
    FloatingWordUtility.QuickMsg("Kh\195\180ng th\225\187\131 m\225\187\159 t\225\187\177 \196\145\225\187\153ng chi\225\186\191n \196\145\225\186\165u trong m\195\180i tr\198\176\225\187\157ng hi\225\187\135n t\225\186\161i")
    return
  end
  if QiJiHelperData.isAutoFight and QiJiHelperData.pressSkillId then
    local tblSkill = ClientTable.cfg_Skill_skillManager:TryGetValue(QiJiHelperData.pressSkillId)
    local tblAction = ConfigManager.GetConfig("cfg_actionLogic", tblSkill.actionId, "groupId")
    ConditionalMgr:CanReleaseSkillNoTargetTips(tblSkill, tblAction)
    if not SkillUtility.IsDontNeedTargetSkill(QiJiHelperData.pressSkillId) and not RoleUtility.IsCanAttackPlayerTips() then
      QiJiHelperData.SetPressSkill()
    end
    self.autoFightBt:Cancel()
    self.autoFightBt:Start()
  else
    QiJiHelperData.SetAutoFightData(true)
    self.autoFightBt:Cancel()
    self.autoFightBt:Start()
  end
end

function RealAutoFightState:Stop()
  self.autoFightBt:Cancel()
  if self.autoFightManager:GetAutoFightState() ~= AutoFightStateEnum.Pause then
    QiJiHelperData.SetAutoFightData(false)
  end
end

function RealAutoFightState:IsUpdateIn()
  return self.autoFightBt:IsUpdateIn()
end

CommonAutoFightState = class(MeAutoFightState)

function CommonAutoFightState:InitAutoFight()
  self:InitCommonMonsterAutoFight()
  self:InitCommonPlayerAutoFight()
end

function CommonAutoFightState:IsUseSkill()
  return RoleManager.me.usingSkillId == nil
end

function CommonAutoFightState:IsUpdateIn()
  local res1 = self.commonPlayerSkillBt:IsUpdateIn()
  local res2 = self.commonMonsterSkillBt:IsUpdateIn()
  return res1 or res2
end

function CommonAutoFightState:IsAttackBoss()
  local target = RoleManager.me.TargetAvatar
  if target then
    if target.RoleType == ERoleType.Player then
      return true
    elseif target.RoleType == ERoleType.Monster then
      return target:IsBoss()
    end
  else
    local monster = RoleTargetManager.GetMostRareMonsterTarget(false)
    if not monster then
      return false
    end
    return monster:IsBoss()
  end
  return false
end

function CommonAutoFightState:InitCommonPlayerAutoFight()
  local root = SelectorNode({
    IfNode(function()
      return (self:IsUseSkill())
    end, SummonSkillNode()),
    IfNode(function()
      return (self:IsUseSkill())
    end, BuffSkillNode()),
    IfNode(function()
      return self:IsUseSkill()
    end, SelectorNode({
      SequenceNode({
        FindNearestMonsterNode(),
        MoveSkillRangeNode(),
        BtnPlayerCommonSkillNode()
      })
    }))
  })
  self.commonPlayerSkillBt = BehaviorTree(root, self)
end

function CommonAutoFightState:InitCommonMonsterAutoFight()
  local root = SelectorNode({
    IfNode(function()
      return (self:IsUseSkill())
    end, SummonSkillNode()),
    IfNode(function()
      return (self:IsUseSkill())
    end, BuffSkillNode()),
    IfNode(function()
      return (self:IsUseSkill())
    end, SelectorNode({
      IfNode(function()
        return not self:IsAttackBoss()
      end, SpecialGroupSkillNode()),
      SequenceNode({
        FindNearestMonsterNode(),
        MoveSkillRangeNode(),
        BtnMonsterCommonSkillNode()
      })
    }))
  })
  self.commonMonsterSkillBt = BehaviorTree(root, self)
end

function CommonAutoFightState:Start()
  if self.releaseSkillBt then
    self.releaseSkillBt:Cancel()
  end
  if RoleManager.me.isDead then
    return
  end
  if not RoleManager.me.TargetAvatar or RoleManager.me.TargetAvatar.isDead then
    local roleTarget = RoleTargetManager.GetRoleTarget()
    if not roleTarget then
      return
    end
    if roleTarget.RoleType == ERoleType.Monster then
      self.releaseSkillBt = self.commonMonsterSkillBt
    elseif roleTarget.RoleType == ERoleType.Player then
      self.releaseSkillBt = self.commonPlayerSkillBt
    end
    RoleManager.me:SetTarget(roleTarget)
  elseif RoleManager.me.TargetAvatar.RoleType == ERoleType.Player then
    if not RoleUtility.IsCanAttackPlayerTips() then
      return
    end
    self.releaseSkillBt = self.commonPlayerSkillBt
  elseif RoleManager.me.TargetAvatar.RoleType == ERoleType.Monster then
    self.releaseSkillBt = self.commonMonsterSkillBt
  end
  self.releaseSkillBt:Start()
end

function CommonAutoFightState:Stop()
  if self.releaseSkillBt then
    self.releaseSkillBt:Cancel()
  end
end

PressSkillAutoFightState = class(MeAutoFightState)

function PressSkillAutoFightState:IsNotUseSkill()
  return RoleManager.me.usingSkillId == nil
end

function PressSkillAutoFightState:IsReleasePressSkill()
  return QiJiHelperData.pressSkillId ~= nil and QiJiHelperData.pressSkillId ~= 0
end

function PressSkillAutoFightState:IsHavePlayerTarget()
  return RoleManager.me.TargetAvatar ~= nil and RoleManager.me.TargetAvatar.RoleType == ERoleType.Player
end

function PressSkillAutoFightState:IsUpdateIn()
  local res1 = self.specifyPlayerSkillBt:IsUpdateIn()
  local res2 = self.specifyMonsterSkillBt:IsUpdateIn()
  return res1 or res2
end

function PressSkillAutoFightState:InitAutoFight()
  self:InitSpecifyPlayerAutoFight()
  self:InitSpecifyMonsterAutoFight()
end

function PressSkillAutoFightState:InitSpecifyPlayerAutoFight()
  local root = IfNode(function()
    return self:IsNotUseSkill() and self:IsHavePlayerTarget()
  end, SelectorNode({
    IfNode(function()
      return self:IsReleasePressSkill()
    end, SequenceNode({
      FindPressSkillMonsterNode(),
      MovePressSkillRangeNode(),
      ReleasePressSkillNode()
    })),
    IfNode(function()
      return not self:IsReleasePressSkill()
    end, SequenceNode({
      FindNearestMonsterNode(),
      MoveSkillRangeNode(),
      BtnPlayerCommonSkillNode()
    }))
  }))
  self.specifyPlayerSkillBt = BehaviorTree(root, self)
end

function PressSkillAutoFightState:InitSpecifyMonsterAutoFight()
  local root = IfNode(function()
    return self:IsNotUseSkill() and not self:IsHavePlayerTarget()
  end, SequenceNode({
    FindPressSkillMonsterNode(),
    MovePressSkillRangeNode(),
    ReleasePressSkillNode()
  }))
  self.specifyMonsterSkillBt = BehaviorTree(root, self)
  self.specifyMonsterSkillBt:SetStateCallback(function(kind)
    self:Stop()
  end, BehaviorStatusEnum.FAILED)
end

function PressSkillAutoFightState:IsUpdateIn()
  local res = self.specifySkillBt:IsUpdateIn()
  return res
end

function PressSkillAutoFightState:Start()
  local isPlayAnimation = true
  if self.specifySkillBt then
    self.specifySkillBt:Cancel()
  end
  self.specifyInitialize = false
  if RoleManager.me.isDead then
    return
  end
  local tblSkill = ClientTable.cfg_Skill_skillManager:TryGetValue(QiJiHelperData.pressSkillId)
  local tblAction = ConfigManager.GetConfig("cfg_actionLogic", tblSkill.actionId, "groupId")
  if not tblAction then
    logError("ID K\225\187\185 N\196\131ng l\195\160" .. QiJiHelperData.pressSkillId .. "B\225\186\163ng actionLogic tr\225\187\145ng")
    return
  end
  if tblAction.needTarget and tblAction.needTarget == 0 then
    if not SkillUtility.IsDontNeedTargetSkill(QiJiHelperData.pressSkillId) then
      if not RoleManager.me.TargetAvatar or RoleManager.me.TargetAvatar.isDead then
        local roleTarget = RoleTargetManager.GetRoleTarget(nil, tblSkill)
        if not roleTarget then
          FloatingTipUtility.QuickMsg("K\225\187\185 n\196\131ng n\195\160y c\225\186\167n c\195\179 m\225\187\165c ti\195\170u \196\145\225\187\131 s\225\187\173 d\225\187\165ng")
          return
        end
        RoleManager.me:SetTarget(roleTarget)
        if roleTarget.RoleType == ERoleType.Monster then
          self.specifySkillBt = self.specifyMonsterSkillBt
        elseif roleTarget.RoleType == ERoleType.Player then
          self.specifySkillBt = self.specifyPlayerSkillBt
        end
      elseif RoleManager.me.TargetAvatar.RoleType == ERoleType.Player then
        if not RoleUtility.IsCanAttackPlayerTips() then
          return
        end
        self.specifySkillBt = self.specifyPlayerSkillBt
      else
        self.specifySkillBt = self.specifyMonsterSkillBt
      end
      if not QiJiHelperData.isAutoFight then
        isPlayAnimation = ConditionalMgr:CanReleaseSkillNoSkillRangeTips(tblSkill, tblAction)
      end
      if isPlayAnimation then
        self.specifySkillBt:Start()
      end
    elseif RoleManager.me.TargetAvatar and not RoleManager.me.TargetAvatar.isDead then
      if not QiJiHelperData.isAutoFight then
        ConditionalMgr:CanReleaseSkillNoSkillRangeTips(tblSkill, tblAction)
      end
      if RoleManager.me.TargetAvatar.RoleType == ERoleType.Monster then
        self.specifySkillBt = self.specifyMonsterSkillBt
      elseif RoleManager.me.TargetAvatar.RoleType == ERoleType.Player then
        self.specifySkillBt = self.specifyPlayerSkillBt
      end
      self.specifySkillBt:Start()
    elseif not QiJiHelperData.isAutoFight and ConditionalMgr:CanReleaseSkillNoSkillRangeTips(tblSkill, tblAction) then
      SkillMgr.RequestSkillTest(QiJiHelperData.pressSkillId)
      QiJiHelperData.SetPressSkill()
    end
  else
    if ConditionalMgr:CanReleaseSkillNoSkillRangeTips(tblSkill, tblAction) then
      SkillMgr.RequestSkillTest(QiJiHelperData.pressSkillId)
      if tblSkill.summonId ~= 0 then
        QiJiHelperData.SetSummonMonsterId(tblSkill.summonId)
      end
    end
    QiJiHelperData.SetPressSkill()
  end
end

function PressSkillAutoFightState:Stop()
  if self.specifySkillBt and self.specifySkillBt:IsUpdateIn() then
    self.specifySkillBt:Cancel()
    QiJiHelperData.SetPressSkill()
    if QiJiHelperData.isAutoFight then
      RoleManager.me:SetAutoFight(AutoFightStrKey.AutoFight)
    end
  end
end

MeAutoFight = class()

function MeAutoFight:ctor()
  self:InitAutoMap()
end

function MeAutoFight:InitAutoMap()
  self.autoMap = {}
  self.autoMap[AutoFightStrKey.AutoFight] = RealAutoFightState(self)
  self.autoMap[AutoFightStrKey.ReleaseSkill] = CommonAutoFightState(self)
  self.autoMap[AutoFightStrKey.SpecifySkill] = PressSkillAutoFightState(self)
  self.autoMap[AutoFightStrKey.HookFight] = HookAutoFightState(self)
  self.autoFightState = AutoFightStateEnum.Close
  self.preAutoType = AutoFightStrKey.None
  self.autoKey = AutoFightStrKey.None
end

function MeAutoFight:GetCurAutoFightKey()
  return self.autoKey
end

function MeAutoFight:IsAutoFightOpen()
  if self.autoKey == AutoFightStrKey.AutoFight or self.autoKey == AutoFightStrKey.HookFight then
    return true
  end
end

function MeAutoFight:GetAutoFightState()
  local state = self.autoFightState
  return state
end

function MeAutoFight:MainUICloseAutoFightStart()
  self.autoFightState = AutoFightStateEnum.Close
  for k, v in pairs(self.autoMap) do
    v:Stop()
  end
end

function MeAutoFight:MainUIOpenAutoFightStart()
  self.autoFightState = AutoFightStateEnum.Open
  self.autoKey = AutoFightStrKey.AutoFight
  for k, v in pairs(self.autoMap) do
    if k ~= self.autoKey then
      v:Stop()
    end
  end
  self.autoMap[self.autoKey]:Start()
  EventManager.Dispatch(Event.StartAttack)
  EventManager.Dispatch(Event.SetIsExpShow, self.autoFightState)
end

function MeAutoFight:MoveCloseAutoFight()
  local autoState
  local mapConf = ClientTable.cfg_Map_mapManager:TryGetValue(SceneData.mapId)
  if not mapConf then
    return
  end
  if mapConf.orInterrupt == 0 then
    autoState = QiJiHelperData.isAutoFight and AutoFightStateEnum.Pause or AutoFightStateEnum.Close
  else
    autoState = AutoFightStateEnum.Close
  end
  if self.autoFightState ~= autoState then
    self.autoFightState = autoState
    EventManager.Dispatch(Event.SetIsExpShow, self.autoFightState)
  end
  self.autoKey = AutoFightStrKey.None
  for k, v in pairs(self.autoMap) do
    v:Stop()
  end
end

function MeAutoFight:SetAutoFightStart(autoKey)
  self.autoKey = autoKey
  if autoKey == AutoFightStrKey.None then
    self.autoFightState = AutoFightStateEnum.Close
    for k, v in pairs(self.autoMap) do
      v:Stop()
    end
    return
  end
  for k, v in pairs(self.autoMap) do
    if k ~= autoKey then
      v:Stop()
    end
  end
  self.autoMap[autoKey]:Start()
  EventManager.Dispatch(Event.StartAttack)
  self.autoFightState = autoKey == AutoFightStrKey.AutoFight and AutoFightStateEnum.Open or AutoFightStateEnum.Close
end

function MeAutoFight:StartPressAutoFightStart()
  self.autoKey = AutoFightStrKey.SpecifySkill
  for k, v in pairs(self.autoMap) do
    if k ~= self.autoKey then
      v:Stop()
    end
  end
  self.autoMap[self.autoKey]:Start()
  EventManager.Dispatch(Event.StartAttack)
  self.autoFightState = AutoFightStateEnum.Close
end

function MeAutoFight:SetAutoTaskFightStart(autoKey)
  if RoleManager.me.TargetAvatar and RoleManager.me.TargetAvatar.RoleType ~= ERoleType.NPC then
    RoleManager.me:SetTarget(nil)
  end
  self.autoKey = autoKey
  if autoKey == AutoFightStrKey.None then
    self.autoFightState = AutoFightStateEnum.Close
    for k, v in pairs(self.autoMap) do
      v:Stop()
    end
    return
  end
  for k, v in pairs(self.autoMap) do
    if k ~= autoKey then
      v:Stop()
    end
  end
  self.autoMap[autoKey]:Start()
  EventManager.Dispatch(Event.StartAttack)
  self.autoFightState = autoKey == AutoFightStrKey.AutoFight and AutoFightStateEnum.Open or AutoFightStateEnum.Close
end

function MeAutoFight:SetAutoFightHookStart(isOpen)
  RoleManager.me:SetTarget(nil)
  local autoKey = isOpen and AutoFightStrKey.AutoFight or AutoFightStrKey.None
  self.autoKey = AutoFightStrKey.AutoFight
  QiJiHelperData.SetAutoReturnHome(true)
  if autoKey == AutoFightStrKey.None then
    self.autoFightState = AutoFightStateEnum.Close
    for k, v in pairs(self.autoMap) do
      v:Stop()
    end
    return
  end
  for k, v in pairs(self.autoMap) do
    if k ~= autoKey then
      v:Stop()
    end
  end
  self.autoMap[autoKey]:Start()
  EventManager.Dispatch(Event.StartAttack)
  self.autoFightState = isOpen and AutoFightStateEnum.Open or AutoFightStrKey.None
end

function MeAutoFight:SetHookCardAutoFightHookStart(isOpen)
  RoleManager.me:SetTarget(nil)
  local autoKey = isOpen and AutoFightStrKey.HookFight or AutoFightStrKey.None
  self.autoKey = autoKey
  if autoKey == AutoFightStrKey.None then
    self.autoFightState = AutoFightStateEnum.Close
    for k, v in pairs(self.autoMap) do
      v:Stop()
    end
    return
  end
  QiJiHelperData.SetAutoReturnHome(true)
  for k, v in pairs(self.autoMap) do
    if k ~= autoKey then
      v:Stop()
    end
  end
  self.autoMap[autoKey]:Start()
  EventManager.Dispatch(Event.StartAttack)
  self.autoFightState = isOpen and AutoFightStateEnum.Open or AutoFightStrKey.None
end

function MeAutoFight:ReStartAutoFight()
  if self.autoKey == AutoFightStrKey.None then
    self.autoFightState = AutoFightStateEnum.Close
    for k, v in pairs(self.autoMap) do
      v:Stop()
    end
    return
  end
  for k, v in pairs(self.autoMap) do
    if k ~= self.autoKey then
      v:Stop()
    end
  end
  if self.autoMap[self.autoKey] then
    self.autoMap[self.autoKey]:Start()
  end
  QiJiHelperData.SetAutoReturnHome(QiJiHelperData.openReturnHome)
end

function MeAutoFight:StopAutoFightByAutoKey(autoKey)
  if self.autoKey == autoKey then
    self.autoKey = AutoFightStrKey.None
  end
  if self.autoMap[autoKey] then
    self.autoMap[autoKey]:Stop()
  end
end

function MeAutoFight:ReconnectCloseAutoFight()
  self:StopAutoFightByAutoKey(AutoFightStrKey.ReleaseSkill)
  self:StopAutoFightByAutoKey(AutoFightStrKey.SpecifySkill)
end
