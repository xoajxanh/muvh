Tip_GuardToGiftUI = class(BaseUI)
Tip_GuardToGiftUI.layer = UILayer.Tip
Tip_GuardToGiftUI.orderInLayer = 0
Tip_GuardToGiftUI.hideType = UIHideType.WaitDestroy
Tip_GuardToGiftUI.hideFunc = UIHideFunc.MoveOutOfScreen
Tip_GuardToGiftUI.escClose = UIEscClose.DontClose

function Tip_GuardToGiftUI:InitControls()
  self.btn_closeBg = self:GetControl("btn_closeBg")
  self.bg_firstCharge = self:GetControl("bg_firstCharge")
  self.btn_close = self:GetControl("btn_close")
  self.Tip_ModelShow = self:GetControl("Tip_ModelShow")
  self.btn_buy = self:GetControl("go_buy/btn_buy")
  self.lab_buy = self:GetControl("go_buy/btn_buy/lab_buy")
  self.Eff_UI_annuikuang03 = self:GetControl("go_buy/btn_buy/Eff_UI_annuikuang03")
  self.lab_itemName = self:GetControl("lab_itemName")
end

function Tip_GuardToGiftUI:Init()
end

function Tip_GuardToGiftUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Tip_GuardToGiftUI:InitUI()
  self.CenterModel = ItemCellData()
end

function Tip_GuardToGiftUI:RegistUIEvents()
  self.btn_closeBg:SetOnClick(self, self.btn_closeBgOnClick)
  self.btn_close:SetOnClick(self, self.btn_closeOnClick)
  self.Tip_ModelShow:SetOnClick(self, self.Tip_ModelShowOnClick)
  self.btn_buy:SetOnClick(self, self.btn_buyOnClick)
end

function Tip_GuardToGiftUI:btn_closeBgOnClick(control)
end

function Tip_GuardToGiftUI:btn_closeOnClick(control)
  UIManager.Hide(UIID.Tip_GuardToGiftUI)
end

function Tip_GuardToGiftUI:Tip_ModelShowOnClick(control)
end

function Tip_GuardToGiftUI:btn_buyOnClick(control)
  local strengthenItem = BagInfoData.GetFirstItemTblByConfigId(self.itemID)
  if strengthenItem ~= nil then
    BagInfoController.UseItemReq(1, strengthenItem.id)
  else
    local dic = ClientTable.cfg_Global_globalManager:GetBuyGuardJumpInfoDic()
    if dic ~= nil and dic[self.itemID] ~= nil then
      NavigationUtility.ClickNavigationByNavId(dic[self.itemID])
    end
  end
  UIManager.Hide(UIID.Tip_GuardToGiftUI)
end

function Tip_GuardToGiftUI:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function Tip_GuardToGiftUI:RegistEvents()
end

function Tip_GuardToGiftUI:Refresh()
  local nowSelectData = self.GuardInfoItem()
  if nowSelectData == nil or nowSelectData.nowtable == nil then
    return
  end
  local itemID = nowSelectData.nowtable.strengthenModel
  self.itemID = nowSelectData.nowtable.strengthenModel
  local itemData = ItemUtility.GenerateItemData(itemID)
  self.CenterModel:RefreshData(itemData)
  ItemUtility.ShowItemCell(self.Tip_ModelShow, self.CenterModel, self, false)
  self.lab_itemName:SetText(nowSelectData.nowtable.changeName)
  self:LoadingImages("img_guardtogift_bg" .. nowSelectData.nowtable.petType, self.bg_firstCharge)
end

function Tip_GuardToGiftUI:LoadingImages(img, obj)
  self.cor = Coroutine.Start(function()
    local name = string.format("Texture/%s.png", img)
    local request = self:LoadAssetAsync(name, typeof(CS.UnityEngine.Sprite))
    Coroutine.Yield(request)
    if request.isError then
      logError(request.error)
      Coroutine.Break()
    end
    obj:SetSprite(request.res)
    self.cor = nil
  end)
end

function Tip_GuardToGiftUI:Update()
  if self.CenterModel and self.CenterModel:GetModelData() and self.CenterModel.itemData ~= nil and self.CenterModel.itemData.tblItem ~= nil then
    RoleEquipUtility.EquipModelRotation(self.CenterModel:GetModelData(), self.CenterModel.itemData.tblItem.SpinAxis, 2)
  end
end

function Tip_GuardToGiftUI:OnHide()
end

function Tip_GuardToGiftUI:OnDestroy()
end

function Tip_GuardToGiftUI.GuardInfoItem()
  local GuardData = gameMgr:GetAvatarManager():GetMainPlayer():GetGuardData()
  if GuardData == nil then
    return
  end
  return GuardData:GetNowSelectGuarItem()
end
