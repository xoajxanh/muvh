local CrystalNucleusPedestalAdvancedItemPointTemplate = {}

function CrystalNucleusPedestalAdvancedItemPointTemplate:Init()
  self:InitControls()
end

function CrystalNucleusPedestalAdvancedItemPointTemplate:InitControls()
  self.img_ItemBg = self:GetControl("img_Itembg")
  self.img_Lock = self:GetControl("img_Lock")
  self.ima_Icon = self:GetControl("img_Icon")
  self.img_LockNext = self:GetControl("img_Lock_next")
end

function CrystalNucleusPedestalAdvancedItemPointTemplate:Refresh(_data, _ui)
  if _data == nil or _ui == nil then
    return
  end
  self:Reset()
  self.data = _data
  self.rootUI = _ui
  self:RefreshUnlockState()
  self:RefreshNextUnlockState()
end

function CrystalNucleusPedestalAdvancedItemPointTemplate:RefreshUnlockState()
  self.img_Lock:SetActive(not self.data.m_Unlock)
end

function CrystalNucleusPedestalAdvancedItemPointTemplate:RefreshNextUnlockState()
  if self.data.m_Unlock then
    return
  end
  local currentLevel = CrystalNucleusManager:GetPedestalLevel()
  local puzzleHoleConfig = ClientTable.cfg_puzzle_holeManager:TryGetValue(currentLevel + 1, "unlockLevel")
  if puzzleHoleConfig == nil or puzzleHoleConfig.position == nil then
    return
  end
  local nextUnlock = false
  for i, v in pairs(puzzleHoleConfig.position) do
    if v and v == self.data.m_Index then
      nextUnlock = true
    end
  end
  self.img_LockNext:SetActive(nextUnlock)
end

function CrystalNucleusPedestalAdvancedItemPointTemplate:Reset()
  self.img_Lock:SetActive(false)
  self.img_LockNext:SetActive(false)
end

return CrystalNucleusPedestalAdvancedItemPointTemplate
