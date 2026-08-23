import os
import subprocess
import tempfile
from concurrent.futures import ThreadPoolExecutor
import UnityPy

src_bundle = "lua.mu2"
dest_dir = r"final/extracted_lua"
unluac_jar = "unluac.jar"

os.makedirs(dest_dir, exist_ok=True)

def process_asset(name, script_bytes):
    # Determine output filename
    filename = name
    if not filename.endswith('.lua') and not filename.endswith('.txt') and not filename.endswith('.bytes'):
        filename += '.lua'
    
    # Handle duplicates
    outpath = os.path.join(dest_dir, filename)
    counter = 1
    base_name, ext = os.path.splitext(outpath)
    while os.path.exists(outpath):
        outpath = f"{base_name}_{counter}{ext}"
        counter += 1
        
    os.makedirs(os.path.dirname(outpath), exist_ok=True)
    
    # Check if it's the custom xLua 5.3 format: 1B 4C 75 61 53 01
    if script_bytes.startswith(b'\x1bLuaS\x01'):
        # Patch header
        data = bytearray(script_bytes)
        data[5] = 0x00
        data.insert(14, 0x04)
        
        # Write to temp file
        fd, temp_path = tempfile.mkstemp(suffix=".lua")
        with os.fdopen(fd, 'wb') as f:
            f.write(data)
            
        # Decompile
        cmd = ["java", "-jar", unluac_jar, temp_path]
        try:
            result = subprocess.run(cmd, capture_output=True, text=True, encoding="utf-8")
            if result.returncode == 0:
                with open(outpath, "w", encoding="utf-8") as f:
                    f.write(result.stdout)
                return True
            else:
                print(f"Failed to decompile {name}: {result.stderr.strip()}")
                # Fallback to writing the raw bytes if decompilation fails
                with open(outpath + ".bytes", "wb") as f:
                    f.write(script_bytes)
                return False
        except Exception as e:
            print(f"Error processing {name}: {e}")
            return False
        finally:
            os.remove(temp_path)
    else:
        # Not a custom Lua file (could be proto text, standard lua, etc.)
        # If it's standard Lua (format 0), we could also decompile it
        if script_bytes.startswith(b'\x1bLua'):
            fd, temp_path = tempfile.mkstemp(suffix=".lua")
            with os.fdopen(fd, 'wb') as f:
                f.write(script_bytes)
            cmd = ["java", "-jar", unluac_jar, temp_path]
            try:
                result = subprocess.run(cmd, capture_output=True, text=True, encoding="utf-8")
                if result.returncode == 0:
                    with open(outpath, "w", encoding="utf-8") as f:
                        f.write(result.stdout)
                    return True
                else:
                    # Not compilable with unluac
                    with open(outpath, "wb") as f:
                        f.write(script_bytes)
                    return True
            finally:
                os.remove(temp_path)
        else:
            # Plain text or proto
            with open(outpath, "wb") as f:
                f.write(script_bytes)
            return True

def main():
    print(f"Loading {src_bundle}...")
    env = UnityPy.load(src_bundle)
    
    tasks = []
    for obj in env.objects:
        if obj.type.name == "TextAsset":
            data = obj.read()
            name = data.m_Name
            script = data.m_Script
            if isinstance(script, str):
                script = script.encode('utf-8', 'surrogateescape')
            tasks.append((name, script))
            
    print(f"Found {len(tasks)} TextAssets. Starting decompilation...")
    
    success = 0
    with ThreadPoolExecutor(max_workers=8) as executor:
        futures = [executor.submit(process_asset, name, script) for name, script in tasks]
        for idx, future in enumerate(futures):
            if future.result():
                success += 1
            if (idx + 1) % 500 == 0:
                print(f"Processed {idx + 1}/{len(tasks)} files...")
                
    print(f"Done! Successfully processed {success} out of {len(tasks)} files to {dest_dir}")

if __name__ == "__main__":
    main()
