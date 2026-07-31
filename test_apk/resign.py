import os
import zipfile
import subprocess
import shutil
import datetime

apk_dir = r"D:\MUVH\android\test_apk\v1"
signer_jar = r"D:\MUVH\android\test_apk\uber-apk-signer.jar"

def remove_meta_inf(apk_path):
    temp_apk = apk_path + ".tmp"
    removed_anything = False
    with zipfile.ZipFile(apk_path, 'r') as zin:
        with zipfile.ZipFile(temp_apk, 'w', zipfile.ZIP_DEFLATED) as zout:
            for item in zin.infolist():
                # Skip signature files inside META-INF folder
                name_upper = item.filename.upper()
                if name_upper.startswith("META-INF/") and (
                    name_upper == "META-INF/MANIFEST.MF" or 
                    name_upper.endswith(".RSA") or 
                    name_upper.endswith(".DSA") or 
                    name_upper.endswith(".EC") or 
                    name_upper.endswith(".SF")
                ):
                    removed_anything = True
                    continue
                buffer = zin.read(item.filename)
                zout.writestr(item, buffer)
                
    if removed_anything:
        print(f"Removed old signature from {os.path.basename(apk_path)}")
    else:
        print(f"No old signature found in {os.path.basename(apk_path)}")
        
    os.replace(temp_apk, apk_path)

target_apk = os.path.join(apk_dir, "MU_antisplit.apk")

if not os.path.exists(target_apk):
    print(f"Error: Base file {target_apk} not found!")
else:
    # 1. Generate timestamp and create a clone
    timestamp = datetime.datetime.now().strftime("%y%m%d_%H%M%S")
    cloned_apk_name = f"mu_{timestamp}.apk"
    cloned_apk_path = os.path.join(apk_dir, cloned_apk_name)
    
    print(f"Cloning {os.path.basename(target_apk)} to {cloned_apk_name}...")
    shutil.copy2(target_apk, cloned_apk_path)
    
    # 2. Remove old signatures from the clone
    print("Starting old signature removal on the clone...")
    try:
        remove_meta_inf(cloned_apk_path)
    except Exception as e:
        print(f"Error removing signatures from {cloned_apk_name}: {e}")

    # 3. Sign the clone
    print("\nStarting APK signing...")
    cmd = [
        "java", "-jar", signer_jar,
        "-a", cloned_apk_path,
        "--allowResign",
        "--overwrite",
        "--ks", r"D:\MUVH\android\test_apk\bndltool.keystore",
        "--ksAlias", "BNDLTOOL",
        "--ksKeyPass", "123456",
        "--ksPass", "123456"
    ]
    
    print(f"Running: {' '.join(cmd)}")
    subprocess.run(cmd, check=True)
    
    # 4. Clean up idsig files
    print("\nCleaning up .idsig files...")
    for f in os.listdir(apk_dir):
        if f.endswith('.idsig'):
            try:
                os.remove(os.path.join(apk_dir, f))
            except Exception as e:
                pass
                
    print(f"\nSuccessfully generated signed APK: {cloned_apk_name}")
