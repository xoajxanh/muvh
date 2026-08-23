local SuitSwitchTemplate = {}

function SuitSwitchTemplate:Init()
  self:InitControls()
end

function SuitSwitchTemplate:InitControls()
  self.nowControl = self:GetControl()
  self.nowControl:SetOnClick(self, self.nowControlOnClick)
end

function SuitSwitchTemplate:InitData()
  self.spriteCol = nil
end

function SuitSwitchTemplate:Refresh(data, ui)
  self.suitType = data.suitType
  self.rootUI = ui
  local tbl = ClientTable.cfg_Item_equip_bingjianManager:TryGetValue(data.suitType, "cellType")
  if tbl ~= nil then
    if self.spriteCol ~= nil then
      Coroutine.Stop(self.spriteCol)
      self.spriteCol = nil
    end
    if data.isSelect then
      self.spriteCol = ui:SetSprite("Atlas_Common", tbl.iconName2, self.nowControl)
    else
      self.spriteCol = ui:SetSprite("Atlas_Common", tbl.iconName1, self.nowControl)
    end
    self.suitName = tbl.titleSprite
  end
end

function SuitSwitchTemplate:nowControlOnClick()
  local suitInfoTbl = {
    type = self.suitType,
    name = self.suitName
  }
  EventManager.Dispatch(Event.SuitChange, suitInfoTbl)
end

return SuitSwitchTemplate
