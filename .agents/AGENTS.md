# Mod Development & Deployment Workflow

1. **Ideation & Planning**: Whenever the USER requests a new feature or modification, first present the idea/plan to the USER.
2. **Development**: Wait for the USER's approval before implementing. If approved, develop and test the changes FIRST in the `final\modified_lua_dev` directory.
3. **Cloning**: After development on dev is finalized, clone the changes to `final\modified_lua_customer`. **Remember**: Always maintain the distinction (e.g. remove the 'Execute' hot script button in the customer build).
4. **Build Phase**: Only trigger the `build_and_update.ps1` script to build the APKs AFTER explicitly receiving the USER's permission to build.
