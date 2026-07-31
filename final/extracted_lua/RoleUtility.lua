RoleUtility = {}
local this = RoleUtility
this.IsAddFriendRed = false

function RoleUtility.GetBasicCareer(career)
  local num = career % 10
  num = 10 + num
  return num
end

function RoleUtility.GetRankBasicCareer(career)
  local num = career % 10
  return num
end

function RoleUtility.JudgeWardCompatibilty(selfCareer, tarCareer)
  local isSameCareer = this.GetBasicCareer(selfCareer) == this.GetBasicCareer(tarCareer)
  if isSameCareer then
    local isUP = tarCareer <= selfCareer
    if isUP then
      return 1
    else
      return 2
    end
  else
    return 0
  end
end

function RoleUtility.UpWardCompatibilty(selfCareer, tarCareer)
  local isSameCareer = this.GetBasicCareer(selfCareer) == this.GetBasicCareer(tarCareer)
  local isUP = tarCareer <= selfCareer
  local flag = isSameCareer and isUP
  return flag
end

function RoleUtility.DownWardCompatibilty(selfCareer, tarCareer)
  local isSameCareer = this.GetBasicCareer(selfCareer) == this.GetBasicCareer(tarCareer)
  local isDown = selfCareer <= tarCareer
  local flag = isSameCareer and isDown
  return flag
end

function RoleUtility.CareerJudge(selfCareer, tarCareer)
  return this.GetBasicCareer(selfCareer) == this.GetBasicCareer(tarCareer)
end

function RoleUtility.GteCareerNameByType(type)
  if type == ERoleCareer.Magic then
    return "Ma Ph\195\161p S\198\176"
  elseif type == ERoleCareer.SwordMan then
    return "Ki\225\186\191m S\196\169"
  elseif type == ERoleCareer.Archer then
    return "Cung Th\225\187\167"
  elseif type == ERoleCareer.SpellSword then
    return "Ma K\225\187\181 S\196\169"
  elseif type == ERoleCareer.HolyMaster then
    return "\196\144\225\186\161o S\198\176 Th\195\161nh"
  elseif type == ERoleCareer.SummonMagician then
    return "Tri\225\187\135u H\225\187\147i S\198\176 "
  elseif type == ERoleCareer.Knight then
    return "K\225\187\181 S\196\169 Ki\225\186\191m"
  elseif type == ERoleCareer.Magister then
    return "Ph\195\161p S\198\176"
  elseif type == ERoleCareer.Marksman then
    return "Cung Th\225\187\167 Th\195\161nh"
  elseif type == ERoleCareer.CallingTeacher then
    return "Tri\225\187\135u H\225\187\147i S\198\176 M\195\161u"
  elseif type == ERoleCareer.SwordDevil then
    return "K\225\187\181 S\196\169 Song Tr\195\172"
  elseif type == ERoleCareer.GodKnight then
    return "Th\225\186\167n K\225\187\181 S\196\169"
  elseif type == ERoleCareer.GodMagic then
    return "Th\225\186\167n \196\144\225\186\161o S\198\176"
  elseif type == ERoleCareer.GodArcher then
    return "Th\225\186\167n Cung Th\225\187\167"
  elseif type == ERoleCareer.SummonTheWizard then
    return "Tri\225\187\135u H\225\187\147i S\198\176 Kh\195\180ng Gian"
  elseif type == ERoleCareer.Blademaster then
    return "K\225\187\181 S\196\169 Ma Ph\195\161p"
  elseif type == ERoleCareer.Minister then
    return "T\225\186\191 S\198\176"
  elseif type == ERoleCareer.Templar then
    return "K\225\187\181 S\196\169 R\225\187\147ng"
  elseif type == ERoleCareer.Archmage then
    return "\196\144\225\186\161i Ph\195\161p S\198\176"
  elseif type == ERoleCareer.ElvesRangers then
    return "Du Hi\225\187\135p Tinh Linh"
  elseif type == ERoleCareer.DemonKnight then
    return "K\225\187\181 S\196\169 Song Ki\225\186\191m"
  elseif type == ERoleCareer.GrandSummoner then
    return "Tri\225\187\135u H\225\187\147i S\198\176 V\195\180 T\225\186\173n"
  end
end

function RoleUtility.GetSkillPhyAttackUpAndDown(skillId)
  local skill = ClientTable.cfg_Skill_skillManager:TryGetValue(skillId)
  local attackDown = ViewData.meData:GetAttribute(EAttributeType.minimumPhysBaseDmg)
  local attackUp = ViewData.meData:GetAttribute(EAttributeType.maximumPhysBaseDmg)
  local up = (skill.maxDamage + attackUp) * skill.skillBaseDmg
  local down = (skill.minDamage + attackDown) * skill.skillBaseDmg
  return Mathf.Floor(up / 10000), Mathf.Floor(down / 10000)
end

function RoleUtility.GetSkillMagicAttackUpAndDown(skillId)
  local skill = ClientTable.cfg_Skill_skillManager:TryGetValue(skillId)
  local attackDown = ViewData.meData:GetAttribute(EAttributeType.minimumWizBaseDmg)
  local attackUp = ViewData.meData:GetAttribute(EAttributeType.maximumWizBaseDmg)
  local up = (skill.maxDamage + attackUp) * skill.skillBaseDmg
  local down = (skill.minDamage + attackDown) * skill.skillBaseDmg
  return Mathf.Floor(up / 10000), Mathf.Floor(down / 10000)
end

function RoleUtility.TargetIsFitMyPkMode(role)
  if role and not role.isDead then
    if RoleManager.me.PKMode == ERolePkMode.All then
      return true
    elseif RoleManager.me.PKMode == ERolePkMode.Union then
      if role.RoleType == ERoleType.Player and WarAllianceData.GetIsSameUnion(role.id) then
        return false
      end
      return true
    elseif RoleManager.me.PKMode == ERolePkMode.SiegeDefense then
      if role.RoleType == ERoleType.Player and WarAllianceData.GetIsSameUnion(role.id) then
        return false
      end
      return true
    elseif RoleManager.me.PKMode == ERolePkMode.SiegeAttack then
      if role.RoleType == ERoleType.Player then
        local holdUnionId = Activity_LuoLanSiegeData.holdUnionId
        if role.unionId ~= 0 and role.unionId ~= holdUnionId then
          return false
        end
      end
      return true
    elseif RoleManager.me.PKMode == ERolePkMode.Peace then
      local isEnemyUnion = WarAllianceUtility.IsEnemyUnion(role)
      if role.RoleType == ERoleType.Monster then
        return true
      end
      if role.evilLevel ~= EvilRoleType.Level0 then
        return true
      elseif isEnemyUnion then
        return true
      else
        return false
      end
    elseif RoleManager.me.PKMode == ERolePkMode.Team then
      if role.RoleType == ERoleType.Player and TeamData.IsTeammate(role.id) then
        return false
      end
      return true
    elseif RoleManager.me.PKMode == ERolePkMode.UnionKuaFu then
      if role.RoleType == ERoleType.Player and CampController.GetIsSameCamp(role.id) then
        return false
      end
      return true
    elseif RoleManager.me.PKMode == ERolePkMode.Camp then
      if role.RoleType == ERoleType.Player and QuickFind:GetKunShouBattleDataMgr():IsSameCamp(RoleManager.me.id, role.id) then
        return false
      end
      return true
    end
  end
  return false
end

function RoleUtility.TargetIsFitMyPkModeTips()
  if RoleManager.me.TargetAvatar and not RoleManager.me.TargetAvatar.isDead then
    if RoleManager.me.PKMode == ERolePkMode.All then
      return true
    elseif RoleManager.me.PKMode == ERolePkMode.Union then
      if RoleManager.me.TargetAvatar.RoleType == ERoleType.Player and WarAllianceData.GetIsSameUnion(RoleManager.me.TargetAvatar.id) then
        FloatingTipUtility.QuickMsg("Kh\195\180ng th\225\187\131 t\225\186\165n c\195\180ng \196\145\225\187\147ng minh khi \196\145ang \225\187\159 ch\225\186\191 \196\145\225\187\153 Guild")
        return false
      end
      return true
    elseif RoleManager.me.PKMode == ERolePkMode.SiegeDefense then
      if RoleManager.me.TargetAvatar.RoleType == ERoleType.Player and WarAllianceData.GetIsSameUnion(RoleManager.me.TargetAvatar.id) then
        FloatingTipUtility.QuickMsg("Trong C\195\180ng Th\195\160nh Chi\225\186\191n, Phe Th\225\187\167 Th\195\160nh kh\195\180ng th\225\187\131 t\225\186\165n c\195\180ng Phe Th\225\187\167 Th\195\160nh")
        return false
      end
      return true
    elseif RoleManager.me.PKMode == ERolePkMode.SiegeAttack then
      if RoleManager.me.TargetAvatar.RoleType == ERoleType.Player then
        local holdUnionId = Activity_LuoLanSiegeData.holdUnionId
        if RoleManager.me.TargetAvatar.unionId ~= 0 and RoleManager.me.TargetAvatar.unionId ~= holdUnionId then
          FloatingTipUtility.QuickMsg("Trong C\195\180ng Th\195\160nh Chi\225\186\191n, Phe C\195\180ng Th\195\160nh kh\195\180ng th\225\187\131 t\225\186\165n c\195\180ng Phe C\195\180ng Th\195\160nh")
          return false
        end
      end
      return true
    elseif RoleManager.me.PKMode == ERolePkMode.Peace then
      if RoleManager.me.TargetAvatar.RoleType == ERoleType.Monster then
        return true
      else
        local isEnemyUnion = WarAllianceUtility.IsEnemyUnion(RoleManager.me.TargetAvatar)
        if RoleManager.me.TargetAvatar.evilLevel ~= EvilRoleType.Level0 then
          return true
        elseif isEnemyUnion then
          if SceneData.IsCrossRealm() and CampController.GetIsSameCamp(RoleManager.me.TargetAvatar.id) then
            return false
          end
          return true
        else
          FloatingTipUtility.QuickMsg("Ch\225\186\191 \196\145\225\187\153 H\195\178a B\195\172nh kh\195\180ng th\225\187\131 t\225\186\165n c\195\180ng ng\198\176\225\187\157i ch\198\161i kh\195\180ng c\195\179 t\195\170n \196\145\225\187\143")
          return false
        end
      end
    elseif RoleManager.me.PKMode == ERolePkMode.Team then
      if RoleManager.me.TargetAvatar.RoleType == ERoleType.Player and TeamData.IsTeammate(RoleManager.me.TargetAvatar.id) then
        FloatingTipUtility.QuickMsg("Kh\195\180ng th\225\187\131 t\225\186\165n c\195\180ng \196\145\225\187\147ng \196\145\225\187\153i trong ch\225\186\191 \196\145\225\187\153 t\225\187\149 \196\145\225\187\153i")
        return false
      end
      return true
    elseif RoleManager.me.PKMode == ERolePkMode.UnionKuaFu then
      if RoleManager.me.TargetAvatar.RoleType == ERoleType.Player and CampController.GetIsSameCamp(RoleManager.me.TargetAvatar.id) then
        FloatingTipUtility.QuickMsg("Kh\195\180ng th\225\187\131 t\225\186\165n c\195\180ng \196\145\225\187\147ng minh trong ch\225\186\191 \196\145\225\187\153 Li\195\170n Minh")
        return false
      end
      return true
    elseif RoleManager.me.PKMode == ERolePkMode.Camp then
      if RoleManager.me.TargetAvatar.RoleType == ERoleType.Player and QuickFind:GetKunShouBattleDataMgr():IsSameCamp(RoleManager.me.id, RoleManager.me.TargetAvatar.id) then
        FloatingTipUtility.QuickMsg("Kh\195\180ng th\225\187\131 t\225\186\165n c\195\180ng ng\198\176\225\187\157i c\195\185ng phe trong ch\225\186\191 \196\145\225\187\153 Tr\225\186\173n doanh")
        return false
      end
      return true
    end
  end
  FloatingTipUtility.QuickMsg("K\225\187\185 n\196\131ng n\195\160y c\225\186\167n c\195\179 m\225\187\165c ti\195\170u \196\145\225\187\131 s\225\187\173 d\225\187\165ng")
  return false
end

function RoleUtility.IsCanAttackPlayerTips()
  local res = this.TargetIsFitMyPkModeTips()
  if not res then
    return false
  end
  if not RoleTargetManager.IsCanAttackPlayer(RoleManager.me.TargetAvatar) then
    local titleStr = ClientTable.cfg_Ui_wordManager:GetUi_wordCount("noviceProtection_1")
    local globalConfig = ClientTable.cfg_Global_globalManager:GetGlobalItemEffect(2110012)
    globalConfig = string.split(globalConfig, "#")
    titleStr = string.format(titleStr, globalConfig[2])
    FloatingTipUtility.QuickMsg(titleStr)
    return false
  end
  return true
end

function RoleUtility.IsCanAttackPlayer(role)
  local res = this.TargetIsFitMyPkMode(role)
  if not res then
    return false
  end
  if not RoleTargetManager.IsCanAttackPlayer(role) then
    return false
  end
  return true
end

function RoleUtility.ModelRoleNameColor(Roleid)
  if Roleid == RoleManager.me.data.id then
    local nameColor = ItemQuality2ColorDic[EItemColorEnum.white]
    if RoleManager.me.PKMode == ERolePkMode.Team then
      if TeamData.IsTeammate(Roleid) then
        nameColor = ItemQuality2ColorDic[EItemColorEnum.blue]
      end
    elseif RoleManager.me.PKMode == ERolePkMode.Union then
      local ownerInfo = ViewData.GetGameObjectInViewById(Roleid)
      if ownerInfo and ViewData.meData.unionId == ownerInfo.unionId then
        nameColor = ItemQuality2ColorDic[EItemColorEnum.green]
      end
    elseif RoleManager.me.PKMode == ERolePkMode.UnionKuaFu then
      local ownerInfo = ViewData.GetGameObjectInViewById(Roleid)
      if ownerInfo and ViewData.meData.unionCamp == ownerInfo.unionCamp then
        nameColor = ItemQuality2ColorDic[EItemColorEnum.green]
      end
    end
    return nameColor
  else
    local nameColor = ItemQuality2ColorDic[EItemColorEnum.BRed]
    local role = RoleManager.GetRoleById(Roleid)
    if not role then
      return nameColor
    end
    local isEnemyUnion = WarAllianceUtility.IsEnemyUnion(role)
    if RoleManager.me.PKMode == ERolePkMode.Peace then
      if role and role.evilLevel == EvilRoleType.Level0 then
        if isEnemyUnion then
          if SceneData.IsCrossRealm() and CampController.IsSameCamp(role.unionCamp) then
            nameColor = ItemQuality2ColorDic[EItemColorEnum.white]
          else
            nameColor = ItemQuality2ColorDic[EItemColorEnum.red]
          end
        else
          nameColor = ItemQuality2ColorDic[EItemColorEnum.white]
        end
      else
        nameColor = ItemQuality2ColorDic[EItemColorEnum.BRed]
      end
    elseif RoleManager.me.PKMode == ERolePkMode.Team then
      if TeamData.IsTeammate(Roleid) then
        nameColor = ItemQuality2ColorDic[EItemColorEnum.green]
      elseif role.evilLevel == EvilRoleType.Level0 then
        nameColor = isEnemyUnion and ItemQuality2ColorDic[EItemColorEnum.red] or ItemQuality2ColorDic[EItemColorEnum.orange]
      elseif role.evilLevel ~= EvilRoleType.Level0 then
        nameColor = ItemQuality2ColorDic[EItemColorEnum.BRed]
      end
    elseif RoleManager.me.PKMode == ERolePkMode.Union then
      if role and ViewData.meData.unionId == role.unionId then
        nameColor = ItemQuality2ColorDic[EItemColorEnum.green]
      elseif role and role.evilLevel == EvilRoleType.Level0 then
        nameColor = isEnemyUnion and ItemQuality2ColorDic[EItemColorEnum.red] or ItemQuality2ColorDic[EItemColorEnum.orange]
      elseif role.evilLevel ~= EvilRoleType.Level0 then
        nameColor = ItemQuality2ColorDic[EItemColorEnum.BRed]
      end
    elseif RoleManager.me.PKMode == ERolePkMode.UnionKuaFu then
      if role and ViewData.meData.unionCamp == role.unionCamp then
        nameColor = ItemQuality2ColorDic[EItemColorEnum.green]
      elseif role and role.evilLevel == EvilRoleType.Level0 then
        nameColor = isEnemyUnion and ItemQuality2ColorDic[EItemColorEnum.red] or ItemQuality2ColorDic[EItemColorEnum.orange]
      elseif role.evilLevel ~= EvilRoleType.Level0 then
        nameColor = ItemQuality2ColorDic[EItemColorEnum.BRed]
      end
    elseif RoleManager.me.PKMode == ERolePkMode.All then
      if role and role.evilLevel == EvilRoleType.Level0 then
        nameColor = ItemQuality2ColorDic[EItemColorEnum.red]
      elseif role.evilLevel ~= EvilRoleType.Level0 then
        nameColor = ItemQuality2ColorDic[EItemColorEnum.BRed]
      end
    elseif RoleManager.me.PKMode == ERolePkMode.SiegeAttack then
      local holdUnionId = Activity_LuoLanSiegeData.holdUnionId
      if role and holdUnionId ~= 0 and role.unionId ~= 0 and role.unionId ~= holdUnionId then
        nameColor = ItemQuality2ColorDic[EItemColorEnum.green]
      end
    elseif RoleManager.me.PKMode == ERolePkMode.SiegeDefense then
      if role and WarAllianceData.GetIsSameUnion(role.id) then
        nameColor = ItemQuality2ColorDic[EItemColorEnum.green]
      end
    elseif RoleManager.me.PKMode == ERolePkMode.Camp and QuickFind:GetKunShouBattleDataMgr():IsSameCamp(RoleManager.me.id, role.id) then
      nameColor = ItemQuality2ColorDic[EItemColorEnum.green]
    end
    return nameColor
  end
end

function RoleUtility.IsInTheRangeOfScope(target, scope)
  return this.IsLessThanRangeInTheBetween(RoleManager.me.serverCoord, target.serverCoord, scope)
end

function RoleUtility.IsLessThanRangeInTheBetween(cellA, cellB, scope)
  local range = Mathf.Max(Mathf.Abs(cellB.x - cellA.x), Mathf.Abs(cellB.y - cellA.y))
  return scope >= range
end

function RoleUtility.IsSameCarrer(tarCareer, career)
  if tarCareer == nil or career == nil then
    return false
  end
  local carrerTbl
  if type(career) == "table" then
    carrerTbl = career
  else
    local strTab = string.split(career, "#")
    for i = 1, table.count(strTab) do
      table.insert(carrerTbl, tonumber(strTab[i]))
    end
  end
  for i, v in pairs(carrerTbl) do
    if RoleUtility.JudgeWardCompatibilty(v, tarCareer) == 0 then
      return false
    end
  end
  return true
end

function RoleUtility.GetCurrentCareerCategory(skillInfo, autoType)
  local career = this.GetBasicCareer(RoleManager.me.career)
  local strength = QuickFind.LuaMainPlayerData():TryGetAttrValue(EAttributeType.strength)
  local energy = QuickFind.LuaMainPlayerData():TryGetAttrValue(EAttributeType.energy)
  local agility = QuickFind.LuaMainPlayerData():TryGetAttrValue(EAttributeType.agility)
  local Curse = QuickFind.LuaMainPlayerData():TryGetAttrValue(EAttributeType.maximumCurseBaseDmg)
  local magic = QuickFind.LuaMainPlayerData():TryGetAttrValue(EAttributeType.maximumWizBaseDmg)
  if career == ERoleCareer.SwordMan then
    return strength >= agility and ERoleCategory.FightHard or ERoleCategory.AgileWarfare
  elseif career == ERoleCareer.Magic then
    return energy >= agility and ERoleCategory.IntellectualMethod or ERoleCategory.SensitizingMethod
  elseif career == ERoleCareer.Archer then
    return energy <= agility and ERoleCategory.SensitizingBow or ERoleCategory.WisdomBow
  elseif career == ERoleCareer.SpellSword then
    return strength <= energy and ERoleCategory.Warlock or ERoleCategory.ForceDemon
  elseif career == ERoleCareer.SummonMagician then
    if skillInfo and skillInfo.skillForm and autoType then
      return tonumber(autoType)
    end
    return Curse >= magic and ERoleCategory.CurseSummon or ERoleCategory.MagicSummon
  end
end
