Activity_WarAllianceRedBagUI = class(BaseUI)
Activity_WarAllianceRedBagUI.layer = UILayer.Panel
Activity_WarAllianceRedBagUI.orderInLayer = 0
Activity_WarAllianceRedBagUI.hideType = UIHideType.WaitDestroy
Activity_WarAllianceRedBagUI.hideFunc = UIHideFunc.MoveOutOfScreen
Activity_WarAllianceRedBagUI.escClose = UIEscClose.DontClose

function Activity_WarAllianceRedBagUI:InitControls()
  self.btn_closeBg = self:GetControl("btn_closeBg")
  self.btn_close = self:GetControl("go_WarAllianceRedBag/btn_close")
  self.RedBagPanel = self:GetControl("go_WarAllianceRedBag/RedBagPanel")
  self.img_RedBag_time = self:GetControl("go_WarAllianceRedBag/RedBagPanel/img_RedBag_time")
  self.lab_time = self:GetControl("go_WarAllianceRedBag/RedBagPanel/img_RedBag_time/lab_time")
  self.sw_RedBag = self:GetControl("go_WarAllianceRedBag/RedBagPanel/sw_RedBag")
  self.Content = self:GetControl("go_WarAllianceRedBag/RedBagPanel/sw_RedBag/Viewport/Content")
  self.Item_RedBag = self:GetControl("go_WarAllianceRedBag/RedBagPanel/sw_RedBag/Viewport/Content/Item_RedBag")
  self.lab_UseName = self:GetControl("go_WarAllianceRedBag/RedBagPanel/sw_RedBag/Viewport/Content/Item_RedBag/OffRedBag/lab_UseName")
  self.lab_text = self:GetControl("go_WarAllianceRedBag/RedBagPanel/sw_RedBag/Viewport/Content/Item_RedBag/OffRedBag/lab_text")
  self.lab_moneyNum = self:GetControl("go_WarAllianceRedBag/RedBagPanel/sw_RedBag/Viewport/Content/Item_RedBag/OnRedBag/lab_moneyNum")
  self.btn_Thanks = self:GetControl("go_WarAllianceRedBag/RedBagPanel/sw_RedBag/Viewport/Content/Item_RedBag/OnRedBag/btn_Thanks")
  self.lab_name = self:GetControl("go_WarAllianceRedBag/RedBagPanel/sw_RedBag/Viewport/Content/Item_RedBag/OnRedBag/sw_RedBag_getName/Viewport/Content/lab_name")
  self.desc = self:GetControl("go_WarAllianceRedBag/RedBagPanel/Desc/desc")
  self.btn_sendRedBag = self:GetControl("go_WarAllianceRedBag/RedBagPanel/btn_sendRedBag")
  self.btn_leftArrow = self:GetControl("go_WarAllianceRedBag/RedBagPanel/btn_leftArrow")
  self.btn_rightArrow = self:GetControl("go_WarAllianceRedBag/RedBagPanel/btn_rightArrow")
  self.lab_cost = self:GetControl("go_WarAllianceRedBag/RedBagPanel/lab_cost")
  self.lab_red = self:GetControl("go_WarAllianceRedBag/RedBagPanel/lab_red")
  self.consumeItem = self:GetControl("go_WarAllianceRedBag/RedBagPanel/lab_red/consumeItem")
end

function Activity_WarAllianceRedBagUI:Init()
end

function Activity_WarAllianceRedBagUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Activity_WarAllianceRedBagUI:InitUI()
  self.WarAllianceRedEnvelopeTemp = UIUtility.BindUIContainerTemp(self.Item_RedBag, LuaComponentTemplates.WarAllianceRedEnvelopeTemplate, self)
end

function Activity_WarAllianceRedBagUI:RegistUIEvents()
  self.btn_closeBg:SetOnClick(self, self.btn_closeBgOnClick)
  self.btn_close:SetOnClick(self, self.btn_closeOnClick)
  self.btn_sendRedBag:SetOnClick(self, self.btn_sendRedBagOnClick)
end

function Activity_WarAllianceRedBagUI:btn_closeBgOnClick(control)
  UIManager.Hide(UIID.Activity_WarAllianceRedBagUI)
end

function Activity_WarAllianceRedBagUI:btn_closeOnClick(control)
  UIManager.Hide(UIID.Activity_WarAllianceRedBagUI)
end

function Activity_WarAllianceRedBagUI:btn_sendRedBagOnClick(control)
  networkRequest.ReqSendRedPacket(500, 5)
end

function Activity_WarAllianceRedBagUI:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function Activity_WarAllianceRedBagUI:RegistEvents()
  self:RegistEvent(Event.WarAllianceRedEnvelopeChange, self.WarAllianceRedEnvelopeChange, self)
end

function Activity_WarAllianceRedBagUI:Refresh()
  gameMgr:GetAvatarManager():GetMainPlayer():GetActivityDataMgr():GetWarAllianceRedEnvelopeManager():Init()
  self.RedEnvelopeCount = 0
  self.sw_RedBag:SetNormalizedPosition(0, 0)
  networkRequest.ReqUnionRedPacket()
  self:RefreshTime()
  self:RefreshCost()
end

function Activity_WarAllianceRedBagUI:RefreshTime()
  local cfgTab = ClientTable.cfg_Commerce_overviewManager:TryGetValue(30021)
  local startTime, endTime = TimeUtility.CalcTimeStamp(cfgTab.deadline)
  local remainderTime = (endTime - Time.GetServerTime()) / 1000
  self:ShowTime(remainderTime)
end

function Activity_WarAllianceRedBagUI:ShowTime(remainderTime)
  if self.Timer then
    Timer.Stop(self.Timer)
  end
  self.lab_time:SetText(string.GetColorText("", ItemQuality2ColorDic[5]))
  if 0 < remainderTime then
    local timeStr = TimeUtility.ShowDayTime(remainderTime)
    self.lab_time:SetText(string.GetColorText(timeStr, ItemQuality2ColorDic[5]))
    
    local function UpdateTimer()
      remainderTime = remainderTime - 1
      local timeStr = TimeUtility.ShowDayTime(remainderTime)
      if remainderTime <= 0 then
        if self.Timer then
          Timer.Stop(self.Timer)
          self.Timer = nil
          self.lab_time:SetText(string.GetColorText("", ItemQuality2ColorDic[5]))
        end
      else
        self.lab_time:SetText(string.GetColorText(tostring(timeStr), ItemQuality2ColorDic[5]))
      end
    end
    
    self.Timer = Timer.StartLoop(1, remainderTime, UpdateTimer)
  end
end

function Activity_WarAllianceRedBagUI:RefreshCost()
  local redBagCount = BagInfoData.GetItemTotalCountByItemId(3005001)
  self.lab_cost:SetActive(false)
  self.lab_red:SetActive(false)
  if 1 <= redBagCount then
    local itemData = ItemUtility.GenerateItemData(3005001)
    self.consumeItem.itemCellData = self.consumeItem.itemCellData or ItemCellData()
    self.consumeItem.itemCellData:RefreshData(itemData)
    ItemUtility.ShowItemCell(self.consumeItem, self.consumeItem.itemCellData, self, true)
    self.lab_red:SetActive(true)
  else
    local effect = ClientTable.cfg_Commerce_globalManager:TryGetValue(315001).effect
    if not string.isNullOrEmpty(effect) then
      local count = string.split(effect, "#")[2]
      self.lab_cost:SetText(string.format("Ti\195\170u hao %d KC", tonumber(count)))
    end
    self.lab_cost:SetActive(true)
  end
end

function Activity_WarAllianceRedBagUI:WarAllianceRedEnvelopeChange()
  local redEnvelopeData = gameMgr:GetAvatarManager():GetMainPlayer():GetActivityDataMgr():GetWarAllianceRedEnvelopeManager():GetRedEnvelopeData()
  self.RedEnvelopeCount = table.count(redEnvelopeData)
  self.WarAllianceRedEnvelopeTemp:SetData(redEnvelopeData)
  self:RefreshCost()
end

function Activity_WarAllianceRedBagUI:Update()
  local x, y = self.sw_RedBag:GetNormalizedPosition()
  if self.RedEnvelopeCount > 3 then
    if x <= 1 / self.RedEnvelopeCount then
      self.btn_leftArrow:SetActive(false)
      self.btn_rightArrow:SetActive(true)
    elseif x >= 1 - 1 / self.RedEnvelopeCount then
      self.btn_leftArrow:SetActive(true)
      self.btn_rightArrow:SetActive(false)
    else
      self.btn_leftArrow:SetActive(true)
      self.btn_rightArrow:SetActive(true)
    end
  else
    self.btn_leftArrow:SetActive(false)
    self.btn_rightArrow:SetActive(false)
  end
end

function Activity_WarAllianceRedBagUI:OnHide()
end

function Activity_WarAllianceRedBagUI:OnDestroy()
end
