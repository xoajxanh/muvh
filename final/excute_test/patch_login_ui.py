import re

with open(r'd:\MUVH\android\mu-decompiled\final\extracted_lua\Login_LoginUI.lua', 'r', encoding='utf-8') as f:
    content = f.read()

# 1. Force LoginData.isSdk = false at start of OnCreate and OnShow and Refresh
content = content.replace('function Login_LoginUI:OnCreate()', 'function Login_LoginUI:OnCreate()\n  LoginData.isSdk = false\n  pcall(function() CS.MuInterface.Instance:HideView() end)')
content = content.replace('function Login_LoginUI:OnShow()', 'function Login_LoginUI:OnShow()\n  LoginData.isSdk = false\n  pcall(function() CS.MuInterface.Instance:HideView() end)')

# 2. In OnRefresh: disable SDK call and force clean in-game login input form
old_on_refresh = '''  if LoginData.panelState == PanelStateEnum.InputLogin then
    self.go_selectServer:SetActive(false)
    self.go_LoginInput:SetActive(not LoginData.isSdk)
    self.go_ConnectServer:SetActive(false)
    self.btn_bindAccount:SetActive(false)
    self.btn_changeChannel_apple:SetActive(false)
    self.btn_loginSdk:SetActive(LoginData.isSdk)
    if LoginData.isSdk then
      LogManager.AddLoginLog("SDK_Login_Begin", "Login")
      CS.MuInterface.Instance:RemoveLoginSucListener()
      CS.MuInterface.Instance:BindLoginSucListener(SdkLoginSuc)
      CS.MuInterface.Instance:Login()
    end'''

new_on_refresh = '''  LoginData.isSdk = false
  if LoginData.panelState == PanelStateEnum.InputLogin then
    self.go_selectServer:SetActive(false)
    self.go_LoginInput:SetActive(true)
    self.go_ConnectServer:SetActive(false)
    self.btn_bindAccount:SetActive(false)
    self.btn_changeChannel_apple:SetActive(false)
    self.btn_loginSdk:SetActive(false)'''

content = content.replace(old_on_refresh, new_on_refresh)

# 3. Disable btn_loginSdkOnClick
content = re.sub(r'function Login_LoginUI:btn_loginSdkOnClick\(\).*?end', 'function Login_LoginUI:btn_loginSdkOnClick()\n  -- Bypassed SDK Login\nend', content, flags=re.DOTALL)

# 4. In btn_backOnClick: clean logout to input form
old_back = '''function Login_LoginUI:btn_backOnClick()
  LoginData.LogoutAccount()
  ActionStepsLogManager.SetRoleAction(ActionStepsType.LogOut)
  self:SetState(PanelStateEnum.InputLogin)
end'''

new_back = '''function Login_LoginUI:btn_backOnClick()
  LoginData.isSdk = false
  pcall(function() CS.MuInterface.Instance:HideView() end)
  self:SetState(PanelStateEnum.InputLogin)
end'''

content = content.replace(old_back, new_back)

with open(r'd:\MUVH\android\mu-decompiled\final\modified_lua_dev_farm\Login_LoginUI.lua', 'w', encoding='utf-8') as f:
    f.write(content)

print("Tao thanh cong modified_lua_dev_farm\\Login_LoginUI.lua!")
