import UnityPy
print('Loading...')
env = UnityPy.load('lua.mu2')
print('Saving...')
with open(r'final/test_lua/lua.mu2', 'wb') as f:
    f.write(env.file.save(packer='lz4'))
print('Done.')
