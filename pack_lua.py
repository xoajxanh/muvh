import os
import UnityPy

script_dir = os.path.dirname(os.path.abspath(__file__))
src_bundle = os.path.join(script_dir, "test_apk", "lua.mu2")
extracted_dir = os.path.join(script_dir, "final", "extracted_lua")
dest_bundle = os.path.join(script_dir, "final", "new_lua", "lua.mu2")
compiled_dir = os.path.join(script_dir, "final", "compiled_lua")

os.makedirs(os.path.dirname(dest_bundle), exist_ok=True)

print(f"Loading {src_bundle}...")
env = UnityPy.load(src_bundle)

# Build a map of our compiled files
files = {}
for root, _, filenames in os.walk(compiled_dir):
    for f in filenames:
        files[f.lower()] = os.path.join(root, f)

if not files:
    raise RuntimeError(f"[ERROR] No compiled Lua files found in {compiled_dir} to pack!")

replaced = 0
for obj in env.objects:
    if obj.type.name == "TextAsset":
        data = obj.read()
        name = data.m_Name
        
        # In run_all.py, we might have added .lua if it was missing extension
        search_name = name.lower()
        if not search_name.endswith('.lua') and not search_name.endswith('.txt') and not search_name.endswith('.bytes'):
            search_name += '.lua'
            
        if search_name in files:
            with open(files[search_name], 'rb') as f:
                new_bytes = bytearray(f.read())
            
            # If we were compiling to bytecode, we'd do it here. But xLua can execute raw text (.lua source code).
            # We just replace the bytes. UnityPy expects a string for m_Script.
            data.m_Script = new_bytes.decode('utf-8', 'surrogateescape')
            data.save()
            replaced += 1
            print(f"  [OK] Injected into bundle: {name}")

if replaced == 0:
    raise RuntimeError(f"[ERROR] 0 TextAssets replaced in {src_bundle}! Check compiled file names.")

print(f"-> Successfully replaced {replaced} TextAsset(s) in bundle.")

print("Saving and packing to LZ4...")
with open(dest_bundle, "wb") as f:
    if hasattr(env, 'file'):
        f.write(env.file.save(packer="lz4"))
    else:
        f.write(list(env.files.values())[0].save(packer="lz4"))

print(f"Saved to {dest_bundle}")
