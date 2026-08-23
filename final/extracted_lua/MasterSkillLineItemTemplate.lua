local MasterSkillLineItemTemplate = {}

function MasterSkillLineItemTemplate:Init()
  self:InitControls()
  self:BindUIEvent()
  self:InitParams()
end

function MasterSkillLineItemTemplate:InitParams()
  self.parentTbl = nil
  self.isLight = nil
  local width, height = self.bg:GetSizeDelta()
  self.bgHeight = height or 0
  width, height = self.check:GetSizeDelta()
  self.checkHeight = height or 0
end

function MasterSkillLineItemTemplate:InitControls()
  self.line = self:UIControl()
  self.bg = self:GetControl("Line/background")
  self.check = self:GetControl("Line/check")
end

function MasterSkillLineItemTemplate:BindUIEvent()
end

function MasterSkillLineItemTemplate:Refresh(data, ui)
  self.parentTbl = ui
  self.data = data
  self:RefreshData()
  self:RefreshView()
end

function MasterSkillLineItemTemplate:RefreshData()
  local curData = QuickFind.MasterDataMgr():GetSkillDataBySkillGroup(self.data.skillGroup)
  self.isRefreshView = not self.skillData or curData.skillGroup ~= self.skillData.skillGroup
  self.skillData = curData
end

function MasterSkillLineItemTemplate:RefreshView()
  if self.line == nil and self.data == nil or not self.isRefreshView then
    return
  end
  local vector, angle, width = self:CalculateTransData(self.data.startPoint, self.data.endPoint)
  self.line.transform.localPosition = vector
  self.line:SetRotation(0, 0, angle)
  self.bg:SetSizeDelta(width, self.bgHeight)
  self.check:SetSizeDelta(width, self.checkHeight)
  self:RefreshState()
end

function MasterSkillLineItemTemplate:RefreshState()
  local isLight = self:IsLight(self.skillData)
  if isLight ~= self.isLight then
    self.isLight = isLight
    self.check:SetActive(isLight)
  end
end

function MasterSkillLineItemTemplate:TryChangeState()
  self:RefreshData()
  self:RefreshState()
end

function MasterSkillLineItemTemplate:CalculateTransData(startPoint, endPoint)
  local distance = Vector3.Distance(startPoint, endPoint)
  local dirNormalize = (startPoint - endPoint).normalized
  local angle = Mathf.Atan2(dirNormalize.y, dirNormalize.x) * Mathf.Rad2Deg + 180
  return startPoint, angle, distance
end

function MasterSkillLineItemTemplate:IsLight(data)
  if data == nil then
    return false
  end
  if not QuickFind.MasterDataMgr():GetCurEnableSubTypeIsMatchSelf(data.subType) then
    return false
  end
  if data.level > 0 then
    return true
  end
  return QuickFind.MasterDataMgr():GetUpcodeByGroupId(data.skillGroup) == MasterSkillUpcode.CanUpgrade
end

return MasterSkillLineItemTemplate
