local GoalUI_AncientBossTemp = {}

function GoalUI_AncientBossTemp:Init(root)
  self.root = root
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
  self:BindEvent()
end

function GoalUI_AncientBossTemp:InitControls()
  self.lab_instance = self:GetControl("lab_instance")
  self.lab_des = self:GetControl("lab_des")
  self.btn_next = self:GetControl("btn_next")
  self.cost = self:GetControl("cost")
  self.frame_item = self:GetControl("cost/Viewport/materialParent/frame_item")
end

function GoalUI_AncientBossTemp:InitUI()
  self.costItemsTemplate = UIUtility.BindUIContainerTemp(self.frame_item, LuaComponentTemplates.ConsumableUnitTemplate, self.root)
end

function GoalUI_AncientBossTemp:RegistUIEvents()
  self.btn_next:SetOnClick(self, self.btn_nextOnClick)
end

function GoalUI_AncientBossTemp:btn_nextOnClick()
  networkRequest.ReqUnionSeekHelp()
end

function GoalUI_AncientBossTemp:BindEvent()
  self.eventContainer = EventContainer(EventManager)
  self.eventContainer:Regist(Event.Bag_ResBagChange, self.BagChangedCallBack, self)
  self.eventContainer:Regist(Event.Bag_ResBagInfo, self.BagChangedCallBack, self)
end

function GoalUI_AncientBossTemp:BagChangedCallBack()
  self:Refresh(SceneData.groupId)
end

function GoalUI_AncientBossTemp:Refresh(mapId)
  local cost, checkCfg, holySkeletonBossMapId, runeBossMapId = {}
  if not table.isNullOrEmpty(GlobalConfig.HolySkeletonBossHelpCfg) and GlobalConfig.HolySkeletonBossHelpCfg[1] then
    for i, v in pairs(GlobalConfig.HolySkeletonBossHelpCfg[1]) do
      if mapId == tonumber(v) then
        holySkeletonBossMapId = tonumber(v)
        break
      end
    end
  end
  if not table.isNullOrEmpty(GlobalConfig.RuneBossHelpCfg) and GlobalConfig.RuneBossHelpCfg[1] then
    for i, v in pairs(GlobalConfig.RuneBossHelpCfg[1]) do
      if mapId == tonumber(v) then
        runeBossMapId = tonumber(v)
        break
      end
    end
  end
  if holySkeletonBossMapId and mapId and holySkeletonBossMapId == mapId and not table.isNullOrEmpty(GlobalConfig.HolySkeletonBossHelpCfg[2]) then
    checkCfg = GlobalConfig.HolySkeletonBossHelpCfg[2]
  elseif runeBossMapId and mapId and runeBossMapId == mapId and not table.isNullOrEmpty(GlobalConfig.RuneBossHelpCfg[2]) then
    checkCfg = GlobalConfig.RuneBossHelpCfg[2]
  else
    return
  end
  if table.count(checkCfg) > 0 then
    for i = 3, 20, 2 do
      if checkCfg[i] then
        table.insert(cost, {
          itemId = tonumber(checkCfg[i]),
          count = tonumber(checkCfg[i + 1])
        })
      else
        break
      end
    end
  end
  self.costItemsTemplate:SetData(cost)
end

function GoalUI_AncientBossTemp:OnHide()
end

return GoalUI_AncientBossTemp
