require("GameConst/AutoSkillEnum")
require("GameModel/QiJiHelperData")
QiJiHelperController = {}
local this = QiJiHelperController

function QiJiHelperController.Init()
  this.eventContainer = EventContainer(EventManager)
  this.RegistEvents()
end

function QiJiHelperController.RegistEvents()
  this.eventContainer:Regist(Event.GamePlay_Reconnect, this.ReconnectAutoFight)
  this.eventContainer:Regist(Event.Role_ChangePos, this.RoleChangePosStopAutoFight)
  this.eventContainer:Regist(Event.UpdateSkillCd, this.ResetPreSkillId)
end

function QiJiHelperController.ResetPreSkillId(_, skillId)
  if skillId and skillId == QiJiHelperData.pressSkillId then
    QiJiHelperData.SetPressSkill()
  end
end

function QiJiHelperController.ReconnectAutoFight()
  if not RoleManager.me then
    return
  end
  RoleManager.me:ReconnectCloseAutoFight()
end

function QiJiHelperController.StopAutoFight()
  local instanceMapInfo = ClientTable.cfg_Map_instanceManager:TryGetValue(SceneData.mapId, "mapId")
  if not RoleManager.me then
    return
  end
  if instanceMapInfo and instanceMapInfo.type == 2205 then
    RoleManager.me:SetAutoTaskFight(AutoFightStrKey.AutoFight)
    return
  end
  RoleManager.me:SetAutoTaskFight(AutoFightStrKey.None)
end

function QiJiHelperController.RoleChangePosStopAutoFight(_, lid, reason, reasonParam)
  if not RoleManager.me then
    return
  end
  if RoleManager.me:IsCurSafeZone() then
    RoleManager.me:SetAutoTaskFight(AutoFightStrKey.None)
  end
end

function QiJiHelperController.ResetReturnHomeTime()
  QiJiHelperData.nextReturnHomeTime = Time.GetServerSecondTime() + QiJiHelperData.SettingData.ReturnHome.ReturnTime
end

function QiJiHelperController.SetMeBuffSkill(skillId, handleType)
  if handleType then
    QiJiHelperData.OpenBuffSkill(skillId)
  else
    QiJiHelperData.CloseBuffSkill(skillId)
  end
end

function QiJiHelperController.SetSelfSelSkill(skillId, handleType)
  if handleType then
    QiJiHelperData.OpenSelfSelSkill(skillId)
  else
    QiJiHelperData.CloseSelfSelSkill(skillId)
  end
end

function QiJiHelperController.SetSkillMonsterRange(range)
  QiJiHelperData.SettingData.KillMonsterScope = range
end

function QiJiHelperController.SetSTrikeBack(isOn)
  QiJiHelperData.SettingData.StrikeBack = isOn
end

function QiJiHelperController.SetReturnHome(isOn)
  QiJiHelperData.SettingData.ReturnHome.IsReturn = isOn
  QiJiHelperData.meCellPos = Vector2Int(RoleManager.me.serverCoord.x, RoleManager.me.serverCoord.y)
end

function QiJiHelperController.SetTeammateBuff(isOn)
  QiJiHelperData.SettingData.AddBuffToTeammate = isOn
end

function QiJiHelperController.SetReturnHomeTime(returnTime)
  QiJiHelperData.SettingData.ReturnHome.ReturnTime = returnTime
end

function QiJiHelperController.SetAutoRecover(isOn)
  QiJiHelperData.SettingData.SetAutoRecover = isOn
end

function QiJiHelperController.SetAutoTreat(isOn)
  QiJiHelperData.SettingData.AutoTreat = isOn
end

function QiJiHelperController.SetExpUp(isOn)
  QiJiHelperData.SettingData.expUp = isOn
end

function QiJiHelperController.SetAutoRecoverHp(num)
  QiJiHelperData.SettingData.recoverHp = num
end

function QiJiHelperController.SetAutoRecoverMp(num)
  QiJiHelperData.SettingData.recoverMp = num
end

function QiJiHelperController.SetAutoPickupType(pickType)
  QiJiHelperData.SettingData.selectPickupType = pickType
end

function QiJiHelperController.Save()
  QiJiHelperData.Save()
end

function QiJiHelperController.StrikeBack(data)
  if not RoleManager.me then
    return
  end
  if RoleManager.me.TargetAvatar and not RoleManager.me.TargetAvatar.isDead then
    return
  end
  if not QiJiHelperData.isAutoFight or not QiJiHelperData.SettingData.StrikeBack then
    return
  end
  for i = 1, #data.hurtList do
    local hurt = data.hurtList[i]
    if hurt.targetId == ViewData.meData.id and data.attackerId ~= ViewData.meData.id then
      local target = RoleManager.GetRoleById(data.attackerId)
      if target and target.RoleType == ERoleType.Monster and not target.isDead and not RoleUtility.IsInTheRangeOfScope(target, QiJiHelperData.SettingData.KillMonsterScope) then
        local res = RoleTargetManager.IsCanAttackMonster(target)
        if not res then
          return
        end
        RoleManager.me:SetTarget(target)
        break
      end
    end
  end
  if not ViewData.meData.equipsData:GetEquipByIndex(ERoleEquipPosition.SpecialPower) then
    return
  end
  local pkModeError = PKData.GetChangePkModeError()
  if pkModeError ~= PkModeErrorEnum.None then
    return
  end
  if QiJiHelperData.selectRoleId then
    return
  end
  local strikeRange = tonumber(ClientTable.cfg_Global_globalManager:GetGlobalItemEffect(1190001))
  for i = 1, #data.hurtList do
    local hurt = data.hurtList[i]
    if hurt.targetId == ViewData.meData.id and data.attackerId ~= ViewData.meData.id then
      local target = RoleManager.GetRoleById(data.attackerId)
      if target and target.RoleType == ERoleType.Player and RoleUtility.IsInTheRangeOfScope(target, strikeRange) then
        if RoleManager.me.PKMode ~= ERolePkMode.All then
          NetManager.Send(RoleMessage.ReqSetPKMode, {
            param = ERolePkMode.All
          })
        end
        RoleManager.me:SetTarget(target)
        RoleManager.me:SetAutoFight(AutoFightStrKey.None)
        RoleManager.me:SetAutoFight(AutoFightStrKey.AutoFight)
        QiJiHelperData.SetSelectRoleId(target.id)
        break
      end
    end
  end
end

function QiJiHelperController.SetSelfSelIndSkill(skillId)
end

function QiJiHelperController.SetSelfSelfGroupSkill(skillId)
end

function QiJiHelperController.SetSummonSkill(skillId)
  QiJiHelperData.SettingData.selfSelSummonSkill = skillId
end

function QiJiHelperController.SetCantPickupType(cancel, dropItemType, rarity)
  QiJiHelperData.SetCantPickupType(cancel, dropItemType, rarity)
end

function QiJiHelperController.SetDefaultAutoFight()
  QiJiHelperData.SetDefaultAutoFight()
end

function QiJiHelperController.SetDefaultAutoPickup()
  QiJiHelperData.SetDefaultAutoPickup()
end
