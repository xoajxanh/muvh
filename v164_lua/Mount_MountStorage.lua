Mount_MountStorage = class(BaseUI)
Mount_MountStorage.layer = UILayer.Panel
Mount_MountStorage.orderInLayer = 2
Mount_MountStorage.hideType = UIHideType.WaitDestroy
Mount_MountStorage.hideFunc = UIHideFunc.MoveOutOfScreen
Mount_MountStorage.escClose = UIEscClose.DontClose

function Mount_MountStorage:InitControls()
  self.bg_mountSub = self:GetControl("bg_mountSub")
  self.btn_close = self:GetControl("bg_mountSub/btn_close")
  self.img_rideAttribute = self:GetControl("bg_mountSub/img_rideAttribute")
  self.txt_attribute = self:GetControl("bg_mountSub/img_rideAttribute/txt_attribute")
  self.go_switch = self:GetControl("bg_mountSub/go_switch")
  self.Img_open = self:GetControl("bg_mountSub/go_switch/Img_open")
  self.sv_rideList = self:GetControl("bg_mountSub/sv_rideList")
  self.img_bg = self:GetControl("bg_mountSub/sv_rideList/Viewport/Content/img_bg")
  self.go_nullRide = self:GetControl("bg_mountSub/go_nullRide")
end

function Mount_MountStorage:OnPreLoad()
end

local ShowMountList = {}
local selectItemIndex = 1
local ItemTakeoffindex = 1
local ItemTakePos, selectFrameObj
local Attributeindex = 1
local switchplusY = 0
local switchselfY = 0
local switchselfX = 0
local sv_rideTop = 0

function Mount_MountStorage:Init()
end

function Mount_MountStorage:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Mount_MountStorage:InitUI()
  self:InitIconContainer()
  self:ComputeAttriSize()
end

function Mount_MountStorage:ComputeAttriSize()
  local GridLayoutGroup = self.img_rideAttribute.transform:GetComponent("GridLayoutGroup")
  local cell = GridLayoutGroup.cellSize
  local spa = GridLayoutGroup.spacing
  switchplusY = cell.y + spa.y
  switchselfX, switchselfY = self.go_switch:GetAnchoredPosition()
  sv_rideTop = self.sv_rideList.transform:GetComponent("RectTransform").offsetMax
end

local function IconOnCreate(ctr)
  ctr.img_rideHead = UIControl(ctr.transform, "img_rideHeadFrame/img_rideHead")
  ctr.itemCtr = ItemUtility.InitItemCell(ctr.img_rideHead)
  ctr.modelData = ItemCellData()
  ctr.txt_rideName = UIControl(ctr.transform, "img_rideHeadFrame/txt_rideName")
  ctr.img_rideIcon = UIControl(ctr.transform, "img_rideHeadFrame/img_rideIcon")
  ctr.img_select = UIControl(ctr.transform, "img_rideHeadFrame/img_select")
  ctr.img_rideIcon:SetActive(false)
  ctr.img_select:SetActive(false)
end

local function IconRefresh(ctr, _, itemData, ui)
  local IconData = ItemUtility.GenerateItemData(itemData.itemId)
  ctr.modelData:RefreshData(IconData)
  ctr.modelData.isShowArrow = false
  ItemUtility.ShowItemCell(ctr.itemCtr, ctr.modelData, ui, true)
  if ctr.img_select then
    ctr.img_select:SetActive(selectItemIndex == itemData.index)
  end
  if ctr.img_rideIcon then
    ctr.img_rideIcon:SetActive(RoleManager.me.data.rideMount and itemData.id == RoleManager.me.data.rideMount.id)
  end
  if ctr.txt_rideName then
    ctr.txt_rideName:SetText(itemData.name)
  end
  ctr.itemInfo = itemData
  if selectItemIndex == itemData.index then
    ui:OnMountItemClick(ctr)
  end
  ctr:SetOnClick(ui, ui.OnMountItemClick)
  ctr.img_rideHead.itemId = itemData.itemId
  ctr.img_rideHead.equipid = itemData.id
  ctr.img_rideHead.bagGridIndex = itemData.bagGridIndex
  ctr.img_rideHead.index = itemData.index
  ctr.img_rideHead:SetOnClick(ui, ui.ItemClick)
end

function Mount_MountStorage:SetFrame(control, quality)
  if quality == 0 then
    ColorUtility.SetUIColor(control, Color(0, 1, 1, 1))
  elseif quality == 1 then
    ColorUtility.SetUIColor(control, Color(0.30980392156862746, 0.5137254901960784, 0.8117647058823529, 1))
  elseif quality == 2 then
    ColorUtility.SetUIColor(control, Color(0.5, 0, 1, 1))
  elseif quality == 3 then
    ColorUtility.SetUIColor(control, Color(1, 0.5, 0, 1))
  elseif quality == 4 then
    ColorUtility.SetUIColor(control, Color(0.8117647058823529, 0.3137254901960784, 0.9019607843137255, 1))
  elseif quality == 5 then
    ColorUtility.SetUIColor(control, Color(0, 1, 0, 1))
  end
end

function Mount_MountStorage:InitIconContainer()
  self.iconContainer = UIContainer(self.img_bg, self, IconOnCreate, IconRefresh)
end

function Mount_MountStorage:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function Mount_MountStorage:OnHide()
end

function Mount_MountStorage:OnDestroy()
end

function Mount_MountStorage:RegistUIEvents()
  self.btn_close:SetOnClick(self, self.btn_closeOnClick)
  self.Img_open:SetOnClick(self, self.Img_openOnClick)
end

function Mount_MountStorage:btn_closeOnClick(control)
end

function Mount_MountStorage:ItemClick(control)
  ItemTakeoffindex = control.index
  ItemTakePos = control.bagGridIndex
  local itemData = ItemUtility.GenerateItemData(control.itemId)
  itemData.equipid = control.equipid
  itemData.equipposition = control.bagGridIndex
  UIManager.Show(UIID.ItemTipUI, {
    item = itemData,
    rightOperate = EItemOperateType.MountDisboard,
    ctrl = control,
    openType = TipsOpenType.BagOpen
  })
end

function Mount_MountStorage:Img_openOnClick(control)
  if Attributeindex == 1 then
    Attributeindex = 2
    self.Img_open.transform.localScale = Vector3(-1, 1, 1)
  elseif Attributeindex == 2 then
    Attributeindex = 1
    self.Img_open.transform.localScale = Vector3(1, 1, 1)
  end
  self:RefreshAttribute()
end

function Mount_MountStorage:OnMountItemClick(control)
  selectItemIndex = control.itemInfo.index
  if selectFrameObj then
    selectFrameObj:SetActive(false)
  end
  selectFrameObj = control.img_select
  if selectFrameObj then
    selectFrameObj:SetActive(true)
  end
  MountData.curItemInfo = control.itemInfo
  EventManager.Dispatch(Event.Mount_ShowChange, control.itemInfo)
  self:RefreshAttribute()
end

function Mount_MountStorage:RegistEvents()
  self:RegistEvent(Event.Mount_Change, self.MountChangeFunc, self)
end

function Mount_MountStorage:MountChangeFunc(id, msg)
  self:RefreshToggle(msg)
end

function Mount_MountStorage:RefreshToggle(msg)
  self:InitUIShowList(msg)
  if table.count(ShowMountList) == 0 then
    self.sv_rideList:SetActive(false)
    self.go_nullRide:SetActive(true)
    self.img_rideAttribute:SetActive(false)
    self.go_switch:SetActive(false)
    if #ShowMountList == 0 then
      MountData.curItemInfo = nil
      EventManager.Dispatch(Event.Mount_ShowChange)
    end
  else
    self.sv_rideList:SetActive(true)
    self.go_nullRide:SetActive(false)
    self.img_rideAttribute:SetActive(true)
    self.go_switch:SetActive(true)
    self.iconContainer:SetData(ShowMountList)
    self:RefreshAttribute()
  end
end

local function sort(a, b)
  if a.fight ~= b.fight then
    return a.fight < b.fight
  end
  return a.itemId < b.itemId
end

function Mount_MountStorage:InitUIShowList(msg)
  ShowMountList = {}
  local tblMountList = ItemUtility.GetItemByTypeAndSubType(2, 22)
  for i = 1, #tblMountList do
    if ParseUtility:IsCareerIn(tblMountList[i].career, RoleManager.me.data.career) then
      local mountData = RoleManager.me.data.mountData:GetMountData(tblMountList[i].id)
      if mountData ~= nil then
        table.insert(ShowMountList, mountData)
      end
    end
  end
  table.sort(ShowMountList, sort)
  local ride = true
  for i = 1, #ShowMountList do
    ShowMountList[i].index = i
    if RoleManager.me.data.rideMount and ShowMountList[i].id == RoleManager.me.data.rideMount.id then
      selectItemIndex = i
      ride = false
    end
  end
  if ride then
    if selectItemIndex > #ShowMountList then
      selectItemIndex = 1
      return
    end
    if msg and ItemTakePos == msg.position and ItemTakeoffindex < selectItemIndex then
      selectItemIndex = selectItemIndex - 1
    end
  end
end

local function AttOnCreate(ctr)
  ctr.txt_attributeValue = UIControl(ctr.transform, "txt_attributeValue")
end

local function AttRefresh(ctr, _, itemData, ui)
  ctr:SetText(itemData.name)
  ctr.txt_attributeValue:SetText(itemData.value)
end

function Mount_MountStorage:AllAttributeData()
  local Attinfo = {}
  local fight, Minattack, Maxattack, Defense, Damagebonus, Damageabsorb, MoveSpeedmul, resistDamageReflection, monsterDropRate = 0, 0, 0, 0, 0, 0, 0, 0, 0
  for i, v in pairs(ShowMountList) do
    local curItemInfo = v.tblEquip
    if curItemInfo.disable_fight ~= 0 then
      fight = fight + curItemInfo.disable_fight
    end
    if curItemInfo.disable_minimumPhysBaseDmg ~= 0 then
      Minattack = Minattack + curItemInfo.disable_minimumPhysBaseDmg
    end
    if curItemInfo.disable_maximumPhysBaseDmg ~= 0 then
      Maxattack = Maxattack + curItemInfo.disable_maximumPhysBaseDmg
    end
    if curItemInfo.disable_defenseBase ~= 0 then
      Defense = Defense + curItemInfo.disable_defenseBase
    end
    if curItemInfo.disable_damageBonus ~= 0 then
      local mun = math.floor(curItemInfo.disable_damageBonus / 100)
      Damagebonus = Damagebonus + mun
    end
    if curItemInfo.display_disable_damageAbsorption ~= 0 then
      local mun = math.floor(curItemInfo.display_disable_damageAbsorption / 100)
      Damageabsorb = Damageabsorb + mun
    end
    if curItemInfo.moveSpeed_mul ~= 0 then
      local mun = math.floor(curItemInfo.moveSpeed_mul / 100)
      if RoleManager.me.data.rideMount and curItemInfo.id == RoleManager.me.data.rideMount.itemId then
        MoveSpeedmul = mun
      end
    end
    if curItemInfo.disable_resistDamageReflection ~= 0 then
      local mun = math.floor(curItemInfo.disable_resistDamageReflection / 100)
      resistDamageReflection = resistDamageReflection + mun
    end
    if curItemInfo.disable_monsterDropRate and curItemInfo.disable_monsterDropRate ~= 0 then
      local mun = math.floor(curItemInfo.disable_monsterDropRate / 100)
      monsterDropRate = monsterDropRate + mun
    end
  end
  if 0 < fight then
    table.insert(Attinfo, {
      name = MountAttribute.fight,
      value = fight
    })
  end
  if 0 < Minattack then
    table.insert(Attinfo, {
      name = MountAttribute.Minattack,
      value = Minattack
    })
  end
  if 0 < Maxattack then
    table.insert(Attinfo, {
      name = MountAttribute.Maxattack,
      value = Maxattack
    })
  end
  if 0 < Defense then
    table.insert(Attinfo, {
      name = MountAttribute.Defense,
      value = Defense
    })
  end
  if 0 < Damagebonus then
    table.insert(Attinfo, {
      name = MountAttribute.Damagebonus,
      value = Damagebonus .. "%"
    })
  end
  if 0 < Damageabsorb then
    table.insert(Attinfo, {
      name = MountAttribute.Damageabsorb,
      value = Damageabsorb .. "%"
    })
  end
  if 0 < MoveSpeedmul then
    table.insert(Attinfo, {
      name = MountAttribute.MoveSpeedmul,
      value = MoveSpeedmul .. "%"
    })
  end
  if 0 < resistDamageReflection then
    table.insert(Attinfo, {
      name = MountAttribute.ResistDamageReflection,
      value = resistDamageReflection .. "%"
    })
  end
  if 0 < monsterDropRate then
    table.insert(Attinfo, {
      name = ClientTable.cfg_Ui_word_attributeManager:GetKeyWord("monsterDropRate", "attributeUI"),
      value = monsterDropRate .. "%"
    })
  end
  return Attinfo
end

function Mount_MountStorage:RefreshAttribute()
  local Attinfo = self:AllAttributeData()
  if self.AttributeContainer == nil then
    self.AttributeContainer = UIContainer(self.txt_attribute, self, AttOnCreate, AttRefresh)
  end
  if Attributeindex == 1 then
    local showitem = {
      Attinfo[1]
    }
    self.go_switch:SetAnchoredPosition(switchselfX, switchselfY)
    self.sv_rideList.transform:GetComponent("RectTransform").offsetMax = Vector2(sv_rideTop.x, sv_rideTop.y)
    self.AttributeContainer:SetData(showitem)
  else
    local plus = switchplusY * (#Attinfo - 1)
    local switchy = switchselfY - plus
    local sv_ridey = sv_rideTop.y - plus
    self.go_switch:SetAnchoredPosition(switchselfX, switchy)
    self.sv_rideList.transform:GetComponent("RectTransform").offsetMax = Vector2(sv_rideTop.x, sv_ridey)
    self.AttributeContainer:SetData(Attinfo)
  end
end

function Mount_MountStorage:Refresh()
  self:RefreshToggle()
end
