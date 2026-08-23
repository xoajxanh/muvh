local Skill_SkillPreviewMenuTemplate = {}

function Skill_SkillPreviewMenuTemplate:Init(data)
  self:InitParams(data)
  self:InitControls()
  self:BindUIEvent()
end

function Skill_SkillPreviewMenuTemplate:InitParams(data)
  self.menuData = nil
  self.initData = data
  self.parentUI = data.UI
  self.pageViewTbl = data.pageViewTbl
  self.ClickMenuCallBack = data.ClickMenuCallBack
  self.subMenuContainer = nil
  self.continerTrans = nil
  self.tempSubMenuControl = nil
  self.isHaveSubMenu = false
end

function Skill_SkillPreviewMenuTemplate:InitControls()
  self.label = self:GetControl("lab_name")
  self.checkMark = self:GetControl("Checkmark")
end

function Skill_SkillPreviewMenuTemplate:BindUIEvent()
  self:UIControl():SetOnClick(self, self.ClickGoCallBack)
end

function Skill_SkillPreviewMenuTemplate:ClickGoCallBack(_, data)
  if self.ClickMenuCallBack then
    self.ClickMenuCallBack(self.pageViewTbl, data or self.menuData)
  end
end

function Skill_SkillPreviewMenuTemplate:Refresh(data)
  self.tempId = data.id
end

function Skill_SkillPreviewMenuTemplate:RefershMenuView(data)
  self.menuData = data
  self.label:SetText(self.menuData and self.menuData.str or nil)
end

function Skill_SkillPreviewMenuTemplate:RefreshMenuState(data)
  if self.menuData == nil then
    return
  end
  local state = self:CheckMenuStateByData(data)
  if self.checkMark and not IsNil(self.checkMark.gameObject) then
    self.checkMark:SetActive(state)
  end
  self:TryRefreshSubMenuState(data, state)
end

function Skill_SkillPreviewMenuTemplate:GetSubMenuDataByPageLevel()
  if self.subMenuData == nil then
    if self.menuData and self.menuData.pageLevel == 1 then
      self.subMenuData = self.menuData.idList
    else
      self.subMenuData = {}
    end
  end
  return self.subMenuData
end

function Skill_SkillPreviewMenuTemplate:GetSubMenuContinerTempTransByPageLevel()
  if self.menuData == nil then
    return
  end
  if self.menuData.pageLevel == 1 then
    return self.parentUI.ContentMain
  end
  return self.parentUI.ContentMain
end

function Skill_SkillPreviewMenuTemplate:TryRefreshSubMenuState(data, state)
  if not state then
    self:HideSubMenu()
    return
  end
  if not self.isHaveSubMenu then
    self:RefreshSubMenuView()
  end
  if table.count(self.subMenuData) > 0 and data.pageLevel == self.menuData.pageLevel then
    data = ClientTable.cfg_Skill_SkillPreviewManager:GetDefaultSkillDataByMenuData(data)
    if data then
      self:ClickGoCallBack(nil, data)
    end
    return
  end
  self:RefreshSubMenuItemState(data)
end

function Skill_SkillPreviewMenuTemplate:RefreshSubMenuItemState(data)
  if self.subMenuContainer == nil then
    return
  end
  for i, v in pairs(self.subMenuContainer.items) do
    if v and v.itemTemp then
      v.itemTemp:RefreshMenuState(data)
    end
  end
end

function Skill_SkillPreviewMenuTemplate:RefreshSubMenuView()
  if self.menuData == nil or self.parentUI == nil then
    return
  end
  local dataCount = table.count(self:GetSubMenuDataByPageLevel())
  if dataCount == 0 then
    return
  end
  if self.subMenuContainer == nil then
    self:CreateSubMenuContainer()
  end
  if self.continerTrans and not IsNil(self.continerTrans.gameObject) then
    self.continerTrans:SetActive(true)
  end
  self.subMenuContainer:SetData(self:GetSubMenuDataByPageLevel())
  for i, v in pairs(self.subMenuContainer.items) do
    if v and v.itemTemp then
      v.itemTemp:RefershMenuView(ClientTable.cfg_Skill_SkillPreviewManager:GetSkillInfoByPageLevel(self.menuData.pageLevel + 1, v.itemTemp.tempId))
    end
  end
  self.continerTrans:SetSiblingIndex(self:UIControl():GetSiblingIndex() + 1)
  self.continerTrans.transform.sizeDelta = Vector2.right * self.tempSubMenuWide + Vector2.up * (self.tempSubMenuHeight + self.subMenuSpacing) * dataCount
end

function Skill_SkillPreviewMenuTemplate:CreateSubMenuContainer()
  local temp = self:GetSubMenuContinerTempTransByPageLevel()
  if temp == nil or IsNil(temp.gameObject) then
    return
  end
  self.continerTrans = Instantiate(self:GetSubMenuContinerTempTransByPageLevel().transform)
  self.continerTrans = UIControl(self.continerTrans)
  if self.continerTrans == nil then
    return
  end
  self.continerTrans:SetParent(self:UIControl():GetParent())
  self.continerTrans.localPosition = Vector3.zero
  self.continerTrans.localScale = Vector3.one
  self.subMenuSpacing = self.continerTrans.verticalLayoutGroup.spacing
  self.tempSubMenuControl = UIControl(self.continerTrans.transform, "subTwo")
  self.tempSubMenuHeight = self.tempSubMenuControl.transform.sizeDelta.y
  self.tempSubMenuWide = self.tempSubMenuControl.transform.sizeDelta.x
  self.subMenuContainer = UIUtility.BindUIContainerTemp(self.tempSubMenuControl, LuaComponentTemplates.Skill_SkillPreviewMenuTemplate, self, self.initData)
end

function Skill_SkillPreviewMenuTemplate:HideSubMenu()
  if self.subMenuContainer then
    for i, v in pairs(self.subMenuContainer.items) do
      if v and v.itemTemp then
        v.itemTemp:HideSubMenu()
      end
    end
    self.subMenuContainer:SetData(nil)
  end
  if self.continerTrans and not IsNil(self.continerTrans.gameObject) then
    self.continerTrans:SetActive(false)
  end
  self.isHaveSubMenu = false
end

function Skill_SkillPreviewMenuTemplate:ClearSubMenu()
  if self.subMenuContainer then
    for i, v in pairs(self.subMenuContainer.items) do
      if v and v.itemTemp then
        v.itemTemp:ClearSubMenu()
      end
    end
    self.subMenuContainer:RemoveAll()
  end
  if self.continerTrans and not IsNil(self.continerTrans.gameObject) then
    self.continerTrans:SetActive(false)
  end
  self.subMenuData = nil
  self.isHaveSubMenu = false
end

function Skill_SkillPreviewMenuTemplate:CheckMenuStateByData(data)
  if self.menuData == nil then
    return false
  end
  if self.menuData.pageLevel == 1 then
    return self.menuData.group == data.group
  elseif self.menuData.pageLevel == 2 then
    return self.menuData.preViewid == data.preViewid
  end
  return false
end

return Skill_SkillPreviewMenuTemplate
