Team3V3CreateUI = class(BaseUI)
Team3V3CreateUI.layer = UILayer.Panel
Team3V3CreateUI.orderInLayer = 5
Team3V3CreateUI.hideType = UIHideType.WaitDestroy
Team3V3CreateUI.hideFunc = UIHideFunc.MoveOutOfScreen
Team3V3CreateUI.escClose = UIEscClose.DontClose

function Team3V3CreateUI:InitControls()
  self.Bg_Close = self:GetControl("Bg_Close")
  self.Panel_Tip = self:GetControl("Panel_Tip")
  self.Image_TipBg = self:GetControl("Panel_Tip/Image_TipBg")
  self.teamName_txt = self:GetControl("Panel_Tip/Image_TipBg/name/teamName_txt")
  self.lab_count = self:GetControl("Panel_Tip/Image_TipBg/name/lab_count")
  self.Text_TipTitle = self:GetControl("Panel_Tip/Image_TipBg/Text_TipTitle")
  self.btn_close = self:GetControl("Panel_Tip/Image_TipBg/btn_close")
  self.Button_Cancel = self:GetControl("Panel_Tip/Image_TipBg/ButtonTriggerView/Button_Cancel")
  self.Text_Cancel = self:GetControl("Panel_Tip/Image_TipBg/ButtonTriggerView/Button_Cancel/Text_Cancel")
  self.Button_OK = self:GetControl("Panel_Tip/Image_TipBg/ButtonTriggerView/Button_OK")
  self.diaNum_txt = self:GetControl("Panel_Tip/Image_TipBg/ButtonTriggerView/Button_OK/diaNum_txt")
  self.iconImg = self:GetControl("Panel_Tip/Image_TipBg/ButtonTriggerView/Button_OK/diaNum_txt/Image")
  self.text = self:GetControl("Panel_Tip/Image_TipBg/ButtonTriggerView/Button_OK/text")
  self.lab_InputField = self:GetControl("Panel_Tip/Image_TipBg/name/lab_InputField")
end

function Team3V3CreateUI:Init()
end

function Team3V3CreateUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Team3V3CreateUI:InitUI()
end

function Team3V3CreateUI:RegistUIEvents()
  self.Bg_Close:SetOnClick(self, self.btn_closeOnClick)
  self.btn_close:SetOnClick(self, self.btn_closeOnClick)
  self.Button_Cancel:SetOnClick(self, self.btn_closeOnClick)
  self.Button_OK:SetOnClick(self, self.Button_OKOnClick)
  self.lab_InputField:SetOnEndEdit(self, self.InputFieldEnd)
end

function Team3V3CreateUI:btn_closeOnClick(control)
  UIManager.Hide(UIID.Team3V3CreateUI)
end

function Team3V3CreateUI:InputFieldEnd(control)
  self.TeamName = self.lab_InputField:GetInputText()
end

function Team3V3CreateUI:Button_OKOnClick(control)
  if string.isNullOrEmpty(self.TeamName) then
    FloatingTipUtility.QuickMsg("Vui l\195\178ng nh\225\186\173p T\195\170n Chi\225\186\191n \196\144\225\187\153i")
    return
  end
  local bagCount = BagInfoData.GetItemTotalCountByItemId(tonumber(self.itemId))
  if bagCount < tonumber(self.itemCount) then
    FloatingTipUtility.QuickMsg("\196\144\225\186\161o c\225\187\165 kh\195\180ng \196\145\225\187\167")
    return
  else
    networkRequest.ReqCreateMatchTeam3V3(self.TeamName)
    UIManager.Hide(UIID.Team3V3CreateUI)
  end
end

function Team3V3CreateUI:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function Team3V3CreateUI:RegistEvents()
end

function Team3V3CreateUI:Refresh()
  self.TeamName = ""
  local activity = ClientTable.cfg_Activity_globalManager:GetEffect(500573)
  local info = string.split(activity, "#")
  self.itemId = info[1]
  self.itemCount = info[2]
  local bagCount = BagInfoData.GetItemTotalCountByItemId(tonumber(self.itemId))
  local itemIcon = ClientTable.cfg_Item_itemManager:TryGetValue(tonumber(self.itemId)).icon
  self:SetSprite("Atlas_Common", itemIcon, self.iconImg)
  self.diaNum_txt:SetText(string.GetColorText(self.itemCount, bagCount >= tonumber(self.itemCount) and ItemQuality2ColorDic[EItemColorEnum.white] or ItemQuality2ColorDic[EItemColorEnum.red]))
  self.lab_InputField:SetInputText("")
end

function Team3V3CreateUI:OnHide()
end

function Team3V3CreateUI:OnDestroy()
end
