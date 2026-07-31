PreloadResourceData = {}
local this = PreloadResourceData
PreloadResourceData.LOW_LOAD_COUNT = 1
PreloadResourceData.MIDDLE_LOAD_COUNT = 1
PreloadResourceData.HEIGHT_LOAD_COUNT = 1
PreloadResourceData.preCount = 0
PreloadResourceData.totalCount = 0
PreloadResourceData.ResTbl = {}
PreloadResourceData.UIPreloadingTbl = {}
PreloadResourceData.CatlikeTime = 0.33

local function CheckUIName(tbl, name)
  if not table.contains(tbl, name) then
    table.insert(tbl, name)
  end
end

local function CollectUIPreLoadRes()
  this.UIPreloadingTbl = {}
  local cfgUILogic = ClientTable.cfg_Ui_logicManager:GetDic()
  for _, ui in pairs(cfgUILogic) do
    if ui.mainUI ~= "Tip_PromptTipUI" and ui.inputLoading == 1 then
      CheckUIName(this.UIPreloadingTbl, ui.mainUI)
    end
  end
  CheckUIName(this.UIPreloadingTbl, "ShopSkill_TIpsUI")
  CheckUIName(this.UIPreloadingTbl, "Auction_RecommendTIpsUI")
  CheckUIName(this.UIPreloadingTbl, "Skill_TIpsUI")
  CheckUIName(this.UIPreloadingTbl, "Equip_TIpsUI")
  CheckUIName(this.UIPreloadingTbl, "Attribute_AddTipsUI")
  CheckUIName(this.UIPreloadingTbl, "Auction_TIpsUI")
  CheckUIName(this.UIPreloadingTbl, "Tip_EffectTipUI")
  CheckUIName(this.UIPreloadingTbl, "Tip_RewardTipUI")
  CheckUIName(this.UIPreloadingTbl, "Tip_FourPartyRivalryScoreUI")
  CheckUIName(this.UIPreloadingTbl, "Main_JoyStickUI")
  CheckUIName(this.UIPreloadingTbl, "Loading_LoadingUI")
  CheckUIName(this.UIPreloadingTbl, "Tip_PromptTipUI")
  return this.UIPreloadingTbl
end

function PreloadResourceData.Init()
  CollectUIPreLoadRes()
end

local function CollectMonsterLoadRes(mapId)
  local monsterPreloadingTbl = {}
  local monsterDeadEffectPreloadTbl = {}
  local monsterMap = {}
  local deadEffectMap = {}
  local monsters = ClientTable.cfg_Monster_monsterManager:GetDic()
  for _, monster in pairs(monsters) do
    if Mathf.Floor(monster.id * 0.01) == mapId and not monsterMap[monster.model] then
      monsterMap[monster.model] = true
      local monsterPath = monster.model
      table.insert(monsterPreloadingTbl, monsterPath)
      local deadEffectTbl = ClientTable.cfg_Monster_deadEffectManager:TryGetValue(monster.model, "id")
      if deadEffectTbl and not deadEffectMap[deadEffectTbl.effectFileName] then
        table.insert(monsterDeadEffectPreloadTbl, deadEffectTbl.effectFileName)
        deadEffectMap[deadEffectTbl.effectFileName] = true
      end
    end
  end
  return monsterPreloadingTbl, monsterDeadEffectPreloadTbl
end

local function CollectNpcLoadRes(mapId)
  local NpcPreloadingTbl = {}
  local npcMap = {}
  local NPCs = ClientTable.cfg_Npc_npcManager:GetDic()
  for _, npc in pairs(NPCs) do
    if npc.map == mapId and not npcMap[npc.model] then
      table.insert(NpcPreloadingTbl, npc.model)
      npcMap[npc.model] = true
    end
  end
  return NpcPreloadingTbl
end

local function CollectSkillLoadRes()
  local SkillPreloadingTbl = {}
  if ViewData.meData and ViewData.meData.skills then
    for _, skill in pairs(ViewData.meData.skills) do
      if skill then
        local cfg_skill = ClientTable.cfg_Skill_skillManager:TryGetValue(skill.sid)
        if cfg_skill then
          local skillConfig = ConfigManager.GetConfig("cfg_actionLogic", cfg_skill.actionId, "groupId")
          if skillConfig and skillConfig.actions then
            if skillConfig.actions.ActionEffectData then
              for i = 1, #skillConfig.actions.ActionEffectData do
                if not string.isNullOrEmpty(skillConfig.actions.ActionEffectData[i].prefab) then
                  table.insert(SkillPreloadingTbl, skillConfig.actions.ActionEffectData[i].prefab)
                end
              end
            end
            if skillConfig.actions.ActionBulletData then
              for i = 1, #skillConfig.actions.ActionBulletData do
                if not string.isNullOrEmpty(skillConfig.actions.ActionBulletData[i].prefab) then
                  table.insert(SkillPreloadingTbl, skillConfig.actions.ActionBulletData[i].prefab)
                end
              end
            end
          end
        end
      end
    end
  end
  return SkillPreloadingTbl
end

function PreloadResourceData.Preload(modelType, path)
  Coroutine.Start(function()
    local Req = CS.Framework.ResourceManager.InstantiateAsync(path)
    Coroutine.Yield(Req)
    PreLoadManager.Count()
    if Req.isError then
      logError(Req.error)
      Coroutine.Break()
    end
    local model = Req.gameObject
    PoolManagerTest.Recycle(modelType, path, model)
  end)
end

function PreloadResourceData.PreloadSkill(modelType, path)
  Coroutine.Start(function()
    local Req = CS.Framework.ResourceManager.InstantiateAsync(path)
    Coroutine.Yield(Req)
    if Req.isError then
      logError(Req.error)
      Coroutine.Break()
    end
    local model = Req.gameObject
    if model then
      PoolManagerTest.Recycle(modelType, path, model)
    end
  end)
end

local function CheckPoolResExist(modelType, tbl)
  local resultTbl = {}
  for _, modelName in ipairs(tbl) do
    if not PoolManagerTest.Contains(modelType, modelName) then
      table.insert(resultTbl, modelName)
    end
  end
  return resultTbl
end

function PreloadResourceData.CollectPreloadRes(mapId)
  this.ResTbl = {}
  local tempTbl
  local count = 0
  tempTbl = CollectSkillLoadRes()
  tempTbl = CheckPoolResExist(ResourceTypeEnum.Effect_Skill, tempTbl)
  this.ResTbl[ResourceTypeEnum.Effect_Skill] = table.combine(this.ResTbl[ResourceTypeEnum.Effect_Skill], tempTbl)
  count = count + table.count(tempTbl)
  local monsterDead = {}
  tempTbl, monsterDead = CollectMonsterLoadRes(mapId)
  tempTbl = CheckPoolResExist(ResourceTypeEnum.Model_Monster, tempTbl)
  this.ResTbl[ResourceTypeEnum.Model_Monster] = table.combine(this.ResTbl[ResourceTypeEnum.Model_Monster], tempTbl)
  count = count + table.count(tempTbl)
  monsterDead = CheckPoolResExist(ResourceTypeEnum.Effect_Skill, monsterDead)
  this.ResTbl[ResourceTypeEnum.Effect_Skill] = table.combine(this.ResTbl[ResourceTypeEnum.Effect_Skill], monsterDead)
  count = count + table.count(monsterDead)
  tempTbl = CollectNpcLoadRes(mapId)
  tempTbl = CheckPoolResExist(ResourceTypeEnum.Model_NPC, tempTbl)
  this.ResTbl[ResourceTypeEnum.Model_NPC] = table.combine(this.ResTbl[ResourceTypeEnum.Model_NPC], tempTbl)
  count = count + table.count(tempTbl)
  return 0 < count, count
end

function PreloadResourceData.ResetCount()
  this.preCount = 0
  this.totalCount = 0
end

PreloadResourceData.Init()
