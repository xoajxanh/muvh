local ClimbTowerViewTemplate = {}

function ClimbTowerViewTemplate:Init(data)
  self:InitControls()
  self:InitData(data)
end

function ClimbTowerViewTemplate:InitControls()
  self.nowCtr = self:GetControl()
  self.scroll_logs = self:GetControl("ScrollView")
  self.go_systemChar = self:GetControl("tog_instance")
  self.img_SystemCharBubble = self:GetControl("go_systemChar/img_SystemCharBubble")
  self.lab_Event = self:GetControl("go_systemChar/img_SystemCharBubble/lab_Event")
  self.go_Tower_First = self:GetControl("Tower_First")
  self.go_Tower_Special = self:GetControl("Tower_Special")
  self.go_Tower_Normal = self:GetControl("Tower_Normal")
  self.go_Tower_top = self:GetControl("Tower_top")
end

function ClimbTowerViewTemplate:InitData(data)
  self.data = {}
  if data then
    self.clickCallBack = data.clickCallBack
    self.baseUI = data.baseUI
  end
  _, self.go_Tower_FirstHeight = self.go_Tower_First:GetSizeDelta()
  _, self.go_Tower_SpecialHeight = self.go_Tower_Special:GetSizeDelta()
  _, self.go_Tower_NormalHeight = self.go_Tower_Normal:GetSizeDelta()
  _, self.go_Tower_topHeight = self.go_Tower_top:GetSizeDelta()
end

function ClimbTowerViewTemplate:InitContainer()
end

function ClimbTowerViewTemplate:ResetData(data)
end

function ClimbTowerViewTemplate:Refresh(data, curIndex)
  self.data = data
  self:RefreshBossTableView(curIndex)
end

function ClimbTowerViewTemplate:RefreshBossTableView(curIndex)
  if table.isNullOrEmpty(self.data) then
    return
  end
  if self.logsView == nil then
    self.logsView = UITableView()
    self.logsView:SetLowerMargin(0)
    self.logsView:SetScrollView(self.scroll_logs)
    self.logsView:SetScalarForCellInTableView(self, self.ScalarForCellInTableView)
    self.logsView:SetTotalCellCount(self, self.GetLogCount)
    self.logsView:SetCellAtIndexInTableView(self, self.GetLogCell)
    self.logsView:SetCellAtIndexInTableViewWillAppear(self, self.UpdateWildCellCallBack)
  end
  curIndex = curIndex or table.count(self.data)
  self.logsView:ReloadData(curIndex)
end

function ClimbTowerViewTemplate:GetLogCount()
  return table.count(self.data)
end

function ClimbTowerViewTemplate:GetLogCell()
  return self.logsView:ReuseOrCreateCell(self.go_systemChar)
end

function ClimbTowerViewTemplate:ScalarForCellInTableView(index)
  local data = self.data[index]
  local resHeight = self:GetTowerHeight(data, index)
  return resHeight
end

function ClimbTowerViewTemplate:GetTowerHeight(singleData, index)
  if singleData.head then
    return self.go_Tower_topHeight
  elseif index == table.count(self.data) then
    return self.go_Tower_FirstHeight
  elseif singleData.flag and singleData.flag == 1 then
    return self.go_Tower_SpecialHeight
  else
    return self.go_Tower_NormalHeight
  end
  return self.go_Tower_NormalHeight
end

function ClimbTowerViewTemplate:UpdateWildCellCallBack(index)
  if type(self.data) ~= "table" or next(self.data) == nil then
    return
  end
  if self.data[index] ~= nil then
    local cell = self.logsView:GetLoadedCell(index)
    self:RefreshLogView(self.data[index], cell, index)
  end
end

function ClimbTowerViewTemplate:RefreshLogView(singleData, obj, index)
  if singleData == nil then
    return
  end
  local h = self:GetTowerHeight(singleData, index)
  local w = obj:GetSizeDelta()
  obj:SetSizeDelta(w, h)
  if obj.pageTempaltes == nil then
    obj.pageTempaltes = luaTemplateManager.GetNewTemplate(obj, LuaComponentTemplates.Instance_ClimbTowerTower_SpecialTemplate, {
      clickCallBack = self.clickCallBack,
      baseUI = self.baseUI,
      nowCtr = obj
    })
  end
  obj.pageIndex = index
  obj.data = singleData
  if obj.pageTempaltes then
    obj.pageTempaltes:onShowPanel(obj.data, self.baseUI.ClickIndex, self.baseUI)
  end
end

function ClimbTowerViewTemplate:Hide()
  if self.logsView then
    self.logsView:UnloadAllCells()
  end
end

function ClimbTowerViewTemplate:GetTempObjByIndex(index)
  if self.data and self.data[index] ~= nil then
    local cell = self.logsView:GetLoadedCell(index)
    return cell
  end
end

return ClimbTowerViewTemplate
