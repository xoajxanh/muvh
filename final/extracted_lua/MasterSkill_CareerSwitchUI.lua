MasterSkill_CareerSwitchUI = class(BaseUI)
MasterSkill_CareerSwitchUI.layer = UILayer.Panel
MasterSkill_CareerSwitchUI.orderInLayer = 10
MasterSkill_CareerSwitchUI.hideType = UIHideType.WaitDestroy
MasterSkill_CareerSwitchUI.hideFunc = UIHideFunc.MoveOutOfScreen
MasterSkill_CareerSwitchUI.escClose = UIEscClose.DontClose

function MasterSkill_CareerSwitchUI:InitControls()
  self.btn_closeBg = self:GetControl("btn_closeBg")
  self.panel_switch = self:GetControl("panel_switch")
  self.btn_ExpCloseSwitch = self:GetControl("panel_switch/bg_switch/btn_ExpCloseSwitch")
  self.btn_oncePrice = self:GetControl("panel_switch/bg_switch/go_ship/once/btn_oncePrice")
  self.btn_once = self:GetControl("panel_switch/bg_switch/go_ship/once/btn_once")
  self.btn_foreverPrice = self:GetControl("panel_switch/bg_switch/go_ship/forever/btn_foreverPrice")
  self.btn_forever = self:GetControl("panel_switch/bg_switch/go_ship/forever/btn_forever")
end

function MasterSkill_CareerSwitchUI:Init()
end

function MasterSkill_CareerSwitchUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function MasterSkill_CareerSwitchUI:InitUI()
  self.objTbl = {}
  table.insert(self.objTbl, self.btn_oncePrice)
  table.insert(self.objTbl, self.btn_foreverPrice)
  self.changeModelCtrTbl = {}
  self.changeModelTbl = {}
  self.labelCtrTbl = {}
  for i, v in pairs(self.objTbl) do
    table.insert(self.changeModelCtrTbl, ItemUtility.InitItemCell(v))
    table.insert(self.labelCtrTbl, UIControl(v.transform, "lab_num1"))
    table.insert(self.changeModelTbl, ItemCellData())
  end
end

function MasterSkill_CareerSwitchUI:RegistUIEvents()
  self.btn_closeBg:SetOnClick(self, self.btn_closeBgOnClick)
  self.btn_ExpCloseSwitch:SetOnClick(self, self.btn_ExpCloseSwitchOnClick)
  self.btn_once:SetOnClick(self, self.btn_onceOnClick)
  self.btn_forever:SetOnClick(self, self.btn_foreverOnClick)
end

function MasterSkill_CareerSwitchUI:btn_closeBgOnClick(control)
  UIManager.Hide(UIID.MasterSkill_CareerSwitchUI)
end

function MasterSkill_CareerSwitchUI:btn_ExpCloseSwitchOnClick(control)
  UIManager.Hide(UIID.MasterSkill_CareerSwitchUI)
end

function MasterSkill_CareerSwitchUI:btn_onceOnClick(control)
  if self.meetOnce then
    networkRequest.ReqEnableGrandMasterTalent(self.targetType, 1)
  else
    FloatingTipUtility.QuickMsg(ClientTable.cfg_Ui_wordManager:GetDaShiSwitchConsumNotMeetStr())
  end
end

function MasterSkill_CareerSwitchUI:btn_foreverOnClick(control)
  if self.meetForever then
    networkRequest.ReqEnableGrandMasterTalent(self.targetType, 2)
  else
    FloatingTipUtility.QuickMsg(ClientTable.cfg_Ui_wordManager:GetDaShiSwitchConsumNotMeetStr())
  end
end

function MasterSkill_CareerSwitchUI:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function MasterSkill_CareerSwitchUI:RegistEvents()
  self:RegistEvent(Event.NewSwitchMasterCarrerChanged, self.NewSwitchMasterCarrerChangedCallBack, self)
end

function MasterSkill_CareerSwitchUI:NewSwitchMasterCarrerChangedCallBack()
  UIManager.Hide(UIID.MasterSkill_CareerSwitchUI)
end

function MasterSkill_CareerSwitchUI:Refresh()
  if self.args == nil or self.args.type == nil then
    UIManager.Hide(UIID.MasterSkill_CareerSwitchUI)
    return
  end
  self:RefreshData()
  self:RefreshView()
end

function MasterSkill_CareerSwitchUI:RefreshData()
  self.targetType = self.args.type
  self.consumabelData = QuickFind.MasterDataMgr():GetSwitchConsum()
  self.count = table.count(self.consumabelData)
  self.meetOnce = false
  self.meetForever = false
  if self.count > 0 then
    local bagCount = BagInfoData.GetItemTotalCountByItemId(self.consumabelData[1].itemId)
    self.meetOnce = bagCount >= self.consumabelData[1].count
  end
  if self.count > 1 then
    local bagCount = BagInfoData.GetItemTotalCountByItemId(self.consumabelData[2].itemId)
    self.meetForever = bagCount >= self.consumabelData[2].count
  end
end

function MasterSkill_CareerSwitchUI:RefreshView()
  for i, v in pairs(self.changeModelTbl) do
    if v ~= nil and not (i > self.count) then
      local itemData = ItemUtility.GenerateItemData(self.consumabelData[i].itemId)
      v:RefreshData(itemData)
      ItemUtility.ShowItemCell(self.changeModelCtrTbl[i], v, self, true)
      self:RefeshLabelView(i)
    end
  end
end

function MasterSkill_CareerSwitchUI:RefeshLabelView(index)
  local numLabel = self.labelCtrTbl[index]
  local consumabel = self.consumabelData[index]
  if numLabel == nil then
    return
  end
  local bagCount = BagInfoData.GetItemTotalCountByItemId(consumabel.itemId)
  local numColor = bagCount >= consumabel.count and ItemQuality2ColorDic[5] or ItemQuality2ColorDic[27]
  numLabel:SetText(string.GetColorText(consumabel.count, numColor))
end

function MasterSkill_CareerSwitchUI:OnHide()
end

function MasterSkill_CareerSwitchUI:OnDestroy()
end
