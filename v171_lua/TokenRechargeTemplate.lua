local TokenRechargeTemplate = {}

function TokenRechargeTemplate:Init()
  self:InitControls()
  self:InitTemplates()
  self:InitUIEvents()
end

function TokenRechargeTemplate:InitControls()
  self.img_rechagePicture = self:GetControl("img_rechagePicture")
  self.btn_rechange = self:GetControl("btn_rechange")
  self.lab_buy = self:GetControl("btn_rechange/lab_buy")
  self.btn_Item = self:GetControl("go_gem/btn_Item")
  self.img_zheKou = self:GetControl("img_zhekou")
  self.txt_zheKou = self:GetControl("img_zhekou/txt_zhekou")
  self.txt_des = self:GetControl("txt_des")
end

function TokenRechargeTemplate:InitTemplates()
  self.rewardItemTemplate = UIUtility.BindUIContainerTemp(self.btn_Item, LuaComponentTemplates.UIItemTemplate, self.root, {
    isShowTips = true,
    stencil = 2,
    maskType = 5
  })
end

function TokenRechargeTemplate:InitUIEvents()
  self.btn_rechange:SetOnClick(self, self.Btn_ReChangeOnClick)
end

function TokenRechargeTemplate:Btn_ReChangeOnClick()
  if self.data.global then
    if not string.isNullOrEmpty(self.data.global[2]) then
      Application.OpenURL(self.data.global[2])
    end
  else
    DataToCSharpMgr.Pay({
      amount = tonumber(self.data.rmb),
      product_Id = self.data.id,
      BusinessPayType = BusinessPayType.None
    })
  end
end

function TokenRechargeTemplate:Refresh(data, ui)
  if table.isNullOrEmpty(data) then
    return
  end
  self.data = data
  self.ui = ui
  self:RefreshView()
  local itemId = RechargeData:GetBoxItemTbl({data})
  self.rewardItemTemplate:SetData(itemId)
end

function TokenRechargeTemplate:RefreshView()
  self.ui:SetSprite("Atlas_Main", self.data.title, self.img_rechagePicture)
  self.lab_buy:SetText(string.format("%sK VND", math.ceil(tonumber(self.data.rmb) / 1000)))
  if not string.isNullOrEmpty(self.data.discount) then
    self.img_zheKou:SetActive(true)
    self.txt_zheKou:SetText(self.data.discount)
    self.txt_des:SetActive(true)
  else
    self.img_zheKou:SetActive(false)
    self.txt_des:SetActive(false)
  end
end

return TokenRechargeTemplate
