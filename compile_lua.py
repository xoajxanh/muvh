import os
import subprocess

modified_dir = os.environ.get("LUA_SRC_DIR", r"final\modified_lua")
compiled_dir = r"final\compiled_lua"
luac_exe = r"lua53\luac53.exe"

os.makedirs(compiled_dir, exist_ok=True)

for root, _, files in os.walk(modified_dir):
    for f in files:
        if f.endswith('.lua'):
            src_path = os.path.join(root, f)
            dest_path = os.path.join(compiled_dir, f) # Keep .lua extension so pack_lua finds it easily
            
            # 1. Compile
            cmd = [luac_exe, "-s", "-o", dest_path, src_path]
            subprocess.run(cmd, check=True)
            
            # Convert 64-bit size_t to 32-bit size_t
            subprocess.run(["python", "convert_64_to_32.py", dest_path, dest_path], check=True)
            
            # Patch Header
            with open(dest_path, 'rb') as file:
                data = bytearray(file.read())
                
            if data[0:4] == b'\x1bLua':
                data[5] = 0x01 # Format byte
                del data[14]   # Instruction size byte
                
                with open(dest_path, 'wb') as file:
                    file.write(data)
            
print("Compiled and patched successfully to final/compiled_lua")
