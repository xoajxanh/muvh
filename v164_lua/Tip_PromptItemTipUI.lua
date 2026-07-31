Tip_PromptItemTipUI = class(BaseUI)
Tip_PromptItemTipUI.layer = UILayer.Tip
Tip_PromptItemTipUI.orderInLayer = 7
Tip_PromptItemTipUI.hideType = UIHideType.WaitDestroy
Tip_PromptItemTipUI.hideFunc = UIHideFunc.MoveOutOfScreen
Tip_PromptItemTipUI.escClose = UIEscClose.DontClose

function Tip_PromptItemTipUI:InitControls()
  self.Image_TipBg = self:GetControl("Panel_Tip/Image_TipBg")
  self.Button_OK = self:GetControl("Panel_Tip/Image_TipBg/ButtonTriggerView/Button_OK")
  self.Text_OK = self:GetControl("Panel_Tip/Image_TipBg/ButtonTriggerView/Button_OK/Text_OK")
  self.Button_Cancel = self:GetControl("Panel_Tip/Image_TipBg/ButtonTriggerView/Button_Cancel")
  self.Text_Cancel = self:GetControl("Panel_Tip/Image_TipBg/ButtonTriggerView/Button_Cancel/Text_Cancel")
  self.lab_Descriptionon = self:GetControl("Panel_Tip/Image_TipBg/ButtonTriggerView/Button_Cancel/Btn_Description")
  self.Text_TipContent = self:GetControl("Panel_Tip/Image_TipBg/Text_TipContent")
  self.btn_3DItem_0 = self:GetControl("Panel_Tip/Image_TipBg/sw_item/Viewport/Content/lab_title_0/btn_3DItem")
  self.btn_3DItem_1 = self:GetControl("Panel_Tip/Image_TipBg/sw_item/Viewport/Content/lab_title_1/btn_3DItem")
  self.btn_3DItem_2 = self:GetControl("Panel_Tip/Image_TipBg/sw_item/Viewport/Content/lab_title_2/btn_3DItem")
  self.lab_title_2 = self:GetControl("Panel_Tip/Image_TipBg/sw_item/Viewport/Content/lab_title_2")
  self.lab_diamondNum = self:GetControl("Panel_Tip/Image_TipBg/ButtonTriggerView/Button_OK/btn_needGold/lab_num")
end

function Tip_PromptItemTipUI:Init()
  self.redStr = "#F36055"
  self.greenStr = "#57FF3B"
  self.itemCellData1 = ItemCellData()
  self.itemCellData2 = ItemCellData()
  self.itemCellData3 = ItemCellData()
  self.itemCellDataTbl = {
    self.itemCellData1,
    self.itemCellData2,
    self.itemCellData3
  }
end

function Tip_PromptItemTipUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Tip_PromptItemTipUI:InitUI()
  self.lab_Descriptionon:SetActive(true)
end

function Tip_PromptItemTipUI:RegistUIEvents()
  self.Button_OK:SetOnClick(self, self.Button_OKOnClick)
  self.Button_Cancel:SetOnClick(self, self.Button_CancelOnClick)
  self.btn_3DItem_0:SetOnClick(self, self.btn_3DItemOnClick)
  self.btn_3DItem_1:SetOnClick(self, self.btn_3DItemOnClick)
  self.btn_3DItem_2:SetOnClick(self, self.btn_3DItemOnClick)
end

function Tip_PromptItemTipUI:Button_OKOnClick(control)
  local isEnough = PandoraActivityData.CheckDiamondEnough()
  if isEnough == false then
    TipUtility.QuickShowPrompt({
      id = 88,
      cancelAction = function()
        UIManager.Hide(UIID.PromptTipUI)
      end,
      okAction = function()
        UIManager.Hide(UIID.PromptTipUI)
        UIManager.Hide(UIID.Tip_PromptItemTipUI)
        if RechargeData.IsNeedGotoRecharge(BusinessPayType.None) then
          UIManager.Show(UIID.Recharge_FirstChargeUI, {
            PayType = BusinessPayType.None
          })
        else
          UIManager.Show(UIID.RechargeWelfareUI, {openFirstTab = 4})
        end
      end
    })
    return
  end
  EventManager.Dispatch(Event.PandoraActivityRareChooseNext, self.args.layer)
end

function Tip_PromptItemTipUI:Button_CancelOnClick(control)
  networkRequest.ReqPandoraRareChoose(1, PandoraActivityData.nowSelectTogCommerceId)
  UIManager.Hide(UIID.Tip_PromptItemTipUI)
end

function Tip_PromptItemTipUI:btn_3DItemOnClick(control)
end

function Tip_PromptItemTipUI:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function Tip_PromptItemTipUI:RegistEvents()
end

function Tip_PromptItemTipUI:Refresh()
  if self.args == nil then
    return
  end
  local cfg
  if self.args.layer == 1 then
    cfg = ClientTable.cfg_Ui_promptwordManager:TryGetValue(83)
    self.lab_Descriptionon:SetText(cfg.leftButtonTips)
  else
    cfg = ClientTable.cfg_Ui_promptwordManager:TryGetValue(84)
    self.lab_Descriptionon:SetText(string.format(cfg.leftButtonTips, self.args.itemData[1].count))
  end
  self:CreateItemCellData(self.args.layer, 1)
  ItemUtility.ShowItemCell(self.btn_3DItem_0, self.itemCellData1, self, true)
  self:CreateItemCellData(self.args.layer, 2)
  ItemUtility.ShowItemCell(self.btn_3DItem_1, self.itemCellData2, self, true)
  rewardData = PandoraActivityData.GetNextLayerRewardData(self.args.layer, 3)
  if rewardData == false then
    self.lab_title_2:SetActive(false)
  else
    self.lab_title_2:SetActive(true)
    self:CreateItemCellData(self.args.layer, 3)
    ItemUtility.ShowItemCell(self.btn_3DItem_2, self.itemCellData3, self, true)
  end
  local str = string.format(cfg.content, self.args.layer - 1)
  self.Text_TipContent:SetText(str)
  self.Text_OK:SetText(cfg.rightButton)
  self.Text_Cancel:SetText(cfg.leftButton)
  local isEnough = PandoraActivityData.CheckDiamondEnough()
  local poolData = ClientTable.cfg_Commerce_pandorapoolManager:TryGetValue(PandoraActivityData.nowSelectTogCommerceId, "commerceId")
  if poolData == nil or poolData.cost == nil then
    return
  end
  local labStr = tostring(poolData.cost[2])
  if isEnough == false then
    self.lab_diamondNum:SetText(string.format("<color=%s>%s</color>", self.redStr, labStr))
  else
    self.lab_diamondNum:SetText(string.format("<color=%s>%s</color>", self.greenStr, labStr))
  end
end

function Tip_PromptItemTipUI:CreateItemCellData(layer, type)
  local rewardData = PandoraActivityData.GetNextLayerRewardData(layer, type)
  if rewardData == false then
    return
  end
  local itemData = ItemUtility.GenerateItemData(rewardData.itemId)
  itemData.count = rewardData.count
  self.itemCellDataTbl[type]:RefreshData(itemData)
end

function Tip_PromptItemTipUI:OnHide()
end

function Tip_PromptItemTipUI:OnDestroy()
end
