netMsgPreprocessing[101002] = function(msgID, tblData)
  if tblData ~= nil then
    if tblData.attackerId ~= nil then
      EffAnimatorController.UseSkillGetEffAniAndPlay(tblData.attackerId, tblData.skillId)
    end
    if tblData.attackerId == QuickFind.LuaMainPlayerViewAttrData().id then
      gameMgr:GetAvatarManager():GetMainPlayer():GetInfo():GetOtherAttr():SetMp(tblData.mp)
    elseif tblData.targetId == QuickFind.LuaMainPlayerViewAttrData().id then
      for i, v in pairs(tblData.hurtList) do
        if v.targetId == QuickFind.LuaMainPlayerViewAttrData().id then
          gameMgr:GetAvatarManager():GetMainPlayer():GetInfo():GetOtherAttr():SetHp(v.hp)
          return
        end
      end
    end
    if tblData.attackerId ~= nil and ViewData.meData.id == tblData.attackerId then
      EventManager.Dispatch(Event.CanNotCollectBox)
    end
  end
end
netMsgPreprocessing[101003] = function(msgID, tblData)
  if tblData ~= nil and tblData.lid == QuickFind.LuaMainPlayerViewAttrData().id then
    if tblData.type == 1 then
      gameMgr:GetAvatarManager():GetMainPlayer():GetInfo():GetOtherAttr():SetHp(tblData.value)
      gameMgr:GetAvatarManager():GetMainPlayer():GetInfo():GetOtherAttr().maxHp = tblData.maxValue
    elseif tblData.type == 2 then
      gameMgr:GetAvatarManager():GetMainPlayer():GetInfo():GetOtherAttr():SetMp(tblData.value)
      gameMgr:GetAvatarManager():GetMainPlayer():GetInfo():GetOtherAttr().maxMp = tblData.maxValue
    end
  end
end
netMsgPreprocessing[101005] = function(msgID, tblData)
  if tblData.lid == ViewData.meData.id then
    if tblData.reliveType == 2 then
      gameMgr:GetPromptDataManager():GetDeadStrengthenPromptDataManager():ShowDeadStrengthenPromptPanel()
    end
    QuickFind.LuaMainPlayerViewAttrData():SetAttributeByReliveInfo(tblData)
  end
end
netMsgPreprocessing[101008] = function(msgID, tblData)
  if tblData.attackerId == QuickFind.LuaMainPlayerViewAttrData().id then
    gameMgr:GetAvatarManager():GetMainPlayer():GetInfo():GetOtherAttr():SetMp(tblData.mp)
  end
end
netMsgPreprocessing[101009] = function(msgID, tblData)
end
netMsgPreprocessing[101011] = function(msgID, tblData)
end
netMsgPreprocessing[101012] = function(msgID, tblData)
  EventManager.Dispatch(Event.DieBuyRelive)
end
netMsgPreprocessing[101013] = function(msgID, tblData)
  EventManager.Dispatch(Event.BossDead, tblData)
end
