MountItemData = class(ItemData)

function MountItemData:ctor(equip, item, itemEquip)
  self.isActive = false
  self.valid = false
  if equip ~= nil then
    ItemData.ctor(self, equip)
    self.isActive = true
    self.valid = equip.valid
  end
  self.tblItem = item
  self.tblEquip = itemEquip
  self.itemId = item.id
  self.name = item.name
  self.icon = item.icon
  self.quality = item.quality
  self.type = item.type
  self.subType = item.subType
  self.fight = itemEquip.fight
  self.activeSkill = itemEquip.carryingSkills
  self.equipPosition = itemEquip.equipPosition
  local skillList = ConfigManager.skillGroupList[self.activeSkill]
  if skillList and 0 < #skillList then
    self.tblSkill = skillList[1]
    local tbltips = ClientTable.cfg_Item_tipsManager:TryGetValue(self.tblSkill.description)
    if tbltips then
      self.skillDesc = tbltips.content
    end
  end
  local modelpath = ClientTable.cfg_Item_mountManager:TryGetValue(self.itemId)
  self.model = modelpath.model
  self.route = modelpath.route
  self.cityride = modelpath.cityride
  self.height = modelpath.height
end
