local SpringFestivalTemp = {}

function SpringFestivalTemp:Init()
  self:InitControls()
end

local function OnEquipItemCreate(ctr)
  ctr.itemCellData = ItemCellData()
end

local function OnEquipItemRefresh(ctr, index, data, ui)
  local itemData = ItemUtility.GenerateItemData(data.itemId)
  itemData.count = data.count
  ctr.itemCellData:RefreshData(itemData)
  ItemUtility.ShowItemCell(ctr, ctr.itemCellData, ui.rootUI, true)
end

function SpringFestivalTemp:InitControls()
  self.btn_goRecharge = self:GetControl("btns/btn_goRecharge")
  self.lab_taskName = self:GetControl("lab_dailyMission")
  self.lab_CanNotGet = self:GetControl("btns/img_unget")
  self.lab_alreadyGet = self:GetControl("btns/img_Received")
  self.btn_get_item = self:GetControl("btns/btn_get")
  self.img_redPoint = self:GetControl("btns/btn_get/img_redPoint")
  self.btn_Item = self:GetControl("sw_gift/Viewport/Content/btn_Item")
  self.btn_equipItemContainer = UIContainer(self.btn_Item, self, OnEquipItemCreate, OnEquipItemRefresh)
  self.btn_get_item:SetOnClick(self, self.btn_equipPrizeOnClick)
end

function SpringFestivalTemp:btn_equipPrizeOnClick()
  NetManager.Send(CommerceMessage.ReqQianDaoReward, {
    configId = self.data.configId
  })
end

function SpringFestivalTemp:Refresh(data)
  self.data = data
  if not self.data then
    return
  end
  self:RefreshItemData(self.data)
end

function SpringFestivalTemp:RefreshData(giftId)
  if not string.isNullOrEmpty(giftId) then
    local data = ClientTable.cfg_Gift_giftManager:TryGetValue(giftId, "id").reward
    local boxItems = ConfigManager.FindConfigs("cfg_Box_box", "boxId", data)
    local itemData = {}
    for i, v in pairs(boxItems) do
      itemData[i] = {
        itemId = v.itemId,
        count = v.count
      }
    end
    self.btn_equipItemContainer:SetData(itemData)
  end
end

function SpringFestivalTemp:RefreshItemData(data)
  if data then
    local itemData = ClientTable.cfg_Commerce_qiandaoManager:TryGetValue(data.goalId, "goalId")
    if not itemData then
      return
    end
    self.lab_taskName:SetText(itemData.des .. "(" .. data.current .. "/" .. data.count .. ")")
    self:RefreshData(itemData.giftId)
  end
  self.btn_goRecharge:SetActive(false)
  self.lab_CanNotGet:SetActive(false)
  self.btn_get_item:SetActive(false)
  self.img_redPoint:SetActive(false)
  self.lab_alreadyGet:SetActive(false)
  if data.hasReward then
    self.lab_alreadyGet:SetActive(true)
  elseif data.count <= data.current then
    self.btn_get_item:SetActive(true)
    self.img_redPoint:SetActive(true)
  elseif data.count > data.current then
    self.lab_CanNotGet:SetActive(true)
  end
end

return SpringFestivalTemp
