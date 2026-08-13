local BuffItem_MemberCardTemplate = {}
setmetatable(BuffItem_MemberCardTemplate, LuaComponentTemplates.BuffItem_BaseTemplate)

function BuffItem_MemberCardTemplate:GetMemberMgr()
  if gameMgr:GetAvatarManager() then
    return gameMgr:GetAvatarManager():GetMainPlayer():GetMemberDataMgr()
  end
  return nil
end

function BuffItem_MemberCardTemplate:InitTemplateType()
  self.buffItemType = EBuffItemType.Member
end

function BuffItem_MemberCardTemplate:GetCardTipsInfo()
  if self:GetMemberMgr() == nil then
    return nil, ""
  end
  local temporaryId = self:GetMemberMgr():GetTemporaryMemberLevle()
  local temporaryTime = self:GetMemberMgr():GetTemporaryMemberEndTime()
  local memberTotalTime = self:GetMemberMgr():GetTemporaryMemberTotalTime()
  local memberTbl = ClientTable.cfg_MemberManager:TryGetValue(temporaryId)
  if memberTbl then
    local strFormat = "k\195\173ch ho\225\186\161t c\195\179 th\225\187\131 nh\225\186\173n \196\145\225\186\183c quy\225\187\129n sau\n %s"
    local temp = {}
    temp.id = temporaryId
    temp.titleFormat = memberTbl.freeCards .. "\239\188\154\n %s"
    temp.str = string.format(strFormat, string.gsub(memberTbl.tips1, "&", "\n"))
    temp.endTime = temporaryTime / 1000
    temp.totalTime = memberTotalTime / 1000
    return temp, memberTbl.spirit
  end
  return nil, ""
end

function BuffItem_MemberCardTemplate:TimeEndCallBack()
  self:RunBaseFunction("TimeEndCallBack")
  local data = {}
  local cfg_memberSetting = ClientTable.cfg_Member_settingManager:TryGetValue(ECardType.EMemberCard)
  data.memberCardData = cfg_memberSetting
  if data.memberCardData then
    if data.memberCardData.showtype == 1 then
      if not UIManager.IsVisible(UIID.MainMenuUI) then
        ExpiredPromptData.AddExpired(ExpiredTypeEnum.PrivilegeCard, data)
      elseif ExpiredPromptData.isTraverseUI(ExpiredTypeEnum.PrivilegeCard, data) then
        ExpiredPromptData.ShowSortUI(ExpiredTypeEnum.PrivilegeCard, data)
      end
    end
    gameMgr:GetAvatarManager():GetMainPlayer():GetMemberDataMgr():CardInfo(IndexerEnum.set, data)
    EventManager.Dispatch(Event.MemberPrivilegeCardBubbleTips)
    ExpiredPromptData.TraverseShowUI()
  end
end

return BuffItem_MemberCardTemplate
