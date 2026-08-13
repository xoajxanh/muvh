Login_LoginRoleUI = class(BaseUI)
Login_LoginRoleUI.layer = UILayer.Panel
Login_LoginRoleUI.orderInLayer = 1
Login_LoginRoleUI.hideType = UIHideType.Destroy
Login_LoginRoleUI.hideFunc = UIHideFunc.Deactive
Login_LoginRoleUI.escClose = UIEscClose.DontClose

function Login_LoginRoleUI:InitControls()
  self.Panel_LoginRole = self:GetControl("Panel_LoginRole")
  self.btn_CreateRole = self:GetControl("Panel_LoginRole/btn_CreateRole")
  self.btn_Connect = self:GetControl("Panel_LoginRole/btn_Connect")
  self.btn_Back = self:GetControl("Panel_LoginRole/btn_Back")
  self.btn_CancleDelete = self:GetControl("Panel_LoginRole/btn_CancleDelete")
  self.lab_cancleDelete = self:GetControl("Panel_LoginRole/btn_CancleDelete/lab_cancleDelete")
  self.go_NameList = self:GetControl("Panel_LoginRole/go_NameList")
  self.RoleInfo = self:GetControl("Panel_LoginRole/go_NameList/RoleInfo")
  self.btn_DeleteOne = self:GetControl("Panel_LoginRole/btn_DeleteOne")
end

local Input = CS.UnityEngine.Input
local PhysicsEx = CS.Framework.PhysicsEx
local clickCdTime = 1
local timeDuring = clickCdTime
local clickCount = 0
local clickTimeDuring = 0
local doubleClick = 0.3

function Login_LoginRoleUI:Init()
  self.RoleHeight = 270
  self.RoleModelInfoTbl = {}
  self.PetModelInfoTbl = {}
  self.nameContainer = {}
  self.delTimeCoutdown = {}
  self.curRole = nil
  self.effectCol = nil
  self.effectRequest = nil
  self.originPos = Vector3.zero
  self.noSelect = false
  self.newCreateId = -1
  self.loadingPanelIsLoaded = false
  self.isNoRole = true
  self.selectRoleButtonId = nil
end

function Login_LoginRoleUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Login_LoginRoleUI:InitUI()
  self:NameInit()
  self:NoRoleList()
end

function Login_LoginRoleUI:NoRoleList()
  self.btn_Connect:SetActive(false)
end

function Login_LoginRoleUI:InitDelTime()
  if self.delTimeCoutdown ~= nil then
    Timer.Stop(self.delTimeCoutdown)
    self.delTimeCoutdown = nil
  end
  local longTime = 0
  for _, roleInfo in pairs(self.RoleModelInfoTbl) do
    if roleInfo.data.isDel and longTime < roleInfo.data.refreshSec then
      longTime = roleInfo.data.refreshSec
    end
  end
  if longTime ~= 0 then
    self.delTimeCoutdown = Timer.StartLoop(1, longTime, self.RefreshDelTime, self)
  end
end

function Login_LoginRoleUI:SetDeTime()
  self.nameContainer:RefreshKTable()
end

function Login_LoginRoleUI:RefreshDelTime()
  local overdueRole
  for i = #self.RoleModelInfoTbl, 1, -1 do
    local roleInfo = self.RoleModelInfoTbl[i]
    if roleInfo.data.isDel then
      roleInfo.data.refreshSec = roleInfo.data.refreshSec - 1
      if roleInfo.data.refreshSec <= 0 then
        overdueRole = roleInfo
        if self.curRole and self.curRole == overdueRole then
          self.curRole = nil
        end
        table.remove(LoginData.roleList, i)
        table.remove(self.RoleModelInfoTbl, i)
        overdueRole:Destroy()
        self:ShowRoleList()
      end
    end
  end
  if not overdueRole then
    self:SetDeTime()
  end
end

local function NameOnCreate(ctr)
  ctr.lab_name = UIControl(ctr.transform, "lab_Name")
  ctr.lab_careerAndLevel = UIControl(ctr.transform, "lab_CareerAndLevel")
  ctr.img_memberIcon = UIControl(ctr.transform, "lab_Name/img_memberIcon")
  ctr.btn_Delete = UIControl(ctr.transform, "btn_Delete")
  ctr.btn_CancelDelete = UIControl(ctr.transform, "btn_CancelDelete")
  ctr.lab_cancelDeleteTime = UIControl(ctr.transform, "lab_cancelDeleteTime")
end

local function NameOnRefresh(ctr, _, role, ui)
  local data = role.data
  if not data.refresh then
    data.refresh = true
    role:SetPosition(data.x, data.y, data.z)
    local screenPos = MainCamera.camera:WorldToScreenPoint(Vector3.New(data.x, data.y, data.z))
    ctr:SetAnchoredPosition(screenPos.x * UIManager.ratio, screenPos.y * UIManager.ratio + ui.RoleHeight)
    ctr.lab_name:SetText(data.name)
    local levelText = ""
    local tbl = ClientTable.cfg_Character_levelManager:TryGetValue(data.level)
    if tbl ~= nil and not string.isNullOrEmpty(tbl.name) then
      levelText = tbl.name
    end
    ctr.lab_careerAndLevel:SetText(string.format("%s %s", RoleUtility.GteCareerNameByType(data.career), levelText))
    local memberShow = false
    if memberShow then
      local memberIconSize = ctr.img_memberIcon.rectTransform.sizeDelta
      local sizeData = ctr.rectTransform.sizeDelta
      local targetSize = ctr.lab_name.text.preferredWidth + memberIconSize.x + 10
      if targetSize > sizeData.x then
        ctr.rectTransform.sizeDelta = Vector2.right * targetSize + Vector2.up * sizeData.y
      end
      local xOffSet = (targetSize - 10) / 2 - ctr.lab_name.text.preferredWidth / 2
      ctr.lab_name.rectTransform.anchoredPosition = Vector2.right * xOffSet + Vector2.up * ctr.lab_name.rectTransform.anchoredPosition.y
      local iconPos = ctr.img_memberIcon.rectTransform.anchoredPosition
      ctr.img_memberIcon.rectTransform.anchoredPosition = Vector2.right * -(targetSize - 10) / 2 + Vector2.up * iconPos.y
    end
  end
  if ctr.remainTimeLoop then
    Timer.Stop(ctr.remainTimeLoop)
    ctr.remainTimeLoop = nil
  end
  local lastRecordTime = role.data.calmTime
  local surplusSec = TimeUtility.RefreshSec(TimeUtility.AddDay(role.data.calmTime, 1))
  if lastRecordTime ~= 0 and 0 < surplusSec then
    ctr.btn_CancelDelete:SetActive(true)
    ctr.lab_cancelDeleteTime:SetActive(true)
    ctr.lab_cancelDeleteTime:SetText(string.format(LocalizationUtility.GetContentByKey("DeleteRole_2"), TimeUtility.ShowNewTime(surplusSec)))
    ctr.remainTimeLoop = Timer.StartLoopForever(1, function()
      local surplusSec = TimeUtility.RefreshSec(TimeUtility.AddDay(role.data.calmTime, 1))
      ctr.lab_cancelDeleteTime:SetText(string.format(LocalizationUtility.GetContentByKey("DeleteRole_2"), TimeUtility.ShowNewTime(surplusSec)))
      if surplusSec <= 0 then
        Timer.Stop(ctr.remainTimeLoop)
        ctr.remainTimeLoop = nil
      end
    end)
  else
    ctr.btn_CancelDelete:SetActive(false)
    ctr.lab_cancelDeleteTime:SetActive(false)
  end
  ctr.btn_Delete.id = role.data.id
  ctr.btn_Delete:SetOnClick(ui, ui.Btn_DeleteOnClick)
  ctr.btn_CancelDelete:SetOnClick(ui, function()
    networkRequest.ReqCancelDelRole(role.data.id)
  end)
end

function Login_LoginRoleUI:NameInit()
  self.nameContainer = UIContainer(self.RoleInfo, self, NameOnCreate, NameOnRefresh)
end

function Login_LoginRoleUI:OnShow()
  CS.LauncherUI.Close()
  self:RegistEvents()
  self:Refresh()
  if (not self.args or not self.args.silent) and not LoginData.needInviteCode then
    self:AnimationShow(true)
  end
  self:ShowRoleList()
  self:InitDelTime()
  ActionStepsLogManager.SetRoleAction(ActionStepsType.EnterCreateRoleUI)
  EventManager.Dispatch(Event.Load_PreLoadEndOneJionGame)
end

function Login_LoginRoleUI:OnHide()
  self:StopDeleteRoleTimer()
  CommercialTimeLimitedActivityData.RoleList = LoginData.roleList
  LoginData.ReSet()
  for index, _ in pairs(self.RoleModelInfoTbl) do
    self.RoleModelInfoTbl[index]:Destroy()
  end
  self.newCreateId = -1
  self.RoleModelInfoTbl = {}
  self.PetModelInfoTbl = {}
  self.nameContainer = {}
  if not IsNil(self.selectEffect) then
    CS.Framework.ObjectEx.Destroy(self.selectEffect.gameObject)
  end
  self.selectEffect = nil
  self.curRole = nil
  if self.delTimeCoutdown ~= nil then
    Timer.Stop(self.delTimeCoutdown)
    self.delTimeCoutdown = nil
  end
  self:StopLoadEffect()
  timeDuring = clickCdTime
end

function Login_LoginRoleUI:SaveCurRoleId()
  PlayerPrefs.SetString("curSelectRole", self.curRole.id)
end

function Login_LoginRoleUI:GetCurSelectRoleId()
  return PlayerPrefs.GetString("curSelectRole", "")
end

function Login_LoginRoleUI:OnDestroy()
  self.loadingPanelIsLoaded = false
  self.isNoRole = true
end

function Login_LoginRoleUI:FindModelInfo(roleInfo)
  for _, role in pairs(self.RoleModelInfoTbl) do
    if roleInfo.info.roleId == role.data.id then
      return role
    end
  end
end

function Login_LoginRoleUI:SelectRole(infoTbl)
  if self.newCreateId ~= -1 then
    for i, info in pairs(infoTbl) do
      if info.id == self.newCreateId then
        self.curRole = infoTbl[i]
        self:SaveCurRoleId()
        self.newCreateId = -1
        return
      end
    end
  end
  if self.curRole == nil and 0 < #infoTbl then
    local select = self:GetCurSelectRoleId()
    for i, info in pairs(infoTbl) do
      if not string.isNullOrEmpty(select) and tonumber(select) == infoTbl[i].id then
        self.curRole = infoTbl[i]
      end
    end
    if self.curRole == nil then
      self.curRole = infoTbl[1]
    end
  end
end

local offsetPos = Vector3.New(0, 205, 0)

function Login_LoginRoleUI:AnimationShow(isDown, haveCallBack)
  if haveCallBack then
    UIManager.Show(UIID.LoginCreateRoleUI)
  end
end

function Login_LoginRoleUI:ShowRoleList()
  if LoginData.roleList ~= nil then
    LoginData.roleCount = #LoginData.roleList > 4 and 4 or #LoginData.roleList
    self.isNoRole = LoginData.roleCount == 0
    for i = 1, LoginData.roleCount do
      local role = LoginData.roleList[i]
      if not self:FindModelInfo(role) then
        self:InitShowRole(role, i)
      else
        self:RefreshShowRole(role, i)
      end
    end
    self.nameContainer:SetData(self.RoleModelInfoTbl)
    self.btn_DeleteOne:SetActive(table.count(self.RoleModelInfoTbl) ~= 0)
    self:SelectRole(self.RoleModelInfoTbl)
    if self.curRole ~= nil then
      self:ShowDeleteBtn()
      self:ShowSelectEffect()
      self:ShowRoleState()
      self:ShowCancleDeleteBtn()
    else
      self:NoRoleList()
    end
  end
end

function Login_LoginRoleUI:RefreshShowRole(roleInfo, index)
  local role = self.RoleModelInfoTbl[index]
  local rolePos = LoginData.roleInitPos[index]
  if role then
    role.data.isDel = roleInfo.isDel
    role.data.delTime = roleInfo.delTime
    role.data.refreshSec = roleInfo.refreshSec
    role.data.x = rolePos.x
    role.data.y = rolePos.y
    role.data.z = rolePos.z
    role.data.refresh = false
    role.data.calmTime = roleInfo.calmTime
  end
  role:SetPosition(rolePos.x, rolePos.y, rolePos.z)
  role:PetReset()
end

function Login_LoginRoleUI:InitShowRole(role, index)
  local rolePos = LoginData.roleInitPos[index]
  local data = {
    id = role.info.roleId,
    name = role.info.name,
    unionName = role.info.unionName,
    unionLogo = role.info.unionLogo,
    createTime = role.info.createTime,
    model = "1003",
    x = rolePos.x,
    y = rolePos.y,
    z = rolePos.z,
    dir = 180,
    moveSpeed = 2.2,
    VecScale = 1,
    equipModel = {},
    selectRoleScene = true,
    career = role.info.career,
    modelType = EModelType.Charactor,
    equipsData = RoleEquipData(role.equips),
    rideMount = self:GetRideMount(role),
    revealWing = self:GetWing(role),
    isDel = role.isDel,
    delTime = role.delTime,
    level = role.info.level,
    refreshSec = role.refreshSec,
    refresh = false,
    roleType = ERoleType.Player,
    holyRingInfo = role.holyRingInfo,
    calmTime = role.calmTime,
    boxColliderSize = Vector3(6, 20, 1)
  }
  data.PetData = RoleEquipUtility.GetCurEquipShowData(ForgeData.appearData[data.id], data.equipsData.Data, ERoleEquipPosition.pet)
  data.model, data.modelScale = RoleEquipUtility.GetCurPlayerModelName(ForgeData.appearData[data.id], data.equipsData.Data)
  local mRole = RevealPlayer(data)
  self.RoleModelInfoTbl[index] = mRole
  if data.PetData then
    self.PetModelInfoTbl[index] = mRole
  end
end

function Login_LoginRoleUI:ShowDeleteBtn()
  for i = self.nameContainer.maxCount, 1, -1 do
    if self.nameContainer.data[i].gameObject == self.curRole.gameObject then
      self.nameContainer.items[i].btn_Delete:SetActive(false)
      self.selectRoleButtonId = self.nameContainer.items[i].btn_Delete.id
    else
      self.nameContainer.items[i].btn_Delete:SetActive(false)
    end
  end
end

function Login_LoginRoleUI:ShowCancleDeleteBtn()
  if self.curRole == nil or self.curRole.data and self.curRole.data.calmTime ~= 0 and 0 < TimeUtility.RefreshSec(TimeUtility.AddDay(self.curRole.data.calmTime, 1)) then
    self.btn_DeleteOne:SetActive(false)
  else
    self.btn_DeleteOne:SetActive(true)
  end
end

function Login_LoginRoleUI:StopDeleteRoleTimer()
  local items = self.nameContainer.items
  if table.isNullOrEmpty(items) then
    return
  end
  for i, item in pairs(items) do
    if item.remainTimeLoop then
      Timer.Stop(item.remainTimeLoop)
      item.remainTimeLoop = nil
    end
  end
end

function Login_LoginRoleUI:ShowSelectEffect()
  if self.selectEffect == nil then
    if self.effectRequest then
      return
    end
    self.effectCol = Coroutine.Start(self.DoLoadEffect, self)
  else
    self.selectEffect.transform:SetParent(self.curRole.model.transform, false)
    self.selectEffect.transform.localPosition = Vector3.zero
  end
end

function Login_LoginRoleUI:StopLoadEffect()
  if self.effectCol then
    Coroutine.Stop(self.effectCol)
    self.effectCol = nil
  end
  if self.effectRequest then
    self.effectRequest:Dispose()
    self.effectRequest = nil
  end
end

function Login_LoginRoleUI:DoLoadEffect()
  self.effectRequest = CS.Framework.ResourceManager.InstantiateAsync("Effect/Scene/Teleport_15.prefab", self.curRole.model.transform, false)
  Coroutine.Yield(self.effectRequest)
  if not self.effectRequest or self.effectRequest.isError then
    Coroutine.Break()
  end
  self.selectEffect = self.effectRequest.gameObject
  self.selectEffect.transform.localPosition = Vector3.zero
  self.effectRequest = nil
  self.effectCol = nil
end

function Login_LoginRoleUI:ShowRoleState()
  self.loadingPanelIsLoaded = UIManager.CheckUIIsLoaded(UIID.LoadingUI)
  local curRoleIsInDelTime = self.curRole and self.curRole.data and self.curRole.data.calmTime ~= 0 and 0 < TimeUtility.RefreshSec(TimeUtility.AddDay(self.curRole.data.calmTime, 1))
  if self.loadingPanelIsLoaded == false or curRoleIsInDelTime then
    self.btn_Connect:SetActive(false)
  else
    self.btn_Connect:SetActive(true)
  end
end

function Login_LoginRoleUI:GetRideMount(role)
  for i = 1, #role.equips do
    local tblItem = ClientTable.cfg_Item_itemManager:TryGetValue(role.equips[i].itemId)
    if tblItem.type == 2 and tblItem.subType == 22 then
      local itemEquip = ClientTable.cfg_Item_equipManager:TryGetValue(role.equips[i].itemId)
      local mountData = MountItemData(role.equips[i], tblItem, itemEquip)
      if mountData ~= nil and mountData.valid then
        return mountData
      end
    end
  end
  return nil
end

function Login_LoginRoleUI:GetWing(role)
  for i = 1, #role.equips do
    local itemData = ItemUtility.GenerateItemDataByServerData(role.equips[i])
    if itemData.tblItem.type == EItemType.Equipe and itemData.subType == EItemSubtype.Wing then
      return true
    end
  end
  return nil
end

local Input = CS.UnityEngine.Input
local KeyCode = CS.UnityEngine.KeyCode

function Login_LoginRoleUI:Update()
  if not self.loadingPanelIsLoaded then
    self.loadingPanelIsLoaded = UIManager.CheckUIIsLoaded(UIID.LoadingUI)
    local curRoleIsInDelTime = self.curRole == nil or self.curRole.data and self.curRole.data.calmTime ~= 0 and 0 < TimeUtility.RefreshSec(TimeUtility.AddDay(self.curRole.data.calmTime, 1))
    if self.loadingPanelIsLoaded and not self.isNoRole and curRoleIsInDelTime == false then
      self.btn_Connect:SetActive(true)
    else
      self.btn_Connect:SetActive(false)
    end
  end
  self:OnClick()
  for _, v in pairs(self.PetModelInfoTbl) do
    v:Update()
  end
  if Input.GetKeyDown(KeyCode.Tab) and LoginData.isWhite then
    UIManager.Show(UIID.GM_ToolUI)
  end
end

function Login_LoginRoleUI:OnClick()
  timeDuring = timeDuring + 0.02
  clickTimeDuring = clickTimeDuring + 0.02
  if Input.GetMouseButtonDown(0) and self:CheckClickLayer("Role") then
    if CS.Framework.InputEx.ClickUICheck() then
      return
    end
    if timeDuring >= clickCdTime then
      if clickTimeDuring < doubleClick then
        clickCount = clickCount + 1
      else
        clickTimeDuring = 0
        clickCount = 1
      end
      if clickCount <= 1 then
        self:ClickDown()
      else
        clickCount = 0
        clickTimeDuring = 0
        if self.curRole and not self.curRole.data.isDel then
          timeDuring = 0
          self:Button_ConnectOnClick()
        end
      end
    end
  end
end

function Login_LoginRoleUI:GetModelById(modelObj)
  for _, role in pairs(self.RoleModelInfoTbl) do
    if tostring(role.data.id) == modelObj.name then
      return role
    end
  end
end

function Login_LoginRoleUI:CheckClickLayer(layer)
  local hitObj = PhysicsEx.MouseRaycast(MainCamera.camera)
  if not hitObj then
    return false
  end
  if LayerMask.LayerToName(hitObj.layer) == layer then
    return true
  end
  return false
end

function Login_LoginRoleUI:ClickDown()
  local hitObj, hitX, hitY, hitZ = PhysicsEx.MouseRaycast(MainCamera.camera)
  if not hitObj then
    return
  end
  local layerName = LayerMask.LayerToName(hitObj.layer)
  if layerName == "Role" then
    local Avatar = self:GetModelById(hitObj)
    if Avatar then
      self.curRole = Avatar
      self:SaveCurRoleId()
      self:ShowDeleteBtn()
      self:ShowSelectEffect()
      self:ShowRoleState()
      self:ShowCancleDeleteBtn()
    end
  end
end

function Login_LoginRoleUI:RegistUIEvents()
  self.btn_Connect:SetOnClick(self, self.Button_ConnectOnClick)
  self.btn_Back:SetOnClick(self, self.Button_BackOnClick)
  self.btn_CreateRole:SetOnClick(self, self.Button_CreateRoleOnClick)
  self.btn_DeleteOne:SetOnClick(self, self.Btn_DeleteOnClick)
end

function Login_LoginRoleUI:Button_ConnectOnClick(_, id)
  if not self.loadingPanelIsLoaded then
    return
  end
  if self.curRole and self.curRole.data and self.curRole.data.calmTime ~= 0 and 0 < TimeUtility.RefreshSec(TimeUtility.AddDay(self.curRole.data.calmTime, 1)) then
    return
  end
  local id = id or self.curRole and self.curRole.id
  if self.curRole then
    LoginData.roleId = self.curRole.data.id
    LoginData.roleName = self.curRole.data.name
    LoginData.roleLevel = self.curRole.data.level
    LoginData.createTime = self.curRole.data.createTime
  end
  TipUtility.GetSessionTips()
  LogManager.AddLoginLog("ReqChooseRole Begin", "Login")
  NetManager.Send(UserMessage.ReqChooseRole, {roleId = id})
  ActionStepsLogManager.SetRoleAction(ActionStepsType.SelectRole)
end

function Login_LoginRoleUI:Button_BackOnClick(control)
  UIManager.Hide(UIID.LoginCreateRoleUI)
  UIManager.Hide(UIID.LoginRoleUI)
  NetManager.Close()
  Scene.EnterLogin()
end

function Login_LoginRoleUI:BtnActive(flag, haveCallBack)
  self:AnimationShow(flag, haveCallBack)
  if flag and self.curRole ~= nil then
    self:ShowRoleState()
  else
    self:NoRoleList()
  end
end

function Login_LoginRoleUI:Button_CreateRoleOnClick(control)
  if LoginData.roleCount >= 4 then
    TipUtility.ShowPrompt("tishi", "kechuangjianjueseyiman")
    return
  end
  if LoginData.needInviteCode then
    UIManager.Show(UIID.InviteFriendUI)
    return
  end
  self:BtnActive(false, true)
end

function Login_LoginRoleUI:Btn_DeleteOnClick()
  UIManager.Show(UIID.PromptTipUI, {
    tile = LocalizationUtility.GetContentByKey("tishi"),
    textContent = string.format(LocalizationUtility.GetContentByKey("DeleteRole_1"), self.curRole.data.name),
    ok = function(data)
      NetManager.Send(UserMessage.ReqDeleteRole, {
        rid = data.id
      })
      RoleDeclareManager.DeleteRecentRole(data.id)
    end,
    okArgs = {
      id = self.selectRoleButtonId
    }
  })
end

function Login_LoginRoleUI:RegistEvents()
  self:RegistEvent(Event.Login_RefreshRoleList, self.OnRefreshRoleList, self)
  self:RegistEvent(Event.Login_CreateRole, self.OnResCreateRole, self)
  self:RegistEvent(Event.Login_OutCreateRoleUI, self.OnOutCreateRoleUI, self)
  self:RegistEvent(Event.UpdateInviteCodeState, self.UpdateInviteCodeState, self)
end

function Login_LoginRoleUI:UpdateInviteCodeState()
  if not LoginData.needInviteCode then
    self:BtnActive(false, true)
  end
end

function Login_LoginRoleUI:OnOutCreateRoleUI()
  if not LoginData.needInviteCode then
    self:BtnActive(true)
  end
end

function Login_LoginRoleUI:ResetModel(i)
  local overdueRole = table.remove(self.RoleModelInfoTbl, i)
  if not IsNil(self.PetModelInfoTbl[i]) then
    table.remove(self.PetModelInfoTbl, i)
  end
  if self.curRole == overdueRole then
    self.curRole = nil
  end
  overdueRole:Destroy()
end

function Login_LoginRoleUI:OnResCreateRole()
  local firstIdStr = PlayerPrefs.GetString(LoginData:GetFirstIdKey(), "")
  for _, v in ipairs(LoginData.roleList) do
    if v.info.name == LoginData.playerCreateName then
      if not string.contains(firstIdStr, tostring(v.info.roleId)) then
        if string.isNullOrEmpty(firstIdStr) then
          firstIdStr = tostring(v.info.roleId)
        else
          firstIdStr = string.format("%s%s%s", firstIdStr, "#", tostring(v.info.roleId))
        end
        PlayerPrefs.SetString(LoginData:GetFirstIdKey(), firstIdStr)
        PlayerPrefs.Save()
      end
      self.newCreateId = v.info.roleId
      break
    end
  end
  if table.count(LoginData.roleList) == 1 then
    local roleId = LoginData.roleList[1].info.roleId
    self:Button_ConnectOnClick(self.btn_Connect, roleId)
  else
    self:OnRefreshRoleList()
  end
end

function Login_LoginRoleUI:OnRefreshRoleList()
  local deleteList = {}
  for i, role in pairs(self.RoleModelInfoTbl) do
    local isDelete = true
    for _, roleInfo in pairs(LoginData.roleList) do
      if roleInfo.info.roleId == role.data.id then
        isDelete = false
        break
      end
    end
    if isDelete then
      table.insert(deleteList, i)
    end
  end
  for _, i in pairs(deleteList) do
    self:ResetModel(i)
  end
  self:ShowRoleList()
  self:InitDelTime()
end

function Login_LoginRoleUI:Refresh()
  local audios = ClientTable.cfg_Audio_audioManager:TryGetValue(6207, "id")
  if audios then
    AudioManager.PlayBGM(audios.resourceName, audios.volume)
  end
end
