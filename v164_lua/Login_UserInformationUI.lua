Login_UserInformationUI = class(BaseUI)
Login_UserInformationUI.layer = UILayer.Panel
Login_UserInformationUI.orderInLayer = 10
Login_UserInformationUI.hideType = UIHideType.Destroy
Login_UserInformationUI.hideFunc = UIHideFunc.MoveOutOfScreen
Login_UserInformationUI.escClose = UIEscClose.DontClose

function Login_UserInformationUI:InitControls()
  self.btn_closeBg = self:GetControl("btn_closeBg")
  self.go_UserInformation = self:GetControl("go_UserInformation")
  self.btn_closePolicy = self:GetControl("go_UserInformation/btn_closePolicy")
  self.btn_ThirdAccount = self:GetControl("go_UserInformation/Toggle_frist/btn_ThirdAccount")
  self.text_ThirdAccoun = self:GetControl("go_UserInformation/Toggle_frist/btn_ThirdAccount/text_ThirdAccoun")
  self.btn_IP = self:GetControl("go_UserInformation/Toggle_frist/btn_IP")
  self.text_IP = self:GetControl("go_UserInformation/Toggle_frist/btn_IP/text_IP")
  self.btn_GameLog = self:GetControl("go_UserInformation/Toggle_frist/btn_GameLog")
  self.text_GameLog = self:GetControl("go_UserInformation/Toggle_frist/btn_GameLog/text_GameLog")
  self.btn_Recharge = self:GetControl("go_UserInformation/Toggle_frist/btn_Recharge")
  self.text_Recharge = self:GetControl("go_UserInformation/Toggle_frist/btn_Recharge/text_Recharge")
  self.btn_Role = self:GetControl("go_UserInformation/Toggle_frist/btn_Role")
  self.text_Role = self:GetControl("go_UserInformation/Toggle_frist/btn_Role/text_Role")
  self.btn_day = self:GetControl("go_UserInformation/ThirdAccountPanel/btn_day")
  self.toggle_frist = self:GetControl("go_UserInformation/Toggle_frist")
  self.thirdAccountPanel = self:GetControl("go_UserInformation/ThirdAccountPanel")
  self.iPPanel = self:GetControl("go_UserInformation/IPPanel")
  self.gameLogPanel = self:GetControl("go_UserInformation/GameLogPanel")
  self.rechargePanel = self:GetControl("go_UserInformation/RechargePanel")
  self.rolePanel = self:GetControl("go_UserInformation/RolePanel")
  self.btn_retureThirdAccountPanel = self:GetControl("go_UserInformation/ThirdAccountPanel/btn_reture")
  self.btn_retureIPPanel = self:GetControl("go_UserInformation/IPPanel/btn_reture")
  self.btn_retureGameLogPanel = self:GetControl("go_UserInformation/GameLogPanel/btn_reture")
  self.btn_retureRechargePanel = self:GetControl("go_UserInformation/RechargePanel/btn_reture")
  self.btn_retureRolePanel = self:GetControl("go_UserInformation/RolePanel/btn_reture")
end

function Login_UserInformationUI:Init()
  self.curTable = {}
  self.curTableStr = ""
  self.btnTextArray = {}
  self.curTableNumber = 0
end

function Login_UserInformationUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Login_UserInformationUI:InitUI()
  local str = ClientTable.cfg_Ui_wordManager:TryGetValue("Config_userInformation_day").content
  self.btnTextArray = string.split(str or "", "#")
  PolicyData:GetReqInfomation()
end

function Login_UserInformationUI:RegistUIEvents()
  self.btn_closeBg:SetOnClick(self, self.btn_closeBgOnClick)
  self.btn_closePolicy:SetOnClick(self, self.btn_closePolicyOnClick)
  self.btn_ThirdAccount:SetOnClick(self, self.btn_ThirdAccountOnClick)
  self.btn_IP:SetOnClick(self, self.btn_IPOnClick)
  self.btn_GameLog:SetOnClick(self, self.btn_GameLogOnClick)
  self.btn_Recharge:SetOnClick(self, self.btn_RechargeOnClick)
  self.btn_Role:SetOnClick(self, self.btn_RoleOnClick)
  self.btn_retureThirdAccountPanel:SetOnClick(self, self.btn_retureOnClick)
  self.btn_retureIPPanel:SetOnClick(self, self.btn_retureOnClick)
  self.btn_retureGameLogPanel:SetOnClick(self, self.btn_retureOnClick)
  self.btn_retureRechargePanel:SetOnClick(self, self.btn_retureOnClick)
  self.btn_retureRolePanel:SetOnClick(self, self.btn_retureOnClick)
end

function Login_UserInformationUI:HideAllOtherPanel()
  self.thirdAccountPanel:SetActive(false)
  self.iPPanel:SetActive(false)
  self.gameLogPanel:SetActive(false)
  self.rechargePanel:SetActive(false)
  self.rolePanel:SetActive(false)
  self.toggle_frist:SetActive(true)
end

function Login_UserInformationUI:btn_closeBgOnClick(control)
end

function Login_UserInformationUI:btn_closePolicyOnClick(control)
  UIManager.Hide(UIID.Login_UserInformationUI)
end

function Login_UserInformationUI:SetCurTableComponent(ctr)
  self.curTable = {}
  self.curTable.txt_title1 = UIControl(ctr.transform, "img_Title1/img_txt/lab_txt")
  self.curTable.txt_title2 = UIControl(ctr.transform, "img_Title2/img_txt/lab_txt")
  self.curTable.btn_day = UIControl(ctr.transform, "btn_day")
  self.curTable.lab_mode = UIControl(ctr.transform, "btn_day/lab_mode")
  self.curTable.grid_day = UIControl(ctr.transform, "grid_day")
  self.curTable.btn_day1 = UIControl(ctr.transform, "grid_day/btn_day1")
  UIControl(ctr.transform, "grid_day/btn_day1/lab_dayshow"):SetText(self.btnTextArray[1])
  self.curTable.btn_day1.contentText = self.btnTextArray[1]
  self.curTable.btn_day2 = UIControl(ctr.transform, "grid_day/btn_day2")
  UIControl(ctr.transform, "grid_day/btn_day2/lab_dayshow"):SetText(self.btnTextArray[2])
  self.curTable.btn_day2.contentText = self.btnTextArray[2]
  self.curTable.btn_day3 = UIControl(ctr.transform, "grid_day/btn_day3")
  UIControl(ctr.transform, "grid_day/btn_day3/lab_dayshow"):SetText(self.btnTextArray[3])
  self.curTable.btn_day3.contentText = self.btnTextArray[3]
  self.curTable.btn_day4 = UIControl(ctr.transform, "grid_day/btn_day4")
  UIControl(ctr.transform, "grid_day/btn_day4/lab_dayshow"):SetText(self.btnTextArray[4])
  self.curTable.btn_day4.contentText = self.btnTextArray[4]
  self.curTable.btn_day5 = UIControl(ctr.transform, "grid_day/btn_day5")
  UIControl(ctr.transform, "grid_day/btn_day5/lab_dayshow"):SetText(self.btnTextArray[5])
  self.curTable.btn_day5.contentText = self.btnTextArray[5]
  self.curTable.lab_day = UIControl(ctr.transform, "lab_day")
  self.curTable.grid_day:SetActive(false)
end

function Login_UserInformationUI:SetCurTableComponentEvent(ctr)
  self.curTable.btn_day:SetOnClick(self, function(control)
    self.curTable.grid_day:SetActive(true)
  end)
  self.curTable.btn_day1:SetOnClick(self, function(control)
    self.curTable.lab_mode:SetText(control.curTable.btn_day1.contentText or "")
    self.curTable.grid_day:SetActive(false)
    self.curTable.lab_day:SetText(string.format(self.curTableStr, control.curTable.btn_day1.contentText, PolicyData:GetInfomation(PolicyData.TimeExtentEnum.year1, self.curTableNumber)))
  end)
  self.curTable.btn_day2:SetOnClick(self, function(control)
    self.curTable.lab_mode:SetText(control.curTable.btn_day2.contentText or "")
    self.curTable.grid_day:SetActive(false)
    self.curTable.lab_day:SetText(string.format(self.curTableStr, control.curTable.btn_day2.contentText, PolicyData:GetInfomation(PolicyData.TimeExtentEnum.month3, self.curTableNumber)))
  end)
  self.curTable.btn_day3:SetOnClick(self, function(control)
    self.curTable.lab_mode:SetText(control.curTable.btn_day3.contentText or "")
    self.curTable.grid_day:SetActive(false)
    self.curTable.lab_day:SetText(string.format(self.curTableStr, control.curTable.btn_day3.contentText, PolicyData:GetInfomation(PolicyData.TimeExtentEnum.month1, self.curTableNumber)))
  end)
  self.curTable.btn_day4:SetOnClick(self, function(control)
    self.curTable.lab_mode:SetText(control.curTable.btn_day4.contentText or "")
    self.curTable.grid_day:SetActive(false)
    self.curTable.lab_day:SetText(string.format(self.curTableStr, control.curTable.btn_day4.contentText, PolicyData:GetInfomation(PolicyData.TimeExtentEnum.day7, self.curTableNumber)))
  end)
  self.curTable.btn_day5:SetOnClick(self, function(control)
    self.curTable.lab_mode:SetText(control.curTable.btn_day5.contentText or "")
    self.curTable.grid_day:SetActive(false)
    self.curTable.lab_day:SetText(string.format(self.curTableStr, control.curTable.btn_day5.contentText, PolicyData:GetInfomation(PolicyData.TimeExtentEnum.day1, self.curTableNumber)))
  end)
end

function Login_UserInformationUI:btn_ThirdAccountOnClick(control)
  self.toggle_frist:SetActive(false)
  self.thirdAccountPanel:SetActive(true)
  self.curTableStr = ClientTable.cfg_Ui_wordManager:TryGetValue("Config_userInformation_1").content
  self:SetCurTableComponent(self.thirdAccountPanel)
  self:SetCurTableComponentEvent(self.thirdAccountPanel)
  self.curTableNumber = 1
  self.curTable.lab_day:SetText(string.format(self.curTableStr or "", "7 ng\195\160y g\225\186\167n \196\145\195\162y", PolicyData:GetInfomation(PolicyData.TimeExtentEnum.day7, self.curTableNumber)))
end

function Login_UserInformationUI:btn_IPOnClick(control)
  self.toggle_frist:SetActive(false)
  self.iPPanel:SetActive(true)
  self.curTableStr = ClientTable.cfg_Ui_wordManager:TryGetValue("Config_userInformation_2").content
  self:SetCurTableComponent(self.iPPanel)
  self:SetCurTableComponentEvent(self.iPPanel)
  self.curTableNumber = 2
  self.curTable.lab_day:SetText(string.format(self.curTableStr or "", "7 ng\195\160y g\225\186\167n \196\145\195\162y", PolicyData:GetInfomation(PolicyData.TimeExtentEnum.day7, self.curTableNumber)))
end

function Login_UserInformationUI:btn_GameLogOnClick(control)
  self.toggle_frist:SetActive(false)
  self.gameLogPanel:SetActive(true)
  self.curTableStr = ClientTable.cfg_Ui_wordManager:TryGetValue("Config_userInformation_3").content
  self:SetCurTableComponent(self.gameLogPanel)
  self:SetCurTableComponentEvent(self.gameLogPanel)
  self.curTableNumber = 3
  self.curTable.lab_day:SetText(string.format(self.curTableStr or "", "7 ng\195\160y g\225\186\167n \196\145\195\162y", PolicyData:GetInfomation(PolicyData.TimeExtentEnum.day7, self.curTableNumber)))
end

function Login_UserInformationUI:btn_RechargeOnClick(control)
  self.toggle_frist:SetActive(false)
  self.rechargePanel:SetActive(true)
  self.curTableStr = ClientTable.cfg_Ui_wordManager:TryGetValue("Config_userInformation_4").content
  self:SetCurTableComponent(self.rechargePanel)
  self:SetCurTableComponentEvent(self.rechargePanel)
  self.curTableNumber = 4
  self.curTable.lab_day:SetText(string.format(self.curTableStr or "", "7 ng\195\160y g\225\186\167n \196\145\195\162y", PolicyData:GetInfomation(PolicyData.TimeExtentEnum.day7, self.curTableNumber)))
end

function Login_UserInformationUI:btn_RoleOnClick(control)
  self.toggle_frist:SetActive(false)
  self.rolePanel:SetActive(true)
  self.curTableStr = ClientTable.cfg_Ui_wordManager:TryGetValue("Config_userInformation_5").content
  self:SetCurTableComponent(self.rolePanel)
  self:SetCurTableComponentEvent(self.rolePanel)
  self.curTableNumber = 5
  self.curTable.lab_day:SetText(string.format(self.curTableStr or "", "7 ng\195\160y g\225\186\167n \196\145\195\162y", PolicyData:GetInfomation(PolicyData.TimeExtentEnum.day7, self.curTableNumber)))
end

function Login_UserInformationUI:btn_retureOnClick(control)
  self:HideAllOtherPanel()
end

function Login_UserInformationUI:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function Login_UserInformationUI:RegistEvents()
end

function Login_UserInformationUI:Refresh()
  self:HideAllOtherPanel()
end

function Login_UserInformationUI:OnHide()
  self.curTable = {}
  self.curTableStr = ""
  self:HideAllOtherPanel()
end

function Login_UserInformationUI:OnDestroy()
end
