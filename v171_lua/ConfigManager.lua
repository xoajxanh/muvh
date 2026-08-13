ConfigManager = {}
local this = ConfigManager
local name2Table = {}
local name2Map = {}

function ConfigManager.GetConfigTable(name)
  local tbl = name2Table[name]
  if not tbl then
    tbl = require("Config/data/" .. name)
    if not tbl then
      logError("Config " .. name .. "not exist!!!")
      return
    end
    name2Table[name] = tbl
  end
  return tbl
end

local function BuildMap(array, key)
  key = key or "id"
  local dic = {}
  for k, v in ipairs(array) do
    dic[v[key]] = v
  end
  return dic
end

function ConfigManager.GetConfig(name, id, key)
  if id == nil then
    return nil
  end
  local map = name2Map[name]
  if not map then
    local tbl = this.GetConfigTable(name)
    if tbl then
      map = BuildMap(tbl, key)
      name2Map[name] = map
    end
  end
  if not map then
    logError(string.format("B\225\186\163ng %s kh\195\180ng t\225\187\147n t\225\186\161i!", name))
    return
  end
  if not map[id] and not isHideWarning then
    return
  end
  return map and map[id]
end

local enableCacheWhenFindConfigs = {cfg_Box_box = true, cfg_union_badge = true}
local findConfigsCache = {}

function ConfigManager.FindConfigs(name, key, value)
  FunctionProfiler.BeginSample(name, "ConfigManager.FindConfigs")
  FunctionProfiler.EndSample()
  local cfgs, tableCache, keyCache
  local enableCache = enableCacheWhenFindConfigs[name]
  if enableCache then
    tableCache = findConfigsCache[name]
    if tableCache then
      keyCache = tableCache[key]
      if keyCache then
        cfgs = keyCache[value]
        if cfgs then
          return cfgs
        end
      end
    end
  end
  FunctionProfiler.BeginSample(name, "ConfigManager.DoFindConfigs")
  cfgs = {}
  local tbl = this.GetConfigTable(name)
  if tbl then
    for k, v in ipairs(tbl) do
      if v[key] == value then
        table.insert(cfgs, v)
      end
    end
  end
  FunctionProfiler.EndSample()
  if enableCache then
    if not tableCache then
      tableCache = {}
      findConfigsCache[name] = tableCache
    end
    if not keyCache then
      keyCache = {}
      tableCache[key] = keyCache
    end
    keyCache[value] = cfgs
  end
  return cfgs
end

function ConfigManager.Preload()
  local skillGroupList = {}
  local tbl = this.GetConfigTable("cfg_Skill_skill")
  if tbl then
    for k, v in ipairs(tbl) do
      local group = skillGroupList[v.groupId]
      if group == nil then
        group = {}
        skillGroupList[v.groupId] = group
      end
      table.insert(group, v)
    end
  end
  this.skillGroupList = skillGroupList
  local cfg_Character_attribute_level_List = {}
  tbl = this.GetConfigTable("cfg_Character_attribute_level")
  if tbl then
    for k, v in ipairs(tbl) do
      local group = cfg_Character_attribute_level_List[v.level]
      if group == nil then
        group = {}
        cfg_Character_attribute_level_List[v.level] = group
      end
      table.insert(group, v)
    end
  end
  this.cfg_Character_attribute_level_List = cfg_Character_attribute_level_List
  local cfg_Item_equip_suit_list = {}
  tbl = this.GetConfigTable("cfg_Item_equip_suit")
  if tbl then
    for k, v in ipairs(tbl) do
      local group = cfg_Item_equip_suit_list[v.suitId]
      if group == nil then
        group = {}
        cfg_Item_equip_suit_list[v.suitId] = group
      end
      table.insert(group, v)
    end
  end
  this.cfg_Item_equip_suit_list = cfg_Item_equip_suit_list
end
