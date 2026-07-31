local SkillTemplate = {}
SkillTemplate.skillID = 0

function SkillTemplate:Init()
  self:InitComponent()
  self:BindEvent()
end

function SkillTemplate:InitComponent()
  self.icon_skill = self:GetControl("icon_skill")
  self.skillIco = self:GetControl("icon_skill/skillIco")
  self.skillLevel = self:GetControl("icon_skill/skillLevel")
  self.skillSelect = self:GetControl("icon_skill/skillSelect")
end

function SkillTemplate:BindEvent()
  if self.icon_skill then
    self.icon_skill:SetOnClick(self, function()
      EventManager.Dispatch(Event.MasterTipsOpen, self.skillID)
    end)
  end
end

function SkillTemplate:Refresh(data, ui)
  if data == nil then
    return
  end
  self.skillIco:SetSprite(data.icon)
  self.skillLevel:SetText(string.format("%d/%d", data.masterSkillLevel, data.maxLevel))
  self.skillSelect:SetActive(data.seniorSkill > 0)
end

return SkillTemplate
