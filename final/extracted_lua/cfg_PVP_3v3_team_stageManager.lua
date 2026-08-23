local cfg_PVP_3v3_team_stageManager = {}

function cfg_PVP_3v3_team_stageManager:GetName()
  return "cfg_PVP_3v3_team_stageManager"
end

function cfg_PVP_3v3_team_stageManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_PVP_3v3_team_stage")
  end
  return self.dic
end

setmetatable(cfg_PVP_3v3_team_stageManager, TableManagerBase)

function cfg_PVP_3v3_team_stageManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

function cfg_PVP_3v3_team_stageManager:GetTabListByType(type, typeKey)
  return self:BaseGetTabListByType(type, typeKey)
end

function cfg_PVP_3v3_team_stageManager:GetTabDataByStageAndLevel(stage, level)
  if stage == nil or level == nil then
    return
  end
  local cfg
  for i, v in pairs(self:GetDic()) do
    if v.stage == stage and v.level == level then
      cfg = v
      break
    end
  end
  return cfg
end

function cfg_PVP_3v3_team_stageManager:GetSeasonRewards()
  if self.allSeasonRewards == nil then
    self.allSeasonRewards = {}
    local tempSeasonRewards = {}
    for i, v in pairs(self:GetDic()) do
      if tempSeasonRewards[v.stage] == nil then
        tempSeasonRewards[v.stage] = {}
      end
      if tempSeasonRewards[v.stage][v.level] == nil and v.showItem ~= "" then
        tempSeasonRewards[v.stage][v.level] = v
        table.insert(self.allSeasonRewards, v)
      end
    end
    table.sort(self.allSeasonRewards, function(a, b)
      return a and b and a.stage < b.stage
    end)
  end
  return self.allSeasonRewards
end

return cfg_PVP_3v3_team_stageManager
