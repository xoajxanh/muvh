local CrossServer_PreviewTemplate = {}

function CrossServer_PreviewTemplate:Init(rootUI)
  self:InitControls(rootUI)
  self:InitContainer()
end

function CrossServer_PreviewTemplate:InitControls(rootUI)
  self.rootUI = rootUI
  self.nowControl = self:GetControl()
  self.btn_activeList = self:GetControl("sw_GodCrossList/Viewport/Content/btn_activeList")
end

function CrossServer_PreviewTemplate:InitContainer()
  self.btn_activeListContainer = UIUtility.BindUIContainerTemp(self.btn_activeList, LuaComponentTemplates.CrossServer_Preview_PageTemplate, self.rootUI)
  local previewFuncList = ClientTable.cfg_Function_functionManager:GetPreviewFuncListByPreviewType(FunctionSystemPreviewType.CrossServer)
  self.planeContainer = {}
  for i, v in ipairs(previewFuncList) do
    local planeCtr = self:GetControl(v.previewRoute)
    if not IsNil(planeCtr.transform) then
      self.planeContainer[v.id] = luaTemplateManager.GetNewTemplate(planeCtr, LuaComponentTemplates.CrossServer_Preview_PlaneTemplate, {
        rootUI = self.rootUI,
        data = v
      })
    end
  end
end

function CrossServer_PreviewTemplate:InitData()
end

function CrossServer_PreviewTemplate:BindUIEvent()
end

function CrossServer_PreviewTemplate:Refresh()
  self:UIControl():SetActive(true)
  self:RefreshBtn_activeList()
  return true
end

function CrossServer_PreviewTemplate:RefreshBtn_activeList()
  local showPreviewFuncList = {}
  local previewFuncList = ClientTable.cfg_Function_functionManager:GetPreviewFuncListByPreviewType(FunctionSystemPreviewType.CrossServer)
  for i, v in pairs(previewFuncList) do
    if v.condition and ConditionManager.Check4D(v.condition) then
      table.insert(showPreviewFuncList, v)
    end
  end
  if type(showPreviewFuncList) ~= "table" or table.count(showPreviewFuncList) <= 0 then
    return
  end
  self.btn_activeListContainer:SetData(showPreviewFuncList)
  local pageTemplate = self.btn_activeListContainer.items[1].itemTemp
  if pageTemplate ~= nil then
    if pageTemplate:UIControl():GetIsOn() then
      self:RefreshPlane(showPreviewFuncList[1].id, true)
    else
      pageTemplate:UIControl():SetIsOn(true)
    end
  end
end

function CrossServer_PreviewTemplate:RefreshPlane(funcId, state)
  if funcId == nil or type(funcId) ~= "number" then
    return
  end
  local template = self:GetPlaneTemplate(funcId)
  if template ~= nil then
    if state then
      template:UIControl():SetActive(true)
      if template.Refresh ~= nil then
        template:Refresh()
      end
    else
      template:UIControl():SetActive(false)
      if template.Exit ~= nil then
        template:Exit()
      end
    end
  end
end

function CrossServer_PreviewTemplate:GetPlaneTemplate(funcId)
  if type(funcId) ~= "number" or self.planeContainer == nil then
    return
  end
  return self.planeContainer[funcId]
end

function CrossServer_PreviewTemplate:Exit()
  for i, template in pairs(self.planeContainer) do
    template:GetControl():SetActive(false)
    if template.Exit ~= nil then
      template:Exit()
    end
  end
  local pageTemplate
  if type(self.btn_activeListContainer) == "table" and type(self.btn_activeListContainer.items) == "table" then
    for k, v in pairs(self.btn_activeListContainer.items) do
      pageTemplate = v.itemTemp
      if pageTemplate.Exit ~= nil then
        pageTemplate:Exit()
      end
    end
  end
  self:UIControl():SetActive(false)
end

return CrossServer_PreviewTemplate
