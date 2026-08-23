Instance_BloodCastleSecondUI = class(BaseUI)
Instance_BloodCastleSecondUI.layer = UILayer.Panel
Instance_BloodCastleSecondUI.orderInLayer = 5
Instance_BloodCastleSecondUI.hideType = UIHideType.WaitDestroy
Instance_BloodCastleSecondUI.hideFunc = UIHideFunc.MoveOutOfScreen
Instance_BloodCastleSecondUI.escClose = UIEscClose.DontClose

function Instance_BloodCastleSecondUI:InitControls()
  self.btn_close = self:GetControl("btn_close")
  self.btn_closeBg = self:GetControl("btn_closeBg")
  self.lab_instance = self:GetControl("lab_instance")
  self.lab_description = self:GetControl("lab_description")
  self.lab_count1 = self:GetControl("Middel/lab_leftcount/lab_count1")
  self.btn_get1 = self:GetControl("Middel/lab_leftcount/btn_get1")
  self.img_itemicon = self:GetControl("Middel/lab_requirements/img_itemicon")
  self.btn_get2 = self:GetControl("Middel/lab_requirements/btn_get2")
  self.lab_already = self:GetControl("Middel/lab_requirements/lab_already")
  self.btn_enter = self:GetControl("Middel/btn_enter")
  self.lab_enter = self:GetControl("Middel/btn_enter/lab_enter")
  self.btn_cancle = self:GetControl("Middel/btn_cancle")
  self.lab_cancel = self:GetControl("Middel/btn_cancle/lab_cancle")
end

function Instance_BloodCastleSecondUI:OnPreLoad()
end

function Instance_BloodCastleSecondUI:Init()
  self.EnterTranContentData = {}
end

function Instance_BloodCastleSecondUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Instance_BloodCastleSecondUI:InitUI()
  self:InitContent()
end

function Instance_BloodCastleSecondUI:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function Instance_BloodCastleSecondUI:OnHide()
end

function Instance_BloodCastleSecondUI:OnDestroy()
end

function Instance_BloodCastleSecondUI:RegistUIEvents()
  self.btn_close:SetOnClick(self, self.btn_closeOnClick)
  self.btn_get1:SetOnClick(self, self.btn_get1OnClick)
  self.img_itemicon:SetOnClick(self, self.img_itemiconOnClick)
  self.btn_get2:SetOnClick(self, self.btn_get2OnClick)
  self.btn_enter:SetOnClick(self, self.btn_enterOnClick)
  self.btn_cancle:SetOnClick(self, self.btn_cancleOnClick)
end

function Instance_BloodCastleSecondUI:btn_closeOnClick(control)
  UIManager.Hide(UIID.Instance_BloodCastleSecondUI)
end

function Instance_BloodCastleSecondUI:btn_get1OnClick(control)
end

function Instance_BloodCastleSecondUI:img_itemiconOnClick(control)
end

function Instance_BloodCastleSecondUI:btn_get2OnClick(control)
  UIManager.Show(UIID.Item_CombineUI, {npcConfigID = 1004005})
  UIManager.Hide(UIID.Instance_BloodCastleSecondUI)
end

local instanceCount = 0

local function InterfaceInforCheck()
  if not (0 < instanceCount) then
    TipUtility.ShowPrompt("tishi", "InstanceCountInsufficient")
    return false
  end
  if 0 >= BagInfoData.GetItemCountByItemConfigId(8000050) then
    TipUtility.ShowPrompt("tishi", "cailiaobuzu")
    return false
  end
  return true
end

function Instance_BloodCastleSecondUI:btn_enterOnClick(control)
  if not InterfaceInforCheck() then
    return
  end
  if self.args and self.args.enterOnClick then
    self.args.enterOnClick(self.enterConditionData.id)
  else
    local mapData = {
      mapId = self.enterConditionData.id
    }
    EventManager.Dispatch(Event.Map_ChangeMap, mapData)
  end
  UIManager.Hide(UIID.Instance_BloodCastleSecondUI)
end

function Instance_BloodCastleSecondUI:btn_cancleOnClick(control)
  if self.args and self.args.cancelOnClick then
    self.args.cancelOnClick()
    return
  end
  self:btn_closeOnClick()
end

function Instance_BloodCastleSecondUI:InitContent()
end

function Instance_BloodCastleSecondUI:RegistEvents()
end

function Instance_BloodCastleSecondUI:Refresh()
  local instanceType = self:InitConditionData()
  self:SetPanel()
  if self.args and self.args.title and self.args.invitationType and self.args.labEnter and self.args.labCancel then
    local contentText = ClientTable.cfg_Ui_wordManager:TryGetValue("MatchInviteContent", "id")
    self.lab_instance:SetText(self.args.title)
    self.lab_description:SetText(string.format(contentText.content, self.args.inviterName, string.format("Lv.%s(%s-%s)", self.LevelAndNumber[1], self.LevelAndNumber[2], self.LevelAndNumber[3]), self.enterConditionData.name, self.args.invitationType))
    self.lab_enter:SetText(self.args.labEnter)
    self.lab_cancel:SetText(self.args.labCancel)
  end
  if instanceType == 2204 then
    local count = RefreshData.GetInstanceCount(4020201)
    self.lab_count1:SetText(count)
    instanceCount = count
  end
end

function Instance_BloodCastleSecondUI:InitConditionData()
  if UIManager.IsVisible(UIID.ChatUI) then
    UIManager.Hide(UIID.ChatUI)
  end
  local tranId = TranScriptData.tranScriptInviteData.instanceId or TranScriptData.tranScriptInviteData[2]
  local transTable = ClientTable.cfg_Map_instanceManager:TryGetValue(tonumber(tranId), "mapId")
  for k, v in pairs(TranScriptData.TranScriptGlobal) do
    if k == transTable.type then
      self.EnterTranContentData.Enum = k
      self.EnterTranContentData.condition = v.condition
      self.EnterTranContentData.LevelAndNumber = v.LevelAndNumber
    end
  end
  self.enterConditionData, self.LevelAndNumber = TranScriptData.GetEnterConditionData(self.EnterTranContentData.Enum, self.EnterTranContentData.condition, self.EnterTranContentData.LevelAndNumber)
  return transTable.type
end

function Instance_BloodCastleSecondUI:SetPanel()
  local item = string.split(self.enterConditionData.cost, "#")
  local itemData = ItemUtility.GenerateItemData(tonumber(item[1]))
  local bagCount = BagInfoData.GetItemCountByItemConfigId(tonumber(item[1]))
  itemData.count = tonumber(item[2])
  ItemUtility.ShowItem(self, self.img_itemicon, itemData, true)
  self.lab_instance:SetText(self.enterConditionData.name)
  local Content = LocalizationUtility.GetContentByKey("BloodCastleSecondDefaultContent")
  self.lab_description:SetText(string.format(Content, self.enterConditionData.name))
  self.lab_already:SetText(string.format("%d/", bagCount))
  if 0 < bagCount then
    self.btn_get2:SetActive(false)
  else
    self.btn_get2:SetActive(true)
  end
  local count = RefreshData.GetInstanceCount(3020401)
  self.lab_count1:SetText(count)
  instanceCount = count
end
