local Activity_CommercialHoliday_PetInvestPage = {}

function Activity_CommercialHoliday_PetInvestPage:Init(rootUI)
  self:InitControls(rootUI)
  self:InitData()
end

function Activity_CommercialHoliday_PetInvestPage:InitControls(rootUI)
  self.rootUI = rootUI
  self.go_Model = self:GetControl("go_Model")
  self.btn_328 = self:GetControl("btn_328")
  self.btn_get = self:GetControl("btn_get")
  self.img_received = self:GetControl("img_received")
  self.txt_PetInvest_lastTime = self:GetControl("lab_Time/txt_PetInvest_lastTime")
  self.btn_tips = self:GetControl("btn_tips")
end

function Activity_CommercialHoliday_PetInvestPage:InitData()
end

function Activity_CommercialHoliday_PetInvestPage:Refresh()
  self:ShowModel()
  self:RefreshBtn()
  self:ShowTime()
end

function Activity_CommercialHoliday_PetInvestPage:ShowTime()
  if self.timer then
    Timer.Stop(self.timer)
    self.timer = nil
  end
  self.timer = Timer.StartLoopForever(1, function()
    self.txt_PetInvest_lastTime:SetText(QuickFind:GetYutulaixiDataMgr():GetRemainTimeDes())
  end)
end

function Activity_CommercialHoliday_PetInvestPage:RefreshBtn()
  local data = QuickFind:GetYutulaixiDataMgr():GetData()
  if data == nil then
    return
  end
  local recharge = ClientTable.cfg_Commerce_globalManager:TryGetValue(314001)
  if recharge == nil then
    self.btn_328:SetActive(false)
    self.btn_get:SetActive(false)
    self.img_received:SetActive(false)
    return
  end
  if QuickFind:GetYutulaixiDataMgr().rechargeCfg == nil or RefreshData.GetLimitCount(QuickFind:GetYutulaixiDataMgr().rechargeCfg.countKey) < 1 then
    self.btn_328:SetActive(false)
    self.btn_328:SetOnClick(self, function()
    end)
    if data.isReceive then
      self.btn_get:SetActive(false)
      self.img_received:SetActive(true)
      self.btn_get:SetOnClick(self, function()
      end)
    else
      self.btn_get:SetActive(true)
      self.img_received:SetActive(false)
      self.btn_get:SetOnClick(self, self.GetOnClick)
    end
  else
    self.btn_328:SetActive(true)
    self.btn_328:SetOnClick(self, self.RechargeOnClick)
    self.btn_get:SetActive(false)
    self.img_received:SetActive(false)
  end
  self.btn_tips:SetOnClick(self, function()
    UIManager.Show(UIID.ItemTipUI, {
      item = ItemUtility.GenerateItemData(2210139),
      rightOperate = EItemOperateType.Show,
      ctrl = self.btn_tips
    })
  end)
end

function Activity_CommercialHoliday_PetInvestPage:GetOnClick()
  networkRequest.ReqGetYuTuAward()
end

function Activity_CommercialHoliday_PetInvestPage:RechargeOnClick()
  local itemPrice = math.floor(QuickFind:GetYutulaixiDataMgr().rechargeCfg.rmb / 100)
  DataToCSharpMgr.Pay({
    amount = itemPrice,
    product_Id = QuickFind:GetYutulaixiDataMgr().rechargeCfg.id,
    product_name = QuickFind:GetYutulaixiDataMgr().rechargeCfg.name,
    BusinessPayType = BusinessPayType.Holiday_Prize
  })
  NetManager.Send(RechargeMessage.ReqDirectRepayInfo)
end

function Activity_CommercialHoliday_PetInvestPage:OnHide()
  if self.timer then
    Timer.Stop(self.timer)
    self.timer = nil
  end
end

function Activity_CommercialHoliday_PetInvestPage:ShowModel()
  if self.isShowModel then
    return
  end
  self.go_Model.transform.localPosition = Vector3(-198, -143, -400)
  self.curShowModel = CS.Framework.GameModel("EffectModel", self.go_Model.transform, function(go, name)
    local renders = self.curShowModel.transform:GetComponentsInChildren(typeof(UnityEngineLua.Renderer))
    for i = 0, renders.Length - 1 do
      local rend = renders[i]
      rend.sortingOrder = 400
    end
    local sys = self.curShowModel.transform:GetComponentsInChildren(typeof(CS.UnityEngine.ParticleSystem))
    for i = 0, sys.Length - 1 do
      local par = sys[i]
      par.gameObject.layer = 5
      par:GetComponent(typeof(CS.UnityEngine.Renderer)).sortingOrder = 410
    end
  end)
  local path = string.format("Model/Pet/Lieyanhu.prefab", self.go_Model)
  self.curShowModel.transform.localPosition = Vector3(0, -40, 0)
  self.curShowModel.transform.eulerAngles = Vector3(0, 150, 0)
  self.curShowModel.transform.localScale = Vector3(150, 150, 150)
  self.curShowModel:LoadAsync(path)
  self.curShowModel:SetLayer(UI_LAYER)
  self.isShowModel = true
end

return Activity_CommercialHoliday_PetInvestPage
