local PlayerPointTemplate = {}
local mapWidthScale, mapHeightScale, halfMapSpWidth, halfMapSpHeight
local rotateParam = 0.4

function PlayerPointTemplate:Init()
  self:InitComponent()
end

function PlayerPointTemplate:InitComponent()
  self.sp_blood = self:GetControl("sp_blood")
end

function PlayerPointTemplate:Refresh(data, ui)
  if not data then
    self:GetControl():SetActive(false)
    return
  end
  self.data = data
  self.ui = ui
  self:GetControl():SetActive(true)
  self:RefreshMapDataScale()
end

function PlayerPointTemplate:Update()
  if self.data then
    local career = RoleUtility.GetBasicCareer(self.data:GetCareer())
    local handImage = self.data._serverData.groupType == 1 and "3V3HeadBg01" or "3V3HeadBg02"
    self.ui:SetSprite("Atlas_Common", handImage, self:GetControl())
    self.ui:SetSprite("Atlas_headPortrait", career, self.sp_blood)
    if QuickFind:GetThreeVsThreeDataMgr() and QuickFind:GetThreeVsThreeDataMgr():GetMainPlayerCampInfo() and QuickFind:GetThreeVsThreeDataMgr():GetMainPlayerCampInfo():GetPlayerInfo(RoleManager.me.id) then
      local mainPlayerInfo = QuickFind:GetThreeVsThreeDataMgr():GetMainPlayerCampInfo():GetPlayerInfo(RoleManager.me.id)
      if mainPlayerInfo ~= nil then
        local camp = mainPlayerInfo:GetGroupId()
        if self.data:GetId() ~= RoleManager.me.id and self.data:GetGroupId() ~= camp then
          local state = QuickFind:GetThreeVsThreeDataMgr():GetPlayerCampPositionInfo(self.data:GetId())
          self:GetControl():SetActive(state)
        end
      end
    end
    if QuickFind:GetThreeVsThreeDataMgr() and QuickFind:GetThreeVsThreeDataMgr():GetCampPositionInfoList(self.data:GetId()) then
      local playerInfo = QuickFind:GetThreeVsThreeDataMgr():GetCampPositionInfoList(self.data:GetId())
      if playerInfo then
        local x = playerInfo.X
        local y = playerInfo.Y
        local curPosX = (x * mapWidthScale - halfMapSpWidth) * rotateParam + (y * mapHeightScale - halfMapSpHeight) * rotateParam + 12
        local curPosY = -(x * mapWidthScale - halfMapSpWidth) * rotateParam + (y * mapHeightScale - halfMapSpHeight) * rotateParam + 2
        self:GetControl().transform:SetAnchoredPosition(curPosX, curPosY)
      end
    end
  end
end

function PlayerPointTemplate:RefreshMapDataScale()
  mapWidthScale = 1024 / SceneData.width
  mapHeightScale = 1024 / SceneData.height
  halfMapSpWidth = 512.0
  halfMapSpHeight = 512.0
end

return PlayerPointTemplate
