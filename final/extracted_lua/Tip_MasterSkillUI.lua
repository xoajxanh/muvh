Tip_MasterSkillUI = class(BaseUI)
Tip_MasterSkillUI.layer = UILayer.Panel
Tip_MasterSkillUI.orderInLayer = 1
Tip_MasterSkillUI.hideType = UIHideType.WaitDestroy
Tip_MasterSkillUI.hideFunc = UIHideFunc.MoveOutOfScreen
Tip_MasterSkillUI.escClose = UIEscClose.DontClose

function Tip_MasterSkillUI:InitControls()
  self.Bg_Close = self:GetControl("Bg_Close")
  self.Panel_Skill = self:GetControl("Panel_Skill")
  self.Tip_Skill = self:GetControl("Panel_Skill/Tip_Skill")
  self.btn_SkillCloseBg = self:GetControl("Panel_Skill/Tip_Skill/btn_SkillCloseBg")
  self.btn_SkillClose = self:GetControl("Panel_Skill/Tip_Skill/bg_skillDetail/btn_SkillClose")
  self.skillImg = self:GetControl("Panel_Skill/Tip_Skill/bg_skillDetail/skillBg/skillImg")
  self.lab_skillName = self:GetControl("Panel_Skill/Tip_Skill/bg_skillDetail/lab_skillName")
  self.skillLevel = self:GetControl("Panel_Skill/Tip_Skill/bg_skillDetail/skillLevel")
  self.lab_skillLevel = self:GetControl("Panel_Skill/Tip_Skill/bg_skillDetail/skillLevel/lab_skillLevel")
  self.needCount = self:GetControl("Panel_Skill/Tip_Skill/bg_skillDetail/needTip/needCount")
  self.lab_currentLeveL = self:GetControl("Panel_Skill/Tip_Skill/bg_skillDetail/upperLevel/levelBg/lab_currentLeveL")
  self.upperLevelScrollView = self:GetControl("Panel_Skill/Tip_Skill/bg_skillDetail/upperLevel/ScrollView")
  self.lab_currentSkillTip = self:GetControl("Panel_Skill/Tip_Skill/bg_skillDetail/upperLevel/ScrollView/Viewport/Content/lab_currentSkillTip")
  self.nextLeveL = self:GetControl("Panel_Skill/Tip_Skill/bg_skillDetail/nextLevel")
  self.lab_nextLeveL = self:GetControl("Panel_Skill/Tip_Skill/bg_skillDetail/nextLevel/levelBg/lab_nextLeveL")
  self.nextLevelScrollView = self:GetControl("Panel_Skill/Tip_Skill/bg_skillDetail/nextLevel/ScrollView")
  self.lab_nextSkillTip = self:GetControl("Panel_Skill/Tip_Skill/bg_skillDetail/nextLevel/ScrollView/Viewport/Content/lab_nextSkillTip")
  self.btn_goInput = self:GetControl("Panel_Skill/Tip_Skill/bg_skillDetail/btns/btn_goInput")
end

function Tip_MasterSkillUI:Init()
end

function Tip_MasterSkillUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Tip_MasterSkillUI:InitUI()
  self.isCanUpgrade = false
end

function Tip_MasterSkillUI:RegistUIEvents()
  self.Bg_Close:SetOnClick(self, self.Bg_CloseOnClick)
  self.btn_SkillCloseBg:SetOnClick(self, self.btn_SkillCloseBgOnClick)
  self.btn_SkillClose:SetOnClick(self, self.btn_SkillCloseOnClick)
  self.btn_goInput:SetOnClick(self, self.btn_goInputOnClick)
end

function Tip_MasterSkillUI:Bg_CloseOnClick(control)
  UIManager.Hide(UIID.Tip_MasterSkillUI)
end

function Tip_MasterSkillUI:btn_SkillCloseBgOnClick(control)
  UIManager.Hide(UIID.Tip_MasterSkillUI)
end

function Tip_MasterSkillUI:btn_SkillCloseOnClick(control)
end

function Tip_MasterSkillUI:btn_goInputOnClick(control)
  if QuickFind.MasterDataMgr():GetUpcodeByGroupId(self.skillData.skillGroup) == MasterSkillUpcode.ProfessionalTalentNotOpen then
    local text = ClientTable.cfg_Ui_wordManager:GetUi_wordCount("Dashi_8")
    FloatingTipUtility.QuickMsg(text)
    return
  elseif QuickFind.MasterDataMgr():GetUpcodeByGroupId(self.skillData.skillGroup) == MasterSkillUpcode.TalentNotOpen then
    local text = ClientTable.cfg_Ui_wordManager:GetUi_wordCount("Dashi_9")
    FloatingTipUtility.QuickMsg(text)
    return
  end
  if QuickFind.MasterDataMgr():GetUpcodeByGroupId(self.skillData.skillGroup) ~= MasterSkillUpcode.ProfessionalTalentNotOpen then
    networkRequest.ReqUpGrandMasterSkill(self.skillData.subType, self.skillData.lid)
  end
  if self.isCanUpgrade == true then
    if UIManager.IsVisible(UIID.EffectTipUI) then
      EventManager.Dispatch(Event.TipEffect, {
        name = "Eff_UI_masterskillshengjichenggong",
        time = 1
      })
    else
      UIManager.Show(UIID.EffectTipUI, {
        name = "Eff_UI_masterskillshengjichenggong",
        effectTime = 1
      })
    end
  end
end

function Tip_MasterSkillUI:OnShow()
  self:RegistEvents()
  self:ResetScrollViewPos()
  self:Refresh()
end

function Tip_MasterSkillUI:RegistEvents()
  self:RegistEvent(Event.NewMasterSkillUpgradeDataChanged, self.RefreshUpgradeSkillTip, self)
  self:RegistEvent(Event.NewMasterPointChanged, self.NewMasterPointChangedCallBack, self)
end

function Tip_MasterSkillUI:Refresh()
  self:RefreshTipMasterSkillData()
  self:RefreshTipMasterSkillView()
end

function Tip_MasterSkillUI:ResetScrollViewPos()
  self.upperLevelScrollView.scrollRect.normalizedPosition = Vector2(0, 1)
  self.nextLevelScrollView.scrollRect.normalizedPosition = Vector2(0, 1)
end

function Tip_MasterSkillUI:RefreshUpgradeSkillTip(id, tblId)
  self:ResetScrollViewPos()
  self:RefreshTipMasterSkillData(tblId)
  self:RefreshTipMasterSkillView()
end

function Tip_MasterSkillUI:RefreshTipMasterSkillData(tblId)
  if tblId == nil then
    if self.args.data == nil then
      return
    end
    self.skillData = self.args.data
  else
    local data = QuickFind.MasterDataMgr():GetSkillDataByLid(tblId)
    self.skillData = data
  end
end

function Tip_MasterSkillUI:NewMasterPointChangedCallBack(id, data)
  self:RefreshTipMasterSkillView()
end

function Tip_MasterSkillUI:RefreshTipMasterSkillView()
  if self.skillData == nil then
    return
  end
  self:RefreshUpgradeButtonState()
  self:SetSprite("Atlas_Skill", self.skillData.skillIcon, self.skillImg)
  self.lab_skillName:SetText(self.skillData.name)
  self.lab_skillLevel:SetText(self.skillData.level .. "/" .. self.skillData.maxlevel)
  local colorNeedPoint = self.skillData.needPoint and string.GetColorText(self.skillData.needPoint, QuickFind.MasterDataMgr():GetExPointIsEnough(self.skillData.subType, self.skillData.needPoint) and "#DCE1E5" or "#FF2323") or ""
  self.needCount:SetText(colorNeedPoint)
  local cfg_MasterSkill_detailManager = ClientTable.cfg_MasterSkill_detailManager
  local curSkillDesID = cfg_MasterSkill_detailManager:GetCurItemTipsIDByLid(self.skillData.lid)
  local nextSkillDesID = cfg_MasterSkill_detailManager:GetCurItemTipsIDByLid(self.skillData.nextLId)
  self.lab_currentSkillTip:SetText(SkillUtility.ParseSkillDesc(curSkillDesID))
  if self.skillData.level < self.skillData.maxlevel then
    self.lab_nextSkillTip:SetText(SkillUtility.ParseSkillDesc(nextSkillDesID))
  else
    self.lab_nextSkillTip:SetText("K\225\187\185 n\196\131ng hi\225\187\135n t\225\186\161i \196\145\195\163 \196\145\225\186\167y c\225\186\165p")
  end
end

function Tip_MasterSkillUI:RefreshNextLeveLState()
  self.nextLeveL:SetActive(self.skillData.nextLId ~= nil)
end

function Tip_MasterSkillUI:RefreshUpgradeButtonState()
  if self.skillData.level == nil and self.skillData.maxlevel == nil then
    return
  end
  if self.skillData.level < self.skillData.maxlevel then
    self.btn_goInput:SetActive(true)
    self:RefreshUpgradeButtonColorState()
  else
    self.btn_goInput:SetActive(false)
  end
end

function Tip_MasterSkillUI:RefreshUpgradeButtonColorState()
  if self.skillData and self.skillData.skillGroup and QuickFind.MasterDataMgr():GetUpcodeByGroupId(self.skillData.skillGroup) == MasterSkillUpcode.CanUpgrade then
    self.isCanUpgrade = true
    self:Btn_goInputTurnNormal()
  else
    self.isCanUpgrade = false
    self:Btn_goInputTurnGrey()
  end
end

function Tip_MasterSkillUI:Btn_goInputTurnGrey()
  self:SetSprite("Atlas_Common", "ty_btn_short_grey", self.btn_goInput)
end

function Tip_MasterSkillUI:Btn_goInputTurnNormal()
  self:SetSprite("Atlas_Common", "ty_btn_short3_new", self.btn_goInput)
end

function Tip_MasterSkillUI:ShowLearnExSkillTip()
  if self.skillData and self.skillData.name and self.skillData.preSkills and self.skillData.preSkills.groupId then
    local cfg = ConfigManager.GetConfig("cfg_Skill_skill", self.skillData.preSkills.groupId, "groupId")
    local perSkillName = cfg and cfg.name or ""
    FloatingWordUtility.QuickMsg(string.format("K\195\173ch ho\225\186\161t %s c\225\186\167n h\225\187\141c K\225\187\185 N\196\131ng %s tr\198\176\225\187\155c \196\145\195\179 tr\198\176\225\187\155c", self.skillData.name, perSkillName))
  end
end

function Tip_MasterSkillUI:OnHide()
  self.skillData = nil
end
