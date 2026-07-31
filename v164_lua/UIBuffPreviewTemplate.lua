local UIBuffPreviewTemplate = {}

function UIBuffPreviewTemplate:Init(data)
  self:InitParams(data)
  self:InitControls()
  self:BindUIEvent()
end

function UIBuffPreviewTemplate:InitParams(data)
  self.parentTbl = nil
  self.viewRole = nil
  self.viewRoleData = nil
  self.buffLidList = nil
end

function UIBuffPreviewTemplate:InitViewRoleData()
  self.viewRoleData = {}
  self.viewRoleData.career = ViewData.meData.career
  self.viewRoleData.modelType = EModelType.Charactor
  self.viewRoleData.roleName = ViewData.meData.name
  self.viewRoleData.serverCoord = Vector2Int()
  self.viewRoleData.roleType = ERoleType.Player
  self.viewRoleData.parent = self.go_model.transform
  self.viewRoleData.animationName = "idle"
end

function UIBuffPreviewTemplate:InitControls()
  self.showInfo = self:GetControl("ShowInfo")
  self.go_model = self:GetControl("ShowInfo/My/go_model")
  self.img_StayTuned = self:GetControl("img_StayTuned")
end

function UIBuffPreviewTemplate:BindUIEvent()
end

function UIBuffPreviewTemplate:RefreshData(data)
  self.buffId = data.buffId
  if self.viewRole == nil and self:IsShowBuff() then
    self:InitRole()
  end
end

function UIBuffPreviewTemplate:Refresh(data, ui)
  self.parentTbl = ui
  self:RefreshData(data)
  self:TryShowBuffView()
end

function UIBuffPreviewTemplate:InitRole()
  self:InitViewRoleData()
  self:InitRoleOtherData()
  self:InitRoleView()
end

function UIBuffPreviewTemplate:InitRoleOtherData()
  local equip = table.DeepCopy(ViewData.meData.equipsData.Data)
  self.viewRoleData.equipsData = RoleEquipData(equip)
  self.viewRoleData.model = RoleEquipUtility.GetCurPlayerModelName(ForgeData.appearData[ViewData.meData.id], self.viewRoleData.equipsData.Data)
  self.viewRoleData.id = tonumber(self.viewRoleData.model)
  ForgeData.appearData[self.viewRoleData.id] = ForgeData.appearData[ViewData.meData.id]
end

function UIBuffPreviewTemplate:InitRoleView()
  self.showInfo:SetActive(true)
  if self.viewRole then
    self.viewRole:RefreshModel(self.viewRoleData)
  else
    self.viewRole = ViewRole(self.viewRoleData)
    self.viewRole:SetPosition(0, 0, 0)
    self.viewRole.transform.localEulerAngles = Vector3(0, 0, 0)
  end
end

function UIBuffPreviewTemplate:DestroyRoleModel()
  if self.viewRole then
    self.viewRole:Destroy()
    self.viewRole = nil
  end
end

function UIBuffPreviewTemplate:TryShowBuffView()
  self.img_StayTuned:SetActive(not self:IsShowBuff())
  self.showInfo:SetActive(self:IsShowBuff())
  self:DestroyBuffEffect()
  self:ShowBuffEffect()
end

function UIBuffPreviewTemplate:ShowBuffEffect()
  if self.viewRole == nil or not self:IsShowBuff() then
    return
  end
  self.buffLidList = gameMgr:GetEffectManager():GetBuffEffectProcessor():AddBuffs({
    self.buffId
  }, self.viewRole.model.BuffAnchor)
  self.viewRole:SetBuffAnchorDepth(-2)
end

function UIBuffPreviewTemplate:DestroyBuffEffect()
  if self.buffLidList then
    gameMgr:GetEffectManager():GetBuffEffectProcessor():RemoveEffects(self.buffLidList)
    self.buffLidList = nil
  end
end

function UIBuffPreviewTemplate:IsShowBuff()
  return self.buffId ~= 0 and self.buffId ~= nil
end

function UIBuffPreviewTemplate:ChangeViewState(state)
  if self:UIControl() and not IsNil(self:UIControl().gameObject) then
    self:UIControl():SetActive(state)
  end
  if not state then
    self.isInitialized = false
  end
end

function UIBuffPreviewTemplate:OnDisable()
  self:DestroyRoleModel()
  self:DestroyBuffEffect()
  self.isInitialized = false
end

function UIBuffPreviewTemplate:OnDestroy()
  self:DestroyRoleModel()
  self:DestroyBuffEffect()
  self.isInitialized = false
end

return UIBuffPreviewTemplate
