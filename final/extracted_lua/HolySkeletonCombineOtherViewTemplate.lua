local HolySkeletonCombineOtherViewTemplate = {}

function HolySkeletonCombineOtherViewTemplate:Init(root)
  self.parent = root
  self:InitControls()
  self:InitParams()
  self:BindUIEvent()
end

function HolySkeletonCombineOtherViewTemplate:InitControls()
  self.rewardItemCtr = self:GetControl("go_itemGet/btn_3DItem")
  self.itemEffect = self:GetControl("go_itemGet/itemEffect")
  self.go_costParent = self:GetControl("go_costItem/costParent")
  self.btn_combine = self:GetControl("btn_combine")
  self.btn_all = self:GetControl("btn_all")
  self.lab_des = self:GetControl("lab_des")
end

function HolySkeletonCombineOtherViewTemplate:InitParams()
  self.isCanCombine = true
  self.soulHolesItemOnlyId = {}
  self.soulHoles = {}
  self.soulHoleNum = 3
  self.surplusSoulHoleNum = self.soulHoleNum
  for i = 1, self.soulHoleNum do
    local ctr = UIControl(self.go_costParent.transform:GetChild(i - 1))
    ctr.HolySkeleton_Item = UIControl(ctr.transform, "HolySkeleton_Item")
    ctr.btn_addItem = UIControl(ctr.transform, "btn_addItem")
    ctr.btn_del = UIControl(ctr.transform, "btn_del")
    ctr.img_choose = UIControl(ctr.transform, "img_choose")
    table.insert(self.soulHoles, ctr)
  end
  UIEffectUtility.SetUIEffect("Eff_UI_holySkeletonCombine", self.itemEffect, false, Vector3(0.4, 0.4, 0.4))
  self.itemEffect:SetActive(false)
  self.zeroOneSoulTypeCombineTip = ClientTable.cfg_Ui_wordManager:GetUi_wordCount("Equip_HolySkeletonCombineUI_1")
  self.twoSoulTypeCombineTip = ClientTable.cfg_Ui_wordManager:GetUi_wordCount("Equip_HolySkeletonCombineUI_3")
  self.threeSoulTypeCombineTip = ClientTable.cfg_Ui_wordManager:GetUi_wordCount("Equip_HolySkeletonCombineUI_2")
  self.lab_des:SetText(self.zeroOneSoulTypeCombineTip)
end

function HolySkeletonCombineOtherViewTemplate:BindUIEvent()
  self.btn_combine:SetOnClick(self, self.btn_combineOnClick)
  self.btn_all:SetOnClick(self, self.btn_allOnClick)
end

function HolySkeletonCombineOtherViewTemplate:btn_combineOnClick()
  if self.isCanCombine == false then
    return
  end
  if self.surplusSoulHoleNum > 0 then
    FloatingTipUtility.QuickMsg("H\195\163y b\225\187\143 th\195\170m nhi\225\187\129u Linh H\225\187\147n")
    return
  end
  if self.parent.tog_overAni:GetIsOn() == false then
    if self.waitCoroutine then
      Coroutine.Stop(self.waitCoroutine)
      self.waitCoroutine = nil
    end
    self.waitCoroutine = Coroutine.Start(function()
      self.itemEffect:SetActive(false)
      self.itemEffect:SetActive(true)
      self.isCanCombine = false
      Coroutine.Wait(2)
      self:ReqCombine()
      self.waitCoroutine = nil
    end)
  else
    self.isCanCombine = false
    self:ReqCombine()
  end
end

function HolySkeletonCombineOtherViewTemplate:btn_allOnClick()
  if self.isCanCombine == false then
    return
  end
  if self.surplusSoulHoleNum <= 0 then
    FloatingTipUtility.QuickMsg("\195\148 \196\145\195\163 \196\145\225\186\167y")
    return
  end
  local holySkeletonCombineSoulBagTemp = gameMgr:GetAvatarManager():GetMainPlayer():GetSacredBoneDataMgr():GetHolySkeletonCombineSoulBagTemp()
  for i = 1, self.surplusSoulHoleNum do
    local bagItems = holySkeletonCombineSoulBagTemp and holySkeletonCombineSoulBagTemp.items
    if bagItems then
      if 0 < #bagItems then
        for j = 1, #bagItems do
          local itemTemp = bagItems[j] and bagItems[j].itemTemp
          local curFilterConditionAllItemId = gameMgr:GetAvatarManager():GetMainPlayer():GetSacredBoneDataMgr():GetCurFilterConditionAllItemId()
          if 1 <= table.count(curFilterConditionAllItemId) then
            if table.contains(curFilterConditionAllItemId, itemTemp.data.ItemId) and itemTemp and itemTemp.reduceCount < itemTemp.data.ItemCount and (self.fillableSoulType == itemTemp.data.SoulType or self.fillableSoulType == nil) and (self.fillableModQuality == itemTemp.data.ModQuality or self.fillableModQuality == nil) then
              itemTemp:BagItemOnClick()
              break
            end
          else
            FloatingTipUtility.QuickMsg("Hi\225\187\135n kh\195\180ng c\195\179 Linh H\225\187\147n \196\145\225\187\131 gh\195\169p th\195\170m")
            return
          end
        end
      else
        FloatingTipUtility.QuickMsg("Hi\225\187\135n kh\195\180ng c\195\179 Linh H\225\187\147n \196\145\225\187\131 gh\195\169p th\195\170m")
        return
      end
    end
  end
end

function HolySkeletonCombineOtherViewTemplate:Refresh(data, ui)
  if self.surplusSoulHoleNum <= 0 or data == nil or ui == nil then
    return
  end
  self.data = data
  self.parent = ui
  self:RefreshModelView()
  self:RefreshUIView()
end

function HolySkeletonCombineOtherViewTemplate:RefreshModelView()
  for i = 1, self.soulHoleNum do
    if self.soulHoles[i].HolySkeleton_Item.itemData == nil then
      local itemData = ItemUtility.GenerateItemDataByServerData(self.data.ItemInfo)
      ItemUtility.ShowItemCellByItemId(self.data.ItemId, 1, self.soulHoles[i].HolySkeleton_Item, self.parent, true, nil, {
        clickCallBack = function()
          UIManager.Show(UIID.ItemTipUI, {
            item = itemData,
            rightOperate = EItemOperateType.Show,
            ctrl = self.soulHoles[i].HolySkeleton_Item
          })
        end
      })
      ItemUtility.ResetItemCell(self.rewardItemCtr)
      self.soulHoles[i].btn_addItem:SetActive(false)
      self.soulHoles[i].btn_del:SetActive(true)
      self.soulHoles[i].btn_del:SetOnClick(self, function()
        if self.isCanCombine == true then
          ItemUtility.ResetItemCell(self.soulHoles[i].HolySkeleton_Item)
          self.surplusSoulHoleNum = self.surplusSoulHoleNum + 1
          self.fillableSoulType = self.surplusSoulHoleNum < self.soulHoleNum and self.fillableSoulType or nil
          self.fillableSubType = self.surplusSoulHoleNum < self.soulHoleNum and self.fillableSubType or nil
          self.fillableModQuality = self.surplusSoulHoleNum < self.soulHoleNum and self.fillableModQuality or nil
          ItemUtility.ResetItemCell(self.rewardItemCtr)
          self.soulHolesItemOnlyId[i] = nil
          self.soulHoles[i].btn_addItem:SetActive(true)
          self.soulHoles[i].btn_del:SetActive(false)
          EventManager.Dispatch(Event.SacredBoneBagChange)
        end
      end)
      self.surplusSoulHoleNum = self.surplusSoulHoleNum - 1
      self.fillableSoulType = self.data.SoulType
      self.fillableSubType = self.data.SubType
      self.fillableModQuality = self.data.ModQuality
      self.soulHolesItemOnlyId[i] = self.data.ItemInfo.id
      break
    end
  end
end

function HolySkeletonCombineOtherViewTemplate:RefreshUIView()
end

function HolySkeletonCombineOtherViewTemplate:ReqCombine()
  local cfgBoneMixId = ClientTable.cfg_Bone_mixManager:GetId(self.data.ItemId)
  local itemIds = {}
  for i, v in pairs(self.soulHolesItemOnlyId) do
    table.insert(itemIds, v)
  end
  networkRequest.ReqBoneMix(cfgBoneMixId, itemIds)
  self:ResetCurSelectedCombineData(true)
end

function HolySkeletonCombineOtherViewTemplate:OnFilterConditionChange(chooseType, chooseQuality)
  self.soulHoleNum = gameMgr:GetAvatarManager():GetMainPlayer():GetSacredBoneDataMgr():GetMeetCombineCount(chooseType, chooseQuality)
  self.surplusSoulHoleNum = self.soulHoleNum
  for i, v in pairs(self.soulHoles) do
    v:SetActive(i <= self.soulHoleNum)
  end
  local tip = ""
  if chooseType < 2 then
    tip = self.zeroOneSoulTypeCombineTip
  elseif chooseType == 2 then
    tip = self.twoSoulTypeCombineTip
  elseif chooseType == 3 then
    tip = self.threeSoulTypeCombineTip
  end
  self.lab_des:SetText(tip)
end

function HolySkeletonCombineOtherViewTemplate:GetFilledHoleNumByOnlyID(onlyId)
  local reduceNum = 0
  for i = 1, self.soulHoleNum do
    if self.soulHolesItemOnlyId[i] and self.soulHolesItemOnlyId[i] == onlyId then
      reduceNum = reduceNum + 1
    end
  end
  return reduceNum
end

function HolySkeletonCombineOtherViewTemplate:ResetCurSelectedCombineData(isResetRewardItemModelView)
  self.surplusSoulHoleNum = self.soulHoleNum
  self.fillableSoulType = nil
  self.fillableSubType = nil
  self.fillableModQuality = nil
  self.soulHolesItemOnlyId = {}
  for i = 1, self.soulHoleNum do
    ItemUtility.ResetItemCell(self.soulHoles[i].HolySkeleton_Item)
    self.soulHoles[i].btn_addItem:SetActive(true)
    self.soulHoles[i].btn_del:SetActive(false)
  end
  if isResetRewardItemModelView then
    ItemUtility.ResetItemCell(self.rewardItemCtr)
  end
end

function HolySkeletonCombineOtherViewTemplate:OnHide()
  if self.waitCoroutine then
    Coroutine.Stop(self.waitCoroutine)
    self.waitCoroutine = nil
    self:ReqCombine()
  else
    self:ResetCurSelectedCombineData(true)
  end
  self.itemEffect:SetActive(false)
  self.isCanCombine = true
  self.soulHoleNum = 3
  self.surplusSoulHoleNum = self.soulHoleNum
  for i = 1, self.soulHoleNum do
    self.soulHoles[i]:SetActive(true)
  end
  self.lab_des:SetText(self.zeroOneSoulTypeCombineTip)
end

return HolySkeletonCombineOtherViewTemplate
