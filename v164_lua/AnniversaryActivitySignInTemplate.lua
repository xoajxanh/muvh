local AnniversaryActivitySignInTemplate = {}

function AnniversaryActivitySignInTemplate:Init()
  self:InitControls()
  self:RegistUIEvents()
end

function AnniversaryActivitySignInTemplate:InitControls()
  self.bgBlack = self:GetControl("Img_Bg/bgBlack")
  self.lab_Name = self:GetControl("lab_Name")
  self.selectEffect = self:GetControl("Eff_UI_qiji2_hanfuhuodong_kapiankuang")
  self.btn_3DItem = self:GetControl("btn_3DItem")
  self.go_model = self:GetControl("btn_3DItem/go_model")
  self.img_select = self:GetControl("btn_3DItem/img_select")
  self.btn_Get = self:GetControl("btn_Get")
  self.btn_Received = self:GetControl("btn_Received")
  self.btn_ReceivedTxt = self:GetControl("btn_Received/txt1")
  self.txt_lastTimeGift = self:GetControl("txt_lastTimeGift")
end

function AnniversaryActivitySignInTemplate:RegistUIEvents()
  self.btn_Get:SetOnClick(self, self.btn_GetOnClick)
end

function AnniversaryActivitySignInTemplate:btn_GetOnClick(control)
  NetManager.Send(CommerceMessage.ReqQianDaoReward, {
    configId = self.signInCfg.id
  })
end

function AnniversaryActivitySignInTemplate:Refresh(data, ui)
  self.root = ui
  self.signInData = data
  self.signInCfg = data.cfgInfo
  local reward, showData = AnniversaryActivity_SignInData.GetSignInReward(self.signInCfg)
  local taskGoalData = AnniversaryActivity_SignInData.GetSignInTaskGoalData(self.signInCfg.goalId)
  if not showData then
    return
  end
  local itemData = ItemUtility.GenerateItemData(showData.itemId)
  if itemData == nil or itemData.tblItem == nil then
    return
  end
  itemData.count = showData.count or 0
  if not self.itemCellData then
    self.itemCellData = ItemCellData()
  elseif self.itemCellData.model then
    self.itemCellData:RecycleRes()
  end
  self.itemCellData:RefreshData(itemData)
  if self.itemCellData.itemData.tblItem.subType == EItemSubtype.EffectTitle then
    self.go_model.transform.localScale = Vector3.one * 0.5
    if self.pos == nil then
      self.pos = self.btn_3DItem.transform.localPosition
      self.btn_3DItem.transform.localPosition = Vector3.New(self.pos.x, self.pos.y - 10, self.pos.z)
    end
  end
  ItemUtility.ShowItemCell(self.btn_3DItem, self.itemCellData, ui, true)
  self.lab_Name:SetText("Day" .. reward.sortId)
  if data.hasReward then
    self:ChangeItemState(TaskStateEnum.Got)
  elseif data.count <= data.current then
    self:ChangeItemState(TaskStateEnum.CanGet)
  elseif data.count > data.current then
    self:ChangeItemState(TaskStateEnum.CanNotGet)
  end
end

function AnniversaryActivitySignInTemplate:ChangeItemState(state)
  self.selectEffect:SetActive(state == TaskStateEnum.CanGet)
  self.btn_Get:SetActive(state == TaskStateEnum.CanGet)
  self.btn_Received:SetActive(state == TaskStateEnum.Got or state == TaskStateEnum.CanNotGet)
  self.img_select:SetActive(state == TaskStateEnum.Got)
  if state == TaskStateEnum.CanNotGet then
    self.btn_ReceivedTxt:SetText("\236\136\152\235\160\185 \235\182\136\234\176\128")
  elseif state == TaskStateEnum.Got then
    self.btn_ReceivedTxt:SetText("\196\144\195\163 nh\225\186\173n xong")
  end
  self.bgBlack:SetActive(state == TaskStateEnum.CanNotGet)
end

return AnniversaryActivitySignInTemplate
