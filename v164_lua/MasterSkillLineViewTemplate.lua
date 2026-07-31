local MasterSkillLineViewTemplate = {}

function MasterSkillLineViewTemplate:Init()
  self:InitParams()
  self:InitControls()
  self:BindUIEvent()
end

function MasterSkillLineViewTemplate:InitParams()
  self.parentTbl = nil
  self.groupAndGoList = {}
  self.goAndTemplateDic = {}
end

function MasterSkillLineViewTemplate:InitControls()
  self.lineContainer = self:UIControl()
end

function MasterSkillLineViewTemplate:BindUIEvent()
end

function MasterSkillLineViewTemplate:Refresh(data, ui)
  self.parentTbl = ui
  self.skillGroup = data
  self:RefreshData()
  self:RefreshView()
end

function MasterSkillLineViewTemplate:RefreshData()
  self.LineInfoTbl = {}
  if self.skillGroup == nil then
    return
  end
  local lineTbl
  for i, v in pairs(self.skillGroup) do
    lineTbl = ClientTable.cfg_MasterSkill_detailManager:GetLineTblBySkillGroup(v.skillGroup)
    if lineTbl then
      table.combine(self.LineInfoTbl, lineTbl)
    end
  end
end

function MasterSkillLineViewTemplate:RefreshView()
  local count = table.count(self.LineInfoTbl)
  self.lineContainer:SetTopGridMaxCount(count)
  local groupId, go
  for i = 1, count do
    groupId = self.LineInfoTbl[i].skillGroup
    go = self.lineContainer:GetTopGridObjectList()[i - 1].transform
    if go and groupId then
      if self.goAndTemplateDic[go] == nil then
        self.goAndTemplateDic[go] = luaTemplateManager.GetNewTemplate(go, LuaComponentTemplates.MasterSkillLineItemTemplate)
      end
      if self.groupAndGoList[groupId] == nil then
        self.groupAndGoList[groupId] = {}
      end
      table.insert(self.groupAndGoList[groupId], go)
      self.goAndTemplateDic[go]:Refresh(self.LineInfoTbl[i], self.parentTbl)
    end
  end
end

function MasterSkillLineViewTemplate:TryRefreshAllLineState()
  for i, v in pairs(self.goAndTemplateDic) do
    v:TryChangeState()
  end
end

function MasterSkillLineViewTemplate:TryRefreshLineStateByGroup(group)
  local goTbl = self.groupAndGoList[group]
  if goTbl then
    for i, v in pairs(goTbl) do
      if self.goAndTemplate[v] then
        self.goAndTemplate[v]:TryChangeState()
      end
    end
  end
end

return MasterSkillLineViewTemplate
