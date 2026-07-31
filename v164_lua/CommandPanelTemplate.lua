local CommandPanelTemplate = {}

function CommandPanelTemplate:Init(data)
  self.goCallBack = data.goCallBack
  self.curTogIndex = data.curTogIndex
  self.relevancyBtn = data.relevancyBtn
  self:InitControls()
  self:BindUIEvent()
end

function CommandPanelTemplate:InitControls()
  self.levelExecuteBtn = self:GetControl("level/executeBtn")
  self.levelInputField = self:GetControl("level/InputField")
  self.year = self:GetControl("adjustTime/year")
  self.month = self:GetControl("adjustTime/month")
  self.day = self:GetControl("adjustTime/day")
  self.hour = self:GetControl("adjustTime/hour")
  self.minute = self:GetControl("adjustTime/minute")
  self.second = self:GetControl("adjustTime/second")
  self.executeOpenBtn = self:GetControl("adjustTime/executeOpenBtn")
  self.executeSystemBtn = self:GetControl("adjustTime/executeSystemBtn")
  self.inquireOpenTimeBtn = self:GetControl("inquireOpenTime/executeBtn")
  self.inquireSystemTimeBtn = self:GetControl("InquireSystemTime/executeBtn")
  self.emptyBagBtn = self:GetControl("emptyBag/executeBtn")
  self.inputFieldID = self:GetControl("createGoods/InputFieldID")
  self.inputFieldCount = self:GetControl("createGoods/InputFieldCount")
  self.createGoodsBtn = self:GetControl("createGoods/executeBtn")
  self.runBtn = self:GetControl("run/executeBtn")
  self.attributeDropdown = self:GetControl("adjustAttribute/Dropdown")
  self.attributeInputField = self:GetControl("adjustAttribute/InputField")
  self.addAttributeBtn = self:GetControl("adjustAttribute/addBtn")
  self.reduceAttributeBtn = self:GetControl("adjustAttribute/reduceBtn")
  self.btn_OpenWarReport = self:GetControl("btn_OpenWarReport/executeBtn")
  self.btn_CloseWarReport = self:GetControl("btn_CloseWarReport/executeBtn")
  self.gmInputField = self:GetControl("gm/InputField")
  self.btn_GM = self:GetControl("gm/executeBtn")
end

function CommandPanelTemplate:BindUIEvent()
  self.relevancyBtn:SetOnClick(self, self.ClickGoCallBack)
  self.levelExecuteBtn:SetOnClick(self, self.levelExecuteBtnOnClick)
  self.executeOpenBtn:SetOnClick(self, self.executeOpenBtnOnClick)
  self.executeSystemBtn:SetOnClick(self, self.executeSystemBtnOnClick)
  self.inquireOpenTimeBtn:SetOnClick(self, self.inquireOpenTimeBtnOnClick)
  self.inquireSystemTimeBtn:SetOnClick(self, self.inquireSystemTimeBtnOnClick)
  self.emptyBagBtn:SetOnClick(self, self.emptyBagBtnOnClick)
  self.runBtn:SetOnClick(self, self.runBtnOnClick)
  self.createGoodsBtn:SetOnClick(self, self.createGoodsBtnOnClick)
  self.addAttributeBtn:SetOnClick(self, self.addAttributeBtnOnClick)
  self.reduceAttributeBtn:SetOnClick(self, self.reduceAttributeBtnOnClick)
  self.btn_OpenWarReport:SetOnClick(self, self.btn_OpenWarReportOnClick)
  self.btn_CloseWarReport:SetOnClick(self, self.btn_CloseWarReportOnClick)
  self.btn_GM:SetOnClick(self, self.btn_GMOnClick)
end

function CommandPanelTemplate:ClickGoCallBack()
  if self.goCallBack then
    self.goCallBack(self.curTogIndex)
  end
end

function CommandPanelTemplate:levelExecuteBtnOnClick()
  local inputNumber = self.levelInputField:GetInputText()
  if not string.isNullOrEmpty(inputNumber) then
    NetManager.Send(ChatMessage.ReqGM, {
      info = string.format("@16 %s", inputNumber)
    })
  end
end

function CommandPanelTemplate:executeOpenBtnOnClick()
  local year = self.year:GetInputText()
  local month = self.month:GetInputText()
  local day = self.day:GetInputText()
  if not string.isNullOrEmpty(year) and not string.isNullOrEmpty(month) and not string.isNullOrEmpty(day) then
    local setOpenTime = string.format("@Ch\225\187\137nh th\225\187\157i gian M\225\187\159 SV %s- %s- %s", year, month, day)
    NetManager.Send(ChatMessage.ReqGM, {info = setOpenTime})
  end
end

function CommandPanelTemplate:executeSystemBtnOnClick()
  local year = self.year:GetInputText()
  local month = self.month:GetInputText()
  local day = self.day:GetInputText()
  local hour = self.hour:GetInputText()
  local minute = self.minute:GetInputText()
  local second = self.second:GetInputText()
  if not string.isNullOrEmpty(year) and not string.isNullOrEmpty(month) and not string.isNullOrEmpty(day) and not string.isNullOrEmpty(hour) and not string.isNullOrEmpty(minute) and not string.isNullOrEmpty(second) then
    local SystemTime = string.format("@Ch\225\187\137nh th\225\187\157i gian SV %s- %s- %s %s:%s:%s", year, month, day, hour, minute, second)
    NetManager.Send(ChatMessage.ReqGM, {info = SystemTime})
  end
end

function CommandPanelTemplate:inquireOpenTimeBtnOnClick()
  NetManager.Send(ChatMessage.ReqGM, {
    info = "@Truy v\225\186\165n th\225\187\157i gian M\225\187\159 SV"
  })
end

function CommandPanelTemplate:inquireSystemTimeBtnOnClick()
  NetManager.Send(ChatMessage.ReqGM, {
    info = "@L\225\186\165y th\225\187\157i gian SV"
  })
end

function CommandPanelTemplate:emptyBagBtnOnClick()
  NetManager.Send(ChatMessage.ReqGM, {
    info = "@D\225\187\141n T\195\186i"
  })
end

function CommandPanelTemplate:runBtnOnClick()
  NetManager.Send(ChatMessage.ReqGM, {info = "@212 7"})
end

function CommandPanelTemplate:createGoodsBtnOnClick()
  local id = self.inputFieldID:GetInputText()
  local count = self.inputFieldCount:GetInputText()
  if not string.isNullOrEmpty(id) and not string.isNullOrEmpty(count) then
    local goodsMessage = string.format("@3 %s %s", id, count)
    NetManager.Send(ChatMessage.ReqGM, {info = goodsMessage})
  end
end

function CommandPanelTemplate:addAttributeBtnOnClick()
  local changeAttribute = self.attributeInputField:GetInputText()
  local attributeIndex = self.attributeDropdown:GetSelectValue()
  if not string.isNullOrEmpty(changeAttribute) then
    local attribute = string.format("@4 %s %s 0", attributeIndex + 1, changeAttribute)
    NetManager.Send(ChatMessage.ReqGM, {info = attribute})
  end
end

function CommandPanelTemplate:reduceAttributeBtnOnClick()
  local changeAttribute = self.attributeInputField:GetInputText()
  local attributeIndex = self.attributeDropdown:GetSelectValue()
  if not string.isNullOrEmpty(changeAttribute) then
    local attribute = string.format("@4 %s %s 1", attributeIndex + 1, changeAttribute)
    NetManager.Send(ChatMessage.ReqGM, {info = attribute})
  end
end

function CommandPanelTemplate:btn_OpenWarReportOnClick()
  NetManager.Send(ChatMessage.ReqGM, {
    info = "@Th\195\180ng tin Chi\225\186\191n B\195\161o 1"
  })
end

function CommandPanelTemplate:btn_CloseWarReportOnClick()
  NetManager.Send(ChatMessage.ReqGM, {
    info = "@Th\195\180ng tin Chi\225\186\191n B\195\161o 0"
  })
end

function CommandPanelTemplate:btn_GMOnClick()
  local gmMessage = self.gmInputField:GetInputText()
  if not string.isNullOrEmpty(gmMessage) then
    NetManager.Send(ChatMessage.ReqGM, {info = gmMessage})
  end
end

function CommandPanelTemplate:Refresh(data, ui)
end

return CommandPanelTemplate
