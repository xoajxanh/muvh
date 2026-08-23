BuffUtility = {}
local this = BuffUtility

function BuffUtility.HasBuff(buffId)
  if BuffData.GetBuff(ViewData.meData.id, buffId) then
    return true
  end
  return false
end
