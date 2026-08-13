Main_MapNameUI = class(BaseUI)
Main_MapNameUI.layer = UILayer.Loading
Main_MapNameUI.orderInLayer = -1
Main_MapNameUI.hideType = UIHideType.WaitDestroy
Main_MapNameUI.hideFunc = UIHideFunc.MoveOutOfScreen
Main_MapNameUI.escClose = UIEscClose.DontClose

function Main_MapNameUI:InitControls()
  self.img_mapname = self:GetControl("img_mapname")
end

function Main_MapNameUI:OnPreLoad()
end

function Main_MapNameUI:Init()
  self.showMapLogoCoroutine = nil
  self.waitTime = 10
  self.intervalTime = 3
  self.delayTime = 1
end

function Main_MapNameUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Main_MapNameUI:InitUI()
end

function Main_MapNameUI:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function Main_MapNameUI:OnHide()
end

function Main_MapNameUI:OnDestroy()
end

function Main_MapNameUI:RegistUIEvents()
end

function Main_MapNameUI:RegistEvents()
end

function Main_MapNameUI:Refresh()
  if ForgeData.isUseInMap then
    ForgeData.isUseInMap = false
    return
  end
  self:SetMapLogo()
end

function Main_MapNameUI:SetMapLogo()
  if self.showMapLogoCoroutine ~= nil then
    Coroutine.Stop(self.showMapLogoCoroutine)
    self.showMapLogoCoroutine = nil
  end
  if self.img_mapname ~= nil then
    self.img_mapname:SetActive(false)
    local mapTab = ClientTable.cfg_Map_mapManager:TryGetValue(SceneData.mapId, "id")
    self:SetSprite("Atlas_Language", mapTab.mapPic, self.img_mapname)
    self.img_mapname:SetColor("0xFFFFFF00")
    
    local function LogoFuc()
      if self.img_mapname.image ~= nil then
        self.img_mapname.image:DOFade(1, 3)
      else
        logError("self.img_mapname.image==nil")
        return
      end
      Coroutine.Wait(self.waitTime)
      self.img_mapname.image:DOFade(0, 3)
      Coroutine.Wait(self.intervalTime)
      UIManager.Hide(UIID.MapNameUI)
    end
    
    self.showMapLogoCoroutine = Coroutine.Start(LogoFuc)
  else
    log("self.img_mapname==nil")
  end
end
