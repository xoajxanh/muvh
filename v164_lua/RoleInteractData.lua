RoleInteractData = {}
local this = RoleInteractData
this.roleId = nil
this.teamId = nil
this.serverId = nil
this.unionId = nil
this.roleName = nil
this.career = nil
this.unionName = nil
this.unionPosition = nil
this.fight = nil
this.level = nil
this.isOnline = true
this.interactType = nil
this.equipData = {}

function RoleInteractData.Init(data)
  local teamId = data and data.teamId or 0
  local equipData = {}
  if data ~= nil then
    equipData = RoleEquipData(data.equips)
  else
    equipData = RoleEquipData(equipData)
  end
  if this.interactType == RoleOpenType.WarOpen then
    this.equipData = equipData
    return
  end
  local curRole = {
    serverId = this.serverId,
    interactType = this.interactType,
    online = this.isOnline,
    roleId = this.roleId,
    mapId = data.mapId,
    serverId = this.serverId,
    roleName = this.roleName,
    unionName = this.unionName,
    unionPosition = this.unionPosition,
    teamId = teamId,
    fightValue = this.fight,
    career = this.career,
    level = this.level,
    unionId = this.unionId,
    equipData = equipData,
    maxHp = 0,
    hp = 0,
    maxMp = 0,
    mp = 0
  }
  if data.reqFlag == OtherRoleOpenSource.TeamOpen then
    if RoleInteractData.ctr ~= nil and UIManager.IsVisible(UIID.TeamTempUI) then
      local ui = UIManager.GetUiByName(UIID.TeamTempUI)
      if ui ~= nil then
        local checkPlayerList = ShowBtnItemUtility.GetConditionBtns(curRole)
        ui:RetBtnsUI(RoleInteractData.ctr, #checkPlayerList)
        ui:RefreshBtns(checkPlayerList)
      end
      RoleInteractData.ctr = nil
    end
  else
    UIManager.Show(UIID.Team_RoleInteractUI, curRole)
  end
  this.interactType = nil
  this.isOnline = true
end

function RoleInteractData:TeamTempSetData(data)
  self.ctr = data.ctr
end

RoleInteractData.HpMPUIPlayerid = nil

function RoleInteractData.PlayerLookShowUI(role, type)
  if PKData.ScramblePlayerId == role.data.id then
    PKData.ScramblePlayerId = nil
  end
  if RedFortData.activityState == ActivityStatusEnum.RUNNING then
    logPurple("SK Ph\195\161o \196\144\195\160i \196\144\225\187\143 \196\145ang m\225\187\159, \225\186\163nh \196\145\225\186\161i di\225\187\135n \196\145\195\163 b\225\187\139 t\225\186\175t")
    return
  end
  if role.data.id ~= this.HpMPUIPlayerid and UIManager.IsVisible(UIID.PlayerHpMPInfoUI) then
    UIManager.Hide(UIID.PlayerHpMPInfoUI)
    RoleInteractData.HpMPUIPlayerid = role.data.id
  end
  local roleInteractTable = {
    interactType = type,
    online = true,
    roleId = role.data.id,
    mapId = role.data.data.info.mapId,
    hostId = role.data.data.info.hostId,
    serverId = role.data.data.info.serverId,
    roleName = role.data.name,
    unionName = role.data.unionName,
    unionId = role.data.unionId,
    unionPosition = role.data.unionPosition,
    teamId = role.data.teamId,
    fightValue = role.data.data.info.fight,
    career = role.data.career,
    level = role.data.level,
    equipData = role.data.equipsData,
    maxHp = role.data.maxHp,
    hp = role.data.hp,
    maxMp = role.data.maxMp,
    mp = role.data.mp
  }
  UIManager.Show(UIID.PlayerHpMPInfoUI, roleInteractTable)
end

function RoleInteractData.PlayerHpMPRepelBossHp()
  if UIManager.IsVisible(UIID.BossHpInfoUI) then
    UIManager.Hide(UIID.BossHpInfoUI)
  end
end

function RoleInteractData.BossHRepelPlayerHpMP()
  if UIManager.IsVisible(UIID.PlayerHpMPInfoUI) then
    UIManager.Hide(UIID.PlayerHpMPInfoUI)
  end
end

function RoleInteractData.PlayerLookHideUI(role)
  if not role:IsCurSafeZone() then
    UIManager.Hide(UIID.PlayerHpMPInfoUI)
  end
end
