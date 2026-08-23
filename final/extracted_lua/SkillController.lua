require("GameModel/SkillData")
require("GamePlay/FightFramework/SkillUtility")
SkillController = {}
local this = SkillController
local path

function SkillController.Init()
  this.messageContainer = EventContainer(NetManager)
  this.eventContainer = EventContainer(EventManager)
  this.RegistEvent()
  this.RegistMessages()
  path = CS.System.IO.Path.Combine(CS.UnityEngine.Application.persistentDataPath, "skillInfo")
  CS.Framework.DirectoryEx.CreateDirectory(path)
end

function SkillController.RegistMessages()
  this.messageContainer:Regist(FightMessage.ResBroadcastUseSkill, this.ResPrecastSkill)
  this.messageContainer:Regist(FightMessage.ResPlayerUseSkill, this.ResCastSkill)
  this.messageContainer:Regist(FightMessage.ResUseSubSkill, this.ResUseSubSkill)
  this.messageContainer:Regist(SkillMessage.ResLearnSkill, this.OnResLearnSkill)
  this.messageContainer:Regist(FightMessage.ResDamageList, this.ResDamageData)
end

function SkillController:ResDamageData(data)
  SkillData.SetAllAttackData(data)
end

function SkillController.ResPrecastSkill(_, data)
  if data.attackerId == ViewData.meData.id then
    return
  end
  local skill_struct = SkillUtility.ConstructSkillFromServerData(data)
  if skill_struct.attacker == nil then
    ServerViewFixer.AddUsingSkillMissingRole(skill_struct.attackerId, skill_struct.attackerX, skill_struct.attackerY)
  end
  this.PerformClientSkill(skill_struct)
end

function SkillController.ShowBlood(skillData)
  local attacker = RoleManager.GetRoleById(skillData.attackerId)
  local target = RoleManager.GetRoleById(skillData.targetId)
  if attacker and attacker.RoleType == ERoleType.Player then
    attacker.Head:ShowBloodActive()
  end
  if target and target.RoleType == ERoleType.Player then
    target.Head:ShowBloodActive()
  end
  for i = 1, #skillData.hurtList do
    local roleId = skillData.hurtList[i].targetId
    local hurtTarget = RoleManager.GetRoleById(roleId)
    if hurtTarget and hurtTarget.RoleType == ERoleType.Player then
      hurtTarget.Head:ShowBloodActive()
    end
  end
end

function SkillController.ResCastSkill(_, data)
  SkillController.ResCastSkillAsync(data)
end

function SkillController.ResCastSkillCallBack(data)
  local skill_struct = SkillUtility.ConstructSkillFromServerData(data)
  if skill_struct.attacker == nil then
    ServerViewFixer.AddUsingSkillMissingRole(skill_struct.attackerId, skill_struct.attackerX, skill_struct.attackerY)
  end
  if skill_struct.tblSkill.effect > 0 then
    if data.attackerId ~= ViewData.meData.id and not data.precast then
      this.PerformClientSkill(skill_struct)
    end
    this.PerformServerSkill(skill_struct, data)
  end
  this.ApplySkillEffect(skill_struct, data)
  this.ShowBlood(skill_struct)
  ExpAddData.AddPetHurt(data)
  EventManager.Dispatch(Event.MeHurtByOthersSkill, {
    attacker = skill_struct.attackerId,
    target = skill_struct.targetId,
    skillId = skill_struct.skillId
  })
end

function SkillController.SkillCallBackSync(data)
  local skill_struct = SkillUtility.ConstructSkillFromServerData(data)
  this.ApplySkillEffect(skill_struct, data)
end

function SkillController.SkillCallBackAsync(data)
  local skill_struct = SkillUtility.ConstructSkillFromServerData(data)
  if skill_struct.attacker == nil then
    ServerViewFixer.AddUsingSkillMissingRole(skill_struct.attackerId, skill_struct.attackerX, skill_struct.attackerY)
  end
  if skill_struct.tblSkill.effect > 0 then
    if data.attackerId ~= ViewData.meData.id and not data.precast then
      this.PerformClientSkill(skill_struct)
    end
    this.PerformServerSkill(skill_struct, data)
  end
  this.ShowBlood(skill_struct)
  ExpAddData.AddPetHurt(data)
  EventManager.Dispatch(Event.MeHurtByOthersSkill, {
    attacker = skill_struct.attackerId,
    target = skill_struct.targetId,
    skillId = skill_struct.skillId
  })
end

SkillController.SingleRefreshCount = 20
SkillController.RefreshList = nil
SkillController.IsRefresh = false
SkillController.CastSkillAsyncCoroutine = nil

function SkillController.ResCastSkillAsync(data)
  if SkillController.RefreshList == nil then
    SkillController.RefreshList = Queue:New()
  end
  if RoleManager.me.id == data.attackerId or RoleManager.me.id == data.targetId or data.state then
    SkillController.ResCastSkillCallBack(data)
  else
    SkillController.RefreshList:PushLast(data)
    SkillController.SkillCallBackSync(data)
    if SkillController.IsRefresh == false then
      SkillController.CastSkillAsyncCoroutine = Coroutine.Start(SkillController.StartResCastSkillAsync)
    end
  end
end

function SkillController.StartResCastSkillAsync()
  SkillController.IsRefresh = true
  local refreshCount, data = 0
  Coroutine.Yield()
  while 0 < SkillController.RefreshList:Count() do
    refreshCount = refreshCount + 1
    if refreshCount > SkillController.SingleRefreshCount then
      Coroutine.Yield()
      refreshCount = 0
    end
    data = SkillController.RefreshList:PopFirst()
    SkillController.SkillCallBackAsync(data)
  end
  SkillController.TryClearCastSkillAsyncCoroutine()
  SkillController.IsRefresh = false
end

function SkillController.TryClearCastSkillAsyncCoroutine()
  if SkillController.CastSkillAsyncCoroutine ~= nil then
    Coroutine.Stop(SkillController.CastSkillAsyncCoroutine)
    SkillController.CastSkillAsyncCoroutine = nil
  end
end

function SkillController.ClearAllCastSkillData()
  SkillController.IsRefresh = false
  SkillController.RefreshList = nil
end

function SkillController.ResUseSubSkill(_, data)
  local skill_struct = SkillUtility.ConstructSkillFromServerData(data)
  if skill_struct.attacker == nil then
    ServerViewFixer.AddUsingSkillMissingRole(skill_struct.attackerId, skill_struct.attackerX, skill_struct.attackerY)
  end
  local hurt
  for i = 1, #data.hurtList do
    hurt = data.hurtList[i]
    if hurt.hp == nil then
      hurt.hp = 0
    end
    ViewData.ChangeRoleHp(hurt.targetId, hurt.hp)
    ViewData.ChangeRoleServerPos(hurt.targetId, hurt.x, hurt.y)
    local hurtTarget = RoleManager.GetRoleById(hurt.targetId)
    if hurtTarget and hurtTarget.RoleType == ERoleType.Player then
      hurtTarget.Head:ShowBloodActive()
    end
  end
  ExpAddData.AddHurt(data)
  ActionManager.PlayHitActions(skill_struct, data)
end

local function RoleMeHurtSceneInteractionState(hurt)
  if hurt.targetId == ViewData.meData.id and Scene.sitPos and (ViewData.meData.serverCoord.x ~= hurt.x or ViewData.meData.serverCoord.y ~= hurt.y) then
    EventManager.Dispatch(Event.Role_CheckSitState, {
      x = hurt.x,
      y = hurt.y,
      animation = "idle"
    })
  end
end

function SkillController.ApplySkillEffect(skill_struct, data)
  local hurt
  for i = 1, #data.hurtList do
    hurt = data.hurtList[i]
    ViewData.ChangeRoleHp(hurt.targetId, hurt.hp)
    RoleMeHurtSceneInteractionState(hurt)
    ViewData.ChangeRoleServerPos(hurt.targetId, hurt.x, hurt.y)
  end
  if data.attackerId then
    ViewData.ChangeRoleMp(data.attackerId, data.mp)
  end
  if skill_struct.attacker then
    skill_struct.attacker.data:SetServerPos(skill_struct.attackerX, skill_struct.attackerY)
  end
  ActionManager.PlayHitActions(skill_struct, data)
  QiJiHelperController.StrikeBack(data)
  ExpAddData.AddHurt(data)
end

local LookTargetPos = Vector3.zero

function SkillController.LookSkillDir(skill_struct)
  if not skill_struct.attacker then
    return
  end
  local skillRangeCfg = SkillUtility.GetSkillRangesConfig(skill_struct.skillId)
  local dir = SkillUtility.GetSkillRangeDir(skillRangeCfg, skill_struct.chooseRangeIndex)
  if dir then
    skill_struct.attacker:SetRotation(dir)
  elseif skill_struct.targetId and skill_struct.targetId ~= 0 then
    skill_struct.attacker:LookAtTarget(skill_struct.targetId)
  else
    Scene.GetPosByCellNoGC(skill_struct, LookTargetPos)
    skill_struct.attacker:LookAt(LookTargetPos, false)
  end
end

function SkillController.PerformClientSkill(skill_struct)
  if not skill_struct.notChangeDir then
    this.LookSkillDir(skill_struct)
  end
  if not skill_struct.skillConfig then
    logError("L\225\187\151i thi tri\225\187\131n k\225\187\185 n\196\131ng!", skill_struct.skillId)
    return
  end
  ActionManager.PlayClientActions(skill_struct)
  BaseSkill.DisposeAni(skill_struct)
  BaseSkill.DisposeEffect(skill_struct)
  BaseSkill.DisposeCameraEffect(skill_struct)
end

function SkillController.PerformServerSkill(skill_struct, skillMsg)
  if not skill_struct.skillConfig then
    logError("L\225\187\151i thi tri\225\187\131n k\225\187\185 n\196\131ng!", skill_struct.skillId)
    return
  end
  SkillData.SetSkillStructActionConfig(skill_struct)
  BaseSkill.AddSkill(skill_struct)
  ActionManager.PlayServerActions(skill_struct, skillMsg)
end

function SkillController.OnResLearnSkill(eventId, data)
  if data and data.forgetSkill ~= 0 then
    MeController.RemoveSkillData(data.forgetSkill)
    local skillConfig = ClientTable.cfg_Skill_skillManager:TryGetValue(data.forgetSkill)
    local skillData = RoleManager.me.skills[skillConfig.groupId]
    if not skillData then
      SkillSettingData.RemovePanAllSkill(data.forgetSkill)
      QiJiHelperData.ForgetSkill(data.forgetSkill)
      SkillData.RemoveSkillData({
        sid = data.forgetSkill
      })
    elseif skillData and data.forgetSkill > skillData.sid then
      SkillSettingData.SetPanSkillWhenLearnNewSkill(skillData.sid)
      QiJiHelperData.LearnSkill(skillData.sid)
      SkillData.UpdateSkillData(skillData)
    end
  end
  if data and data.skillInfo then
    local skillConfig = ClientTable.cfg_Skill_skillManager:TryGetValue(data.skillInfo.sid)
    local skillData = RoleManager.me.skills[skillConfig.groupId]
    MeController.AddSkillData(data.skillInfo)
    if not skillData or data.skillInfo.sid > skillData.sid then
      SkillData.UpdateSkillData(data.skillInfo)
      SkillSettingData.SetPanSkillWhenLearnNewSkill(data.skillInfo.sid)
      QiJiHelperData.LearnSkill(data.skillInfo.sid)
    end
  end
  EventManager.Dispatch(Event.Skill_SkillRedPoint)
end

function SkillController.RegistEvent()
  this.eventContainer:Regist(Event.Skill_Upgrade, this.OnReqLearnSkill)
end

function SkillController.OnReqLearnSkill(eventId, skillId)
  local msg = {skillId = skillId}
  NetManager.Send(SkillMessage.ReqLearnSkill, msg)
end

function SkillController.LeaveGame()
  SkillController.TryClearCastSkillAsyncCoroutine()
  SkillController.ClearAllCastSkillData()
end
