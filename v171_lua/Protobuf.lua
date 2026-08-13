Protobuf = {}
local this = Protobuf
local pb = require("pb")
local pb_unsafe = require("pb_unsafe")
local protoc = require("LuaCore/ProtoBuf/protoc")
protoc:addpath("LuaCore/Net/proto")

function Protobuf.LoadProto(path)
  protoc:loadfile(path)
end

local pools = {}

local function Create(name)
  FunctionProfiler.BeginSample(name, "Protobuf.Create")
  local msg = {_protoName = name}
  FunctionProfiler.EndSample()
  return msg
end

function Protobuf.Alloc(name)
  local pool = pools[name]
  if not pool or pool:IsEmpty() then
    return Create(name)
  end
  local msg = pool:LastValue()
  if not msg._protoDelayTime or msg._protoDelayTime < Time.time then
    msg._protoName = name
    msg._protoDelayTime = nil
    pool:PopLast()
    return msg
  end
  return Create(name)
end

function Protobuf.Recycle(msg, delay)
  if not msg then
    return false
  end
  local name = msg._protoName
  if not name then
    return false
  end
  msg._protoName = nil
  local pool = pools[name]
  if not pool then
    pool = Queue:New()
    pools[name] = pool
  end
  if delay and 0 < delay then
    msg._protoDelayTime = Time.time + delay
  end
  pool:PushFirst(msg)
  return true
end

function Protobuf.GetTemp(name)
  if not name then
    return nil
  end
  local pool = pools[name]
  if not pool then
    local msg = {}
    pool = Queue:New()
    pool:PushFirst(msg)
    return msg
  end
  if pool:IsEmpty() then
    local msg = {}
    pool:PushFirst(msg)
    return msg
  else
    return pool:LastValue()
  end
end

function Protobuf.Decode(name, buffer)
  return pb.decode(name, buffer)
end

function Protobuf.DecodeFast(name, pBuffer, size)
  local success, msg = pcall(pb_unsafe.decode, name, pBuffer, size, this.Alloc(name))
  if not success then
    logError("Decode message failed", name)
  end
  return success and msg or nil
end

function Protobuf.Encode(name, tbl)
  return pb.encode(name, tbl)
end
