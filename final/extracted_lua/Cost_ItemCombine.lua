Cost_ItemCombine = class()
setgetters(Cost_ItemCombine, {
  BucketCount = function(self)
    if self:CheckIsHonour() then
      return self.buckets[1].count
    else
      return table.count(self.buckets)
    end
  end
})

function Cost_ItemCombine:CheckIsHonour()
  if table.count(self.buckets) == 1 and self.buckets[1].count and 1 < self.buckets[1].count and self.buckets[1].conditions and self.buckets[1].conditions[1] and tonumber(self.buckets[1].conditions[1].param) == 42990001 then
    return true
  else
    return false
  end
end

function Cost_ItemCombine:ctor()
  self.buckets = {}
end

function Cost_ItemCombine:AddOptionalBuckets(bucketsCfg)
  if bucketsCfg then
    local bucket = {}
    bucket.count = tonumber(bucketsCfg[1][1][3])
    bucket.conditions = {}
    local condition = ConditionManager.GenerateSingleCondition(bucketsCfg[1][1])
    table.insert(bucket.conditions, condition)
    table.insert(self.buckets, bucket)
  end
end

function Cost_ItemCombine:AddRequiredBuckets(bucketsCfg)
  local bucketStrs = string.split(bucketsCfg, "&")
  local params, bucket
  for i = 1, #bucketStrs do
    params = string.stringToNumberArray(bucketStrs[i], "#")
    bucket = {
      itemId = params[1],
      count = params[2]
    }
    table.insert(self.buckets, bucket)
  end
end
