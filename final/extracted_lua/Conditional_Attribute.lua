Conditional_Attribute = class(BaseConditional)
Conditional_Attribute.name = "attributeCondition"

function Conditional_Attribute:Calc(tblSkill, tblAction)
  local conditional = tblSkill.useCondition
  local res = ConditionManager.Check(conditional)
  return res
end

function Conditional_Attribute:CalcTips(tblSkill, tblAction)
  if not table.isNullOrEmpty(tblSkill.useCondition2) and not ConditionManager.Check(tblSkill.useCondition2) then
    local tipStr = ClientTable.cfg_Ui_wordManager:GetUi_wordCount("Skill_Usecondition_1")
    FloatingTipUtility.QuickMsg(tipStr)
    return false
  end
  local conditional = tblSkill.useCondition
  local res = ConditionManager.Check(conditional)
  if not res then
    FloatingTipUtility.QuickMsg("Kh\195\180ng th\225\187\131 d\195\185ng k\225\187\185 n\196\131ng")
  end
  return res
end
