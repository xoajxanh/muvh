local img_daTaranKBgTemplate = {}

function img_daTaranKBgTemplate:Init(data)
  self:InitControls()
  self:InitTemplates()
  self:InitUIEvents()
end

function img_daTaranKBgTemplate:InitControls()
  self.lab_RoleLevel1 = self:GetControl("lab_RoleLevel")
  self.lab_RoleLevel2 = self:GetControl("lab_RoleLevel (1)")
  self.btn_Item1 = self:GetControl("sw_gift/Viewport/Content1/btn_Item")
  self.btn_Item2 = self:GetControl("sw_gift/Viewport/Content2/btn_Item")
  self.btn_Item3 = self:GetControl("sw_gift/Viewport/Content2/btn_Item (1)")
  self.SelfTasBtn_getA = self:GetControl("SelfTaskgo_state2/SelfTaskbtn_get")
  self.Eff_UI_SelfTaskA = self:GetControl("SelfTaskgo_state2/SelfTaskbtn_get/Eff_UI_SelfTask")
  self.SelfTaskLab_FinishA = self:GetControl("SelfTaskgo_state2/SelfTasklab_Finish")
  self.SelfTasBtn_getO = self:GetControl("SelfTaskgo_state1/SelfTaskbtn_get")
  self.Eff_UI_SelfTaskO = self:GetControl("SelfTaskgo_state1/SelfTaskbtn_get/Eff_UI_SelfTask")
  self.SelfTaskLab_FinishO = self:GetControl("SelfTaskgo_state1/SelfTasklab_Finish")
end

function img_daTaranKBgTemplate:InitTemplates()
  self.rewardItemTemplate1 = UIUtility.BindUIContainerTemp(self.btn_Item1, LuaComponentTemplates.UIItemTemplate, self.root, {
    isShowTips = true,
    stencil = 2,
    maskType = 5
  })
  self.rewardItemTemplate2 = UIUtility.BindUIContainerTemp(self.btn_Item2, LuaComponentTemplates.UIItemTemplate, self.root, {
    isShowTips = true,
    stencil = 2,
    maskType = 5
  })
end

function img_daTaranKBgTemplate:InitUIEvents()
  self.SelfTasBtn_getO:SetOnClick(self, self.SelfTasBtn_getOnClick)
  self.SelfTasBtn_getA:SetOnClick(self, self.SelfTasBtn_getAOnClick)
end

function img_daTaranKBgTemplate:SelfTasBtn_getOnClick()
  self.SelfTasBtn_getO:SetActive(false)
  self.SelfTasBtn_getO:SetInteractable(false)
  self.Eff_UI_SelfTaskO:SetActive(false)
  self.SelfTaskLab_FinishO:SetActive(true)
  networkRequest.ReqGetGift({
    self.data.ordinary.id
  })
end

function img_daTaranKBgTemplate:SelfTasBtn_getAOnClick()
  self.SelfTasBtn_getA:SetActive(false)
  self.SelfTasBtn_getA:SetInteractable(false)
  self.Eff_UI_SelfTaskA:SetActive(false)
  self.SelfTaskLab_FinishA:SetActive(true)
  if self.data.advanced and ConditionManager.Check4D(self.data.advanced.buyCondition) and self.advancedSeverCountKey and self.count > 0 and self.count <= 100 and self.advancedState ~= nil then
    if self.advancedState then
      return
    else
      networkRequest.ReqGetGift({
        self.data.advanced.id
      })
      networkRequest.ReqCountByType(260001)
    end
  end
end

function img_daTaranKBgTemplate:Refresh(data, ui)
  if table.isNullOrEmpty(data) then
    return
  end
  self.data = data
  self.ui = ui
  self.SelfTasBtn_getO:SetInteractable(false)
  self.Eff_UI_SelfTaskO:SetActive(false)
  self.SelfTaskLab_FinishO:SetActive(false)
  self.SelfTasBtn_getA:SetInteractable(false)
  self.Eff_UI_SelfTaskA:SetActive(false)
  self.SelfTaskLab_FinishA:SetActive(false)
  self.btn_Item3:SetActive(false)
  self:RefreshOrdinary()
  self:RefreshAdvanced()
  self:SetInitTemplates()
end

function img_daTaranKBgTemplate:RefreshOrdinary()
  self.lab_RoleLevel1:SetText(self.data.rankData.showLevel)
  if self.data.ordinary.buyCondition ~= nil and ConditionManager.Check4D(self.data.ordinary.buyCondition) then
    local ordinaryState = QuickFind:GetTask_EarlyGoldManager():GetRefreshCountFun(self.data.ordinary)
    if ordinaryState then
      self.SelfTaskLab_FinishO:SetActive(true)
      self.SelfTasBtn_getO:SetActive(false)
    else
      self.SelfTasBtn_getO:SetActive(true)
      self.Eff_UI_SelfTaskO:SetActive(true)
      self.SelfTasBtn_getO:SetInteractable(true)
    end
  end
end

function img_daTaranKBgTemplate:RefreshAdvanced()
  self:RefreshCountKey()
  if self.data.advanced then
    if self.data.advanced.global then
      local global = self.data.advanced.global
      if tonumber(global[3]) == tonumber(self.data.advanced.id) then
        self.btn_Item3:SetActive(true)
        self.ui:SetSprite(global[1], global[2], self.btn_Item3)
      end
    end
    if self.data.advanced.buyCondition ~= nil and ConditionManager.Check4D(self.data.advanced.buyCondition) then
      self.advancedState = QuickFind:GetTask_EarlyGoldManager():GetRefreshCountFun(self.data.advanced)
      if self.advancedSeverCountKey and self.count ~= nil and tonumber(self.count) > 0 then
        if self.advancedState then
          self.SelfTaskLab_FinishA:SetActive(true)
          self.SelfTasBtn_getA:SetActive(false)
        else
          self.SelfTasBtn_getA:SetActive(true)
          self.SelfTasBtn_getA:SetInteractable(true)
          self.Eff_UI_SelfTaskA:SetActive(true)
        end
      end
    end
  else
    self.SelfTasBtn_getA:SetActive(false)
  end
end

function img_daTaranKBgTemplate:RefreshCountKey()
  if self.data.advanced then
    self.advancedSeverCountKey = RefreshData.GetRefreshByKey(self.data.advanced.severCountKey)
    if self.advancedSeverCountKey then
      self.count = self.advancedSeverCountKey.total - self.advancedSeverCountKey.count
      if self.count >= 0 then
        self.lab_RoleLevel2:SetText(self.data.rankData.showLevel .. "\n" .. "Su\225\186\165t C\195\178n L\225\186\161i" .. " " .. self.count)
      end
    end
  else
    self.lab_RoleLevel2:SetActive(false)
  end
end

function img_daTaranKBgTemplate:SetInitTemplates()
  self.ItemTbl = QuickFind:GetTask_EarlyGoldManager():GetBoxItemTbl({
    self.data.ordinary
  })
  if self.ItemTbl then
    self.rewardItemTemplate1:SetData(self.ItemTbl)
  end
  if self.data.advanced then
    self.ItemTbl2 = QuickFind:GetTask_EarlyGoldManager():GetBoxItemTbl({
      self.data.advanced
    })
    if self.ItemTbl2 then
      self.rewardItemTemplate2:SetData(self.ItemTbl2)
    end
  end
end

return img_daTaranKBgTemplate
