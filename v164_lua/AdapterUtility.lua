AdapterUtility = {}
local this = AdapterUtility
AdapterUtility.lastSafeArea = CS.UnityEngine.Rect(0, 0, 0, 0)
AdapterUtility.editorTestArea = CS.UnityEngine.Rect(0, 0.056, 0.9458128078817734, 0.944)
AdapterUtility.editorOrientation = ""
AdapterUtility.lastLandscapeState = ""
AdapterUtility.offsetX = 0
local Screen = CS.UnityEngine.Screen

local function GetSafeArea()
  local safeArea
  local a = ""
  if not CS.Framework.ResourceManager.editorMode then
    safeArea = Screen.safeArea
    a = Screen.orientation:ToString()
  else
    local nas = AdapterUtility.editorTestArea
    safeArea = CS.UnityEngine.Rect(Screen.width * nas.x, Screen.height * nas.y, Screen.width * nas.width, Screen.height * nas.height)
    a = AdapterUtility.editorOrientation
    if a == "LandscapeLeft" then
      safeArea.x = Screen.width - safeArea.width
    end
    if string.isNullOrEmpty(a) then
      safeArea.width = Screen.width
    end
  end
  AdapterUtility.lastLandscapeState = a
  AdapterUtility.offsetX = 0
  safeArea.y = 0
  safeArea.height = Screen.height
  if Application.platform == CS.UnityEngine.RuntimePlatform.IPhonePlayer then
    AdapterUtility.offsetX = (Screen.width - safeArea.width) / 2 * UIManager.ratio
  elseif a == "LandscapeRight" then
    AdapterUtility.offsetX = (Screen.width - safeArea.width) * UIManager.ratio
  end
  return safeArea
end

function AdapterUtility.Refresh(rectTrans)
  if not rectTrans then
    return
  end
  if not Screen or not Screen.safeArea then
    return
  end
  local a = Screen.orientation:ToString()
  if AdapterUtility.lastLandscapeState == a then
    return
  end
  local safeArea = GetSafeArea()
  if safeArea ~= this.lastSafeArea then
    this.lastSafeArea = safeArea
    local anchorMin = safeArea.position
    local anchorMax = safeArea.position + safeArea.size
    anchorMin.x = anchorMin.x / Screen.width
    anchorMin.y = anchorMin.y / Screen.height
    anchorMax.x = anchorMax.x / Screen.width
    anchorMax.y = anchorMax.y / Screen.height
    rectTrans.anchorMin = anchorMin
    rectTrans.anchorMax = anchorMax
  end
end
