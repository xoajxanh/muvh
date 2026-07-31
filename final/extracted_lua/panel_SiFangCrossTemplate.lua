local panel_SiFangCrossTemplate = {}

function panel_SiFangCrossTemplate:Init(rootPanel)
  self.rootPanel = rootPanel
  self:InitControls()
  self:InitUI()
  self:BindUIEvents()
end

function panel_SiFangCrossTemplate:InitControls()
  self.go_main = self:GetControl("go_main")
  self.panel_detail = self:GetControl("panel_detail")
  self.btn_detailClose = self:GetControl("panel_detail/btn_close")
  self.panel_union_list = self:GetControl("panel_union_list")
  self.btn_unionListClose = self:GetControl("panel_union_list/img_bg/btn_close")
  self.btn_goForm = self:GetControl("go_main/img_Bg/btn_goForm")
  self.btn_goReward = self:GetControl("go_main/img_Bg/btn_goReward")
  self.btn_detail = self:GetControl("go_main/img_Bg/btn_detail")
  self.Union_Camp = self:GetControl("go_main/img_Bg/sw_leaderList/Viewport/Content/Union_Camp")
  self.JuItem_1 = self:GetControl("panel_union_list/sw_joinUnion1/Viewport/Content/JuItem")
  self.JuItem_2 = self:GetControl("panel_union_list/sw_joinUnion2/Viewport/Content/JuItem")
  self.JuItem_3 = self:GetControl("panel_union_list/sw_joinUnion3/Viewport/Content/JuItem")
  self.JuItem_4 = self:GetControl("panel_union_list/sw_joinUnion4/Viewport/Content/JuItem")
  self.lab_entryTime = self:GetControl("go_main/img_Bg/lab_show_SiFang/lab_Time/lab_entryTime")
  self.btn_signUp = self:GetControl("go_main/img_Bg/btn_signUp")
  self.lab_SiFangPrompt = self:GetControl("go_main/img_Bg/lab_SiFangPrompt")
  self.unionLeaderRewardItem = self:GetControl("panel_detail/panel_UnionReward/Viewport/Content/Reward_WinReward/OneReward/sw_failedMemberReward/Viewport/Content/btn_failBoy")
  self.unionPersonRewardItem = self:GetControl("panel_detail/panel_UnionReward/Viewport/Content/Reward_WinReward/TwoReward/sw_failedMemberReward/Viewport/Content/btn_failBoy")
  self.killResurrectedPersonRewardItem = self:GetControl("panel_detail/panel_UnionReward/Viewport/Content/OtherReward/MemberReward/MemberReward/Viewport/Content/btn_failBoy")
  self.failRewardItem = self:GetControl("panel_detail/panel_UnionReward/Viewport/Content/Reward_LoseReward/Viewport/Content/itemRank")
  self.personalPointsRankItem = self:GetControl("panel_detail/panel_personReward/sw/Viewport/Content/itemRank")
  self.btn_compose = self:GetControl("go_main/img_Bg/btn_compose")
  self.this = self:GetControl()
end

local function OnCreateUnionItem(ctr)
  ctr.downBg = UIControl(ctr.transform, "downBg")
  ctr.win_team = UIControl(ctr.transform, "win_team")
  ctr.lab_Vacancy = UIControl(ctr.transform, "img_Name/lab_Vacancy")
  ctr.btn_signUp = UIControl(ctr.transform, "status/btn_sign_up")
  ctr.btn_noJoin = UIControl(ctr.transform, "status/img_no_join")
  ctr.btn_signUpSuccess = UIControl(ctr.transform, "status/sign_up_success")
  ctr.img_Name = UIControl(ctr.transform, "img_Name")
  ctr.lab_unionName = UIControl(ctr.transform, "img_Name/lab_text")
  ctr.img_main = UIControl(ctr.transform, "img_main")
end

local function OnRefreshUnionItem(ctr, _, data, ui)
  if data.ruWeiInfo == nil then
    ctr.lab_Vacancy:SetActive(true)
  else
    ctr.lab_Vacancy:SetActive(false)
  end
  ctr.lab_unionName:SetText(data.unionName or "")
  ui.rootPanel:SetSprite("Atlas_Common", data.unionImage, ctr.img_Name, false)
  ui.rootPanel:SetSprite("Atlas_Common", data.unionImageBg, ctr.img_main, true)
  local path = string.format("Texture/%s.png", data.unionBg)
  local sprite = ui.rootPanel:LoadAsset(path, typeof(CS.UnityEngine.Sprite))
  ctr.downBg:SetSprite(sprite)
  local winUnionId = QuickFind:GetSiFangZhengBaDataManager():GetWinUnionId()
  if data.campId and data.campId > 0 and 0 < winUnionId and data.campId == winUnionId then
    ctr.win_team:SetActive(true)
  else
    ctr.win_team:SetActive(false)
  end
  ctr.btn_signUp:SetOnClick(ui, function()
    if QuickFind:GetSiFangZhengBaDataManager():GetIsPreparationStage() then
      ui:SendSignUp(data)
    else
      FloatingTipUtility.QuickMsg(LocalizationUtility.GetContentByKey("Activity_SiFang_Tips5"))
    end
  end)
  ui:ChangeButtonState(ctr, data)
end

function panel_SiFangCrossTemplate:SendSignUp(data)
  local time = tonumber(ClientTable.cfg_Activity_globalManager:TryGetValue(500546).effect)
  if self.signUpStartTime == nil then
    SiFangZhengBaController.OnReqUnionKuaFuGongChengZhanBaoMing(data.campId)
    self.signUpStartTime = Time.GetServerTime()
  elseif time <= Time.GetServerTime() - self.signUpStartTime then
    SiFangZhengBaController.OnReqUnionKuaFuGongChengZhanBaoMing(data.campId)
    self.signUpStartTime = Time.GetServerTime()
  else
    FloatingTipUtility.QuickMsg(string.format(LocalizationUtility.GetContentByKey("Activity_SiFang_Tips8"), Mathf.Ceil((time - (Time.GetServerTime() - self.signUpStartTime)) / 1000)))
  end
end

function panel_SiFangCrossTemplate:ChangeButtonState(ctr, data)
  self:SetButtonActive(ctr, self.ButtonStateEnum.AllHide)
  local isUnionLeader = gameMgr:GetAvatarManager():GetMainPlayer():GetWarAllianceData().IsLeader()
  local isReadyStage = QuickFind:GetSiFangZhengBaDataManager():GetIsPreparationStage()
  local isOpenStage = QuickFind:GetSiFangZhengBaDataManager():GetIsOpenSiFangZhengBa()
  local isFinished = QuickFind:GetSiFangZhengBaDataManager():CheckActivityFinish()
  if data.ruWeiInfo == nil then
    self:SetButtonActive(ctr, self.ButtonStateEnum.AllHide)
  else
    if RoleManager.me.unionId == 0 then
      self:SetButtonActive(ctr, self.ButtonStateEnum.AllHide)
      return
    end
    if isFinished == true then
      self:SetButtonActive(ctr, self.ButtonStateEnum.AllHide)
      return
    end
    local allUnionId = QuickFind:GetSiFangZhengBaDataManager():GetAllSignUpUnionId()
    if allUnionId then
      for i, v in pairs(allUnionId) do
        if v == RoleManager.me.unionId then
          self:SetButtonActive(ctr, self.ButtonStateEnum.AllHide)
          return
        end
      end
    end
    if data.serverId == ViewData.meData.serverId then
      if isUnionLeader and isReadyStage == true and isOpenStage == false then
        self:SetButtonActive(ctr, self.ButtonStateEnum.CanNotSignUp)
      else
        self:SetButtonActive(ctr, self.ButtonStateEnum.AllHide)
      end
      return
    end
    local info = data.ruWeiInfo
    for i, v in ipairs(info) do
      if v.unionId == 0 then
        return
      end
      if v.unionId == RoleManager.me.unionId then
        self:SetButtonActive(ctr, self.ButtonStateEnum.AlreadySignUp)
        return
      end
    end
    if isUnionLeader then
      if isOpenStage == true or isReadyStage == false then
        self:SetButtonActive(ctr, self.ButtonStateEnum.AllHide)
      else
        self:SetButtonActive(ctr, self.ButtonStateEnum.CanSignUp)
      end
    else
      self:SetButtonActive(ctr, self.ButtonStateEnum.AllHide)
    end
  end
end

function panel_SiFangCrossTemplate:SetButtonActive(ctr, type)
  ctr.btn_signUp:SetActive(type == self.ButtonStateEnum.CanSignUp)
  ctr.btn_noJoin:SetActive(type == self.ButtonStateEnum.CanNotSignUp)
  ctr.btn_signUpSuccess:SetActive(type == self.ButtonStateEnum.AlreadySignUp)
end

local function OnCreateJuItem(ctr)
  ctr.img_ground = UIControl(ctr.transform, "img_ground")
  ctr.lab_name = UIControl(ctr.transform, "lab_name")
end

local function OnRefreshJuItem(ctr, _, data, ui)
  local str = ""
  if RoleManager.me.unionId > 0 and data.unionId == RoleManager.me.unionId then
    str = string.GetColorText(data.UnionName, "#FF8A00")
  else
    str = data.UnionName
  end
  ctr.lab_name:SetText(str)
end

local function OnCreateRewardItem(ctr)
  ctr.go_model = UIControl(ctr.transform, "go_model")
  ctr.modelData = ItemCellData()
end

local function OnRefreshRewardItem(ctr, _, data, ui)
  if data == nil then
    return
  end
  local itemData = ItemUtility.GenerateItemData(data.id)
  itemData.count = data.count
  ctr.modelData:RefreshData(itemData)
  if itemData.tblItem.subType == EItemSubtype.EffectTitle then
    ctr.go_model.transform.localScale = Vector3.one * 0.5
  end
  ItemUtility.ShowItemCell(ctr, ctr.modelData, ui.rootPanel, true)
end

local function OnCreateRankReward(ctr)
  ctr.itemCtr = UIControl(ctr.transform)
  ctr.modelData = ItemCellData()
end

local function OnRefreshRankReward(ctr, _, data, ui)
  if data == nil then
    return
  end
  local itemData = ItemUtility.GenerateItemData(data.id)
  itemData.count = data.count
  ctr.modelData:RefreshData(itemData)
  ItemUtility.ShowItemCell(ctr, ctr.modelData, ui.rootPanel, true)
end

local function OnCreateRankRewardItem(ctr)
  ctr.itemRank = UIControl(ctr.transform)
  ctr.btn_first = UIControl(ctr.transform, "sw_victoriousLeaderReward/Viewport/Content/btn_first")
end

local function OnRefreshRankRewardItem(ctr, _, data, ui)
  local rankTbl = string.split(data.rank, "#")
  local rankStr = ""
  if rankTbl[1] == rankTbl[2] then
    rankStr = string.format(ui.singularRankText, rankTbl[1])
  else
    rankStr = string.format(ui.quantityRankText, rankTbl[1], rankTbl[2])
  end
  ctr.itemRank:SetText(rankStr)
  if ctr.rewardContainer == nil then
    ctr.rewardContainer = UIContainer(ctr.btn_first, ui, OnCreateRankReward, OnRefreshRankReward)
  end
  local rewardTbl = string.split(data.showReward, "&")
  local rewardData = {}
  for i, v in ipairs(rewardTbl) do
    local reward = string.split(v, "#")
    table.insert(rewardData, {
      id = tonumber(reward[1]),
      count = tonumber(reward[2])
    })
  end
  ctr.rewardContainer:SetData(rewardData)
end

function panel_SiFangCrossTemplate:InitUI()
  self.panelTab = {
    self.go_main,
    self.panel_detail,
    self.panel_union_list
  }
  self.PanelEnum = {
    Main = enum(1),
    Detail = enum(2),
    UnionList = enum(3)
  }
  self.ButtonStateEnum = {
    CanSignUp = enum(1),
    CanNotSignUp = enum(2),
    AlreadySignUp = enum(3),
    AllHide = enum(4)
  }
  self.EnterButtonStateEnum = {
    CanEnter = enum(1),
    Finished = enum(2),
    NotEnough = enum(3),
    AllHide = enum(4)
  }
  self.UnionContainer = UIContainer(self.Union_Camp, self, OnCreateUnionItem, OnRefreshUnionItem)
  self.JuItemContainerTab = {
    [1] = UIContainer(self.JuItem_1, self, OnCreateJuItem, OnRefreshJuItem),
    [2] = UIContainer(self.JuItem_2, self, OnCreateJuItem, OnRefreshJuItem),
    [3] = UIContainer(self.JuItem_3, self, OnCreateJuItem, OnRefreshJuItem),
    [4] = UIContainer(self.JuItem_4, self, OnCreateJuItem, OnRefreshJuItem)
  }
  self.unionLeaderRewardItemContainer = UIContainer(self.unionLeaderRewardItem, self, OnCreateRewardItem, OnRefreshRewardItem)
  self.unionPersonRewardItemContainer = UIContainer(self.unionPersonRewardItem, self, OnCreateRewardItem, OnRefreshRewardItem)
  self.killResurrectedPersonRewardItemContainer = UIContainer(self.killResurrectedPersonRewardItem, self, OnCreateRewardItem, OnRefreshRewardItem)
  self.failRewardItemContainer = UIContainer(self.failRewardItem, self, OnCreateRankRewardItem, OnRefreshRankRewardItem)
  self.personalPointsRankItemContainer = UIContainer(self.personalPointsRankItem, self, OnCreateRankRewardItem, OnRefreshRankRewardItem)
  self.singularRankText = ClientTable.cfg_Activity_globalManager:TryGetValue(500564).effect or ""
  self.quantityRankText = ClientTable.cfg_Activity_globalManager:TryGetValue(500565).effect or ""
end

function panel_SiFangCrossTemplate:BindUIEvents()
  self.btn_goForm:SetOnClick(self, self.btn_goFormOnClick)
  self.btn_goReward:SetOnClick(self, self.btn_goRewardOnClick)
  self.btn_detail:SetOnClick(self, self.btn_detailOnClick)
  self.btn_unionListClose:SetOnClick(self, self.btn_unionListCloseOnClick)
  self.btn_detailClose:SetOnClick(self, self.btn_detailCloseOnClick)
  self.btn_signUp:SetOnClick(self, self.btn_signUpOnClick)
  self.btn_compose:SetOnClick(self, self.btn_composeOnClick)
end

function panel_SiFangCrossTemplate:btn_composeOnClick(control)
  UIManager.Show(UIID.Shop, {type = 24, subtype = 1})
end

function panel_SiFangCrossTemplate:btn_goFormOnClick(control)
  self:ChangePanelState(self.PanelEnum.UnionList)
end

function panel_SiFangCrossTemplate:btn_unionListCloseOnClick(control)
  self:ChangePanelState(self.PanelEnum.Main)
end

function panel_SiFangCrossTemplate:btn_goRewardOnClick(control)
  self:ChangePanelState(self.PanelEnum.Detail)
end

function panel_SiFangCrossTemplate:btn_detailCloseOnClick(control)
  self:ChangePanelState(self.PanelEnum.Main)
end

function panel_SiFangCrossTemplate:btn_detailOnClick(control)
  UIManager.Show(UIID.System_DescUI, {id = 1151})
end

function panel_SiFangCrossTemplate:btn_signUpOnClick(control)
  local isOpen = QuickFind:GetSiFangZhengBaDataManager():GetIsOpenSiFangZhengBa()
  if isOpen == false then
    FloatingTipUtility.QuickMsg(LocalizationUtility.GetContentByKey("Activity_SiFang_Tips1"))
    return
  end
  local isFinished = QuickFind:GetSiFangZhengBaDataManager():CheckActivityFinish()
  if isOpen == true and isFinished == true then
    FloatingTipUtility.QuickMsg(LocalizationUtility.GetContentByKey("Activity_SiFang_Tips9"))
    return
  end
  local needLevel = QuickFind:GetSiFangZhengBaDataManager():GetNeedLevel()
  if needLevel > ViewData.meData.level then
    FloatingTipUtility.QuickMsg(LocalizationUtility.GetContentByKey("Activity_SiFang_Tips2"))
    return
  end
  if TranScriptData.InTranscript == true or TranScriptData.InAllGodsscript == true then
    FloatingTipUtility.QuickMsg(LocalizationUtility.GetContentByKey("Activity_SiFang_Tips7"))
    return
  end
  if FourPartyRivalryManager:CheckInFourPartyRivalryMap(SceneData.mapId) then
    FloatingTipUtility.QuickMsg(LocalizationUtility.GetContentByKey("Activity_SiFang_Tips7"))
    return
  end
  if RoleManager.me.unionId == 0 then
    FloatingTipUtility.QuickMsg(LocalizationUtility.GetContentByKey("Activity_SiFang_Tips3"))
    return
  end
  local isAlreadyRuWei = QuickFind:GetSiFangZhengBaDataManager():GetIsAlreadyRuWei()
  if isAlreadyRuWei == false then
    FloatingTipUtility.QuickMsg(LocalizationUtility.GetContentByKey("Activity_SiFang_Tips4"))
    return
  end
  local isEnough = QuickFind:GetSiFangZhengBaDataManager():GetUnionNumber()
  if isEnough == false then
    FloatingTipUtility.QuickMsg(LocalizationUtility.GetContentByKey("Activity_SiFang_Tips6"))
    return
  end
  local mpaId = QuickFind:GetSiFangZhengBaDataManager():GetTransferMapId()
  local mapData = {mapId = mpaId}
  SceneController.OnReqTransferTransmitMap(nil, mapData)
  UIManager.Hide(UIID.CrossServer_IntoUI)
end

function panel_SiFangCrossTemplate:ChangePanelState(index)
  for i, v in ipairs(self.panelTab) do
    if i == index then
      v:SetActive(true)
    else
      v:SetActive(false)
    end
  end
end

function panel_SiFangCrossTemplate:RefreshPanel()
  self.this:SetActive(true)
  self.lab_entryTime:SetActive(false)
  self.btn_signUp:SetActive(false)
  self:ShowReward()
  SiFangZhengBaController.OnReqUnionKuaFuGongChengZhanInfo()
end

function panel_SiFangCrossTemplate:Refresh()
  self:ShowUnion()
  self:RefreshUnionListPanel()
  self:SetTimeStrColor()
  local isOpen = QuickFind:GetSiFangZhengBaDataManager():GetIsOpenSiFangZhengBa()
  local isFinished = QuickFind:GetSiFangZhengBaDataManager():CheckActivityFinish()
  local isEnough = QuickFind:GetSiFangZhengBaDataManager():GetUnionNumber()
  local state
  if isOpen == true and isFinished == false and isEnough == true then
    state = self.EnterButtonStateEnum.CanEnter
  elseif isOpen == true and isFinished == true then
    state = self.EnterButtonStateEnum.Finished
  elseif isOpen == true and isEnough == false then
    state = self.EnterButtonStateEnum.NotEnough
  else
    state = self.EnterButtonStateEnum.AllHide
  end
  self:ChangeEnterButtonState(state)
end

function panel_SiFangCrossTemplate:ChangeEnterButtonState(state)
  self.btn_signUp:SetActive(state == self.EnterButtonStateEnum.CanEnter)
  self.lab_SiFangPrompt:SetActive(state == self.EnterButtonStateEnum.Finished or state == self.EnterButtonStateEnum.NotEnough)
  if state == self.EnterButtonStateEnum.Finished then
    self.lab_SiFangPrompt:SetText(LocalizationUtility.GetContentByKey("Activity_SiFang_Tips11"))
  elseif state == self.EnterButtonStateEnum.NotEnough then
    self.lab_SiFangPrompt:SetText(LocalizationUtility.GetContentByKey("Activity_SiFang_Tips10"))
  else
    self.lab_SiFangPrompt:SetText("")
  end
end

function panel_SiFangCrossTemplate:ShowUnion()
  local unionData = QuickFind:GetSiFangZhengBaDataManager():GetUnionListData()
  if not unionData then
    return
  end
  if #unionData.info < 4 then
    local unionNum = #unionData.info
    local lackNum = 4 - unionNum
    for i = 1, lackNum do
      unionData.info[unionNum + i] = {}
    end
  end
  for i, v in ipairs(unionData.info) do
    local cfgTbl = ClientTable.cfg_Activity_sifangCampManager:TryGetValue(i)
    v.unionName = cfgTbl.unionName
    v.unionImage = cfgTbl.unionImage
    v.unionImageBg = cfgTbl.unionImageBg
    v.unionBg = cfgTbl.unionBg
  end
  self.UnionContainer:SetData(unionData.info)
  if RoleManager.me.unionId == 0 then
    FloatingTipUtility.QuickMsg(LocalizationUtility.GetContentByKey("Activity_SiFang_Tips3"))
    return
  end
  local isAlreadyRuWei = QuickFind:GetSiFangZhengBaDataManager():GetIsAlreadyRuWei()
  if isAlreadyRuWei == false then
    FloatingTipUtility.QuickMsg(LocalizationUtility.GetContentByKey("Activity_SiFang_Tips4"))
    return
  end
end

function panel_SiFangCrossTemplate:SetTimeStrColor()
  self.lab_entryTime:SetActive(true)
  local isOpen = QuickFind:GetSiFangZhengBaDataManager():GetIsOpenSiFangZhengBa()
  if isOpen == true then
    self.lab_entryTime:SetColor(EUIColor.Green)
  else
    self.lab_entryTime:SetColor(EUIColor.Red)
  end
end

function panel_SiFangCrossTemplate:RefreshUnionListPanel()
  local unionData = QuickFind:GetSiFangZhengBaDataManager():GetUnionListData()
  if not unionData or #unionData.info == 0 then
    return
  end
  for i, v in ipairs(unionData.info) do
    if v.ruWeiInfo then
      self.JuItemContainerTab[i]:SetData(v.ruWeiInfo)
    end
  end
end

function panel_SiFangCrossTemplate:ShowReward()
  self.unionLeaderRewardItemContainer:SetData(QuickFind:GetSiFangZhengBaDataManager():GetRewardData(500510))
  self.unionPersonRewardItemContainer:SetData(QuickFind:GetSiFangZhengBaDataManager():GetRewardData(500509))
  self.killResurrectedPersonRewardItemContainer:SetData(QuickFind:GetSiFangZhengBaDataManager():GetRewardData(500511))
  self.failRewardItemContainer:SetData(QuickFind:GetSiFangZhengBaDataManager():GetRankRewardData(SiFangZhengBaRewardType.UnionReward))
  self.personalPointsRankItemContainer:SetData(QuickFind:GetSiFangZhengBaDataManager():GetRankRewardData(SiFangZhengBaRewardType.PersonReward))
end

function panel_SiFangCrossTemplate:Exit()
  self:ChangePanelState(self.PanelEnum.Main)
  self.this:SetActive(false)
  self.UnionContainer:SetData()
  for i, v in ipairs(self.JuItemContainerTab) do
    v:SetData()
  end
end

return panel_SiFangCrossTemplate
