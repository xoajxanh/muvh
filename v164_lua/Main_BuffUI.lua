Main_BuffUI = class(BaseUI)
Main_BuffUI.layer = UILayer.Panel
Main_BuffUI.orderInLayer = 0
Main_BuffUI.hideType = UIHideType.WaitDestroy
Main_BuffUI.hideFunc = UIHideFunc.MoveOutOfScreen
Main_BuffUI.escClose = UIEscClose.DontClose

function Main_BuffUI:InitControls()
  self.Grid_Buff = self:GetControl("Grid_Buff")
  self.btn_MemberCard = self:GetControl("Grid_Buff/btn_MemberCard")
  self.btn_GoldCard = self:GetControl("Grid_Buff/btn_GoldCard")
  self.btn_MonthCard = self:GetControl("Grid_Buff/btn_MonthCard")
  self.btn_buff = self:GetControl("Grid_Buff/btn_buff")
  self.Grid_Tip = self:GetControl("Grid_Tip")
  self.itemTime = self:GetControl("Grid_Tip/itemTime")
  self.itemTip = self:GetControl("Grid_Tip/itemTip")
  self.go_buffTip = self:GetControl("go_buffTip")
  self.go_buffTipBG = self:GetControl("go_buffTip/go_buffTipBG")
  self.lab_buffName = self:GetControl("go_buffTip/Panel/lab_buffName")
  self.lab_buffTime = self:GetControl("go_buffTip/Panel/lab_buffTime")
  self.lab_buffEffect = self:GetControl("go_buffTip/Panel/lab_buffEffect")
  self.go_LJSDBuffTip = self:GetControl("go_LJSDBuffTip")
  self.go_LJSDTipBG = self:GetControl("go_LJSDBuffTip/go_LJSDTipBG")
  self.lab_LJSDTitle = self:GetControl("go_LJSDBuffTip/Panel/lab_LJSDTitle")
  self.lab_LJSDName = self:GetControl("go_LJSDBuffTip/Panel/lab_LJSDName")
  self.go_buffExtend = self:GetControl("go_buffExtend")
  self.btn_Extend = self:GetControl("btn_Extend")
end

Main_BuffUI.LowBuffCount = 5

function Main_BuffUI:OnPreLoad()
end

function Main_BuffUI:Init()
  self.BuffContainer = nil
  self.buffItemType = EBuffItemType.None
  self.acc = 0
end

function Main_BuffUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Main_BuffUI:InitUI()
  self.BuffContainer = UIContainer(self.btn_buff, self, self.CreateBuffItemCallBack, self.RefreshBuffItemCallBack)
  self.buffDescInitAnchoredPos = Vector3.NewFrom(self.go_buffTip.rectTransform.anchoredPosition)
  self.usingBuffDescPos = Vector3.NewFrom(self.go_buffTip.rectTransform.anchoredPosition)
  self:InitTemplates()
end

function Main_BuffUI:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function Main_BuffUI:OnHide()
  self.BuffContainer:SetData({})
  self:go_LJSDTipBGOnClick()
end

function Main_BuffUI:OnDestroy()
  self.BuffContainer = nil
end

local accupdata = 300
local Intervals = 300

function Main_BuffUI:Update()
  self:UpdateBuffMask()
  self:UpdataTemplates()
end

function Main_BuffUI:RegistUIEvents()
  self.go_buffTipBG:SetOnClick(self, self.BGOnClick)
  self.go_LJSDTipBG:SetOnClick(self, self.go_LJSDTipBGOnClick)
  self.btn_Extend:SetOnClick(self, self.btn_ExtendOnClick)
end

function Main_BuffUI:RegistEvents()
  self:RegistEvent(Event.Buff_RefreshRoleBuff, self.ShowBuff, self)
  self:RegistEvent(Event.Scene_OnEnterScene, self.Refresh, self)
  self:RegistEvent(Event.Buff_RoleMonthCardBuff, self.MonthCardChangedCallBack, self)
  self:RegistEvent(Event.Buff_LJSDTips, self.Buff_LJSDTips, self)
  self:RegistEvent(Event.TemporaryMemberLevelChanged, self.TemporaryMemberLevelChangedCallBack, self)
  self:RegistEvent(Event.Buff_RefreshMainPlayerSingleBuff, self.RefreshSingleBuff, self)
  self:RegistEvent(Event.Buff_RefreshMainPlayerAllBuff, self.RefreshAllBuff, self)
  self:RegistEvent(Event.SpecialBuffChange, self.SpecialBuffOnChange, self)
end

function Main_BuffUI:btn_buffOnClick(control)
  if self.Grid_Tip ~= nil and not IsNil(self.Grid_Tip.gameObject) and self.Grid_Tip.gameObject.activeSelf then
    self:SetGridTipState(false)
    return
  end
  self:RefreshBuffTips(control)
end

function Main_BuffUI:Destroylab_buffTimer()
  if self.lab_buffTimer then
    Timer.Stop(self.lab_buffTimer)
    self.lab_buffTimer = nil
  end
end

function Main_BuffUI:BGOnClick()
  self:Destroylab_buffTimer()
  self.go_buffTip:SetActive(false)
  self.showingBuffDesc = nil
end

function Main_BuffUI:go_LJSDTipBGOnClick()
  self.go_LJSDBuffTip:SetActive(false)
end

function Main_BuffUI:btn_ExtendOnClick()
  self.extraBuffItemsTemplate:AutoChangeStage()
  self.extraBuffItemsTemplate:Refresh({
    buffStructList = self.highBuffList,
    baseUI = self,
    buffCallBack = self.btn_buffOnClick
  })
end

function Main_BuffUI:btn_buffOnPress(control)
  local buffData = control.data
  if self.showingBuffDesc ~= control then
    self.showingBuffDesc = control
    self.usingBuffDescPos.x = self.buffDescInitAnchoredPos.x + control.rectTransform.anchoredPosition.x
    self.go_buffTip:SetAnchoredPosition(self.usingBuffDescPos.x, self.usingBuffDescPos.y)
    self.lab_buffName:SetText(buffData.buffConfig.name)
    if string.isNullOrEmpty(buffData.buffConfig.desc) then
      self.lab_buffEffect:SetText("")
    else
      local desc
      local matchAttNames = string.gmatch(buffData.buffConfig.desc, "%[(%w+)%]")
      local formatDesc = string.gsub(buffData.buffConfig.desc, "%[(%w+)%]", "")
      local attrVals = {}
      local attrVal
      for attrName in matchAttNames, nil, nil do
        attrVal = 0
        if ClientServersDifferenceAttribute[attrName] then
          attrVal = buffData.showAttribute[EAttributeType[attrName]] or 0
        else
          attrVal = buffData.attribute[EAttributeType[attrName]] or 0
        end
        if AttributeConfig.IsRatioAttribute(attrName) then
          attrVal = attrVal * 0.01
        end
        attrVals[#attrVals + 1] = attrVal
      end
      if #attrVals < 1 then
        desc = buffData.buffConfig.desc
      else
        desc = string.format(formatDesc, unpack(attrVals))
      end
      self.lab_buffEffect:SetText(desc)
    end
  end
  logPurple("buffData.totalTime" .. tostring(buffData.totalTime))
  if 0 < buffData.totalTime then
    self.lab_buffTime:SetActive(true)
  else
    self.lab_buffTime:SetActive(false)
  end
  self.lab_buffTime:SetText(TimeUtility.ShowTime(buffData.time))
  self.go_buffTip:SetActive(true)
end

function Main_BuffUI:btn_buffOnEndPress(control)
  self.go_buffTip:SetActive(false)
  self.showingBuffDesc = nil
end

function Main_BuffUI:Buff_LJSDTips(_, data)
  if data.pos == "left" then
    self:btn_defenseValueleft()
  elseif data.pos == "right" then
    self:btn_defenseValueright()
  end
end

function Main_BuffUI:btn_defenseValueleft()
  local shield = gameMgr:GetAvatarManager():GetMainPlayer():GetMe().data.shield
  local maxShield = gameMgr:GetAvatarManager():GetMainPlayer():GetInfo():TryGetAttrValue(EAttributeType.maximumShield)
  if not RoleManager.me.data.hasShield then
    shield = 0
    maxShield = 0
  end
  self.lab_LJSDTitle:SetText(string.format(ClientTable.cfg_Ui_wordManager:GetUi_wordCount("LJSDBuffTip_SDTitle"), shield, maxShield))
  self.lab_LJSDName:SetText(ClientTable.cfg_Ui_wordManager:GetUi_wordCount("LJSDBuffTip_SD"))
  self.go_LJSDBuffTip.transform.localPosition = Vector3(650, 137, -220)
  self.go_LJSDBuffTip:SetActive(true)
end

function Main_BuffUI:btn_defenseValueright()
  local value = HPData.GetComboPercent() and HPData.GetComboPercent() or 0
  local Ui_word = ""
  if RoleUtility.GetBasicCareer(ViewData.meData.career) == 11 then
    Ui_word = "LJSDBuffTip_comboSkill01"
  elseif RoleUtility.GetBasicCareer(ViewData.meData.career) == 12 then
    Ui_word = "LJSDBuffTip_comboSkill02"
  elseif RoleUtility.GetBasicCareer(ViewData.meData.career) == 13 then
    Ui_word = "LJSDBuffTip_comboSkill03"
  elseif RoleUtility.GetBasicCareer(ViewData.meData.career) == 14 then
    Ui_word = "LJSDBuffTip_comboSkill04"
  elseif RoleUtility.GetBasicCareer(ViewData.meData.career) == 16 then
    Ui_word = "LJSDBuffTip_comboSkill06"
  end
  value = math.floor(value * 100)
  self.lab_LJSDTitle:SetText(string.format(ClientTable.cfg_Ui_wordManager:GetUi_wordCount("LJSDBuffTip_comboSkillTitle"), value))
  self.lab_LJSDName:SetText(ClientTable.cfg_Ui_wordManager:GetUi_wordCount(Ui_word))
  self.go_LJSDBuffTip.transform.localPosition = Vector3(950, 137, -220)
  self.go_LJSDBuffTip:SetActive(true)
end

function Main_BuffUI:TemporaryMemberLevelChangedCallBack()
  if self.memberCardTempate then
    self.memberCardTempate:Refresh()
  end
end

function Main_BuffUI:MonthCardChangedCallBack()
  if self.anvanceMonthCardTempate then
    self.anvanceMonthCardTempate:Refresh()
  end
end

function Main_BuffUI:Refresh()
  self:ShowBuff()
  self:RefreshTempates()
end

function Main_BuffUI.CreateBuffItemCallBack(ctr, self)
  ctr.lab_buff = UIControl(ctr.transform, "lab_buff")
  ctr.img_mask = UIControl(ctr.transform, "img_mask")
  ctr.img_buff = UIControl(ctr.transform, "img_buff")
  ctr.lab_buffNum = UIControl(ctr.transform, "lab_buffNum")
  ctr.lab_num = UIControl(ctr.transform, "lab_num")
  ctr:SetOnClick(self, self.btn_buffOnClick)
end

function Main_BuffUI.RefreshBuffItemCallBack(ctr, _, data, ui)
  ctr.data = data
  ctr.lab_buff:SetText(data.buffConfig.name)
  if data.totalTime > 0 then
    ctr.img_mask:SetActive(true)
    ctr.img_mask:SetFillAmount(1 - data.time / data.totalTime)
  else
    ctr.img_mask:SetActive(false)
  end
  if ctr.img_buff.loader then
    Coroutine.Stop(ctr.img_buff.loader)
  end
  local buffOverlayNum = ""
  if ctr.lab_buffNum and type(data.overlayNum) == "number" and 1 < data.overlayNum then
    buffOverlayNum = data.overlayNum
  end
  ctr.lab_buffNum:SetText(buffOverlayNum)
  local buffCount = ""
  if ctr.lab_num and type(data.count) == "number" and 1 < data.count then
    buffCount = data.count
  end
  ctr.lab_num:SetText(buffCount)
  ctr.img_buff.loader = ui:SetSprite("Atlas_Buff", data.buffConfig.icon, ctr.img_buff)
end

function Main_BuffUI:ShowBuff()
  if ViewData.meData then
    local buffInfos = {}
    for _, buffInfo in pairs(BuffData.GetBuffs(ViewData.meData.id)) do
      if not string.isNullOrEmpty(buffInfo.buffConfig.icon) then
        table.insert(buffInfos, buffInfo)
      end
    end
    self.showBuffInfo = buffInfos
    self.lowBuffList, self.highBuffList = self:GetShowBuff()
    self.BuffContainer:SetData(self.lowBuffList)
    self:RefreshExtraBtn()
  end
end

function Main_BuffUI.BuffSort(buffA, buffB)
end

function Main_BuffUI:RefreshExtraBtn()
  local stage = #self.showBuffInfo > self.LowBuffCount
  self.btn_Extend:SetActive(stage)
  if stage then
    self.extraBuffItemsTemplate:Refresh({
      buffStructList = self.highBuffList,
      baseUI = self,
      buffCallBack = self.btn_buffOnClick
    })
  else
    self.extraBuffItemsTemplate:ChangeStage(stage)
  end
end

function Main_BuffUI:GetShowBuff()
  local lowBuffList, highBuffList = {}, {}
  for k, v in pairs(self.showBuffInfo) do
    if k > self.LowBuffCount then
      table.insert(highBuffList, v)
    else
      table.insert(lowBuffList, v)
    end
  end
  return lowBuffList, highBuffList
end

function Main_BuffUI:RefreshSingleBuff(id, buffId)
  local buffUIControl = self:GetBuffUIControl(buffId)
  self.extraBuffItemsTemplate:RefreshSingleBuff(buffId)
  if buffUIControl == nil then
    return
  end
  local buffStruct = BuffData.GetBuff(ViewData.meData.id, buffId)
  if buffStruct == nil then
    return
  end
  self.RefreshBuffItemCallBack(buffUIControl, nil, buffStruct, self)
end

function Main_BuffUI:RefreshAllBuff(id, allbuffId)
  for i = 1, #allbuffId do
    local buffUIControl = self:GetBuffUIControl(allbuffId[i].buffCId)
    self.extraBuffItemsTemplate:RefreshSingleBuff(allbuffId[i].buffCId)
    if buffUIControl == nil then
      return
    end
    local buffStruct = BuffData.GetBuff(ViewData.meData.id, allbuffId[i].buffCId)
    if buffStruct == nil then
      return
    end
    self.RefreshBuffItemCallBack(buffUIControl, nil, buffStruct, self)
  end
end

function Main_BuffUI:SpecialBuffOnChange(id, stage)
  if stage then
    self.LowBuffCount = self.LowBuffCount - 1
  else
    self.LowBuffCount = self.LowBuffCount + 1
  end
  self:ShowBuff()
end

function Main_BuffUI:GetBuffUIControl(buffConfigId)
  if self.BuffContainer == nil or self.BuffContainer.items == nil or next(self.BuffContainer.items) == nil then
    return
  end
  for k, v in pairs(self.BuffContainer.items) do
    if v.data.buffCId == buffConfigId then
      return v
    end
  end
end

function Main_BuffUI:UpdateBuffMask()
  for _, item in pairs(self.BuffContainer.items) do
    if item.data then
      item.img_mask:SetFillAmount(1 - item.data.time / item.data.totalTime)
    end
  end
end

function Main_BuffUI:RefreshBuffTips(control)
  local buffData = control.data
  if self.showingBuffDesc ~= control then
    self.showingBuffDesc = control
    self.usingBuffDescPos.x = self.buffDescInitAnchoredPos.x + control.rectTransform.anchoredPosition.x
    local x, y = control:GetParent():GetAnchoredPosition()
    local w, h = control:GetParent():GetSizeDelta()
    local yOffset = y + h + control.rectTransform.anchoredPosition.y - 20
    self.usingBuffDescPos.y = self.buffDescInitAnchoredPos.y + yOffset
    self.go_buffTip:SetAnchoredPosition(self.usingBuffDescPos.x, self.usingBuffDescPos.y)
    self.lab_buffName:SetText(buffData.buffConfig.name)
    if string.isNullOrEmpty(buffData.buffConfig.desc) then
      self.lab_buffEffect:SetText("")
    else
      local desc
      local matchAttNames = string.gmatch(buffData.buffConfig.desc, "%[(%w+)%]")
      local formatDesc = string.gsub(buffData.buffConfig.desc, "%[(%w+)%]", "")
      local attrVals = {}
      local attrVal
      for attrName in matchAttNames, nil, nil do
        attrVal = 0
        if ClientServersDifferenceAttribute[attrName] then
          attrVal = buffData.showAttribute[EAttributeType[attrName]] or 0
        else
          attrVal = buffData.attribute[EAttributeType[attrName]] or 0
          if EAttributeType[attrName] == EAttributeType.maximumPhysBaseDmg and attrVal == 0 then
            attrVal = buffData.attribute[EAttributeType.maximumWizBaseDmg] or 0
          end
        end
        if AttributeConfig.IsRatioAttribute(attrName) then
          attrVal = attrVal * 0.01
        end
        attrVals[#attrVals + 1] = attrVal
      end
      if #attrVals < 1 then
        desc = buffData.buffConfig.desc
      else
        desc = string.format(formatDesc, unpack(attrVals))
      end
      self.lab_buffEffect:SetText(desc)
    end
  end
  self:Destroylab_buffTimer()
  if 0 < buffData.totalTime then
    self.lab_buffTime:SetText(TimeUtility.ShowTime(buffData.time))
    self.buffDatatime = buffData.time
    self.lab_buffTime:SetActive(true)
    self.lab_buffTimer = Timer.StartLoopForever(1, self.Refreshlab_buffTime, self)
  else
    self.lab_buffTime:SetActive(false)
  end
  self.go_buffTip:SetActive(true)
end

function Main_BuffUI:Refreshlab_buffTime()
  self.buffDatatime = self.buffDatatime - 1
  self.lab_buffTime:SetText(TimeUtility.ShowTime(self.buffDatatime))
  if self.buffDatatime <= 0 then
    self:BGOnClick()
  end
end

function Main_BuffUI:GetTemplateByType(type)
  if type == EBuffItemType.Member then
    return self.memberCardTempate
  elseif type == EBuffItemType.AdvanceMonthCard then
    return self.anvanceMonthCardTempate
  end
  return nil
end

function Main_BuffUI:InitTemplates()
  local templateParam = {
    ui = self,
    clickCallBack = self.TemplateClickCallBack,
    timeEndCallBack = self.TemplateTimeEndCallBack,
    refreshCallBack = self.TemplateRefreshCallBack
  }
  if self.memberCardTempate == nil then
    self.memberCardTempate = luaTemplateManager.GetNewTemplate(self.btn_MemberCard, LuaComponentTemplates.BuffItem_MemberCardTemplate)
    self.memberCardTempate:InitTemplate(templateParam)
  end
  if self.anvanceMonthCardTempate == nil then
    self.anvanceMonthCardTempate = luaTemplateManager.GetNewTemplate(self.btn_MonthCard, LuaComponentTemplates.BuffItem_AdvanceMonthCardTemplate)
    self.anvanceMonthCardTempate:InitTemplate(templateParam)
  end
  if self.extraBuffItemsTemplate == nil then
    self.extraBuffItemsTemplate = luaTemplateManager.GetNewTemplate(self.go_buffExtend, LuaComponentTemplates.ExtraBuffItemsTemplate)
  end
end

function Main_BuffUI:UpdataTemplates()
  if self.memberCardTempate ~= nil then
    self.memberCardTempate:UpdataMaskView()
  end
  if self.anvanceMonthCardTempate ~= nil then
    self.anvanceMonthCardTempate:UpdataMaskView()
  end
end

function Main_BuffUI:RefreshTempates()
  if self.memberCardTempate ~= nil then
    self.memberCardTempate:Refresh()
  end
  if self.anvanceMonthCardTempate ~= nil then
    self.anvanceMonthCardTempate:Refresh()
  end
end

function Main_BuffUI:TemplateClickCallBack(type)
  if self.Grid_Tip == nil or IsNil(self.Grid_Tip.gameObject) then
    return
  end
  local targetTemplate = self:GetTemplateByType(type)
  if targetTemplate == nil then
    return
  end
  local tipsState = self.Grid_Tip.gameObject.activeSelf
  if not tipsState or targetTemplate.buffItemType ~= self.buffType then
    self:RefreshTipsView(targetTemplate.curCardInfo)
  end
  self.buffType = type
  self:SetGridTipState(not tipsState)
end

function Main_BuffUI:TemplateRefreshCallBack(type)
  if self.Grid_Tip == nil or IsNil(self.Grid_Tip.gameObject) then
    return
  end
  local tipsState = self.Grid_Tip.gameObject.activeSelf
  if not tipsState or type ~= self.buffType then
    return
  end
  local targetTemplate = self:GetTemplateByType(type)
  if targetTemplate == nil then
    return
  end
  self:RefreshTipsView(targetTemplate.curCardInfo)
end

function Main_BuffUI:TemplateTimeEndCallBack(type)
  if self.Grid_Tip == nil or IsNil(self.Grid_Tip.gameObject) then
    return
  end
  local tipsState = self.Grid_Tip.gameObject.activeSelf
  if not tipsState or type ~= self.buffType then
    return
  end
  local targetTemplate = self:GetTemplateByType(type)
  if targetTemplate == nil then
    return
  end
  self:ShowTimeFinishedTips()
  self:SetGridTipState(false)
end

function Main_BuffUI:RefreshTipsView(tipsData)
  if tipsData == nil then
    return
  end
  if self.destoryTimeSchedule then
    self:SetDestroyTime()
  end
  self.itemTip:SetText(tipsData.str or "")
  self.DaojishiText = self.memberDaojishiText
  self.acc = 0
  self.countDown = TimeUtility.RefreshSec(tipsData.endTime)
  self.timeFormat = tipsData.titleFormat
  local timeStr = string.GetColorText(TimeUtility.ShowDayTime(self.countDown), "#FF2323")
  self.itemTime:SetText(string.format(self.timeFormat, timeStr), "#FF2323")
  self.destoryTimeSchedule = Timer.StartLoopForever(1, self.RefreshTime, self, self.itemTime)
  self.acc = 0
end

function Main_BuffUI:RefreshTime(lab_lastTime)
  self.acc = self.acc + 1
  if self.countDown ~= nil and 1 <= self.countDown then
    self.countDown = self.countDown - 1
    local timeshow = string.GetColorText(TimeUtility.ShowDayTime(self.countDown), "#FF2323")
    local DaoJiShi = string.format(self.timeFormat, timeshow)
    lab_lastTime:SetText(DaoJiShi, "#FF2323")
    if 1 > self.countDown then
      local targetTemplate = self:GetTemplateByType(self.buffType)
      if targetTemplate then
        targetTemplate:TimeEndCallBack()
      end
    end
  end
  if self.acc > 6 then
    self.acc = 0
    self:SetGridTipState(false)
    self:SetDestroyTime()
  end
end

function Main_BuffUI:SetDestroyTime()
  if self.destoryTimeSchedule then
    Timer.Stop(self.destoryTimeSchedule)
    self.destoryTimeSchedule = nil
  end
end

function Main_BuffUI:ShowTimeFinishedTips()
  local timeStr = string.GetColorText(TimeUtility.ShowDayTime(0), "#FF2323")
  self.itemTime:SetText(string.format(self.timeFormat, timeStr), "#FF2323")
end

function Main_BuffUI:SetGridTipState(isShow)
  if self.Grid_Tip == nil or IsNil(self.Grid_Tip.gameObject) then
    return
  end
  if self.Grid_Tip.gameObject.activeSelf ~= isShow then
    self.Grid_Tip:SetActive(isShow)
  end
end
