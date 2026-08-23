local Equip_StoneUI_Attribute = class()

function Equip_StoneUI_Attribute:ctor(trans, stoneCellItemUI)
  self.trans = trans
  self.stoneCellItemUI = stoneCellItemUI
  self:InitUI()
end

function Equip_StoneUI_Attribute:InitUI()
  if not self.stoneCellItemUI then
    return
  end
  self.tx_stoneOne = UIControl(self.trans.transform, "tx_stoneOne")
  self:SetAttributeInfo()
end

function Equip_StoneUI_Attribute:SetAttributeInfo()
  local obj
  for i = 1, table.count(self.stoneCellItemUI) do
    if i > self.trans.transform.childCount then
      obj = Instantiate(self.tx_stoneOne.gameObject)
      obj.transform:SetParent(self.trans.transform, false)
    else
      obj = self.trans.transform:GetChild(i - 1).gameObject
    end
    local stoneCellItem = self.stoneCellItemUI[i]
    local tx_stoneOne = UIControl(obj.transform)
    local lab_stoneAttributeOne = UIControl(obj.transform, "lab_stoneAttributeOne")
    self:SetAttributeItemInfo(stoneCellItem, tx_stoneOne, lab_stoneAttributeOne)
  end
end

function Equip_StoneUI_Attribute:SetAttributeItemInfo(stoneCellItem, tx_stoneOne, lab_stoneAttributeOne)
  if not stoneCellItem then
    return
  end
  tx_stoneOne:SetText(string.format("Kh\225\186\163m \196\144\195\161 %d", stoneCellItem.stoneCellIndex % 100))
  if stoneCellItem.stoneData and stoneCellItem.stoneData.valid then
    local tblEquip = stoneCellItem.stoneData.tblEquip
    lab_stoneAttributeOne:SetText(RoleEquipUtility.GetEquipStoneFirstAttri(tblEquip))
  elseif not stoneCellItem.stoneCellIsOpen then
    lab_stoneAttributeOne:SetText(string.format("Thu\225\187\153c t\195\173nh Tr\195\161c Vi\225\187\135t \196\145\225\187\167 %d d\195\178ng s\225\186\189 m\225\187\159", stoneCellItem.tabZhuoyueCount))
  else
    lab_stoneAttributeOne:SetText("Hi\225\187\135n kh\195\180ng kh\225\186\163m \196\145\195\161")
  end
end

return Equip_StoneUI_Attribute
