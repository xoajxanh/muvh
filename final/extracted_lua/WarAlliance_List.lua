WarAlliance_List = class(BaseUI)
WarAlliance_List.layer = UILayer.Panel
WarAlliance_List.orderInLayer = 2
WarAlliance_List.hideType = UIHideType.Destroy
WarAlliance_List.hideFunc = UIHideFunc.MoveOutOfScreen
WarAlliance_List.escClose = UIEscClose.DontClose

function WarAlliance_List:InitControls()
  self.panel_left = self:GetControl("panel_left")
  self.btn_closeBg = self:GetControl("panel_left/btn_closeBg")
  self.bg_frame = self:GetControl("panel_left/bg_frame")
  self.CloseBtn = self:GetControl("panel_left/bg_frame/CloseBtn")
  self.WarAllianceList = self:GetControl("panel_left/WarAllianceList")
  self.Button_WarAllianceItem = self:GetControl("panel_left/WarAllianceList/WarAllianceListScr/bg_WarAlliancePanel/Viewport/Content/Button_WarAllianceItem")
  self.btn_fastregist = self:GetControl("panel_left/WarAllianceList/btn_fastregist")
end

function WarAlliance_List:OnPreLoad()
end

function WarAlliance_List:Init()
  self.SimpleInfo = {}
  self.listSelect = {}
end

function WarAlliance_List:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function WarAlliance_List:InitUI()
  self:InitContent()
end

function WarAlliance_List:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function WarAlliance_List:OnHide()
end

function WarAlliance_List:OnDestroy()
end

function WarAlliance_List:RegistUIEvents()
  self.btn_closeBg:SetOnClick(self, self.CloseBtnOnClick)
  self.CloseBtn:SetOnClick(self, self.CloseBtnOnClick)
  self.btn_fastregist:SetOnClick(self, self.btn_fastregistOnClick)
end

function WarAlliance_List:CloseBtnOnClick(control)
  UIManager.Hide(UIID.WarAlliance_List)
end

function WarAlliance_List:btn_fastregistOnClick()
  NetManager.Send(UnionMessage.ReqJoinUnion, {id = 0, join = true})
end

function WarAlliance_List:RegistEvents()
  self:RegistEvent(Event.WarAlliance_InitWarAllianceList, self.InitWarAllianceList, self)
  self:RegistEvent(Event.WarAlliance_applyJoinCallBack, self.WarAlliance_applyJoinCallBack, self)
end

function WarAlliance_List:Refresh()
  NetManager.Send(UnionMessage.ReqUnionList)
  self.btn_fastregist:SetActive(not WarAllianceData.IsHaveUnion)
end

local function Button_WarAllianceItemCreate(control)
  control.lab_name = UIControl(control.transform, "lab_name")
  control.lab_number = UIControl(control.transform, "lab_number")
  control.lab_level = UIControl(control.transform, "lab_level")
  control.applyBtn = UIControl(control.transform, "applyBtn")
  control.lab_isApply = UIControl(control.transform, "applyBtn/lab_isApply")
end

function WarAlliance_List:InitContent()
  self.Button_WarAllianceItemTemp = UIContainer(self.Button_WarAllianceItem, self, Button_WarAllianceItemCreate)
end

function WarAlliance_List:InitWarAllianceList()
  for k, v in pairs(self.listSelect) do
    v:SetActive(false)
  end
  local data = WarAllianceData.WarAllianceDataList
  self.btn_fastregist:SetActive(0 < #data and not WarAllianceData.IsHaveUnion)
  if 0 < #data then
    for i = 1, #data do
      local obj = self.Button_WarAllianceItemTemp:GetOrCreateItem(i)
      local UnionLevelItem = ClientTable.cfg_union_unionLevelManager:TryGetValue(data[i].level)
      obj.lab_name:SetText(data[i].name)
      obj.lab_number:SetText(string.format("%d/%d", data[i].count, UnionLevelItem.unionMax))
      obj.lab_level:SetText(data[i].level)
      obj.applyBtn:SetActive(not WarAllianceData.IsHaveUnion)
      obj.applyBtn:SetInteractable(true)
      if data[i].apply then
        obj.lab_isApply:SetText("\196\144\195\163 xin")
        obj.applyBtn:SetInteractable(false)
      else
        obj.lab_isApply:SetText(LocalizationUtility.GetContentByKey("shenqing"))
        obj.applyBtn:SetOnClick(self, function()
          self:applyBtnOnClick(data[i].id, obj)
        end)
      end
      obj:SetActive(true)
      obj:SetOnClick(self, function()
        self:Button_WarAllianceListOnClick(data[i].id, obj)
      end)
      table.insert(self.listSelect, obj)
    end
    local RandomNum = Mathf.Random(1, #data)
    self:Button_WarAllianceListOnClick(data[RandomNum].id, self.listSelect[RandomNum])
  else
    for k, v in pairs(self.listSelect) do
      v:SetActive(false)
    end
  end
end

function WarAlliance_List:WarAlliance_applyJoinCallBack(_, msg)
  local data = WarAllianceData.WarAllianceDataList
  if data then
    for i = 1, #data do
      if msg.id == data[i].id then
        self.listSelect[i].lab_isApply:SetText("\196\144\195\163 xin")
        self.listSelect[i].applyBtn:SetInteractable(false)
      end
    end
  end
end

function WarAlliance_List:applyBtnOnClick(id, obj)
  NetManager.Send(UnionMessage.ReqJoinUnion, {id = id, join = true})
end

function WarAlliance_List:Button_WarAllianceListOnClick(id, obj)
  NetManager.Send(UnionMessage.ReqUnionSimpleInfo, {id = id})
  self:SetButtonPitchOn(self.listSelect, obj)
end

function WarAlliance_List:SetButtonPitchOn(ObjTab, Control)
  for k, v in pairs(ObjTab) do
    if v == Control then
      v:GetChild("img_clickeffect"):SetActive(true)
    else
      v:GetChild("img_clickeffect"):SetActive(false)
    end
  end
end
