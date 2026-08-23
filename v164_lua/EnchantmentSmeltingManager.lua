local EnchantmentSmeltingManager = {}
local SelectItemData

function EnchantmentSmeltingManager:RefreshEnchantmentSmelting()
end

function EnchantmentSmeltingManager:GetSelectItemData()
  return SelectItemData
end

function EnchantmentSmeltingManager:SetSelectItemData(data)
  SelectItemData = data
end

return EnchantmentSmeltingManager
