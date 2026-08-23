ShowTaskMonsterPage = class(BaseUI)
ShowTaskMonsterPage.layer = UILayer.Panel
ShowTaskMonsterPage.orderInLayer = 0
ShowTaskMonsterPage.hideType = UIHideType.Hide
ShowTaskMonsterPage.hideFunc = UIHideFunc.MoveOutOfScreen
ShowTaskMonsterPage.escClose = UIEscClose.DontClose

function ShowTaskMonsterPage:InitControls()
  self.bg = self:GetControl("bg")
  self.direct = self:GetControl("bg/direct")
  self.monsterName = self:GetControl("bg/monsterName")
  self.distance = self:GetControl("bg/distance")
  self.Image = self:GetControl("bg/Image")
end

ShowTaskMonsterPage.lastPointTbl = nil

function ShowTaskMonsterPage:OnPreLoad()
end

function ShowTaskMonsterPage:Init()
end

function ShowTaskMonsterPage:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function ShowTaskMonsterPage:InitUI()
  self.index = 0
end

function ShowTaskMonsterPage:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function ShowTaskMonsterPage:OnHide()
end

function ShowTaskMonsterPage:OnDestroy()
end

function ShowTaskMonsterPage:Update()
  if UIManager.IsVisible(UIID.PlayerHpMPInfoUI) then
    self.bg:SetActive(false)
    return
  end
  if RoleManager.me then
    local mapPointTbl, dis, angle = self:GetMapMonsterData()
    if self.lastPointTbl ~= nil and self.lastPointTbl.id == mapPointTbl.id and self.lastDistance == dis then
      return
    end
    self.mapPointTbl = mapPointTbl
    self.lastDistance = dis
    if mapPointTbl then
      local isShow = ClientTable.cfg_Global_globalManager:CheckMonsterGuideCloseRange(dis)
      self.bg:SetActive(isShow)
      if not isShow then
        return
      end
      local mindis = string.format("\225\187\158 n\198\161i g\225\186\167n <color=#FF0000>%dm</color>", dis)
      self:RefreshInfo(mapPointTbl.point, mapPointTbl.name, mindis, -angle)
    elseif gameMgr:GetAvatarManager():GetMainPlayer():GetActivityDataMgr():GetKLTRuinsManager():GetVirusCircleManager().IsInActivity then
      local distance, angle = gameMgr:GetAvatarManager():GetMainPlayer():GetActivityDataMgr():GetKLTRuinsManager():GetVirusCircleManager():GetDirAndDisByMainPlayerPoint()
      local isShow = distance ~= nil and angle ~= nil and 1 <= distance
      self.bg:SetActive(isShow)
      if isShow == false then
        return
      end
      local disDes = string.format(ClientTable.cfg_Activity_globalManager:GetSafeAreaDirDisFormat(), Mathf.Floor(distance))
      self:RefreshInfo(ClientTable.cfg_Activity_globalManager:GetSafeAreaDirIcon(), ClientTable.cfg_Activity_globalManager:GetSafeAreaDirName(), disDes, -angle - 45)
    else
      self.bg:SetActive(false)
    end
  end
end

function ShowTaskMonsterPage:RefreshInfo(spriteName, name, disDes, angle)
  self:SetSprite("Atlas_Common", spriteName, self.Image)
  self.monsterName:SetText(name)
  self.distance:SetText(disDes)
  self.direct:SetRotation(0, 0, angle)
end

function ShowTaskMonsterPage:RegistUIEvents()
end

function ShowTaskMonsterPage:RegistEvents()
end

function ShowTaskMonsterPage:Refresh()
end

function ShowTaskMonsterPage:GetMapMonsterData()
  local monsterPointList = ClientTable.cfg_Map_minimapManager:GetMonsterPointList(SceneData.mapId)
  if type(monsterPointList) ~= "table" or #monsterPointList <= 0 then
    return
  end
  local startPoint, endPointV3, endPointV2, minDistancePointTbl, minDistance, minDistancePointV2, angle = RoleManager.me.cellPos, Vector3.zero
  for k, v in pairs(monsterPointList) do
    local distance
    endPointV2 = Vector2.NewByString(v.position)
    if endPointV2 ~= nil then
      distance = Vector2.Distance(endPointV2, startPoint)
    end
    if ClientTable.cfg_Global_globalManager:CheckMonsterGuideRange(distance) and (minDistance == nil or distance ~= nil and minDistance > Mathf.Round(distance)) then
      minDistance = Mathf.Round(distance)
      minDistancePointTbl = v
      minDistancePointV2 = endPointV2
    end
  end
  if minDistancePointTbl == nil then
    return
  end
  local direct = {}
  direct.x = minDistancePointV2.x - startPoint.x
  direct.y = minDistancePointV2.y - startPoint.y
  local directNormal = Vector2.Normalize(direct)
  local defaultDirect = {}
  defaultDirect.x = 0
  defaultDirect.y = 0
  angle = Vector2.Angle(defaultDirect, directNormal)
  return minDistancePointTbl, minDistance, angle
end

local posVect3 = Vector3.zero
local viewInfernalMobs = {}
local typeList = {2002}

function ShowTaskMonsterPage:GetViewAllInfernalMobs()
  local curInfernalMobs
  for k, v in pairs(viewInfernalMobs) do
    viewInfernalMobs[k] = nil
  end
  RoleManager.GetMonsterByMonsterType2(viewInfernalMobs, typeList)
  local curMinDis = 100
  local angle = 0
  for k, v in pairs(viewInfernalMobs) do
    local distance = Vector2.Distance(v.cellPos, RoleManager.me.cellPos)
    local direct = {}
    posVect3:Set(v.cellPos.x, 0, v.cellPos.y)
    local endPos = MainCamera.camera:WorldToScreenPoint(posVect3)
    local startPos = self.direct.transform.position
    direct.x = endPos.x - startPos.x
    direct.y = endPos.y - startPos.y
    local directNormal = Vector2.Normalize(direct)
    local defaultDirect = {}
    defaultDirect.x = 0
    defaultDirect.y = 1
    angle = Vector2.Angle(defaultDirect, directNormal)
    if 0 < directNormal.x then
      angle = 360 - angle
    end
    if curMinDis > Mathf.Floor(distance) then
      curMinDis = Mathf.Floor(distance)
      curInfernalMobs = v
    end
  end
  return curInfernalMobs, curMinDis, angle
end
