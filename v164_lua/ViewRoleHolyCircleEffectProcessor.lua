local ViewRoleHolyCircleEffectProcessor = {}
setmetatable(ViewRoleHolyCircleEffectProcessor, LuaClass.RoleHolyCircleEffectProcessor)

function ViewRoleHolyCircleEffectProcessor:RefreshLoadEffectData()
  if self:GetRole() == nil or self:GetRole().holyRingTbl == nil then
    return
  end
  local holyDataTbl = self:GetRole().holyRingTbl
  local count = table.count(holyDataTbl)
  for i = 1, count do
    if holyDataTbl[i] and holyDataTbl[i].itemId then
      table.insert(self.needLoadEffectDataTbl, {
        name = self.holyEffectNamePR .. i,
        itemId = holyDataTbl[i].itemId
      })
    end
  end
end

return ViewRoleHolyCircleEffectProcessor
