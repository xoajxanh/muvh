local NightFightRankTemplate = {}

function NightFightRankTemplate:Init()
  self:InitControls()
  self:InitParams()
  self:BindUIEvent()
end

function NightFightRankTemplate:InitParams()
  self.parentTbl = nil
  self.rankData = nil
end

function NightFightRankTemplate:InitControls()
  self.lab_rank = self:GetControl("lab_rank")
  self.img_noRank = self:GetControl("img_noRank")
  self.img_rankIcon = self:GetControl("img_rankIcon")
  self.lab_Name = self:GetControl("lab_Name")
  self.lab_Career = self:GetControl("lab_occupation")
  self.lab_level = self:GetControl("lab_level")
  self.lab_integral = self:GetControl("lab_integral")
  self.lab_HighestKill = self:GetControl("lab_HighestKill")
  self.btn_giftItem = self:GetControl("lab_rank_gift/btn_giftItem")
end

function NightFightRankTemplate:BindUIEvent()
end

function NightFightRankTemplate:Refresh(data, ui)
  self.parentTbl = ui
  self.rankData = data
  self:InitRewardContainer()
  self:RefreshView()
end

function NightFightRankTemplate:InitRewardContainer()
  if self.itemContainer == nil and self.btn_giftItem and not IsNil(self.btn_giftItem.transform) then
    self.itemContainer = UIUtility.BindUIContainerTemp(self.btn_giftItem, LuaComponentTemplates.UIItemTemplate, self.parentTbl, {isShowTips = true})
  end
end

function NightFightRankTemplate:RefreshView()
  if self.rankData == nil then
    return
  end
  local isNoRank = self.rankData.rank == 0
  local isShowRankIcon = self:IsShowRankIcon() and self.rankData.rank <= 3
  if self.img_rankIcon and not IsNil(self.img_rankIcon.transform) then
    if isShowRankIcon and not isNoRank then
      self.parentTbl:SetSprite("Atlas_Main", "ico_" .. self.rankData.rank, self.img_rankIcon)
    else
      self.parentTbl:SetSprite("Atlas_Main", "", self.img_rankIcon)
    end
  end
  if self.lab_rank and not IsNil(self.lab_rank.transform) then
    if not isShowRankIcon and not isNoRank then
      self.lab_rank:SetText(tostring(self.rankData.rank))
    else
      self.lab_rank:SetText("")
    end
  end
  if self.img_noRank and not IsNil(self.img_noRank.transform) then
    self.img_noRank:SetActive(isNoRank)
  end
  if self.lab_Name and not IsNil(self.lab_Name.transform) then
    self.lab_Name:SetText(self.rankData.name)
  end
  if self.lab_Career and not IsNil(self.lab_Career.transform) then
    if self:IsShowCareer() and self.rankData.career then
      self.lab_Career:SetText(RoleUtility.GteCareerNameByType(self.rankData.career))
    else
      self.lab_Career:SetText("")
    end
  end
  if self.lab_level and not IsNil(self.lab_level.transform) then
    if self:IsShowLevel() and self.rankData.level then
      self.lab_level:SetText(tostring(self.rankData.level))
    else
      self.lab_level:SetText("0")
    end
  end
  if self.lab_integral and not IsNil(self.lab_integral.transform) then
    self.lab_integral:SetText(self.rankData.score and tostring(self.rankData.score) or "0")
  end
  if self.lab_HighestKill and not IsNil(self.lab_HighestKill.transform) then
    if self:IsShowMaxKill() and self.rankData.maxKill then
      self.lab_HighestKill:SetText(tostring(self.rankData.maxKill))
    else
      self.lab_HighestKill:SetText("0")
    end
  end
  self:RefreshRewardView()
end

function NightFightRankTemplate:RefreshRewardView()
  if self.itemContainer == nil then
    return
  end
  if not self:IsShowReward() or self.rankData.rank == nil then
    self.itemContainer:SetData({})
    return
  end
  local itemTbls = QuickFind:GetKunShouBattleDataMgr():GetRewardListByRank(self.rankData.rank)
  self.itemContainer:SetData(itemTbls or {})
end

function NightFightRankTemplate:IsCanClickItem()
  return false
end

function NightFightRankTemplate:IsShowRankIcon()
  return true
end

function NightFightRankTemplate:IsShowCareer()
  return true
end

function NightFightRankTemplate:IsShowLevel()
  return true
end

function NightFightRankTemplate:IsShowReward()
  return true
end

function NightFightRankTemplate:IsShowMaxKill()
  return true
end

function NightFightRankTemplate:OnDisable()
  if self.itemContainer then
    self.itemContainer:RemoveAll()
  end
end

return NightFightRankTemplate
