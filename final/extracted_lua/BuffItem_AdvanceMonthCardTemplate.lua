local BuffItem_AdvanceMonthCardTemplate = {}
setmetatable(BuffItem_AdvanceMonthCardTemplate, LuaComponentTemplates.BuffItem_BaseTemplate)

function BuffItem_AdvanceMonthCardTemplate:GetMainPlayerEquipsData()
  if RoleManager.me and RoleManager.me.data then
    return RoleManager.me.data.equipsData
  end
  return nil
end

function BuffItem_AdvanceMonthCardTemplate:InitTemplateType()
  self.buffItemType = EBuffItemType.AdvanceMonthCard
end

function BuffItem_AdvanceMonthCardTemplate:GetCardTipsInfo()
  if self:GetMainPlayerEquipsData() == nil then
    return nil, ""
  end
  local monthCardInfo = self:GetMainPlayerEquipsData().StoneData[CommercializeEquipCell.GoldCard]
  if monthCardInfo and monthCardInfo.tblItem and monthCardInfo.tblEquip then
    local temp = {}
    temp.id = monthCardInfo.itemId
    temp.titleFormat = monthCardInfo.tblItem.name .. "\196\144\225\186\191m ng\198\176\225\187\163c :\n %s"
    temp.str = self:GetTipsStr(monthCardInfo.itemId)
    temp.endTime = monthCardInfo.time / 1000
    temp.totalTime = monthCardInfo.tblEquip.equipTime / 1000
    return temp, nil
  end
  return nil, ""
end

function BuffItem_AdvanceMonthCardTemplate:TimeEndCallBack()
  self:RunBaseFunction("TimeEndCallBack")
  local data = {}
  local cfg_memberSetting = ClientTable.cfg_Member_settingManager:TryGetValue(ECardType.PrivilegeCard)
  data.privilegeCardData = cfg_memberSetting
  if data.privilegeCardData then
    if data.privilegeCardData.showtype == 1 then
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

function BuffItem_AdvanceMonthCardTemplate:GetTipsStr(id)
  local itemtbl = ClientTable.cfg_Item_tipsManager:TryGetValue(id)
  if itemtbl == nil or string.isNullOrEmpty(itemtbl.content) then
    return ""
  end
  local Grop = string.split(itemtbl.content, "\n")
  local text = ""
  for i, v in pairs(Grop) do
    if i == 2 then
      text = v
    elseif 2 < i then
      text = text .. "\n"
      text = text .. v
    end
  end
  return text
end

return BuffItem_AdvanceMonthCardTemplate
