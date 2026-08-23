local GoalUI_KSBattleRankTemp = {}
setmetatable(GoalUI_KSBattleRankTemp, LuaComponentTemplates.NightFightRankTemplate)

function GoalUI_KSBattleRankTemp:IsShowCareer()
  return false
end

function GoalUI_KSBattleRankTemp:IsShowLevel()
  return false
end

function GoalUI_KSBattleRankTemp:IsShowReward()
  return false
end

function GoalUI_KSBattleRankTemp:IsShowMaxKill()
  return false
end

return GoalUI_KSBattleRankTemp
