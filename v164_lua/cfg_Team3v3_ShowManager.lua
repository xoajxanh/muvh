local cfg_Team3v3_ShowManager = {}

function cfg_Team3v3_ShowManager:GetName()
  return "cfg_Team3v3_ShowManager"
end

function cfg_Team3v3_ShowManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Team3v3_Show")
  end
  return self.dic
end

setmetatable(cfg_Team3v3_ShowManager, TableManagerBase)

function cfg_Team3v3_ShowManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

function cfg_Team3v3_ShowManager:GetTabListByType(type, typeKey)
  return self:BaseGetTabListByType(type, typeKey)
end

function cfg_Team3v3_ShowManager:GetTabListByMeetsCondition()
  local rewardData = {}
  local careerEquipDict = {}
  local suitTypeAdded = {}
  local tbl = self:GetDic()
  for i, v in ipairs(tbl) do
    if v.type == 1 then
      local suitType = v.suitType or 0
      if not suitTypeAdded[suitType] then
        table.insert(rewardData, {
          suitType = v.suitType,
          type = v.type,
          size = tonumber(v.showRate),
          rewardName = v.rewardName
        })
        suitTypeAdded[suitType] = true
      end
      local careerTbl = string.split(v.show, "&")
      for j, k in ipairs(careerTbl) do
        local isShow = string.split(k, "#")
        local curCareer = tonumber(isShow[1])
        if isShow[2] == "1" then
          local itemTbl = string.split(v.itemId, "#")
          if not careerEquipDict[curCareer] then
            careerEquipDict[curCareer] = {}
          end
          if not careerEquipDict[curCareer][suitType] then
            careerEquipDict[curCareer][suitType] = {}
          end
          table.insert(careerEquipDict[curCareer][suitType], tonumber(itemTbl[j]))
        end
      end
    else
      local otherTbl = string.split(v.itemId, "#")
      table.insert(rewardData, {
        suitType = v.suitType,
        itemId = tonumber(otherTbl[1]),
        type = v.type,
        size = tonumber(v.showRate),
        rewardName = v.rewardName
      })
    end
  end
  table.sort(rewardData, function(a, b)
    if a.type and b.type then
      return a.type < b.type
    else
      return false
    end
  end)
  return rewardData, careerEquipDict
end

return cfg_Team3v3_ShowManager
