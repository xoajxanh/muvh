local CrossServerThreeVsThreeGomainTemplate = {}

function CrossServerThreeVsThreeGomainTemplate:Init(root)
  self.root = root
  self:InitControls()
  self:InitUI()
  self:BindUIEvent()
end

function CrossServerThreeVsThreeGomainTemplate:InitControls()
  self.SportStart3V3 = self:GetControl("go_Sport3V3/SportStart3V3")
  self.Sport3V3Maintain = self:GetControl("go_Sport3V3/Sport3V3Maintain")
  self.Sport3V3Before = self:GetControl("go_Sport3V3/Sport3V3Before")
  self.honorMoney = self:GetControl("go_Sport3V3/honorMoney")
  self.btn_3DItemCoin = self:GetControl("go_Sport3V3/honorMoney/btn_3DItemCoin")
  self.btn_honorExchange = self:GetControl("go_Sport3V3/honorMoney/btn_compose")
  self.SportMatch3V3 = self:GetControl("go_Sport3V3/SportStart3V3/SportMatch3V3")
  self.SportTeam3V3 = self:GetControl("go_Sport3V3/SportStart3V3/SportTeam3V3")
  self.descBtn = self:GetControl("go_Sport3V3/SportStart3V3/SportMatch3V3/descBtn1")
end

function CrossServerThreeVsThreeGomainTemplate:InitUI()
  self.sportMatch3V3Template = luaTemplateManager.GetNewTemplate(self.SportMatch3V3, LuaComponentTemplates.SportMatch3V3Template, {
    root = self.root,
    parent = self
  })
  self.sportTeam3V3Template = luaTemplateManager.GetNewTemplate(self.SportTeam3V3, LuaComponentTemplates.SportTeam3V3Template, {
    root = self.root,
    parent = self
  })
end

function CrossServerThreeVsThreeGomainTemplate:BindUIEvent()
  self.btn_honorExchange:SetOnClick(self, self.btn_honorExchangeOnClick)
  self.descBtn:SetOnClick(self, self.descBtnOnClick)
end

function CrossServerThreeVsThreeGomainTemplate:btn_honorExchangeOnClick()
  if QuickFind:GetThreeVsThreeDataMgr():GetMatchState() == 1 then
    FloatingTipUtility.QuickMsg("\196\144ang gh\195\169p tr\225\186\173n kh\195\180ng th\225\187\131 th\225\187\177c hi\225\187\135n thao t\195\161c n\195\160y, h\195\163y h\225\187\167y Gh\195\169p Tr\225\186\173n tr\198\176\225\187\155c")
    return
  end
  UIManager.Show(UIID.Shop, {type = 21, subtype = 3})
end

function CrossServerThreeVsThreeGomainTemplate:descBtnOnClick(control)
  local uiDescriptionConfig = ClientTable.cfg_Ui_descriptionManager:TryGetValue(1106)
  if uiDescriptionConfig ~= nil and not string.isNullOrEmpty(uiDescriptionConfig.desc) then
    UIManager.Show(UIID.System_DescUI, {
      id = uiDescriptionConfig.id
    })
  end
end

function CrossServerThreeVsThreeGomainTemplate:Refresh()
  self.SportStart3V3:SetActive(true)
  self.SportMatch3V3:SetActive(false)
  self.SportTeam3V3:SetActive(false)
  self.Sport3V3Maintain:SetActive(false)
  self.Sport3V3Before:SetActive(false)
  self.honorMoney:SetActive(true)
  self:RefreshBtn3DItemCoin()
  self:UIControl():SetActive(true)
end

function CrossServerThreeVsThreeGomainTemplate:RefreshBtn3DItemCoin()
  local activityGlobalConfig = ClientTable.cfg_Activity_globalManager:TryGetValue(500067)
  if activityGlobalConfig ~= nil and not string.isNullOrEmpty(activityGlobalConfig.effect) then
    local configId = tonumber(activityGlobalConfig.effect)
    ItemUtility.ShowItemCellByItemId(configId, 1, self.btn_3DItemCoin, self.root, true)
    local bagCount = BagInfoData.GetItemTotalCountByItemId(configId)
    self.btn_3DItemCoin.countCtr:SetText(bagCount)
  end
end

function CrossServerThreeVsThreeGomainTemplate:RefreshEnterCount()
  if WarAllianceData.MyWarAllianceData and WarAllianceData.MyWarAllianceData.id then
    NetManager.Send(UnionMessage.ReqMemberList)
  end
end

function CrossServerThreeVsThreeGomainTemplate:RefreshSportMatch3V3Template()
  self:RefreshEnterCount()
  self.sportMatch3V3Template:Refresh()
  self.SportMatch3V3:SetActive(true)
  self.SportTeam3V3:SetActive(false)
end

function CrossServerThreeVsThreeGomainTemplate:RefreshSportTeam3V3Template()
  self.sportTeam3V3Template:Refresh()
  self.SportMatch3V3:SetActive(false)
  self.SportTeam3V3:SetActive(true)
end

function CrossServerThreeVsThreeGomainTemplate:OnDisable()
  self:UIControl():SetActive(false)
end

function CrossServerThreeVsThreeGomainTemplate:Exit()
  self:UIControl():SetActive(false)
end

return CrossServerThreeVsThreeGomainTemplate
