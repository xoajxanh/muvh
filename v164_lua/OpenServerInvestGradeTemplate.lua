local OpenServerInvestGradeTemplate = {}

function OpenServerInvestGradeTemplate:Init(rootUI)
  self:InitControls(rootUI)
  self:BindUIEvent()
  self:InitContainer()
end

function OpenServerInvestGradeTemplate:InitControls(rootUI)
  self.rootUI = rootUI
  self.nowControl = self:GetControl()
  self.img_Invest = self:GetControl("Invest/img_Invest")
  self.lab_num = self:GetControl("Invest/img_Invest/lab_num")
  self.btn_go = self:GetControl("Invest/btn_go")
  self.lab_unTime = self:GetControl("Invest/lab_unTime")
  self.go_Invest = self:GetControl("sw_Invest/Viewport/grid_Invest/go_Invest")
end

function OpenServerInvestGradeTemplate:InitContainer()
  self.giftContainer = UIUtility.BindUIContainerTemp(self.go_Invest, LuaComponentTemplates.OpenServerInvestGiftTemplate, self.rootUI)
end

function OpenServerInvestGradeTemplate:InitData()
end

function OpenServerInvestGradeTemplate:BindUIEvent()
  self.btn_go:SetOnClick(self, self.btn_goOnClick)
end

function OpenServerInvestGradeTemplate:btn_goOnClick()
  DataToCSharpMgr.Pay({
    amount = math.floor(self.rechargeCfg.rmb / 100),
    product_Id = self.rechargeCfg.id,
    product_name = self.rechargeCfg.name
  })
end

function OpenServerInvestGradeTemplate:Refresh(data)
  if data == nil then
    return
  end
  self.data = data
  self.rechargeCfg = ClientTable.cfg_Recharge_rechargeManager:TryGetValue(self.data.id)
  self.lab_num:SetText(string.format("%dVND", math.floor(self.rechargeCfg.rmb / 100)))
  self.btn_go:SetActive(data.state == KFTZGradeState.GoRecharge)
  self.lab_unTime:SetActive(data.state == KFTZGradeState.NotRecharge)
  local spriteName = ClientTable.cfg_Commerce_globalManager:GetInvestmentSpriteNameByRechargeId(self.data.id)
  if not string.isNullOrEmpty(spriteName) then
    self.rootUI:SetSprite("Atlas_Language", spriteName, self.img_Invest)
  end
  local dayGiftInfoList = {}
  if table.count(data.notGotDayGiftInfoList) >= 1 then
    dayGiftInfoList = table.DeepCopy(data.notGotDayGiftInfoList)
  end
  table.combine(dayGiftInfoList, data.gotDayGiftInfoList)
  self.giftContainer:SetData(dayGiftInfoList, self.rootUI)
end

function OpenServerInvestGradeTemplate:Exit()
  local template
  if type(self.giftContainer) == "table" and type(self.giftContainer.items) == "table" then
    for k, v in pairs(self.giftContainer.items) do
      template = v.itemTemp
      if template.Exit ~= nil then
        template:Exit()
      end
    end
  end
end

return OpenServerInvestGradeTemplate
