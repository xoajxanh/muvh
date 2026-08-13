local PandoraActivityRewardShowTemplate = {}

function PandoraActivityRewardShowTemplate:Init(root)
  self.root = root
  self:InitControls()
  self:InitContainer()
  self:InitUIEvents()
end

function PandoraActivityRewardShowTemplate:InitControls()
  self.role_model = self:GetControl("setPresentation/model")
  self.btn_rewardx = self:GetControl("sw_Gift/Viewport/Content/btn_rewardx")
  self.lab_des = self:GetControl("lab_des")
end

local function RewardOnCreate(ctr)
  ctr.go_model = UIControl(ctr.transform, "go_model")
  ctr.go_modelData = ItemCellData()
end

local function RewardOnRefresh(ctr, _, data, ui)
  if data == nil then
    return
  end
  local itemData = ItemUtility.GenerateItemData(data)
  itemData.count = 1
  ctr.go_modelData:RefreshData(itemData)
  ItemUtility.ShowItemCell(ctr, ctr.go_modelData, ui, true)
end

function PandoraActivityRewardShowTemplate:InitContainer()
  self.rewardContainer = UIContainer(self.btn_rewardx, self.root, RewardOnCreate, RewardOnRefresh)
end

function PandoraActivityRewardShowTemplate:InitUIEvents()
  self.role_model:SetOnDrag(self, self.DragViewRole)
end

function PandoraActivityRewardShowTemplate:DragViewRole(control, eventData)
  if self.lookRole then
    local rotY = self.lookRole.dir
    rotY = rotY - eventData.delta.x
    self.lookRole:SetRotation(0, rotY, 0)
  end
end

function PandoraActivityRewardShowTemplate:Refresh(_data, _ui)
  if _data == nil or _ui == nil then
    return
  end
  self.rewardData = _data
  self.rewardContainer:SetData(_data)
  self:ShowPlayerModel()
end

function PandoraActivityRewardShowTemplate:ShowPlayerModel()
  local viewRoleData = PandoraActivityData.GetPandoraActivityRoleModelShowInfo(self.rewardData, self.role_model.transform)
  if self.lookRole then
    self.lookRole:Destroy()
    self.lookRole = ViewRole(viewRoleData)
  else
    self.lookRole = ViewRole(viewRoleData)
  end
  self.lookRole:SetPosition(-10, -160, -150)
  self.lookRole:SetRotation(0, 180, 0)
end

function PandoraActivityRewardShowTemplate:CloseUI()
  if self.lookRole then
    self.lookRole:DestroyModel()
    self.lookRole:DestroyEquip()
    self.lookRole:Destroy()
    self.lookRole = nil
  end
end

return PandoraActivityRewardShowTemplate
