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
  local cost, checkCfg = {}
  local holySkeletonBossMapId = table.isNullOrEmpty(GlobalConfig.HolySkeletonBossHelpCfg) == false and GlobalConfig.HolySkeletonBossHelpCfg[1]
  local runeBossMapId = table.isNullOrEmpty(GlobalConfig.RuneBossHelpCfg) == false and GlobalConfig.RuneBossHelpCfg[1]
  if holySkeletonBossMapId and mapId and holySkeletonBossMapId == mapId then
    checkCfg = GlobalConfig.HolySkeletonBossHelpCfg
  elseif runeBossMapId and mapId and runeBossMapId == mapId then
    checkCfg = GlobalConfig.RuneBossHelpCfg
  else
    return
  end
  if table.count(checkCfg) > 0 then
    for i = 4, 20, 2 do
      if checkCfg[i] then
        table.insert(cost, {
          itemId = checkCfg[i],
          count = checkCfg[i + 1]
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
