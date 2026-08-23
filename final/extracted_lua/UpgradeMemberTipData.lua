local UpgradeMemberTipData = {}
local rewardCount = 0

function UpgradeMemberTipData:Init(rcount)
  rewardCount = rcount
  self.addExp = 0
  self.curVipIndex = 0
  self.curSumExp = 0
  self.maxAddExp = 0
  self.upLevelId = 100
  self.sumExpList = ClientTable.cfg_MemberManager:GetExpList()
end

function UpgradeMemberTipData:InitData()
  self:InitCurVipIndex()
  self:InitCurSumExp()
  self:InitMaxAddExp()
  self:InitCurNextExp()
end

function UpgradeMemberTipData:GetMemberDataMgr()
  if gameMgr:GetAvatarManager() then
    return gameMgr:GetAvatarManager():GetMainPlayer():GetMemberDataMgr()
  end
  return nil
end

function UpgradeMemberTipData:InitCurNextExp()
  local nowExp = self:GetMemberDataMgr():GetCurExp()
  local maxExp = self:GetMemberDataMgr():GetCurTotalExp()
  self:SetAddExp(maxExp - nowExp)
end

function UpgradeMemberTipData:InitCurVipIndex()
  local curVipLevel = self:GetMemberDataMgr():GetMemberLevle()
  for i, v in ipairs(self.sumExpList) do
    if v.id == curVipLevel then
      self.curVipIndex = i
      break
    end
  end
end

function UpgradeMemberTipData:InitCurSumExp()
  if self.curVipIndex > 1 then
    self.curSumExp = self.sumExpList[self.curVipIndex - 1].sumVipExp + self:GetMemberDataMgr():GetCurExp()
  else
    self.curSumExp = self:GetMemberDataMgr():GetCurExp()
  end
end

function UpgradeMemberTipData:InitMaxAddExp()
  local maxExp = self.sumExpList[#self.sumExpList].sumVipExp
  local nowExp = self:GetMemberDataMgr():GetCurExp()
  if self.curVipIndex > 1 then
    local levelExp = self.sumExpList[self.curVipIndex - 1].sumVipExp
    self.maxAddExp = maxExp - levelExp - nowExp
  else
    self.maxAddExp = maxExp - nowExp
  end
end

function UpgradeMemberTipData:SetAddExp(exp)
  if exp < 0 then
    exp = 0
  elseif exp > self.maxAddExp then
    exp = self.maxAddExp
  end
  if exp % rewardCount ~= 0 then
    exp = exp + (rewardCount - exp % rewardCount)
  end
  self.addExp = exp
  self:RefreshUpLevel()
end

function UpgradeMemberTipData:RefreshUpLevel()
  local sumExp = self.curSumExp + self.addExp
  local index
  if self.curVipIndex == 0 then
    index = 1
  else
    index = self.curVipIndex
  end
  local isMax = true
  for i = index, #self.sumExpList do
    if sumExp < self.sumExpList[i].sumVipExp then
      self.upLevelId = self.sumExpList[i].id
      isMax = false
      break
    end
  end
  if isMax then
    self.upLevelId = self.sumExpList[#self.sumExpList].id
  end
  EventManager.Dispatch(Event.UpgradeMemberTipChanged)
end

function UpgradeMemberTipData:GetAddExp()
  return self.addExp
end

function UpgradeMemberTipData:GetUpLevelId()
  return self.upLevelId
end

return UpgradeMemberTipData
