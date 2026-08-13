local function GetChild(root, name)
  if root then
    local trans = root.transform
    
    if trans then
      return trans:Find(name)
    else
      return root:Find(name)
    end
  end
end

local function GetTransComponent(root, name, gType)
  local child = GetChild(root, name)
  if child then
    return child:GetComponent(gType)
  else
    PrintLog("KsEngine.GetTransComponent root has no child named " .. name, "error", 3)
  end
end

local function GetTransSimpleComponent(root, name)
  if root then
    local trans = root.transform
    if trans then
      return trans:GetComponent(name)
    else
      return root:GetComponent(name)
    end
  end
end

local KsEngine = {GetTransComponent = GetTransComponent, GetTransSimpleComponent = GetTransSimpleComponent}
return KsEngine
