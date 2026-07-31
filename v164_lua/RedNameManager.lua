RedNameManager = {}
local this = RedNameManager
this.intervalTipTime = 60
this.intervalHurtUITime = 1
this.redNameData = {}
this.showHurtUITime = 0

function RedNameManager.OnEnterGame()
  this.RegistEvents()
end

function RedNameManager.RegistEvents()
  this.eventContainer = EventContainer(EventManager)
  this.eventContainer:Regist(Event.MeHurtByOthersSkill, this.MeHurtByOthersSkill)
  this.eventContainer:Regist(Event.WarAlliance_MyWarAllianceData, this.UpdateRedNameHead)
  this.eventContainer:Regist(Event.Camp_ChangeUnionCamp, this.UpdateRedNameHead)
end

function RedNameManager.MeHurtByOthersSkill(_, attackInfo)
  local target = RoleManager.GetRoleById(attackInfo.targetId)
  local attacker = RoleManager.GetRoleById(attackInfo.attackerId)
  local isDamageSkill = true
  if not attackInfo.skillId then
    isDamageSkill = true
  else
    local cfg_skill = ClientTable.cfg_Skill_skillManager:TryGetValue(attackInfo.skillId)
    if cfg_skill.bufftype == BuffType.Buff then
      isDamageSkill = false
    end
  end
  if target and attacker and attacker.RoleType == ERoleType.Player and target.id == ViewData.meData.id and attacker.id ~= ViewData.meData.id and isDamageSkill then
    this.ShowHurtUI()
    this.ShowBeAttackTips(attacker)
  end
end

function RedNameManager.ShowHurtUI()
  local mapConfig = ClientTable.cfg_Map_mapManager:TryGetValue(SceneData.mapId)
  if mapConfig.redscreen == 0 then
    return
  end
  if not UIManager.IsVisible(UIID.HurtUI) then
    UIManager.Show(UIID.HurtUI)
  end
  this.showHurtUITime = Time.GetServerSecondTime()
end

function RedNameManager.ShowBeAttackTips(role)
  if this.redNameData[role.id] then
    return
  end
  this.redNameData[role.id] = Time.GetServerSecondTime()
  FloatingWordUtility.QuickMsg(string.format("B\225\186\161n \196\145ang b\225\187\139 <color=%s>%s</color> t\225\186\165n c\195\180ng", ERoleEvilNameColor16[role.evilLevel], role.name))
end

function RedNameManager.UpdateRedNameHead()
  RoleManager.RefreshHeadColor()
end

function RedNameManager.OnLeaveGame()
  if this.eventContainer then
    this.eventContainer:UnRegistAll()
  end
end

function RedNameManager.UnRegistAll()
  if this.eventContainer then
    this.eventContainer:UnRegistAll()
  end
end

function RedNameManager.Update()
  for k, v in pairs(this.redNameData) do
    if Time.GetServerSecondTime() - v > this.intervalTipTime then
      this.redNameData[k] = nil
    end
  end
  if UIManager.IsVisible(UIID.HurtUI) and Time.GetServerSecondTime() - this.showHurtUITime > this.intervalHurtUITime then
    UIManager.Hide(UIID.HurtUI)
  end
end
