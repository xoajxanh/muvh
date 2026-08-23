UnionAttributeCalculator = {}
local this = UnionAttributeCalculator

function UnionAttributeCalculator.CalcUnionAttributes(rid, career)
  if RoleManager.me == nil or RoleManager.me and rid ~= RoleManager.me.id then
    return
  end
  if gameMgr:GetAvatarManager() == nil or gameMgr:GetAvatarManager():GetMainPlayer() == nil or gameMgr:GetAvatarManager():GetMainPlayer():GetUnionArmbandDataMgr() == nil then
    return
  end
  local armbandDic = gameMgr:GetAvatarManager():GetMainPlayer():GetUnionArmbandDataMgr():GetAllArmbandData()
  if armbandDic == nil or table.count(armbandDic) == 0 then
    return
  end
  local tbl = {}
  local attributeTbl = {}
  for key, value in pairs(armbandDic) do
    tbl = ClientTable.cfg_union_badgeManager:TryGetValue(value.id)
    if tbl then
      local result = AttributeConfig.GetTableAttributes(tbl)
      if result and table.count(result) > 0 then
        for i, v in pairs(result) do
          if attributeTbl[i] == nil then
            attributeTbl[i] = v
          else
            attributeTbl[i] = v + attributeTbl[i]
          end
        end
      end
    end
  end
  return attributeTbl
end
