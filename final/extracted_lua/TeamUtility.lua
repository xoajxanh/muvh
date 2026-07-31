TeamUtility = {}

function TeamUtility.IsTeammate(lid)
  if type(lid) ~= "number" then
    return false
  end
  if QuickFind:GetThreeVsThreeDataMgr():IsInActivity() then
    return QuickFind:GetThreeVsThreeDataMgr():IsTeammate(lid)
  end
  return false
end
