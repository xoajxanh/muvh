Skill_SetSkillUI = class(BaseUI)
Skill_SetSkillUI.layer = UILayer.Panel
Skill_SetSkillUI.orderInLayer = 1
Skill_SetSkillUI.hideType = UIHideType.Destroy
Skill_SetSkillUI.hideFunc = UIHideFunc.MoveOutOfScreen
Skill_SetSkillUI.escClose = UIEscClose.DontClose

function Skill_SetSkillUI:InitControls()
  self.btn_close = self:GetControl("img_bg/btn_close")
  self.img_drag = self:GetControl("img_bg/img_drag")
  self.dragItem = self:GetControl("img_bg/dragItem")
  self.tog_allShowModel = self:GetControl("img_bg/img_setSkillFrame/tog_allShowModel")
  self.tog_turnShowModel = self:GetControl("img_bg/img_setSkillFrame/tog_turnShowModel")
  self.tog_skill = self:GetControl("img_bg/img_setSkillFrame/tog_skill")
  self.tog_item = self:GetControl("img_bg/img_setSkillFrame/tog_item")
  self.btn_reset = self:GetControl("img_bg/img_setSkillFrame/btn_reset")
  self.go_allShowModel = self:GetControl("img_bg/img_setSkillFrame/go_allShowModel")
  self.go_turnShowModel = self:GetControl("img_bg/img_setSkillFrame/go_turnShowModel")
  self.img_setItemFrame = self:GetControl("img_bg/img_setItemFrame")
  self.img_selection_all = self:GetControl("img_bg/img_setSkillFrame/go_allShowModel/img_selection")
  self.img_selection_turn = self:GetControl("img_bg/img_setSkillFrame/go_turnShowModel/img_selection")
  self.img_selection_item = self:GetControl("img_bg/img_selection")
  self.turn_img_skill_zhu = self:GetControl("img_bg/img_setSkillFrame/go_turnShowModel/img_setMainSkill/img_skill_zhu")
  self.all_img_skill_zhu = self:GetControl("img_bg/img_setSkillFrame/go_allShowModel/img_setMainSkill/img_skill_zhu")
  self.turnPanSkills = {
    nil,
    nil,
    nil,
    nil,
    nil,
    nil,
    nil,
    nil
  }
  self.allPanSkills = {
    nil,
    nil,
    nil,
    nil,
    nil,
    nil,
    nil,
    nil
  }
  self.setitems = {
    nil,
    nil,
    nil,
    nil,
    nil
  }
  for i = 1, 7 do
    self.allPanSkills[i] = UIControl(self.go_allShowModel.transform, "img_setSkill" .. tostring(i))
    self.allPanSkills[i]:SetOnClick(self, self.Button_AllPanSkillsSelection)
    self.allPanSkills[i].index = i
    self.allPanSkills[i].type = 0
    self.allPanSkills[i]:SetOnLongPress(self, self.OnLongPress, self.OnDrag, self.OnDragEnd)
  end
  for i = 1, 8 do
    self.turnPanSkills[i] = UIControl(self.go_turnShowModel.transform, "img_setSkill" .. tostring(i))
    self.turnPanSkills[i]:SetOnClick(self, self.Button_TurnPanSkillsSelection)
    self.turnPanSkills[i].index = i
    self.turnPanSkills[i].type = 0
    self.turnPanSkills[i]:SetOnLongPress(self, self.OnLongPress, self.OnDrag, self.OnDragEnd)
  end
  for i = 1, 5 do
    self.setitems[i] = UIControl(self.img_setItemFrame.transform, "img_setItem" .. tostring(i))
    self.setitems[i]:SetOnClick(self, self.Button_ItemsSelection)
    self.setitems[i].itemCellData = ItemCellData()
    self.setitems[i].index = i
    self.setitems[i].type = 1
    self.setitems[i]:SetOnLongPress(self, self.OnLongPressItem, self.OnDragItem, self.OnDragEndItem)
  end
  self.dragItem.itemCellData = ItemCellData()
  self.cur_turn_index = 1
  self.cur_all_index = 1
  self.cur_item_index = 1
  self.img_selection_turn.transform:SetParent(self.turnPanSkills[self.cur_turn_index].transform)
  self.img_selection_all.transform:SetParent(self.allPanSkills[self.cur_all_index].transform)
  self.img_selection_item.transform:SetParent(self.setitems[self.cur_item_index].transform)
  self.img_selection_turn.transform.localPosition = Vector3.New(0, 0, 0)
  self.img_selection_all.transform.localPosition = Vector3.New(0, 0, 0)
  self.img_selection_item.transform.localPosition = Vector3.New(0, 0, 0)
end

function Skill_SetSkillUI:Init()
end

function Skill_SetSkillUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Skill_SetSkillUI:InitUI()
end

function Skill_SetSkillUI:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function Skill_SetSkillUI:OnHide()
  EventManager.Dispatch(Event.Skill_Pan_Changed)
  EventManager.Dispatch(Event.Main_SetItem)
end

function Skill_SetSkillUI:OnDestroy()
end

function Skill_SetSkillUI:RegistUIEvents()
  self.btn_close:SetOnClick(self, self.Button_CloseOnClick)
  self.tog_allShowModel:SetOnToggleChanged(self, self.Tog_AllShowModelOnClick)
  self.tog_turnShowModel:SetOnToggleChanged(self, self.Tog_TurnShowModelOnClick)
  self.tog_skill:SetOnToggleChanged(self, self.Tog_SkillOnClick)
  self.tog_item:SetOnToggleChanged(self, self.Tog_ItemOnClick)
  self.btn_reset:SetOnClick(self, self.Button_ResetOnClick)
end

function Skill_SetSkillUI:Button_CloseOnClick()
  UIManager.Hide(UIID.Skill_SetSkillUI)
end

function Skill_SetSkillUI:Tog_AllShowModelOnClick()
  if self.tog_allShowModel.toggle.isOn then
    self.go_allShowModel:SetActive(true)
    self.go_turnShowModel:SetActive(false)
    SkillSettingData.SetPanMode(EPanModeType.All)
  end
end

function Skill_SetSkillUI:Tog_TurnShowModelOnClick()
  if self.tog_turnShowModel.toggle.isOn then
    self.go_allShowModel:SetActive(false)
    self.go_turnShowModel:SetActive(true)
    SkillSettingData.SetPanMode(EPanModeType.Turn)
  end
end

function Skill_SetSkillUI:Tog_SkillOnClick(control)
  if self.tog_skill.toggle.isOn then
    UIManager.Show(UIID.SkillUI)
    local imgSelection = SkillSettingData.curmode == EPanModeType.All and self.img_selection_all or self.img_selection_turn
    self:SetSelectImgVisible("skill", imgSelection)
  end
  control:GetChild("Img_shrink"):SetActive(self.tog_skill.toggle.isOn)
end

function Skill_SetSkillUI:Tog_ItemOnClick(control)
  if self.tog_item.toggle.isOn then
    UIManager.Show(UIID.NewBagInfoUI)
    self:SetSelectImgVisible("item")
  end
  control:GetChild("Img_shrink"):SetActive(self.tog_item.toggle.isOn)
end

function Skill_SetSkillUI:Button_ResetOnClick()
  SkillSettingData.Clear()
  self:LoadSkillsSetting()
  self:LoadItemsSetting()
end

function Skill_SetSkillUI:SetSelectImgVisible(selectType, skillImgSelection)
  if selectType == "skill" then
    self.img_selection_item:SetActive(false)
    if skillImgSelection then
      skillImgSelection:SetActive(true)
    end
  else
    self.img_selection_item:SetActive(true)
    self.img_selection_turn:SetActive(false)
    self.img_selection_all:SetActive(false)
  end
end

function Skill_SetSkillUI:Button_TurnPanSkillsSelection(control)
  self.img_selection_turn.transform:SetParent(self.turnPanSkills[control.index].transform)
  self.img_selection_turn.transform.localPosition = Vector3.New(0, 0, 0)
  self.cur_turn_index = control.index
  UIManager.Show(UIID.SkillUI)
  self.tog_skill:SetIsOn(true)
  self:SetSelectImgVisible("skill", self.img_selection_turn)
end

function Skill_SetSkillUI:Button_AllPanSkillsSelection(control)
  self.img_selection_all.transform:SetParent(self.allPanSkills[control.index].transform)
  self.img_selection_all.transform.localPosition = Vector3.New(0, 0, 0)
  self.cur_all_index = control.index
  UIManager.Show(UIID.SkillUI)
  self.tog_skill:SetIsOn(true)
  self:SetSelectImgVisible("skill", self.img_selection_all)
end

function Skill_SetSkillUI:Button_ItemsSelection(control)
  self.cur_item_index = control.index
  self.img_selection_item.transform:SetParent(self.setitems[control.index].transform)
  self.img_selection_item.transform.localPosition = Vector3.New(0, 0, 0)
  UIManager.Show(UIID.NewBagInfoUI)
  self.tog_item:SetIsOn(true)
  self:SetSelectImgVisible("item")
end

function Skill_SetSkillUI:RegistEvents()
  self:RegistEvent(Event.Skill_Pan_SetSkill, self.OnSetSkill, self)
  self:RegistEvent(Event.Skill_Pan_DragSkillEnd, self.OnPlaceSkill, self)
  self:RegistEvent(Event.Skill_Pan_SetItem, self.OnSetItem, self)
  self:RegistEvent(Event.Bag_ResBagChange, self.LoadItemsSetting, self)
  self:RegistEvent(Event.Skill_Pan_DragItemEnd, self.OnPlaceItem, self)
  self:RegistEvent(Event.Skill_ResLearnSkill, self.RefreshComboSkill, self)
end

function Skill_SetSkillUI:OnSetSkill(id, skillInfoId)
  if SkillSettingData.curmode == EPanModeType.All then
    self:SetSkill(self.cur_all_index, skillInfoId)
  elseif SkillSettingData.curmode == EPanModeType.Turn then
    self:SetSkill(self.cur_turn_index, skillInfoId)
  end
end

function Skill_SetSkillUI:OnSetItem(id, itemInfoId)
  SkillSettingData.SetManualItem(self.cur_item_index, itemInfoId)
  self:SetItem(self.cur_item_index, itemInfoId)
  EventManager.Dispatch(Event.Main_SetItem, self.cur_item_index, itemInfoId)
end

function Skill_SetSkillUI:SetSkill(curIndex, skillInfoId)
  if skillInfoId < 1 then
    if self.allPanSkills[curIndex] then
      self:SetSprite("Atlas_Common", "ty_bg_skillBg", self.allPanSkills[curIndex])
      SkillSettingData.SetPanAllSkill(curIndex, 0)
    end
    if self.turnPanSkills[curIndex] then
      self:SetSprite("Atlas_Common", "ty_bg_skillBg", self.turnPanSkills[curIndex])
      SkillSettingData.SetPanTurnSkill(curIndex, 0)
    end
    return
  end
  local cfg_skill = ClientTable.cfg_Skill_skillManager:TryGetValue(skillInfoId)
  if cfg_skill ~= nil then
    if self.allPanSkills[curIndex] then
      self:SetSprite("Atlas_Skill", cfg_skill.icon, self.allPanSkills[curIndex])
      SkillSettingData.SetPanAllSkill(curIndex, skillInfoId)
    end
    if self.turnPanSkills[curIndex] then
      self:SetSprite("Atlas_Skill", cfg_skill.icon, self.turnPanSkills[curIndex])
      SkillSettingData.SetPanTurnSkill(curIndex, skillInfoId)
    end
  else
    Debug.LogError("cfg_skill_skill not exist " .. tostring(skillInfoId))
  end
end

function Skill_SetSkillUI:SetItem(curIndex, itemInfoId)
  if itemInfoId < 1 then
    SkillSettingData.SetItem(curIndex, 0)
  else
    for i = 1, #SkillSettingData.skill_use_items do
      if SkillSettingData.skill_use_items[i] == itemInfoId and i ~= curIndex then
        SkillSettingData.SetItem(i, 0)
      end
    end
    SkillSettingData.SetItem(curIndex, itemInfoId)
    self:LoadItemsSetting()
  end
end

function Skill_SetSkillUI:OnPlaceSkill(id, data)
  local pos = data.pos
  local iconRadio = 32
  if SkillSettingData.curmode == EPanModeType.All then
    pos = self.go_allShowModel.transform.worldToLocalMatrix:MultiplyPoint(pos)
    for i, v in pairs(self.allPanSkills) do
      local rectpos = v.transform.localPosition
      local isCollided, dis2 = MathUtility:IsSphereCollided2(pos.x, pos.y, iconRadio, rectpos.x, rectpos.y, iconRadio)
      if isCollided == true then
        self:SetSkill(i, data.id)
        break
      end
    end
  elseif SkillSettingData.curmode == EPanModeType.Turn then
    pos = self.go_turnShowModel.transform.worldToLocalMatrix:MultiplyPoint(pos)
    for i, v in pairs(self.turnPanSkills) do
      local rectpos = v.transform.localPosition
      local isCollided, dis2 = MathUtility:IsSphereCollided2(pos.x, pos.y, iconRadio, rectpos.x, rectpos.y, iconRadio)
      if isCollided == true then
        self:SetSkill(i, data.id)
        break
      end
    end
  end
end

function Skill_SetSkillUI:OnPlaceItem(id, data)
  local pos = data.pos
  local iconRadio = 32
  pos = self.img_setItemFrame.transform.worldToLocalMatrix:MultiplyPoint(pos)
  for i, v in pairs(self.setitems) do
    local rectpos = v.transform.localPosition
    local isCollided, dis2 = MathUtility:IsSphereCollided2(pos.x, pos.y, iconRadio, rectpos.x, rectpos.y, iconRadio)
    if isCollided == true then
      self:SetItem(i, data.id)
      SkillSettingData.SetManualItem(i, data.id)
      break
    end
  end
end

function Skill_SetSkillUI:OnLongPress(control, eventData)
  self:OnDragBegin(control, eventData)
end

function Skill_SetSkillUI:OnDragBegin(control, eventData)
  self.img_drag.transform.position = control.transform.position
  local sprite, spriteId
  if control.type == 0 then
    if SkillSettingData.curmode == EPanModeType.All then
      self.img_drag.id = SkillSettingData.skill_pan_all[control.index]
    elseif SkillSettingData.curmode == EPanModeType.Turn then
      self.img_drag.id = SkillSettingData.skill_pan_turn[control.index]
    end
    if self.img_drag.id == 0 then
      return
    end
    self:SetSkill(control.index, 0)
    sprite = "Atlas_Skill"
    spriteId = ClientTable.cfg_Skill_skillManager:TryGetValue(self.img_drag.id).icon
  else
    self.img_drag.id = SkillSettingData.skill_use_items[control.index]
    if self.img_drag.id == 0 then
      return
    end
    sprite = "Atlas_Icon"
    spriteId = ClientTable.cfg_Item_itemManager:TryGetValue(self.img_drag.id).icon
  end
  self:SetSprite(sprite, spriteId, self.img_drag)
  self.img_drag:SetActive(true)
end

function Skill_SetSkillUI:OnDrag(control, eventData)
  if self.img_drag.id == 0 then
    return
  end
  local pos = self.img_drag.transform.localPosition
  pos.x = pos.x + eventData.delta.x
  pos.y = pos.y + eventData.delta.y
  self.img_drag.transform.localPosition = pos
end

function Skill_SetSkillUI:OnDragEnd(control, eventData)
  if self.img_drag.id == 0 then
    return
  end
  local tpos = self.img_drag.transform.position
  self.img_drag:SetActive(false)
  if control.type == 0 then
    self:OnPlaceSkill(0, {
      id = self.img_drag.id,
      pos = tpos
    })
  else
    self:OnPlaceItem(0, {
      id = self.img_drag.id,
      pos = tpos
    })
  end
end

function Skill_SetSkillUI:OnLongPressItem(control, eventData)
  self.dragItem.transform.position = control.transform.position
  self.dragItem.id = SkillSettingData.skill_use_items[control.index]
  if self.dragItem.id == 0 then
    return
  end
  local itemData = ItemUtility.GenerateItemData(self.dragItem.id)
  itemData.count = nil
  self.dragItem.itemCellData:RefreshData(itemData)
  self.dragItem:SetActive(true)
  SkillSettingData.SetItem(control.index, 0)
  self:LoadItemsSetting()
  ItemUtility.ShowItemCell(self.dragItem, self.dragItem.itemCellData, self, false)
end

function Skill_SetSkillUI:OnDragItem(control, eventData)
  if self.dragItem.id == 0 then
    return
  end
  local pos = self.dragItem.transform.position
  local test = UIManager.uiCamera:ScreenToWorldPoint(Vector2(eventData.position.x, eventData.position.y))
  self.dragItem.transform.position = Vector3(test.x, test.y, pos.z)
end

function Skill_SetSkillUI:OnDragEndItem(control, eventData)
  if self.dragItem.id == 0 then
    return
  end
  self.dragItem:SetActive(false)
  local tpos = self.dragItem.transform.position
  self:OnPlaceItem(0, {
    id = self.dragItem.id,
    pos = tpos
  })
  self.dragItem.itemCellData:Reset()
end

function Skill_SetSkillUI:Refresh()
  if SkillSettingData.curmode == EPanModeType.All then
    self.tog_allShowModel.toggle.isOn = true
    Skill_SetSkillUI:Tog_AllShowModelOnClick()
  elseif SkillSettingData.curmode == EPanModeType.Turn then
    self.tog_turnShowModel.toggle.isOn = true
    Skill_SetSkillUI:Tog_TurnShowModelOnClick()
  end
  self.tog_skill.toggle.isOn = true
  self:LoadSkillsSetting()
  self:LoadItemsSetting()
  self:RefreshImgSelection()
  self:RefreshComboSkill()
  self:RefreshAttackBtn()
  if self.args and self.args.showItem then
    self.tog_item:SetIsOn(true)
  end
  if UIManager.IsVisible(UIID.Task_EarlyGoldGameplay) then
    self:Button_CloseOnClick()
  end
end

function Skill_SetSkillUI:RefreshComboSkill()
  if RoleManager.me.data.hasShield or SkillUtility.GetMeComboSkill() then
    self.setitems[5]:SetActive(false)
  else
    self.setitems[5]:SetActive(true)
  end
end

function Skill_SetSkillUI:RefreshAttackBtn()
  self:SetSprite("Atlas_Main", SkillUtility.GetMainPlayerAttackBtnName(), self.turn_img_skill_zhu, false)
  self:SetSprite("Atlas_Main", SkillUtility.GetMainPlayerAttackBtnName(), self.all_img_skill_zhu, false)
end

function Skill_SetSkillUI:RefreshImgSelection()
  if UIManager.IsVisible(UIID.SkillUI) then
    local imgSelection = SkillSettingData.curmode == EPanModeType.All and self.img_selection_all or self.img_selection_turn
    self:SetSelectImgVisible("skill", imgSelection)
  else
    self:SetSelectImgVisible("item")
  end
end

function Skill_SetSkillUI:LoadSkillsSetting()
  for i = 1, 7 do
    local id = SkillSettingData.skill_pan_all[i]
    if id == 0 then
      self:SetSprite("Atlas_Common", "ty_bg_skillBg", self.allPanSkills[i])
    else
      local cfg_skill = ClientTable.cfg_Skill_skillManager:TryGetValue(id)
      if cfg_skill ~= nil then
        self:SetSprite("Atlas_Skill", cfg_skill.icon, self.allPanSkills[i])
      else
        print(id)
        Debug.LogError("cfg_skill_skill not exist " .. tostring(id))
      end
    end
  end
  for i = 1, 8 do
    local id = SkillSettingData.skill_pan_turn[i]
    if id == 0 then
      self:SetSprite("Atlas_Common", "ty_bg_skillBg", self.turnPanSkills[i])
    else
      local cfg_skill = ClientTable.cfg_Skill_skillManager:TryGetValue(id)
      if cfg_skill ~= nil then
        self:SetSprite("Atlas_Skill", cfg_skill.icon, self.turnPanSkills[i])
      else
        Debug.LogError("cfg_skill_skill not exist " .. tostring(id))
      end
    end
  end
end

function Skill_SetSkillUI:LoadItemsSetting()
  for i = 1, #self.setitems do
    local id = SkillSettingData.skill_use_items[i]
    if id ~= 0 then
      local itemData = ItemUtility.GenerateItemData(id)
      itemData.count = nil
      self.setitems[i].itemCellData:RefreshData(itemData)
    else
      self.setitems[i].itemCellData:Reset()
    end
    ItemUtility.ShowItemCell(self.setitems[i], self.setitems[i].itemCellData, self, false)
  end
end

function Skill_SetSkillUI:IsInSkillRect(x, y, rectx, recty)
  local iconSize = 60
  return false
end
