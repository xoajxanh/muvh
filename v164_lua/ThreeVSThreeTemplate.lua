local ThreeVSThreeTemplate = {}

function ThreeVSThreeTemplate:Init()
  self:InitControls()
end

function ThreeVSThreeTemplate:InitControls()
  self.lab_name = self:GetControl("lab_name")
  self.img_career = self:GetControl("img_career")
  self.img_select = self:GetControl("img_select")
  self.lab_level = self:GetControl("lab_level")
end

function ThreeVSThreeTemplate:Refresh(data, ui)
  if not data then
    return
  end
  self.data = data
  self.root = ui
  self.img_select:SetActive(false)
  self:ThreeVSThreeImageRefresh()
end

function ThreeVSThreeTemplate:ThreeVSThreeImageRefresh()
  local spriteName = ClientTable.cfg_Character_attributeManager:TryGetValue(self.data.career, "id")
  if spriteName then
    self.root:SetSprite("Atlas_headPortrait", spriteName.headPortrait, self.img_career)
  end
  self.img_select:SetActive(self.data.id == ViewData.meData.id)
  self.lab_name:SetText(self.data.name)
  local level
  if type(self.data.level) == "number" then
    level = ClientTable.cfg_Character_levelManager:TryGetValue(self.data.level, "level").name
  else
    level = self.data.level
  end
  self.lab_level:SetText(level)
end

return ThreeVSThreeTemplate
