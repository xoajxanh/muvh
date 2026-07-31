Instance_ClimbTowerUI = class(BaseUI)
Instance_ClimbTowerUI.layer = UILayer.Panel
Instance_ClimbTowerUI.orderInLayer = 0
Instance_ClimbTowerUI.hideType = UIHideType.WaitDestroy
Instance_ClimbTowerUI.hideFunc = UIHideFunc.MoveOutOfScreen
Instance_ClimbTowerUI.escClose = UIEscClose.DontClose

function Instance_ClimbTowerUI:InitControls()
  self.btn_close = self:GetControl("btn_close")
  self.ScrollView = self:GetControl("ScrollView")
  self.view_content = self:GetControl("ScrollView/Viewport/Content")
  self.scroview_scrollRect = self:GetControl("ScrollView")
  self.lab_floor = self:GetControl("rightpanel/lab_floor")
  self.img_itemicon = self:GetControl("rightpanel/lab_requirements/img_itemicon")
  self.btn_get2 = self:GetControl("rightpanel/lab_requirements/btn_get2")
  self.lab_consumeCount = self:GetControl("rightpanel/lab_requirements/lab_consumeCount")
  self.grid = self:GetControl("rightpanel/grid")
  self.right_btn_3DItem = self:GetControl("rightpanel/grid/btn_3DItem")
  self.lab_count1 = self:GetControl("rightpanel/lab_leftcount/lab_count1")
  self.btn_get1 = self:GetControl("rightpanel/lab_leftcount/btn_get1")
  self.btn_enter = self:GetControl("rightpanel/btn_enter")
  self.btn_enter_text = self:GetControl("rightpanel/btn_enter/lab_enter")
  self.go_model = self:GetControl("go_model")
  self.go_3ditem_cuurreowrd = self:GetControl("Reward_BigAward/btn_3DItem")
  self.lab_rewardFloorNum = self:GetControl("Reward_BigAward/lab_rewardFloorNum")
  self.go_Tower_First = self:GetControl("Tower_First")
  self.go_Tower_Special = self:GetControl("Tower_Special")
  self.go_Tower_Normal = self:GetControl("Tower_Normal")
  self.go_Tower_top = self:GetControl("Tower_top")
  self.Tower = self:GetControl("Tower")
  self.go_tuijianfangyulitxt = self:GetControl("lab_recommendAtk")
end

function Instance_ClimbTowerUI:Init()
  self.monsterModel = {}
  self.ClickIndex = 0
  self.ClickIndexTemp = 0
  self.ClickObj = nil
  self.ClickEnmu = 0
  self.isEnteronceGame = true
  self.listtbale = {}
  self.tempitemdata = {}
end

function Instance_ClimbTowerUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Instance_ClimbTowerUI:InitUI()
  self:InitCollections()
end

function Instance_ClimbTowerUI:RegistUIEvents()
  self.btn_close:SetOnClick(self, self.btn_closeOnClick)
  self.img_itemicon:SetOnClick(self, self.img_itemiconOnClick)
  self.btn_get2:SetOnClick(self, self.btn_get2OnClick)
  self.btn_get1:SetOnClick(self, self.btn_get1OnClick)
  self.btn_enter:SetOnClick(self, self.btn_enterOnClick)
end

local function OnSubMenuCreate(ctr)
  ctr.go_model = UIControl(ctr.transform, "go_model")
  ctr.lab_num = UIControl(ctr.transform, "lab_num")
end

local function OnSubMenuShow(ctr, index, data, ui)
  if data == nil then
    return
  end
  if ctr.itemcelldata == nil then
    ctr.itemcelldata = ItemCellData()
  end
  local itemData = ItemUtility.GenerateItemData(data.itemid)
  ctr.itemcelldata:RefreshData(itemData)
  ItemUtility.ShowItemCell(ctr, ctr.itemcelldata, self, true)
  ctr.lab_num:SetText(data.count)
end

function Instance_ClimbTowerUI:OnPageToggleValueChanged(pageControl)
  if not pageControl and not pageControl.data then
    return
  end
  if pageControl.data.id == self.ClickIndex and self.ClickObj then
    if pageControl.pageTempaltes then
      pageControl.pageTempaltes:onSelelct()
    end
    self.ClickObj = pageControl
    return
  end
  if pageControl.pageTempaltes and self.ClickObj and self.ClickObj.pageTempaltes then
    self.ClickObj.pageTempaltes:onNoSelelct()
  end
  if pageControl.pageTempaltes then
    pageControl.pageTempaltes:onSelelct()
    self.ClickObj = pageControl
  end
  if pageControl.data then
    self:OnSetMonstermodel(pageControl.data)
    self.ClickIndex = pageControl.data.id
    self.lab_floor:SetText("H\225\186\161ng" .. self.ClickIndex .. "T\225\186\167ng")
    if pageControl.data.islock == 2 then
      self:OnSetButtonState(3)
    elseif self.ClickIndex == self.ClickIndexTemp then
      if self.TowerData and self.TowerData.index == self.TowerData.combinHigth then
        if pageControl and pageControl.data and pageControl.data.isreward then
          self:OnSetButtonState(2)
        else
          self:OnSetButtonState(1)
        end
      else
        self:OnSetButtonState(0)
      end
    elseif pageControl.data.isreward then
      self:OnSetButtonState(2)
    else
      self:OnSetButtonState(1)
    end
    self.combineItemContainer:RemoveAll()
    self.combineItemContainer:SetDataKTable(pageControl.data.reworditems)
  end
  local singleData = self:GetClimbTowerMgr():GetSingleTowerDataById(self.ClickIndex)
  if singleData then
    local str = ""
    if singleData.defend then
      str = tonumber(singleData.defend)
      local defenseBase = QuickFind.LuaMainPlayerData():TryGetAttrValue(EAttributeType.monsterDamageAbsorptionShow)
      if str < defenseBase then
        str = string.GetColorText("Ph\195\178ng Th\225\187\167: " .. str, ItemQuality2ColorDic[5])
      else
        str = string.GetColorText("Ph\195\178ng Th\225\187\167: " .. str, ItemQuality2ColorDic[7])
      end
    end
    self.go_tuijianfangyulitxt:SetText(str)
  end
end

function Instance_ClimbTowerUI:InitCollections()
  self.climbTowerViewTemp = luaTemplateManager.GetNewTemplate(self.Tower, LuaComponentTemplates.ClimbTowerViewTemplate, {
    baseUI = self,
    clickCallBack = self.OnPageToggleValueChanged
  })
  self.combineItemContainer = UIContainer(self.right_btn_3DItem, self, OnSubMenuCreate, OnSubMenuShow)
end

function Instance_ClimbTowerUI:OnSetButtonState(state)
  if state == 0 then
    self.btn_enter_text:SetText("V\195\160o th\195\161ch \196\145\225\186\165u")
  elseif state == 1 then
    self.btn_enter_text:SetText("Nh\225\186\173n")
  elseif state == 2 then
    self.btn_enter_text:SetText("\196\144\195\163 nh\225\186\173n xong")
  elseif state == 3 then
    self.btn_enter_text:SetText("Kh\195\180ng th\225\187\131 th\195\161ch \196\145\225\186\165u ")
  end
  self.ClickEnmu = state
end

function Instance_ClimbTowerUI:InstantiateGameObject(targetobj, parent)
  local obj = Instantiate(targetobj)
  obj:SetActive(true)
  obj.transform:SetParent(parent)
  obj.transform:SetLocalPosition(targetobj.transform.localPosition)
  obj.transform.localScale = targetobj.transform.localScale
  return obj
end

function Instance_ClimbTowerUI:OnSetSprite(data, ui)
  ui:SetSprite("Atlas_Common", data, ui)
end

function Instance_ClimbTowerUI:OnSetScroviewLen(index)
  local lens = self.view_content.transform.childCount
  local localpress = (tonumber(index) - 1) / lens
  self.scroview_scrollRect.scrollRect.verticalNormalizedPosition = localpress
end

function Instance_ClimbTowerUI:OnSetMonstermodel(data)
  local scale, position = MonsterData.GetMonsterScaleAndPos(data)
  self:ShowMonsterModel(data, self.go_model, scale, position)
end

function Instance_ClimbTowerUI:ShowMonsterModel(monsterTbl, parent, scale, position)
  for k, v in pairs(self.monsterModel) do
    v:SetHide()
  end
  local monster
  if self.monsterModel and self.monsterModel[monsterTbl.model] == nil then
    monster = UIMonsterUtility(monsterTbl.monsterID, parent, scale, position, Vector3(0, -180, 0))
    self.monsterModel[monsterTbl.model] = monster
  else
    monster = self.monsterModel[monsterTbl.model]
    monster:SetParent(parent)
  end
  monster.transform.localScale = scale
  monster.transform.localPosition = position
  monster:SetActive()
end

function Instance_ClimbTowerUI:OnSetRewordItemShow(data)
  if not table.isNullOrEmpty(self.tempitemdata) then
    ItemUtility.HideItemCell(self.go_3ditem_cuurreowrd, self.tempitemdata)
  end
  local itemcelldata = ItemCellData()
  local itemData = ItemUtility.GenerateItemData(data.itemid)
  itemcelldata:RefreshData(itemData)
  ItemUtility.ShowItemCell(self.go_3ditem_cuurreowrd, itemcelldata, self, true)
  self.tempitemdata = itemcelldata
end

function Instance_ClimbTowerUI:OnSetRewordItemShowPool(id)
  if self.itemdatalist then
    self.itemdatalist = {}
  end
  local iscreate = true
  for i, v in pairs(self.itemdatalist) do
    if id == i then
      v.model:SetActive(true)
      iscreate = false
    else
      v.model:SetActive(false)
    end
  end
  if iscreate then
    local itemcelldata = ItemCellData()
    local itemData = ItemUtility.GenerateItemData(data.itemid)
    itemcelldata:RefreshData(itemData)
    ItemUtility.ShowItemCell(self.go_3ditem_cuurreowrd, itemcelldata, self, true)
    self.itemdatalist[id] = itemcelldata
  end
end

function Instance_ClimbTowerUI:btn_closeOnClick(control)
  UIManager.Hide(UIID.Instance_ClimbTowerUI)
end

function Instance_ClimbTowerUI:tog_instanceOnClick(control)
end

function Instance_ClimbTowerUI:btn_3DItemOnClick(control)
end

function Instance_ClimbTowerUI:img_itemiconOnClick(control)
end

function Instance_ClimbTowerUI:btn_get2OnClick(control)
end

function Instance_ClimbTowerUI:btn_3DItemOnClick(control)
end

function Instance_ClimbTowerUI:btn_get1OnClick(control)
end

function Instance_ClimbTowerUI:btn_enterOnClick(control)
  if self.ClickEnmu == 0 then
    if self.ClickIndex == self.ClickIndexTemp then
      NetManager.Send(MapMessage.ReqJoinToTower)
      UIManager.Hide(UIID.Instance_ClimbTowerUI)
      RoleManager.me:SetAutoFight(AutoFightStrKey.None)
    end
  elseif self.ClickEnmu == 1 then
    NetManager.Send(RoleMessage.ReqRewardTower, {
      id = self.ClickIndex
    })
  elseif self.ClickEnmu == 2 then
  elseif self.ClickEnmu == 3 then
  end
end

function Instance_ClimbTowerUI:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function Instance_ClimbTowerUI:RegistEvents()
  self:RegistEvent(Event.ClimbTowerCurrnLevel, self.OnGetCurrLevelCallBack, self)
end

function Instance_ClimbTowerUI:Refresh()
  NetManager.Send(RoleMessage.ReqTowerLevel)
end

function Instance_ClimbTowerUI:OnGetCurrLevelCallBack(_, data)
  if self.ClickObj and self.ClickObj.pageTempaltes then
    local singleData = self:GetClimbTowerMgr():GetSingleTowerDataById(self.ClickIndex)
    if singleData then
      self.ClickObj.data.isreward = singleData.isreward
    end
    self.ClickObj.pageTempaltes:onSetRedpoint(false)
    if self.ClickObj.data.islock == 2 then
      self:OnSetButtonState(3)
    else
      if self.ClickObj.data.reworditems and table.count(self.ClickObj.data.reworditems) > 0 then
        local showTbl = {}
        for i, v in ipairs(self.ClickObj.data.reworditems) do
          local itemData = ItemUtility.GenerateItemData(v.itemid)
          itemData.count = v.count
          table.insert(showTbl, itemData)
        end
        UIManager.Show(UIID.Tip_RewardTipUI, {rewards = showTbl})
      end
      if self.ClickIndex == self.ClickIndexTemp then
        if data and data.index == data.combinHigth then
          if self.ClickObj and self.ClickObj.data and self.ClickObj.data.isreward then
            self:OnSetButtonState(2)
          else
            self:OnSetButtonState(1)
          end
        else
          self:OnSetButtonState(0)
        end
      elseif self.ClickObj.data.isreward then
        self:OnSetButtonState(2)
      else
        self:OnSetButtonState(1)
      end
    end
    return
  end
  self.ClickIndex = data.index + 1 > data.combinHigth and data.combinHigth or data.index + 1
  self.ClickIndexTemp = self.ClickIndex
  self.TowerData = data
  local dataIndex = self:GetClimbTowerMgr():GetIndexFromShowDataById(self.ClickIndex, data.combinHigth)
  self.climbTowerViewTemp:Refresh(data.data, dataIndex)
  self:OnSetRewordItemShow(data.currreword)
  if data.currtierid then
    self.lab_rewardFloorNum:SetText("T\225\186\167ng " .. data.currtierid)
  else
    self.lab_rewardFloorNum:SetText("\196\144\195\163 v\198\176\225\187\163t \225\186\163i")
  end
  if self.isEnteronceGame then
    self.isEnteronceGame = false
  end
end

function Instance_ClimbTowerUI:OnHide()
  self.ClickIndex = 0
  self.ClickIndexTemp = 0
  self.ClickEnmu = 0
  self.isEnteronceGame = true
  self.ClickObj = nil
  for i, v in ipairs(self.listtbale) do
    v:Destroy()
  end
  self.listtbale = {}
  self.climbTowerViewTemp:Hide()
  self.combineItemContainer:RemoveAll()
end

function Instance_ClimbTowerUI:OnDestroy()
  self.ClickIndex = 0
  self.ClickIndexTemp = 0
  self.ClickEnmu = 0
  self.ClickObj = nil
  for i, v in ipairs(self.listtbale) do
    v:Destroy()
  end
  self.listtbale = {}
end

function Instance_ClimbTowerUI:GetClimbTowerMgr()
  if gameMgr:GetAvatarManager() then
    return gameMgr:GetAvatarManager():GetMainPlayer():GetClimBTowerData()
  end
end
