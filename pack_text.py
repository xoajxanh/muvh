import os
import UnityPy

src_bundle = "lua.mu2"
modified_dir = r"final/modified_lua"
dest_bundle = r"final/new_lua/lua.mu2"

os.makedirs(os.path.dirname(dest_bundle), exist_ok=True)

print(f"Loading {src_bundle}...")
env = UnityPy.load(src_bundle)

files = {}
for root, _, filenames in os.walk(modified_dir):
    for f in filenames:
        files[f.lower()] = os.path.join(root, f)

replaced = 0
for obj in env.objects:
    if obj.type.name == "TextAsset":
        data = obj.read()
        name = data.m_Name
        
        search_name = name.lower()
        if not search_name.endswith('.lua') and not search_name.endswith('.txt') and not search_name.endswith('.bytes'):
            search_name += '.lua'
            
        if search_name in files:
            with open(files[search_name], 'rb') as f:
                new_bytes = bytearray(f.read())
            
            data.m_Script = new_bytes.decode('utf-8', 'surrogateescape')
            data.save()
            replaced += 1
            print(f"Replaced {name} with RAW TEXT.")
            
print(f"Replaced {replaced} TextAssets.")

print("Saving and packing to LZ4...")
with open(dest_bundle, "wb") as f:
    f.write(env.file.save(packer="lz4"))

print(f"Saved to {dest_bundle}")
