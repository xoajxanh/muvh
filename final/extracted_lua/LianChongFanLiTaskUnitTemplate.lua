local LianChongFanLiTaskUnitTemplate = {}

function LianChongFanLiTaskUnitTemplate:Init(data)
  self.baseUI = data.baseUI
  self:InitParams()
  self:InitControls()
  self:BindUIEvent()
  self:InitContainer()
end

function LianChongFanLiTaskUnitTemplate:InitParams()
  self.parentTbl = nil
  self.taskInfo = nil
end

function LianChongFanLiTaskUnitTemplate:InitControls()
  self.desLabel = self:GetControl("txt_day")
  self.btn_Item = self:GetControl("sw_gift/Viewport/Content/btn_Item")
  self.btn_goRecharge = self:GetControl("btns/btn_goRecharge")
  self.btn_get = self:GetControl("btns/btn_get")
  self.lab_Received = self:GetControl("btns/lab_Received")
  self.lab_notReached = self:GetControl("btns/lab_notReached")
end

function LianChongFanLiTaskUnitTemplate:InitContainer()
  self.btn_ItemContainer = UIUtility.BindUIContainerTemp(self.btn_Item, LuaComponentTemplates.UIItemTemplate, self.baseUI, {isShowTips = true})
end

function LianChongFanLiTaskUnitTemplate:BindUIEvent()
  self.btn_goRecharge:SetOnClick(self, self.ClickGoReChargeCallBack)
  self.btn_get:SetOnClick(self, self.ClickGetCallBack)
end

function LianChongFanLiTaskUnitTemplate:ClickGoReChargeCallBack()
  EventManager.Dispatch(Event.CommerceCombineActivitySetJumpId, CommerceActivityIdType.LianChongFanLi)
  RechargeData.BuyDiamond(BusinessPayType.ContinuousRecharge)
end

function LianChongFanLiTaskUnitTemplate:ClickGetCallBack()
  if self.taskInfo then
    NetManager.Send(RechargeMessage.ReqGetGift, {
      id = {
        self.taskInfo.giftId
      }
    })
  end
end

function LianChongFanLiTaskUnitTemplate:Refresh(taskId, ui)
  self.parentTbl = ui
  if QuickFind:Co_serving_LCFLData() then
    self.taskInfo = QuickFind:Co_serving_LCFLData():GetTaskInfoByTaskId(taskId)
  end
  self:RefreshView()
end

function LianChongFanLiTaskUnitTemplate:RefreshView()
  self:RefreshTaskView()
  self:RefreshRewardView()
  self:RefreshBtnView()
end

function LianChongFanLiTaskUnitTemplate:RefreshTaskView()
  self.desLabel:SetText(self.taskInfo.des)
end

function LianChongFanLiTaskUnitTemplate:RefreshRewardView()
  if self.btn_ItemContainer and self.taskInfo then
    self.btn_ItemContainer:SetData(self.taskInfo.rewardInfo)
  else
    self.btn_ItemContainer:SetData({})
  end
end

function LianChongFanLiTaskUnitTemplate:RefreshBtnView()
  if self.taskInfo == nil or QuickFind:Co_serving_LCFLData() == nil then
    return
  end
  local state = QuickFind:Co_serving_LCFLData():GetTaskRewardStateByTaskId(self.taskInfo.id)
  self.btn_goRecharge:SetActive(state == ELCFLRewardState.GoRecharge)
  self.btn_get:SetActive(state == ELCFLRewardState.CanGet)
  self.lab_Received:SetActive(state == ELCFLRewardState.Geted)
  self.lab_notReached:SetActive(state == ELCFLRewardState.NotGet)
end

return LianChongFanLiTaskUnitTemplate
