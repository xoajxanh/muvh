EffectState = {
  None = enum(0),
  Ready = enum(),
  Running = enum(),
  Interrupted = enum(),
  WillDestroy = enum(),
  HaveDestory = enum()
}
SkillState = {
  None = enum(0),
  Start = enum()
}
CameraEffectType = {
  Horizontal = enum(0),
  Vertical = enum(),
  Random = enum()
}
RoleActionEnum = {
  Camera = enum(0)
}
BulletType = {
  TargetPos = enum(0),
  FollowTarget = enum(),
  SelfToTarget = enum(),
  MoveInPath = enum(),
  TargetDir = enum(),
  MoveInBezier = enum(),
  MoveInCSharpeTargetPos = enum(),
  MoveInCSharpeTargetDir = enum(),
  AroundSelfShoot = enum()
}
WeaponBulletType = {
  Normal = enum(0),
  Bezier = enum(),
  MoveInCSharpe = enum()
}
SkillEffectTargetType = {
  Self = enum(0),
  Target = enum()
}
RoleAnimationType = {
  Normal = enum(0),
  Move = enum()
}
ESkillAnimationPlayType = {
  Random = enum(0),
  Combo = enum(),
  Sequence = enum()
}
RoleBuffRemoveType = {
  AfterDie = enum(1),
  AfterRelive = enum(),
  LoopEnd = enum(),
  Collider = enum(),
  Replace = enum(),
  CastSkill = enum(),
  ClientCancel = enum()
}
ESKillCastType = {
  Initiative = enum(1),
  Passive = enum(),
  Combo = enum(),
  SubSkill = enum(),
  Disposable = enum()
}
SkillGroupEnum = {
  GuiMeiSkill = 90291,
  XiFengCi = 11110100,
  XinChengYiNu = 12210100,
  ShengLingMonster = 90511,
  ShengLingPlayer = 10000300,
  PiLiXuanFengZhan = 11070100,
  ZhiMingYiJi = 11130100
}
