const fs = require('fs');
const content = fs.readFileSync('./final/extracted_lua/cfg_Map_map.lua', 'utf8');
const blocks = content.split('{\n    id = ');
for (const b of blocks.slice(1)) {
  const idMatch = b.match(/^(\d+)/);
  if (idMatch) {
    const id = parseInt(idMatch[1]);
    if ([250001, 250002, 270001, 270002].includes(id)) {
      console.log('=== MAP ' + id + ' ===');
      console.log(b.slice(0, 500));
    }
  }
}
