local Puzzle_JH_PanelQiangHuaTemplate = {}

function Puzzle_JH_PanelQiangHuaTemplate:Init()
  self:InitControls()
end

function Puzzle_JH_PanelQiangHuaTemplate:InitControls()
  self.img_physBaseDmgjiantou = self:GetControl("img_physBaseDmgjiantou")
  self.text_gong = self:GetControl("text_gong")
  self.text_physBaseDmg = self:GetControl("text_physBaseDmg")
  self.text_physBaseDmgnext = self:GetControl("text_physBaseDmgnext")
end

function Puzzle_JH_PanelQiangHuaTemplate:Refresh(data, ui)
  self.data = data
  self.parent = ui
  self.img_physBaseDmgjiantou:SetActive(true)
  self.text_physBaseDmgnext:SetActive(true)
  self:SetAttribute(self.data)
end

function Puzzle_JH_PanelQiangHuaTemplate:SetAttribute(data)
  local puzzleType, puzzleValue = "", ""
  local name, nameUp, minValue, maxValue, minValueUp, maxValueUp, puzzle_entry_levelup, puzzle_entry
  if self.parent.nucleusLevel then
    puzzle_entry = ClientTable.cfg_puzzle_entry_levelupManager:GetGrowUpLevel(data, self.parent.nucleusLevel)
    puzzle_entry_levelup = ClientTable.cfg_puzzle_entry_levelupManager:GetGrowUpLevel(data, self.parent.nucleusLevel + 1)
  end
  minValue, maxValue, name, puzzleType, puzzleValue = CrystalNucleusUtility:CheckEntryTableHaveValue(puzzle_entry)
  minValueUp, maxValueUp, nameUp = CrystalNucleusUtility:CheckEntryTableHaveValue(puzzle_entry_levelup)
  self.text_gong:SetText(name)
  if minValueUp then
    if maxValue and maxValueUp then
      self.text_physBaseDmg:SetText(puzzleValue .. minValue .. puzzleType .. "~" .. puzzleValue .. maxValue .. puzzleType)
      self.text_physBaseDmgnext:SetText(puzzleValue .. minValueUp .. puzzleType .. "~" .. puzzleValue .. maxValueUp .. puzzleType)
    else
      self.text_physBaseDmg:SetText(puzzleValue .. minValue .. puzzleType)
      self.text_physBaseDmgnext:SetText(puzzleValue .. minValueUp .. puzzleType)
    end
  else
    if maxValue then
      self.text_physBaseDmg:SetText(puzzleValue .. minValue .. puzzleType .. "~" .. puzzleValue .. maxValue .. puzzleType)
    else
      self.text_physBaseDmg:SetText(puzzleValue .. minValue .. puzzleType)
    end
    self.img_physBaseDmgjiantou:SetActive(false)
    self.text_physBaseDmgnext:SetActive(false)
  end
end

return Puzzle_JH_PanelQiangHuaTemplate
