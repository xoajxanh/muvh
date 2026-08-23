Activity_SeaChestUI = class(BaseUI)
Activity_SeaChestUI.layer = UILayer.Panel
Activity_SeaChestUI.orderInLayer = 500
Activity_SeaChestUI.hideType = UIHideType.WaitDestroy
Activity_SeaChestUI.hideFunc = UIHideFunc.MoveOutOfScreen
Activity_SeaChestUI.escClose = UIEscClose.DontClose

function Activity_SeaChestUI:InitControls()
  self.btn_closeBg = self:GetControl("btn_closeBg")
  self.btn_close = self:GetControl("img_bg/group_right/btn_close")
  self.go_server = self:GetControl("img_bg/go_server")
  self.grid_group = self:GetControl("img_bg/grid_group")
  self.key_count_txt = self:GetControl("img_bg/img_keybg/img_icon/Text")
  self.go_integral = self:GetControl("img_bg/go_integral")
  self.grid_group_item = self:GetControl("img_bg/grid_group/Viewport/Content/lab_tab")
  self.btn_3DItem1 = self:GetControl("img_bg/go_server/item_group/btn_3DItem1")
  self.item_group = self:GetControl("img_bg/go_server/item_group")
  self.btn_3DItem2 = self:GetControl("img_bg/go_server/item_group/btn_3DItem2")
  self.btn_3DItem3 = self:GetControl("img_bg/go_server/item_group/btn_3DItem3")
  self.btn_3DItem4 = self:GetControl("img_bg/go_server/item_group/btn_3DItem4")
  self.btn_3DItem5 = self:GetControl("img_bg/go_server/item_group/btn_3DItem5")
  self.btn_3DItem6 = self:GetControl("img_bg/go_server/item_group/btn_3DItem6")
  self.btn_free = self:GetControl("img_bg/go_server/btn_group/btn_free")
  self.key_count_txt = self:GetControl("img_bg/go_server/btn_group/btn_free/img_bg/lab_num")
  self.btn_diamond = self:GetControl("img_bg/go_server/btn_group/btn_diamond")
  self.btn_diamond_count = self:GetControl("img_bg/go_server/btn_group/btn_diamond/img_bg/lab_num")
  self.btn_reset = self:GetControl("img_bg/go_server/btn_group/btn_reset")
  self.btn_3DItem = self:GetControl("img_bg/go_server/btn_3DItem")
  self.img_geticon = self:GetControl("img_bg/go_server/btn_3DItem/img_icon/icon")
  self.tog_allRecover = self:GetControl("img_bg/group_right/tog_allRecover")
  self.btn_descBtn = self:GetControl("img_bg/group_right/descBtn")
  self.zhuanpan_0 = self:GetControl("img_bg/bg/img_bgBg/zhuanpan_0")
  self.zhuanpan_1 = self:GetControl("img_bg/bg/img_bgBg/zhuanpan_1")
  self.zhuanpan_2 = self:GetControl("img_bg/bg/img_bgBg/zhuanpan_2")
  self.zhuanpan_3 = self:GetControl("img_bg/bg/img_bgBg/zhuanpan_3")
end

function Activity_SeaChestUI:Init()
  self.currindex = {}
  self.prefabs_anmations = "Activity_SeaChestUI_animations"
end

function Activity_SeaChestUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Activity_SeaChestUI:InitUI()
  self.btn_closeBg:SetOnClick(self, self.btn_closeBgOnClick)
  self.btn_close:SetOnClick(self, self.btn_closeOnClick)
  self.btn_diamond:SetOnClick(self, self.OnPlayAniamionDiamond)
  self.btn_free:SetOnClick(self, self.OnPlayAniamionFree)
  self.btn_reset:SetOnClick(self, self.OnClickReset)
  self.btn_descBtn:SetOnClick(self, self.Onbtn_descBtnClick)
  self.tog_allRecover:SetOnToggleChanged(self, self.OnToggleChangedAnimation)
  self:OnInitItem()
  self:OnInitUIPanel()
  self:OnInitEnPlayAnimaion()
  self.img_geticonSize = self.img_geticon.transform.localScale
  self.zhuanpanCtrList = {
    [1] = self.zhuanpan_0,
    [2] = self.zhuanpan_1,
    [3] = self.zhuanpan_2,
    [4] = self.zhuanpan_3
  }
  self.speed = 0
end

function Activity_SeaChestUI:RegistUIEvents()
end

function Activity_SeaChestUI:OnBagChange()
  if self.chestdata then
    if self.chestdata.setp == 3 or self.chestdata.setp == 4 then
      local cost = ClientTable.cfg_SeaChest_costManager:TryGetValue(tonumber(self.chestdata.type), "type").cost
      local str = ""
      if 2 <= #cost then
        local cion = BagInfoData:GetItemTotalCountByItemIdFromIndexDic(tonumber(cost[1]))
        if cion >= tonumber(cost[2]) then
          str = string.GetColorText(cion .. "/" .. cost[2], ItemQuality2ColorDic[5])
        else
          str = string.GetColorText(cion .. "/" .. cost[2], ItemQuality2ColorDic[12])
        end
        self.btn_diamond_count:SetText(str)
      end
    elseif self.chestdata.setp == 1 or self.chestdata.setp == 2 then
      local cost = ClientTable.cfg_SeaChest_costManager:TryGetValue(tonumber(self.chestdata.type), "type").costStone
      local str = ""
      if 2 <= #cost then
        local cion = BagInfoData:GetItemTotalCountByItemIdFromIndexDic(tonumber(cost[1]))
        if cion >= tonumber(cost[2]) then
          str = string.GetColorText(cion .. "/" .. cost[2], ItemQuality2ColorDic[5])
        else
          str = string.GetColorText(cion .. "/" .. cost[2], ItemQuality2ColorDic[12])
        end
        self.btn_diamond_count:SetText(str)
      end
      self:OnReacherKeyCount(str)
    end
  end
end

function Activity_SeaChestUI:Onbtn_descBtnClick()
  UIManager.Show(UIID.Seachest_DescUI, {
    id = 1096,
    data = self.chestdata
  })
end

function Activity_SeaChestUI:OnInitEnPlayAnimaion(control)
  local prefabs = PlayerPrefs.GetString(self.prefabs_anmations, "")
  if prefabs ~= "" then
    self.tog_allRecover:SetIsOn(true)
  else
    self.tog_allRecover:SetIsOn(false)
  end
end

function Activity_SeaChestUI:OnToggleChangedAnimation(control, ison)
  if ison then
    PlayerPrefs.SetString(self.prefabs_anmations, "andmion")
  else
    PlayerPrefs.DeleteKey(self.prefabs_anmations)
  end
end

function Activity_SeaChestUI:OnClickReset(control)
  if self.chestdata then
    local data = ClientTable.cfg_Ui_promptwordManager:GetKoreaTipData(69)
    if data then
      UIManager.Show(UIID.PromptTipUI, {
        title = data.title,
        autoClose = false,
        textContent = data.content,
        okText = data.rightButton,
        ok = function()
          networkRequest.ReqDeepSeaTreasureReset(self.chestdata.type)
        end
      })
    end
  end
end

function Activity_SeaChestUI:OnReacherRightDara(_, msg, isreacher)
  if isreacher then
  else
    self.chestdata = msg
    if self.randomtime and self.tog_allRecover:GetIsOn() == false then
      return
    end
  end
  self.btn_free:SetActive(self.chestdata.setp == 1 or self.chestdata.setp == 2)
  self.btn_diamond:SetActive(self.chestdata.setp == 3 or self.chestdata.setp == 4)
  self.btn_reset:SetActive(self.chestdata.setp == 3 or self.chestdata.setp == 4)
  for i, v in ipairs(self.chestdata.rewardpond) do
    self:OnReacherIteminfo(i, v, self.chestdata.setp)
  end
  if self.chestdata.setp == 3 or self.chestdata.setp == 4 then
    local cost = ClientTable.cfg_SeaChest_costManager:TryGetValue(tonumber(self.chestdata.type), "type").cost
    local str = ""
    if 2 <= #cost then
      local cion = BagInfoData:GetItemTotalCountByItemIdFromIndexDic(tonumber(cost[1]))
      if cion >= tonumber(cost[2]) then
        str = string.GetColorText(cion .. "/" .. cost[2], ItemQuality2ColorDic[5])
      else
        str = string.GetColorText(cion .. "/" .. cost[2], ItemQuality2ColorDic[12])
      end
      self.btn_diamond_count:SetText(str)
    end
  end
  self:OnBagChange()
  self.img_geticon:SetActive(false)
  for i = 1, #self.zhuanpanCtrList do
    self.zhuanpanCtrList[i].transform.eulerAngles = Vector3(0, 0, 0)
  end
  self.speed = 0
  local go_model = self.btn_3DItem:GetChild("go_model")
  for i = 1, go_model.transform.childCount do
    Destroy(go_model.transform:GetChild(i - 1).gameObject)
  end
  if (self.chestdata.setp == 2 or self.chestdata.setp == 4) and #self.chestdata.itemInfos then
    self:OnPlayerEnd()
    UIManager.Show(UIID.Tip_SeaChestReward, self.chestdata)
    local iteminfo_item = ClientTable.cfg_Item_itemManager:TryGetValue(self.chestdata.itemInfos[1].itemId)
    if iteminfo_item then
      if iteminfo_item.type == 29 then
        local iconId = iteminfo_item.icon
        self:SetSprite("Atlas_Common", tostring(iconId), self.img_geticon, true)
        self.img_geticon.transform.localScale = self.img_geticonSize * (iteminfo_item.pngSize / 100)
        self.img_geticon:SetActive(true)
      else
        local itemCellData = ItemCellData()
        local itemData = ItemUtility.GenerateItemData(iteminfo_item.id)
        itemCellData:RefreshData(itemData)
        ItemUtility.ShowItemCell(self.btn_3DItem, itemCellData, self, true)
      end
    end
  end
end

function Activity_SeaChestUI:OnReacherIteminfo(i, info, iszuanshi)
  local item = self.item_btnList[i]
  if item then
    item:SetActive(true)
    local dataitem = self:GetControl(item.path .. "/pro_icon/lab_pro")
    if dataitem then
      dataitem:SetText(tostring(tonumber(info.probability) * 100) .. "%")
    end
    local lab_name = self:GetControl(item.path .. "/pro_icon/lab_name")
    if lab_name then
      if iszuanshi == 1 or iszuanshi == 2 then
        lab_name:SetText(info.data.freeName)
      else
        lab_name:SetText(info.data.diamondName)
      end
    end
    local item_image = self:GetControl(item.path .. "/img_icon")
    if item_image then
      if iszuanshi == 1 or iszuanshi == 2 then
        if item_image.image.sprite == nil or item_image.image.sprite.name ~= tostring(info.data.iconf) then
          self:SetSprite("Atlas_Common", info.data.iconf, item_image)
        end
      elseif item_image.image.sprite == nil or item_image.image.sprite.name ~= tostring(info.data.icond) then
        self:SetSprite("Atlas_Common", info.data.icond, item_image)
      end
    end
    local img_select = self:GetControl(item.path .. "/img_select")
    if img_select then
      img_select:SetActive(false)
    end
  end
end

function Activity_SeaChestUI:OnInitItem()
  self.item_btnList = {}
  for i = 1, 6 do
    local btn = self:GetControl("img_bg/go_server/item_group/btn_3DItem_" .. i)
    btn:SetActive(false)
    btn:SetOnClickParam(self, self.OnItemBtn, i)
    local btndesc = self:GetControl("img_bg/go_server/item_group/btn_3DItem_" .. i .. "/img_xijie")
    btndesc:SetActive(true)
    btndesc:SetOnClickParam(self, self.OnItemBigBtn, i)
    table.insert(self.item_btnList, btn)
  end
end

local function OnSubMenuCreate(ctr)
  ctr.lab_tab_light = UIControl(ctr.transform, "lab_tab_light")
  ctr.lab_tab_dark = UIControl(ctr.transform, "lab_tab_dark")
  ctr.lab_typeName_dark = UIControl(ctr.transform, "lab_tab_dark/lab_typeName")
  ctr.lab_typeName_light = UIControl(ctr.transform, "lab_tab_light/lab_typeName")
end

local function OnSubMenuShow(ctr, index, data, ui)
  if data == nil then
    return
  end
  ctr.lab_typeName_dark:SetText(data.name)
  ctr.lab_typeName_light:SetText(data.name)
  if tonumber(ui.currindex) == tonumber(data.itemid) then
    ctr.lab_tab_light:SetActive(true)
    ui.currobj = ctr.lab_tab_light
  end
  ctr.data = data
  ctr:SetOnClick(ui, ui.OnTitleOnClick)
end

function Activity_SeaChestUI:OnTitleOnClick(control)
  if control then
    if tonumber(control.data.itemid) == tonumber(self.currindex) then
      return
    else
      if self.currobj then
        self.currobj:SetActive(false)
      end
      control.lab_tab_light:SetActive(true)
      self.currindex = tonumber(control.data.itemid)
      self.currobj = control.lab_tab_light
      self:OnBagChange()
      local id = ClientTable.cfg_SeaChest_rewardManager:GetTier(tonumber(control.data.itemid))
      networkRequest.ReqDeepSeaTreasureInfo(id)
    end
  end
end

function Activity_SeaChestUI:OnInitUIPanel(control)
  self.combineItemContainer = UIContainer(self.grid_group_item, self, OnSubMenuCreate, OnSubMenuShow)
end

function Activity_SeaChestUI:OnItemBtn(control)
  if self.chestdata then
    local tempdata = self.chestdata.rewardpond[control.param]
    if tempdata then
      local isreacher = false
      if self.chestdata.setp == 1 or self.chestdata.setp == 2 then
        isreacher = true
      end
      UIManager.Show(UIID.SeaChest_TipsUI, {data = tempdata, isreacher = isreacher})
    end
  end
end

function Activity_SeaChestUI:OnItemBigBtn(control)
  if self.chestdata then
    local tempdata = self.chestdata.rewardpond[control.param]
    if tempdata then
      local isreacher = false
      local titlename = ""
      if self.chestdata.setp == 1 or self.chestdata.setp == 2 then
        isreacher = true
        titlename = tempdata.data.freeName
      else
        titlename = tempdata.data.diamondName
      end
      local data = gameMgr:GetAvatarManager():GetMainPlayer():GetActivity_SeaChestData():GetTreasureDataForIndex(control.param)
      UIManager.Show(UIID.SeaChest_DetailTipsUI, {
        data = data,
        isreacher = isreacher,
        titlename = titlename
      })
    end
  end
end

function Activity_SeaChestUI:OnReacherKeyCount(count)
  self.key_count_txt:SetText(count)
end

function Activity_SeaChestUI:btn_ShowKeyOnClick(control)
  local itemData = ItemUtility.GenerateItemData(self.currindex)
  itemData.tipsPosition = Vector3(-300, 150, 0)
  UIManager.Show(UIID.ItemTipUI, {
    item = itemData,
    rightOperate = EItemOperateType.Show,
    ctrl = control
  })
end

function Activity_SeaChestUI:btn_closeBgOnClick(control)
end

function Activity_SeaChestUI:OnPlayAniamionDiamond(control)
  if self.randomtime then
    return
  else
    local costdiamond = ""
    if self.chestdata.setp == 3 or self.chestdata.setp == 4 then
      local cost = ClientTable.cfg_SeaChest_costManager:TryGetValue(tonumber(self.chestdata.type), "type").cost
      if 2 <= #cost then
        local cion = BagInfoData:GetItemTotalCountByItemIdFromIndexDic(tonumber(cost[1]))
        costdiamond = cost[2]
        if cion < tonumber(cost[2]) then
          local datatip = ClientTable.cfg_Ui_wordManager:TryGetValue("SeaChestDimondTips")
          if datatip and datatip.content then
            FloatingTipUtility.QuickMsg(datatip.content)
          end
          return
        end
      end
    end
    local data = ClientTable.cfg_Ui_promptwordManager:GetKoreaTipData(71)
    if data then
      UIManager.Show(UIID.PromptTipUI, {
        title = data.title,
        autoClose = false,
        textContent = string.format(data.content, costdiamond),
        okText = data.rightButton,
        ok = function()
          networkRequest.ReqDeepSeaTreasureAward(self.chestdata.type)
          if self.tog_allRecover:GetIsOn() == true then
          else
            self:OnBtnXunbao(control)
          end
        end
      })
    end
  end
end

function Activity_SeaChestUI:OnBtnXunbao(control)
  control.gameObject:SetActive(false)
  self.playerstate = true
  self:OnReFreees(6)
  Timer.Start(1.5, function()
    control.gameObject:SetActive(true)
    self.playerstate = false
    Timer.Stop(self.randomtime)
    self.randomtime = nil
    self:OnPlayerEnd()
    self:OnReacherRightDara(1, 1, 1)
  end)
end

function Activity_SeaChestUI:OnPlayAniamionFree(control)
  if self.randomtime then
    return
  else
    if self.chestdata.setp == 1 or self.chestdata.setp == 2 then
      local keycount = BagInfoData:GetItemTotalCountByItemIdFromIndexDic(tonumber(self.currindex))
      if keycount and keycount <= 0 then
        local datatip = ClientTable.cfg_Ui_wordManager:TryGetValue("SeaChestKeyTips")
        if datatip and datatip.content then
          FloatingTipUtility.QuickMsg(datatip.content)
        end
        return
      end
    end
    local data = ClientTable.cfg_Ui_promptwordManager:GetKoreaTipData(70)
    if data then
      UIManager.Show(UIID.PromptTipUI, {
        title = data.title,
        autoClose = false,
        textContent = string.format(data.content, "1"),
        okText = data.rightButton,
        ok = function()
          networkRequest.ReqDeepSeaTreasureAward(self.chestdata.type)
          if self.tog_allRecover:GetIsOn() == true then
          else
            self:OnBtnXunbao(control)
          end
        end
      })
    end
  end
end

function Activity_SeaChestUI:OnPlayerEnd(count)
  local currindex = -1
  if self.chestdata then
    for i, v in ipairs(self.chestdata.rewardpond) do
      if v.data.id == self.chestdata.rewardConfigId then
        currindex = i
      end
    end
  end
  for i, v in ipairs(self.item_btnList) do
    local item_image = self:GetControl(v.path .. "/img_select")
    if i == currindex then
      item_image:SetActive(true)
    else
      item_image:SetActive(false)
    end
  end
end

function Activity_SeaChestUI:OnReFreees(count)
  if self.playerstate == false then
    return
  end
  if count > #self.item_btnList then
    self:OnReFreees(0)
    return
  end
  if self.item_btnList then
    local ran = Mathf.Random() * 0.2
    self.randomtime = Timer.Start(ran, function()
      count = count + 1
      for i, v in ipairs(self.item_btnList) do
        local item_image = self:GetControl(v.path .. "/img_select")
        if i == count then
          item_image:SetActive(true)
        else
          item_image:SetActive(false)
        end
      end
      self:OnReFreees(count)
    end)
  end
end

function Activity_SeaChestUI:btn_closeOnClick(control)
  UIManager.Hide(UIID.Activity_SeaChestUI)
end

function Activity_SeaChestUI:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function Activity_SeaChestUI:RegistEvents()
  self:RegistEvent(Event.Activity_SeaChestDatechange, self.OnReacherRightDara, self)
  self:RegistEvent(Event.Activity_SeaChestTitledata, self.OnReacherTitle, self)
  self:RegistEvent(Event.Bag_ResBagChange, self.OnBagChange, self)
end

function Activity_SeaChestUI:Refresh()
  if self.args then
    networkRequest.ReqDeepSeaTreasureCanReward()
  end
end

function Activity_SeaChestUI:OnReacherTitle(_, titledata)
  if self.args then
    self.currindex = tonumber(self.args.itemId)
    self:OnBagChange()
    if self.currobj then
      self.currobj:SetActive(false)
    end
    self.combineItemContainer:SetData(titledata, true)
    local id = ClientTable.cfg_SeaChest_rewardManager:GetTier(self.args.itemId)
    networkRequest.ReqDeepSeaTreasureInfo(id)
  end
end

function Activity_SeaChestUI:Update()
  if self.playerstate == true then
    self.speed = self.speed + Time.deltaTime * 0.5
    for i = 1, #self.zhuanpanCtrList do
      local towards
      if i % 2 == 0 then
        towards = 1
      else
        towards = -1
      end
      self.zhuanpanCtrList[i].transform.eulerAngles = Vector3(0, 0, self.zhuanpanCtrList[i].transform.eulerAngles.z + 45 * self.speed * towards)
    end
  end
end

function Activity_SeaChestUI:OnHide()
end

function Activity_SeaChestUI:OnDestroy()
  self:UnRegistEvent(Event.Activity_SeaChestDatechange, self.OnReacherRightDara, self)
  self:UnRegistEvent(Event.Bag_ResBagChange, self.OnBagChange, self)
end
