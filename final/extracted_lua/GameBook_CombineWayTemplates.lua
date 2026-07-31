local GameBook_CombineWayTemplates = {}

function GameBook_CombineWayTemplates:Init()
  self:InitControls()
  self:InitData()
end

function GameBook_CombineWayTemplates:InitControls()
  self.lab_groupTitle = self:GetControl("lab_groupTitle")
  self.second_Container = self:GetControl("second_Container")
end

function GameBook_CombineWayTemplates:InitData()
  if self.recordDic == nil then
    self.recordDic = {}
  end
end

function GameBook_CombineWayTemplates:Refresh(_templateData)
  self.templateData = _templateData
  self.lab_groupTitle:SetText(self.templateData.cfg_gameguide.title)
  local combineArray = string.split(self.templateData.cfg_gameguide.combine, "&")
  local count = table.count(combineArray)
  self.second_Container:SetTopGridMaxCount(count)
  local index = 1
  for key, value in pairs(combineArray) do
    local go = self.second_Container:GetTopGridObjectList()[index - 1].transform
    if self.recordDic[go] == nil then
      self.recordDic[go] = luaTemplateManager.GetNewTemplate(go, LuaComponentTemplates.GameBook_CombineWaySecondTemplates)
    end
    local templateData = {
      cfg_gameguide = self.templateData.cfg_gameguide,
      itemIdStr = combineArray[index],
      ui = self.templateData.ui,
      serverData = {}
    }
    self.recordDic[go]:Refresh(templateData)
    index = index + 1
  end
end

return GameBook_CombineWayTemplates
