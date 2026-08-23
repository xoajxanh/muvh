require("GamePlay/FightFramework/Bullet/Bullet_LineMove")
require("GamePlay/FightFramework/Bullet/Bullet_PointToPoint")
require("GamePlay/FightFramework/Bullet/Bullet_MoveInPath")
require("GamePlay/FightFramework/Bullet/Bullet_LineMoveTargetPos")
require("GamePlay/FightFramework/Bullet/Bullet_LineMoveTargetDir")
require("GamePlay/FightFramework/Bullet/SkillBulletMgr")
require("GamePlay/FightFramework/Bullet/Bullet_MoveInBezier")
require("GamePlay/FightFramework/Bullet/Bullet_MoveInCSharpeTargetPos")
require("GamePlay/FightFramework/Bullet/Bullet_MoveInCSharpeTargetDir")
require("GamePlay/FightFramework/Bullet/Bullet_AroundSelfShoot")
BulletMgr = {}
local this = BulletMgr
BulletMgr.m_Bullets = {}
local BulletTable = {
  Bullet_LineMove,
  Bullet_MoveInPath,
  Bullet_PointToPoint,
  Bullet_MoveInBezier,
  Bullet_MoveInCSharpeTargetPos,
  Bullet_MoveInCSharpeTargetDir,
  Bullet_AroundSelfShoot
}
local useBulletBool = false
local bulletPool = {}
local weakReference = {__mode = "kv"}

local function AllocBullet()
  if not useBulletBool then
    return {}
  end
  local bullet = table.remove(bulletPool)
  if bullet then
    setmetatable(bullet, nil)
    return bullet
  else
    return {}
  end
end

local function RecycleBullet(bullet)
  Vector3.Recycle(bullet.dir)
  Vector3.Recycle(bullet.initPos)
  Vector3.Recycle(bullet.initRotation)
  Vector3.Recycle(bullet.targetPos)
  bullet.attacker = nil
  bullet.target = nil
  for k, v in pairs(BulletTable) do
    if v.RecycleBullet then
      v.RecycleBullet(bullet)
    end
  end
  if useBulletBool then
    setmetatable(bullet, weakReference)
    table.insert(bulletPool, bullet)
  end
end

function BulletMgr.Init()
end

function BulletMgr.Update()
  for k, v in pairs(this.m_Bullets) do
    this.UpdateBullet(v)
  end
end

function BulletMgr.UpdateBullet(bulletData_struct)
  if bulletData_struct.state == EffectState.None then
    bulletData_struct.startTime = bulletData_struct.startTime - Time.deltaTime
    if bulletData_struct.startTime <= 0 then
      bulletData_struct.state = EffectState.Ready
    end
  elseif bulletData_struct.state == EffectState.Ready then
    this.InitStartAndTargetPos(bulletData_struct, bulletData_struct.skillData_struct)
    for k, v in pairs(BulletTable) do
      if v.InitBullet then
        v.InitBullet(bulletData_struct.skillData_struct, bulletData_struct)
      end
    end
    bulletData_struct.bullet = this.LoadEffect(bulletData_struct)
    bulletData_struct.state = EffectState.Running
  elseif bulletData_struct.state == EffectState.Running then
    bulletData_struct.lifeTime = bulletData_struct.lifeTime - Time.deltaTime
    for k, v in pairs(BulletTable) do
      if v.Update then
        v.Update(bulletData_struct)
      end
    end
    if 0 >= bulletData_struct.lifeTime then
      bulletData_struct.state = EffectState.HaveDestory
    end
  end
end

local nextBID = 0

local function NextBID()
  nextBID = nextBID + 1
  return nextBID
end

function BulletMgr.AddBullet(skillData_struct, bulletData)
  if EffectDisplayController.IsMaxCount(skillData_struct.attackerId) then
    return
  end
  local dirs = skillData_struct.position
  local pbullet = AllocBullet()
  local dir = dirs and 0 < #dirs and dirs[1]
  SkillBulletMgr.AddBullet(bulletData, pbullet, dir, skillData_struct)
  pbullet.skillId = skillData_struct.skillId
  pbullet.groupId = skillData_struct.groupId
  pbullet.attackerId = skillData_struct.attackerId
  pbullet.tid = skillData_struct.targetId
  pbullet.dir = Vector3.Alloc(0, 0, 1)
  pbullet.bid = NextBID()
  pbullet.state = SkillState.None
  pbullet.attacker = skillData_struct.attacker
  pbullet.target = skillData_struct.target
  pbullet.skillData_struct = skillData_struct
  if not string.isNullOrEmpty(pbullet.prefab) then
    local effectActive = EffectDisplayController.AddSkillEffect(pbullet.attackerId)
    table.insert(this.m_Bullets, pbullet)
  end
  this.AddWeaponBullet(pbullet)
  if dirs then
    local bullet
    for i = 2, #dirs do
      bullet = AllocBullet()
      table.copy(bullet, pbullet)
      bullet.startTime, pbullet.startTimeSpeedUp = SkillBulletMgr.RandomStartTime(bulletData, skillData_struct.attackSpeed)
      bullet.group = dirs[i]
      if not string.isNullOrEmpty(pbullet.prefab) then
        local effectActive = EffectDisplayController.AddSkillEffect(pbullet.attackerId)
        table.insert(this.m_Bullets, bullet)
      end
      this.AddWeaponBullet(bullet)
    end
  end
end

function BulletMgr.AddWeaponBullet(pbullet)
  local skillData_struct = pbullet.skillData_struct
  local weaponBullet, weaponBulletData
  if skillData_struct.weaponConfig and skillData_struct.weaponConfig.actions and skillData_struct.weaponConfig.actions.WeaponActionBullletData then
    for i = 1, #skillData_struct.weaponConfig.actions.WeaponActionBullletData do
      weaponBulletData = skillData_struct.weaponConfig.actions.WeaponActionBullletData[i]
      if not string.isNullOrEmpty(weaponBulletData.prefab) then
        local effectActive = EffectDisplayController.AddSkillEffect(pbullet.attackerId)
        if not effectActive then
          return
        end
        weaponBullet = AllocBullet()
        table.copy(weaponBullet, pbullet)
        weaponBullet.prefab = weaponBulletData.prefab
        if weaponBulletData.weaponBulletType == WeaponBulletType.MoveInCSharpe then
          weaponBullet.type = weaponBullet.type == BulletType.TargetPos and BulletType.MoveInCSharpeTargetPos or BulletType.MoveInCSharpeTargetDir
        elseif weaponBulletData.weaponBulletType == WeaponBulletType.Bezier then
          weaponBullet.type = BulletType.MoveInBezier
        end
        weaponBullet.scale = weaponBulletData.scale
        weaponBullet.hits = weaponBulletData.hits.hitStruct
        table.insert(this.m_Bullets, weaponBullet)
      end
    end
  end
end

function BulletMgr.AddHeiLongBoTrailBullet(skillData_struct, heiLongBoTrailBulletData)
  if not skillData_struct.position or #skillData_struct.position < 1 then
    return
  end
  if string.isNullOrEmpty(heiLongBoTrailBulletData.prefab) then
    return
  end
  local paths = ConfigManager.GetConfigTable("cfg_HeiLongBo")
  local lastPathIndex = #paths - 1
  for i = 1, #skillData_struct.position do
    local effectActive = EffectDisplayController.AddSkillEffect(skillData_struct.attackerId)
    if not effectActive then
      return
    end
    local pbullet = {}
    local dir = math.random(0, lastPathIndex)
    SkillBulletMgr.AddBullet(heiLongBoTrailBulletData, pbullet, dir, skillData_struct)
    pbullet.skillId = skillData_struct.skillId
    pbullet.groupId = skillData_struct.groupId
    pbullet.attackerId = skillData_struct.attackerId
    pbullet.tid = skillData_struct.targetId
    pbullet.dir = Vector3.Alloc(0, 0, 1)
    pbullet.bid = NextBID()
    pbullet.state = SkillState.None
    pbullet.attacker = skillData_struct.attacker
    pbullet.target = skillData_struct.target
    pbullet.skillData_struct = skillData_struct
    table.insert(this.m_Bullets, pbullet)
  end
end

function BulletMgr.InitStartAndTargetPos(pbullet, skillData_struct)
  if not skillData_struct.isUI then
    pbullet.attacker = RoleManager.GetRoleById(pbullet.attackerId)
    pbullet.target = RoleManager.GetRoleById(pbullet.tid)
  end
  if pbullet.attacker then
    local startPos = Vector3.Alloc()
    pbullet.attackerNode = SkillUtility.GetRolePos(pbullet.attacker, pbullet.startBone)
    if pbullet.attackerNode then
      startPos:Set(pbullet.attackerNode:GetPosition())
    else
      startPos:CopyFrom(pbullet.attacker.pos)
    end
    startPos:Add(pbullet.offset)
    pbullet.initPos = startPos
    pbullet.initRotation = Vector3.AllocFrom(pbullet.offsetEulerAngles)
  else
    pbullet.initPos = Vector3.Alloc()
    Scene.GetPosByCellNonAlloc(skillData_struct.attackerX, skillData_struct.attackerY, pbullet.initPos)
    pbullet.initRotation = Vector3.Alloc(0, 0, 0)
  end
  pbullet.targetPos = skillData_struct.targetPos
  if pbullet.target then
    pbullet.targetBodyPos = pbullet.target.pos
    pbullet.targetNode = SkillUtility.GetRolePos(pbullet.target, pbullet.targetBone)
    if pbullet.targetNode then
      pbullet.targetPos = Vector3.Alloc(pbullet.targetNode:GetPosition())
    end
  else
    pbullet.targetBodyPos = pbullet.targetPos
  end
  if pbullet.targetPos then
    pbullet.targetPos = Vector3.AllocFrom(pbullet.targetPos):Add(pbullet.targetOffset)
  end
end

function BulletMgr.DestroyBullet(bullet)
  PoolManagerTest.Recycle(ResourceTypeEnum.Effect_Skill, bullet.prefab, bullet.bullet)
  EffectDisplayController.RemoveSkillEffect(bullet.attackerId)
  RecycleBullet(bullet)
end

function BulletMgr.Destroy(bid)
  for k, v in pairs(this.m_Bullets) do
    if v.bid == bid then
      this.DestroyBullet(v)
      this.m_Bullets[k] = nil
      break
    end
  end
end

function BulletMgr.DestroySingleBullet(bullet)
  for k, v in pairs(this.m_Bullets) do
    if v == bullet then
      this.DestroyBullet(v)
      this.m_Bullets[k] = nil
      break
    end
  end
end

function BulletMgr.LoadEffect(bulletData_struct)
  local skillEffect = PoolManagerTest.Spawn(ResourceTypeEnum.Effect_Skill, bulletData_struct.prefab)
  local parentRoot
  if bulletData_struct.attacker ~= nil and bulletData_struct.attacker.model and bulletData_struct.type == BulletType.SelfToTarget then
    parentRoot = bulletData_struct.attacker.model.SkillAnchor
  else
    parentRoot = SkillMgr.ROOT
  end
  if IsNil(skillEffect) then
    local skillModel = CS.Framework.GameModel(tostring(bulletData_struct.skillId), parentRoot, function(go, name)
      this.OnLoadSkillModel(bulletData_struct, skillEffect)
    end)
    skillModel:LoadAsync(bulletData_struct.prefab)
    skillEffect = skillModel.gameObject
    this.SetSkillEffectPosAndScale(bulletData_struct, skillEffect)
  else
    skillEffect:SetActive(false)
    skillEffect.gameObject.name = tostring(bulletData_struct.skillId)
    this.SetSkillEffectPosAndScale(bulletData_struct, skillEffect)
    this.OnLoadSkillModel(bulletData_struct, skillEffect)
  end
  return skillEffect
end

function BulletMgr.SetSkillEffectPosAndScale(bulletData_struct, skillEffect)
  if bulletData_struct.attackerId ~= nil and bulletData_struct.attackerId ~= 0 and bulletData_struct.attacker ~= nil then
    skillEffect.transform.position = bulletData_struct.initPos
    skillEffect.transform.eulerAngles = bulletData_struct.initRotation
  end
  if bulletData_struct.scale ~= nil then
    skillEffect.transform.localScale = bulletData_struct.scale
  end
  if skillEffect then
    skillEffect:SetActive(true)
  end
end

function BulletMgr.OnLoadSkillModel(bulletData_struct, skillEffect)
  for k, v in pairs(BulletTable) do
    if v.InitEffect then
      v.InitEffect(bulletData_struct, skillEffect)
    end
  end
end

function BulletMgr.RoleExit(rid)
  for k, v in pairs(this.m_Bullets) do
    if v.tid == rid and v.type == BulletType.SelfToTarget then
      this.DestroyBullet(v)
      this.m_Bullets[k] = nil
    end
  end
end

function BulletMgr.DestroyAllBullets()
  for k, v in pairs(this.m_Bullets) do
    this.DestroyBullet(v)
    this.m_Bullets[k] = nil
  end
end

function BulletMgr.LeaveGame()
  this.DestroyAllBullets()
end

function BulletMgr.ChangeScene()
  this.DestroyAllBullets()
end
