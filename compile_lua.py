import os
import sys
import subprocess

script_dir = os.path.dirname(os.path.abspath(__file__))
modified_dir = os.environ.get("LUA_SRC_DIR", os.path.join("final", "modified_lua"))
if not os.path.isabs(modified_dir):
    modified_dir = os.path.join(script_dir, modified_dir)

compiled_dir = os.path.join(script_dir, "final", "compiled_lua")
luac_exe = os.path.join(script_dir, "lua53", "luac53.exe")
convert_py = os.path.join(script_dir, "convert_64_to_32.py")

os.makedirs(compiled_dir, exist_ok=True)

if not os.path.isdir(modified_dir):
    raise RuntimeError(f"[ERROR] Source Lua directory does not exist or is not a directory: {modified_dir}")

count = 0
for root, _, files in os.walk(modified_dir):
    for f in files:
        if f.endswith('.lua'):
            src_path = os.path.join(root, f)
            dest_path = os.path.join(compiled_dir, f) # Keep .lua extension so pack_lua finds it easily
            
            # 1. Compile
            cmd = [luac_exe, "-o", dest_path, src_path]
            subprocess.run(cmd, check=True)
            
            # Convert 64-bit size_t to 32-bit size_t
            subprocess.run([sys.executable, convert_py, dest_path, dest_path], check=True)
            
            # Patch Header
            with open(dest_path, 'rb') as file:
                data = bytearray(file.read())
                
            if data[0:4] == b'\x1bLua':
                data[5] = 0x01 # Format byte
                del data[14]   # Instruction size byte
                
                with open(dest_path, 'wb') as file:
                    file.write(data)
            
            count += 1
            print(f"  [OK] Compiled: {f}")

if count == 0:
    raise RuntimeError(f"[ERROR] No .lua files found in: {modified_dir}")

print(f"-> Successfully compiled {count} Lua file(s) to final/compiled_lua")

