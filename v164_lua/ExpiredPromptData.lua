ExpiredPromptData = {}
local this = ExpiredPromptData
ExpiredTypeEnum = {
  MonthCard = enum(1),
  Efficient = enum(),
  MemberCard = enum(),
  PrivilegeCard = enum()
}
ExpiredPromptData.ShowSortUIName = {
  [1] = "MonthCardMaturit_Tips",
  [2] = "EfficientExpired_Tips",
  [3] = "MonthCardMaturit_Tips",
  [4] = "MonthCardMaturit_Tips"
}
this.ExpiredPromptInfo = {}

function ExpiredPromptData.AddExpired(type, ExpiredInfo)
  this.ExpiredPromptInfo[type] = ExpiredInfo
end

function ExpiredPromptData.RemoveAllExpired()
  this.ExpiredPromptInfo = {}
end

function ExpiredPromptData.RemoveExpiredByType(Type)
  this.ExpiredPromptInfo[Type] = nil
end

function ExpiredPromptData.ShowSortUI(type, data)
  gameMgr:GetAvatarManager():GetMainPlayer():GetMemberDataMgr():CardType(IndexerEnum.set, type)
  local UIName = this.ShowSortUIName[type]
  UIManager.Show(UIName, data)
end

function ExpiredPromptData.isTraverseUI(type, data)
  for i, v in pairs(this.ShowSortUIName) do
    if i < type and UIManager.IsVisible(v) then
      this.ExpiredPromptInfo[i] = data
      return false
    end
  end
  return true
end

function ExpiredPromptData.TraverseShowUI()
  for i, v in pairs(this.ExpiredPromptInfo) do
    if v then
      if i == ExpiredTypeEnum.PrivilegeCard then
        this.ShowSortUI(i, v)
        break
      elseif i == ExpiredTypeEnum.MemberCard then
        this.ShowSortUI(i, v)
        break
      elseif i == ExpiredTypeEnum.Efficient and v <= 0 then
        this.ShowSortUI(i)
        break
      end
    end
  end
end
