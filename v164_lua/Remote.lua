RemoteMessage = {
  ReqLoginRemote = 200001,
  ResLoginRemote = 200002,
  ReqFetchRemoteMaps = 200003,
  ResFetchRemoteMaps = 200004,
  RemoteMapServerLinkLink = 200005
}
MessageIDToName[200001] = "RemotePackage.ReqLoginRemote"
MessageIDToName[200002] = "RemotePackage.ResLoginRemote"
MessageIDToName[200003] = "RemotePackage.ReqFetchRemoteMaps"
MessageIDToName[200004] = "RemotePackage.ResFetchRemoteMaps"
MessageIDToName[200005] = "RemotePackage.RemoteMapServerLink"
Protobuf.LoadProto("Remote.proto")
