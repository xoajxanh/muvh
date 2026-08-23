import os
import subprocess
from concurrent.futures import ThreadPoolExecutor

src_dir = r"final/temp_lua"
dest_dir = r"final/extracted_lua"
unluac_jar = r"unluac.jar"

os.makedirs(dest_dir, exist_ok=True)

files_to_process = []
for root, _, files in os.walk(src_dir):
    for file in files:
        if file.endswith(".lua"):
            files_to_process.append(os.path.join(root, file))

def process_file(filepath):
    relpath = os.path.relpath(filepath, src_dir)
    outpath = os.path.join(dest_dir, relpath)
    os.makedirs(os.path.dirname(outpath), exist_ok=True)
    
    tmp_path = filepath + ".tmp"
    
    # Restore header
    try:
        with open(filepath, 'rb') as f:
            data = bytearray(f.read())
            
        if data[0:4] == b'\x1bLua' and data[5] == 0x01:
            data[5] = 0x00 # Change format byte to 0
            data.insert(14, 0x04) # Insert missing Instruction size byte (4)
            
        with open(tmp_path, 'wb') as f:
            f.write(data)
    except Exception as e:
        print(f"Failed to patch header for {filepath}: {e}")
        return False

    cmd = ["java", "-jar", unluac_jar, tmp_path]
    try:
        result = subprocess.run(cmd, capture_output=True, text=True, encoding="utf-8")
        if result.returncode == 0:
            with open(outpath, "w", encoding="utf-8") as f:
                f.write(result.stdout)
            # Clean up tmp
            if os.path.exists(tmp_path):
                os.remove(tmp_path)
            return True
        else:
            print(f"Failed to decompile {filepath}: {result.stderr.strip()}")
            return False
    except Exception as e:
        print(f"Error processing {filepath}: {e}")
        return False

print(f"Found {len(files_to_process)} files to decompile.")
success = 0
with ThreadPoolExecutor(max_workers=8) as executor:
    results = executor.map(process_file, files_to_process)
    for r in results:
        if r:
            success += 1

print(f"Successfully decompiled {success} out of {len(files_to_process)} files to {dest_dir}")
