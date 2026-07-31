local HolyRingCombineOtherViewTemp = {}

function HolyRingCombineOtherViewTemp:Init()
  self:InitControls()
  self:InitParams()
  self:BindUIEvent()
end

function HolyRingCombineOtherViewTemp:InitControls()
  self.Ring_Item_center = self:GetControl("Ring_center/Ring_Item_center")
  self.centerImg_choose = self:GetControl("Ring_center/Ring_Item_center/img_choose")
  self.RingItem = self:GetControl("RingItem")
  self.btn_combine = self:GetControl("btn_combine")
  self.btn_allCombine = self:GetControl("btn_allCombine")
  self.btn_combineText = self:GetControl("btn_combine/Text")
  self.btn_allCombineText = self:GetControl("btn_allCombine/Text")
  self.lab_des = self:GetControl("lab_des")
end

function HolyRingCombineOtherViewTemp:InitParams()
  self.holyRingHoles = {}
  self.holyRingHolesNum = self.RingItem.transform.childCount
  for i = 1, self.holyRingHolesNum do
    local ctr = UIControl(self.RingItem.transform:GetChild(i - 1))
    ctr.Ring_Item = UIControl(ctr.transform, "Ring_Item")
    ctr.img_choose = UIControl(ctr.transform, "img_choose")
    table.insert(self.holyRingHoles, ctr)
  end
end

function HolyRingCombineOtherViewTemp:BindUIEvent()
  self.btn_combine:SetOnClick(self, self.btn_combineOnClick)
  self.btn_allCombine:SetOnClick(self, self.btn_allCombineOnClick)
end

function HolyRingCombineOtherViewTemp:btn_combineOnClick(control)
  if self.curSelectedHolyRingControl == nil then
    FloatingTipUtility.QuickMsg(ClientTable.cfg_Ui_wordManager:GetCombineHolyRingNoSelectTip())
    return
  end
  if table.isNullOrEmpty(self.holyRingHoles) then
    return
  end
  for i = 1, self.holyRingHolesNum do
    if self.holyRingHoles[i].Ring_Item.itemData == nil then
      FloatingTipUtility.QuickMsg("Gh\195\169p Nguy\195\170n li\225\187\135u kh\195\180ng \196\145\225\187\167")
      return
    end
  end
  local cfgRingCombineId = ClientTable.cfg_Ring_combineManager:GetId(self.data.ItemId)
  local combineCount = 1
  networkRequest.ReqHolyRingCombine(cfgRingCombineId, combineCount)
end

function HolyRingCombineOtherViewTemp:btn_allCombineOnClick(control)
  if self.curSelectedHolyRingControl == nil then
    FloatingTipUtility.QuickMsg(ClientTable.cfg_Ui_wordManager:GetCombineHolyRingNoSelectTip())
    return
  end
  if table.isNullOrEmpty(self.holyRingHoles) then
    return
  end
  for i = 1, self.holyRingHolesNum do
    if self.holyRingHoles[i].Ring_Item.itemData == nil then
      FloatingTipUtility.QuickMsg("Gh\195\169p Nguy\195\170n li\225\187\135u kh\195\180ng \196\145\225\187\167")
      return
    end
  end
  local cfgRingCombineId = ClientTable.cfg_Ring_combineManager:GetId(self.data.ItemId)
  local combineCount = self.curSelectedHolyRingCount // self.holyRingHolesNum
  networkRequest.ReqHolyRingCombine(cfgRingCombineId, combineCount)
end

function HolyRingCombineOtherViewTemp:Refresh(control, ui)
  if control == nil or ui == nil then
    return
  end
  self.data = control.data
  self.parent = ui
  self:RefreshModelView(control)
  self:RefreshUIView()
end

function HolyRingCombineOtherViewTemp:RefreshModelView(control)
  if table.isNullOrEmpty(self.holyRingHoles) then
    return
  end
  if self.curSelectedHolyRingControl == control then
    return
  else
    self:ResetModelData()
    if self.curSelectedHolyRingControl then
      self.curSelectedHolyRingControl.img_select:SetActive(false)
    end
    self.curSelectedHolyRingControl = control
    control.img_select:SetActive(true)
  end
  self.curSelectedHolyRingCount = self.data.Count or 0
  local minNum = Mathf.Min(self.curSelectedHolyRingCount, self.holyRingHolesNum)
  for i = 1, minNum do
    self.holyRingHoles[i].img_choose:SetActive(false)
    ItemUtility.ShowItemCellByItemId(self.data.ItemId, 1, self.holyRingHoles[i].Ring_Item, self.parent, true)
  end
  local rewardBoxId = ClientTable.cfg_Ring_combineManager:GetRewardBoxIdByItemId(self.data.ItemId)
  self.rewardItemId = ClientTable.cfg_Box_boxManager:GetItemIdByRewardBoxId(rewardBoxId)
  ItemUtility.ShowItemCellByItemId(self.rewardItemId, 1, self.Ring_Item_center, self.parent, true)
  self.centerImg_choose:SetActive(true)
end

function HolyRingCombineOtherViewTemp:RefreshUIView()
  self:RefreshCombineButtonColor()
end

function HolyRingCombineOtherViewTemp:ResetModelData()
  if self.Ring_Item_center.itemData then
    self.Ring_Item_center.itemData = nil
  end
  if self.Ring_Item_center.itemCellData then
    self.Ring_Item_center.itemCellData:RecycleRes()
  end
  self.centerImg_choose:SetActive(false)
  if table.isNullOrEmpty(self.holyRingHoles) then
    return
  end
  for i = 1, self.holyRingHolesNum do
    self.holyRingHoles[i].img_choose:SetActive(false)
    if self.holyRingHoles[i].Ring_Item.itemData then
      self.holyRingHoles[i].Ring_Item.itemData = nil
    end
    if self.holyRingHoles[i].Ring_Item.itemCellData then
      self.holyRingHoles[i].Ring_Item.itemCellData:RecycleRes()
    end
  end
end

function HolyRingCombineOtherViewTemp:ResetOtherData()
  if self.curSelectedHolyRingControl then
    self.curSelectedHolyRingControl.img_select:SetActive(false)
    self.curSelectedHolyRingControl = nil
  end
  self.curSelectedHolyRingCount = nil
  self.rewardItemId = nil
end

function HolyRingCombineOtherViewTemp:RefreshSelectedData()
  if self.curSelectedHolyRingControl == nil or self.data == nil or self.parent == nil then
    return
  end
  local HolyRingBagItemData = gameMgr:GetAvatarManager():GetMainPlayer():GetHolyRingDataMgr():GetBagDataByOnlyId(self.data.ItemInfo.id)
  local count = HolyRingBagItemData and HolyRingBagItemData.Count
  if count == nil or count < ClientTable.cfg_Global_globalManager:GetCombineHolyRingBagFilterNum() then
    if self.parent.holyRingCombineBagFirstControl then
      self.curSelectedHolyRingControl = nil
      self:Refresh(self.parent.holyRingCombineBagFirstControl, self.parent)
    else
      self:ResetModelData()
    end
  else
    local control = self.curSelectedHolyRingControl
    self.curSelectedHolyRingControl = nil
    self:Refresh(control, self.parent)
  end
end

function HolyRingCombineOtherViewTemp:RefreshCombineButtonColor()
  self:SetCombineButtonGrey(self.curSelectedHolyRingControl == nil)
end

function HolyRingCombineOtherViewTemp:SetCombineButtonActive(bool)
  self.btn_combine:SetActive(bool)
  self.btn_allCombine:SetActive(bool)
end

function HolyRingCombineOtherViewTemp:SetCombineButtonGrey(bool)
  self.btn_combine:SetAlpha(bool and 0.5 or 1)
  self.btn_allCombine:SetAlpha(bool and 0.5 or 1)
  self.btn_combineText:SetAlpha(bool and 0.5 or 1)
  self.btn_allCombineText:SetAlpha(bool and 0.5 or 1)
end

function HolyRingCombineOtherViewTemp:OnHide()
  self:SetCombineButtonGrey(true)
  self:ResetModelData()
  self:ResetOtherData()
end

return HolyRingCombineOtherViewTemp
