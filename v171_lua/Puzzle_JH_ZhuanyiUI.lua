Puzzle_JH_ZhuanyiUI = class(BaseUI)
Puzzle_JH_ZhuanyiUI.layer = UILayer.Panel
Puzzle_JH_ZhuanyiUI.orderInLayer = 0
Puzzle_JH_ZhuanyiUI.hideType = UIHideType.WaitDestroy
Puzzle_JH_ZhuanyiUI.hideFunc = UIHideFunc.MoveOutOfScreen
Puzzle_JH_ZhuanyiUI.escClose = UIEscClose.DontClose
local this = Puzzle_JH_ZhuanyiUI

function Puzzle_JH_ZhuanyiUI:InitControls()
  self.bg_equip = self:GetControl("bg_equip")
  self.lab_item = self:GetControl("bg_equip/lab_item")
  self.selectSecond = self:GetControl("bg_equip/img_zhuanyiframe/selectSecond")
  self.selectMain = self:GetControl("bg_equip/img_zhuanyiframe/selectMain")
  self.btn_MainParent = self:GetControl("bg_equip/btn_MainParent")
  self.main_additem = self:GetControl("bg_equip/btn_MainParent/bg_additem")
  self.btn_SecondParent = self:GetControl("bg_equip/btn_SecondParent")
  self.second_additem = self:GetControl("bg_equip/btn_SecondParent/bg_additem")
  self.btn_zhuanyi = self:GetControl("bg_equip/btn_zhuanyi")
  self.text_zhuijia = self:GetControl("bg_equip/btn_zhuanyi/text_zhuijia")
  self.Eff_UI_xinanniu = self:GetControl("bg_equip/btn_zhuanyi/Eff_UI_xinanniu")
  self.btn_close = self:GetControl("bg_equip/btn_close")
  self.btn_xiexia = self:GetControl("bg_equip/btn_xiexia")
  self.btn_xiexia_right = self:GetControl("bg_equip/btn_xiexia_right")
  self.descBtn = self:GetControl("descBtn")
  self.img_btn_l = self:GetControl("img_btn_l")
  self.img_btn_r = self:GetControl("img_btn_r")
  self.txt_tip_r = self:GetControl("txt_tip_r")
  self.txt_tip_l = self:GetControl("txt_tip_l")
  self.costInfoUI = self:GetControl("costInfoUI")
  self.Content = self:GetControl("costInfoUI/Viewport/Content")
  self.sellProfit = self:GetControl("costInfoUI/Viewport/Content/sellProfit")
  self.lab_num = self:GetControl("costInfoUI/Viewport/Content/sellProfit/lab_num")
  self.btn_getCost = self:GetControl("costInfoUI/btn_getCost")
  self.costItem = self:GetControl("costInfoUI/costItem")
  self.lab_name = self:GetControl("costInfoUI/costItem/lab_name")
end

function Puzzle_JH_ZhuanyiUI:Init()
end

function Puzzle_JH_ZhuanyiUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Puzzle_JH_ZhuanyiUI:InitUI()
  self.isMainHasJinghe = false
  self.isSecondHasJinghe = false
  self.isMainHasJingheData = nil
  self.isSecondHasJingheData = nil
  self.cellData = nil
  self:SetPanelUIShowState(1)
end

function Puzzle_JH_ZhuanyiUI:RegistUIEvents()
  self.btn_MainParent:SetOnClick(self, self.btn_MainParentOnClick)
  self.btn_SecondParent:SetOnClick(self, self.btn_SecondParentOnClick)
  self.btn_zhuanyi:SetOnClick(self, self.btn_zhuanyiOnClick)
  self.btn_close:SetOnClick(self, self.btn_closeOnClick)
  self.btn_xiexia:SetOnClick(self, self.btn_xiexiaOnClick)
  self.btn_xiexia_right:SetOnClick(self, self.btn_xiexia_rightOnClick)
  self.descBtn:SetOnClick(self, self.descBtnOnClick)
  self.img_btn_l:SetOnClick(self, self.img_btn_lOnClick)
  self.img_btn_r:SetOnClick(self, self.img_btn_rOnClick)
  self.sellProfit:SetOnClick(self, self.sellProfitOnClick)
  self.btn_getCost:SetOnClick(self, self.btn_getCostOnClick)
  self.costItem:SetOnClick(self, self.costItemOnClick)
end

function Puzzle_JH_ZhuanyiUI:btn_MainParentOnClick(control)
end

function Puzzle_JH_ZhuanyiUI:btn_SecondParentOnClick(control)
end

function Puzzle_JH_ZhuanyiUI:btn_zhuanyiOnClick(control)
  CrystalNucleusZhuanYiController.canChangeBagRefreshFunc = false
  if self.isMainHasJingheData and self.isSecondHasJingheData then
    networkRequest.ReqCrystalNucleusTransfer(self.isSecondHasJingheData.m_ServerInfo.id, self.isMainHasJingheData.m_ServerInfo.id)
  end
  self:SetPanelUIShowState(1)
end

function Puzzle_JH_ZhuanyiUI:btn_closeOnClick(control)
  UIManager.Hide(UIID.Puzzle_JH_NavUI)
end

function Puzzle_JH_ZhuanyiUI:btn_xiexiaOnClick(control)
  self:SetPanelUIShowState(1)
  EventManager.Dispatch(Event.CrystalNucleusTransferBagChange, nil)
end

function Puzzle_JH_ZhuanyiUI:btn_xiexia_rightOnClick(control)
  self:SetPanelUIShowState(2)
end

function Puzzle_JH_ZhuanyiUI:descBtnOnClick(control)
  local lvCfg = ConfigManager.FindConfigs("cfg_Ui_description", "uiName", "Puzzle_JH_ZhuanyiUI")
  UIManager.Show(UIID.System_DescUI, {
    id = lvCfg[1].id
  })
end

function Puzzle_JH_ZhuanyiUI:img_btn_lOnClick(control)
end

function Puzzle_JH_ZhuanyiUI:img_btn_rOnClick(control)
end

function Puzzle_JH_ZhuanyiUI:sellProfitOnClick(control)
end

function Puzzle_JH_ZhuanyiUI:btn_getCostOnClick(control)
end

function Puzzle_JH_ZhuanyiUI:costItemOnClick(control)
end

function Puzzle_JH_ZhuanyiUI:SetPanelUIShowState(state)
  if state == 1 then
    self.selectSecond:SetActive(true)
    self.main_additem:SetActive(true)
    self.second_additem:SetActive(false)
    self.btn_zhuanyi:SetActive(false)
    self.btn_xiexia:SetActive(false)
    self.btn_xiexia_right:SetActive(false)
    self.txt_tip_l:SetActive(true)
    self.txt_tip_r:SetActive(false)
    self.lab_num:SetText("0")
    self:SetSprite("Atlas_Common", "tianjia_ty", self.selectMain, true)
    self:SetSprite("Atlas_Common", "tianjia_ty", self.selectSecond, true)
    if self.itemSize1 == nil and self.itemSize2 == nil then
      self.itemSize1 = self.selectMain.transform.localScale
      self.itemSize2 = self.selectSecond.transform.localScale
    end
    self.selectMain.transform.localScale = self.itemSize1
    self.selectSecond.transform.localScale = self.itemSize2
    this.isMainHasJinghe = false
    this.isSecondHasJinghe = false
    this.isMainHasJingheData = nil
    this.isSecondHasJingheData = nil
  elseif state == 2 then
    self.selectSecond:SetActive(true)
    self.main_additem:SetActive(false)
    self.second_additem:SetActive(true)
    self.btn_zhuanyi:SetActive(false)
    self.btn_xiexia:SetActive(true)
    self.btn_xiexia_right:SetActive(false)
    self.txt_tip_l:SetActive(false)
    self.txt_tip_r:SetActive(true)
    self:SetSprite("Atlas_Common", "tianjia_ty", self.selectSecond, true)
    self.selectSecond.transform.localScale = self.itemSize2
    this.isMainHasJinghe = true
    this.isSecondHasJinghe = false
    this.isSecondHasJingheData = nil
  elseif state == 3 then
    self.selectSecond:SetActive(false)
    self.main_additem:SetActive(false)
    self.second_additem:SetActive(false)
    self.btn_zhuanyi:SetActive(true)
    self.btn_xiexia:SetActive(true)
    self.btn_xiexia_right:SetActive(true)
    self.txt_tip_l:SetActive(false)
    self.txt_tip_r:SetActive(false)
    this.isMainHasJinghe = true
    this.isSecondHasJinghe = true
  end
end

function Puzzle_JH_ZhuanyiUI:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function Puzzle_JH_ZhuanyiUI:RegistEvents()
  self:RegistEvent(Event.CrystalNucleusTransfer, self.OnCrystalNucleusTransfer)
  self:RegistEvent(Event.Bag_CoinChanged, self.OnCoinChanged, self)
end

function Puzzle_JH_ZhuanyiUI:OnCoinChanged()
  self:ChangeZhuanYiDeplete()
end

function Puzzle_JH_ZhuanyiUI:OnCrystalNucleusTransfer(itemData)
  if this.isMainHasJinghe == false then
    this:SetSprite("Atlas_Common", tostring(itemData.m_ItemConfig.icon), this.selectMain, true)
    this.selectMain.transform.localScale = this.itemSize1 * 0.5
    this:SetPanelUIShowState(2)
    this.isMainHasJingheData = itemData
    EventManager.Dispatch(Event.CrystalNucleusTransferBagChange, itemData.m_ServerInfo.nucleusLevel)
  elseif this.isMainHasJinghe == true and this.isSecondHasJinghe == false then
    if itemData == nil then
      return
    end
    this:SetSprite("Atlas_Common", tostring(itemData.m_ItemConfig.icon), this.selectSecond, true)
    this.selectSecond.transform.localScale = this.itemSize2 * 0.5
    this:SetPanelUIShowState(3)
    this.isSecondHasJingheData = itemData
    this:ChangeZhuanYiDeplete()
  end
end

function Puzzle_JH_ZhuanyiUI:ChangeZhuanYiDeplete()
  if self.isMainHasJingheData == nil then
    return
  end
  local depleteCfg = ClientTable.cfg_puzzle_zhuanyiManager:GetDic()
  local cost
  for i, v in ipairs(depleteCfg) do
    if v.level == self.isMainHasJingheData.m_ServerInfo.nucleusLevel then
      cost = v.cost
      break
    end
  end
  local itemTbl = string.split(cost, "#")
  local id = tonumber(itemTbl[1])
  local itemData = ItemUtility.GenerateItemData(id)
  local bagCount = BagInfoData.GetItemTotalCountByItemId(id)
  local strColor = bagCount >= tonumber(itemTbl[2]) and "#00FF00" or "#FF0000"
  local strBag = Mathf.NumberShowFormat(bagCount, 1)
  local countT = Mathf.NumberShowFormat(tonumber(itemTbl[2]), 1)
  local countStr
  countStr = string.format("%s%s", string.GetColorText(strBag, strColor), string.GetColorText(string.format("/%s", countT), ItemQuality2ColorDic[EItemColorEnum.white]))
  self.lab_num:SetText(countStr)
  self.lab_name:SetText(itemData.tblItem.name)
  self.btn_getCost.itemData = itemData
  self.btn_getCost:SetOnClick(ItemUtility, ItemUtility.ClickObtainItemBtn)
  if bagCount >= tonumber(itemTbl[2]) then
    self.btn_zhuanyi:SetActive(true)
    self.btn_getCost:SetActive(false)
  else
    self.btn_zhuanyi:SetActive(false)
    self.btn_getCost:SetActive(true)
  end
end

function Puzzle_JH_ZhuanyiUI:ShowDepleteModel()
  local itemTbl = ClientTable.cfg_puzzle_zhuanyiManager:TryGetValue(2).cost
  local id = tonumber(string.split(itemTbl, "#")[1])
  local itemData = ItemUtility.GenerateItemData(id)
  self.cellData = ItemCellData()
  self.cellData:RefreshData(itemData)
  ItemUtility.ShowItemCell(self.costItem, self.cellData, self, true)
end

function Puzzle_JH_ZhuanyiUI:Refresh()
  self.btn_getCost:SetActive(false)
  self:SetPanelUIShowState(1)
  if self.cellData == nil then
    self:ShowDepleteModel()
  end
  CrystalNucleusZhuanYiController.canChangeBagRefreshFunc = false
end

function Puzzle_JH_ZhuanyiUI:OnHide()
end

function Puzzle_JH_ZhuanyiUI:OnDestroy()
end
