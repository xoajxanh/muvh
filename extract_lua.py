import os
import UnityPy

def extract_assets(src, dest):
    env = UnityPy.load(src)
    os.makedirs(dest, exist_ok=True)
    count = 0
    for obj in env.objects:
        if obj.type.name == "TextAsset":
            data = obj.read()
            name = data.m_Name
            # The script property holds the bytes for TextAsset
            script = data.m_Script
            if isinstance(script, str):
                script = script.encode('utf-8', 'surrogateescape')
            filename = name
            if not filename.endswith('.lua') and not filename.endswith('.bytes'):
                filename += '.lua'
            filepath = os.path.join(dest, filename)
            # Create subdirectories if name contains paths
            os.makedirs(os.path.dirname(filepath), exist_ok=True)
            with open(filepath, "wb") as f:
                f.write(script)
            count += 1
    print(f"Extracted {count} TextAssets to {dest}")

extract_assets(r"d:\MUVH\android\test_apk\lua.mu2", r"final/temp_lua")
