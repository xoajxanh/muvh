local BossUI_TitleTogTemp = {}

function BossUI_TitleTogTemp:Init()
  self.lab_boss = self:GetControl("lab_bossSecret")
  self.tog = self:GetControl("")
  self:SetTogIsOn(false)
  self.index = BossTogType.none
end

function BossUI_TitleTogTemp:SetTogIsOn(isOn)
  if self.tog then
    self.tog:SetIsOn(isOn)
  end
end

function BossUI_TitleTogTemp:InitTogOn(index)
  if self.tog then
    self.tog:SetIsOn(self.index == index)
  end
end

function BossUI_TitleTogTemp:Refresh(data, ui)
  if data == nil then
    return
  end
  if self.lab_boss then
    self.lab_boss:SetText(data.text)
  end
  self.index = data.index
  self.tog:SetOnToggleChanged(self, self.OnClickTog)
  self.tog.gameObject.name = data.name
  BossData:InitTogObject(self.index, self.tog)
  self:SetTogIsOn(data.index == BossData:GSetCurTog())
end

function BossUI_TitleTogTemp:OnClickTog(tog)
  BossData:DoOnclick(self.tog, self.tog.toggle.isOn, self.index)
end

return BossUI_TitleTogTemp
