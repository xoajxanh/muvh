local RefreshRankTemplate = {}

function RefreshRankTemplate:Init()
  self:InitControls()
end

function RefreshRankTemplate:InitControls()
  self.lab_rank = self:GetControl("lab_rank")
  self.lab_img_rank = self:GetControl("lab_img_rank")
  self.lab_name = self:GetControl("lab_name")
  self.lab_career = self:GetControl("lab_career")
  self.lab_rechargeNum = self:GetControl("lab_rechargeNum")
end

function RefreshRankTemplate:Refresh(data, ui)
  if not data then
    return
  end
  self.data = data
  self.ui = ui
  self:RefreshRankUI()
end

function RefreshRankTemplate:RefreshRankUI()
  local data = self.data
  local career = RoleUtility.GteCareerNameByType(data.career)
  self.lab_career:SetText(career)
  self.lab_rechargeNum:SetText(data.rechargeNum)
  self.lab_name:SetText(data.name)
  if data.rank and data.rank > 0 and data.rank <= 3 then
    self.ui:SetSprite("Atlas_Main", "ico_l" .. data.rank, self.lab_img_rank)
    self.lab_rank:SetText(data.rank)
    self.lab_img_rank:SetActive(true)
  else
    self.lab_rank:SetText(data.rank)
    self.lab_img_rank:SetActive(false)
  end
end

return RefreshRankTemplate
