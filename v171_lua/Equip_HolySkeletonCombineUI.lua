Equip_HolySkeletonCombineUI = class(BaseUI)
Equip_HolySkeletonCombineUI.layer = UILayer.Panel
Equip_HolySkeletonCombineUI.orderInLayer = 0
Equip_HolySkeletonCombineUI.hideType = UIHideType.WaitDestroy
Equip_HolySkeletonCombineUI.hideFunc = UIHideFunc.MoveOutOfScreen
Equip_HolySkeletonCombineUI.escClose = UIEscClose.DontClose

function Equip_HolySkeletonCombineUI:InitControls()
  self.btn_closeBg = self:GetControl("btn_closeBg")
  self.img_combineInside = self:GetControl("img_combine/img_combineInside")
  self.tog_overAni = self:GetControl("img_combine/tog_overAni")
  self.btn_close = self:GetControl("btn_close")
end

function Equip_HolySkeletonCombineUI:Init()
end

function Equip_HolySkeletonCombineUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Equip_HolySkeletonCombineUI:InitUI()
  self.holySkeletonCombineOtherViewTemp = luaTemplateManager.GetNewTemplate(self.img_combineInside, LuaComponentTemplates.HolySkeletonCombineOtherViewTemplate, self)
end

function Equip_HolySkeletonCombineUI:RegistUIEvents()
  self.btn_closeBg:SetOnClick(self, self.btn_closeBgOnClick)
  self.btn_close:SetOnClick(self, self.btn_closeOnClick)
end

function Equip_HolySkeletonCombineUI:ClickBagItemCallBack(_, data)
  self.holySkeletonCombineOtherViewTemp:Refresh(data, self)
end

function Equip_HolySkeletonCombineUI:btn_closeBgOnClick()
  UIManager.Hide(UIID.Equip_HolySkeletonCombineUI)
end

function Equip_HolySkeletonCombineUI:btn_closeOnClick()
  UIManager.Hide(UIID.Equip_HolySkeletonCombineUI)
end

function Equip_HolySkeletonCombineUI:OnShow()
  gameMgr:GetAvatarManager():GetMainPlayer():GetSacredBoneDataMgr():SetHolySkeletonCombineOtherViewTemp(self.holySkeletonCombineOtherViewTemp)
  self:RegistEvents()
  self:Refresh()
end

function Equip_HolySkeletonCombineUI:RegistEvents()
  self:RegistEvent(Event.Item_CombineRsp, self.OnItemCombineRsp, self)
  self:RegistEvent(Event.HolySkeletonCombineBagItemOnClick, self.ClickBagItemCallBack, self)
end

function Equip_HolySkeletonCombineUI:OnItemCombineRsp(_, msg)
  if msg == nil then
    return
  end
  if #msg.rewards > 0 then
    local combineMap = {}
    local showItems = {}
    for i = 1, msg.combineCount do
      combineMap[tostring(i)] = i
    end
    for i, v in pairs(combineMap) do
      if msg.rewards[v] then
        table.insert(showItems, msg.rewards[v])
      end
    end
    if 0 < table.count(showItems) then
      ItemUtility.ShowItemCellByItemId(msg.rewards[1].itemId, 1, self.holySkeletonCombineOtherViewTemp.rewardItemCtr, self, true, nil, {
        clickCallBack = function()
          local itemData = ItemUtility.GenerateItemDataByServerData(msg.rewards[1])
          UIManager.Show(UIID.ItemTipUI, {
            item = itemData,
            rightOperate = EItemOperateType.Show,
            ctrl = self.holySkeletonCombineOtherViewTemp.rewardItemCtr
          })
        end
      })
      UIManager.Show(UIID.ObtainTipUI, {
        generalRewards = showItems,
        specialRewards = nil,
        isCombine = true
      })
    end
  end
  local holySkeletonCombineSoulBagTemp = gameMgr:GetAvatarManager():GetMainPlayer():GetSacredBoneDataMgr():GetHolySkeletonCombineSoulBagTemp()
  self.holySkeletonCombineOtherViewTemp:OnFilterConditionChange(holySkeletonCombineSoulBagTemp.ui.chooseSoulType, holySkeletonCombineSoulBagTemp.ui.chooseSoulQuality)
  self.holySkeletonCombineOtherViewTemp.isCanCombine = true
end

function Equip_HolySkeletonCombineUI:Refresh()
end

function Equip_HolySkeletonCombineUI:OnHide()
  self.holySkeletonCombineOtherViewTemp:OnHide()
end
