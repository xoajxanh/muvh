local GoalUI_KSBattleMeRankTemp = {}
setmetatable(GoalUI_KSBattleMeRankTemp, LuaComponentTemplates.NightFightRankTemplate)

function GoalUI_KSBattleMeRankTemp:Refresh(data, ui)
  self:RunBaseFunction("Refresh", data, ui)
  self:UIControl():SetActive(data ~= nil)
end

function GoalUI_KSBattleMeRankTemp:IsShowRankIcon()
  return false
end

function GoalUI_KSBattleMeRankTemp:IsShowCareer()
  return false
end

function GoalUI_KSBattleMeRankTemp:IsShowLevel()
  return false
end

function GoalUI_KSBattleMeRankTemp:IsShowReward()
  return false
end

function GoalUI_KSBattleMeRankTemp:IsShowMaxKill()
  return false
end

return GoalUI_KSBattleMeRankTemp
