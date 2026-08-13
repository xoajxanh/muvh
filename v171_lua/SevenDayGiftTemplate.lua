local SevenDayGiftTemplate = {}

function SevenDayGiftTemplate:Init(rootUI)
  self:InitControls(rootUI)
  self:InitContainer()
end

function SevenDayGiftTemplate:InitControls(rootUI)
  self.rootUI = rootUI
  self.nowControl = self:GetControl()
  self.txt_SevenDayGifts_lastTime = self:GetControl("lab_Time/txt_SevenDayGifts_lastTime")
  self.go_SevenDay = self:GetControl("go_SevenDay")
  self.btn_ItemTarget = self:GetControl("sw_targetReward/Viewport/Content/btn_ItemTarget")
end

function SevenDayGiftTemplate:InitContainer()
  self.dayRewardContainer = {}
  for i = 1, self.go_SevenDay.transform.childCount do
    local itemCtr = self.go_SevenDay:GetChild("day_" .. i)
    local dayRewardTemp = luaTemplateManager.GetNewTemplate(itemCtr, LuaComponentTemplates.SevenDayGiftDayGiftTemplate, self.rootUI)
    table.insert(self.dayRewardContainer, dayRewardTemp)
  end
  self.targetRewardContainer = UIUtility.BindUIContainerTemp(self.btn_ItemTarget, LuaComponentTemplates.SevenDayGiftTargetRewardTemplate, self.rootUI)
end

function SevenDayGiftTemplate:InitData()
end

function SevenDayGiftTemplate:BindUIEvent()
end

function SevenDayGiftTemplate:Refresh()
  local dayGiftInfoList = QuickFind:GetSevenDayGiftData():GetDayGiftInfoList()
  for i, dayRewardTemp in ipairs(self.dayRewardContainer) do
    dayRewardTemp:Refresh(dayGiftInfoList[i])
  end
  self.targetRewardContainer:SetData(QuickFind:GetSevenDayGiftData():GetTargetGiftInfoList())
  self:RefreshTime()
end

function SevenDayGiftTemplate:RefreshTime()
  self:DestroyTime()
  self.txt_SevenDayGifts_lastTime:SetText(QuickFind:GetSevenDayGiftData():GetRemainTimeDes())
  self.RemainTimeLoop = Timer.StartLoopForever(1, function()
    self.txt_SevenDayGifts_lastTime:SetText(QuickFind:GetSevenDayGiftData():GetRemainTimeDes())
    QuickFind:GetSevenDayGiftData():RefreshDayGiftInfoByOpenDay()
  end)
end

function SevenDayGiftTemplate:Exit()
  self:DestroyTime()
  self:ReleaseModel()
end

function SevenDayGiftTemplate:DestroyTime()
  if self.RemainTimeLoop then
    Timer.Stop(self.RemainTimeLoop)
    self.RemainTimeLoop = nil
  end
end

function SevenDayGiftTemplate:ReleaseModel()
  for i, dayRewardTemp in ipairs(self.dayRewardContainer) do
    dayRewardTemp:ReleaseModel()
  end
  local itemTemp
  for i, v in ipairs(self.targetRewardContainer.items) do
    itemTemp = v.itemTemp
    itemTemp:ReleaseModel()
  end
end

return SevenDayGiftTemplate
