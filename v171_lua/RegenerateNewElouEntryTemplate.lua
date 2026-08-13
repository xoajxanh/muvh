local RegenerateNewElouEntryTemplate = {}

function RegenerateNewElouEntryTemplate:Init()
  self:InitParams()
  self:InitControls()
end

function RegenerateNewElouEntryTemplate:InitParams()
end

function RegenerateNewElouEntryTemplate:InitControls()
  self.lab_name = self:GetControl("lab_name")
  self.lab_old = self:GetControl("lab_old")
  self.lab_new = self:GetControl("lab_new")
end

function RegenerateNewElouEntryTemplate:Refresh(data)
  local regenerateEquip = gameMgr:GetAvatarManager():GetMainPlayer():GetRegenerateDataMgr().RegenerateEquipCellData.itemData
  local level = ClientTable.cfg_Item_equip_regenerateEvolutionManager:GetRegenerateLevelList(regenerateEquip.tblItem.subType)
  local regenerateup, regenerateValueup
  if level > regenerateEquip.serverInfo.regenerateLevel then
    regenerateup = MeEquipController.GetEquipregenerate(regenerateEquip.tblItem.subType, regenerateEquip.serverInfo.regenerateLevel + 1 or 0)
    regenerateValueup = regenerateup.value
  end
  self.attributeInfo = data
  local itembol = self:EquipId(regenerateEquip.RegenerateAttributeList, self.attributeInfo.configid)
  local orginalValuenum = self.attributeInfo.orginalValue
  local orginalValue = self.attributeInfo.orginalValue / 100
  local numValue = self.attributeInfo.attributeValue
  local num = self.attributeInfo.attributeValue / 100
  if self.attributeInfo then
    self.lab_nameRefresh = ""
    local text, numStr = self.attributeInfo.attributeInfo:match("(.*) (.*)")
    if text and numStr then
      self.lab_nameRefresh = text
    end
    if string.contains(self.attributeInfo.attributeInfo, "%%") then
      if math.floor(tostring(tonumber(num * 100)):gsub("%.0$", "")) % 100 == 0 then
        self.lab_oldRefresh = math.floor(num) .. ".00%"
      elseif math.floor(tostring(tonumber(num * 100)):gsub("%.0$", "")) % 10 == 0 then
        self.lab_oldRefresh = num .. "0%"
      else
        self.lab_oldRefresh = num .. "%"
      end
      if level > regenerateEquip.serverInfo.regenerateLevel then
        local numNew = (orginalValue + orginalValue * regenerateValueup / 10000) * 100
        local str = tostring(numNew):gsub("%.0$", "")
        local num = tonumber(math.floor(str))
        local numstr = num * 0.01
        if tonumber(str) % 10 == 0 then
          self.lab_newRefresh = numstr .. "0%"
        else
          self.lab_newRefresh = numstr .. "%"
        end
      else
        self.lab_newRefresh = "\196\144\195\163 \196\145\225\186\167y c\225\186\165p"
      end
    else
      self.lab_oldRefresh = numValue
      if level > regenerateEquip.serverInfo.regenerateLevel then
        self.lab_newRefresh = math.floor(orginalValuenum + orginalValuenum * regenerateValueup / 10000)
      else
        self.lab_newRefresh = "\196\144\195\163 \196\145\225\186\167y c\225\186\165p"
      end
    end
    self:RefreshView()
  end
end

function RegenerateNewElouEntryTemplate:RefreshView()
  if self.attributeInfo == nil then
    return
  end
  self.lab_name:SetText(self.lab_nameRefresh or "")
  self.lab_old:SetText(self.lab_oldRefresh or "")
  self.lab_new:SetText(self.lab_newRefresh or "")
end

function RegenerateNewElouEntryTemplate:EquipId(itemtable, configLevelId)
  for i, v in pairs(itemtable) do
    if v.RegenerateAttribute[1].attributeName == "levelEnergyReduce" and v.configid == configLevelId then
      return true
    end
  end
end

return RegenerateNewElouEntryTemplate
