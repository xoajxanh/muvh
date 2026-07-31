local ExperienceBonusViewTemplate = {}

function ExperienceBonusViewTemplate:GetExperienceBonusMgr()
  if gameMgr:GetAvatarManager() and gameMgr:GetAvatarManager():GetMainPlayer() then
    return gameMgr:GetAvatarManager():GetMainPlayer():GetExperienceBonusMgr()
  end
end

function ExperienceBonusViewTemplate:Init()
  self:InitControls()
  self:InitParams()
  self:BindUIEvent()
end

function ExperienceBonusViewTemplate:InitParams()
  if self.expBonusContainer == nil then
    self.expBonusContainer = UIUtility.BindUIContainerTemp(self.go_unit, LuaComponentTemplates.ExperienceBonusViewUnitTemplate, self)
  end
  self.arrowRoatateTbl = {
    [false] = {
      x = 1,
      y = 1,
      z = 1
    },
    [true] = {
      x = 1,
      y = -1,
      z = 1
    }
  }
end

function ExperienceBonusViewTemplate:InitControls()
  self.btn_expUp = self:GetControl("btn_expUpBg")
  self.lab_expUp = self:GetControl("btn_expUpBg/lab_expUp")
  self.gp_arrow = self:GetControl("btn_expUpBg/bg_expbar_arrow")
  self.go_unit = self:GetControl("sw_expUp/Viewport/Content/img_expUpBlackBg")
  self.sw_expUp = self:GetControl("sw_expUp")
end

function ExperienceBonusViewTemplate:BindUIEvent()
  self.btn_expUp:SetOnClick(self, self.ClickExpUpBtnCallBack)
end

function ExperienceBonusViewTemplate:ClickExpUpBtnCallBack()
  self:RefreshListViewState()
  self:RefreshArror()
end

function ExperienceBonusViewTemplate:InitView()
  self:RefreshData()
  self:RefreshView()
  self:SetListState(false)
end

function ExperienceBonusViewTemplate:RefreshData()
  if self:GetExperienceBonusMgr() == nil then
    return
  end
  self.IdList = self:GetExperienceBonusMgr():GetNeedShowExpId()
  self.idCount = table.count(self.IdList)
end

function ExperienceBonusViewTemplate:RefreshView()
  local totalNum = self:GetExperienceBonusMgr():GetTotalAddExpNum()
  local holyRingLotionData = gameMgr:GetAvatarManager():GetMainPlayer():GetExperienceBonusMgr():GetExperienceBonusData(1009)
  if holyRingLotionData ~= nil then
    local holyRingLotionAddExp = holyRingLotionData.value
    if 0 < totalNum then
      totalNum = totalNum - holyRingLotionAddExp <= 0 and 0 or totalNum - holyRingLotionAddExp
    end
  end
  self.lab_expUp:SetText(totalNum .. "EABCD")
  if self.IdList then
    self.expBonusContainer:SetData(self.IdList)
  end
end

function ExperienceBonusViewTemplate:RefreshListViewState()
  if self.sw_expUp == nil or IsNil(self.sw_expUp.gameObject) then
    return
  end
  local curState = self.sw_expUp.gameObject.activeSelf
  if curState then
    self:SetListState(false)
  else
    self:SetListState(self.idCount ~= nil and self.idCount > 0)
  end
end

function ExperienceBonusViewTemplate:SetListState(state)
  if self.sw_expUp.gameObject.activeSelf == state then
    return
  end
  self.sw_expUp:SetActive(state)
end

function ExperienceBonusViewTemplate:RefreshArror()
  local isShowList = self.sw_expUp and not IsNil(self.sw_expUp.gameObject) and self.sw_expUp.gameObject.activeSelf
  self.gp_arrow:SetScale(self.arrowRoatateTbl[isShowList])
end

function ExperienceBonusViewTemplate:ExperienceBonusStateChangedCallBack()
  self:RefreshData()
  self:RefreshView()
end

function ExperienceBonusViewTemplate:ExperienceBonusDataChangedCallBack()
  self:RefreshData()
  self:RefreshView()
end

return ExperienceBonusViewTemplate
