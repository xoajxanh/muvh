import re

def main():
    with open(r'final\modified_lua_dev\EmmyluaDebug.lua', 'r', encoding='utf-8') as f:
        dev = f.read()

    with open(r'final\modified_lua_admin\EmmyluaDebug.lua', 'w', encoding='utf-8') as f:
        f.write(dev)

    cust = dev.replace('_G.Mod_IsAdmin = true', '_G.Mod_IsAdmin = false')
    # Remove the execution button code block
    cust = re.sub(r'local execBtnGo = GameObject\("AdminExecBtn"\).*?-- Token Generator Title', '-- Token Generator Title', cust, flags=re.DOTALL)
    
    with open(r'final\modified_lua_customer\EmmyluaDebug.lua', 'w', encoding='utf-8') as f:
        f.write(cust)

    print("Cloned dev to admin and customer successfully.")

if __name__ == '__main__':
    main()
