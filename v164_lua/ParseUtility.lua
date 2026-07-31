ParseUtility = {}
local this = ParseUtility

function ParseUtility:IsCareerIn(careerArrayText, roleCareer)
  if careerArrayText ~= nil and careerArrayText ~= "" and careerArrayText ~= "0" then
    local roleCareerPro = math.floor(roleCareer / 10)
    local roleCareerLevel = roleCareer % 10
    local careerEnough = false
    local careers = string.split(careerArrayText, "#")
    for _, v in pairs(careers) do
      local num = tonumber(v)
      local temPro = math.floor(num / 10)
      local temLevel = num % 10
      if roleCareerLevel == temLevel and roleCareerPro <= temPro then
        careerEnough = true
      end
    end
    return careerEnough
  end
  return true
end

function ParseUtility:IsSameCareerType(careerArrayText, roleCareer)
  local career = ERoleCareer.All
  if careerArrayText ~= nil and careerArrayText ~= "" and careerArrayText ~= "0" then
    local roleCareerLevel = roleCareer % 10
    local careerEnough = false
    local careers = string.split(careerArrayText, "#")
    for _, v in pairs(careers) do
      local num = tonumber(v)
      local temLevel = num % 10
      if roleCareerLevel == temLevel then
        careerEnough = true
        career = num
      end
    end
    return careerEnough, career
  end
  return true, career
end

function ParseUtility.ParseId(str)
  local tbl = {}
  if not string.isNullOrEmpty(str) then
    local reward = string.split(str, "#")
    for _, v in ipairs(reward) do
      table.insert(tbl, tonumber(v))
    end
  end
  return tbl
end

function ParseUtility.ParseSingleCost(str)
  local tbl = {}
  if not string.isNullOrEmpty(str) then
    local cost = string.split(str, "&")[1]
    local reward = string.split(cost, "#")
    tbl.itemId = tonumber(reward[1])
    tbl.count = tonumber(reward[2])
  end
  return tbl
end

function ParseUtility.ParsShopSingleCost(str)
  local tbl = {}
  if not string.isNullOrEmpty(str) then
    local shop = {}
    if string.contains(str, "&") then
      local strReward = string.split(str, "&")
      for i, v in ipairs(strReward) do
        local shop = {}
        local reward = string.split(v, "#")
        shop.itemId = tonumber(reward[1])
        shop.count = tonumber(reward[2])
        table.insert(tbl, shop)
      end
      return tbl
    end
    local reward = string.split(str, "#")
    shop.itemId = tonumber(reward[1])
    shop.count = tonumber(reward[2])
    table.insert(tbl, shop)
  end
  return tbl
end

function ParseUtility.ParseUIParam(str)
  local tbl = {}
  if not string.isNullOrEmpty(str) then
    local uiInfo = string.split(str, "#")
    if table.count(uiInfo) > 1 then
      tbl[1] = uiInfo[1]
      tbl[2] = tonumber(uiInfo[2])
    else
      tbl[1] = uiInfo[1]
    end
  end
  return tbl
end

function ParseUtility.CuttingParam(str)
  local tbl = {}
  if not string.isNullOrEmpty(str) then
    tbl = string.split(str, "#")
  end
  return tbl
end

function ParseUtility.AnalysisCondition(str)
  local conditons = string.split(str, "&")
  local conditionTbl = {}
  local conditionType
  for i = 1, #conditons do
    local condition = string.split(conditons[i], "#")
    if condition[1] == "201" and table.count(condition) > 2 then
      conditionType = tonumber(condition[1])
      conditionTbl[conditionType] = condition[2]
      for i, v in pairs(condition) do
        if v ~= "201" and RoleUtility.CareerJudge(ViewData.meData.career, tonumber(v)) then
          conditionType = tonumber(condition[1])
          conditionTbl[conditionType] = condition[i]
          break
        end
      end
    else
      conditionType = tonumber(condition[1])
      conditionTbl[conditionType] = condition[2]
    end
  end
  return conditionTbl
end

function ParseUtility.GetTblByAnalysisCondition(conditionCfg)
  local groupStr = string.split(conditionCfg, "/")
  local conditionTbl = {}
  for i = 1, #groupStr do
    conditionTbl[i] = ParseUtility.AnalysisCondition(groupStr[i])
  end
  return conditionTbl
end

function ParseUtility.GetTblByAnalysisParam(str)
  if not string.isNullOrEmpty(str) and string.contains(str, "&") then
    local levelTab = {}
    local globalTab = string.split(str, "&")
    for i, v in pairs(globalTab) do
      if string.contains(v, "#") then
        levelTab[tonumber(string.split(v, "#")[1])] = tonumber(string.split(v, "#")[2])
      end
    end
    return levelTab
  end
end
