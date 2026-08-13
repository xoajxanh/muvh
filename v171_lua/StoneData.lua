StoneData = class(EquipData)
setgetters(StoneData, {
  tblEquip = function(self)
    return ClientTable.cfg_Item_equipManager:TryGetValue(self.itemId)
  end
})

function StoneData:Init()
  ItemData.Init(self)
  self.valid = false
  self.attributeMap = {}
end

function StoneData:RefreshData(equip)
  ItemData.RefreshData(self, equip)
  self:SetValid(equip.valid)
  self.subType = self.tblItem.subType
end

function StoneData:SetValid(valid)
  self.valid = valid
end

function StoneData:GetAllAttributes()
  if self.valid then
    if ViewData.meData then
      local attrTabs = ConfigManager.FindConfigs("cfg_Item_stone_light", "itemID", self.itemId)
      local tab
      for i = 1, #attrTabs do
        local careerStr = string.split(attrTabs[i].career, "#")
        for n = 1, #careerStr do
          if RoleUtility.CareerJudge(ViewData.meData.career, tonumber(careerStr[n])) then
            tab = attrTabs[i]
            break
          end
        end
      end
      if tab then
        if self.attributeMap == nil then
          self.attributeMap = {}
        end
        AttributeConfig.GetTableAttributes(tab, self.attributeMap)
      else
        self.attributeMap = {}
      end
    else
      self.attributeMap = {}
    end
  else
    self.attributeMap = {}
  end
  return self.attributeMap
end

function StoneData:GetGenerateAttr(attr)
  local attrType = table.getKey(EAttributeType, attr)
  if self.attributeMap[EEquipeAttributeProviderSystem.GenerateAttr] then
    return self.attributeMap[EEquipeAttributeProviderSystem.GenerateAttr][attrType]
  end
end
