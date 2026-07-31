local TabTalentTemplate = {}
TabTalentTemplate.tabID = 0

function TabTalentTemplate:Init()
  self:InitComponent()
  self:BindEvent()
end

function TabTalentTemplate:InitComponent()
  self.tab_talent = self:GetControl("")
  self.Checkmark = self:GetControl("Background/Checkmark")
  self.imgName = self:GetControl("imgName")
  self.occupationIco = self:GetControl("icoBg/occupationIco")
  self.btn_goInput = self:GetControl("btns/btn_goInput")
  self.lab_Received = self:GetControl("btns/lab_Received")
end

function TabTalentTemplate:BindEvent()
  if self.btn_goInput then
    self.btn_goInput:SetOnClick(self, function()
      if QuickFind.MasterSysData().IsFree then
        networkRequest.ReqEnableGrandMasterTalent(self.tabID, 2)
      elseif QuickFind.MasterSysData().MasterType == 0 then
        networkRequest.ReqEnableGrandMasterTalent(self.tabID, 0)
      else
        EventManager.Dispatch(Event.MasterTabOpenPay, self.tabID)
      end
    end)
  end
  if self.tab_talent then
    self.tab_talent:SetOnClick(self, function()
      EventManager.Dispatch(Event.MasterTabChange, self.tabID)
    end)
  end
end

function TabTalentTemplate:Refresh(data, ui)
  if data == nil then
    return
  end
  self.tabID = data.type
  self.Checkmark:SetActive(QuickFind.MasterSysData().MasterType == self.tabID)
  self.imgName:SetSprite(data.typeNameRes)
  self.occupationIco:SetSprite(data.typeIconRes)
  self.btn_goInput:SetActive(QuickFind.MasterSysData().MasterType ~= self.tabID)
  self.lab_Received:SetActive(QuickFind.MasterSysData().MasterType == self.tabID)
end

return TabTalentTemplate
