local Appear_Couture_CoutureItemTemplate = {}

function Appear_Couture_CoutureItemTemplate:Init(rootUI)
  self:InitControls(rootUI)
  self:InitContainer()
end

function Appear_Couture_CoutureItemTemplate:InitControls(rootUI)
  self.rootUI = rootUI
  self.nowControl = self:GetControl()
  self.objItem = self:GetControl("objItem")
  self.CoutureName = self:GetControl("CoutureName")
  self.allTime = self:GetControl("allTime")
  self.img_btn_choose = self:GetControl("img_btn_choose")
  self.select = self:GetControl("select")
  self.tog_select = self:GetControl("tog_select")
  self.unActive = self:GetControl("unActive")
  self.lab_strengthen = self:GetControl("lab_strengthen")
  self.go_modelData = ItemCellData()
end

function Appear_Couture_CoutureItemTemplate:InitContainer()
  self.nowControl:SetOnClick(self, self.nowOnClick)
  self.img_btn_choose:SetOnClick(self, self.img_btn_chooseOnClick)
  self.select:SetOnClick(self, self.selectOnClick)
end

function Appear_Couture_CoutureItemTemplate:Refresh(data, ui)
  if data == nil then
    return
  end
  self.data = data
  self.fashionId = data.fashionId
  self.CoutureName:SetText(data.ItemName)
  self.allTime:SetActive(data.overtime ~= 0 and data.overtime ~= nil)
  self.lab_strengthen:SetActive(not data.isNeedActive)
  self.lab_strengthen:SetText(data.nowTable ~= nil and "+" .. data.nowTable.level or "")
  self.img_btn_choose:SetActive(data.crulUse)
  self.select:SetActive(not data.isNeedActive)
  self.unActive:SetActive(data.isNeedActive)
  if data.overtime ~= 0 and data.overtime ~= nil then
    local surplusTime = Mathf.Floor(data.overtime) - Time.GetServerSecondTime()
    local showTime = self:ShowDayHourMin(surplusTime)
    self.allTime:SetText(showTime)
  end
  local itemData = ItemUtility.GenerateItemData(data.itemId)
  self.go_modelData:RefreshData(itemData)
  ItemUtility.ShowItemCell(self.objItem, self.go_modelData, ui, false)
end

function Appear_Couture_CoutureItemTemplate:RefreshSelectEffect(fashionId)
  self.tog_select:SetActive(fashionId == self.fashionId)
end

function Appear_Couture_CoutureItemTemplate:nowOnClick()
  EventManager.Dispatch(Event.Appear_CoutureSelectChange, self.data)
end

function Appear_Couture_CoutureItemTemplate:img_btn_chooseOnClick()
  self:UseCouture(true)
end

function Appear_Couture_CoutureItemTemplate:selectOnClick()
  self:UseCouture(false)
end

function Appear_Couture_CoutureItemTemplate:UseCouture(isUninstall)
  if gameMgr:GetAvatarManager():GetMainPlayer():GetAppear_CoutureManager().frequencyTime > 0 then
    FloatingTipUtility.QuickMsg("Thao t\195\161c qu\195\161 th\198\176\225\187\157ng xuy\195\170n")
    return
  end
  gameMgr:GetAvatarManager():GetMainPlayer():GetAppear_CoutureManager().frequencyTime = 0.8
  EventManager.Dispatch(Event.Appear_OperationFashion, self.data, isUninstall)
end

function Appear_Couture_CoutureItemTemplate:ShowDayHourMin(sec)
  local timeStr = ""
  local day = Mathf.Floor(sec / ETimeSec.day)
  local hour = Mathf.Floor(sec % ETimeSec.day / ETimeSec.hour)
  local min = Mathf.Ceil(sec % ETimeSec.hour / ETimeSec.min)
  if min == 60 then
    min = 59
  end
  timeStr = string.format(LocalizationUtility.GetContentByKey("Time_kfhd"), day, hour, min)
  return timeStr
end

return Appear_Couture_CoutureItemTemplate
