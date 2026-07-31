local OnHookBossPosTemplate = {}

function OnHookBossPosTemplate:Init()
  self.lab_mapName = self:GetControl("lab_mapName")
  self.lab_bossCount = self:GetControl("lab_bossCount")
  self.lab_level = self:GetControl("lab_level")
  self.img_jianTou = self:GetControl("img_jianTou")
  self:InitControl()
  self:UIControl():SetOnClick(self, self.OnClick)
end

function OnHookBossPosTemplate:InitControl()
  self.lab_bossCount:SetText("")
  self.lab_level:SetText("")
  self.img_jianTou:SetActive(false)
end

function OnHookBossPosTemplate:Refresh(data, ui)
  self.data = data
  if data == nil then
    return
  end
  self.tableID = data.id
  local Strtemp = string.split(data.position, "&")
  local levelText = string.format("<color=green>%s</color>", #Strtemp)
  self.IsNeedCondition = ConditionManager.Check4D(data.entryCondition)
  if self.IsNeedCondition == false then
    levelText = string.format("<color=red>%s</color>", data.entryConditionShow)
  end
  self.lab_mapName:SetText(data.mapName)
  self.lab_level:SetText(levelText)
end

function OnHookBossPosTemplate:OnClick()
  if self.IsNeedCondition == false then
    FloatingTipUtility.QuickMsg("\196\144i\225\187\129u ki\225\187\135n kh\195\180ng th\225\187\143a")
    return
  end
  local OnHookBossMapSelectInfo = {
    go = self.go,
    tableData = self.data
  }
  EventManager.Dispatch(Event.OnHookBossMapSelect, OnHookBossMapSelectInfo)
end

function OnHookBossPosTemplate:SetSelect(isNeedSelect)
  self.img_jianTou:SetActive(isNeedSelect)
end

return OnHookBossPosTemplate
