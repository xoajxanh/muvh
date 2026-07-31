GM_MessageTreeLogic = {}
local this = GM_MessageTreeLogic

function GM_MessageTreeLogic.MakeTree(tb, parent)
  for k, v in pairs(tb) do
    local node = table.clone(this.NodeMsg())
    node.name = k
    if type(v) == "string" and string.len(v) > 100 then
      local jsonValue = json.decode(v)
      if jsonValue ~= nil and type(jsonValue) == "table" and table.count(jsonValue) > 0 then
        v = jsonValue
      end
    end
    node.value = v
    node.parent = parent.name
    node.tab = parent.tab + 1
    this.index = this.index + 1
    node.index = this.index
    if nil == parent.child then
      parent.child = {}
    end
    table.insert(parent.child, node)
    if type(v) == "table" then
      node.isClick = true
      if node.parent == "Root" then
        node.isOpen = true
        this.MakeTree(v, node)
      else
        node.isOpen = false
        this.MakeTree(v, node)
      end
    end
  end
  return parent
end

function GM_MessageTreeLogic.NodeMsg()
  local node = {
    name = "",
    value = nil,
    parent = nil,
    child = nil,
    tab = 0,
    index = 0,
    isOpen = false,
    isClick = false,
    uiObj = nil
  }
  return node
end

function GM_MessageTreeLogic.GetTree(tableContent)
  if tableContent == nil then
    return
  end
  this.index = 0
  this.root = table.clone(this.NodeMsg())
  this.root.name = "Root"
  return this.MakeTree(tableContent, this.root)
end
