import os
import subprocess
import shutil
import UnityPy
from concurrent.futures import ThreadPoolExecutor
import sys

base_dir = r"d:\MUVH\android\mu-decompiled"
unluac_jar = os.path.join(base_dir, "unluac.jar")

def extract_and_decompile(src_file, temp_dir, dest_dir, label):
    print(f"[{label}] Starting extraction from {src_file}...", flush=True)
    os.makedirs(temp_dir, exist_ok=True)
    os.makedirs(dest_dir, exist_ok=True)

    env = UnityPy.load(src_file)
    count = 0
    for obj in env.objects:
        if obj.type.name == "TextAsset":
            data = obj.read()
            script = data.m_Script
            if isinstance(script, str):
                script = script.encode('utf-8', 'surrogateescape')
            filename = data.m_Name
            if not filename.endswith('.lua') and not filename.endswith('.bytes'):
                filename += '.lua'
            filepath = os.path.join(temp_dir, filename)
            with open(filepath, "wb") as f:
                f.write(script)
            count += 1
    print(f"[{label}] Extracted {count} files to {temp_dir}", flush=True)

    files_to_process = [os.path.join(temp_dir, f) for f in os.listdir(temp_dir) if f.endswith(".lua")]

    def process_file(filepath):
        filename = os.path.basename(filepath)
        outpath = os.path.join(dest_dir, filename)
        
        try:
            with open(filepath, 'rb') as f:
                data = bytearray(f.read())
            
            if len(data) > 15 and data[0:4] == b'\x1bLua' and data[5] == 1:
                data[5] = 0
                data.insert(14, 4)
                
                patched_path = filepath + ".patched"
                with open(patched_path, 'wb') as f:
                    f.write(data)
            else:
                patched_path = filepath
                
            cmd = ["java", "-jar", unluac_jar, patched_path]
            result = subprocess.run(cmd, capture_output=True, text=True, encoding="utf-8")
            
            if patched_path != filepath and os.path.exists(patched_path):
                os.remove(patched_path)

            if result.returncode == 0:
                with open(outpath, "w", encoding="utf-8") as f:
                    f.write(result.stdout)
                return (filename, True, "")
            else:
                return (filename, False, f"Decompile error: {result.stderr}")
        except Exception as e:
            return (filename, False, f"Process error: {e}")

    print(f"[{label}] Decompiling {len(files_to_process)} files...", flush=True)
    success = 0
    with ThreadPoolExecutor(max_workers=16) as executor:
        results = executor.map(process_file, files_to_process)
        for filename, ok, err in results:
            if ok:
                success += 1

    print(f"[{label}] Decompiled {success}/{len(files_to_process)} files to {dest_dir}", flush=True)

v165_src = os.path.join(base_dir, "test_apk", "lua.mu2.v165")
v171_src = os.path.join(base_dir, "test_apk", "lua.mu2")

v165_temp = os.path.join(base_dir, "temp_v165")
v165_dest = os.path.join(base_dir, "v165_lua")

v171_temp = os.path.join(base_dir, "temp_v171")
v171_dest = os.path.join(base_dir, "v171_lua")

extract_and_decompile(v165_src, v165_temp, v165_dest, "v165")
extract_and_decompile(v171_src, v171_temp, v171_dest, "v171")
