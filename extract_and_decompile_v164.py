import os
import subprocess
import shutil
import UnityPy
from concurrent.futures import ThreadPoolExecutor

src_file = r"d:\MUVH\android\test_apk\lua.mu2"
temp_dir = r"d:\MUVH\android\mu-decompiled\temp_v164"
dest_dir = r"d:\MUVH\android\mu-decompiled\v164_lua"
unluac_jar = r"d:\MUVH\android\mu-decompiled\unluac.jar"
convert_py = r"d:\MUVH\android\mu-decompiled\convert_64_to_32.py"

os.makedirs(temp_dir, exist_ok=True)
os.makedirs(dest_dir, exist_ok=True)

print("Extracting from UnityPy...")
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
print(f"Extracted {count} files to {temp_dir}")

import sys
sys.path.append(r"d:\MUVH\android\mu-decompiled")
import convert_64_to_32

files_to_process = [os.path.join(temp_dir, f) for f in os.listdir(temp_dir) if f.endswith(".lua")]

def process_file(filepath):
    filename = os.path.basename(filepath)
    outpath = os.path.join(dest_dir, filename)
    
    tmp_path = filepath + ".32.bytes"
    try:
        convert_64_to_32.convert_file(filepath, tmp_path)
    except Exception as e:
        return (filename, False, f"Convert error: {e}")
        
    cmd = ["java", "-jar", unluac_jar, tmp_path]
    try:
        result = subprocess.run(cmd, capture_output=True, text=True, encoding="utf-8")
        if result.returncode == 0:
            with open(outpath, "w", encoding="utf-8") as f:
                f.write(result.stdout)
            return (filename, True, "")
        else:
            return (filename, False, f"Decompile error: {result.stderr}")
    except Exception as e:
        return (filename, False, f"Process error: {e}")

print(f"Found {len(files_to_process)} files to decompile.")
success = 0
with ThreadPoolExecutor(max_workers=8) as executor:
    results = executor.map(process_file, files_to_process)
    for filename, ok, err in results:
        if ok:
            success += 1
        else:
            pass #print(f"Failed {filename}: {err}")

print(f"Successfully decompiled {success} out of {len(files_to_process)} files to {dest_dir}")
