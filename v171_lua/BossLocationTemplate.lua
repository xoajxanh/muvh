local BossLocationTemplate = {}

function BossLocationTemplate:Init()
  self:InitComponent()
end

function BossLocationTemplate:InitComponent()
  self.Title = self:GetControl("bossLocationTitle")
  self.Btn = self:GetControl("Group/Btn")
end

function BossLocationTemplate:Refresh()
  self.bossLocationDataTab = {}
  local sortTab = {}
  for i, v in ipairs(SceneData.bossPosDataList) do
    if sortTab[v.Param] == nil then
      sortTab[v.Param] = {}
      table.insert(sortTab[v.Param], v)
    else
      table.insert(sortTab[v.Param], v)
    end
  end
  for k, v in pairs(sortTab) do
    if v then
      for i, vv in ipairs(v) do
        if vv then
          table.insert(self.bossLocationDataTab, vv)
        end
      end
    end
  end
  if Instance_BossUI.selectToggleType == BossTogType.AngelBossTog and #self.bossLocationDataTab > 0 then
    table.sort(self.bossLocationDataTab, function(a, b)
      if a ~= nil and b ~= nil then
        if a.id and b.id then
          return a.id < b.id
        else
          return false
        end
      else
        return false
      end
    end)
  end
  if self.BtnContainer == nil then
    self.BtnContainer = UIContainer(self.Btn, self, self.OnBtnCreat, self.OnBtnRefresh)
  end
  self.BtnContainer:SetData(self.bossLocationDataTab)
  local haveData = #self.bossLocationDataTab > 0
  self.Title:SetActive(false)
  return haveData
end

function BossLocationTemplate.OnBtnCreat(ctr)
  ctr.lab_name = UIControl(ctr.transform, "lab_name")
end

function BossLocationTemplate.OnBtnRefresh(ctr, _, data, ui)
  ctr.data = data
  ctr:SetOnClick(ui, ui.BtnOnClick)
  ctr.lab_name:SetText(data.name)
end

function BossLocationTemplate:BtnOnClick(control)
  local data = control.data
  if not data then
    return
  end
  if not data.position then
    return
  end
  if UIManager.IsVisible(UIID.MapDetailUI) then
    Main_MapDetailUI:ShowMovePathByWorldPos(self:ConvertPos(data.position), nil, function(moveRes)
      if UIManager.IsVisible(UIID.FlyShoe_FlyShoeUI) then
        UIManager.Hide(UIID.FlyShoe_FlyShoeUI)
      end
      if moveRes == ENavigateStatus.Arrived then
        RoleManager.me:SetAutoFight(AutoFightStrKey.AutoFight)
      end
    end)
    if UIManager.IsVisible(UIID.FlyShoe_FlyShoeUI) then
      EventManager.Dispatch(Event.FlyShoeRefresh)
    else
      UIManager.Show(UIID.FlyShoe_FlyShoeUI)
    end
  end
end

function BossLocationTemplate:ConvertPos(posStr)
  local posArray = string.split(posStr, "#")
  return Vector3(tonumber(posArray[1]), 0, tonumber(posArray[2]))
end

return BossLocationTemplate
