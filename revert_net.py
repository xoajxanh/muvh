import sys

path = r'd:\MUVH\android\mu-decompiled\final\extracted_lua\NetMsgPreverifying_Map.lua'
with open(path, 'r', encoding='utf-8') as f:
    c = f.read()

target = '''local function DumpTable(node, depth, maxDepth)
    depth = depth or 1
    maxDepth = maxDepth or 3
    if depth > maxDepth then return "{...}" end
    if type(node) == "table" then
        local s = "{"
        for k, v in pairs(node) do
            s = s .. tostring(k) .. ":" .. DumpTable(v, depth + 1, maxDepth) .. ", "
        end
        return s .. "}"
    else
        return tostring(node)
    end
end
'''

if target in c:
    c = c.replace(target, '')
    with open(path, 'w', encoding='utf-8') as f:
        f.write(c)
    print('Removed DumpTable.')
else:
    print('DumpTable not found.')
