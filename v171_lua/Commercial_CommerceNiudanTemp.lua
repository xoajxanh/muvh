local Commercial_CommerceNiudanTemp = {}

function Commercial_CommerceNiudanTemp:Init(root)
  self.root = root
  self:InitControls()
  self:InitUI()
  self:BindEvents()
end

function Commercial_CommerceNiudanTemp:InitControls()
  self.sw_spirtsrankList = self:GetControl("sw_spirtsrankList")
  self.RechargeAndReceive = self:GetControl("sw_spirtsrankList/Viewport/Content/img_Accumulating")
  self.txt_lastTime_Invest = self:GetControl("txt_lastTime_Invest")
  self.Btn_GashaponLeft = self:GetControl("Btn_GashaponLeft")
  self.Btn_GashaponRight = self:GetControl("Btn_GashaponRight")
  self.leftlab_num = self:GetControl("Btn_GashaponLeft/img_icon/lab_num")
  self.rightlab_num = self:GetControl("Btn_GashaponRight/img_icon/lab_num")
  self.Gashaponimg_iconLeft = self:GetControl("Btn_GashaponLeft/img_icon")
  self.Gashaponimg_iconRight = self:GetControl("Btn_GashaponRight/img_icon")
  self.gashaponReward = self:GetControl("GashaponReward")
  self.tog_overAni = self:GetControl("tog_overAni")
  self.descBtn = self:GetControl("descBtn")
  self.EffectRoot = self:GetControl("EffectRoot")
  self.effect = {}
  self.labList = {}
  self.iconList = {}
  self.numBgList = {}
  for i = 1, self.gashaponReward.transform.childCount do
    local lab_num = self.gashaponReward:GetChild("Gashapon_" .. i .. "/img_numbg/lab_num")
    local img_icon = self.gashaponReward:GetChild("Gashapon_" .. i .. "/img_icon")
    local img_numBg = self.gashaponReward:GetChild("Gashapon_" .. i .. "/img_numbg")
    self.labList[i] = lab_num
    self.iconList[i] = img_icon
    self.numBgList[i] = img_numBg
  end
end

function Commercial_CommerceNiudanTemp:BindEvents()
  self.Btn_GashaponLeft:SetOnClick(self, self.Btn_GashaponLeftOnClick)
  self.Btn_GashaponRight:SetOnClick(self, self.Btn_GashaponRightOnClick)
  self.descBtn:SetOnClick(self, self.descBtnOnClick)
end

function Commercial_CommerceNiudanTemp:descBtnOnClick()
  UIManager.Show(UIID.System_DescUI, {id = 1089})
end

function Commercial_CommerceNiudanTemp:Btn_GashaponLeftOnClick()
  if not QuickFind:GetConnectionNiudanManager().OnClickType then
    QuickFind:GetConnectionNiudanManager().OnClickType = true
    self:BagItemCount(1)
  end
end

function Commercial_CommerceNiudanTemp:Btn_GashaponRightOnClick()
  if not QuickFind:GetConnectionNiudanManager().OnClickType then
    QuickFind:GetConnectionNiudanManager().OnClickType = true
    self:BagItemCount(10)
  end
end

function Commercial_CommerceNiudanTemp:BagItemCount(count)
  if self.imgId then
    if count <= BagInfoData.GetItemTotalCountByItemId(tonumber(self.imgId)) then
      networkRequest.ReqLuckDiamondGashapon(count)
      EventManager.Dispatch(Event.NiudanDataRefresh)
    else
      FloatingTipUtility.QuickMsg("V\195\169 Quay Tr\225\187\169ng kh\195\180ng \196\145\225\187\167")
      QuickFind:GetConnectionNiudanManager().OnClickType = false
    end
  end
end

function Commercial_CommerceNiudanTemp:InitUI()
  self.ReceiveTempaltes = UIUtility.BindUIContainerTemp(self.RechargeAndReceive, LuaComponentTemplates.Commercial_RechargeAndReceiveTemp, self.root)
end

function Commercial_CommerceNiudanTemp:LoadEffectUI()
  local niudan = QuickFind:GetConnectionNiudanManager():InitShowEffectData()
  if not niudan then
    return
  end
  if self.tog_overAni:GetIsOn() then
    QuickFind:GetConnectionNiudanManager().OnClickType = false
    local ItemData = QuickFind:GetConnectionNiudanManager():InitShowRewardData()
    UIManager.Show(UIID.Tip_RewardTipUI, {rewards = ItemData})
    FloatingWordUtility.QuickMsg("Nh\225\186\173n th\195\160nh c\195\180ng")
    return
  end
  local EffectBool = false
  for i, v in ipairs(self.effect) do
    if v.data.name == niudan then
      v:SetActive(true)
      EffectBool = true
    end
  end
  if not EffectBool then
    local effect = UIEffectUtility.SetUIEffect(niudan, self.EffectRoot, false, Vector2.one)
    table.insert(self.effect, effect)
  end
  if self.effectCoroutine then
    Coroutine.Stop(self.effectCoroutine)
    self.effectCoroutine = nil
  end
  
  local function showRewardUI()
    Coroutine.Wait(2.8)
    QuickFind:GetConnectionNiudanManager().OnClickType = false
    for i, v in ipairs(self.effect) do
      v:SetActive(false)
    end
    local ItemData = QuickFind:GetConnectionNiudanManager():InitShowRewardData()
    UIManager.Show(UIID.Tip_RewardTipUI, {rewards = ItemData})
    FloatingWordUtility.QuickMsg("Nh\225\186\173n th\195\160nh c\195\180ng")
  end
  
  self.effectCoroutine = Coroutine.Start(showRewardUI, self)
end

function Commercial_CommerceNiudanTemp:Refresh()
  self.sw_spirtsrankList:SetNormalizedPosition(0, 1)
  local gamedatalist = QuickFind:GetConnectionNiudanManager():GetData()
  if gamedatalist ~= nil then
    self.ReceiveTempaltes:SetData(gamedatalist)
  end
  local niudandatalist = QuickFind:GetConnectionNiudanManager():GetNiudanData()
  for i, v in ipairs(self.labList) do
    v:SetText(niudandatalist[i].count)
  end
  for i, v in ipairs(self.iconList) do
    self.root:SetSprite("Atlas_Common", niudandatalist[i].basemapIcon, v)
  end
  for i, v in ipairs(self.numBgList) do
    self.root:SetSprite("Atlas_Common", niudandatalist[i].basemapLogIcon, v)
  end
  local rightlab = "X10"
  local leftlab = "X1"
  local sub = BagInfoData.GetItemTotalCountByItemId(tonumber(self.imgId))
  if 1 <= sub and sub < 10 then
    self.rightlab_num:SetText(string.GetColorText(rightlab, ItemQuality2ColorDic[12]))
    self.leftlab_num:SetText(string.GetColorText(leftlab, ItemQuality2ColorDic[5]))
  elseif 10 <= sub then
    self.rightlab_num:SetText(string.GetColorText(rightlab, ItemQuality2ColorDic[5]))
    self.leftlab_num:SetText(string.GetColorText(leftlab, ItemQuality2ColorDic[5]))
  else
    self.rightlab_num:SetText(string.GetColorText(rightlab, ItemQuality2ColorDic[12]))
    self.leftlab_num:SetText(string.GetColorText(leftlab, ItemQuality2ColorDic[12]))
  end
  local effect = ClientTable.cfg_Commerce_globalManager:TryGetValue(319001).effect
  if not string.isNullOrEmpty(effect) then
    self.imgId = string.split(effect, "#")[1]
    self.root:SetSprite("Atlas_Common", self.imgId, self.Gashaponimg_iconLeft)
    self.root:SetSprite("Atlas_Common", self.imgId, self.Gashaponimg_iconRight)
  end
  EventManager.Dispatch(Event.CallRefreshRedPoint, {
    id = ERedPointId.holidayActivity_Gashapon
  })
  self:RefreshSurplusTime()
end

function Commercial_CommerceNiudanTemp:RefreshSurplusTime()
  if self.remainTimeLoop then
    Timer.Stop(self.remainTimeLoop)
    self.remainTimeLoop = nil
  end
  self.txt_lastTime_Invest:SetText(QuickFind:GetConnectionNiudanManager():GetRemainTimeDes())
  self.remainTimeLoop = Timer.StartLoopForever(1, function()
    self.txt_lastTime_Invest:SetText(QuickFind:GetConnectionNiudanManager():GetRemainTimeDes())
  end)
end

function Commercial_CommerceNiudanTemp:Hide()
  if self.remainTimeLoop then
    Timer.Stop(self.remainTimeLoop)
    self.remainTimeLoop = nil
  end
  for i, v in ipairs(self.effect) do
    v:Destroy()
  end
  self.effect = {}
end

return Commercial_CommerceNiudanTemp
