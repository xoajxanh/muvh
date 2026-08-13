Equip_HolySkeletonBagUI = class(BaseUI)
Equip_HolySkeletonBagUI.layer = UILayer.Panel
Equip_HolySkeletonBagUI.orderInLayer = 10
Equip_HolySkeletonBagUI.hideType = UIHideType.WaitDestroy
Equip_HolySkeletonBagUI.hideFunc = UIHideFunc.MoveOutOfScreen
Equip_HolySkeletonBagUI.escClose = UIEscClose.DontClose

function Equip_HolySkeletonBagUI:InitControls()
  self.Panel_Desc = self:GetControl("Root/Panel_Desc")
  self.CloseBtn = self:GetControl("Root/CloseBtn")
  self.lab_DescTitle = self:GetControl("Root/lab_DescTitle")
  self.Scroll_Name = self:GetControl("Root/Scroll_Name")
  self.nameItem = self:GetControl("Root/Scroll_Name/Viewport/Content/nameItem")
  self.btn_item = self:GetControl("Root/Scroll_Name/Viewport/Content/nameItem/btn_item")
  self.btn_Inlay = self:GetControl("Root/btn_Inlay")
  self.text_Inlay = self:GetControl("Root/btn_Inlay/text_Inlay")
end

function Equip_HolySkeletonBagUI:Init()
end

function Equip_HolySkeletonBagUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Equip_HolySkeletonBagUI:InitUI()
  self.ReqHolyBoneInlayId = nil
  self.holySkeletonBagUITemplates = UIUtility.BindUIContainerTemp(self.nameItem, LuaComponentTemplates.HolySkeletonBagUITemplates, self)
end

function Equip_HolySkeletonBagUI:RegistUIEvents()
  self.Panel_Desc:SetOnClick(self, self.Panel_DescOnClick)
  self.CloseBtn:SetOnClick(self, self.CloseBtnOnClick)
  self.nameItem:SetOnClick(self, self.nameItemOnClick)
  self.btn_item:SetOnClick(self, self.btn_itemOnClick)
  self.btn_Inlay:SetOnClick(self, self.btn_InlayOnClick)
end

function Equip_HolySkeletonBagUI:Panel_DescOnClick(control)
  self:OnHide()
end

function Equip_HolySkeletonBagUI:CloseBtnOnClick(control)
  self:OnHide()
end

function Equip_HolySkeletonBagUI:nameItemOnClick(control)
end

function Equip_HolySkeletonBagUI:btn_itemOnClick(control)
end

function Equip_HolySkeletonBagUI:btn_InlayOnClick(control)
  self:SetOnClickEquip()
end

function Equip_HolySkeletonBagUI:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function Equip_HolySkeletonBagUI:RegistEvents()
end

function Equip_HolySkeletonBagUI:Refresh()
  self:RefreshHolySkeletonBag()
end

function Equip_HolySkeletonBagUI:RefreshHolySkeletonBag()
  local index = gameMgr:GetAvatarManager():GetMainPlayer():GetSacredBoneDataMgr().SacredBoneEquipSelectIndex
  if not index then
    return
  end
  local SacredBoneEquipData = gameMgr:GetAvatarManager():GetMainPlayer():GetSacredBoneDataMgr().SacredBoneEquipData
  local SacredBoneSelectIndex = gameMgr:GetAvatarManager():GetMainPlayer():GetSacredBoneDataMgr().SacredBoneSelectIndex
  if SacredBoneEquipData[index].SacredBoneData[SacredBoneSelectIndex].SacredBoneSetType then
    self.text_Inlay:SetText("Thay th\225\186\191")
  else
    self.text_Inlay:SetText("Kh\225\186\163m")
  end
  local SacredBoneBagItemData = gameMgr:GetAvatarManager():GetMainPlayer():GetSacredBoneDataMgr():GetBagEquipDataByOnlyId(index, SacredBoneSelectIndex)
  if not SacredBoneBagItemData then
    self.ReqHolyBoneInlayId = nil
  end
  for i, v in ipairs(SacredBoneBagItemData) do
    function v.OnClick()
      self:OnClick(v)
    end
  end
  self.holySkeletonBagUITemplates:SetData(SacredBoneBagItemData)
  for i, v in pairs(self.holySkeletonBagUITemplates.items) do
    if v.itemTemp and v.itemTemp.data and v.itemTemp.data.ItemInfo and v.itemTemp.data.ItemInfo.id then
      if self.ReqHolyBoneInlayId then
        v.itemTemp:SetChooseChange(v.itemTemp.data.ItemInfo.id == self.ReqHolyBoneInlayId)
      elseif i == 1 then
        v.itemTemp:SetChooseChange(true)
        self.ReqHolyBoneInlayId = v.itemTemp.data.ItemInfo.id
      end
    end
  end
end

function Equip_HolySkeletonBagUI:OnClick(data)
  for i, v in pairs(self.holySkeletonBagUITemplates.items) do
    if v.itemTemp and v.itemTemp.data and v.itemTemp.data.ItemInfo and v.itemTemp.data.ItemInfo.id then
      v.itemTemp:SetChooseChange(v.itemTemp.data.ItemInfo.id == data.ItemInfo.id)
      if v.itemTemp.data.ItemInfo.id == data.ItemInfo.id then
        self.ReqHolyBoneInlayId = data.ItemInfo.id
      end
    end
  end
end

function Equip_HolySkeletonBagUI:SetOnClickEquip()
  if not self.ReqHolyBoneInlayId then
    FloatingTipUtility.QuickMsg("Ch\198\176a ch\225\187\141n Linh H\225\187\147n")
    return
  end
  local SacredBoneEquipSelectIndex = gameMgr:GetAvatarManager():GetMainPlayer():GetSacredBoneDataMgr().SacredBoneEquipSelectIndex
  if not SacredBoneEquipSelectIndex then
    return
  end
  local SacredBoneSelectIndex = gameMgr:GetAvatarManager():GetMainPlayer():GetSacredBoneDataMgr().SacredBoneSelectIndex
  if not SacredBoneSelectIndex then
    return
  end
  networkRequest.ReqHolyBoneInlay(SacredBoneEquipSelectIndex, SacredBoneSelectIndex, self.ReqHolyBoneInlayId)
  self:OnHide()
end

function Equip_HolySkeletonBagUI:OnHide()
  self.ReqHolyBoneInlayId = nil
  EventManager.Dispatch(Event.SacredBoneEquipChange)
  EventManager.Dispatch(Event.HolySkeletonBagChange)
  UIManager.Hide(UIID.Equip_HolySkeletonBagUI)
end

function Equip_HolySkeletonBagUI:OnDestroy()
end
