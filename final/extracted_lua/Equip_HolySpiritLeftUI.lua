Equip_HolySpiritLeftUI = class(BaseUI)
Equip_HolySpiritLeftUI.layer = UILayer.Panel
Equip_HolySpiritLeftUI.orderInLayer = 0
Equip_HolySpiritLeftUI.hideType = UIHideType.Hide
Equip_HolySpiritLeftUI.hideFunc = UIHideFunc.MoveOutOfScreen
Equip_HolySpiritLeftUI.escClose = UIEscClose.DontClose

function Equip_HolySpiritLeftUI:InitControls()
  self.btn_closeAllAttrPanel = self:GetControl("btn_closeAllAttrPanel")
  self.bg_role = self:GetControl("HolySpirit_bg/Role/bg_role")
  self.LineParent = self:GetControl("LineParent")
  self.point = self:GetControl("img_point/point")
  self.img_Name = self:GetControl("img_HolyName/img_Name")
  self.img_Arrow_left = self:GetControl("img_Arrow/img_Arrow_left")
  self.img_Arrow_right = self:GetControl("img_Arrow/img_Arrow_right")
  self.text_Bottom = self:GetControl("HolySpirit_bg/Role/Text_bottom/Text")
  self.bg_role_mijiale = self:GetControl("HolySpirit_bg/Role/role_Parent/bg_role_mijiale")
  self.bg_role_jiabailie = self:GetControl("HolySpirit_bg/Role/role_Parent/bg_role_jiabailie")
  self.bg_role_wulieer = self:GetControl("HolySpirit_bg/Role/role_Parent/bg_role_wulieer")
  self.bg_role_lafeier = self:GetControl("HolySpirit_bg/Role/role_Parent/bg_role_lafeier")
  self.bg_role_laguier = self:GetControl("HolySpirit_bg/Role/role_Parent/bg_role_laguier")
  self.bg_role_shaliye = self:GetControl("HolySpirit_bg/Role/role_Parent/bg_role_shaliye")
  self.bg_role_yuefeier = self:GetControl("HolySpirit_bg/Role/role_Parent/bg_role_yuefeier")
  self.btn_resetPoint = self:GetControl("btn_resetPoint")
  self.resetPointPanel = self:GetControl("resetPointPanel")
  self.consumeItem = self:GetControl("resetPointPanel/lab_price/consumeItem")
  self.lab_priceValue = self:GetControl("resetPointPanel/lab_price/lab_priceValue")
  self.btn_resetPointPanelClose = self:GetControl("resetPointPanel/btn_resetPointPanelClose")
  self.cancelBtn = self:GetControl("resetPointPanel/cancelBtn")
  self.confirmBtn = self:GetControl("resetPointPanel/confirmBtn")
  self.btn_closeBg = self:GetControl("btn_closeBg")
  self.twoOrder = self:GetControl("Order/twoOrder")
  self.sacred_frame = {}
  self.sacred_info = {}
  self.eff = {}
  self.img_bg7 = {}
  self.img_lock = {}
  self.text_Tips = {}
  self.sacred_frameShizijian = {}
  self.sacred_frameQin = {}
  self.sacred_frameHuoyanjian = {}
  self.sacred_frameShenzhang = {}
  self.sacred_frameHua = {}
  self.sacred_frameTianping = {}
  self.sacred_frameShengjian = {}
  self.sacred_frame[1] = self:GetControl("Equip_Sacred/sacred_frame")
  self.sacred_info[1] = self:GetControl("Equip_Sacred/sacred_info")
  self.eff[1] = self:GetControl("Equip_Sacred/Eff")
  self.img_bg7[1] = self:GetControl("Equip_Sacred/sacred_info/img_bg7")
  self.img_lock[1] = self:GetControl("Equip_Sacred/sacred_info/img_Lock")
  self.text_Tips[1] = self:GetControl("Equip_Sacred/Text_Tips")
  self.sacred_frameShizijian[1] = self:GetControl("Equip_Sacred/equip_bg/Image_frameShizijian")
  self.sacred_frameQin[1] = self:GetControl("Equip_Sacred/equip_bg/Image_frameQin")
  self.sacred_frameHuoyanjian[1] = self:GetControl("Equip_Sacred/equip_bg/Image_frameHuoyanjian")
  self.sacred_frameShenzhang[1] = self:GetControl("Equip_Sacred/equip_bg/Image_frameShenzhang")
  self.sacred_frameHua[1] = self:GetControl("Equip_Sacred/equip_bg/Image_frameHua")
  self.sacred_frameTianping[1] = self:GetControl("Equip_Sacred/equip_bg/Image_frameTianping")
  self.sacred_frameShengjian[1] = self:GetControl("Equip_Sacred/equip_bg/Image_frameShengjian")
  self.sacred_frame[2] = self:GetControl("Equip_Sacred2/sacred_frame")
  self.sacred_info[2] = self:GetControl("Equip_Sacred2/sacred_info")
  self.eff[2] = self:GetControl("Equip_Sacred2/Eff")
  self.img_bg7[2] = self:GetControl("Equip_Sacred2/sacred_info/img_bg7")
  self.img_lock[2] = self:GetControl("Equip_Sacred2/sacred_info/img_Lock")
  self.text_Tips[2] = self:GetControl("Equip_Sacred2/Text_Tips")
  self.sacred_frameShizijian[2] = self:GetControl("Equip_Sacred2/equip_bg/Image_frameShizijian")
  self.sacred_frameQin[2] = self:GetControl("Equip_Sacred2/equip_bg/Image_frameQin")
  self.sacred_frameHuoyanjian[2] = self:GetControl("Equip_Sacred2/equip_bg/Image_frameHuoyanjian")
  self.sacred_frameShenzhang[2] = self:GetControl("Equip_Sacred2/equip_bg/Image_frameShenzhang")
  self.sacred_frameHua[2] = self:GetControl("Equip_Sacred2/equip_bg/Image_frameHua")
  self.sacred_frameTianping[2] = self:GetControl("Equip_Sacred2/equip_bg/Image_frameTianping")
  self.sacred_frameShengjian[2] = self:GetControl("Equip_Sacred2/equip_bg/Image_frameShengjian")
end

function Equip_HolySpiritLeftUI:Init()
end

function Equip_HolySpiritLeftUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Equip_HolySpiritLeftUI:InitUI()
  self.holySpiritPointTemplate = UIUtility.BindUIContainerTemp(self.point, LuaComponentTemplates.HolySpiritPointTemplate, self)
  self.roleTab = {
    [1] = self.bg_role_mijiale,
    [2] = self.bg_role_jiabailie,
    [3] = self.bg_role_wulieer,
    [4] = self.bg_role_lafeier,
    [5] = self.bg_role_laguier,
    [6] = self.bg_role_shaliye,
    [7] = self.bg_role_yuefeier
  }
  self.equipImageTabla = {
    [1] = self.sacred_frameShizijian,
    [2] = self.sacred_frameQin,
    [3] = self.sacred_frameHuoyanjian,
    [4] = self.sacred_frameShenzhang,
    [5] = self.sacred_frameHua,
    [6] = self.sacred_frameTianping,
    [7] = self.sacred_frameShengjian
  }
  self.nameTab = {
    [1] = "holySpirit_mijiale",
    [2] = "holySpirit_jiabailie",
    [3] = "holySpirit_wulieer",
    [4] = "holySpirit_lafeier",
    [5] = "holySpirit_laguier",
    [6] = "holySpirit_shaliye",
    [7] = "holySpirit_yuefeier"
  }
  self.orderTab = {
    [2] = self.twoOrder
  }
  self.equipCellData = {}
  self.oldCellDateId = {}
  self.sacred_frame[1].suitType = 1
  self.sacred_frame[2].suitType = 2
end

function Equip_HolySpiritLeftUI:RegistUIEvents()
  self.btn_closeAllAttrPanel:SetOnClick(self, self.btn_closeAllAttrPanelOnClick)
  self.img_Arrow_left:SetOnClick(self, self.btn_img_Arrow_leftOnClick)
  self.img_Arrow_right:SetOnClick(self, self.btn_img_Arrow_rightOnClick)
  self.sacred_frame[1]:SetOnClick(self, self.btn_equipCellOnClick)
  self.sacred_frame[2]:SetOnClick(self, self.btn_equipCellOnClick)
  self.btn_resetPoint:SetOnClick(self, self.btn_resetPointOnClick)
  self.btn_resetPointPanelClose:SetOnClick(self, self.btn_resetPointPanelCloseOnClick)
  self.cancelBtn:SetOnClick(self, self.cancelBtnOnClick)
  self.confirmBtn:SetOnClick(self, self.confirmBtnOnClick)
  self.btn_closeBg:SetOnClick(self, self.btn_closeBgOnClick)
end

function Equip_HolySpiritLeftUI:btn_closeAllAttrPanelOnClick()
  UIManager.Hide(UIID.Equip_HolySpiritLeftUI)
end

function Equip_HolySpiritLeftUI:btn_img_Arrow_leftOnClick()
  gameMgr:GetAvatarManager():GetMainPlayer():GetHolySpiritDataMgr():SetOffsetCurShowHolySpiritType(-1)
end

function Equip_HolySpiritLeftUI:btn_img_Arrow_rightOnClick()
  gameMgr:GetAvatarManager():GetMainPlayer():GetHolySpiritDataMgr():SetOffsetCurShowHolySpiritType(1)
end

function Equip_HolySpiritLeftUI:btn_equipCellOnClick(control)
  if gameMgr:GetAvatarManager():GetMainPlayer():GetHolySpiritDataMgr():CurShowHolySpiritEquitUnlock(control.suitType) then
    local suitEquip = gameMgr:GetAvatarManager():GetMainPlayer():GetHolySpiritDataMgr():GetCurShowHolySpiritEquip()[control.suitType]
    
    local function func()
      self:OpenBagPanel()
      UIManager.Hide(UIID.ItemTipUI)
    end
    
    if suitEquip then
      UIManager.Show(UIID.ItemTipUI, {
        item = suitEquip.equipData,
        isHolySpiritLeft = true,
        rightOperate = {name = "Thay th\225\186\191", func = func}
      })
    elseif not UIManager.IsVisible(UIID.NewBagInfoUI) then
      self:OpenBagPanel()
    end
  else
    local curHolySoirtType = gameMgr:GetAvatarManager():GetMainPlayer():GetHolySpiritDataMgr():GetCurHolySpiritType()
    FloatingTipUtility.QuickMsg(string.format("%s Lv%s m\225\187\159 kh\195\179a", HolySpiritPointData.pageNameArray[control.suitType][curHolySoirtType] or "T\195\170n Th\195\161nh H\225\187\147n", HolySpiritPointData.unLockPointArray[control.suitType][curHolySoirtType] or "Lv"))
  end
end

function Equip_HolySpiritLeftUI:btn_resetPointOnClick()
  local curHolySpiritType = gameMgr:GetAvatarManager():GetMainPlayer():GetHolySpiritDataMgr():GetCurHolySpiritType()
  local upgradeCount = HolySpiritPointData.GetHolySpiritUpgradeCount(curHolySpiritType)
  if upgradeCount == 0 then
    FloatingTipUtility.QuickMsg("Kh\195\180ng c\195\179 \196\145i\225\187\131m Th\195\161nh H\225\187\147n c\195\179 th\225\187\131 \196\145\225\186\183t l\225\186\161i")
    return
  end
  self:SetResetPointPanelShow(true)
  local expendItemId, expendCount = gameMgr:GetAvatarManager():GetMainPlayer():GetHolySpiritDataMgr():GetResetExpendItemIdAndCount()
  local itemData = ItemUtility.GenerateItemData(expendItemId)
  self.consumeItem.itemCellData = self.consumeItem.itemCellData or ItemCellData()
  self.consumeItem.itemCellData:RefreshData(itemData)
  ItemUtility.ShowItemCell(self.consumeItem, self.consumeItem.itemCellData, self, true)
  local count = RefreshData.GetInstanceCount(2360082)
  local bagCount = BagInfoData.GetItemTotalCountByItemId(expendItemId)
  if count ~= 0 then
    self.lab_priceValue:SetText(string.GetColorText("L\225\186\167n \196\145\225\186\167u mi\225\187\133n ph\195\173", ItemQuality2ColorDic[5]))
  else
    self.lab_priceValue:SetText(string.GetColorText(tostring(expendCount), expendCount <= bagCount and ItemQuality2ColorDic[5] or ItemQuality2ColorDic[7]))
  end
end

function Equip_HolySpiritLeftUI:btn_resetPointPanelCloseOnClick()
  self:SetResetPointPanelShow(false)
end

function Equip_HolySpiritLeftUI:cancelBtnOnClick()
  self:SetResetPointPanelShow(false)
end

function Equip_HolySpiritLeftUI:confirmBtnOnClick()
  local curHolySpiritType = gameMgr:GetAvatarManager():GetMainPlayer():GetHolySpiritDataMgr():GetCurHolySpiritType()
  local expendItemId, expendCount = gameMgr:GetAvatarManager():GetMainPlayer():GetHolySpiritDataMgr():GetResetExpendItemIdAndCount()
  local bagCount = BagInfoData.GetItemTotalCountByItemId(expendItemId)
  local count = RefreshData.GetInstanceCount(2360082)
  if count ~= 0 or expendCount <= bagCount then
    gameMgr:GetAvatarManager():GetMainPlayer():GetHolySpiritDataMgr():ResetHolySpiritData()
    networkRequest.ReqHolySpiritWashPoint(curHolySpiritType)
    self:SetResetPointPanelShow(false)
  elseif count == 0 and expendCount > bagCount then
    FloatingTipUtility.QuickMsg("KC kh\195\180ng \196\145\225\187\167")
  end
end

function Equip_HolySpiritLeftUI:btn_closeBgOnClick()
  UIManager.Hide(UIID.Equip_HolySpiritLeftUI)
end

local function getKey(t, value)
  for k, v in pairs(t) do
    for i, v in pairs(v) do
      if v == value then
        return k
      end
    end
  end
end

function Equip_HolySpiritLeftUI:OnShow()
  self:RegistEvents()
  self:SetResetPointPanelShow(false)
  if self.args and self.args.equipSubtype then
    local type = getKey(HolySpiritPointData.equipTab, self.args.equipSubtype)
    gameMgr:GetAvatarManager():GetMainPlayer():GetHolySpiritDataMgr():SetCurShowHolySpiritType(type)
  else
    networkRequest.ReqUnitHolySpirit()
  end
end

function Equip_HolySpiritLeftUI:RegistEvents()
  self:RegistEvent(Event.RefreshHolySpiritPage, self.RefreshHolySpiritPage, self)
  self:RegistEvent(Event.EquipInfoChange, self.RefreshEquip, self)
  self:RegistEvent(Event.Bag_ResBagChange, self.RefreshEquip, self)
end

function Equip_HolySpiritLeftUI:Refresh()
  self:RefreshHolySpiritPage(_, {
    CurHolySpiritType = gameMgr:GetAvatarManager():GetMainPlayer():GetHolySpiritDataMgr():GetCurHolySpiritType(),
    CurHolySpiritPointId = gameMgr:GetAvatarManager():GetMainPlayer():GetHolySpiritDataMgr():GetCurShowHolySpiritPointId()
  })
end

function Equip_HolySpiritLeftUI:RefreshEquip()
  self:RefreshHolySpiritEquip(gameMgr:GetAvatarManager():GetMainPlayer():GetHolySpiritDataMgr():GetCurHolySpiritType())
end

function Equip_HolySpiritLeftUI:RefreshHolySpiritPage(_, data)
  self:SetResetPointPanelShow(false)
  self:RefreshHolySpiritPicture(data.CurHolySpiritType)
  self:RefreshHolySpiritPoint(data.CurHolySpiritType)
  self:RefreshHolySpiritDegree(data.CurHolySpiritType)
  self:RefreshArrow_left_Right(data.CurHolySpiritType)
  self:RefreshHolySpiritEquip(data.CurHolySpiritType)
  EventManager.Dispatch(Event.CallRefreshRedPoint, {
    id = ERedPointId.holyspirit
  })
end

function Equip_HolySpiritLeftUI:RefreshHolySpiritPoint(type)
  if self.holySpiritPointTemplate then
    self.holySpiritPointTemplate:RemoveKTable()
  end
  local typeHolySpiritDataTab = HolySpiritPointData.GetCurTypeHolySpiritData(type)
  if typeHolySpiritDataTab ~= nil and table.count(typeHolySpiritDataTab) > 0 then
    local curHolySpiritDataTab = {}
    for i, v in pairs(typeHolySpiritDataTab) do
      if v.CfgInfo.subType == gameMgr:GetAvatarManager():GetMainPlayer():GetHolySpiritDataMgr():GetCurHolySpiritSubType() then
        table.insert(curHolySpiritDataTab, v)
      end
    end
    self.holySpiritPointTemplate:SetDataKTable(curHolySpiritDataTab)
  end
end

function Equip_HolySpiritLeftUI:RefreshHolySpiritPicture(type)
  for index, v in pairs(self.roleTab) do
    if self.roleTab[index] then
      v:SetActive(index == type)
    end
  end
  for index, v in ipairs(self.equipImageTabla) do
    local isShow = index == type
    if self.equipImageTabla[index] then
      for index, v in pairs(self.equipImageTabla[index]) do
        v:SetActive(isShow)
      end
    end
  end
  if self.nameTab[type] then
    self:SetSprite("Atlas_HolySpirit", self.nameTab[type], self.img_Name, true)
  end
  for i, v in pairs(self.orderTab) do
    v:SetActive(false)
  end
  local subType = gameMgr:GetAvatarManager():GetMainPlayer():GetHolySpiritDataMgr():GetCurHolySpiritSubType()
  if self.orderTab[subType] then
    self.orderTab[subType]:SetActive(true)
  end
end

function Equip_HolySpiritLeftUI:RefreshHolySpiritDegree(type)
  local totalPage = HolySpiritPointData.GetHolySpiritTotalPage()
  self.text_Bottom:SetText(string.format("%d/%d", type, totalPage))
end

function Equip_HolySpiritLeftUI:RefreshHolySpiritEquip(type)
  local equipSubType = HolySpiritPointData.equipTab[type]
  if UIManager.IsVisible(UIID.NewBagInfoUI) then
    EventManager.Dispatch(Event.Bag_RefreshShowHolySpirit)
  end
  if not equipSubType then
    logError("Lo\225\186\161i Th\195\161nh H\225\187\147n con kh\195\180ng t\225\187\147n t\225\186\161i!")
  end
  local suitEquip = gameMgr:GetAvatarManager():GetMainPlayer():GetHolySpiritDataMgr():GetCurShowHolySpiritEquip()
  self:RefreshEquipFrame(suitEquip, type)
end

function Equip_HolySpiritLeftUI:RefreshEquipFrame(suitEquip, type)
  for i = 1, #self.sacred_frame do
    if gameMgr:GetAvatarManager():GetMainPlayer():GetHolySpiritDataMgr():CurShowHolySpiritEquitUnlock(i) then
      self.text_Tips[i]:SetActive(false)
      self.img_lock[i]:SetActive(false)
    else
      self.text_Tips[i]:SetText(string.format("%s Lv%s m\225\187\159 kh\195\179a", HolySpiritPointData.pageNameArray[i][type] or "T\195\170n Th\195\161nh H\225\187\147n", HolySpiritPointData.unLockPointArray[i][type] or "Lv"))
      self.text_Tips[i]:SetActive(true)
      self.img_lock[i]:SetActive(true)
    end
    local isUp = gameMgr:GetAvatarManager():GetMainPlayer():GetHolySpiritDataMgr():CheckEquipUp(i)
    if isUp then
      self.eff[i]:SetActive(true)
    else
      self.eff[i]:SetActive(false)
    end
    self:LoadEquipModel(suitEquip[i], type, i)
  end
end

function Equip_HolySpiritLeftUI:OpenBagPanel()
  if UIManager.IsVisible(UIID.NewBagInfoUI) then
    return
  end
  UIManager.Show(UIID.NewBagInfoUI, {
    OnClose = function(control)
      UIManager.Show(UIID.Equip_HolySpiritRightUI)
    end
  })
end

function Equip_HolySpiritLeftUI:LoadEquipModel(suitEquip, type, i)
  local cellData
  if not self.equipCellData[i] then
    self.equipCellData[i] = ItemCellData()
  end
  cellData = self.equipCellData[i]
  if gameMgr:GetAvatarManager():GetMainPlayer():GetHolySpiritDataMgr():CurShowHolySpiritEquitUnlock(i) then
    if suitEquip == nil then
      cellData:RecycleRes()
      self.img_bg7[i]:SetActive(false)
      self.oldCellDateId[i] = {}
      self.equipImageTabla[type][i]:SetActive(true)
    else
      self.img_bg7[i]:SetActive(true)
      self.equipImageTabla[type][i]:SetActive(false)
      local itemData = suitEquip.equipData
      if self.oldCellDateId[i] == itemData.id then
        return
      end
      self.oldCellDateId[i] = itemData.id
      local parent = self.sacred_frame[i]
      local path = ResourceConfig.GetUIPathByItemData(itemData)
      cellData:RecycleRes()
      cellData:RefreshData(itemData)
      if not cellData.model then
        cellData.model = CS.Framework.GameModel(parent.gameObject, function(go, name)
          ItemUtility.SetModelTransform(go, parent.transform, itemData, 1, 400)
          EquipEffectSet:SetModelEffecByIntensify(itemData, go)
        end)
      end
      if cellData.model.modelObject then
        if not cellData.isDrag then
          ItemUtility.SetModelTransform(cellData.model.modelObject, parent.transform, itemData, 1, 400)
        end
      else
        local obj = PoolManagerTest.Spawn(ResourceTypeEnum.Effect_UI, path)
        if obj then
          cellData.model:SetModelObj(path, obj)
        else
          cellData.model:LoadAsync(path)
          cellData.model:SetLayer(UI_LAYER)
        end
      end
      if cellData.model.modelObject then
        ItemUtility.ShakeEquipItem(cellData.model.modelObject)
        EquipEffectSet:SetModelEffecByIntensify(itemData, cellData.model.modelObject)
      end
    end
  else
    self.equipImageTabla[type][i]:SetActive(true)
    cellData:RecycleRes()
    self.img_bg7[i]:SetActive(true)
    self.oldCellDateId[i] = {}
  end
end

function Equip_HolySpiritLeftUI:RefreshArrow_left_Right(type)
  local totalPage = HolySpiritPointData.GetHolySpiritTotalPage()
  self.img_Arrow_left:SetActive(type ~= 1 and true or false)
  self.img_Arrow_right:SetActive(type ~= totalPage and true or false)
end

function Equip_HolySpiritLeftUI:SetResetPointPanelShow(isShow)
  self.resetPointPanel:SetActive(isShow)
end

function Equip_HolySpiritLeftUI:OnHide()
  self.oldCellDateId = {}
  networkRequest.ReqUnitHolySpirit()
  EventManager.Dispatch(Event.CallRefreshRedPoint, {
    id = ERedPointId.holyspirit
  })
end

function Equip_HolySpiritLeftUI:OnDestroy()
end
