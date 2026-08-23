Equip_HolySkeletonInlayUI = class(BaseUI)
Equip_HolySkeletonInlayUI.layer = UILayer.Panel
Equip_HolySkeletonInlayUI.orderInLayer = 0
Equip_HolySkeletonInlayUI.hideType = UIHideType.WaitDestroy
Equip_HolySkeletonInlayUI.hideFunc = UIHideFunc.MoveOutOfScreen
Equip_HolySkeletonInlayUI.escClose = UIEscClose.DontClose

function Equip_HolySkeletonInlayUI:InitControls()
  self.img_Bg2 = self:GetControl("img_Bg2")
  self.bg_equip = self:GetControl("bg_equip")
  self.SkeletonShowModel = self:GetControl("bg_equip/SkeletonShowModel")
  self.ItemModel_1 = self:GetControl("bg_equip/SkeletonShowModel/ItemModel_1")
  self.ItemModel_2 = self:GetControl("bg_equip/SkeletonShowModel/ItemModel_2")
  self.ItemModel_3 = self:GetControl("bg_equip/SkeletonShowModel/ItemModel_3")
  self.ItemModel_4 = self:GetControl("bg_equip/SkeletonShowModel/ItemModel_4")
  self.ItemModel_5 = self:GetControl("bg_equip/SkeletonShowModel/ItemModel_5")
  self.ItemModel_6 = self:GetControl("bg_equip/SkeletonShowModel/ItemModel_6")
  self.ItemModel_7 = self:GetControl("bg_equip/SkeletonShowModel/ItemModel_7")
  self.frame_equip = self:GetControl("bg_equip/frame_equip")
  self.SkeletonInlayAttribute = self:GetControl("bg_equip/SkeletonInlayAttribute")
  self.sw_attributegrow = self:GetControl("bg_equip/SkeletonInlayAttribute/sw_attributegrow")
  self.frame_item = self:GetControl("bg_equip/SkeletonInlayAttribute/sw_attributegrow/Viewport/materialParent/frame_item_LordSoul")
  self.frame_item_ViceSoul_1 = self:GetControl("bg_equip/SkeletonInlayAttribute/sw_attributegrow/Viewport/materialParent/frame_item_ViceSoul_1")
  self.frame_item_ViceSoul_2 = self:GetControl("bg_equip/SkeletonInlayAttribute/sw_attributegrow/Viewport/materialParent/frame_item_ViceSoul_2")
  self.frame_item_ViceSoul_3 = self:GetControl("bg_equip/SkeletonInlayAttribute/sw_attributegrow/Viewport/materialParent/frame_item_ViceSoul_3")
  self.frame_item_ViceSoul_4 = self:GetControl("bg_equip/SkeletonInlayAttribute/sw_attributegrow/Viewport/materialParent/frame_item_ViceSoul_4")
  self.frame_item_ViceSoul_5 = self:GetControl("bg_equip/SkeletonInlayAttribute/sw_attributegrow/Viewport/materialParent/frame_item_ViceSoul_5")
  self.frame_item_ViceSoul_6 = self:GetControl("bg_equip/SkeletonInlayAttribute/sw_attributegrow/Viewport/materialParent/frame_item_ViceSoul_6")
  self.btn_Inlay = self:GetControl("bg_equip/btn_Inlay")
  self.text_Inlay = self:GetControl("bg_equip/btn_Inlay/text_Inlay")
  self.btn_HolySkeletonMaster = self:GetControl("bg_equip/btn_HolySkeletonMaster")
  self.descBtn = self:GetControl("descBtn")
  self.btn_close = self:GetControl("btn_close")
end

function Equip_HolySkeletonInlayUI:Init()
end

local SkeletonInShowModel = {}
local FrameItemSoul = {}

function Equip_HolySkeletonInlayUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Equip_HolySkeletonInlayUI:InitUI()
  SkeletonInShowModel = {
    [1] = self.ItemModel_1,
    [2] = self.ItemModel_2,
    [3] = self.ItemModel_3,
    [4] = self.ItemModel_4,
    [5] = self.ItemModel_5,
    [6] = self.ItemModel_6,
    [7] = self.ItemModel_7
  }
  FrameItemSoul = {
    [1] = self.frame_item,
    [2] = self.frame_item_ViceSoul_1,
    [3] = self.frame_item_ViceSoul_2,
    [4] = self.frame_item_ViceSoul_3,
    [5] = self.frame_item_ViceSoul_4,
    [6] = self.frame_item_ViceSoul_5,
    [7] = self.frame_item_ViceSoul_6
  }
  self.itemCellDataTop = {}
  self.itemCellData = {}
  self.ItemInfoId = nil
end

function Equip_HolySkeletonInlayUI:RegistUIEvents()
  self.frame_equip:SetOnClick(self, self.frame_equipOnClick)
  self.btn_Inlay:SetOnClick(self, self.btn_InlayOnClick)
  self.btn_HolySkeletonMaster:SetOnClick(self, self.btn_HolySkeletonMasterOnClick)
  self.descBtn:SetOnClick(self, self.descBtnOnClick)
  self.btn_close:SetOnClick(self, self.btn_closeOnClick)
end

function Equip_HolySkeletonInlayUI:frameChooseOnClick(control)
  local SacredBoneEquipSelectIndex = gameMgr:GetAvatarManager():GetMainPlayer():GetSacredBoneDataMgr().SacredBoneEquipSelectIndex
  local SacredBoneEquipData = gameMgr:GetAvatarManager():GetMainPlayer():GetSacredBoneDataMgr().SacredBoneEquipData
  if SacredBoneEquipData[SacredBoneEquipSelectIndex].SacredBoneData[control.param[1]].SacredBoneLockType == true then
    return
  end
  control.param[2]:SetActive(true)
  gameMgr:GetAvatarManager():GetMainPlayer():GetSacredBoneDataMgr().SacredBoneSelectIndex = control.param[1]
  UIManager.Show(UIID.Equip_HolySkeletonBagUI)
end

function Equip_HolySkeletonInlayUI:frameItemOnClick(control)
  local SacredBoneEquipSelectIndex = gameMgr:GetAvatarManager():GetMainPlayer():GetSacredBoneDataMgr().SacredBoneEquipSelectIndex
  if not SacredBoneEquipSelectIndex then
    return
  end
  gameMgr:GetAvatarManager():GetMainPlayer():GetSacredBoneDataMgr().SacredBoneSelectIndex = control.param
  networkRequest.ReqHolyBoneInlay(SacredBoneEquipSelectIndex, control.param, 0)
end

function Equip_HolySkeletonInlayUI:frame_equipOnClick(control)
end

function Equip_HolySkeletonInlayUI:btn_InlayOnClick(control)
end

function Equip_HolySkeletonInlayUI:btn_HolySkeletonMasterOnClick(control)
  UIManager.Show(UIID.Tip_CommonTipsUI, {
    showType = CommonTipsEnum.HolySkeleton
  })
  UIManager.Show(UIID.Skill_SkillPreviewUI, {
    openFirstTab = ESkillPreviewUIType.HolySkeleton
  })
end

function Equip_HolySkeletonInlayUI:descBtnOnClick(control)
  self.lvCfg = ConfigManager.FindConfigs("cfg_Ui_description", "uiName", "Equip_HolySkeletonInlayUI")
  UIManager.Show(UIID.System_DescUI, {
    id = self.lvCfg[1].id
  })
end

function Equip_HolySkeletonInlayUI:btn_closeOnClick(control)
  self:OnHide()
end

function Equip_HolySkeletonInlayUI:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function Equip_HolySkeletonInlayUI:RegistEvents()
  self:RegistEvent(Event.SacredBoneBagChange, self.RefreshSacredBoneBagChange, self)
  self:RegistEvent(Event.SacredBoneEquipChange, self.RefreshSacredBoneEquipChange, self)
  self:RegistEvent(Event.SelectedHolySkeletonEquip, self.SelectedHolySkeletonEquip, self)
  self:RegistEvent(Event.HolySkeletonBagChange, self.HolySkeletonBagChange, self)
end

function Equip_HolySkeletonInlayUI:HolySkeletonBagChange()
  for i, v in ipairs(FrameItemSoul) do
    v:GetChild("img_choose"):SetActive(false)
  end
end

function Equip_HolySkeletonInlayUI:RefreshSacredBoneBagChange()
  if UIManager.IsVisible(UIID.Equip_HolySkeletonBagUI) then
    UIManager.Hide(UIID.Equip_HolySkeletonBagUI)
    UIManager.Show(UIID.Equip_HolySkeletonBagUI)
  end
end

function Equip_HolySkeletonInlayUI:RefreshSacredBoneEquipChange()
  self:RefreshHolePosition()
end

function Equip_HolySkeletonInlayUI:SelectedHolySkeletonEquip(_, data)
  gameMgr:GetAvatarManager():GetMainPlayer():GetSacredBoneDataMgr().SacredBoneEquipSelectIndex = data.modelIndex
  self:RefreshHolePosition()
end

function Equip_HolySkeletonInlayUI:Refresh()
end

function Equip_HolySkeletonInlayUI:RefreshHolePosition()
  EventManager.Dispatch(Event.HolySkeletonEquipSetChange)
  local SacredBoneEquipSelectIndex = gameMgr:GetAvatarManager():GetMainPlayer():GetSacredBoneDataMgr().SacredBoneEquipSelectIndex
  if not SacredBoneEquipSelectIndex then
    return
  end
  local SacredBoneEquipData = gameMgr:GetAvatarManager():GetMainPlayer():GetSacredBoneDataMgr().SacredBoneEquipData
  local data = SacredBoneEquipData[SacredBoneEquipSelectIndex].SacredBoneData
  local SacredEquipData = gameMgr:GetAvatarManager():GetMainPlayer():GetSacredBoneDataMgr():SacredBoneDataInfo(data)
  self:RefreshSacredBone(data, SacredEquipData)
  self:RefreshFrameItemTopEquip(data)
  EventManager.Dispatch(Event.CallRefreshRedPoint, {
    type = ERedPointType.sacredBone_Equip
  })
  EventManager.Dispatch(Event.CallRefreshRedPoint, {
    id = ERedPointId.sacred_Bone_Inlay
  })
end

function Equip_HolySkeletonInlayUI:RefreshFrameItemTopEquip(data)
  if self.itemCellDataTop then
    for i, v in pairs(self.itemCellDataTop) do
      v:RecycleRes()
    end
  end
  local value = ClientTable.cfg_Global_globalManager:TryGetValue(2800022).effect
  local SkeletonIn = string.split(value, "&")
  local SkeletonInValue
  for i, v in ipairs(SkeletonIn) do
    SkeletonInValue = string.split(v, "#")
    SkeletonInShowModel[tonumber(SkeletonInValue[1])]:GetChild("lab_condition"):SetText(SkeletonInValue[2])
  end
  for i, v in pairs(SkeletonInShowModel) do
    if i ~= 1 then
      v:GetChild("img_lock"):SetActive(true)
      v:GetChild("lab_condition"):SetActive(true)
      if data[i].SacredBoneLockType == false then
        v:GetChild("img_lock"):SetActive(false)
        v:GetChild("lab_condition"):SetActive(false)
      end
    end
    if data[i].SacredBoneSetType then
      local items = ItemUtility.GenerateItemDataByServerData(data[i].SacredBoneEquip.ItemInfo)
      if not self.itemCellDataTop[i] then
        self.itemCellDataTop[i] = ItemCellData()
      end
      self.itemCellDataTop[i]:RefreshData(items)
      ItemUtility.ShowItemCell(v, self.itemCellDataTop[i], nil, true)
    end
  end
end

function Equip_HolySkeletonInlayUI:RefreshSacredBone(data, SacredEquipData)
  if self.itemCellData then
    for i, v in pairs(self.itemCellData) do
      v:RecycleRes()
    end
  end
  for i, v in ipairs(FrameItemSoul) do
    local Btn_del = v:GetChild("btn_del")
    local img_choose = v:GetChild("img_choose")
    local lab_name = v:GetChild("lab_name")
    local btn_item = v:GetChild("btn_item")
    local img_lock = v:GetChild("btn_item/img_lock")
    local btn_add = v:GetChild("btn_item/btn_add")
    local img_redPoint = v:GetChild("btn_item/img_redPoint")
    lab_name:SetText()
    img_choose:SetActive(false)
    btn_add:SetActive(true)
    Btn_del:SetActive(false)
    local redBool = gameMgr:GetAvatarManager():GetMainPlayer():GetSacredBoneDataMgr():SetSacredBoneRedPoint(i)
    img_redPoint:SetActive(redBool)
    if UIManager.IsVisible(UIID.Equip_HolySkeletonBagUI) and gameMgr:GetAvatarManager():GetMainPlayer():GetSacredBoneDataMgr().SacredBoneSelectIndex == i then
      img_choose:SetActive(true)
    end
    if i == 1 then
      v:SetOnClickParam(self, self.frameChooseOnClick, {i, img_choose})
      btn_add:SetOnClickParam(self, self.frameChooseOnClick, {i, img_choose})
      img_lock:SetActive(false)
    else
      img_lock:SetActive(true)
      if data[i].SacredBoneLockType == false then
        btn_add:SetOnClickParam(self, self.frameChooseOnClick, {i, img_choose})
        img_lock:SetActive(false)
      end
      v:SetOnClickParam(self, self.frameChooseOnClick, {i, img_choose})
    end
    if data[i].SacredBoneSetType then
      Btn_del:SetActive(true)
      if not data[i].SacredBoneEquip then
        return
      end
      if SacredEquipData then
        lab_name:SetText(string.GetColorText(ClientTable.cfg_Bone_attributeManager:GetAttrDesBySacredBoneInfoData(SacredEquipData[i]), "#51C4FF"))
      else
        lab_name:SetText("")
      end
      if data[i].SacredBoneEquip.ItemInfo then
        btn_add:SetActive(false)
        local items = ItemUtility.GenerateItemDataByServerData(data[i].SacredBoneEquip.ItemInfo)
        if not self.itemCellData[i] then
          self.itemCellData[i] = ItemCellData()
        end
        self.itemCellData[i]:RefreshData(items)
        ItemUtility.ShowItemCell(btn_item, self.itemCellData[i], nil, true)
      end
    else
      btn_item:SetOnClick(btn_item, function()
      end)
    end
    Btn_del:SetOnClickParam(self, self.frameItemOnClick, i)
  end
end

function Equip_HolySkeletonInlayUI:OnHide()
  if UIManager.IsVisible(UIID.Equip_HolySkeletonBagUI) then
    UIManager.Hide(UIID.Equip_HolySkeletonBagUI)
  end
  UIManager.Hide(UIID.Equip_HolySkeletonInlayUI)
end

function Equip_HolySkeletonInlayUI:OnDestroy()
end
