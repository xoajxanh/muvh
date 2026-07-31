local AnniversaryActivityPageTemplate = {}

function AnniversaryActivityPageTemplate:Init()
  self:InitControls()
end

function AnniversaryActivityPageTemplate:InitControls()
  self.img_clickeffect = self:GetControl("img_clickeffect")
  self.lab_name = self:GetControl("lab_name")
  self.img_redPoint = self:GetControl("img_redPoint")
end

function AnniversaryActivityPageTemplate:Refresh(data, ui)
  self:UIControl().data = data
  self.basePanel = ui
  self:UIControl():SetOnClick(ui, ui.BtnHolidayOnClick)
  self.lab_name:SetText(data.commerceName)
  self.img_clickeffect:SetActive(data.Selected)
end

function AnniversaryActivityPageTemplate:SetClickEffect(isActive)
  self.img_clickeffect:SetActive(isActive)
end

function AnniversaryActivityPageTemplate:CheckRedPoint()
  local state = false
  if self:UIControl().data.group then
    local group = self:UIControl().data.group
    if group == AnniversaryActivityEnum.SignIn then
      state = AnniversaryActivity_SignInData.CheckRedPoint()
    elseif group == AnniversaryActivityEnum.NpcActivity then
      state = AnniversaryActivity_NPCActivityData.CheckRedPoint()
    elseif group == AnniversaryActivityEnum.BattleOrder then
      state = AnniversaryActivity_BattleOrderData.CheckRedPoint()
    elseif group == AnniversaryActivityEnum.NewCharacter then
      state = AnniversaryActivity_NewCharacterData.CheckRedPoint()
    elseif group == AnniversaryActivityEnum.Monster then
      state = AnniversaryActivity_MonsterData.CheckRedPoint()
    end
  else
    return
  end
  self.img_redPoint:SetActive(state)
end

return AnniversaryActivityPageTemplate
