Activity_GoodCommentUI = class(BaseUI)
Activity_GoodCommentUI.layer = UILayer.Panel
Activity_GoodCommentUI.orderInLayer = 0
Activity_GoodCommentUI.hideType = UIHideType.Destroy
Activity_GoodCommentUI.hideFunc = UIHideFunc.MoveOutOfScreen
Activity_GoodCommentUI.escClose = UIEscClose.DontClose

function Activity_GoodCommentUI:InitControls()
  self.btn_closeBg = self:GetControl("btn_closeBg")
  self.btn_close = self:GetControl("bg_goodComment/btn_close")
  self.txt_introduce1 = self:GetControl("bg_goodComment/go_goodComment/img_prompt1/txt_introduce1")
  self.txt_introduce2 = self:GetControl("bg_goodComment/go_goodComment/img_prompt2/txt_introduce2")
  self.txt_introduce3 = self:GetControl("bg_goodComment/go_goodComment/img_prompt3/txt_introduce3")
  self.go_gift = self:GetControl("bg_goodComment/go_goodComment/go_gift")
  self.level_Item = self:GetControl("bg_goodComment/go_goodComment/go_gift/Viewport/grid_reward/level_Item")
  self.btn_go = self:GetControl("bg_goodComment/go_goodComment/btn_go")
  self.btn_getGift = self:GetControl("bg_goodComment/go_goodComment/btn_getGift")
  self.descBtn = self:GetControl("bg_goodComment/go_goodComment/descBtn")
end

function Activity_GoodCommentUI:Init()
  GoodCommentData:Init()
  self.timerCoroutine = nil
  self.isCanReward = false
end

function Activity_GoodCommentUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Activity_GoodCommentUI:InitUI()
  GoodCommentData:Updata()
  self.levelItem_Container = UIContainer(self.level_Item, self, self.OnLevelItemCreat, self.OnLevelItemRefresh)
end

function Activity_GoodCommentUI.OnLevelItemCreat(ctr)
  ctr.go_model = UIControl(ctr.transform, "go_model")
  ctr.go_modelData = ItemCellData()
end

function Activity_GoodCommentUI.OnLevelItemRefresh(ctr, _, data, ui)
  if data == nil or next(data) == nil then
    return
  end
  local itemData = ItemUtility.GenerateItemData(data.id)
  ctr.go_modelData:RefreshData(itemData)
  ItemUtility.ShowItemCell(ctr, ctr.go_modelData, ui)
  ctr.countCtr:SetActive(false)
end

function Activity_GoodCommentUI:RegistUIEvents()
  self.btn_closeBg:SetOnClick(self, self.btn_closeOnClick)
  self.btn_close:SetOnClick(self, self.btn_closeOnClick)
  self.level_Item:SetOnClick(self, self.level_ItemOnClick)
  self.btn_go:SetOnClick(self, self.btn_goOnClick)
  self.btn_getGift:SetOnClick(self, self.btn_getGiftOnClick)
  self.descBtn:SetOnClick(self, self.descBtnOnClick)
end

function Activity_GoodCommentUI:btn_closeOnClick(control)
  UIManager.Hide(UIID.Activity_GoodCommentUI)
end

function Activity_GoodCommentUI:level_ItemOnClick(control)
end

function Activity_GoodCommentUI:btn_goOnClick(control)
end

function Activity_GoodCommentUI:btn_getGiftOnClick(control)
  if not self.isCanReward then
    if not string.isNullOrEmpty(GoodCommentData.goodCommentUrl) then
      Application.OpenURL(GoodCommentData.goodCommentUrl)
    end
    local btn_text = UIControl(self.btn_getGift.transform, "txt")
    Coroutine.Start(function()
      Coroutine.Wait(3)
      btn_text:SetText("Nh\225\186\173n th\198\176\225\187\159ng")
      Coroutine.WaitForEndOfFrame()
    end)
    self.isCanReward = true
    return
  end
  if self.timerCoroutine then
    FloatingTipUtility.QuickMsg("Y\195\170u c\225\186\167u qu\195\161 th\198\176\225\187\157ng xuy\195\170n, vui l\195\178ng th\225\187\173 l\225\186\161i sau")
    return
  end
  self.timerCoroutine = Coroutine.Start(function()
    Coroutine.Wait(2)
    self.timerCoroutine = nil
    Coroutine.WaitForEndOfFrame()
  end)
  local commentSuccess = ClientTable.cfg_Ui_wordManager:TryGetValue("GoodComment_prompt_2")
  FloatingTipUtility.QuickMsg(commentSuccess and commentSuccess.content or "Nh\225\186\173n ph\225\186\167n th\198\176\225\187\159ng \196\145\195\161nh gi\195\161 th\195\160nh c\195\180ng")
  networkRequest.ReqReceiveEvaluateGift(GoodCommentData.giftDate.id or 0)
  local refresh = ClientTable.cfg_Count_countManager:TryGetValue(GoodCommentData.giftDate.countKey, "key")
  RefreshData.RefreshTbl(refresh)
  RefreshData.GetRefreshByKey(2444001)
  EventManager.Dispatch(Event.Fuc_Refresh)
end

function Activity_GoodCommentUI:descBtnOnClick(control)
end

function Activity_GoodCommentUI:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function Activity_GoodCommentUI:RegistEvents()
end

function Activity_GoodCommentUI:Refresh()
  self.txt_introduce1:SetText(GoodCommentData.textList[1] or "")
  self.txt_introduce2:SetText(GoodCommentData.textList[2] or "")
  self.txt_introduce3:SetText(GoodCommentData.textList[3] or "")
  local itemDataList = {}
  ClientTable.cfg_Item_itemManager:TryGetValue()
  self.levelItem_Container:SetData(GoodCommentData.awardList)
end

function Activity_GoodCommentUI:OnHide()
end

function Activity_GoodCommentUI:OnDestroy()
end
