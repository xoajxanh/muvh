CostInfoData = class()

function CostInfoData:ctor(costCfg)
  local optionalStrs = string.split(costCfg, "/")
  self.optionalCosts = {}
  local requireCosts, cost, requireStrs, costStrs
  for i = 1, #optionalStrs do
    requireStrs = string.split(optionalStrs[i], "&")
    requireCosts = {}
    for j = 1, #requireStrs do
      costStrs = string.split(requireStrs[j], "#")
      cost = {
        count = tonumber(costStrs[2]),
        optionalItems = string.stringToNumberArray(costStrs[1], "$")
      }
      table.insert(requireCosts, cost)
    end
    table.insert(self.optionalCosts, requireCosts)
  end
end
