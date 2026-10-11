const fs = require('fs');
const content = fs.readFileSync('./final/extracted_lua/cfg_Monster_boss.lua', 'utf8');
const blocks = content.split('mbId = ');
for (const b of blocks.slice(1)) {
  const mType = b.match(/bossType\s*=\s*(\d+)/);
  if (mType && (mType[1] == '16' || mType[1] == '17')) {
    const id = b.match(/id\s*=\s*(\d+)/)?.[1];
    const name = b.match(/name\s*=\s*"([^"]+)"/)?.[1];
    const mapId = b.match(/mapId\s*=\s*(\d+)/)?.[1];
    const killNum = b.match(/yuanGuMonsterKillNum\s*=\s*(\d+)/)?.[1];
    const dLevel = b.match(/Displaylevel\s*=\s*"([^"]+)"/)?.[1];
    console.log(JSON.stringify({ id, bossType: mType[1], mapId, killNum, dLevel, name }));
  }
}
