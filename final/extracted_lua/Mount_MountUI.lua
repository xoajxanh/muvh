Mount_MountUI = class(BaseUI)
Mount_MountUI.layer = UILayer.Panel
Mount_MountUI.orderInLayer = 0
Mount_MountUI.hideType = UIHideType.Destroy
Mount_MountUI.hideFunc = UIHideFunc.MoveOutOfScreen
Mount_MountUI.escClose = UIEscClose.DontClose

function Mount_MountUI:InitControls()
  self.btn_closeBg = self:GetControl("btn_closeBg")
  self.btn_openPanel = self:GetControl("btn_openPanel")
  self.lab_name = self:GetControl("go_mountModel/lab_name")
  self.Img_modelBg = self:GetControl("go_mountModel/Img_modelBg")
  self.LevelScroll = self:GetControl("go_mountModel/LevelScroll")
  self.mountBtnItem = self:GetControl("go_mountModel/LevelScroll/Viewport/LevelContent/mountBtnItem")
  self.img_bg_title = self:GetControl("go_mountModel/img_bg_title")
  self.go_model = self:GetControl("go_mountModel/go_model")
  self.lab_fight = self:GetControl("go_mountModel/lab_fight")
  self.dragArea = self:GetControl("go_mountModel/dragArea")
  self.btn_attributeCollect = self:GetControl("btn_attributeCollect")
  self.btn_preview = self:GetControl("btn_preview")
  self.btn_exitPreview = self:GetControl("btn_exitPreview")
  self.defaultToggle = self:GetControl("defaultToggle")
  self.btn_exitRide = self:GetControl("btn_exitRide")
  self.btn_ride = self:GetControl("btn_ride")
  self.btn_activateRide = self:GetControl("btn_activateRide")
  self.ActiveItem = self:GetControl("ActiveItem")
  self.img_activateItem = self:GetControl("ActiveItem/img_activateItem")
  self.itemText = self:GetControl("ActiveItem/img_activateItem/itemText")
  self.btnAdd = self:GetControl("ActiveItem/img_activateItem/btnAdd")
  self.btn_close = self:GetControl("btn_close")
  self.descBtn = self:GetControl("descBtn")
end

local selectItemIndex = 1
local selectFrameObj, selectMountObj, curItemInfo
local isPreviewRide = false
local curPointPosX, lastPointPosX, curRotation
local ShowMountList = {}
local modelDic = {}

function Mount_MountUI:Init()
  self.iconContainer = {}
end

function Mount_MountUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

local function mountCreat(ctr)
  ctr.txt_mount_tip = UIControl(ctr.transform, "txt_mount_tip")
  ctr.txt_mount_txt = UIControl(ctr.transform, "txt_mount_txt")
end

local function mountRefresh(ctr, _, data, ui)
  ctr.txt_mount_txt:SetText(data.value)
  ctr.txt_mount_tip:SetText(data.att)
end

function Mount_MountUI:InitUI()
  self.mountBtnItemContaine = UIContainer(self.mountBtnItem, self, mountCreat, mountRefresh)
end

function Mount_MountUI:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function Mount_MountUI:OnHide()
  selectItemIndex = 1
  selectFrameObj = nil
  for i, v in pairs(modelDic) do
    UnityEngineLua.GameObject.Destroy(v)
  end
  selectMountObj = nil
  curItemInfo = nil
  curPointPosX = nil
  lastPointPosX = nil
  curRotation = nil
  ShowMountList = {}
  modelDic = {}
  self:OffPreviewMount()
  self.mountBtnItemContaine:SetData({})
end

function Mount_MountUI:OnDestroy()
end

function Mount_MountUI:RegistUIEvents()
  self.btn_close:SetOnClick(self, self.btn_closeOnClick)
  self.descBtn:SetOnClick(self, self.btn_descBtnOnclick)
  self.btn_activateRide:SetOnClick(self, self.btn_activateRideOnClick)
  self.img_activateItem:SetOnClick(self, self.img_activateItemOnClick)
  self.btn_ride:SetOnClick(self, self.btn_rideOnClick)
  self.btn_exitRide:SetOnClick(self, self.btn_exitRideOnClick)
  self.btn_preview:SetOnClick(self, self.btn_previewOnClick)
  self.btn_openPanel:SetOnClick(self, self.btn_openPanelOnClick)
  self.dragArea:SetOnPointerUp(self, self.OnDragUp)
  self.dragArea:SetOnDrag(self, self.OnDragArea)
  self.btn_closeBg:SetOnClick(self, self.btn_closeOnClick)
end

function Mount_MountUI:btn_closeOnClick(control)
  UIManager.Hide(UIID.MountUI)
end

function Mount_MountUI:btn_descBtnOnclick()
  local lvCfg = ConfigManager.FindConfigs("cfg_Ui_description", "uiName", "Mount_MountUI")
  UIManager.Show(UIID.System_DescUI, {
    id = lvCfg[1].id
  })
end

local function PromptOK(okArgs)
  if okArgs.selectItem then
    NetManager.Send(EquipMessage.ReqPutOnTheEquip, {
      position = tonumber(curItemInfo.equipPosition),
      equipId = okArgs.selectItem.id
    })
  end
end

function Mount_MountUI:btn_activateRideOnClick(control)
  if curItemInfo == nil then
    return
  end
  local item = BagInfoData.GetItemByConfigID(curItemInfo.itemId)
  if item then
    local str = string.format("B\225\186\161n c\195\179 mu\225\187\145n ti\195\170u hao \196\145\225\186\161o c\225\187\165 \196\145\225\187\131 k\195\173ch ho\225\186\161t th\195\186 c\198\176\225\187\161i kh\195\180ng?")
    UIManager.Show(UIID.PromptTipUI, {
      title = "Nh\225\186\175c nh\225\187\159",
      textContent = str,
      cancelText = "",
      okText = "",
      cancel = nil,
      ok = PromptOK,
      okArgs = {selectItem = item}
    })
  else
    local str = string.format(LocalizationUtility.GetContentByKey("zuoqijihuodaojubuzu"), curItemInfo.name)
    FloatingWordUtility.QuickBtnMsg({
      parent = self.btn_activateRide,
      msgStr = str
    })
  end
end

function Mount_MountUI:img_activateItemOnClick(control)
  local itemData = ItemUtility.GenerateItemData(curItemInfo.itemId)
  UIManager.Show(UIID.ItemTipUI, {
    item = itemData,
    rightOperate = EItemOperateType.Show,
    ctrl = control
  })
end

function Mount_MountUI:btn_rideOnClick(control)
  if curItemInfo == nil or RoleManager.me.hp <= 0 then
    return
  end
  if Scene.sitPos then
    FloatingWordUtility.QuickMsg("Tr\225\186\161ng th\195\161i ng\225\187\147i xu\225\187\145ng kh\195\180ng th\225\187\131 c\198\176\225\187\161i th\195\186 c\198\176\225\187\161i")
    return
  end
  NetManager.Send(EquipMessage.ReqEquipDefaultHorse, {
    equipId = curItemInfo.id
  })
  NetManager.Send(EquipMessage.ReqChangeHorseState, {
    position = curItemInfo.bagGridIndex,
    ride = true
  })
end

function Mount_MountUI:btn_exitRideOnClick(control)
  if curItemInfo == nil or RoleManager.me.hp <= 0 then
    return
  end
  NetManager.Send(EquipMessage.ReqChangeHorseState, {
    position = curItemInfo.bagGridIndex,
    ride = false
  })
end

function Mount_MountUI:btn_previewOnClick(control)
  isPreviewRide = not isPreviewRide
  self:SetMountStatus(isPreviewRide)
end

function Mount_MountUI:btn_openPanelOnClick(control)
  if UIManager.IsVisible(UIID.MountSubUI) then
    UIManager.Hide(UIID.MountSubUI)
    self.btn_openPanel:SetLocalEulerAngles(Vector3(0, 0, 180))
  else
    UIManager.Show(UIID.MountSubUI)
    self.btn_openPanel:SetLocalEulerAngles(Vector3(0, 0, 0))
  end
end

function Mount_MountUI:btn_closeMountSubUIOnClick(control)
end

function Mount_MountUI:btn_closeAttributeCollectUIOnClick(control)
  self.AttributeCollectUI:SetActive(false)
end

function Mount_MountUI:OnDragArea(control, eventData)
  if selectMountObj == nil then
    return
  end
  if curPointPosX == nil then
    curPointPosX = eventData.position.x
    lastPointPosX = eventData.position.x
  else
    curPointPosX = eventData.position.x
    curRotation = selectMountObj.transform.localEulerAngles
    selectMountObj.transform.localEulerAngles = Vector3(curRotation.x, curRotation.y - (curPointPosX - lastPointPosX), curRotation.z)
    lastPointPosX = curPointPosX
  end
end

function Mount_MountUI:OnDragUp(control, eventData)
  curPointPosX = nil
  lastPointPosX = nil
end

function Mount_MountUI:RegistEvents()
  self:RegistEvent(Event.Role_OnMove, self.OnMainPlayerMoveFunc, self)
  self:RegistEvent(Event.Mount_ShowChange, self.RefreshMount, self)
end

function Mount_MountUI:RefreshMount()
  self:ControlSwitch()
  local itemInfo = MountData.curItemInfo
  curItemInfo = itemInfo
  if not itemInfo then
    self:NoMontShow()
    return
  end
  selectItemIndex = itemInfo.index
  self.lab_name:SetText(itemInfo.name)
  self:LoadMountModel(itemInfo)
  self.lab_fight:SetText(tostring(itemInfo.fight))
  self:SetMountOperation(itemInfo)
  self:SetButtonStatus()
  if isPreviewRide then
    self:SetMountStatus(true)
  end
  self:SetAtrribute(itemInfo)
end

function Mount_MountUI:ControlSwitch()
  local Open = #RoleManager.me.data.mountData.Mounts ~= 0 and true or false
  self.img_bg_title:SetActive(Open)
  self.LevelScroll:SetActive(Open)
  self.Img_modelBg:SetActive(Open)
end

function Mount_MountUI:NoMontShow()
  if selectMountObj then
    selectMountObj:SetActive(false)
  end
  self.Img_modelBg:SetActive(false)
  self.defaultToggle:SetActive(false)
  self.btn_ride:SetActive(false)
  self.btn_exitRide:SetActive(false)
end

function Mount_MountUI:SetAtrribute(itemInfo)
  local Attinfo = MountData:AddItemAttribute(itemInfo.tblEquip)
  local attvalue = {}
  for i = 1, #Attinfo do
    local data = {}
    data.att = Attinfo[i].name
    data.value = Attinfo[i].value
    attvalue[i] = data
  end
  self.mountBtnItemContaine:SetData(attvalue)
end

function Mount_MountUI:LoadMountModel(itemdata)
  Coroutine.Start(self.InitShowModel, self, itemdata)
end

function Mount_MountUI:InitShowModel(itemdata)
  if selectMountObj then
    selectMountObj:SetActive(false)
  end
  local go
  if not table.containsKey(modelDic, itemdata.model) then
    local path = string.format("Model/%s/%s.prefab", itemdata.route, itemdata.model)
    local request = self:LoadAssetAsync(path, typeof(CS.UnityEngine.GameObject))
    Coroutine.Yield(request)
    if request.isError then
      logError(request.error)
      Coroutine.Break()
    end
    go = Instantiate(request.res)
    modelDic[itemdata.model] = go
  else
    go = modelDic[itemdata.model]
    go:SetActive(true)
  end
  selectMountObj = go
  self:SetModel(go)
end

function Mount_MountUI:SetModel(go)
  local mountInfo = ClientTable.cfg_Item_mountManager:TryGetValue(MountData.curItemInfo.itemId)
  go.transform:SetParent(self.go_model.transform, false)
  go.transform.localPosition = Vector3(-10, -180, -500)
  go.transform.localEulerAngles = Vector3(0, 135, 0)
  if mountInfo and not string.isNullOrEmpty(mountInfo.size) then
    go.transform.localScale = Vector3(mountInfo.size, mountInfo.size, mountInfo.size)
  else
    go.transform.localScale = Vector3(50, 50, 50)
  end
  go.layer = 5
  local skinMeshes = go:GetComponentInChildren(typeof(CS.UnityEngine.SkinnedMeshRenderer))
  if skinMeshes then
    skinMeshes.gameObject.layer = 5
  end
  local particles = go:GetComponentsInChildren(typeof(CS.UnityEngine.ParticleSystem))
  if particles then
    for i = 0, particles.Length - 1 do
      particles[i].gameObject.layer = 5
      local renderer = particles[i].gameObject:GetComponent(typeof(CS.UnityEngine.Renderer))
      if renderer then
        renderer.sortingOrder = 201
      end
      particles[i]:Play()
    end
  end
  local animator = go:GetComponent(typeof(CS.UnityEngine.Animator))
  animator:Play("idle")
end

function Mount_MountUI:SetMountOperation(itemInfo)
  self:SetSprite("Atlas_Icon", itemInfo.icon, self.img_activateItem, false)
  local count = BagInfoData.GetItemCountByItemConfigId(itemInfo.itemId)
  local material
  if count < 1 then
    material = MaterialUtility:GetGreyMat()
  end
  self.btnAdd:SetActive(count < 1)
  self.img_activateItem:SetMaterial(material)
  if 0 < count then
    self.itemText:SetText(string.GetColorText(string.format("%d/1", count), "#00FF00"))
  else
    self.itemText:SetText(string.GetColorText(string.format("%d/1", count), "#FF0000"))
  end
end

function Mount_MountUI:SetMountStatus(setRide)
  if setRide then
    self:SetSprite("Atlas_Mount", "btn_exitPreview", self.btn_preview, false)
    RoleManager.me:SetMount(curItemInfo.model)
  else
    self:SetSprite("Atlas_Mount", "btn_preview", self.btn_preview, false)
    RoleManager.me:RefreshMount()
  end
end

function Mount_MountUI:SetButtonStatus()
  if curItemInfo == nil then
    return
  end
  self.btn_activateRide:SetActive(not curItemInfo.isActive)
  self.btn_ride:SetActive(curItemInfo.isActive and not curItemInfo.valid)
  self.btn_exitRide:SetActive(curItemInfo.valid)
  self.ActiveItem:SetActive(not curItemInfo.isActive)
  if curItemInfo.id == MountData.DefaultMount then
    self.defaultToggle:SetActive(true)
  else
    self.defaultToggle:SetActive(false)
  end
end

function Mount_MountUI:OnMainPlayerMoveFunc(id, msg)
  self:OffPreviewMount()
end

function Mount_MountUI:OffPreviewMount()
  if isPreviewRide then
    isPreviewRide = not isPreviewRide
    self:SetMountStatus(isPreviewRide)
  end
end

function Mount_MountUI:Refresh()
  if MountData.curItemInfo then
    self:RefreshMount()
  end
end
