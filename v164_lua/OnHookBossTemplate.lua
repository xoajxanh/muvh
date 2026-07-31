local OnHookBossTemplate = {}

function OnHookBossTemplate:Init()
  self.img_wei = self:GetControl("img_wei")
  self.go_model2 = self:GetControl("go_model2")
  self.lab_bossName = self:GetControl("lab_bossName")
  self.Content = self:GetControl("tog_mapName/posScroll/Viewport/Content")
  self.lab_def = self:GetControl("lab_def")
  self.img_choose = self:GetControl("img_choose")
  if self.bossDic == nil then
    self.bossDic = {}
  end
  self.img_wei:SetActive(false)
  self.monsterEff = UIEffectUtility.SetUIEffect("Eff_UI_annuikuang07", self.img_choose, true, Vector3(1.5, 1.25, 1), Vector3(0, 0, 0))
end

function OnHookBossTemplate:Refresh(data, index)
  self.data = data
  self.index = index
  if data == nil or data.cfg_OnHook_PointList == nil then
    return
  end
  local monsterTbl = data.monstertable
  if monsterTbl then
    self.lab_bossName:SetText("Lv " .. monsterTbl.level .. "  " .. monsterTbl.name)
    self.lab_def:SetText("EXP: " .. UIUtility.GetShowUnitConversion(monsterTbl.monsterExp))
  end
  if self.monsterModel == nil then
    self.monsterModel = {}
  end
  if self.nowMonsterId ~= monsterTbl.id then
    local nowModel = self.monsterModel[self.nowMonsterId]
    if nowModel ~= nil then
      self.monsterModel[self.nowMonsterId]:SetHide()
    end
    if self.monsterModel[monsterTbl.id] == nil then
      self.monsterModel[monsterTbl.id] = UIMonsterUtility(monsterTbl.id, self.go_model2, data.scale, data.position, data.rotate)
    end
    self.nowMonsterId = monsterTbl.id
  end
  self.monsterModel[monsterTbl.id]:SetActive()
  self.Content:SetTopGridMaxCount(#data.cfg_OnHook_PointList)
  local index = 0
  for i, v in pairs(data.cfg_OnHook_PointList) do
    local go = self.Content:GetTopGridObjectList()[index]
    if self.bossDic[go] == nil then
      self.bossDic[go] = luaTemplateManager.GetNewTemplate(go, LuaComponentTemplates.OnHookBossPosTemplate)
    end
    index = index + 1
    self.bossDic[go]:Refresh(v)
  end
end

function OnHookBossTemplate:RefreshBossButtonSelect(data)
  if data == nil then
    for i, v in pairs(self.bossDic) do
      v:SetSelect(false)
    end
    return
  end
  for i, v in pairs(self.bossDic) do
    local isNeedSelect = data.go == i and data.tableData == v.data
    v:SetSelect(isNeedSelect)
  end
end

function OnHookBossTemplate:RefreshBossSelect(bossID)
  if self.data == nil or bossID == nil then
    self.img_choose:SetActive(false)
    return
  end
  local isSelect = tonumber(bossID) == self.data.monsterid
  self.img_choose:SetActive(tonumber(bossID) == self.data.monsterid)
  return isSelect, self.index
end

return OnHookBossTemplate
