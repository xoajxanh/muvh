MeEquipController = {}
local this = MeEquipController
require("GameModel/RoleTitleData")
local firstCellTypeTbl, secendCellTypeTbl, thirdCellTypeTbl, FourCellTypeTbl, fiveCellTypeTbl, sevenCellTypeTbl

function MeEquipController.Init()
  this.messageContainer = EventContainer(NetManager)
  this.RegistMessages()
  this.SetEquipIntensifyConfigData()
  this.SetSuitConfigData()
  this.SetSuitEquipInfoData()
  this.SetStoneLightConfigData()
  this.RegistEvents()
  firstCellTypeTbl = MeEquipController.GetEquipCellByCellIndex(1)
  secendCellTypeTbl = MeEquipController.GetEquipCellByCellIndex(2)
  thirdCellTypeTbl = MeEquipController.GetEquipCellByCellIndex(3)
  FourCellTypeTbl = MeEquipController.GetEquipCellByCellIndex(4)
  fiveCellTypeTbl = MeEquipController.GetEquipCellByCellIndex(5)
  sevenCellTypeTbl = MeEquipController.GetEquipCellByCellIndex(7)
end

function MeEquipController.RegistMessages()
  this.messageContainer:Regist(EquipMessage.ResEquipChange, this.OnResEquipChange)
  this.messageContainer:Regist(EquipMessage.ResEquipIntensify, this.ResEquipIntensify)
  this.messageContainer:Regist(EquipMessage.ResEquipAdditional, this.ResEquipAdditional)
  this.messageContainer:Regist(EquipMessage.ResEquipInfo, this.ResEquipInfo)
  this.messageContainer:Regist(EquipMessage.ResEquipSuperpose, this.ResEquipSuperpose)
  this.messageContainer:Regist(EquipMessage.ResEquipTransfer, this.ResEquipTransfer)
  this.messageContainer:Regist(EquipMessage.ResEquipLucky, this.ResEquipLuckyIntensify)
  this.messageContainer:Regist(FightMessage.ResPlayerUseSkill, this.ResPlayerUseSkill)
end

function MeEquipController.RegistEvents()
  this.eventContainer = EventContainer(EventManager)
  this.eventContainer:Regist(Event.Role_EquipAppearSave, this.OnRefreshRoleAppearData)
  this.eventContainer:Regist(Event.TakeOffEquip, this.OnTakeOffEquip)
end

function MeEquipController.SpecialRemove(msg)
  if msg.position == ERoleEquipPosition.pet then
    if msg.items == nil then
      if not msg.remove then
        return
      end
      local removeData = ViewData.meData.equipsData.Data[msg.position]
      local str = ""
      if removeData.equipTime <= 0 and removeData.equipTime ~= -9999 then
        str = LocalizationUtility.GetContentByKey("ItemTips_equipTimeDelete")
      end
      if 0 >= removeData.durability and removeData.equipTime ~= -9999 then
        str = LocalizationUtility.GetContentByKey("ItemTips_equipDurabilityDelete")
      end
      if not string.isNullOrEmpty(str) then
        str = string.format(str, removeData.tblItem.name)
        FloatingWordUtility.QuickMsg(str)
        BubbleData.AddBubble({
          id = removeData.id,
          itemId = removeData.itemId,
          uiName = UIID.PromptTipUI,
          type = BubbleTypeEnum.ItemOverdue,
          subType = BubbleArticlesType.Pet,
          args = {
            textContent = str,
            ok = function()
              UIManager.JumpShow(UIPanelType.SortAndHide, UIID.Shop)
            end
          }
        })
        EventManager.Dispatch(Event.Bubble_BubbleRefresh)
      end
    else
      BubbleData.RemoveBubbleByitemId(msg.items.itemId)
      EventManager.Dispatch(Event.Bubble_BubbleRefresh)
    end
  end
end

function MeEquipController.IsJumpAppearUI(bagGridIndex)
  if ClientTable.cfg_Global_globalManager:CheckHideAppearanceByCurMap() then
    return
  end
  if RoleEquipUtility.EquipTypeUtility(bagGridIndex, ERoleEquipCondition.timeEquip) or RoleEquipUtility.EquipTypeUtility(bagGridIndex, ERoleEquipCondition.Pet) then
    UIManager.JumpShow(UIPanelType.SortAndHide, UIID.AppearBagInfoUI, {togIndex = 1})
  elseif RoleEquipUtility.EquipTypeUtility(bagGridIndex, ERoleEquipCondition.Title) then
    UIManager.JumpShow(UIPanelType.SortAndHide, UIID.AppearBagInfoUI, {togIndex = 2})
  elseif RoleEquipUtility.EquipTypeUtility(bagGridIndex, ERoleEquipCondition.RingChange) then
    UIManager.JumpShow(UIPanelType.SortAndHide, UIID.AppearBagInfoUI, {togIndex = 3})
  end
end

function MeEquipController.OnResEquipChange(_, msg)
  AudioManager.PlayMusicClipById(3002)
  if msg.items == nil then
    if msg.position == ERoleEquipPosition.transcript_weapon then
      RoleManager.me.data.equipsData:RemoveEquip(msg.position)
      RoleManager.me:UnloadEquip(msg.position)
      EventManager.Dispatch(Event.TakeOffEquip, msg)
      return
    end
    if RoleEquipUtility.EquipTypeUtility(msg.position, ERoleEquipCondition.Equip) then
      this.SpecialRemove(msg)
      if not RedFortData.InRedFortActivity then
        if RoleEquipUtility.EquipTypeUtility(msg.position, ERoleEquipCondition.RingChange) then
          local equipData = ViewData.meData.equipsData:GetEquipByIndex(msg.position)
          local transformation = equipData.tblEquip.transformation
          if RoleManager.me.data.model == transformation then
            RoleManager.me:ChangeModel(ERoleModelName.default, PlayerModelDefaultScale)
          end
        end
        RoleManager.me.data.equipsData:RemoveEquip(msg.position)
      end
      EventManager.Dispatch(Event.TakeOffEquip, msg)
    elseif msg.position >= secendCellTypeTbl[1].index and msg.position <= secendCellTypeTbl[table.count(secendCellTypeTbl)].index then
      RoleManager.me.data.equipsData:RemoveStoneEquip(msg.position)
      EventManager.Dispatch(Event.TakeOffEquip, msg)
    elseif msg.position >= thirdCellTypeTbl[1].index and msg.position <= thirdCellTypeTbl[table.count(thirdCellTypeTbl)].index then
      local m_Data = ViewData.meData.mountData:DisboardData(msg.position)
      ViewData.meData:UpdateRideStatus(m_Data)
      RoleManager.me:RefreshMount()
      EventManager.Dispatch(Event.Mount_Change, msg)
    elseif msg.position >= FourCellTypeTbl[1].index and msg.position <= FourCellTypeTbl[table.count(FourCellTypeTbl)].index then
      RoleManager.me.data.equipsData:RemoveStoneEquip(msg.position)
      MeEquipController.CheckCloseVvip(msg)
    elseif msg.position >= fiveCellTypeTbl[1].index and msg.position <= fiveCellTypeTbl[table.count(fiveCellTypeTbl)].index then
      RoleManager.me.data.equipsData:RemoveEquip(msg.position)
      EventManager.Dispatch(Event.TakeOffEquip, msg)
    elseif msg.position >= sevenCellTypeTbl[1].index and msg.position <= sevenCellTypeTbl[table.count(sevenCellTypeTbl)].index then
      RoleManager.me.data.equipsData:RemoveStoneEquip(msg.position)
    elseif RoleEquipUtility.EquipTypeUtility(msg.position, ERoleEquipCondition.Title) then
      ViewData.meData.titleData:RemoveTitleData(msg.position, true)
      RoleManager.me.Head:RefreshData(RoleManager.me)
      EventManager.Dispatch(Event.Equip_ResTitle)
      EventManager.Dispatch(Event.TakeOffEquip, msg)
    elseif RoleEquipUtility.EquipTypeUtility(msg.position, ERoleEquipCondition.ShouHu) then
      RoleManager.me.data.equipsData:RemoveEquip(msg.position)
      EventManager.Dispatch(Event.TakeOffEquip, msg)
    elseif RoleEquipUtility.EquipTypeUtility(msg.position, ERoleEquipCondition.Shenghun) then
      RoleManager.me.data.equipsData:RemoveStoneEquip(msg.position)
      EventManager.Dispatch(Event.TakeOffEquip, msg)
    end
  else
    if msg.items.bagGridIndex == ERoleEquipPosition.transcript_weapon then
      local equipData = ViewData.meData.equipsData:UpdateData(msg.items)
      RoleManager.me:PutOnEquip(equipData.bagGridIndex, equipData.modelPath)
      EventManager.Dispatch(Event.PutOnEquip, equipData)
      return
    end
    if RoleEquipUtility.EquipTypeUtility(msg.items.bagGridIndex, ERoleEquipCondition.Equip) or RoleEquipUtility.EquipTypeUtility(msg.items.bagGridIndex, ERoleEquipCondition.Foot) or RoleEquipUtility.EquipTypeUtility(msg.items.bagGridIndex, ERoleEquipCondition.Couture) then
      this.SpecialRemove(msg)
      local equipData = ViewData.meData.equipsData:UpdateData(msg.items)
      ViewData.meData.equipsData:SetStoneLightData(msg.stoneLight)
      if this.OnPutOnEquipJudge(msg.items.bagGridIndex, equipData, msg.reason) then
        if not RedFortData.InRedFortActivity then
          RoleManager.me:PutOnEquip(equipData.bagGridIndex, equipData.modelPath)
        end
      elseif not RedFortData.InRedFortActivity then
        RoleManager.me.AvatarEquip:EquipSuitCheck()
      end
      EventManager.Dispatch(Event.PutOnEquip, equipData)
      EventManager.Dispatch(Event.Equip_ResRingChange)
      this.IsJumpAppearUI(msg.items.bagGridIndex)
    elseif msg.items.bagGridIndex >= secendCellTypeTbl[1].index and msg.items.bagGridIndex <= secendCellTypeTbl[table.count(secendCellTypeTbl)].index then
      local equipData = ViewData.meData.equipsData:UpdateStoneData(msg.items)
      ViewData.meData.equipsData:SetStoneLightData(msg.stoneLight)
      EventManager.Dispatch(Event.PutOnEquip, equipData)
    elseif msg.items.bagGridIndex >= thirdCellTypeTbl[1].index and msg.items.bagGridIndex <= thirdCellTypeTbl[table.count(thirdCellTypeTbl)].index then
      local tbl_item = ClientTable.cfg_Item_itemManager:TryGetValue(msg.items.itemId)
      if tbl_item ~= nil and tbl_item.type == 2 and tbl_item.subType == 22 then
        local m_Data = ViewData.meData.mountData:UpdateData(msg.items, tbl_item)
        ViewData.meData:UpdateRideStatus(m_Data)
        RoleManager.me:RefreshMount()
        this.TakeOffMount(msg)
        EventManager.Dispatch(Event.Mount_Change)
      end
    elseif msg.items.bagGridIndex >= FourCellTypeTbl[1].index and msg.items.bagGridIndex <= FourCellTypeTbl[table.count(FourCellTypeTbl)].index then
      local equipData = ViewData.meData.equipsData:UpdateStoneData(msg.items)
      ViewData.meData.equipsData:SetStoneLightData(msg.stoneLight)
      MeEquipController.CheckVvip(msg)
    elseif msg.items.bagGridIndex >= fiveCellTypeTbl[1].index and msg.items.bagGridIndex <= fiveCellTypeTbl[table.count(fiveCellTypeTbl)].index then
      local equipData = ViewData.meData.equipsData:UpdateData(msg.items)
      EventManager.Dispatch(Event.PutOnEquip, equipData)
    elseif msg.items.bagGridIndex >= sevenCellTypeTbl[1].index and msg.items.bagGridIndex <= sevenCellTypeTbl[table.count(sevenCellTypeTbl)].index then
      local equipData = ViewData.meData.equipsData:UpdateStoneData(msg.items)
    elseif RoleEquipUtility.EquipTypeUtility(msg.items.bagGridIndex, ERoleEquipCondition.Title) then
      if msg.items.valid then
        ViewData.meData.titleData:UpdateTitleData(msg.items, true)
        RoleManager.me.Head:RefreshData(RoleManager.me)
      else
        local isHave = ViewData.meData.titleData:IsHaveTitleData(msg.items)
        if isHave then
          ViewData.meData.titleData:UpdateTitleData(msg.items, false)
          RoleManager.me.Head:RefreshData(RoleManager.me)
        else
          local equipData = ViewData.meData.titleData:AddTitleData(msg.items)
          MeEquipController.PromptShowTitle(equipData.tblItem.name, equipData.bagGridIndex)
          EventManager.Dispatch(Event.PutOnEquip, equipData)
        end
      end
      EventManager.Dispatch(Event.Equip_ResTitle)
    elseif msg.items.bagGridIndex == ERoleEquipPosition.autoPickIndex then
      local equipsData = ViewData.meData.equipsData:UpdateData(msg.items)
    elseif RoleEquipUtility.EquipTypeUtility(msg.items.bagGridIndex, ERoleEquipCondition.ShouHu) then
      local equipData = ViewData.meData.equipsData:UpdateData(msg.items)
      EventManager.Dispatch(Event.PutOnEquip, equipData)
    elseif RoleEquipUtility.EquipTypeUtility(msg.items.bagGridIndex, ERoleEquipCondition.Shenghun) then
      local equipData = ViewData.meData.equipsData:UpdateStoneData(msg.items)
      EventManager.Dispatch(Event.PutOnEquip, equipData)
    end
  end
  if msg.position == ERoleEquipPosition.pet then
    local data = {
      isShow = msg.items ~= nil
    }
  end
  EventManager.Dispatch(Event.EquipAttriUpdate)
  EventManager.Dispatch(Event.Equip_ResEquipChange)
  EventManager.Dispatch(Event.RP_RedPointRefresh, {
    index = ERedPointType.btnFunc,
    state = true
  })
end

function MeEquipController.TakeOffMount(msg)
  if RoleManager.me.data.rideMount and RoleManager.me.data.rideMount.id ~= MountData.DefaultMount then
    NetManager.Send(EquipMessage.ReqEquipDefaultHorse, {
      equipId = msg.items.id
    })
  end
end

function MeEquipController.PromptShowTitle(name, bagGridIndex)
  local function PromptOK()
    NetManager.Send(EquipMessage.ReqChangeTitleState, {
      rid = RoleManager.me.id,
      
      position = bagGridIndex,
      wear = true
    })
    
    local function JumpAppear()
      this.IsJumpAppearUI(bagGridIndex)
    end
    
    Timer.StartLoop(0.5, 1, JumpAppear)
  end
  
  local title = {
    title = string.GetColorText("Nh\225\186\175c nh\225\187\159", "#FFFFFFFF"),
    textContent = string.GetColorText("Hi\225\187\131n th\225\187\139 ngay: " .. name, "#FFFFFFFF"),
    cancelText = "",
    okText = "",
    cancel = nil,
    ok = PromptOK,
    okArgs = nil
  }
  if UIManager.IsVisible(UIID.PromptTipUI) then
    EventManager.Dispatch(Event.PromptOnRefresh, title)
  else
    UIManager.Show(UIID.PromptTipUI, title)
  end
end

function MeEquipController.CheckVvip(msg)
  EventManager.Dispatch(Event.Buff_RoleMonthCardBuff)
  PlayerControlForceData.VvipinfoOpen(msg.items.itemId)
end

function MeEquipController.CheckCloseVvip(msg)
  EventManager.Dispatch(Event.Buff_RoleMonthCardBuff)
  PlayerControlForceData.VvipinfoChangeDrug()
end

function MeEquipController.GetEquipCellByCellIndex(cellIndex)
  local EquipCell_cell = ClientTable.cfg_EquipCell_cellManager:GetDic()
  local normalTbl = {}
  for k, v in pairs(EquipCell_cell) do
    if v.cellType == cellIndex then
      table.insert(normalTbl, v)
    end
  end
  table.sort(normalTbl, MeEquipController.SortEquipCell)
  return normalTbl
end

function MeEquipController.SortEquipCell(a, b)
  return a.index < b.index
end

function MeEquipController.ResEquipIntensify(_, msg)
  local equipData
  if msg.inBag then
    equipData = BagInfoData.UpdateEquipAttri(msg.items)
  else
    equipData = RoleManager.me.data.equipsData:UpdateData(msg.items)
    RoleManager.me.AvatarEquip:EquipSuitCheck()
    RoleManager.me.AvatarEquip:IntensifyChangeSetTentacle(msg.items)
  end
  if msg.success then
    AudioManager.PlayMusicClipById(3004)
    if UIManager.IsVisible(UIID.EffectTipUI) then
      EventManager.Dispatch(Event.TipEffect, {
        name = "Eff_UI_qianghuachenggong",
        time = 1
      })
    else
      UIManager.Show(UIID.EffectTipUI, {
        name = "Eff_UI_qianghuachenggong",
        effectTime = 1
      })
    end
    EventManager.Dispatch(Event.Equip_IntensifyEffect, equipData)
  else
    AudioManager.PlayMusicClipById(3005)
    if UIManager.IsVisible(UIID.EffectTipUI) then
      EventManager.Dispatch(Event.TipEffect, {
        name = "Eff_UI_qianghuashibai",
        time = 1
      })
    else
      UIManager.Show(UIID.EffectTipUI, {
        name = "Eff_UI_qianghuashibai",
        effectTime = 1
      })
    end
    EventManager.Dispatch(Event.Equip_IntensifyEffect, equipData)
  end
  EventManager.Dispatch(Event.EquipAttriUpdate, equipData)
end

function MeEquipController.ResEquipAdditional(_, msg)
  if msg.success then
    AudioManager.PlayMusicClipById(3004)
    if UIManager.IsVisible(UIID.EffectTipUI) then
      EventManager.Dispatch(Event.TipEffect, {
        name = "Eff_UI_zhuijiachenghong",
        time = 1
      })
    else
      UIManager.Show(UIID.EffectTipUI, {
        name = "Eff_UI_zhuijiachenghong",
        effectTime = 1
      })
    end
  else
    AudioManager.PlayMusicClipById(3005)
    if UIManager.IsVisible(UIID.EffectTipUI) then
      EventManager.Dispatch(Event.TipEffect, {
        name = "Eff_UI_zhuijiashibai",
        time = 1
      })
    else
      UIManager.Show(UIID.EffectTipUI, {
        name = "Eff_UI_zhuijiashibai",
        effectTime = 1
      })
    end
  end
  local equipData
  if msg.inBag then
    equipData = BagInfoData.UpdateEquipAttri(msg.items)
    EventManager.Dispatch(Event.Bag_ResBagChange)
  else
    equipData = RoleManager.me.data.equipsData:UpdateData(msg.items)
  end
  EventManager.Dispatch(Event.EquipAddSucceed, equipData)
  EventManager.Dispatch(Event.EquipAttriUpdate, equipData)
end

function MeEquipController.ResEquipInfo(_, msg)
  local equipData
  equipData = RoleManager.me.data.equipsData:UpdateData(msg)
  equipData = equipData or BagInfoData.UpdateEquipAttri(msg)
  EventManager.Dispatch(Event.EquipAttriUpdate, equipData)
end

function MeEquipController.ResEquipSuperpose(_, msg)
  local equipData
  if msg.inBag then
    equipData = BagInfoData.UpdateEquipAttri(msg.items)
  else
    equipData = RoleManager.me.data.equipsData:UpdateData(msg.items)
    EventManager.Dispatch(Event.EquipAttriUpdate)
  end
  EventManager.Dispatch(Event.EquipAttriUpdate, equipData)
  EventManager.Dispatch(Event.Equip_OverlapSucceed, {
    equipData = equipData,
    success = msg.success
  })
end

function MeEquipController.ResEquipTransfer(_, msg)
  local equipData
  for i = 1, table.count(msg.items) do
    if msg.inBag[i] then
      equipData = BagInfoData.UpdateEquipAttri(msg.items[i])
    else
      equipData = RoleManager.me.data.equipsData:UpdateData(msg.items[i])
    end
    EventManager.Dispatch(Event.EquipAttriUpdate, equipData)
  end
  EventManager.Dispatch(Event.Equip_TransferSucceed, equipData)
end

function MeEquipController.ResEquipLuckyIntensify(_, msg)
  if msg.success then
    if UIManager.IsVisible(UIID.EffectTipUI) then
      EventManager.Dispatch(Event.TipEffect, {
        name = "Eff_UI_xingyunchenggong",
        time = 1
      })
    else
      UIManager.Show(UIID.EffectTipUI, {
        name = "Eff_UI_xingyunchenggong",
        effectTime = 1
      })
    end
  end
  local equipData
  if msg.inBag then
    equipData = BagInfoData.UpdateEquipAttri(msg.items)
  else
    equipData = RoleManager.me.data.equipsData:UpdateData(msg.items)
  end
  EventManager.Dispatch(Event.EquipAttriUpdate, equipData)
end

function MeEquipController.ResPlayerUseSkill(_, msg)
  if msg.attackerId == ViewData.meData.id then
    local equipData = ViewData.meData.equipsData:GetEquipByIndex(ERoleEquipPosition.pet)
    if equipData then
      local as = ViewData.meData:GetAttribute(EAttributeType.attackSpeedCalculateValue)
      local reduce = 100 / as * ViewData.meData.careerConsumeRatio
      equipData:CalcEquipDurability(reduce)
    end
  end
end

function MeEquipController.OnEnterScene(_, mapid)
  this.RefreshMoveSpeed(Scene.IsWaterMap(mapid))
end

function MeEquipController.OnTakeOffEquip(_, msg)
  if msg == nil then
    return
  end
  local isAppear = RoleEquipUtility.IsEquipAppearData(msg.position)
  if isAppear then
    local isHave = false
    local tempTab = json.decode(ForgeData.appearData[RoleManager.me.id])
    for i, v in pairs(tempTab) do
      if v == msg.position then
        isHave = true
        break
      end
    end
    if isHave then
      RoleManager.me:UnloadEquip(msg.position)
      RoleEquipUtility.UpdateAppearSaveData(msg.position, true, msg.reason)
      local equipData = RoleEquipUtility.GetConditionEquipData(RoleManager.me.data.equipsData.Data, ERoleEquipCondition.Equip)
      local tempPos = msg.position % 100
      local isPutOnEquip = false
      for i, v in pairs(equipData) do
        if i % 100 == tempPos and i ~= msg.position then
          if msg.reason == 2 then
            local RoleEquipNormalPosDic = gameMgr:GetAvatarManager():GetMainPlayer():GetAppear_CoutureManager().RoleEquipNormalPosDic
            if RoleEquipNormalPosDic ~= nil and RoleEquipNormalPosDic[i] ~= nil then
              RoleEquipUtility.UpdateAppearSaveData(i, false, msg.reason)
              RoleManager.me:PutOnEquip(i, v.modelPath)
              break
            end
          elseif tempPos == ERoleEquipPosition.left_weapon then
            isPutOnEquip = true
            if equipData[msg.position - 1] then
              local subType = equipData[msg.position - 1].tblItem.subType
              if RoleEquipUtility.WearWeaponsCondition(v.tblItem.subType, equipData[msg.position - 1].tblItem.subType) then
                RoleEquipUtility.UpdateAppearSaveData(i, false, msg.reason)
                RoleManager.me:PutOnEquip(i, v.modelPath)
                if equipData[i - 1] and MeEquipController.IsCoutureSubtype(subType) == false then
                  RoleEquipUtility.UpdateAppearSaveData(i - 1, false, msg.reason)
                  RoleManager.me:PutOnEquip(i - 1, equipData[i - 1].modelPath)
                end
              end
              break
            else
              RoleEquipUtility.UpdateAppearSaveData(i, false)
              RoleManager.me:PutOnEquip(i, v.modelPath)
              if equipData[i - 1] then
                RoleEquipUtility.UpdateAppearSaveData(i - 1, false)
                RoleManager.me:PutOnEquip(i - 1, equipData[i - 1].modelPath)
              end
              break
            end
          elseif tempPos == ERoleEquipPosition.right_weapon then
            if equipData[msg.position + 1] then
              local subType = equipData[msg.position + 1].tblItem.subType
              if RoleEquipUtility.WearWeaponsCondition(v.tblItem.subType, subType) then
                RoleEquipUtility.UpdateAppearSaveData(i, false, msg.reason)
                RoleManager.me:PutOnEquip(i, v.modelPath)
                if equipData[i + 1] and MeEquipController.IsCoutureSubtype(subType) == false then
                  RoleEquipUtility.UpdateAppearSaveData(i + 1, false, msg.reason)
                  RoleManager.me:PutOnEquip(i + 1, equipData[i + 1].modelPath)
                end
              end
              break
            else
              RoleEquipUtility.UpdateAppearSaveData(i, false)
              RoleManager.me:PutOnEquip(i, v.modelPath)
              if equipData[i + 1] then
                RoleEquipUtility.UpdateAppearSaveData(i + 1, false)
                RoleManager.me:PutOnEquip(i + 1, equipData[i + 1].modelPath)
              end
              break
            end
          else
            RoleEquipUtility.UpdateAppearSaveData(i, false, msg.reason)
            RoleManager.me:PutOnEquip(i, v.modelPath)
            break
          end
        end
      end
    end
  else
    RoleManager.me:UnloadEquip(msg.position)
  end
end

function MeEquipController.OnPutOnEquipJudge(position, equipData, reason)
  if RoleEquipUtility.IsEquipAppearData(position) then
    local indexTab = RoleEquipUtility.DefaultShowAppearEquip(RoleManager.me.id, RoleManager.me.data.equipsData.Data)
    local equipData = RoleEquipUtility.GetConditionEquipData(RoleManager.me.data.equipsData.Data, ERoleEquipCondition.Equip)
    local tempPos = position % 100
    if tempPos == ERoleEquipPosition.right_weapon then
      for _, i in pairs(indexTab) do
        local temp1 = i % 100 == tempPos and position < i
        local temp2 = i % 100 == tempPos + 1 and not RoleEquipUtility.WearWeaponsCondition(equipData[i].tblItem.subType, equipData[position].tblItem.subType)
        if temp1 or temp2 then
          return false
        end
      end
    elseif tempPos == ERoleEquipPosition.left_weapon then
      for _, i in pairs(indexTab) do
        local temp1 = i % 100 == tempPos and position < i
        local temp2 = i % 100 == tempPos - 1 and not RoleEquipUtility.WearWeaponsCondition(equipData[i].tblItem.subType, equipData[position].tblItem.subType)
        if temp1 or temp2 then
          return false
        end
      end
    else
      for _, i in pairs(indexTab) do
        local temp1 = i % 100 == tempPos and position < i
        if temp1 then
          return false
        end
      end
    end
    if reason == nil or reason == 0 or reason == 2 then
      RoleEquipUtility.UpdateAppearSaveData(position, false, reason)
    else
      return false
    end
    return true
  end
  return true
end

function MeEquipController.OnRefreshRoleAppearData(_, msg)
  if table.count(msg.roleList) > 0 then
    for _, roleInfo in pairs(msg.roleList) do
      if string.isNullOrEmpty(roleInfo.info.appear) then
        ForgeData.appearData[roleInfo.info.roleId] = "{}"
      else
        ForgeData.appearData[roleInfo.info.roleId] = roleInfo.info.appear
      end
    end
  end
  if 0 < table.count(msg.deleteRoleList) then
    for _, roleInfo in pairs(msg.deleteRoleList) do
      if string.isNullOrEmpty(roleInfo.info.appear) then
        ForgeData.appearData[roleInfo.info.roleId] = "{}"
      else
        ForgeData.appearData[roleInfo.info.roleId] = roleInfo.info.appear
      end
    end
  end
end

function MeEquipController.RefreshMoveSpeed(isInWaterMap)
  local bootEquip = RoleManager.me.data.equipsData:GetEquipByIndex(ERoleEquipPosition.boot)
  local gloveEquip = RoleManager.me.data.equipsData:GetEquipByIndex(ERoleEquipPosition.glove)
  local wingEquip = RoleManager.me.data.equipsData:GetEquipByIndex(ERoleEquipPosition.wing)
  if bootEquip then
    bootEquip:ValidateAttribute(EAttributeType.staticMoveSpeed, not isInWaterMap)
    bootEquip:ValidateAttribute(EAttributeType.moveSpeed, not isInWaterMap)
  end
  if gloveEquip then
    gloveEquip:ValidateAttribute(EAttributeType.staticMoveSpeed, isInWaterMap)
    gloveEquip:ValidateAttribute(EAttributeType.moveSpeed, isInWaterMap)
  end
  if wingEquip then
    wingEquip:ValidateAttribute(EAttributeType.staticMoveSpeed, isInWaterMap)
    wingEquip:ValidateAttribute(EAttributeType.moveSpeed, isInWaterMap)
  end
  EventManager.Dispatch(Event.EquipAttriUpdate)
end

function MeEquipController.SetEquipIntensifyConfigData()
  this.EquipIntensifyConfigTable = {}
  local cfg_table = ClientTable.cfg_Item_equip_intensifyManager:GetDic()
  for k, v in pairs(cfg_table) do
    if not this.EquipIntensifyConfigTable[v.type] then
      this.EquipIntensifyConfigTable[v.type] = {}
    end
    table.insert(this.EquipIntensifyConfigTable[v.type], v)
  end
  this.EquipZhuijiaConfigTable = {}
  local cfg_tablezhuijia = ClientTable.cfg_Item_equip_zhuijiaManager:GetDic()
  for k, v in pairs(cfg_tablezhuijia) do
    if not this.EquipZhuijiaConfigTable[v.type] then
      this.EquipZhuijiaConfigTable[v.type] = {}
    end
    table.insert(this.EquipZhuijiaConfigTable[v.type], v)
  end
  this.Equip_RegenerateEvolution = {}
  local cfg_regenerateEvolution = ClientTable.cfg_Item_equip_regenerateEvolutionManager:GetDic()
  for k, v in pairs(cfg_regenerateEvolution) do
    if not this.Equip_RegenerateEvolution[v.type] then
      this.Equip_RegenerateEvolution[v.type] = {}
    end
    table.insert(this.Equip_RegenerateEvolution[v.type], v)
  end
  this.EquipGrowUpConfigTable = {}
  local cfg_tableGrowUp = ClientTable.cfg_Item_equip_growUpManager:GetDic()
  for k, v in pairs(cfg_tableGrowUp) do
    if not this.EquipGrowUpConfigTable[v.type] then
      this.EquipGrowUpConfigTable[v.type] = {}
    end
    table.insert(this.EquipGrowUpConfigTable[v.type], v)
  end
  this.EquipBreachConfigTable = {}
  local cfg_tableBreach = ClientTable.cfg_Item_equip_breachManager:GetDic()
  for k, v in pairs(cfg_tableBreach) do
    if not this.EquipBreachConfigTable[v.type] then
      this.EquipBreachConfigTable[v.type] = {}
    end
    table.insert(this.EquipBreachConfigTable[v.type], v)
  end
  this.EquipLuckyConfigTable = {}
  local cfg_tableLucky = ClientTable.cfg_Item_equip_luckyManager:GetDic()
  for k, v in pairs(cfg_tableLucky) do
    if not this.EquipLuckyConfigTable[v.type] then
      this.EquipLuckyConfigTable[v.type] = {}
    end
    table.insert(this.EquipLuckyConfigTable[v.type], v)
  end
  this.EquipOverlapCostConfigTable = {}
  local cfg_table = ClientTable.cfg_Item_equip_overlapManager:GetDic()
  for k, v in pairs(cfg_table) do
    if not this.EquipOverlapCostConfigTable[v.type] then
      this.EquipOverlapCostConfigTable[v.type] = {}
    end
    table.insert(this.EquipOverlapCostConfigTable[v.type], v)
  end
  this.EquipOverlapReplaceConfigTable = {}
  local cfg_table = ClientTable.cfg_Item_equip_overlapReplaceManager:GetDic()
  for k, v in pairs(cfg_table) do
    if not this.EquipOverlapReplaceConfigTable[v.type] then
      this.EquipOverlapReplaceConfigTable[v.type] = {}
    end
    table.insert(this.EquipOverlapReplaceConfigTable[v.type], v)
  end
end

function MeEquipController.SetSuitConfigData()
  this.SuitConfigTable = {}
  local suitcfg = ClientTable.cfg_Item_equip_suitManager:GetDic()
  for _, v in pairs(suitcfg) do
    if not this.SuitConfigTable[v.suitId] then
      this.SuitConfigTable[v.suitId] = {}
    end
    if not this.SuitConfigTable[v.suitId][v.level] then
      this.SuitConfigTable[v.suitId][v.level] = {}
    end
    table.insert(this.SuitConfigTable[v.suitId][v.level], v)
  end
end

function MeEquipController.SetSuitEquipInfoData()
  this.SuitEquipInfoTable = {}
  local euipeCfg = ClientTable.cfg_Item_equipManager:GetDic()
  for _, v in pairs(euipeCfg) do
    if not string.isNullOrEmpty(v.suitId) then
      local suitInfos = string.split(v.suitId, "#")
      local suitId = tonumber(suitInfos[1])
      local suitLevel = tonumber(suitInfos[2])
      if not this.SuitEquipInfoTable[suitId] then
        this.SuitEquipInfoTable[suitId] = {}
      end
      if not this.SuitEquipInfoTable[suitId][suitLevel] then
        this.SuitEquipInfoTable[suitId][suitLevel] = {}
      end
      table.insert(this.SuitEquipInfoTable[suitId][suitLevel], v)
    end
  end
end

function MeEquipController.SetStoneLightConfigData()
  this.StoneLightConfigTable = {}
  local stoneLight = ClientTable.cfg_Item_stone_lightManager:GetDic()
  for k, v in pairs(stoneLight) do
    if not this.StoneLightConfigTable[v.type] then
      this.StoneLightConfigTable[v.type] = {}
    end
    table.insert(this.StoneLightConfigTable[v.type], v)
  end
end

function MeEquipController.GetEquipIntensifyAndAddMaxLevel(ItemInfo)
  local intensifyMaxLevel, addMaxLevel = 0, 0
  local intensifyTable = this.EquipIntensifyConfigTable[ItemInfo.tblItem.id]
  intensifyTable = intensifyTable or this.EquipIntensifyConfigTable[ItemInfo.tblItem.subType]
  for i = 1, table.count(intensifyTable) do
    if intensifyMaxLevel < intensifyTable[i].level then
      local condition = intensifyTable[i].condition
      if condition == nil then
        intensifyMaxLevel = intensifyTable[i].level
      else
        local flag = false
        if condition[1] == 1009 then
          flag = ItemInfo.tblEquip.equipClass >= condition[2]
        elseif condition[1] == 3200 then
          flag = ItemInfo.tblItem.quality > condition[2]
        else
          flag = ConditionManager.GenerateSingleCondition(condition):Check()
        end
        if flag then
          intensifyMaxLevel = intensifyTable[i].level
        else
          intensifyMaxLevel = intensifyTable[i].level
          break
        end
      end
    end
  end
  local addTable = this.EquipZhuijiaConfigTable[ItemInfo.tblItem.id]
  addTable = addTable or this.EquipZhuijiaConfigTable[ItemInfo.tblItem.subType]
  for i = 1, table.count(addTable) do
    if addMaxLevel < addTable[i].level then
      local condition = addTable[i].condition
      if condition == nil then
        addMaxLevel = addTable[i].level
      else
        local flag = false
        if condition[1] == 1009 then
          flag = ItemInfo.tblEquip.equipClass >= condition[2]
        elseif condition[1] == 3200 then
          flag = ItemInfo.tblItem.quality > condition[2]
        else
          flag = ConditionManager.GenerateSingleCondition(condition):Check()
        end
        if flag then
          addMaxLevel = addTable[i].level
        else
          addMaxLevel = addTable[i].level
          break
        end
      end
    end
  end
  return intensifyMaxLevel, addMaxLevel
end

function MeEquipController.GetEquipIntensifyCfg(subtype, level)
  local normalTable = this.EquipIntensifyConfigTable[subtype]
  if normalTable then
    for k, v in pairs(normalTable) do
      if level == v.level then
        return v
      end
    end
  end
end

function MeEquipController.GetEquipAddtion(subtype, level)
  local normalTable = this.EquipZhuijiaConfigTable[subtype]
  if normalTable then
    for k, v in pairs(normalTable) do
      if level == v.level then
        return v
      end
    end
  end
  return nil
end

function MeEquipController.GetEquipregenerate(subtype, level)
  local normalTable = this.Equip_RegenerateEvolution[subtype]
  if normalTable then
    for k, v in pairs(normalTable) do
      if level == v.level then
        return v
      end
    end
  end
  return nil
end

function MeEquipController.GetEquipGrowUpCfg(subtype, level)
  local normalTable = this.EquipGrowUpConfigTable[tostring(subtype)]
  if normalTable then
    for k, v in pairs(normalTable) do
      if subtype == tonumber(v.type) and level == v.level then
        if RoleManager.me then
          if string.contains(v.career, RoleUtility.GetBasicCareer(RoleManager.me.career)) then
            return v
          end
        else
          return v
        end
      end
    end
  end
  return nil
end

function MeEquipController.GetEquipBreachCfg(subtype, level)
  local normalTable = this.EquipBreachConfigTable[subtype]
  if normalTable then
    for k, v in pairs(normalTable) do
      if subtype == tonumber(v.type) and level == v.level then
        return v
      end
    end
  end
  return nil
end

function MeEquipController.GetEquipLuckyCfg(id, level)
  local normalTable = this.EquipLuckyConfigTable[id]
  if normalTable then
    for k, v in pairs(normalTable) do
      if id == tonumber(v.type) and level == v.level then
        return v
      end
    end
  end
  return nil
end

function MeEquipController.GetEquipOverlapCostCfg(ItemInfo)
  local itemId, type = ItemInfo.itemId, ItemInfo.tblEquip.equipClass
  local count = ItemInfo:GetExcellenceCount()
  local normalTable = this.EquipOverlapCostConfigTable[itemId]
  normalTable = normalTable or this.EquipOverlapCostConfigTable[type]
  if normalTable then
    for k, v in pairs(normalTable) do
      if count == v.excellenceNum then
        return v
      end
    end
  end
  return nil
end

function MeEquipController.GetEquipOverlapReplaceCostCfg(ItemInfo, lockCount)
  local itemId, type = ItemInfo.itemId, ItemInfo.tblEquip.equipClass
  local normalTable = this.EquipOverlapReplaceConfigTable[itemId]
  normalTable = normalTable or this.EquipOverlapReplaceConfigTable[type]
  if normalTable then
    for k, v in pairs(normalTable) do
      if lockCount == v.excellenceNum then
        return v
      end
    end
  end
  return nil
end

function MeEquipController.GetSuitCfg(suitid, level)
  level = level or 1
  local normalTable = this.SuitConfigTable[suitid][level]
  if normalTable then
    return normalTable
  end
end

function MeEquipController.GetSuitInfoCfg(suitid, level)
  level = level or 1
  local normalTable = this.SuitEquipInfoTable[suitid][level]
  if normalTable then
    table.sort(normalTable, function(a, b)
      return a.subType < b.subType
    end)
    return normalTable
  end
end

function MeEquipController.GetEquipIntensifyCfgByEquipData(equipeData)
  local normalTable
  local level = equipeData.intensify or 0
  normalTable = this.EquipIntensifyConfigTable[equipeData.tblItem.id]
  normalTable = normalTable or this.EquipIntensifyConfigTable[equipeData.tblItem.subType]
  if normalTable then
    for _, v in pairs(normalTable) do
      if level == v.level then
        return v
      end
    end
  end
end

function MeEquipController.GetEquipAdditionalCfgByEquipData(equipeData)
  local normalTable
  local level = equipeData.additional or 0
  normalTable = this.EquipZhuijiaConfigTable[equipeData.tblItem.subType]
  if normalTable then
    for _, v in pairs(normalTable) do
      if level == v.level then
        return v
      end
    end
  end
end

function MeEquipController.GetEquipregenerateEvolution(equipeData)
  local normalTable
  local level = equipeData.additional or 0
  normalTable = this.Equip_RegenerateEvolution[equipeData.tblItem.subType]
  if normalTable then
    for _, v in pairs(normalTable) do
      if level == v.level then
        return v
      end
    end
  end
end

function MeEquipController.GetStoneLightConfigDataBySubAndPosition(type, itemId)
  local tt = this.StoneLightConfigTable[type]
  local normalTbl = {}
  if not tt then
    return normalTbl
  end
  for k, v in pairs(tt) do
    if v.itemID == itemId and string.contains(v.career, RoleUtility.GetBasicCareer(RoleManager.me.career)) then
      table.insert(normalTbl, v)
    end
  end
  return normalTbl
end

function MeEquipController.GetOrnamentsAllBreach(subtype)
  local normalTable = ClientTable.cfg_Item_equip_breachManager:GetDic()
  local AllBreach = {}
  for k, v in pairs(normalTable) do
    if subtype == tonumber(v.type) and v.level ~= 0 then
      table.insert(AllBreach, v)
    end
  end
  return AllBreach
end

function MeEquipController.ReqTakeOffTheEquip(canPosition, isPutOn)
  NetManager.Send(EquipMessage.ReqTakeOffTheEquip, {position = canPosition})
end

local function GetEquipCarrySkill(equipId)
  local currentEquip = RoleManager.me.data.equipsData.Data
  for k, v in pairs(currentEquip) do
    if v.tblItem.id == equipId then
      return false
    end
  end
  local skilltbl = ClientTable.cfg_Item_equipManager:TryGetValue(equipId)
  skilltbl = ClientTable.cfg_Skill_skillManager:TryGetValue(skilltbl.carryingSkills)
  if skilltbl then
    return string.format("Nh\225\186\173n \196\145\198\176\225\187\163c k\225\187\185 n\196\131ng %s", skilltbl.name)
  end
end

function MeEquipController.IsCanTransfer(old, new, position)
  if position then
  end
  if old and new then
    if old.tblItem.subType == EItemSubtype.Guards or old.tblItem.subType == EItemSubtype.Earrings or old.tblItem.subType == EItemSubtype.Ring or old.tblItem.subType == EItemSubtype.Necklace then
      return false
    end
    if FucShowOrHideController.IsFuncButtonShow("Equip_ForgeNavUi#tog_zhuanyi") and (new.intensify < old.intensify and new.intensify == 0 or new.additional < old.additional and new.additional == 0) then
      return true
    end
  end
  return false
end

function MeEquipController.ReqPutOnTheEquip(canPosition, ItemInfo)
  local equipData = RoleManager.me.data.equipsData.Data
  if MeEquipController.IsCanTransfer(equipData[canPosition], ItemInfo, canPosition) then
    ForgeData.EquipTransferMain = table.clone(equipData[canPosition])
    ForgeData.EquipTransferSecond = table.clone(ItemInfo)
    UIManager.Show(UIID.Equip_ZhuanyiFastUI, {
      oldItem = equipData[canPosition],
      newItem = ItemInfo,
      position = canPosition,
      equipId = ItemInfo.id
    })
  else
    NetManager.Send(EquipMessage.ReqPutOnTheEquip, {
      position = canPosition,
      equipId = ItemInfo.id
    })
  end
  local lastrideMount
  if table.contains(Mount, canPosition) then
    if RoleManager.me.data.rideMount then
      if RoleManager.me.data.rideMount.bagGridIndex == canPosition then
        NetManager.Send(EquipMessage.ReqEquipDefaultHorse, {equipId = 0})
      end
    elseif MountData.DefaultMount == 0 then
      NetManager.Send(EquipMessage.ReqEquipDefaultHorse, {
        equipId = ItemInfo.id
      })
    end
    lastrideMount = table.DeepCopy(RoleManager.me.data.rideMount)
  end
  if table.contains(Mount, canPosition) then
    if lastrideMount then
      if lastrideMount.bagGridIndex == canPosition then
        NetManager.Send(EquipMessage.ReqChangeHorseState, {position = canPosition, ride = true})
      end
    else
      NetManager.Send(EquipMessage.ReqChangeHorseState, {position = canPosition, ride = true})
    end
  end
  local skillStr = GetEquipCarrySkill(ItemInfo.itemId)
  if skillStr and ItemInfo.skill then
    EventManager.Dispatch(Event.Tip_AddLeftMiddleFloatTip, {skillStr})
  end
end

function MeEquipController.ReqEquipIntensify(equipId)
  NetManager.Send(EquipMessage.ReqEquipIntensify, {equipId = equipId})
end

function MeEquipController.ReqEquipAdditional(equipId)
  NetManager.Send(EquipMessage.ReqEquipAdditional, {equipId = equipId})
end

function MeEquipController.ReqEquipLuckyIntensify(equipId)
  NetManager.Send(EquipMessage.ReqEquipLucky, {equipId = equipId})
end

function MeEquipController.ReqEquipGrowUp(equipId)
  NetManager.Send(EquipMessage.ReqEquipGrowUp, {equipId = equipId})
end

function MeEquipController.ReqEquipBreach(equipId)
  NetManager.Send(EquipMessage.ReqEquipBreach, {equipId = equipId})
end

function MeEquipController.ReqSaveAppear(appear)
  NetManager.Send(RoleMessage.ReqSaveAppear, {appear = appear})
end

function MeEquipController.IsCoutureSubtype(subType)
  return subType == EItemSubtype.Couture_OneHandedStick or subType == EItemSubtype.Couture_left or subType == EItemSubtype.Couture_right or subType == EItemSubtype.Couture_CrossBow or subType == EItemSubtype.Couture_BowBag
end
