local OpenServerInvestGiftTemplate = {}

function OpenServerInvestGiftTemplate:Init(rootUI)
  self:InitControls(rootUI)
  self:BindUIEvent()
end

function OpenServerInvestGiftTemplate:InitControls(rootUI)
  self.rootUI = rootUI
  self.nowControl = self:GetControl()
  self.lab_Invest = self:GetControl("lab_Invest")
  self.lab_unfinish = self:GetControl("lab_unfinish")
  self.lab_finish = self:GetControl("lab_finish")
  self.btn_Item = self:GetControl("sw_gift/Viewport/Content/btn_Item")
  self.btn_get = self:GetControl("btn_get")
  self.lab_get = self:GetControl("lab_get")
  self.img_icon = self:GetControl("sw_gift/Viewport/Content/btn_Item/img_icon")
end

function OpenServerInvestGiftTemplate:InitContainer()
end

function OpenServerInvestGiftTemplate:InitData()
end

function OpenServerInvestGiftTemplate:BindUIEvent()
  self.btn_get:SetOnClick(self, self.btn_getOnClick)
end

function OpenServerInvestGiftTemplate:btn_getOnClick()
  NetManager.Send(CommerceMessage.ReqOpenServiceInfo, {
    rewardId = self.data.id
  })
end

function OpenServerInvestGiftTemplate:Refresh(data, ui)
  self.data = data
  self.lab_Invest:SetText(string.format("M\225\187\159 SV %d ng\195\160y ", data.openDay))
  self.lab_unfinish:SetActive(data.state == KFTZRewardState.NeedRecharge)
  self.btn_get:SetActive(data.state == KFTZRewardState.CanGet)
  self.lab_get:SetActive(data.state == KFTZRewardState.Got)
  ItemUtility.ShowItemCellByItemId(data.rewardId, data.rewardCount, self.btn_Item, ui, true)
  self.btn_Item:GetChild("go_model").gameObject:SetActive(false)
  self.img_icon:SetActive(true)
  local TransitionItem = ItemUtility.GenerateItemData(data.rewardId)
  self.data.isRich:SetSprite("Atlas_Common", TransitionItem.tblItem.icon, self.img_icon)
end

function OpenServerInvestGiftTemplate:Exit()
  self:ReleaseModel()
end

function OpenServerInvestGiftTemplate:ReleaseModel()
  if self.btn_Item.itemCellData then
    ItemUtility.ReleaseItemCell(self.btn_Item, self.btn_Item.itemCellData)
  end
end

return OpenServerInvestGiftTemplate
