local CreateTeam3V3Template = {}

function CreateTeam3V3Template:Init(rootPanel)
  self.rootPanel = rootPanel
  self:InitControls()
  self:InitUI()
  self:BindUIEvents()
end

local function RewardItemOnCreate(ctr)
  ctr.itemCellData = ItemCellData()
end

local function RewardItemRefresh(ctr, index, data, ui)
  local itemData = ItemUtility.GenerateItemData(data.itemId)
  itemData.count = data.itemCount
  ctr.itemCellData:RefreshData(itemData)
  ItemUtility.ShowItemCell(ctr, ctr.itemCellData, ui, true, nil, nil, nil, nil, {
    go_effectModel = function(go)
      if itemData.tblItem.subType == EItemSubtype.EffectTitle then
        go.transform.localScale = Vector3(0.5, 0.5, 0.5)
      else
        go.transform.localScale = Vector3(1, 1, 1)
      end
    end
  })
end

function CreateTeam3V3Template:BindEvent()
end

function CreateTeam3V3Template:InitUI()
  self.RewardItemList = UIContainer(self.btn_Item, self.rootPanel, RewardItemOnCreate, RewardItemRefresh)
end

function CreateTeam3V3Template:InitControls()
  self.txt_lastTime = self:GetControl("txt_lastTime")
  self.lab_lastTime = self:GetControl("txt_lastTime/lab_lastTime")
  self.btn_cantreceive = self:GetControl("btn_cantreceive")
  self.img_dia = self:GetControl("btn_cantreceive/img_dia")
  self.num_txt = self:GetControl("btn_cantreceive/img_dia/num_txt")
  self.btn_receive = self:GetControl("btn_receive")
  self.btn_Item = self:GetControl("right_rewardShow/member_gift/Viewport/grid_reward/btn_Item")
  self.btn_detail = self:GetControl("right_rewardShow/btn_detail")
  self.btn_description = self:GetControl("btn_description")
  self.time_register_time = self:GetControl("time_register/time")
end

function CreateTeam3V3Template:BindUIEvents()
  self.btn_cantreceive:SetOnClick(self, self.btn_cantreceiveOnClick)
  self.btn_receive:SetOnClick(self, self.btn_receiveOnClick)
  self.btn_detail:SetOnClick(self, self.btn_detailOnClick)
  self.btn_description:SetOnClick(self, self.btn_descriptionOnClick)
end

function CreateTeam3V3Template:btn_cantreceiveOnClick()
  UIManager.Show(UIID.Team3V3CreateUI)
end

function CreateTeam3V3Template:btn_receiveOnClick()
  UIManager.Show(UIID.Team3V3ApplyUI)
end

function CreateTeam3V3Template:btn_detailOnClick()
  UIManager.Show(UIID.System_DescUI, {id = 1155})
end

function CreateTeam3V3Template:btn_descriptionOnClick()
  UIManager.Show(UIID.System_DescUI, {id = 1156})
end

function CreateTeam3V3Template:Refresh()
  self:BindEvent()
  local activity = ClientTable.cfg_Activity_globalManager:GetEffect(500573)
  self.Daojishi = QuickFind:GetTeam3V3DataMgr():GetBaoMinTime()
  local info = string.split(activity, "#")
  local itemId = info[1]
  local itemCount = info[2]
  local itemIcon = ClientTable.cfg_Item_itemManager:TryGetValue(tonumber(itemId)).icon
  self.rootPanel:SetSprite("Atlas_Common", itemIcon, self.img_dia)
  local bagCount = BagInfoData.GetItemTotalCountByItemId(tonumber(itemId))
  self.num_txt:SetText(string.GetColorText(itemCount, bagCount >= tonumber(itemCount) and ItemQuality2ColorDic[EItemColorEnum.white] or ItemQuality2ColorDic[EItemColorEnum.red]))
  self.time_register_time:SetText(self.Daojishi.startStr .. "~" .. self.Daojishi.endStr)
  self:ShowReward()
  if not self.BaoMinTimer then
    self.BaoMinTimer = Timer.StartLoopForever(1, self.SetBaoMinTime, self)
  end
end

function CreateTeam3V3Template:SetBaoMinTime()
  local NowTime = Time.GetServerSecondTime()
  if NowTime <= self.Daojishi.endStamp then
    self.lab_lastTime:SetText(TimeUtility.ShowDayTime(self.Daojishi.endStamp - Time.GetServerSecondTime()))
  else
    self.lab_lastTime:SetText(TimeUtility.ShowDayTime(0))
  end
end

function CreateTeam3V3Template:ShowReward()
  local info = QuickFind:GetTeam3V3DataMgr():GetCreateTeam3V3Reward()
  self.RewardItemList:SetData(info)
end

function CreateTeam3V3Template:Exit()
  if self.BaoMinTimer then
    Timer.Stop(self.BaoMinTimer)
    self.BaoMinTimer = nil
  end
end

return CreateTeam3V3Template
