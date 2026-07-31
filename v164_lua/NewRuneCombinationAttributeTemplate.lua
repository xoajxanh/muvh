local NewRuneCombinationAttributeTemplate = {}

function NewRuneCombinationAttributeTemplate:Init(data)
  self.root = data.root
  self:InitControls()
  self:InitUI()
  self:BindUIEvent()
end

function NewRuneCombinationAttributeTemplate:InitControls()
  self.img_setSkill = self:GetControl("img_setSkill")
  self.img_skill = self:GetControl("img_setSkill/img_skill")
  self.rune = self:GetControl("grid_attribute/rune")
  self.lab_skill = self:GetControl("img_skill_ground_diwen/lab_skill")
  self.lab_TipSkill = self:GetControl("lab_TipSkill")
end

local function RuneImageCreate(ctr)
  ctr.img_runes = UIControl(ctr.transform, "img_runes")
end

local function RuneImageRefresh(ctr, k, spriteName, ui)
  ui:SetSprite("Atlas_Common", spriteName, ctr.img_runes)
end

function NewRuneCombinationAttributeTemplate:InitUI()
  self.runeImageContainer = UIContainer(self.rune, self.root, RuneImageCreate, RuneImageRefresh)
end

function NewRuneCombinationAttributeTemplate:BindUIEvent()
end

function NewRuneCombinationAttributeTemplate:Refresh(data, ui)
  self.data = data
  self.root = ui
  self:RefreshModel()
  self:RefreshUI()
  self:RefreshHight()
end

function NewRuneCombinationAttributeTemplate:RefreshHight()
  local height = self.lab_TipSkill.text.preferredHeight
  local lab_skillHeight = self.lab_skill.text.preferredHeight + 11
  local obj = self:UIControl()
  if height + lab_skillHeight >= obj.rectTransform.sizeDelta.y then
    obj.rectTransform.sizeDelta = Vector2(obj.rectTransform.sizeDelta.x, height + lab_skillHeight + 5)
    obj.rectTransform.anchoredPosition = Vector3(0, 0, 0)
  end
end

function NewRuneCombinationAttributeTemplate:RefreshModel()
  self.runeImageContainer:SetData(self.data.runeCombination)
end

function NewRuneCombinationAttributeTemplate:RefreshUI()
  if string.isNullOrEmpty(self.data.skillIcon) then
    self.img_skill:SetActive(false)
  else
    self.img_skill:SetActive(true)
    self.root:SetSprite("Atlas_Skill", self.data.skillIcon, self.img_skill)
    self.img_skill:SetColor(self.data.isAvtive and EUIColor.White or EUIColor.Gray)
  end
  local colorSkillName = string.format("%s<color=#E6E600> Lv.%s</color>", self.data.skillName, self.data.skillLevel)
  self.lab_skill:SetText(self.data.isAvtive and colorSkillName or string.GetWithoutColorText(colorSkillName))
  self.lab_TipSkill:SetText(self.data.isAvtive and self.data.skillDes or string.GetWithoutColorText(self.data.skillDes))
  self.lab_skill:SetColor(self.data.isAvtive and EUIColor.White or EUIColor.Gray)
  self.lab_TipSkill:SetColor(self.data.isAvtive and EUIColor.White or EUIColor.Gray)
end

return NewRuneCombinationAttributeTemplate
