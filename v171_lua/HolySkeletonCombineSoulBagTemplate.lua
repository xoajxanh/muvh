local HolySkeletonCombineSoulBagTemplate = {}

function HolySkeletonCombineSoulBagTemplate:Init(root)
  self.parent = root
  self.reduceCount = 0
  self:InitControls()
  self:BindUIEvent()
end

function HolySkeletonCombineSoulBagTemplate:InitControls()
  self.ctr_itemModel = self:GetControl("HolySkeleton_Item")
  self.lab_name = self:GetControl("lab_skeletonName")
  self.lab_attribute = self:GetControl("lab_skeletonAttribute")
  self.lab_num = self:GetControl("img_skeletonNum/lab_num")
  self.img_select = self:GetControl("img_choose")
end

function HolySkeletonCombineSoulBagTemplate:BindUIEvent()
  self:UIControl():SetOnClick(self, self.BagItemOnClick)
end

function HolySkeletonCombineSoulBagTemplate:BagItemOnClick()
  if self.data == nil or self.parent == nil or self.data.ItemCount == nil or self.reduceCount == nil or self.reduceCount >= self.data.ItemCount then
    return
  end
  if self.data.Auction_AuctionUI then
    self.data.AuctionUIItemOnClick()
    return
  end
  if ClientTable.cfg_Bone_mixManager:IsContainThisItemId(self.data.ItemId) == false then
    FloatingTipUtility.QuickMsg("Linh H\225\187\147n hi\225\187\135n t\225\186\161i kh\195\180ng th\225\187\131 gh\195\169p th\195\170m")
    return
  end
  local holySkeletonCombineOtherViewTemp = gameMgr:GetAvatarManager():GetMainPlayer():GetSacredBoneDataMgr():GetHolySkeletonCombineOtherViewTemp()
  if holySkeletonCombineOtherViewTemp and holySkeletonCombineOtherViewTemp.surplusSoulHoleNum <= 0 then
    FloatingTipUtility.QuickMsg("\195\148 \196\145\195\163 \196\145\225\186\167y")
    return
  end
  if holySkeletonCombineOtherViewTemp and holySkeletonCombineOtherViewTemp.fillableSoulType and holySkeletonCombineOtherViewTemp.fillableSoulType ~= self.data.SoulType then
    FloatingTipUtility.QuickMsg("H\195\163y b\225\187\143 Linh H\225\187\147n c\195\185ng lo\225\186\161i v\195\160o")
    return
  end
  if self.data.SoulType ~= 3 then
    if holySkeletonCombineOtherViewTemp and holySkeletonCombineOtherViewTemp.fillableModQuality and holySkeletonCombineOtherViewTemp.fillableModQuality ~= self.data.ModQuality then
      FloatingTipUtility.QuickMsg("H\195\163y b\225\187\143 Linh H\225\187\147n c\195\185ng ph\225\186\169m ch\225\186\165t v\195\160o")
      return
    end
  elseif holySkeletonCombineOtherViewTemp and holySkeletonCombineOtherViewTemp.fillableModQuality and holySkeletonCombineOtherViewTemp.fillableSubType ~= self.data.SubType then
    FloatingTipUtility.QuickMsg("H\195\163y b\225\187\143 Linh H\225\187\147n c\195\185ng d\195\178ng v\195\160o")
    return
  end
  EventManager.Dispatch(Event.HolySkeletonCombineBagItemOnClick, self.data)
  self.reduceCount = self.reduceCount + 1
  if self.data.Auction_AuctionUI then
    self.lab_num:SetText(tostring(self.data.ItemCount))
  else
    self.lab_num:SetText(string.format("%d <color=#F36055>(-%d)</color>", self.data.ItemCount, self.reduceCount))
    self.img_select:SetActive(true)
  end
end

function HolySkeletonCombineSoulBagTemplate:Refresh(data, ui)
  if data == nil then
    self:UIControl():SetActive(false)
    return
  end
  self.data = data
  self.parent = ui
  self:RefreshModelView()
  self:RefreshUIView()
end

function HolySkeletonCombineSoulBagTemplate:RefreshModelView()
  ItemUtility.ShowItemCellByItemId(self.data.ItemId, 1, self.ctr_itemModel, self.parent, true, nil, {
    clickCallBack = function()
      if self.data.Auction_AuctionUI then
        self.data.AuctionUISkeletonItemClick()
      else
        local itemData = ItemUtility.GenerateItemDataByServerData(self.data.ItemInfo)
        UIManager.Show(UIID.ItemTipUI, {
          item = itemData,
          rightOperate = EItemOperateType.Show,
          ctrl = self.ctr_itemModel
        })
      end
    end
  })
end

function HolySkeletonCombineSoulBagTemplate:RefreshUIView()
  self.lab_name:SetText(string.GetColorText(self.data.Name, ItemQuality2ColorDic[self.data.ColorShow]))
  self.lab_attribute:SetText(string.GetColorText(self.data.SacredBoneAttribute, "#51C4FF"))
  local holySkeletonCombineOtherViewTemp = gameMgr:GetAvatarManager():GetMainPlayer():GetSacredBoneDataMgr():GetHolySkeletonCombineOtherViewTemp()
  self.reduceCount = holySkeletonCombineOtherViewTemp and holySkeletonCombineOtherViewTemp:GetFilledHoleNumByOnlyID(self.data.ItemInfo.id) or 0
  if self.data.Auction_AuctionUI then
    self.lab_num:SetText(tostring(self.data.ItemCount or 0))
    self.lab_num:SetActive(true)
  elseif self.reduceCount == 0 then
    self.lab_num:SetText(tostring(self.data.ItemCount or 0))
    self.img_select:SetActive(false)
  else
    self.lab_num:SetText(string.format("%d <color=#F36055>(-%d)</color>", self.data.ItemCount or 0, self.reduceCount or 0))
    self.img_select:SetActive(true)
  end
end

function HolySkeletonCombineSoulBagTemplate:SetSelect(bool)
  self.img_select:SetActive(bool)
end

function HolySkeletonCombineSoulBagTemplate:OnHide()
  self.reduceCount = 0
  ItemUtility.ResetItemCell(self.ctr_itemModel)
end

return HolySkeletonCombineSoulBagTemplate
