BaseConditional = class()
BaseConditional.m_child = nil
BaseConditional.name = "baseCondition"

function BaseConditional:SetChild(child)
  self.m_child = child
end

function BaseConditional:Calc(tblSkill, tblAction)
  return true
end

function BaseConditional:CalcTips(tblSkill, tblAction)
  return true
end

function BaseConditional:Exec(tblSkill, tblAction)
  local bCalcResult = self:Calc(tblSkill, tblAction)
  if bCalcResult then
    if self.m_child ~= nil then
      return self.m_child:Exec(tblSkill, tblAction)
    else
      return true
    end
  end
  return false, self.name
end

function BaseConditional:ExecShowTips(tblSkill, tblAction)
  local bCalcResult = self:CalcTips(tblSkill, tblAction)
  if bCalcResult then
    if self.m_child ~= nil then
      return self.m_child:ExecShowTips(tblSkill, tblAction)
    else
      return true
    end
  end
  return false, self.name
end
