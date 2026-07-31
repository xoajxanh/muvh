local OnHookMainTblTemplate = {}

function OnHookMainTblTemplate:Init()
  self:InitComponents()
  self:InitData()
  self.img_clickeffect:SetActive(false)
end

function OnHookMainTblTemplate:InitComponents()
  self.img_clickeffect = self:GetControl("img_clickeffect")
  self.lab_level = self:GetControl("lab_level")
  self.subTbl = self:GetControl("subTbl")
  self:UIControl():SetOnClick(self, self.OnClick)
end

function OnHookMainTblTemplate:InitData()
  if self.subTblDic == nil then
    self.subTblDic = {}
  end
end

function OnHookMainTblTemplate:Refresh(data)
  self.data = data
  self.MainType = data.mainType
  if data == nil then
    return
  end
  self.lab_level:SetText(data.name)
end

function OnHookMainTblTemplate:RefreshMainTypeSelect(selectType)
  self.selectType = selectType
  self.img_clickeffect:SetActive(selectType == self.MainType)
  if selectType ~= self.MainType then
    self:RefreshSubTbl(nil)
  else
    self:RefreshSubTbl(self.data.condtionsubList)
  end
end

function OnHookMainTblTemplate:RefreshSubTbl(data)
  local subTblData = data
  if subTblData == nil then
    self.subTbl:SetTopGridMaxCount(0)
    return
  end
  self.subTbl:SetTopGridMaxCount(#subTblData)
  local index = 0
  for i, v in pairs(subTblData) do
    local go = self.subTbl:GetTopGridObjectList()[index]
    if self.subTblDic[go] == nil then
      self.subTblDic[go] = luaTemplateManager.GetNewTemplate(go, LuaComponentTemplates.OnHookSubTblTemplate)
    end
    index = index + 1
    self.subTblDic[go]:Refresh(v)
  end
end

function OnHookMainTblTemplate:OnClick()
  if self.selectType ~= self.MainType then
    local maintypeDef, subTypeDef = gameMgr:GetAvatarManager():GetMainPlayer():GetOnHook_PointData():GetDefaultSelect(self.MainType)
    EventManager.Dispatch(Event.OnHookMainTblSelect, self.MainType)
    EventManager.Dispatch(Event.OnHookSubTblSelect, subTypeDef)
  end
end

function OnHookMainTblTemplate:GetsubTblHeight(selectType)
  if selectType ~= self.MainType then
    return 0
  end
  if self.subTbl == nil then
    return 0
  end
  local lenght = UIUtility.GetDicLength(self.subTblDic)
  return lenght * self.subTbl:GetTopGridCellHeight()
end

function OnHookMainTblTemplate:RefreshSubSelect(selectType)
  for i, v in pairs(self.subTblDic) do
    v:RefreshSelectActive(selectType)
  end
end

return OnHookMainTblTemplate
