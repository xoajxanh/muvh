local Activity_CombineFirstGift_MainTemplates = {}

function Activity_CombineFirstGift_MainTemplates:Init(ParPanel)
  self.ParPanel = ParPanel
  self:InitControls()
  self:InitTemplate()
end

function Activity_CombineFirstGift_MainTemplates:InitControls()
  self.bg_firstGist = self:GetControl("sw_firstGift/Viewport/Content/bg_firstGist")
  self.txt_lastTimeGift = self:GetControl("txt_lastTimeGift")
end

function Activity_CombineFirstGift_MainTemplates:InitTemplate()
  self.gistTemplate = UIUtility.BindUIContainerTemp(self.bg_firstGist, LuaComponentTemplates.Activity_CombineFirstGift_ItemTemplates, self.ParPanel, self.ParPanel)
end

function Activity_CombineFirstGift_MainTemplates:Refresh()
  if QuickFind:GetCombineFirstGiftData() == nil then
    return
  end
  if self.RemainTimeLoop ~= nil then
    Timer.Stop(self.RemainTimeLoop)
  end
  if self.txt_lastTimeGift.gameObject.activeInHierarchy == true then
    self.RemainTimeLoop = Timer.StartLoopForever(1, function()
      self.txt_lastTimeGift:SetText(QuickFind:GetCombineFirstGiftData():GetRemainTimeDes())
    end)
  end
  self.gistTemplate:SetData(QuickFind:GetCombineFirstGiftData():GetShopGiftList())
end

function Activity_CombineFirstGift_MainTemplates:Exit()
  Timer.Stop(self.RemainTimeLoop)
  self.RemainTimeLoop = nil
end

return Activity_CombineFirstGift_MainTemplates
