local SevenDayGiftDayGiftTemplate = {}

function SevenDayGiftDayGiftTemplate:Init(rootUI)
  self:InitControls(rootUI)
end

function SevenDayGiftDayGiftTemplate:InitControls(rootUI)
  self.rootUI = rootUI
  self.nowControl = self:GetControl()
  self.btn_Item = self:GetControl("btn_Item")
  self.img_choose = self:GetControl("img_choose")
  self.missionDes = self:GetControl("missionDes")
  self.lab_Day = self:GetControl("lab_Day")
  self.rewardGet = self:GetControl("rewardGet")
end

function SevenDayGiftDayGiftTemplate:InitContainer()
end

function SevenDayGiftDayGiftTemplate:InitData()
end

function SevenDayGiftDayGiftTemplate:BindUIEvent()
end

function SevenDayGiftDayGiftTemplate:btn_ItemOnClick()
  NetManager.Send(CommerceMessage.ReqSevenDaysGiftsReward, {
    configId = self.data.id
  })
end

function SevenDayGiftDayGiftTemplate:Refresh(data, ui)
  if data == nil then
    self:HideCtr()
    return
  end
  self.data = data
  self.nowControl:SetActive(true)
  self.lab_Day:SetText(string.format("Ng\195\160y %s ", string.NumberSwitchChinese(tostring(data.day))))
  ItemUtility.ShowItemCellByItemId(data.rewardId, data.rewardCount, self.btn_Item, self.rootUI, true)
  if data.state == GuardRewardStateEnum.CanGet then
    self.btn_Item:SetOnClick(self, self.btn_ItemOnClick)
  end
  self.rewardGet:SetActive(data.state == GuardRewardStateEnum.Got)
  self.img_choose:SetActive(data.state == GuardRewardStateEnum.CanGet)
  if data.unlockDay and data.unlockDay > 0 then
    self.missionDes:SetText(string.GetColorText(string.format("%d ng\195\160y s\225\186\189 m\225\187\159 kh\195\179a ", data.unlockDay), ItemQuality2ColorDic[11]))
  else
    local count = data.count
    local targetCount = ClientTable.cfg_Task_goalManager:TryGetValue(data.goalId).goalCount
    if count < targetCount then
      self.missionDes:SetText(string.GetColorText(string.format(data.taskDes, data.count), ItemQuality2ColorDic[12]))
    else
      self.missionDes:SetText(string.GetColorText(string.format(data.taskDes, data.count), ItemQuality2ColorDic[11]))
    end
  end
end

function SevenDayGiftDayGiftTemplate:HideCtr()
  self:ReleaseModel()
  self.nowControl:SetActive(false)
end

function SevenDayGiftDayGiftTemplate:ReleaseModel()
  if self.btn_Item.itemCellData then
    ItemUtility.ReleaseItemCell(self.btn_Item, self.btn_Item.itemCellData)
  end
end

return SevenDayGiftDayGiftTemplate
