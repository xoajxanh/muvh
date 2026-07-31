import os
import subprocess
from concurrent.futures import ThreadPoolExecutor

src_dir = r"d:\MUVH\android\mu-decompiled\temp_v164"
dest_dir = r"d:\MUVH\android\mu-decompiled\v164_lua"
unluac_jar = r"d:\MUVH\android\mu-decompiled\unluac.jar"

os.makedirs(dest_dir, exist_ok=True)
files_to_process = [os.path.join(src_dir, f) for f in os.listdir(src_dir) if f.endswith(".lua")]

def process_file(filepath):
    filename = os.path.basename(filepath)
    outpath = os.path.join(dest_dir, filename)
    
    try:
        with open(filepath, 'rb') as f:
            data = bytearray(f.read())
        
        # Only patch if it is format 1 and has the expected \x1bLua signature
        if len(data) > 15 and data[0:4] == b'\x1bLua' and data[5] == 1:
            data[5] = 0
            data.insert(14, 4)
            
            patched_path = filepath + ".patched"
            with open(patched_path, 'wb') as f:
                f.write(data)
        else:
            patched_path = filepath # Not matched, try directly
            
        cmd = ["java", "-jar", unluac_jar, patched_path]
        result = subprocess.run(cmd, capture_output=True, text=True, encoding="utf-8")
        if result.returncode == 0:
            with open(outpath, "w", encoding="utf-8") as f:
                f.write(result.stdout)
            
            # remove patched file if created
            if patched_path != filepath:
                os.remove(patched_path)
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
            # print(f"Failed {filename}: {err}")
            pass

print(f"Successfully decompiled {success} out of {len(files_to_process)} files to {dest_dir}")
