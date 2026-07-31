import UnityPy
env = UnityPy.load(r'final/new_lua/lua.mu2')
for obj in env.objects:
    if obj.type.name == 'TextAsset':
        data = obj.read()
        if data.m_Name == 'MainCamera':
            script = data.script if hasattr(data, 'script') else data.m_Script
            if isinstance(script, str):
                script = script.encode('utf-8', 'surrogateescape')
            print('Found MainCamera. Length:', len(script))
            print('First 100 bytes:')
            print(script[:100])
            break
