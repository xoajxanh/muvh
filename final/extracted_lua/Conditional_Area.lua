Conditional_Area = class(BaseConditional)
Conditional_Area.name = "Conditional_Area"

function Conditional_Area:Calc(tblSkill, tblAction)
  if Scene.IsSafeZone(RoleManager.me.cellPos.x, RoleManager.me.cellPos.y) then
    return false
  end
  return true
end

function Conditional_Area:CalcTips(tblSkill, tblAction)
  if Scene.IsSafeZone(RoleManager.me.cellPos.x, RoleManager.me.cellPos.y) then
    FloatingTipUtility.QuickMsg("Kh\195\180ng th\225\187\131 thi tri\225\187\131n k\225\187\185 n\196\131ng trong khu an to\195\160n")
    return false
  end
  return true
end
