Equip_HolyRingUI = class(BaseUI)
Equip_HolyRingUI.layer = UILayer.Panel
Equip_HolyRingUI.orderInLayer = 0
Equip_HolyRingUI.hideType = UIHideType.WaitDestroy
Equip_HolyRingUI.hideFunc = UIHideFunc.MoveOutOfScreen
Equip_HolyRingUI.escClose = UIEscClose.DontClose

function Equip_HolyRingUI:InitControls()
  self.img_Bg2 = self:GetControl("img_Bg2")
  self.bg_equip = self:GetControl("bg_equip")
  self.sw_RingItem = self:GetControl("bg_equip/HolyRingBag/sw_RingItem")
  self.RingItem = self:GetControl("bg_equip/HolyRingBag/sw_RingItem/Viewport/Content/RingItem")
  self.HolyRing_Item = self:GetControl("bg_equip/HolyRingBag/sw_RingItem/Viewport/Content/RingItem/HolyRing_Item")
  self.chooseRing = self:GetControl("bg_equip/HolyRingBag/chooseRing")
  self.chooseRingname = self:GetControl("bg_equip/HolyRingBag/chooseRing/chooseRing")
  self.Item = self:GetControl("bg_equip/HolyRingBag/chooseRing/Template/Viewport/Content/Item")
  self.sw_ringSkill = self:GetControl("bg_equip/HolyRingSkill/sw_ringSkill")
  self.lab_des = self:GetControl("bg_equip/HolyRingSkill/sw_ringSkill/Viewport/SkillList/lab_des")
  self.descBtn = self:GetControl("descBtn")
  self.btn_close = self:GetControl("btn_close")
end

Equip_HolyRingUI.HolyRingHoleScreen = 1

function Equip_HolyRingUI:Init()
end

function Equip_HolyRingUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Equip_HolyRingUI:InitUI()
  self.EquipRuneTemplate = UIUtility.BindUIContainerTemp(self.RingItem, LuaComponentTemplates.HolyRingItemDataTemplate, self)
end

function Equip_HolyRingUI:RegistUIEvents()
  self.HolyRing_Item:SetOnClick(self, self.HolyRing_ItemOnClick)
  self.descBtn:SetOnClick(self, self.descBtnOnClick)
  self.btn_close:SetOnClick(self, self.btn_closeOnClick)
  self.chooseRing:SetOnDropDownValueChanged(self, self.DropDownChannel)
end

function Equip_HolyRingUI:HolyRing_ItemOnClick(control)
end

function Equip_HolyRingUI:descBtnOnClick(control)
end

function Equip_HolyRingUI:btn_closeOnClick(control)
  UIManager.Hide(UIID.Equip_HolyRingUI)
end

function Equip_HolyRingUI:DropDownChannel(control, index)
  if self.HolyRingHoleScreen ~= index + 1 then
    self.HolyRingHoleScreen = index + 1
  end
  self:HolyRingBagChange()
end

function Equip_HolyRingUI:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function Equip_HolyRingUI:RegistEvents()
  self:RegistEvent(Event.HolyRingBagChange, self.HolyRingBagChange, self)
  self:RegistEvent(Event.HolyRingEquip, self.HolyRingEquip, self)
  self:RegistEvent(Event.HolyRingWearChange, self.RefreshHolyRingItem, self)
end

function Equip_HolyRingUI:RefreshHolyRingItem()
  local holyRingHoleData = gameMgr:GetAvatarManager():GetMainPlayer():GetHolyRingDataMgr():GetHolyRingHoleData()
  if not holyRingHoleData then
    return
  end
  self.holyRingType = {}
  for i, v in pairs(HolyRingType) do
    table.insert(self.holyRingType, i)
  end
  table.sort(self.holyRingType, function(a, b)
    return a < b
  end)
  self.skillBuff = {}
  local Count = 1
  local default = {
    15000011,
    15001011,
    15002011,
    15003011,
    15004011
  }
  for i, v in ipairs(self.holyRingType) do
    for j = 1, table.count(holyRingHoleData) do
      if holyRingHoleData[j].HolyRingHoleItemData ~= nil then
        local buffList = gameMgr:GetAvatarManager():GetMainPlayer():GetHolyRingDataMgr():GetHolyRingHoleDataSkillBuff(holyRingHoleData[j].HolyRingHoleItemData.ItemId)
        if v == 901 and v == holyRingHoleData[j].HolyRingHoleItemData.HolyRingType then
          self:HolyRingItemBuffType(buffList, Count, v, true)
        elseif v == 903 and v == holyRingHoleData[j].HolyRingHoleItemData.HolyRingType then
          self:HolyRingItemBuffType(buffList, Count, v, true)
        elseif v == holyRingHoleData[j].HolyRingHoleItemData.HolyRingType then
          self:HolyRingItemBuffType(buffList, Count, v, true)
        end
      end
    end
    if self.skillBuff[Count] == nil or self.skillBuff[Count] == {} then
      local buffList = gameMgr:GetAvatarManager():GetMainPlayer():GetHolyRingDataMgr():GetHolyRingHoleDataSkillBuff(default[Count])
      if v == 901 then
        self:HolyRingItemBuffType(buffList, Count, v, false)
      elseif v == 903 then
        self:HolyRingItemBuffType(buffList, Count, v, false)
      else
        self:HolyRingItemBuffType(buffList, Count, v, false)
      end
    end
    Count = Count + 1
  end
  local bagSkillShow
  for i, v in ipairs(self.skillBuff) do
    if bagSkillShow == nil then
      bagSkillShow = self:RefreshAttribute(v)
    else
      bagSkillShow = bagSkillShow .. "\n" .. self:RefreshAttribute(v)
    end
  end
  self.lab_des:SetText(bagSkillShow)
  self:DisplayActivated()
end

function Equip_HolyRingUI:HolyRingItemBuffType(data, count, index, bol)
  local buffList = {
    typeId = 0,
    min = 0,
    max = 0,
    buffMy = {
      one = 0,
      twe = 0,
      three = 0
    },
    buffOther = {
      one = 0,
      twe = 0,
      three = 0
    },
    bool = false
  }
  if self.skillBuff[count] then
    buffList = self.skillBuff[count]
  end
  buffList.typeId = data.typeId
  buffList.min = data.min
  buffList.max = data.max
  if index == 901 then
    buffList.buffMy.one = buffList.buffMy.one + tonumber(data.buffMy[1])
    buffList.buffMy.twe = tonumber(data.buffMy[2])
    buffList.buffMy.three = tonumber(data.buffMy[3])
    self.skillBuff[count] = buffList
  elseif index == 903 then
    buffList.buffMy.one = buffList.buffMy.one + tonumber(data.buffMy[1])
    buffList.buffMy.twe = tonumber(data.buffMy[2])
    self.skillBuff[count] = buffList
  else
    if data.buffMy and 0 < #data.buffMy and data.buffMy ~= "0" then
      buffList.buffMy.one = buffList.buffMy.one + tonumber(data.buffMy[1])
    end
    if data.buffOther and 0 < #data.buffOther and data.buffOther ~= "0" then
      buffList.buffOther.one = buffList.buffOther.one + tonumber(data.buffOther[1])
    end
  end
  buffList.bool = bol
  self.skillBuff[count] = buffList
end

function Equip_HolyRingUI:HolyRingBagChange()
  local equipData = self:GetEquipScreen(self.HolyRingHoleScreen)
  for i, v in ipairs(equipData) do
    function v.OnClick()
      self:OnClick(v)
    end
  end
  if equipData ~= nil and equipData ~= {} then
    self.EquipRuneTemplate:SetData(equipData)
  end
end

function Equip_HolyRingUI:HolyRingEquip()
  local index = gameMgr:GetAvatarManager():GetMainPlayer():GetHolyRingDataMgr().HolyRingIndex
  local itemId = gameMgr:GetAvatarManager():GetMainPlayer():GetHolyRingDataMgr().ItemInfoId
  local holyRingHoleData = gameMgr:GetAvatarManager():GetMainPlayer():GetHolyRingDataMgr():GetHolyRingHoleData()
  if itemId and 0 < index and holyRingHoleData[index]:GetHolyRingHoleUnlockState() then
    networkRequest.ReqPutOnReplaceHolyRing(itemId, index)
    if index < 9 then
      gameMgr:GetAvatarManager():GetMainPlayer():GetHolyRingDataMgr().HolyRingIndex = index + 1
    else
      gameMgr:GetAvatarManager():GetMainPlayer():GetHolyRingDataMgr().HolyRingIndex = 1
    end
    if UIManager.IsVisible(UIID.EffectTipUI) then
      EventManager.Dispatch(Event.TipEffect, {
        name = "Eff_UI_hr_zhuangbeichenggong",
        effectTime = 1
      })
    else
      UIManager.Show(UIID.EffectTipUI, {
        name = "Eff_UI_hr_zhuangbeichenggong",
        effectTime = 1
      })
    end
  else
    FloatingTipUtility.QuickMsg("Ch\198\176a ch\225\187\141n \195\180 Th\195\161nh Ho\195\160n")
  end
end

function Equip_HolyRingUI:OnClick(data)
  for i, v in pairs(self.EquipRuneTemplate.items) do
    if v.itemTemp and v.itemTemp.data.ItemInfo then
      v.itemTemp:RefreshSrecct(v.itemTemp.data.ItemInfo.id == data.ItemInfo.id)
    end
  end
end

function Equip_HolyRingUI:GetEquipScreen(Id)
  return self:GetSortScreenEquipRingType(Id)
end

function Equip_HolyRingUI:GetSortScreenEquipRingType(id)
  local BagData = self:GetHolyRingBag()
  if not BagData then
    return
  end
  if id == 1 then
    self.Bag = {}
    self.holyringtype = {}
    for i, v in pairs(HolyRingType) do
      table.insert(self.holyringtype, i)
    end
    table.sort(self.holyringtype, function(a, b)
      return a < b
    end)
    for i, v in pairs(self.holyringtype) do
      self.bagitem = {}
      for x, y in ipairs(BagData) do
        if v == y.HolyRingType then
          table.insert(self.bagitem, y)
        end
      end
      table.sort(self.bagitem, function(a, b)
        return a.Quality > b.Quality
      end)
      for n, m in ipairs(self.bagitem) do
        table.insert(self.Bag, m)
      end
    end
    BagData = self.Bag
  elseif id == 2 then
    table.sort(BagData, function(a, b)
      return a.HolyRingType < b.HolyRingType
    end)
    table.sort(BagData, function(a, b)
      return a.Quality > b.Quality
    end)
  end
  return BagData or {}
end

function Equip_HolyRingUI:GetHolyRingBag()
  local holyRingBagData = gameMgr:GetAvatarManager():GetMainPlayer():GetHolyRingDataMgr():GetHolyRingBagData()
  if not holyRingBagData then
    return {}
  end
  local BagData = {}
  for i, v in ipairs(holyRingBagData) do
    table.insert(BagData, v)
  end
  return BagData or {}
end

function Equip_HolyRingUI:RefreshAttribute(skillData)
  local skillShow
  if not skillData.bool then
    if skillData.typeId then
      local Text = ClientTable.cfg_Ui_wordManager:GetUi_wordCount(HolyRingTypeEnum[skillData.typeId])
      skillShow = string.GetColorText(Text, ItemQuality2ColorDic[10])
    end
    if skillShow then
      skillShow = skillShow .. "  [ " .. string.GetColorText("Ch\198\176a k\195\173ch ho\225\186\161t", ItemQuality2ColorDic[10]) .. " ]"
      skillShow = skillShow .. "\n" .. self:ShowText(skillData.typeId, skillData, 10) .. "\r\n"
    end
  else
    if skillData.typeId then
      local Text = ClientTable.cfg_Ui_wordManager:GetUi_wordCount(HolyRingTypeEnum[skillData.typeId])
      skillShow = string.GetColorText(Text, ItemQuality2ColorDic[1])
    end
    if skillShow then
      skillShow = skillShow .. "  [ " .. string.GetColorText("\196\144\195\163 k\195\173ch ho\225\186\161t", ItemQuality2ColorDic[5]) .. " ]"
      skillShow = skillShow .. "\n" .. self:ShowText(skillData.typeId, skillData, 0) .. "\r\n"
    end
  end
  return skillShow
end

function Equip_HolyRingUI:ShowText(id, data, index)
  local attributeTableText
  if id == 2211000 then
    local Text = ClientTable.cfg_Ui_wordManager:GetUi_wordCount(HolyRingEnumSkillShow[id])
    attributeTableText = string.format(string.GetColorText(Text, ItemQuality2ColorDic[index]), tonumber(data.buffOther.one) / 100)
  elseif id == 2212000 then
    local Text = ClientTable.cfg_Ui_wordManager:GetUi_wordCount(HolyRingEnumSkillShow[id])
    attributeTableText = string.format(string.GetColorText(Text, ItemQuality2ColorDic[index]), tonumber(data.buffMy.one) / 100, tonumber(data.buffMy.three) / 100)
  elseif id == 2213000 then
    local Text = ClientTable.cfg_Ui_wordManager:GetUi_wordCount(HolyRingEnumSkillShow[id])
    attributeTableText = string.format(string.GetColorText(Text, ItemQuality2ColorDic[index]), tonumber(data.buffMy.one) / 100)
  elseif id == 2214000 then
    local Text = ClientTable.cfg_Ui_wordManager:GetUi_wordCount(HolyRingEnumSkillShow[id])
    attributeTableText = string.format(string.GetColorText(Text, ItemQuality2ColorDic[index]), tonumber(data.buffOther.one) / 100)
  elseif id == 2215000 then
    local Text = ClientTable.cfg_Ui_wordManager:GetUi_wordCount(HolyRingEnumSkillShow[id])
    attributeTableText = string.format(string.GetColorText(Text, ItemQuality2ColorDic[index]), tonumber(data.buffMy.one) / 100, -tonumber(data.buffOther.one) / 100)
  end
  return attributeTableText
end

function Equip_HolyRingUI:DisplayActivated()
  local GetHolyRingHoleData = gameMgr:GetAvatarManager():GetMainPlayer():GetHolyRingDataMgr():GetHolyRingHoleData()
  
  local function Activated()
    local skill = {}
    for i, v in pairs(HolyRingType) do
      local count = 0
      for j, k in ipairs(GetHolyRingHoleData) do
        if k.HolyRingHoleItemData and k:GetHolyRingHoleUnlockState() and k.HolyRingHoleItemData.HolyRingType == i then
          count = count + 1
        end
      end
      if 0 < count then
        table.insert(skill, count)
      end
    end
    return skill
  end
  
  if self.skillDisplayActivated == nil then
    self.skillDisplayActivated = {}
    self.skillDisplayActivated = Activated()
  else
    local skillDisplayActivated = {}
    skillDisplayActivated = Activated()
    if table.count(skillDisplayActivated) > table.count(self.skillDisplayActivated) then
      if self.waitEffectTipsUITimeCoroutine then
        Coroutine.Stop(self.waitEffectTipsUITimeCoroutine)
        self.waitEffectTipsUITimeCoroutine = nil
      end
      self.waitEffectTipsUITimeCoroutine = Coroutine.Start(self.WaitEffectTipsUITime, self)
    end
    self.skillDisplayActivated = skillDisplayActivated
  end
end

function Equip_HolyRingUI:WaitEffectTipsUITime()
  Coroutine.Wait(1)
  if UIManager.IsVisible(UIID.EffectTipUI) then
    EventManager.Dispatch(Event.TipEffect, {
      name = "Eff_UI_hr_jinengyijihuo",
      effectTime = 1
    })
  else
    UIManager.Show(UIID.EffectTipUI, {
      name = "Eff_UI_hr_jinengyijihuo",
      effectTime = 1
    })
  end
end

function Equip_HolyRingUI:Refresh()
  self:HolyRingBagChange()
  self:RefreshHolyRingItem()
end

function Equip_HolyRingUI:OnHide()
end

function Equip_HolyRingUI:OnDestroy()
end
