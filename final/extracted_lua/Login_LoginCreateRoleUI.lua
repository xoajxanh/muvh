Login_LoginCreateRoleUI = class(BaseUI)
Login_LoginCreateRoleUI.layer = UILayer.Panel
Login_LoginCreateRoleUI.orderInLayer = 2
Login_LoginCreateRoleUI.hideType = UIHideType.Destroy
Login_LoginCreateRoleUI.hideFunc = UIHideFunc.Deactive
Login_LoginCreateRoleUI.escClose = UIEscClose.DontClose

function Login_LoginCreateRoleUI:InitControls()
  self.Panel_LoginCreateRole = self:GetControl("Panel_LoginCreateRole")
  self.Panel_CreateRole = self:GetControl("Panel_LoginCreateRole/Panel_CreateRole")
  self.btn_Right = self:GetControl("Panel_LoginCreateRole/Panel_CreateRole/btn_Right")
  self.btn_Left = self:GetControl("Panel_LoginCreateRole/Panel_CreateRole/btn_Left")
  self.Button_Ok = self:GetControl("Panel_LoginCreateRole/Panel_CreateRole/Button_Ok")
  self.InputField_Name = self:GetControl("Panel_LoginCreateRole/Panel_CreateRole/InputField_Name")
  self.Button_RandomName = self:GetControl("Panel_LoginCreateRole/Panel_CreateRole/Button_RandomName")
  self.go_roleInfo = self:GetControl("Panel_LoginCreateRole/Panel_CreateRole/go_roleInfo")
  self.Img_roleLeftBg = self:GetControl("Panel_LoginCreateRole/Panel_CreateRole/go_roleInfo/Img_roleLeftBg")
  self.go_roleLeft = self:GetControl("Panel_LoginCreateRole/Panel_CreateRole/go_roleInfo/Img_roleLeftBg/go_roleLeft")
  self.Img_roleMiddleBg = self:GetControl("Panel_LoginCreateRole/Panel_CreateRole/go_roleInfo/Img_roleMiddleBg")
  self.img_seletBg = self:GetControl("Panel_LoginCreateRole/Panel_CreateRole/go_roleInfo/Img_roleMiddleBg/img_seletBg")
  self.plane_selectBottom = self:GetControl("Panel_LoginCreateRole/Panel_CreateRole/go_roleInfo/Img_roleMiddleBg/img_seletBg/plane_selectBottom")
  self.go_roleMiddle = self:GetControl("Panel_LoginCreateRole/Panel_CreateRole/go_roleInfo/Img_roleMiddleBg/go_roleMiddle")
  self.Img_roleRightBg = self:GetControl("Panel_LoginCreateRole/Panel_CreateRole/go_roleInfo/Img_roleRightBg")
  self.go_roleRight = self:GetControl("Panel_LoginCreateRole/Panel_CreateRole/go_roleInfo/Img_roleRightBg/go_roleRight")
  self.img_roleCareer = self:GetControl("Panel_LoginCreateRole/Panel_CreateRole/go_roleInfo/img_roleCareer")
  self.plane_bottom_11 = self:GetControl("Panel_LoginCreateRole/Panel_CreateRole/go_roleInfo/plane_bottom_1")
  self.plane_bottom_12 = self:GetControl("Panel_LoginCreateRole/Panel_CreateRole/go_roleInfo/plane_bottom_2")
  self.plane_bottom_13 = self:GetControl("Panel_LoginCreateRole/Panel_CreateRole/go_roleInfo/plane_bottom_3")
  self.txt_careerDes = self:GetControl("Panel_LoginCreateRole/Panel_CreateRole/txt_careerDes")
  self.go_career = self:GetControl("Panel_LoginCreateRole/Panel_CreateRole/go_career")
  self.tog_swordMan = self:GetControl("Panel_LoginCreateRole/Panel_CreateRole/go_career/grid_career/tog_swordMan")
  self.tog_magic = self:GetControl("Panel_LoginCreateRole/Panel_CreateRole/go_career/grid_career/tog_magic")
  self.tog_archer = self:GetControl("Panel_LoginCreateRole/Panel_CreateRole/go_career/grid_career/tog_archer")
  self.go_careerAttribute = self:GetControl("Panel_LoginCreateRole/Panel_CreateRole/go_careerAttribute")
  self.value_Hp = self:GetControl("Panel_LoginCreateRole/Panel_CreateRole/go_careerAttribute/Attribute_Hp/value_Hp")
  self.value_Strength = self:GetControl("Panel_LoginCreateRole/Panel_CreateRole/go_careerAttribute/Attribute_Strength/value_Strength")
  self.value_Agility = self:GetControl("Panel_LoginCreateRole/Panel_CreateRole/go_careerAttribute/Attribute_Agility/value_Agility")
  self.value_Energy = self:GetControl("Panel_LoginCreateRole/Panel_CreateRole/go_careerAttribute/Attribute_Energy/value_Energy")
  self.Button_Cancel = self:GetControl("Button_Cancel")
  self.go_roleBottom = self:GetControl("Panel_LoginCreateRole/Panel_CreateRole/go_roleInfo/Img_roleBottomBg/go_roleBottom")
  self.tog_SpellSword = self:GetControl("Panel_LoginCreateRole/Panel_CreateRole/go_career/grid_career/tog_SpellsWord")
  self.tog_SummonMagician = self:GetControl("Panel_LoginCreateRole/Panel_CreateRole/go_career/grid_career/tog_SummonMagician")
  self.plane_bottom_14 = self:GetControl("Panel_LoginCreateRole/Panel_CreateRole/go_roleInfo/plane_bottom_4")
  self.plane_bottom_16 = self:GetControl("Panel_LoginCreateRole/Panel_CreateRole/go_roleInfo/plane_bottom_6")
  self.spellSwordUnlock = self:GetControl("Panel_LoginCreateRole/Panel_CreateRole/SpellSwordUnlock")
  self.buyUnlock = self:GetControl("Panel_LoginCreateRole/Panel_CreateRole/SpellSwordUnlock/buyUnlock")
  self.conditionDes = self:GetControl("Panel_LoginCreateRole/Panel_CreateRole/SpellSwordUnlock/conditionDes")
end

function Login_LoginCreateRoleUI:Init()
  self.originPos = Vector3.zero
  self.curSelectIndex = 11
  self.curInfo = {}
  self.faceModelTbl = {}
end

function Login_LoginCreateRoleUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

local function SetFace(go, createRoleInfo)
  local scale = string.split(createRoleInfo.modelScale, "#")
  local rotation = string.split(createRoleInfo.modelRotation, "#")
  local position = string.split(createRoleInfo.modelPosition, "#")
  go.transform.localScale = Vector3.New(scale[1], scale[2], scale[3])
  go.transform.localEulerAngles = Vector3.New(rotation[1], rotation[2], rotation[3])
  go.transform.localPosition = Vector3.New(position[1], position[2], position[3])
  go.layer = 5
  go.transform:Find("smdimport").gameObject.layer = 5
  go.transform:Find("smdimport"):GetComponent("SkinnedMeshRenderer").sortingOrder = 500
  local animator = go:GetComponent(typeof(CS.UnityEngine.Animator))
  if animator then
    animator:SetBool("display", true)
  end
end

function Login_LoginCreateRoleUI:InitUI()
  self.originPos = self.Panel_CreateRole.transform.localPosition
  for id, createRoleInfo in pairs(LoginData.createRoleTbl) do
    self.faceModelTbl[id] = CS.Framework.GameModel("Face" .. id, self.go_roleInfo.transform, function(go, name)
      SetFace(go, createRoleInfo)
    end)
    local path = "Model/Face/" .. createRoleInfo.model .. ".prefab"
    self.faceModelTbl[id]:LoadAsync(path)
  end
  self.faceModelTbl[11].transform:SetParent(self.go_roleLeft.transform, false)
  self.faceModelTbl[12].transform:SetParent(self.go_roleMiddle.transform, false)
  self.faceModelTbl[13].transform:SetParent(self.go_roleRight.transform, false)
  self.faceModelTbl[14].transform:SetParent(self.go_roleBottom.transform, false)
  self.faceModelTbl[16].transform:SetParent(self.go_roleRight.transform, false)
  self.toggleList = {
    [11] = self.tog_swordMan,
    [12] = self.tog_magic,
    [13] = self.tog_archer,
    [14] = self.tog_SpellSword,
    [16] = self.tog_SummonMagician
  }
  self.tog_swordMan.Career = 11
  self.tog_magic.Career = 12
  self.tog_archer.Career = 13
  self.tog_SpellSword.Career = 14
  self.tog_SummonMagician.Career = 16
end

function Login_LoginCreateRoleUI:OnShow()
  self:RegistEvents()
  self:RandomName()
  self:SelectCareer(self:RandomCareer(1, 5))
  self:RefreshToggleState()
  self:AnimationShow(true)
  self:Refresh()
end

function Login_LoginCreateRoleUI:RandomCareer(m, n)
  local career = {
    [1] = 11,
    [2] = 12,
    [3] = 13,
    [4] = 14,
    [5] = 16
  }
  local targetCareer = career[Mathf.Random(m, n)]
  if not targetCareer then
    return career[1]
  end
  return targetCareer
end

function Login_LoginCreateRoleUI:RandomName()
  NetManager.Send(UserMessage.ReqRandomName, {sex = 1})
end

function Login_LoginCreateRoleUI:SelectCareer(roleIndex)
  self.curSelectIndex = roleIndex
  self.curInfo = LoginData.createRoleTbl[self.curSelectIndex]
end

function Login_LoginCreateRoleUI:RefreshToggleState()
  for id, togItem in pairs(self.toggleList) do
    if id == self.curSelectIndex then
      togItem:SetIsOn(true)
    end
  end
end

function Login_LoginCreateRoleUI:OnHide()
  self.curSelectIndex = 11
  self.curInfo = {}
end

function Login_LoginCreateRoleUI:RegistUIEvents()
  self.Button_Ok:SetOnClick(self, self.Button_OkOnClick)
  self.Button_Cancel:SetOnClick(self, self.Button_CancelOnClick)
  self.Button_RandomName:SetOnClick(self, self.OnRandomName)
  self.tog_swordMan:SetOnToggleChanged(self, self.ToggleChanged)
  self.tog_magic:SetOnToggleChanged(self, self.ToggleChanged)
  self.tog_archer:SetOnToggleChanged(self, self.ToggleChanged)
  self.tog_SpellSword:SetOnToggleChanged(self, self.ToggleChanged)
  self.tog_SummonMagician:SetOnToggleChanged(self, self.ToggleChanged)
  self.InputField_Name:SetOnEndEdit(self, self.InputField_NameOnEndEdit)
  self.InputField_Name:SetOnValueChanged(self, self.InputField_NameValueChanged)
  self.InputField_Name:SetOnEndEdit(self, self.InputField_NameEndEdit)
end

function Login_LoginCreateRoleUI:InputField_NameValueChanged(control)
  self.limit = self.InputField_Name.transform:GetComponent("InputField")
  if self.limit.characterLimit ~= 20 then
    self.limit.characterLimit = 20
  end
end

function Login_LoginCreateRoleUI:InputField_NameEndEdit(control)
  local inputText = self.InputField_Name:GetInputText()
  local length = string.vietnamese_length(inputText)
  if 20 < length then
    self.limit.text = string.KoreanStrSub(inputText, 1, 19)
  end
  self.limit = 20
end

function Login_LoginCreateRoleUI:ToggleChanged(control)
  if control:GetIsOn() then
    self:SelectCareer(control.Career)
  end
  self:Refresh()
end

local function SetIndex(index, offset)
  index = index + offset
  if index > #LoginData.createRoleTbl then
    index = 1
  end
  if index < 1 then
    index = #LoginData.createRoleTbl
  end
  return index
end

function Login_LoginCreateRoleUI:OnSelectCareer(Control)
  self.curSelectIndex = SetIndex(self.curSelectIndex, Control.offset)
  self.curInfo = LoginData.createRoleTbl[self.curSelectIndex]
  self:Refresh()
end

function Login_LoginCreateRoleUI:OnSetCareer(Control)
  self.curSelectIndex = Control.index
  self.curInfo = LoginData.createRoleTbl[self.curSelectIndex]
  self:Refresh()
end

function Login_LoginCreateRoleUI:OnRandomName(Control)
  NetManager.Send(UserMessage.ReqRandomName, {sex = 1})
end

local function filter_spec_chars(s)
  local ss = {}
  local k = 1
  while not (k > #s) do
    local c = string.byte(s, k)
    if not c then
      break
    end
    if c < 192 then
      if 48 <= c and c <= 57 or 65 <= c and c <= 90 or 97 <= c and c <= 122 then
        table.insert(ss, string.char(c))
      end
      k = k + 1
    elseif c < 224 then
      k = k + 2
    elseif c < 240 then
      if 228 <= c and c <= 233 then
        local c1 = string.byte(s, k + 1)
        local c2 = string.byte(s, k + 2)
        if c1 and c2 then
          local a1, a2, a3, a4 = 128, 191, 128, 191
          if c == 228 then
            a1 = 184
          elseif c == 233 then
            a2, a4 = 190, c1 ~= 190 and 191 or 165
          end
          if c1 >= a1 and c1 <= a2 and c2 >= a3 and c2 <= a4 then
            table.insert(ss, string.char(c, c1, c2))
          end
        end
      end
      k = k + 3
    elseif c < 248 then
      k = k + 4
    elseif c < 252 then
      k = k + 5
    elseif c < 254 then
      k = k + 6
    end
  end
  return table.concat(ss)
end

function Login_LoginCreateRoleUI:InputField_NameOnEndEdit(_, value)
  value = string.filter_vietnamese_text(value)
  local nn = value:gsub(CS.System.Environment.NewLine, "")
  nn = string.trim(nn)
  self.InputField_Name:SetInputText(nn)
end

function Login_LoginCreateRoleUI:Button_OkOnClick(control)
  local name = self.InputField_Name:GetInputText()
  NetManager.Send(UserMessage.ReqCreateRole, {
    roleName = name,
    sex = 1,
    career = self.curInfo.id
  })
  LoginData.playerCreateName = name
  ActionStepsLogManager.SetRoleAction(ActionStepsType.CreateRole)
  EventManager.Dispatch(Event.KoreaSDKClienAirbrigeAndFirebase, {
    type = KoreaSDKEnum.character_creation,
    param = "",
    reason = "",
    node = KoreaSDKNodeEnum.airbridge
  })
end

function Login_LoginCreateRoleUI:buyUnlockOnClick()
  if self.curInfo.id == ERoleCareer.SpellSword and not LoginData.JudgeCanEstablishSpellSwordId() then
    local name = self.InputField_Name:GetInputText()
    local rechargeData = LoginData.spellSwordRechargeData
    if rechargeData then
      TipUtility.QuickShowPrompt({
        id = PromptWordType.BuySpellSword,
        cancelAction = function()
          UIManager.Hide(UIID.PromptTipUI)
        end,
        okAction = function()
          UIManager.Hide(UIID.PromptTipUI)
          NetManager.Send(UserMessage.ReqCreateRole, {
            roleName = name,
            sex = 1,
            career = self.curInfo.id
          })
          LoginData.playerCreateName = name
          ActionStepsLogManager.SetRoleAction(ActionStepsType.CreateRole)
        end
      })
    end
  end
end

function Login_LoginCreateRoleUI:Button_CancelOnClick(control)
  self:AnimationShow(false, true)
end

function Login_LoginCreateRoleUI:RegistEvents()
  self:RegistEvent(Event.Login_CreateRandomName, self.OnCreateRandomName, self)
  self:RegistEvent(Event.Login_CreateRole, self.OnCreateRole, self)
end

function Login_LoginCreateRoleUI:OnCreateRole(_)
  self:Button_CancelOnClick()
end

function Login_LoginCreateRoleUI:OnCreateRandomName(id, msg)
  self.InputField_Name:SetInputText(LoginData.resRandomName)
end

function Login_LoginCreateRoleUI:Refresh()
  self:RefreshSelectToggleView()
  self:RefreshShowText()
  self:SwitchCareer()
end

function Login_LoginCreateRoleUI:RefreshButtonOkShow()
  if self.curInfo.id == ERoleCareer.SpellSword and not LoginData.JudgeCanEstablishSpellSwordId() then
    return
  end
  self:SetSprite("Atlas_Login", table.count(LoginData.roleList) > 0 and "btn_create" or "btn_startGame", self.Button_Ok)
end

function Login_LoginCreateRoleUI:RefreshSelectToggleView()
  for id, faceModelItem in pairs(self.faceModelTbl) do
    faceModelItem.transform.gameObject:SetActive(id == self.curSelectIndex)
  end
end

function Login_LoginCreateRoleUI:RefreshShowText()
  self.txt_careerDes:SetText(self.curInfo.description)
  local strList = string.split(self.curInfo.attributeShow, "#")
  if table.count(strList) > 0 then
    self.value_Hp:SetText(strList[1])
    self.value_Strength:SetText(strList[2])
    self.value_Agility:SetText(strList[3])
    self.value_Energy:SetText(strList[4])
  end
end

local oldIndex = -1

function Login_LoginCreateRoleUI:SwitchCareer()
  if oldIndex ~= self.curSelectIndex then
    if oldIndex ~= -1 then
      self.faceModelTbl[oldIndex].transform.localScale = Vector3.one
      self["plane_bottom_" .. oldIndex]:SetActive(true)
    end
    oldIndex = self.curSelectIndex
    self:SetSprite("Atlas_Language", self.curInfo.image, self.img_roleCareer, true)
    if self.faceModelTbl[self.curSelectIndex].transform then
      self["plane_bottom_" .. self.curSelectIndex]:SetActive(false)
      self.img_seletBg.transform:SetParent(self.faceModelTbl[self.curSelectIndex].transform.parent.parent, false)
      self.faceModelTbl[self.curSelectIndex].transform.localScale = Vector3.one * 1.1
      if self.faceModelTbl[self.curSelectIndex].modelObject then
        local animator = self.faceModelTbl[self.curSelectIndex].modelObject:GetComponent(typeof(CS.UnityEngine.Animator))
        if animator then
          animator:SetBool("display", true)
        end
      end
    end
  end
end

function Login_LoginCreateRoleUI:SetSpellSwordUI()
  self.spellSwordUnlock:SetActive(false)
  self.Button_Ok:SetActive(true)
  if self.curInfo.id == ERoleCareer.SpellSword and not LoginData.JudgeCanEstablishSpellSwordId() then
    self.spellSwordUnlock:SetActive(true)
    self.Button_Ok:SetActive(false)
    self.conditionDes:SetText(string.format("B\225\186\165t k\225\187\179 nh\195\162n v\225\186\173t n\195\160o trong t\195\160i kho\225\186\163n \196\145\225\186\161t Lv%d", LoginData.careerCreateLevel[14]))
  end
end

local function AnimationCallBack(state)
  if state then
    UIManager.Hide(UIID.LoginCreateRoleUI)
    EventManager.Dispatch(Event.Login_OutCreateRoleUI)
  end
end

function Login_LoginCreateRoleUI:AnimationShow(isDown, haveCallBack)
  local startPos = isDown and Vector3.New(0, 600, 0) or Vector3.zero
  local targetPos = isDown and self.originPos or self.originPos + Vector3.New(0, 600, 0)
  self.Panel_CreateRole.transform.localPosition = self.originPos + startPos
  self.Panel_CreateRole.transform:DOLocalMove(targetPos, LoginData.animationTime):SetEase(Ease.OutQuad):OnComplete(AnimationCallBack(haveCallBack))
end
