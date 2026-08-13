local AnniversaryActivityNewCharacterTaskTemplate = {}

function AnniversaryActivityNewCharacterTaskTemplate:Init()
  self:InitControls()
  self:InitUI()
  self:ResgistUIEvents()
end

function AnniversaryActivityNewCharacterTaskTemplate:InitControls()
  self.btn_3DItem = self:GetControl("item_group/btn_3DItem")
  self.lab_target = self:GetControl("btn_group/lab_target")
  self.btn_noget = self:GetControl("btn_group/btn_noget")
  self.btn_get = self:GetControl("btn_group/btn_get")
  self.btn_got = self:GetControl("btn_group/btn_got")
end

local function ShowRewardItemCreate(ctr)
  ctr.itemCtr = ItemUtility.InitItemCell(UIControl(ctr.transform))
  ctr.modelData = ItemCellData()
end

local function ShowRewardItemRefresh(ctr, _, data, ui)
  local id = tonumber(data.itemId)
  local itemData = ItemUtility.GenerateItemData(id)
  itemData.count = data.count
  ctr.modelData:RefreshData(itemData)
  ItemUtility.ShowItemCell(ctr.itemCtr, ctr.modelData, ui.root, true)
end

function AnniversaryActivityNewCharacterTaskTemplate:InitUI()
  self.rewardContainer = UIContainer(self.btn_3DItem, self, ShowRewardItemCreate, ShowRewardItemRefresh)
end

function AnniversaryActivityNewCharacterTaskTemplate:ResgistUIEvents()
  self.btn_get:SetOnClick(self, self.btn_getOnClick)
end

function AnniversaryActivityNewCharacterTaskTemplate:btn_getOnClick(control)
  NetManager.Send(RechargeMessage.ReqGetGift, {
    id = {
      self.data.giftInfo.id
    }
  })
end

function AnniversaryActivityNewCharacterTaskTemplate:Refresh(data, ui)
  self.root = ui
  self.data = data
  self.lab_target:SetText(data.goalInfo.goalTips)
  self.rewardContainer:SetData(data.boxInfo)
  if RoleManager.me.level < data.goalInfo.goalCount then
    self.btn_noget:SetActive(true)
    self.btn_get:SetActive(false)
    self.btn_got:SetActive(false)
  elseif RechargeData.GetCount(data.giftInfo.countKey) == 0 then
    self.btn_noget:SetActive(false)
    self.btn_get:SetActive(true)
    self.btn_got:SetActive(false)
  else
    self.btn_noget:SetActive(false)
    self.btn_get:SetActive(false)
    self.btn_got:SetActive(true)
  end
end

return AnniversaryActivityNewCharacterTaskTemplate
