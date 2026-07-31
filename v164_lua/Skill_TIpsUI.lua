Skill_TIpsUI = class(BaseUI)
Skill_TIpsUI.layer = UILayer.Background
Skill_TIpsUI.orderInLayer = 2
Skill_TIpsUI.hideType = UIHideType.Hide
Skill_TIpsUI.hideFunc = UIHideFunc.MoveOutOfScreen
Skill_TIpsUI.escClose = UIEscClose.DontClose

function Skill_TIpsUI:InitControls()
  self.BG = self:GetControl("BG")
  self.btn_3DItem = self:GetControl("BG/img_Bg/btn_3DItem")
  self.lab_name = self:GetControl("BG/img_Bg/btn_3DItem/lab_name")
  self.lab_num = self:GetControl("BG/img_Bg/btn_3DItem/lab_num")
  self.MyName = self:GetControl("BG/img_Bg/btn_3DItem/MyName")
  self.lab_skilltips = self:GetControl("BG/lab_skilltips")
  self.btn_quickeuse = self:GetControl("BG/btn_quickeuse")
  self.lab_quickuse = self:GetControl("BG/btn_quickeuse/lab_quickuse")
  self.lab_countdown = self:GetControl("BG/btn_quickeuse/lab_countdown")
  self.btn_close = self:GetControl("BG/btn_close")
end

function Skill_TIpsUI:OnPreLoad()
end

function Skill_TIpsUI:Init()
  self.acc = 9
  self.recTimer = nil
  self.EquipInfo = {}
  self.showCellData = ItemCellData()
end

function Skill_TIpsUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Skill_TIpsUI:InitUI()
  self.BG_pos = self.BG.transform.localPosition
end

function Skill_TIpsUI:OnShow()
  if SceneData.mapId and SceneData.mapId == 1095 then
    UIManager.Hide(UIID.SkillTIpsUI)
    return
  end
  self:RegistEvents()
  local main = UIManager.GetUiByName(UIID.MainMenuUI)
  if main then
    if main.state then
      self.BG.transform.localPosition = self.BG_pos
    else
      self.BG.transform.localPosition = Vector3.New(self.BG_pos.x, self.BG_pos.y - 500, self.BG_pos.z)
    end
  else
    self.BG.transform.localPosition = self.BG_pos
  end
  self:ShowData()
  self:Refresh()
end

function Skill_TIpsUI:ShowData()
  if table.count(self.args.ItemInfo) ~= 0 then
    if not self.args.bagchange then
      self.EquipInfo = {}
      for i, v in pairs(self.args.ItemInfo) do
        if v.params[1] == "1" then
          self:InsertData(v)
        else
          self:AddData(v)
        end
      end
    else
      self.EquipInfo = self.args.ItemInfo
    end
  elseif self.ShowItem ~= nil then
    table.insert(self.EquipInfo, self.ShowItem)
  end
end

function Skill_TIpsUI:UpLInsertData(items)
  self.EquipInfo = {}
  local newshowdelete = 0
  for i, v in pairs(items) do
    if self.ShowItem and self.ShowItem.itemId == v.itemId then
      newshowdelete = newshowdelete + 1
    end
    if newshowdelete ~= 1 then
      if v.params[1] == "1" then
        self:InsertData(v)
      else
        self:AddData(v)
      end
    end
  end
  self:CalculateCount()
end

function Skill_TIpsUI:InsertData(items)
  if items then
    if self.ShowItem and items.itemId == self.ShowItem.itemId then
      return
    end
    local mun = #self.EquipInfo
    for i = 1, mun do
      if items.itemId == self.EquipInfo[i].itemId then
        return
      end
    end
    table.insert(self.EquipInfo, items)
  end
end

function Skill_TIpsUI:AddData(items)
  table.insert(self.EquipInfo, items)
  self:CalculateCount()
end

function Skill_TIpsUI:CalculateCount()
  local count = 1
  if self.ShowItem then
    if tonumber(self.ShowItem.Condition[1]) == TipFastUse.Other then
      count = BagInfoData.GetItemCountByItemConfigId(self.ShowItem.itemId)
    else
      for i, v in pairs(self.EquipInfo) do
        if self.ShowItem.itemId == v.itemId then
          count = count + 1
        end
      end
    end
  end
  self.ShowCount = count
  self.lab_num:SetActive(true)
  self.lab_num:SetText(self.ShowCount)
end

function Skill_TIpsUI:OnHide()
  self.showCellData:RecycleRes()
  self.args.ItemInfo = {}
  self:DestroyTimer()
  self.EquipInfo = {}
  self.ShowItem = nil
end

function Skill_TIpsUI:OnDestroy()
  if self.showCellData then
    self.showCellData:RecycleRes()
    self.showCellData = nil
  end
end

function Skill_TIpsUI:Update()
  if self.showCellData and self.showCellData.model then
    if self.ShowCount then
      self.lab_num:SetText(self.ShowCount)
    end
    local obj = self.showCellData.model.modelObject
    RoleEquipUtility.EquipModelRotation(obj, self.showCellData.itemData.tblItem.SpinAxis, 2)
  end
end

function Skill_TIpsUI:RegistUIEvents()
  self.btn_quickeuse:SetOnClick(self, self.btn_quickeuseOnClick)
  self.btn_close:SetOnClick(self, self.btn_closeOnClick)
end

function Skill_TIpsUI:btn_quickeuseOnClick(control)
  if self.ShowItem.params[1] == "1" then
    RoleEquipUtility.CheckUseItem(self.ShowItem, CheckUseItemWay.NotTip)
  end
  if tonumber(self.ShowItem.Condition[1]) == TipFastUse.Other and TipData.UpExpProp[self.ShowItem.itemId] then
    TipData.UseExpProp(self.ShowItem.id, self.ShowItem.itemId, self.ShowCount)
  end
  MeController.UpdateClientItemCd(self.ShowItem.itemId)
  local params = self.ShowItem.params
  if #self.ShowItem.params == 1 and self.ShowItem.params[1] == "8" then
    params = nil
  end
  local bagidcount = BagInfoData.GetItemCountById(self.ShowItem.id)
  if bagidcount == 0 then
    self:btn_closeOnClick()
    return
  end
  local UseCount = bagidcount < self.ShowCount and bagidcount or self.ShowCount
  BagInfoController.UseItemReq(UseCount, self.ShowItem.id, params, self.ShowItem.itemId)
  if self.ShowItem.params and self.ShowItem.params[1] == "30" then
    TaskManager.SetTaskPickUpDrop()
  end
end

function Skill_TIpsUI:btn_closeOnClick(control)
  if control and self.ShowItem.Condition then
    TipData.BagChangeRefrsh(self.ShowItem.id)
    local ItemData = self.EquipInfo
    local acc = 0
    for k = 1, #ItemData do
      k = k + acc
      if self.EquipInfo[k] and self.EquipInfo[k].itemId == self.ShowItem.itemId then
        table.remove(self.EquipInfo, k)
        acc = acc - 1
      end
    end
  end
  self:DestroyTimer()
  if #self.EquipInfo ~= 0 then
    self:Refresh()
  else
    UIManager.Hide(UIID.SkillTIpsUI)
    TipData.OpenNextUI()
  end
end

function Skill_TIpsUI:RegistEvents()
  self:RegistEvent(Event.Bag_ResBagChange, self.OnBagChange, self)
  self:RegistEvent(Event.TipsMainUIPosChange, self.TipsMainUIPosChange, self)
  self:RegistEvent(Event.HideQuickUseWindow, self.HideThisUI, self)
end

function Skill_TIpsUI:OnBagChange(id, msg)
  if msg then
    local showId = false
    local showremove = false
    if table.count(msg.removeItems) ~= 0 and TipData.bageChangeType(msg) then
      for i, v in pairs(msg.removeItems) do
        local id = v.id
        local ExpendsCount = v.count
        TipData.BagChangeCountRefrsh(v.id, ExpendsCount)
        local acc = 0
        local acccount = 0
        if self.ShowItem and id == self.ShowItem.id then
          showId = true
          showremove = true
          acccount = acccount + 1
        end
        for k = 1, #self.EquipInfo do
          k = k + acc
          if self.EquipInfo[k].id == id then
            if acccount == ExpendsCount then
              break
            end
            acccount = acccount + 1
            table.remove(self.EquipInfo, k)
            acc = acc - 1
          end
        end
      end
    end
    if table.count(msg.TruereduceTbl) ~= 0 and TipData.bageChangeType(msg) then
      for i, v in pairs(msg.TruereduceTbl) do
        local id = v.id
        local acc = 0
        local acccount = 0
        local ExpendsCount = v.count
        TipData.BagChangeCountRefrsh(id, v.count)
        if self.ShowItem and id == self.ShowItem.id then
          showId = true
          if not showremove then
            acccount = acccount + 1
          end
        end
        for k = 1, #self.EquipInfo do
          k = k + acc
          if self.EquipInfo[k].id == id then
            if acccount == ExpendsCount then
              break
            end
            acccount = acccount + 1
            table.remove(self.EquipInfo, k)
            acc = acc - 1
          end
        end
      end
    end
    if showId then
      self:btn_closeOnClick()
    end
  end
end

function Skill_TIpsUI:HideThisUI()
  UIManager.Hide(UIID.SkillTIpsUI)
end

function Skill_TIpsUI:TipsMainUIPosChange(_, state)
  local animalTime = C_UISettings.MainMenuUITime
  local distance = C_UISettings.MainUIDistance
  if state then
    self.BG.transform:DOLocalMove(self.BG_pos, animalTime):SetEase(Ease.OutQuad)
  else
    self.BG.transform:DOLocalMove(self.BG_pos + Vector3.New(0, -distance - 500, 0), animalTime):SetEase(Ease.OutQuad)
  end
end

function Skill_TIpsUI:Refresh()
  self.ShowItem = self.EquipInfo[1]
  if self.ShowItem == nil then
    self.EquipInfo = {}
    self:btn_closeOnClick()
  end
  table.remove(self.EquipInfo, 1)
  self.showCellData:RefreshData(self.ShowItem)
  if self.recTimer == nil then
    self:CreatTimer()
    self:RefreshShow()
  end
end

function Skill_TIpsUI:RefreshShow()
  self.lab_skilltips:SetText("\196\144\198\176\225\187\163c d\195\185ng")
  ItemUtility.ShowItemCell(self.btn_3DItem, self.showCellData, self, true)
  self.lab_countdown:SetText("(" .. self.acc .. "s)")
  if not string.isNullOrEmpty(self.args.lab_quickequip) then
    self.lab_quickuse:SetText(self.args.lab_quickequip)
  end
  local textWidth = self.lab_name.text.preferredWidth
  local bgWith = self.lab_name:GetSizeDelta()
  if textWidth > bgWith then
    local text = string.GetColorText(self.ShowItem.tblItem.name, ItemQuality2ColorDic[self.ShowItem.tblItem.colorShow])
    self.MyName.transform:GetComponent("AutoScrollText").text = text
    self.lab_name:SetActive(false)
    self.MyName:SetActive(true)
  else
    self.lab_name:SetActive(true)
    self.MyName:SetActive(false)
  end
  self:CalculateCount()
end

function Skill_TIpsUI:CreatTimer()
  self.acc = tonumber(self.ShowItem.Condition[2])
  local timeStr = self.acc
  
  local function UpdataTimerBtn()
    if 1 < timeStr then
      timeStr = timeStr - 1
      self.lab_countdown:SetText("(" .. timeStr .. "s)")
    elseif timeStr == 1 then
      timeStr = timeStr - 1
      self.lab_countdown:SetText("(" .. timeStr .. "s)")
      self:btn_quickeuseOnClick()
    end
  end
  
  self.recTimer = Timer.StartLoop(1, timeStr, UpdataTimerBtn)
end

function Skill_TIpsUI:DestroyTimer()
  if self.recTimer then
    Timer.Stop(self.recTimer)
  end
  self.recTimer = nil
end
