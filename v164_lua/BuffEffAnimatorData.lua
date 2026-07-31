BuffEffAnimatorData = {}

function BuffEffAnimatorData.Init()
end

BuffEffAnimatorData.Init()
local BuffAnchorAttack = {
  [1] = "attack",
  [2] = "attack2",
  [3] = "attack3",
  [4] = "attack4"
}

function BuffEffAnimatorData.GetAttack(min, max)
  math.randomseed(os.time())
  local min = min
  local max = max
  local randomInt = math.random(min, max)
  return BuffAnchorAttack[randomInt] and BuffAnchorAttack[randomInt] or "attack"
end

function BuffEffAnimatorData:AddObj(roleDic, buffCid, buffEffect)
  if roleDic and buffCid then
    if not roleDic[buffCid] then
      roleDic[buffCid] = buffEffect
      return
    end
    roleDic[buffCid] = buffEffect
  end
end

function BuffEffAnimatorData:GetObj(roleDic, buffCid)
  if buffCid and roleDic[buffCid] then
    return roleDic[buffCid]
  end
  return nil
end
