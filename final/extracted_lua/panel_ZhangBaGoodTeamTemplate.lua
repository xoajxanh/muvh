local panel_ZhangBaGoodTeamTemplate = {}

function panel_ZhangBaGoodTeamTemplate:Init(root)
  self.root = root
  self:InitControls()
  self:InitUI()
  self:BindUIEvent()
end

function panel_ZhangBaGoodTeamTemplate:InitControls()
  self.flagLittleItem = self:GetControl("GradArmbandsShow/Viewport/Content/GradArmbandsItem")
  self.objFlag = self:GetControl("GradArmbandsShow")
  self.teamName = self:GetControl("img_Name/lab_text")
  self.teamNoName = self:GetControl("img_Name/lab_Vacancy")
end

function panel_ZhangBaGoodTeamTemplate:InitUI()
  self.flagLittleItemContainer = UIContainer(self.flagLittleItem)
end

function panel_ZhangBaGoodTeamTemplate:BindUIEvent()
end

function panel_ZhangBaGoodTeamTemplate:Refresh()
  self:RefreshFlag()
end

function panel_ZhangBaGoodTeamTemplate:RefreshFlag()
end

function panel_ZhangBaGoodTeamTemplate:ShowNoRank()
  self.objFlag:SetActive(false)
  self.teamNoName:SetActive(true)
  self.teamName:SetActive(false)
end

function panel_ZhangBaGoodTeamTemplate:ShowGoodTeamRank(data)
  if data == nil then
    self:ShowNoRank()
    return
  end
  self.objFlag:SetActive(true)
  self.teamNoName:SetActive(false)
  self.teamName:SetActive(true)
  self.teamName:SetText("S" .. tostring(data.serverId) .. "." .. data.unionName)
  self.flagLittleItemContainer:SetActiveTable()
  if data ~= nil and data.unionLogo ~= "" then
    local num = WarAllianceData.ArmbandsDesignGridNum
    for i = 1, num do
      local obj = self.flagLittleItemContainer:GetOrCreateItem(i)
      obj:SetActive(true)
      if data.unionLogo[i] == 0 then
        obj.gameObject:GetComponent(typeof(UnityEngineUI.Image)).enabled = false
      else
        obj.gameObject:GetComponent(typeof(UnityEngineUI.Image)).enabled = true
        obj:SetColor(data.unionLogo[i])
      end
    end
  end
end

function panel_ZhangBaGoodTeamTemplate:OnDisable()
end

function panel_ZhangBaGoodTeamTemplate:Exit()
  self:UIControl():SetActive(false)
end

return panel_ZhangBaGoodTeamTemplate
