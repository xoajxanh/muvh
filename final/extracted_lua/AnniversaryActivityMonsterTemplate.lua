local AnniversaryActivityMonsterTemplate = {}
local nowState = false

local function ShowModelCreate(ctr)
  ctr.itemCtr = ItemUtility.InitItemCell(UIControl(ctr.transform))
  ctr.modelData = ItemCellData()
end

local function ShowModelRefresh(ctr, _, data, ui)
  local id = tonumber(data)
  local itemData = ItemUtility.GenerateItemData(id)
  ctr.modelData:RefreshData(itemData)
  ItemUtility.ShowItemCell(ctr.itemCtr, ctr.modelData, ui.root, true)
end

local function ShowTaskRewardCreate(ctr)
  ctr.waralliance_count = UIControl(ctr.transform, "waralliance_count")
  ctr.btn_3DItem = UIControl(ctr.transform, "waralliance_count/btn_3DItem")
  ctr.img_select = UIControl(ctr.transform, "waralliance_count/btn_3DItem/img_select")
  ctr.itemCtr = ItemUtility.InitItemCell(ctr.btn_3DItem)
  ctr.modelData = ItemCellData()
end

local function ShowTaskRewardRefresh(ctr, _, data, ui)
  local showTaskData = data.showTaskData[1]
  local giftData = data.giftInfo[1]
  local id = tonumber(showTaskData.boxData.itemId)
  local itemData = ItemUtility.GenerateItemData(id)
  itemData.count = showTaskData.boxData.count
  ctr.modelData:RefreshData(itemData)
  ItemUtility.ShowItemCell(ctr.itemCtr, ctr.modelData, ui.root, true)
  ui:ChangeTaskState(data, ctr.waralliance_count, ctr.img_select)
end

function AnniversaryActivityMonsterTemplate:ChangeTaskState(data, countCtr, selectCtr)
  local showTaskData = data.showTaskData[1]
  local giftData = data.giftInfo[1]
  local state = TaskStateEnum.CanNotGet
  if giftData.canGet == true and RechargeData.GetCount(showTaskData.giftData.countKey) == 0 then
    state = TaskStateEnum.CanGet
  elseif giftData.canGet == true and RechargeData.GetCount(showTaskData.giftData.countKey) > 0 then
    state = TaskStateEnum.Got
  end
  if state == TaskStateEnum.CanNotGet then
    if RoleManager.me.data.unionName ~= "" then
      countCtr:SetText("(" .. data.current .. " / " .. showTaskData.goalInfo.goalCount .. ")")
    else
      local formatStr = string.format("<color=%s>%s</color>", ItemQuality2ColorDic[7], data.current)
      countCtr:SetText("(" .. formatStr .. " / " .. showTaskData.goalInfo.goalCount .. ")")
    end
    countCtr:SetColor(EUIColor.White)
  else
    countCtr:SetText("(" .. showTaskData.goalInfo.goalCount .. " / " .. showTaskData.goalInfo.goalCount .. ")")
    countCtr:SetColor(EUIColor.Green)
    selectCtr:SetActive(state == TaskStateEnum.Got)
  end
  return state
end

function AnniversaryActivityMonsterTemplate:Init()
  self:InitControls()
  self:InitUI()
  self:ResgistUIEvents()
end

function AnniversaryActivityMonsterTemplate:InitControls()
  self.monsterItem = self:GetControl("img_rewardbg/reward_grid/btn_3DItem")
  self.lab_des = self:GetControl("Image/lab_des")
  self.waralliance_name = self:GetControl("Image/lab_des/waralliance_name")
  self.lab_des_0 = self:GetControl("Image/lab_des_0")
  self.needShowItem = self:GetControl("Image/waralliance_num/btn_3DItem")
  self.rewardItem = self:GetControl("Image/reward_bg/Scroll View/Viewport/Content/Image")
  self.btn_arrow = self:GetControl("Image/btn_arrow")
  self.reward_bg = self:GetControl("Image/reward_bg")
  self.plane_mask = self:GetControl("Image/reward_bg/plane_mask")
  self.waralliance_num = self:GetControl("Image/waralliance_num")
  self.btn_3DItem = self:GetControl("Image/waralliance_num/btn_3DItem")
  self.img_select = self:GetControl("Image/waralliance_num/btn_3DItem/img_select")
end

function AnniversaryActivityMonsterTemplate:InitUI()
  self.monsterContainer = UIContainer(self.monsterItem, self, ShowModelCreate, ShowModelRefresh)
  self.rewardContainer = UIContainer(self.rewardItem, self, ShowTaskRewardCreate, ShowTaskRewardRefresh)
end

function AnniversaryActivityMonsterTemplate:ResgistUIEvents()
  self.btn_arrow:SetOnClick(self, self.btn_arrowOnClick)
end

function AnniversaryActivityMonsterTemplate:btn_arrowOnClick(control)
  self:ChangePanelState(not nowState, true)
end

function AnniversaryActivityMonsterTemplate:ChangePanelState(state, useDynamic)
  nowState = state
  if state == false then
    self.btn_arrow.transform:SetLocalEulerAngles(0, 0, 180)
  else
    self.btn_arrow.transform:SetLocalEulerAngles(0, 0, 0)
  end
  local width, _ = self.reward_bg:GetSizeDelta()
  local height = state and 250 or 0
  local nowHeight = state and 0 or 250
  local scale = self.plane_mask.transform.localScale
  local scaleZ = state and 0 or 25
  local nowScaleZ = state and 25 or 0
  local pos = self.plane_mask.transform.localPosition
  local posY = state and -250 or -125
  local nowPosY = state and -125 or -250
  if useDynamic then
    if self.doTween1 then
      self.doTween1:Kill()
      self.doTween1 = nil
    end
    self.doTween1 = DOTween.To(function(value)
      self.reward_bg:SetSizeDelta(width, value)
    end, nowHeight, height, 0.2):SetEase(Ease.OutQuad)
    if self.doTween2 then
      self.doTween2:Kill()
      self.doTween2 = nil
    end
    self.doTween2 = DOTween.To(function(value)
      self.plane_mask.transform.localScale = Vector3(scale.x, scale.y, value)
    end, nowScaleZ, scaleZ, 0.2):SetEase(Ease.OutQuad)
    if self.doTween3 then
      self.doTween3:Kill()
      self.doTween3 = nil
    end
    self.doTween3 = DOTween.To(function(value)
      self.plane_mask.transform.localPosition = Vector3(pos.x, value, pos.z)
    end, nowPosY, posY, 0.2):SetEase(Ease.OutQuad)
  else
    self.reward_bg:SetSizeDelta(width, height)
    self.plane_mask.transform.localScale = Vector3(scale.x, scale.y, scaleZ)
    self.plane_mask.transform.localPosition = Vector3(pos.x, posY, pos.z)
  end
end

function AnniversaryActivityMonsterTemplate:ShowPanel()
  self:ChangePanelState(false, false)
end

function AnniversaryActivityMonsterTemplate:Refresh(data, ui)
  self.root = ui
  local showData = AnniversaryActivity_MonsterData.GetDropItemData()
  self.monsterContainer:SetData(showData)
  if RoleManager.me.data.unionName ~= "" then
    self.waralliance_name:SetText(RoleManager.me.data.unionName)
    self.lab_des:SetActive(true)
    self.lab_des_0:SetActive(false)
  else
    self.waralliance_name:SetText("")
    self.lab_des:SetActive(false)
    self.lab_des_0:SetActive(true)
  end
  self.nowTaskData = AnniversaryActivity_MonsterData.GetShowOrGetRewardData()
  if not self.nowTaskData then
    return
  end
  local itemData = ItemUtility.GenerateItemData(self.nowTaskData.showTaskData[1].boxData.itemId)
  if itemData == nil or itemData.tblItem == nil then
    return
  end
  itemData.count = self.nowTaskData.showTaskData[1].boxData.count or 0
  if not self.itemCellData then
    self.itemCellData = ItemCellData()
  elseif self.itemCellData.model then
    self.itemCellData:RecycleRes()
  end
  self.itemCellData:RefreshData(itemData)
  ItemUtility.ShowItemCell(self.btn_3DItem, self.itemCellData, self.root, true)
  local state = self:ChangeTaskState(self.nowTaskData, self.waralliance_num, self.img_select)
  if state == TaskStateEnum.CanGet then
    self.btn_3DItem:SetOnClick(self, self.btn_3DItemOnClick)
  end
  self.rewardContainer:SetData(AnniversaryActivity_MonsterData.taskInfoTbl)
  EventManager.Dispatch(Event.CallRefreshRedPoint, {
    id = ERedPointId.AnniversaryActivity_monster
  })
end

function AnniversaryActivityMonsterTemplate:btn_3DItemOnClick(control)
  if self.nowTaskData then
    NetManager.Send(RechargeMessage.ReqGetGift, {
      id = {
        self.nowTaskData.showTaskData[1].giftData.id
      }
    })
  end
end

return AnniversaryActivityMonsterTemplate
