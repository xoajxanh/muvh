import crypto from 'crypto';

export interface TokenConfigParams {
  deviceSnMd5: string;
  characterUid: string;
  durationDays: number;
  expireAtUnix: number; // Unix timestamp in seconds
  fovMin: number;
  fovMax: number;
  bossRefreshMin: number;
  bossRefreshMax: number;
  maxMoveSpeed: number;
  maxAttackSpeed: number;
  maxMonsterRange: number;
  maxPickupCount: number;
  pickupDelayMin: number;
  pickupDelayMax: number;
  activeTabBasic: boolean;
  activeTabAdvanced: boolean;
  activeTabAutofarm: boolean;
  characterReincarnation: number;
  adminTelegrams: string[];
}

export function generateEncryptedToken(params: TokenConfigParams): { jsonConfig: string; signature: string; encryptedToken: string } {
  const configObject = {
    device_sn_hash: params.deviceSnMd5.trim(),
    character_uid: params.characterUid.trim(),
    duration: `${params.durationDays}d`,
    expire_time: params.expireAtUnix,
    fov_min: Number(params.fovMin),
    fov_max: Number(params.fovMax),
    boss_refresh_min: Number(params.bossRefreshMin),
    boss_refresh_max: Number(params.bossRefreshMax),
    max_move_speed: Number(params.maxMoveSpeed),
    max_attack_speed: Number(params.maxAttackSpeed),
    max_monster_range: Number(params.maxMonsterRange),
    max_pickup_count: Number(params.maxPickupCount),
    pickup_delay_min: Number(params.pickupDelayMin ?? 100),
    pickup_delay_max: Number(params.pickupDelayMax ?? 500),
    active_tab_basic: Boolean(params.activeTabBasic),
    active_tab_advanced: Boolean(params.activeTabAdvanced),
    active_tab_autofarm: Boolean(params.activeTabAutofarm),
    character_reincarnation: Number(params.characterReincarnation),
    admin_telegrams: Array.isArray(params.adminTelegrams) ? params.adminTelegrams : ["@admin1", "@admin2"],
  };

  const jsonConfig = JSON.stringify(configObject);
  const secretSalt = process.env.MOD_SECRET_SALT || "MUVH_SECRET_SALT_XOAI";
  
  // MD5 signature of JSON + SALT
  const signature = crypto.createHash('md5').update(jsonConfig + secretSalt).digest('hex');
  
  // Final payload envelope: JSON|SIGNATURE -> Base64
  const envelope = `${jsonConfig}|${signature}`;
  const encryptedToken = Buffer.from(envelope, 'utf-8').toString('base64');

  return {
    jsonConfig,
    signature,
    encryptedToken,
  };
}

export function decryptAndVerifyToken(base64Token: string): { valid: boolean; config?: any; error?: string } {
  try {
    const envelope = Buffer.from(base64Token, 'base64').toString('utf-8');
    const lastPipeIndex = envelope.lastIndexOf('|');
    if (lastPipeIndex === -1) {
      return { valid: false, error: 'Invalid token format' };
    }

    const jsonConfig = envelope.substring(0, lastPipeIndex);
    const signature = envelope.substring(lastPipeIndex + 1);

    const secretSalt = process.env.MOD_SECRET_SALT || "MUVH_SECRET_SALT_XOAI";
    const expectedSig = crypto.createHash('md5').update(jsonConfig + secretSalt).digest('hex');

    if (signature.toLowerCase() !== expectedSig.toLowerCase()) {
      return { valid: false, error: 'Token signature tampered or invalid' };
    }

    const config = JSON.parse(jsonConfig);
    return { valid: true, config };
  } catch (err: any) {
    return { valid: false, error: err.message || 'Token decryption failed' };
  }
}
