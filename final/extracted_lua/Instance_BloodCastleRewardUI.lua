Instance_BloodCastleRewardUI = class(BaseUI)
Instance_BloodCastleRewardUI.layer = UILayer.Panel
Instance_BloodCastleRewardUI.orderInLayer = 5
Instance_BloodCastleRewardUI.hideType = UIHideType.WaitDestroy
Instance_BloodCastleRewardUI.hideFunc = UIHideFunc.MoveOutOfScreen
Instance_BloodCastleRewardUI.escClose = UIEscClose.DontClose

function Instance_BloodCastleRewardUI:InitControls()
  self.btn_closeBg = self:GetControl("btn_closeBg")
  self.lab_tranName = self:GetControl("description/lab_tranName")
  self.grid = self:GetControl("Middel/lab_rewards/grid")
  self.btn_Item = self:GetControl("Middel/lab_rewards/grid/btn_Item")
  self.btn_enter = self:GetControl("Middel/btn_enter")
end

function Instance_BloodCastleRewardUI:OnPreLoad()
end

function Instance_BloodCastleRewardUI:Init()
end

function Instance_BloodCastleRewardUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Instance_BloodCastleRewardUI:InitUI()
  self:InitContent()
end

function Instance_BloodCastleRewardUI:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function Instance_BloodCastleRewardUI:OnHide()
end

function Instance_BloodCastleRewardUI:OnDestroy()
end

function Instance_BloodCastleRewardUI:RegistUIEvents()
  self.btn_Item:SetOnClick(self, self.btn_ItemOnClick)
  self.btn_enter:SetOnClick(self, self.btn_enterOnClick)
end

function Instance_BloodCastleRewardUI:InitContent()
  self.btn_ItemTemp = UIContainer(self.btn_Item)
end

function Instance_BloodCastleRewardUI:btn_closeBgOnClick(control)
  UIManager.Hide(UIID.Instance_BloodCastleRewardUI)
end

function Instance_BloodCastleRewardUI:btn_ItemOnClick(control)
end

function Instance_BloodCastleRewardUI:btn_enterOnClick(control)
  NetManager.Send(MapMessage.ReqInstanceReward)
  self:btn_closeBgOnClick()
end

function Instance_BloodCastleRewardUI:RegistEvents()
end

function Instance_BloodCastleRewardUI:Refresh()
  self.meData = ViewData.meData
  self:SetPanel()
end

function Instance_BloodCastleRewardUI:SetPanel()
  local ContentData = TranScriptData.GetContentData()
  local AwardTab = string.split(ContentData.dropItem, "&")
  self.lab_tranName:SetText(ContentData.name)
  for i = 1, table.count(AwardTab) do
    local Award = string.split(AwardTab[i], "#")
    local obj = self.btn_ItemTemp:GetOrCreateItem(i)
    local AwardData = ItemUtility.GenerateItemData(tonumber(Award[1]))
    if ContentData.type == TranScriptData.TranScriptSubType.DemonPlaza then
      local ratio = TranScriptData.GetDemonPlazaRatio()
      AwardData.count = math.floor(ratio * TranScriptData.DemonPlazaIntegral)
      TranScriptData.DemonPlazaIntegral = 0
      logError(AwardData.count)
    else
      AwardData.count = Award[2]
    end
    ItemUtility.ShowItem(self, obj, AwardData, true)
  end
end
