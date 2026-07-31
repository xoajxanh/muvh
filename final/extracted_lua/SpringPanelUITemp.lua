local SpringPanelUITemp = {}

function SpringPanelUITemp:Init()
  self:InitControls()
  self.SpringFestivalTemp = UIUtility.BindUIContainerTemp(self.img_DailyGifts, LuaComponentTemplates.SpringFestivalTemp, self)
end

function SpringPanelUITemp:InitControls()
  self.img_DailyGifts = self:GetControl("sw_dailyGiftsList/Viewport/Content/img_DailyGifts")
  self.lab_Time = self:GetControl("lab_Time/txt_DailyGifts_lastTime")
end

function SpringPanelUITemp:Refresh(data)
  if not data then
    return
  end
  self.data = data
  self.SpringFestivalTemp:SetData(data)
  self:DestroySpringFestivalTime()
  self.RemainTimeLoopSpringFestival = Timer.StartLoopForever(1, function()
    self.lab_Time:SetText(QuickFind:GetSpringActivityDataMgr():GetRemainTimeDes())
  end)
end

function SpringPanelUITemp:DestroySpringFestivalTime()
  if self.RemainTimeLoopSpringFestival then
    Timer.Stop(self.RemainTimeLoopSpringFestival)
    self.RemainTimeLoopSpringFestival = nil
  end
end

return SpringPanelUITemp
