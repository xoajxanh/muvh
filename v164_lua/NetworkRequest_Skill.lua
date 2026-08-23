function networkRequest.ReqLearnSkill(skillId)
  local reqTable = {}
  
  if skillId ~= nil then
    reqTable.skillId = skillId
  end
  NetManager.Send(SkillMessage.ReqLearnSkill, reqTable)
end
