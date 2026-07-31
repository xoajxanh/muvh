Conditional_Pet = class(BaseConditional)
BaseConditional.name = "petCondition"

function Conditional_Pet:Calc(tblSkill, tblAction)
  return true
end

function Conditional_Pet:CalcTips(tblSkill, tblAction)
  return true
end
