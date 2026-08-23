# Mod Development & Deployment Workflow

1. **Ideation & Planning**: Whenever the USER requests a new feature or modification, first present the idea/plan to the USER.
2. **Development**: Wait for the USER's approval before implementing. If approved, develop and test the changes FIRST in `final\modified_lua_dev_client` (for Client/Admin features) or `final\modified_lua_dev_customer` (for Customer features).
3. **Cloning & Build Sync**: Development on dev client and dev customer is independent. When building via `build_and_update.ps1`:
   - `modified_lua_dev_client` syncs to `modified_lua_admin` (Admin) and `modified_lua_client` (Client, `_G.Mod_IsAdmin = false`).
   - `modified_lua_dev_customer` syncs to `modified_lua_customer` (Customer, `_G.Mod_IsDev = false`, `_G.Mod_IsAdmin = false`).
4. **Build Phase**: Only trigger the `build_and_update.ps1` script to build the APKs AFTER explicitly receiving the USER's permission to build.
