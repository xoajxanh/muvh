Equip_HolySkeletonCombineBagUI = class(BaseUI)
Equip_HolySkeletonCombineBagUI.layer = UILayer.Panel
Equip_HolySkeletonCombineBagUI.orderInLayer = 0
Equip_HolySkeletonCombineBagUI.hideType = UIHideType.WaitDestroy
Equip_HolySkeletonCombineBagUI.hideFunc = UIHideFunc.MoveOutOfScreen
Equip_HolySkeletonCombineBagUI.escClose = UIEscClose.DontClose

function Equip_HolySkeletonCombineBagUI:InitControls()
  self.sw_SkeletonItem = self:GetControl("bg_equip/HolySkeletonBag/sw_SkeletonItem")
  self.SkeletonItem = self:GetControl("bg_equip/HolySkeletonBag/sw_SkeletonItem/Viewport/Content/SkeletonItem")
  self.chooseSkeleton_Left = self:GetControl("bg_equip/HolySkeletonBag/chooseSkeleton_Left")
  self.chooseSkeleton_Right = self:GetControl("bg_equip/HolySkeletonBag/chooseSkeleton_Right")
  self.img_text_BagEmpty = self:GetControl("img_text_BagEmpty")
  self.descBtn = self:GetControl("descBtn")
  self.btn_close = self:GetControl("btn_close")
  self.btn_AbovePage = self:GetControl("btn_AbovePage")
  self.btn_NextPage = self:GetControl("btn_NextPage")
end

function Equip_HolySkeletonCombineBagUI:Init()
end

function Equip_HolySkeletonCombineBagUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:InitParams()
  self:RegistUIEvents()
end

function Equip_HolySkeletonCombineBagUI:InitUI()
  self.holySkeletonCombineSoulBagTemp = UIUtility.BindUIContainerTemp(self.SkeletonItem, LuaComponentTemplates.HolySkeletonCombineSoulBagTemplate, self)
end

function Equip_HolySkeletonCombineBagUI:InitDropDown()
  self.chooseSkeleton_Left.dropdown:ClearOptions()
  self.chooseSkeleton_Right.dropdown:ClearOptions()
  self:RefreshDropDown(0)
end

function Equip_HolySkeletonCombineBagUI:ChangeDropDown(tbl, crt)
  for i, v in pairs(tbl) do
    crt.dropdown:AddOption(tbl[i])
  end
end

function Equip_HolySkeletonCombineBagUI:InitParams()
  self.chooseSoulType = 0
  self.chooseSoulQuality = 0
  self.cantTurnToLastPageTip = ClientTable.cfg_Ui_wordManager:GetUi_wordCount("Equip_HolySkeletonCombineBagUI_1")
  self.cantTurnToNextPageTip = ClientTable.cfg_Ui_wordManager:GetUi_wordCount("Equip_HolySkeletonCombineBagUI_2")
  self.fixedSoulTypeFilterName = ClientTable.cfg_Ui_wordManager:GetUi_wordCount("Equip_HolySkeletonCombineBagUI_3")
end

function Equip_HolySkeletonCombineBagUI:RegistUIEvents()
  self.descBtn:SetOnClick(self, self.descBtnOnClick)
  self.btn_close:SetOnClick(self, self.btn_closeOnClick)
  self.btn_AbovePage:SetOnClick(self, self.btn_AbovePageOnClick)
  self.btn_NextPage:SetOnClick(self, self.btn_NextPageOnClick)
  self.chooseSkeleton_Left:SetOnDropDownValueChanged(self, self.OnDropDownSoulTypeValueChanged)
  self.chooseSkeleton_Right:SetOnDropDownValueChanged(self, self.OnDropDownSoulQualityValueChanged)
end

function Equip_HolySkeletonCombineBagUI:descBtnOnClick()
  local lvCfg = ConfigManager.FindConfigs("cfg_Ui_description", "uiName", "Equip_HolySkeletonCombineBagUI")
  if 0 < #lvCfg then
    UIManager.Show(UIID.System_DescUI, {
      id = lvCfg[1].id
    })
  end
end

function Equip_HolySkeletonCombineBagUI:btn_closeOnClick()
  UIManager.Hide(UIID.Equip_HolySkeletonCombineBagUI)
end

function Equip_HolySkeletonCombineBagUI:btn_AbovePageOnClick()
  local curChooseSoulType, curChooseSoulQuality = self.chooseSoulType, self.chooseSoulQuality + 1
  local soulTypeDropDownMaxValue = gameMgr:GetAvatarManager():GetMainPlayer():GetSacredBoneDataMgr():GetCombineSoulBagSoulTypeDropDownMaxValue()
  local modQualityDropDownMaxValue = gameMgr:GetAvatarManager():GetMainPlayer():GetSacredBoneDataMgr():GetCombineSoulBagModQulityDropDownMaxValue()
  if curChooseSoulQuality > modQualityDropDownMaxValue then
    curChooseSoulQuality = 0
    curChooseSoulType = curChooseSoulType + 1
  end
  while soulTypeDropDownMaxValue >= curChooseSoulType and modQualityDropDownMaxValue >= curChooseSoulQuality do
    if gameMgr:GetAvatarManager():GetMainPlayer():GetSacredBoneDataMgr():CheckCurFilterConditionSoulCountIsMeetCombine(curChooseSoulType, curChooseSoulQuality) then
      self.chooseSoulType = curChooseSoulType
      self.chooseSoulQuality = curChooseSoulQuality
      self.chooseSkeleton_Left:SetSelectValue(self.chooseSoulType)
      self.chooseSkeleton_Right:SetSelectValue(self.chooseSoulQuality)
      return
    elseif modQualityDropDownMaxValue > curChooseSoulQuality then
      curChooseSoulQuality = curChooseSoulQuality + 1
    elseif soulTypeDropDownMaxValue > curChooseSoulType then
      curChooseSoulType = curChooseSoulType + 1
      curChooseSoulQuality = 0
    elseif soulTypeDropDownMaxValue <= curChooseSoulType then
      FloatingTipUtility.QuickMsg(self.cantTurnToLastPageTip or "")
      return
    end
  end
  FloatingTipUtility.QuickMsg(self.cantTurnToLastPageTip or "")
end

function Equip_HolySkeletonCombineBagUI:btn_NextPageOnClick()
  local curChooseSoulType, curChooseSoulQuality = self.chooseSoulType, self.chooseSoulQuality - 1
  local modQualityDropDownMaxValue = gameMgr:GetAvatarManager():GetMainPlayer():GetSacredBoneDataMgr():GetCombineSoulBagModQulityDropDownMaxValue()
  if curChooseSoulQuality < 0 then
    curChooseSoulQuality = modQualityDropDownMaxValue
    curChooseSoulType = curChooseSoulType - 1
  end
  while 0 <= curChooseSoulType and 0 <= curChooseSoulQuality do
    if gameMgr:GetAvatarManager():GetMainPlayer():GetSacredBoneDataMgr():CheckCurFilterConditionSoulCountIsMeetCombine(curChooseSoulType, curChooseSoulQuality) then
      self.chooseSoulType = curChooseSoulType
      self.chooseSoulQuality = curChooseSoulQuality
      self.chooseSkeleton_Left:SetSelectValue(self.chooseSoulType)
      self.chooseSkeleton_Right:SetSelectValue(self.chooseSoulQuality)
      return
    elseif 0 < curChooseSoulQuality then
      curChooseSoulQuality = curChooseSoulQuality - 1
    elseif 0 < curChooseSoulType then
      curChooseSoulType = curChooseSoulType - 1
      curChooseSoulQuality = modQualityDropDownMaxValue
    elseif curChooseSoulType <= 0 then
      FloatingTipUtility.QuickMsg(self.cantTurnToNextPageTip or "")
      return
    end
  end
  FloatingTipUtility.QuickMsg(self.cantTurnToNextPageTip or "")
end

function Equip_HolySkeletonCombineBagUI:OnDropDownSoulTypeValueChanged(_, selectIndex)
  self.chooseSoulType = selectIndex
  self:RefreshDropDown(selectIndex)
  self:RefreshBagData()
  local holySkeletonCombineOtherViewTemplate = gameMgr:GetAvatarManager():GetMainPlayer():GetSacredBoneDataMgr():GetHolySkeletonCombineOtherViewTemp()
  if holySkeletonCombineOtherViewTemplate and holySkeletonCombineOtherViewTemplate.isCanCombine == true then
    holySkeletonCombineOtherViewTemplate:ResetCurSelectedCombineData(false)
    holySkeletonCombineOtherViewTemplate:OnFilterConditionChange(self.chooseSoulType, self.chooseSoulQuality)
  end
end

function Equip_HolySkeletonCombineBagUI:OnDropDownSoulQualityValueChanged(_, selectIndex)
  self.chooseSoulQuality = selectIndex
  self:RefreshBagData()
  local holySkeletonCombineOtherViewTemplate = gameMgr:GetAvatarManager():GetMainPlayer():GetSacredBoneDataMgr():GetHolySkeletonCombineOtherViewTemp()
  if holySkeletonCombineOtherViewTemplate and holySkeletonCombineOtherViewTemplate.isCanCombine == true then
    holySkeletonCombineOtherViewTemplate:ResetCurSelectedCombineData(false)
    holySkeletonCombineOtherViewTemplate:OnFilterConditionChange(self.chooseSoulType, self.chooseSoulQuality)
  end
end

function Equip_HolySkeletonCombineBagUI:OnShow()
  gameMgr:GetAvatarManager():GetMainPlayer():GetSacredBoneDataMgr():SetHolySkeletonCombineSoulBagTemp(self.holySkeletonCombineSoulBagTemp)
  self:RegistEvents()
  self:Refresh()
end

function Equip_HolySkeletonCombineBagUI:RegistEvents()
  self:RegistEvent(Event.SacredBoneBagChange, self.OnBagChange, self)
  self:RegistEvent(Event.Item_CombineRsp, self.OnItemCombineRsp, self)
end

function Equip_HolySkeletonCombineBagUI:OnBagChange()
  self:RefreshSoulTypeDropDownContent()
  self:RefreshBagData()
end

function Equip_HolySkeletonCombineBagUI:OnItemCombineRsp()
  local curChooseSoulType, curChooseSoulQuality = self.chooseSoulType, self.chooseSoulQuality
  local soulTypeDropDownMaxValue = gameMgr:GetAvatarManager():GetMainPlayer():GetSacredBoneDataMgr():GetCombineSoulBagSoulTypeDropDownMaxValue()
  local modQualityDropDownMaxValue = gameMgr:GetAvatarManager():GetMainPlayer():GetSacredBoneDataMgr():GetCombineSoulBagModQulityDropDownMaxValue()
  while curChooseSoulType <= soulTypeDropDownMaxValue and curChooseSoulQuality <= modQualityDropDownMaxValue do
    if gameMgr:GetAvatarManager():GetMainPlayer():GetSacredBoneDataMgr():CheckCurFilterConditionSoulCountIsMeetCombine(curChooseSoulType, curChooseSoulQuality) then
      self.chooseSoulType = curChooseSoulType
      self.chooseSoulQuality = curChooseSoulQuality
      self.chooseSkeleton_Left:SetSelectValue(self.chooseSoulType)
      self.chooseSkeleton_Right:SetSelectValue(self.chooseSoulQuality)
      return
    elseif curChooseSoulQuality < modQualityDropDownMaxValue then
      curChooseSoulQuality = curChooseSoulQuality + 1
    elseif curChooseSoulType < soulTypeDropDownMaxValue then
      curChooseSoulType = curChooseSoulType + 1
      curChooseSoulQuality = 0
    elseif soulTypeDropDownMaxValue <= curChooseSoulType then
      return
    end
  end
end

function Equip_HolySkeletonCombineBagUI:Refresh()
  self:RefreshSoulTypeDropDownContent()
  self:RefreshBagData()
end

function Equip_HolySkeletonCombineBagUI:RefreshSoulTypeDropDownContent()
  if gameMgr:GetAvatarManager():GetMainPlayer():GetSacredBoneDataMgr():CheckIsShowFixedCombineOption() then
    if self.chooseSkeleton_Left.dropdown.options.Count == 3 then
      self.chooseSkeleton_Left.dropdown:AddOption(self.fixedSoulTypeFilterName or "Linh H\225\187\147n Th\198\176\225\187\157ng-D\195\178ng thu\225\187\153c t\195\173nh c\225\187\145 \196\145\225\187\139nh")
    end
    gameMgr:GetAvatarManager():GetMainPlayer():GetSacredBoneDataMgr():SetCombineSoulBagSoulTypeDropDownMaxValue(3)
  else
    if self.chooseSkeleton_Left.dropdown.options.Count > 3 then
      self.chooseSkeleton_Left.dropdown.options:Remove(self.chooseSkeleton_Left.dropdown.options[3])
    end
    gameMgr:GetAvatarManager():GetMainPlayer():GetSacredBoneDataMgr():SetCombineSoulBagSoulTypeDropDownMaxValue(2)
  end
end

function Equip_HolySkeletonCombineBagUI:RefreshBagData()
  local meetCombineHolySkeletonBagData = gameMgr:GetAvatarManager():GetMainPlayer():GetSacredBoneDataMgr():GetMeetCombineHolySkeletonBagData(self.chooseSoulType, self.chooseSoulQuality)
  self.holySkeletonCombineSoulBagTemp:SetData(meetCombineHolySkeletonBagData)
  self.img_text_BagEmpty:SetActive(table.count(meetCombineHolySkeletonBagData) == 0)
end

function Equip_HolySkeletonCombineBagUI:ResetScrollViewPos()
  self.sw_SkeletonItem:SetNormalizedPosition(0, 1)
end

function Equip_HolySkeletonCombineBagUI:RefreshDropDown(selectIndex)
  self.chooseSkeleton_Right:ClearOptions()
  local textTbl = string.split(ClientTable.cfg_Ui_wordManager:TryGetValue("UIHolySkeletonCombine_" .. selectIndex).content, "#")
  for i, v in ipairs(textTbl) do
    self.chooseSkeleton_Right.dropdown:AddOption(v)
  end
  self.chooseSkeleton_Right:SetSelectValue(self.chooseSoulQuality)
  gameMgr:GetAvatarManager():GetMainPlayer():GetSacredBoneDataMgr():SetCombineSoulBagModQulityDropDownMaxValue(#textTbl)
end

function Equip_HolySkeletonCombineBagUI:OnHide()
  self:ResetScrollViewPos()
  self.chooseSoulType = 0
  self.chooseSoulQuality = 0
  self.chooseSkeleton_Left:SetSelectValue(self.chooseSoulType)
  self.chooseSkeleton_Right:SetSelectValue(self.chooseSoulQuality)
  for i, v in pairs(self.holySkeletonCombineSoulBagTemp.items) do
    if v.itemTemp then
      v.itemTemp:OnHide()
    end
  end
end
