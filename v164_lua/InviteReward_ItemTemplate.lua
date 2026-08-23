local InviteReward_ItemTemplate = {}

function InviteReward_ItemTemplate:Init(data)
  self:InitControls()
  self:InitTemplates()
  self:InitUIEvents()
  self.word = ClientTable.cfg_Ui_wordManager:GetUi_wordCount("Invite_success_show")
  self.INVITE_REWARD_CONFIG = {
    [6600001] = {
      title = string.format(self.word, 1),
      targetNum = 1
    },
    [6600002] = {
      title = string.format(self.word, 3),
      targetNum = 3
    },
    [6600003] = {
      title = string.format(self.word, 5),
      targetNum = 5
    }
  }
end

function InviteReward_ItemTemplate:InitControls()
  self.btn_Item = self:GetControl("btn_Item")
  self.btn_get = self:GetControl("btn_get")
  self.img_light = self:GetControl("img_light_bg")
  self.img_grey1 = self:GetControl("img_grey_bg")
  self.img_grey2 = self:GetControl("img_grey")
  self.lab_title = self:GetControl("lab_title")
end

function InviteReward_ItemTemplate:InitTemplates()
  self.rewardItemTemplate = UIUtility.BindUIContainerTemp(self.btn_Item, LuaComponentTemplates.UIItemTemplate, self.root, {
    isShowTips = true,
    stencil = 2,
    maskType = 5
  })
end

function InviteReward_ItemTemplate:InitUIEvents()
  self.btn_get:SetOnClick(self, self.Btn_getOnClick)
end

function InviteReward_ItemTemplate:Btn_getOnClick()
  networkRequest.ReqGetGift({
    self.data.id
  })
  self:DisableRewardUI()
end

function InviteReward_ItemTemplate:Refresh(data, ui)
  if table.isNullOrEmpty(data) then
    return
  end
  self.data = data
  self.ui = ui
  self.ItemTbl = QuickFind:GetTask_EarlyGoldManager():GetBoxItemTbl({data})
  if self.ItemTbl then
    self.rewardItemTemplate:SetData(self.ItemTbl)
  end
  self:DisableRewardUI()
  self:RefreshViewUI()
end

function InviteReward_ItemTemplate:RefreshViewUI()
  local config = self.INVITE_REWARD_CONFIG[tonumber(self.data.id)]
  if config then
    self.lab_title:SetText(config.title)
  end
  local EarlyGoldManager = QuickFind:GetTask_EarlyGoldManager()
  local VerifyData = EarlyGoldManager:GetVerifyData()
  if not VerifyData or VerifyData.num == nil or VerifyData.code == nil then
    return
  end
  local currentInviteNum = tonumber(VerifyData.num)
  if not config then
    return
  end
  local isCanReceive = true
  if currentInviteNum < config.targetNum then
    isCanReceive = false
  end
  local hasReceived = EarlyGoldManager:GetRefreshCountFun(self.data)
  if hasReceived then
    isCanReceive = false
  end
  self:UpdateReceiveUI(isCanReceive)
end

function InviteReward_ItemTemplate:DisableRewardUI()
  self.btn_get:SetInteractable(false)
  self.img_light:SetActive(false)
  self.img_grey1:SetActive(true)
  self.img_grey2:SetActive(true)
end

function InviteReward_ItemTemplate:UpdateReceiveUI(isCanReceive)
  if isCanReceive then
    self.btn_get:SetInteractable(true)
    self.img_light:SetActive(true)
    self.img_grey1:SetActive(false)
    self.img_grey2:SetActive(false)
  else
    self:DisableRewardUI()
  end
end

return InviteReward_ItemTemplate
