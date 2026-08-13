local Commercial_RechargeAndReceiveTemp = {}

function Commercial_RechargeAndReceiveTemp:Init()
  self:InitControls()
  self:BindEvents()
end

function Commercial_RechargeAndReceiveTemp:InitControls()
  self.txt_day = self:GetControl("txt_day")
  self.btn_goRecharge = self:GetControl("btns/btn_goRecharge")
  self.txt = self:GetControl("btns/btn_goRecharge/txt")
  self.btn_lingqu = self:GetControl("btns/btn_get")
  self.lab_notReached = self:GetControl("btns/lab_notReached")
  self.txt_yijinglingqu = self:GetControl("btns/lab_Received")
  self.img_redPoint = self:GetControl("btns/btn_get/img_redPoint")
  self.btn_goRecharge:SetActive(false)
end

function Commercial_RechargeAndReceiveTemp:BindEvents()
  self.btn_lingqu:SetOnClick(self, self.ReceiveNiudan)
end

function Commercial_RechargeAndReceiveTemp:ReceiveNiudan(control)
  networkRequest.ReqDiamondGashaponReward(self.data.id)
  local str = string.split(self.data.Tbl.reward, "#")
  local ItemInfo = ItemUtility.GenerateItemData(tonumber(str[1]))
  ItemInfo.count = tonumber(str[2])
  local ItemData = {}
  table.insert(ItemData, ItemInfo)
  UIManager.Show(UIID.Tip_RewardTipUI, {rewards = ItemData})
  FloatingWordUtility.QuickMsg("Nh\225\186\173n th\195\160nh c\195\180ng")
end

function Commercial_RechargeAndReceiveTemp:Refresh(data)
  if data == nil then
    return
  end
  self.data = data
  local goalCount = ClientTable.cfg_Task_goalManager:TryGetValue(data.mission, "goalId").goalCount
  local taskText = data.Tbl.description .. "(%d/" .. goalCount .. ")"
  if data.wcActive == 1 then
    self.txt_day:SetText(string.format(taskText, goalCount))
  else
    self.txt_day:SetText(string.format(taskText, data.goals))
  end
  self.lab_notReached:SetActive(data.wcActive == 0 and data.lqActive == 0)
  self.btn_lingqu:SetActive(data.lqActive == 0 and data.wcActive == 1)
  self.img_redPoint:SetActive(data.lqActive == 0 and data.wcActive == 1)
  self.txt_yijinglingqu:SetActive(data.lqActive == 1 and data.wcActive == 1)
end

return Commercial_RechargeAndReceiveTemp
