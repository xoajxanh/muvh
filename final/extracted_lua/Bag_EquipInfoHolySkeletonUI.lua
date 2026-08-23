Bag_EquipInfoHolySkeletonUI = class(BaseUI)
Bag_EquipInfoHolySkeletonUI.layer = UILayer.Panel
Bag_EquipInfoHolySkeletonUI.orderInLayer = 0
Bag_EquipInfoHolySkeletonUI.hideType = UIHideType.WaitDestroy
Bag_EquipInfoHolySkeletonUI.hideFunc = UIHideFunc.MoveOutOfScreen
Bag_EquipInfoHolySkeletonUI.escClose = UIEscClose.DontClose

function Bag_EquipInfoHolySkeletonUI:InitControls()
  self.btn_closeBg = self:GetControl("btn_closeBg")
  self.Windows = self:GetControl("Windows")
  self.View_EquipFrame = self:GetControl("Windows/View_EquipFrame")
  self.img_select = self:GetControl("Windows/View_EquipFrame/img_select")
  self.armor_frame = self:GetControl("Windows/View_EquipFrame/armor_frame")
  self.boot_frame = self:GetControl("Windows/View_EquipFrame/boot_frame")
  self.glove_frame = self:GetControl("Windows/View_EquipFrame/glove_frame")
  self.helm_frame = self:GetControl("Windows/View_EquipFrame/helm_frame")
  self.pant_frame = self:GetControl("Windows/View_EquipFrame/pant_frame")
  self.weapon_frame_left = self:GetControl("Windows/View_EquipFrame/weapon_frame_left")
  self.weapon_frame_right = self:GetControl("Windows/View_EquipFrame/weapon_frame_right")
  self.select_effect = self:GetControl("Windows/View_EquipFrame/select_effect")
  self.img_title = self:GetControl("Windows/img_title")
  self.btn_close = self:GetControl("Windows/btn_close")
  self.currency = self:GetControl("Windows/currency")
  self.go_gold = self:GetControl("Windows/currency/go_gold")
  self.go_integral = self:GetControl("Windows/currency/go_integral")
  self.go_gem = self:GetControl("Windows/currency/go_gem")
  self.go_meltingPoint = self:GetControl("Windows/currency/go_meltingPoint")
  self.armor_info = self:GetControl("Windows/frameInfoParent/armor_info")
  self.boot_info = self:GetControl("Windows/frameInfoParent/boot_info")
  self.glove_info = self:GetControl("Windows/frameInfoParent/glove_info")
  self.helm_info = self:GetControl("Windows/frameInfoParent/helm_info")
  self.pant_info = self:GetControl("Windows/frameInfoParent/pant_info")
  self.weaponL_info = self:GetControl("Windows/frameInfoParent/weaponL_info")
  self.weaponR_info = self:GetControl("Windows/frameInfoParent/weaponR_info")
  self.plane_top = self:GetControl("plane_top")
end

function Bag_EquipInfoHolySkeletonUI:Init()
end

local equipObjTable = {}
local equipInfoTable = {}

function Bag_EquipInfoHolySkeletonUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Bag_EquipInfoHolySkeletonUI:InitUI()
  self:InitUIObj()
  self:PropsInit()
end

function Bag_EquipInfoHolySkeletonUI:InitUIObj()
  equipObjTable = {
    [1] = self.helm_frame,
    [2] = self.glove_frame,
    [3] = self.weapon_frame_left,
    [4] = self.weapon_frame_right,
    [5] = self.armor_frame,
    [6] = self.pant_frame,
    [7] = self.boot_frame
  }
  equipInfoTable = {
    [1] = self.helm_info,
    [2] = self.glove_info,
    [3] = self.weaponL_info,
    [4] = self.weaponR_info,
    [5] = self.armor_info,
    [6] = self.pant_info,
    [7] = self.boot_info
  }
end

function Bag_EquipInfoHolySkeletonUI:PropsInit()
  self.go_gold = ItemUtility.InitItem(self.go_gold)
  self.go_integral = ItemUtility.InitItem(self.go_integral)
  self.go_gem = ItemUtility.InitItem(self.go_gem)
  self.go_meltingPoint = ItemUtility.InitItem(self.go_meltingPoint)
  self.goldTbl = ItemUtility.GenerateItemData(ECoinsType.gemNotTrade)
  self.integralTbl = ItemUtility.GenerateItemData(ECoinsType.integral)
  self.gemTbl = ItemUtility.GenerateItemData(ECoinsType.gem)
  self.meltingTbl = ItemUtility.GenerateItemData(ECoinsType.bindIntegral)
  ItemUtility.ShowItem(self, self.go_gold, self.goldTbl, true)
  ItemUtility.ShowItem(self, self.go_integral, self.integralTbl, true)
  ItemUtility.ShowItem(self, self.go_gem, self.gemTbl, true)
  ItemUtility.ShowItem(self, self.go_meltingPoint, self.meltingTbl, true)
end

function Bag_EquipInfoHolySkeletonUI:RegistUIEvents()
  for index, btn in pairs(equipObjTable) do
    btn.equipIndex = index
    btn:SetOnClick(self, self.EquipModelOnClick)
  end
  self.btn_closeBg:SetOnClick(self, self.btn_closeOnClick)
  self.btn_close:SetOnClick(self, self.btn_closeOnClick)
end

function Bag_EquipInfoHolySkeletonUI:btn_closeOnClick(control)
  self:OnHide()
end

function Bag_EquipInfoHolySkeletonUI:EquipModelOnClick(control)
  local modelIndex = control.equipIndex
  self:ShowSelectEffect(modelIndex, equipObjTable[modelIndex])
  EventManager.Dispatch(Event.SelectedHolySkeletonEquip, {modelIndex = modelIndex})
end

function Bag_EquipInfoHolySkeletonUI:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function Bag_EquipInfoHolySkeletonUI:RegistEvents()
  self:RegistEvent(Event.HolySkeletonNavChange, self.HolySkeletonNavChange, self)
  self:RegistEvent(Event.HolySkeletonEquipSetChange, self.HolySkeletonEquipSetChange, self)
end

function Bag_EquipInfoHolySkeletonUI:Refresh()
  self.select_effect:SetActive(false)
  self:ShowProps()
end

function Bag_EquipInfoHolySkeletonUI:ShowProps()
  local coinCount = 0
  if BagInfoData.CoinInfos[ECoinsType.gemNotTrade] then
    coinCount = BagInfoData.CoinInfos[ECoinsType.gemNotTrade]
  end
  self.go_gold.countCtr:SetText(coinCount)
  local integralCount = 0
  if BagInfoData.CoinInfos[ECoinsType.integral] then
    integralCount = BagInfoData.CoinInfos[ECoinsType.integral]
  end
  self.go_integral.countCtr:SetText(integralCount)
  local gemCount = 0
  if BagInfoData.CoinInfos[ECoinsType.gem] then
    gemCount = BagInfoData.CoinInfos[ECoinsType.gem]
  end
  self.go_gem.countCtr:SetText(gemCount)
  local meltingCount = 0
  if BagInfoData.CoinInfos[ECoinsType.bindIntegral] then
    meltingCount = BagInfoData.CoinInfos[ECoinsType.bindIntegral]
  end
  self.go_meltingPoint.countCtr:SetText(meltingCount)
end

function Bag_EquipInfoHolySkeletonUI:ShowSelectEffect(condition, parent)
  if parent == nil or condition == nil then
    return
  end
  self.select_effect.transform.anchoredPosition = Vector2(0, 0)
  if condition == 1 then
    self.select_effect:SetScale(Vector3(62, 52, 1))
  elseif condition == 2 then
    self.select_effect:SetScale(Vector3(42, 34.5, 1))
  elseif condition == 3 then
    self.select_effect:SetScale(Vector3(52, 43, 1))
  elseif condition == 4 then
    self.select_effect:SetScale(Vector3(50, 42, 1))
  elseif condition == 5 then
    self.select_effect:SetScale(Vector3(97, 80, 1))
  elseif condition == 6 then
    self.select_effect:SetScale(Vector3(42, 34.5, 1))
  elseif condition == 7 then
    self.select_effect:SetScale(Vector3(42, 35, 1))
  end
  self.select_effect:SetActive(true)
  self.select_effect:SetParent(parent)
end

function Bag_EquipInfoHolySkeletonUI:HolySkeletonNavChange(_, data)
  if data == nil then
    return
  end
  if data.from == UIID.Equip_HolySkeletonUI then
    self:SetHolySkeletonIntensifyFirst()
    self:RefreshHoleUIState(false)
  elseif data.from == UIID.Equip_HolySkeletonInlayUI then
    self:SetHolySkeletonSetFirst()
    self:RefreshHoleUIState(true)
  end
end

function Bag_EquipInfoHolySkeletonUI:SetHolySkeletonIntensifyFirst()
  local modelIndex = gameMgr:GetAvatarManager():GetMainPlayer():GetHolySkeletonIntensifyDataMgr():GetFistHolySkeletonIntensifyPlace()
  self:ShowSelectEffect(modelIndex, equipObjTable[modelIndex])
  EventManager.Dispatch(Event.SelectedHolySkeletonEquip, {modelIndex = modelIndex})
end

function Bag_EquipInfoHolySkeletonUI:SetHolySkeletonSetFirst()
  local modelIndex = gameMgr:GetAvatarManager():GetMainPlayer():GetSacredBoneDataMgr():GetEquipDataIndex()
  self:ShowSelectEffect(modelIndex, equipObjTable[modelIndex])
  EventManager.Dispatch(Event.SelectedHolySkeletonEquip, {modelIndex = modelIndex})
end

function Bag_EquipInfoHolySkeletonUI:RefreshHoleUIState(state)
  for i, v in pairs(equipInfoTable) do
    if IsNil(v:GetChild("hole")) then
      v:GetChild("hole"):SetActive(state)
    end
  end
end

function Bag_EquipInfoHolySkeletonUI:HolySkeletonEquipSetChange()
  local SacredBoneEquipData = gameMgr:GetAvatarManager():GetMainPlayer():GetSacredBoneDataMgr().SacredBoneEquipData
  for i, v in ipairs(SacredBoneEquipData) do
    for x, y in ipairs(v.SacredBoneData) do
      if x == 1 then
        local img_LordSoul = equipInfoTable[i]:GetChild("hole/img_LordSoul")
        img_LordSoul:SetActive(true)
        if IsNil(img_LordSoul) then
          if y.SacredBoneSetType == false then
            img_LordSoul:SetActive(false)
          else
            self:SetSprite("Atlas_Common", "1600007", img_LordSoul)
          end
        end
      else
        local img_ViceSoul = equipInfoTable[i]:GetChild("hole/img_ViceSoul/ViceSoul_" .. x - 1)
        local img_on = img_ViceSoul:GetChild("img_on")
        img_on:SetActive(true)
        img_ViceSoul:GetChild("img_off"):SetActive(true)
        if IsNil(img_ViceSoul) then
          if y.SacredBoneLockType == false then
            img_ViceSoul:GetChild("img_off"):SetActive(false)
          end
          if y.SacredBoneSetType == false then
            img_on:SetActive(false)
          else
            local Number = "160000" .. y.SacredBoneEquip.Quality % 10
            self:SetSprite("Atlas_Common", Number, img_on)
          end
        end
      end
    end
  end
end

function Bag_EquipInfoHolySkeletonUI:OnHide()
  UIManager.Hide(UIID.Bag_EquipInfoHolySkeletonUI)
end

function Bag_EquipInfoHolySkeletonUI:OnDestroy()
end
