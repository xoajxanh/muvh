local OnHookPointTemplate = {}

function OnHookPointTemplate:Init()
  self.tip = self:GetControl("tip")
  self.goLineName = self:GetControl("goLineName")
  self.index = self:GetControl("index")
  self.img_quan = self:GetControl("img_quan")
  self.img_quan:SetActive(false)
  self.index:SetActive(false)
  self:UIControl():SetOnClick(self, self.OnClick)
end

function OnHookPointTemplate:Refresh(data)
  self.data = data
  if data == nil then
    return
  end
  self.goLineName:SetText(data.des)
end

function OnHookPointTemplate:OnClick()
  UIManager.Hide(UIID.Instance_BossUI)
  self:JumpMap()
end

function OnHookPointTemplate:JumpMap()
  if self.data == nil or self.data.cfg_OnHook_Point == nil then
    return
  end
  local mapInfo = ClientTable.cfg_Map_mapManager:TryGetValue(self.data.cfg_OnHook_Point.mapId)
  if mapInfo == nil then
    return
  end
  PathFinderManager.JumpMapToMoveToPos(self.data.cfg_OnHook_Point.mapTransId, Vector2(self.data.x, self.data.y), nil, mapInfo.cline, nil, Purpose.None, function()
    RoleManager.me:SetAutoHookFight(true)
  end, nil, true)
end

return OnHookPointTemplate
