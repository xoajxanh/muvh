local TurntableUI_Templates = {}
TurntableUI_Templates.TurntableUIbol = false

function TurntableUI_Templates:Init()
  self:InitControls()
  self:BindUIEvent()
end

function TurntableUI_Templates:InitControls()
  self.img_redPoint = self:GetControl("img_redPoint")
  self.turntable_items = self:GetControl("imgTurntableBg/turntable_items")
  self.turntablepointer = self:GetControl("imgTurntableBg/turntablepointer")
  self.turntablepointerBg = self:GetControl("imgTurntableBg/turntablepointer/turntablepointerBg")
  self.turntableDown = self:GetControl("imgTurntableBg/turntableDown")
  self.turntablerechargeTip = self:GetControl("imgTurntableBg/turntableDown/turntablerechargeTip")
  self.turntable_goRecharge = self:GetControl("imgTurntableBg/turntableDown/turntable_goRecharge")
  self.turntablevertex = self:GetControl("imgTurntableBg/turntablevertex")
  self.turntablevertexText = self:GetControl("imgTurntableBg/turntablevertex/Text")
  self.descBtnTurntable = self:GetControl("descBtnTurntable")
end

function TurntableUI_Templates:BindUIEvent()
  self.turntablevertex:SetOnClick(self, self.TurntablevertexOnclick)
  self.turntable_goRecharge:SetOnClick(self, self.GoRechargeOnclick)
  self.descBtnTurntable:SetOnClick(self, self.DescBtnTurntableOnClick)
end

function TurntableUI_Templates:DescBtnTurntableOnClick()
  UIManager.Show(UIID.System_DescUI, {id = 1114})
end

function TurntableUI_Templates:ShowUI()
  self:ShowItemUI()
  if self.turntableActive ~= nil then
    if self.ModelData and self.ModelData ~= {} then
      self:InDestroy()
    end
    self.ModelData = {}
    for i, v in ipairs(self.turntableItemList) do
      local go_modelData = ItemCellData()
      if not self.turntableActive[i] then
        return
      end
      local itemId = self.turntableActive[i].itemId
      local count = self.turntableActive[i].count
      local itemData = ClientTable.cfg_Item_itemManager:TryGetValue(self.turntableActive[i].itemId)
      if itemData and itemData.useParam then
        local strSplit = string.split(itemData.useParam, "#")
        if strSplit and strSplit[1] and strSplit[1] == "3" and strSplit[2] then
          local box = ClientTable.cfg_Box_boxManager:TryGetShowListByBoxId(tonumber(strSplit[2]))[1]
          if box and box.itemId then
            itemId = box.itemId
            count = box.count
          end
        end
      end
      local itemData = ItemUtility.GenerateItemData(itemId)
      itemData.count = count
      go_modelData:RefreshData(itemData)
      ItemUtility.ShowItemCell(v, go_modelData, self.rootUI, true)
      table.insert(self.ModelData, go_modelData)
    end
  end
end

function TurntableUI_Templates:ShowItemUI()
  self.turntableItemList = {}
  for i = 1, self.turntable_items.transform.childCount do
    local itemCtr = self.turntable_items:GetChild("btn_Item" .. i)
    table.insert(self.turntableItemList, itemCtr)
  end
  self.turntableActive = {}
  local turntable = ClientTable.cfg_Commerce_turntableManager:GetDic()
  if turntable ~= nil then
    for i = 1, #turntable do
      if turntable[i] and ConditionManager.Check4D(turntable[i].condition) then
        table.insert(self.turntableActive, turntable[i])
      end
    end
  end
end

function TurntableUI_Templates:Refresh(data, ui)
  self:RefreshTurntable()
end

function TurntableUI_Templates:InDestroy()
  for i, v in pairs(self.turntableItemList) do
    if self.ModelData[i] and self.ModelData[i] ~= {} then
      ItemUtility.ReleaseItemCell(v, self.ModelData[i])
    end
  end
end

function TurntableUI_Templates:TurntablevertexOnclick()
  local hasCount = self:GetTurntableUIData().turntableData.hasCount
  self.TurntableUIbol = false
  if hasCount ~= nil then
    if 0 < hasCount then
      self.turntablevertex:SetInteractable(false)
      NetManager.Send(CommerceMessage.ReqLuckTurntable, {type = 1})
    else
      local countnum = CommercialHolidayData.Getcfg_Ui_wordFun("Festivalplant2")
      UIManager.Show(UIID.PromptTipUI, {
        title = "Nh\225\186\175c nh\225\187\159",
        textContent = countnum
      })
    end
  end
end

function TurntableUI_Templates:GoRechargeOnclick()
  UIManager.Show(UIID.RechargeWelfareUI, {openFirstTab = 4})
end

function TurntableUI_Templates:GetTurntableUIData()
  return gameMgr:GetAvatarManager():GetOtherPlayer():GetActivityDataMgr():GetTurntableUIDataMgr()
end

function TurntableUI_Templates:RefreshTurntable()
  if not self.TurntableUIbol then
    self:TurntableBg()
  end
  local Rotion = 2880
  local index = 0
  local configId = self:GetTurntableUIData().turntableData.configId
  for i, v in ipairs(self.turntableActive) do
    if configId == v.id then
      index = i
    end
  end
  if index ~= nil and 0 < index then
    self.turntablepointerBg:SetActive(true)
    local v3 = Vector3(0, 0, -((index * 2 - 1) * 22.5 + Rotion))
    self.turntablepointer.transform:DOLocalRotate(v3, 3):OnComplete(function()
      self.TurntableUIbol = true
      self:RefreshShowUI()
    end)
    return
  end
  if index == 0 then
    self:RefreshShowUI()
  end
end

function TurntableUI_Templates:ShowTipsRewardTipUI()
  local Turntable
  local configId = self:GetTurntableUIData().turntableData.configId
  if configId ~= nil and 0 < configId then
    for i, v in ipairs(self.turntableActive) do
      if v.id == configId then
        Turntable = v
      end
      if Turntable then
        local itemId = Turntable.itemId
        local count = Turntable.count
        local itemData = ClientTable.cfg_Item_itemManager:TryGetValue(self.turntableActive[i].itemId)
        if itemData and itemData.useParam then
          local strSplit = string.split(itemData.useParam, "#")
          if strSplit and strSplit[1] and strSplit[1] == "3" and strSplit[2] then
            local box = ClientTable.cfg_Box_boxManager:TryGetShowListByBoxId(tonumber(strSplit[2]))[1]
            if box and box.itemId then
              itemId = box.itemId
              count = box.count
            end
          end
        end
        local itemData = ItemUtility.GenerateItemData(itemId)
        itemData.count = count
        UIManager.Show(UIID.Tip_RewardTipUI, {
          rewards = {itemData}
        })
        self.TurntableUIbol = false
      end
    end
  end
end

function TurntableUI_Templates:RefreshShowUI()
  local hasCount = self:GetTurntableUIData().turntableData.hasCount
  if hasCount ~= nil then
    self.turntablevertexText:SetText("L\198\176\225\187\163t c\195\178n: " .. hasCount)
  end
  local costmoney = self:GetTurntableUIData().turntableData.nextRecharge
  if costmoney ~= nil then
    local content = ClientTable.cfg_Ui_wordManager:GetUi_wordCount("Festivalplant3")
    self.turntablerechargeTip:SetText(string.format(content, tostring(costmoney)))
    if costmoney <= 0 then
      self.turntablerechargeTip:SetActive(false)
      self.turntable_goRecharge:SetActive(false)
    else
      self.turntablerechargeTip:SetActive(true)
      self.turntable_goRecharge:SetActive(true)
    end
  end
  self.turntablevertex:SetInteractable(true)
  self:OverReward()
end

function TurntableUI_Templates:OverReward()
  for i, v in ipairs(self.turntableItemList) do
    local img_overReward = v:GetChild("img_overReward")
    if img_overReward then
      img_overReward:SetActive(false)
    end
  end
  local acquired = self:GetTurntableUIData().turntableData.acquired
  if not acquired then
    return
  end
  for i, v in ipairs(self.turntableActive) do
    for k, l in ipairs(acquired) do
      if v.id == l then
        local img_overReward = self.turntableItemList[i]:GetChild("img_overReward")
        if img_overReward then
          img_overReward:SetActive(true)
        end
      end
    end
  end
end

function TurntableUI_Templates:TurntableBg()
  self.turntablepointerBg:SetActive(false)
  if not self.turntablepointerBg:GetActive() then
    self.turntablepointer.transform.localEulerAngles = Vector3.GetTemp(0, 0, -22.5)
  end
  if self.turntablepointerBg:GetActive() then
    self.turntablepointerBg:SetActive(false)
  end
  self:ShowItemUI()
end

return TurntableUI_Templates
