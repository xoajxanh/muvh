local cfg_Chat_chat = {
  {
    id = 1000,
    priority = 9999,
    style = 1,
    systemChat = "%s",
    conductType = "2"
  },
  {
    id = 1001,
    type = "2",
    priority = 9999,
    style = 1,
    systemChat = "%s",
    conductType = "9"
  },
  {
    id = 1004,
    style = 1,
    systemChat = "Ch\195\186c m\225\187\171ng <color=#FBD994>%s</color> \196\145\195\163 t\196\131ng $1<a href=[system:1]>%s</a></color> l\195\170n \196\145\225\186\191n <color=#FF0000>c\198\176\225\187\157ng h\195\179a +7</color>, nh\225\186\173n \196\145\198\176\225\187\163c hi\225\187\135u qu\225\186\163 v\195\178ng s\195\161ng ho\195\160n to\195\160n m\225\187\155i!",
    remarks = "0: T\195\170n ng\198\176\225\187\157i ch\198\161i, 1: T\195\170n \196\145\225\186\161o c\225\187\165",
    condition = "2006#7",
    acceptCondition = {
      {101, 30}
    },
    conductType = "2"
  },
  {
    id = 1005,
    priority = 4,
    style = 1,
    systemChat = "Ch\195\186c m\225\187\171ng <color=#FBD994>%s</color> \196\145\195\163 t\196\131ng <color=#139D29>%s</color> l\195\170n \196\145\225\186\191n <color=#139D29>buff 4</color>, thu\225\187\153c t\195\173nh t\196\131ng nhi\225\187\129u! <color=#139D29>Ta mu\225\187\145n buff</color>",
    remarks = "0: T\195\170n ng\198\176\225\187\157i ch\198\161i, 1: T\195\170n \196\145\225\186\161o c\225\187\165",
    condition = "101#501",
    acceptCondition = {
      {101, 501}
    },
    conductType = "2"
  },
  {
    id = 1006,
    priority = 2,
    systemChat = "Ch\195\160o m\225\187\171ng v\195\160o <color=#3CD937>%s</color>",
    remarks = "%s: T\195\170n b\225\186\163n \196\145\225\187\147",
    conductType = "0"
  },
  {
    id = 1007,
    type = "2",
    priority = 3,
    style = 1,
    systemChat = "Ch\195\186c m\225\187\171ng <color=#FBD994>%s</color> \196\145\195\163 t\196\131ng <color=#139D29>%s</color> l\195\170n \196\145\225\186\191n <color=#139D29>c\198\176\225\187\157ng h\195\179a +7</color>, thu\225\187\153c t\195\173nh t\196\131ng nhi\225\187\129u!",
    remarks = "0: T\195\170n ng\198\176\225\187\157i ch\198\161i, 1: T\195\170n \196\145\225\186\161o c\225\187\165",
    jumpUi = "Equip_IntensifyUI",
    condition = "101#501",
    acceptCondition = {
      {101, 501}
    },
    conductType = "2"
  },
  {
    id = 1008,
    type = "2",
    priority = 4,
    style = 1,
    systemChat = "Ch\195\186c m\225\187\171ng <color=#FBD994>%s</color> \196\145\195\163 t\196\131ng <color=#139D29>%s</color> l\195\170n \196\145\225\186\191n <color=#139D29>buff 4</color>, thu\225\187\153c t\195\173nh t\196\131ng nhi\225\187\129u!",
    remarks = "0: T\195\170n ng\198\176\225\187\157i ch\198\161i, 1: T\195\170n \196\145\225\186\161o c\225\187\165",
    jumpUi = "Equip_ZhuijiaUI",
    condition = "101#501",
    acceptCondition = {
      {101, 501}
    },
    conductType = "2"
  },
  {
    id = 1011,
    type = "1&3",
    style = 2,
    systemChat = "<color=#FBD994>%s</color> m\225\187\159 $1<a href=[system:1]>%s</a></color> v\195\160 nh\225\186\173n \196\145\198\176\225\187\163c $1<a href=[system:2]>%s</a></color>",
    acceptCondition = {
      {101, 70}
    },
    conductType = "2"
  },
  {id = 1012, conductType = "2"},
  {
    id = 1013,
    type = "1&3",
    style = 2,
    systemChat = "<color=#FBD994>%s</color> \196\145\195\163 gh\195\169p \196\145\198\176\225\187\163c $1<a href=[system:1]>%s</a></color>",
    conductType = "2"
  },
  {
    id = 1014,
    type = "1&3",
    style = 2,
    systemChat = "<color=#FBD994>%s</color> \196\145\195\163 gh\195\169p \196\145\198\176\225\187\163c $1<a href=[system:1]>%s</a></color>",
    conductType = "2"
  },
  {
    id = 1020,
    type = "1&3",
    style = 2,
    systemChat = "10 ph\195\186t sau s\225\186\189 m\225\187\159 Li\195\170n Server!!!",
    acceptCondition = {
      {101, 300}
    },
    conductType = "0"
  },
  {
    id = 1021,
    type = "1&3",
    style = 2,
    systemChat = "5 ph\195\186t sau s\225\186\189 m\225\187\159 Li\195\170n Server!!!",
    acceptCondition = {
      {101, 300}
    },
    conductType = "0"
  },
  {
    id = 1022,
    type = "1&3",
    style = 2,
    systemChat = "2 ph\195\186t sau s\225\186\189 m\225\187\159 Li\195\170n Server!!!",
    countdown = 60,
    acceptCondition = {
      {101, 300}
    },
    conductType = "0"
  },
  {
    id = 1030,
    type = "1&3",
    style = 2,
    systemChat = "10 ph\195\186t sau s\225\186\189 m\225\187\159 G\225\187\153p SV!!!",
    acceptCondition = {
      {101, 300}
    },
    conductType = "0"
  },
  {
    id = 1031,
    type = "1&3",
    style = 2,
    systemChat = "5 ph\195\186t sau s\225\186\189 m\225\187\159 G\225\187\153p SV!!!",
    acceptCondition = {
      {101, 300}
    },
    conductType = "0"
  },
  {
    id = 1032,
    type = "1&3",
    style = 2,
    systemChat = "2 ph\195\186t sau s\225\186\189 m\225\187\159 G\225\187\153p SV!!!",
    countdown = 60,
    acceptCondition = {
      {101, 300}
    },
    conductType = "0"
  },
  {
    id = 10150103,
    systemChat = "<color=#FBD994>%s</color> m\225\187\159 $1<a href=[system:1]>%s</a></color> v\195\160 nh\225\186\173n \196\145\198\176\225\187\163c $1<a href=[system:2]>%s</a></color>",
    acceptCondition = {
      {101, 30},
      {103, 40}
    },
    conductType = "2"
  },
  {
    id = 10150104,
    systemChat = "<color=#FBD994>%s</color> m\225\187\159 $1<a href=[system:1]>%s</a></color> v\195\160 nh\225\186\173n \196\145\198\176\225\187\163c $1<a href=[system:2]>%s</a></color>",
    acceptCondition = {
      {101, 40},
      {103, 70}
    },
    conductType = "2"
  },
  {
    id = 10150105,
    systemChat = "<color=#FBD994>%s</color> m\225\187\159 $1<a href=[system:1]>%s</a></color> v\195\160 nh\225\186\173n \196\145\198\176\225\187\163c $1<a href=[system:2]>%s</a></color>",
    acceptCondition = {
      {101, 50},
      {103, 100}
    },
    conductType = "2"
  },
  {
    id = 10150204,
    systemChat = "<color=#FBD994>%s</color> m\225\187\159 $1<a href=[system:1]>%s</a></color> v\195\160 nh\225\186\173n \196\145\198\176\225\187\163c $1<a href=[system:2]>%s</a></color>",
    acceptCondition = {
      {101, 40},
      {103, 170}
    },
    conductType = "2"
  },
  {
    id = 10150205,
    systemChat = "<color=#FBD994>%s</color> m\225\187\159 $1<a href=[system:1]>%s</a></color> v\195\160 nh\225\186\173n \196\145\198\176\225\187\163c $1<a href=[system:2]>%s</a></color>",
    acceptCondition = {
      {101, 50},
      {103, 200}
    },
    conductType = "2"
  },
  {
    id = 10150206,
    systemChat = "<color=#FBD994>%s</color> m\225\187\159 $1<a href=[system:1]>%s</a></color> v\195\160 nh\225\186\173n \196\145\198\176\225\187\163c $1<a href=[system:2]>%s</a></color>",
    acceptCondition = {
      {101, 100},
      {103, 250}
    },
    conductType = "2"
  },
  {
    id = 10150207,
    systemChat = "<color=#FBD994>%s</color> m\225\187\159 $1<a href=[system:1]>%s</a></color> v\195\160 nh\225\186\173n \196\145\198\176\225\187\163c $1<a href=[system:2]>%s</a></color>",
    acceptCondition = {
      {101, 150},
      {103, 300}
    },
    conductType = "2"
  },
  {
    id = 10150208,
    systemChat = "<color=#FBD994>%s</color> m\225\187\159 $1<a href=[system:1]>%s</a></color> v\195\160 nh\225\186\173n \196\145\198\176\225\187\163c $1<a href=[system:2]>%s</a></color>",
    acceptCondition = {
      {101, 200},
      {103, 350}
    },
    conductType = "2"
  },
  {
    id = 10150209,
    systemChat = "<color=#FBD994>%s</color> m\225\187\159 $1<a href=[system:1]>%s</a></color> v\195\160 nh\225\186\173n \196\145\198\176\225\187\163c $1<a href=[system:2]>%s</a></color>",
    acceptCondition = {
      {101, 250},
      {103, 400}
    },
    conductType = "2"
  },
  {
    id = 10150210,
    systemChat = "<color=#FBD994>%s</color> m\225\187\159 $1<a href=[system:1]>%s</a></color> v\195\160 nh\225\186\173n \196\145\198\176\225\187\163c $1<a href=[system:2]>%s</a></color>",
    acceptCondition = {
      {101, 250},
      {103, 450}
    },
    conductType = "2"
  },
  {
    id = 10150211,
    systemChat = "<color=#FBD994>%s</color> m\225\187\159 $1<a href=[system:1]>%s</a></color> v\195\160 nh\225\186\173n \196\145\198\176\225\187\163c $1<a href=[system:2]>%s</a></color>",
    acceptCondition = {
      {101, 250},
      {103, 500}
    },
    conductType = "2"
  },
  {
    id = 10150212,
    systemChat = "<color=#FBD994>%s</color> m\225\187\159 $1<a href=[system:1]>%s</a></color> v\195\160 nh\225\186\173n \196\145\198\176\225\187\163c $1<a href=[system:2]>%s</a></color>",
    acceptCondition = {
      {101, 250},
      {103, 500}
    },
    conductType = "2"
  },
  {
    id = 1200,
    systemChat = "Ch\195\186c m\225\187\171ng <color=#FBD994>%s</color> c\198\176\225\187\157ng h\195\179a $1<a href=[system:1]>%s</a></color> \196\145\225\186\191n <color=#FF0000>+3</color>!",
    condition = "2006#3",
    acceptCondition = {
      {101, 20},
      {103, 120}
    },
    conductType = "2"
  },
  {
    id = 1201,
    systemChat = "Ch\195\186c m\225\187\171ng <color=#FBD994>%s</color> c\198\176\225\187\157ng h\195\179a $1<a href=[system:1]>%s</a></color> \196\145\225\186\191n <color=#FF0000>+5</color>!",
    condition = "2006#5",
    acceptCondition = {
      {101, 20},
      {103, 160}
    },
    conductType = "2"
  },
  {
    id = 1202,
    systemChat = "Ch\195\186c m\225\187\171ng <color=#FBD994>%s</color> \196\145\195\163 t\196\131ng $1<a href=[system:1]>%s</a></color> l\195\170n \196\145\225\186\191n <color=#FF0000>c\198\176\225\187\157ng h\195\179a +7</color>, nh\225\186\173n \196\145\198\176\225\187\163c hi\225\187\135u qu\225\186\163 v\195\178ng s\195\161ng ho\195\160n to\195\160n m\225\187\155i!",
    condition = "2006#7",
    acceptCondition = {
      {101, 20},
      {103, 200}
    },
    conductType = "2"
  },
  {
    id = 1203,
    systemChat = "Ch\195\186c m\225\187\171ng <color=#FBD994>%s</color> \196\145\195\163 t\196\131ng $1<a href=[system:1]>%s</a></color> l\195\170n \196\145\225\186\191n <color=#FF0000>c\198\176\225\187\157ng h\195\179a +9</color>, nh\225\186\173n \196\145\198\176\225\187\163c hi\225\187\135u qu\225\186\163 v\195\178ng s\195\161ng ho\195\160n to\195\160n m\225\187\155i!",
    condition = "2006#9",
    acceptCondition = {
      {101, 40},
      {103, 250}
    },
    conductType = "2"
  },
  {
    id = 1204,
    systemChat = "Ch\195\186c m\225\187\171ng <color=#FBD994>%s</color> c\198\176\225\187\157ng h\195\179a $1<a href=[system:1]>%s</a></color> \196\145\225\186\191n <color=#FF0000>+11</color>!",
    condition = "2006#11",
    acceptCondition = {
      {101, 60},
      {103, 300}
    },
    conductType = "2"
  },
  {
    id = 1205,
    systemChat = "Ch\195\186c m\225\187\171ng <color=#FBD994>%s</color> c\198\176\225\187\157ng h\195\179a $1<a href=[system:1]>%s</a></color> \196\145\225\186\191n <color=#FF0000>+15</color>!",
    condition = "2006#15",
    acceptCondition = {
      {101, 80},
      {103, 350}
    },
    conductType = "2"
  },
  {
    id = 1206,
    systemChat = "Ch\195\186c m\225\187\171ng <color=#FBD994>%s</color> c\198\176\225\187\157ng h\195\179a $1<a href=[system:1]>%s</a></color> \196\145\225\186\191n <color=#FF0000>+30</color>!",
    condition = "2006#30",
    acceptCondition = {
      {101, 100},
      {103, 400}
    },
    conductType = "2"
  },
  {
    id = 1207,
    systemChat = "Ch\195\186c m\225\187\171ng <color=#FBD994>%s</color> c\198\176\225\187\157ng h\195\179a $1<a href=[system:1]>%s</a></color> \196\145\225\186\191n <color=#FF0000>+45</color>!",
    condition = "2006#45",
    acceptCondition = {
      {101, 150}
    },
    conductType = "2"
  },
  {
    id = 1208,
    systemChat = "Ch\195\186c m\225\187\171ng <color=#FBD994>%s</color> c\198\176\225\187\157ng h\195\179a $1<a href=[system:1]>%s</a></color> \196\145\225\186\191n <color=#FF0000>+60</color>!",
    condition = "2006#60",
    acceptCondition = {
      {101, 200}
    },
    conductType = "2"
  },
  {
    id = 1209,
    systemChat = "Ch\195\186c m\225\187\171ng <color=#FBD994>%s</color> c\198\176\225\187\157ng h\195\179a $1<a href=[system:1]>%s</a></color> \196\145\225\186\191n <color=#FF0000>+81</color>!",
    condition = "2006#81",
    acceptCondition = {
      {101, 250}
    },
    conductType = "2"
  },
  {
    id = 1210,
    systemChat = "Ch\195\186c m\225\187\171ng <color=#FBD994>%s</color> c\198\176\225\187\157ng h\195\179a $1<a href=[system:1]>%s</a></color> \196\145\225\186\191n <color=#FF0000>+153</color>!",
    condition = "2006#153",
    acceptCondition = {
      {101, 300}
    },
    conductType = "2"
  },
  {
    id = 1211,
    systemChat = "Ch\195\186c m\225\187\171ng <color=#FBD994>%s</color> c\198\176\225\187\157ng h\195\179a $1<a href=[system:1]>%s</a></color> \196\145\225\186\191n <color=#FF0000>+225</color>!",
    condition = "2006#225",
    acceptCondition = {
      {101, 400}
    },
    conductType = "2"
  },
  {
    id = 1212,
    systemChat = "Ch\195\186c m\225\187\171ng <color=#FBD994>%s</color> c\198\176\225\187\157ng h\195\179a $1<a href=[system:1]>%s</a></color> \196\145\225\186\191n <color=#FF0000>+297</color>!",
    condition = "2006#297",
    acceptCondition = {
      {101, 800}
    },
    conductType = "2"
  },
  {
    id = 1213,
    systemChat = "Ch\195\186c m\225\187\171ng <color=#FBD994>%s</color> c\198\176\225\187\157ng h\195\179a $1<a href=[system:1]>%s</a></color> \196\145\225\186\191n <color=#FF0000>+369</color>!",
    condition = "2006#369",
    acceptCondition = {
      {101, 1200}
    },
    conductType = "2"
  },
  {
    id = 1214,
    systemChat = "Ch\195\186c m\225\187\171ng <color=#FBD994>%s</color> c\198\176\225\187\157ng h\195\179a $1<a href=[system:1]>%s</a></color> \196\145\225\186\191n <color=#FF0000>+441</color>!",
    condition = "2006#441",
    acceptCondition = {
      {101, 1600}
    },
    conductType = "2"
  },
  {
    id = 1215,
    systemChat = "Ch\195\186c m\225\187\171ng <color=#FBD994>%s</color> c\198\176\225\187\157ng h\195\179a $1<a href=[system:1]>%s</a></color> \196\145\225\186\191n <color=#FF0000>+513</color>!",
    condition = "2006#513",
    acceptCondition = {
      {101, 2000}
    },
    conductType = "2"
  },
  {
    id = 1216,
    systemChat = "Ch\195\186c m\225\187\171ng <color=#FBD994>%s</color> c\198\176\225\187\157ng h\195\179a $1<a href=[system:1]>%s</a></color> \196\145\225\186\191n <color=#FF0000>+585</color>!",
    condition = "2006#585",
    acceptCondition = {
      {101, 2400}
    },
    conductType = "2"
  },
  {
    id = 1217,
    systemChat = "Ch\195\186c m\225\187\171ng <color=#FBD994>%s</color> c\198\176\225\187\157ng h\195\179a $1<a href=[system:1]>%s</a></color> \196\145\225\186\191n <color=#FF0000>+657</color>!",
    condition = "2006#657",
    acceptCondition = {
      {101, 2800}
    },
    conductType = "2"
  },
  {
    id = 1218,
    systemChat = "Ch\195\186c m\225\187\171ng <color=#FBD994>%s</color> c\198\176\225\187\157ng h\195\179a $1<a href=[system:1]>%s</a></color> \196\145\225\186\191n <color=#FF0000>+729</color>!",
    condition = "2006#729",
    acceptCondition = {
      {101, 3200}
    },
    conductType = "2"
  },
  {
    id = 1219,
    systemChat = "Ch\195\186c m\225\187\171ng <color=#FBD994>%s</color> c\198\176\225\187\157ng h\195\179a $1<a href=[system:1]>%s</a></color> \196\145\225\186\191n <color=#FF0000>+801</color>!",
    condition = "2006#801",
    acceptCondition = {
      {101, 3600}
    },
    conductType = "2"
  },
  {
    id = 1101,
    remarks = "Ph\225\186\161m vi c\225\186\165p c\195\179 th\225\187\131 th\225\186\165y: 40~150",
    acceptCondition = {
      {101, 40},
      {103, 170}
    },
    conductType = "2"
  },
  {
    id = 1102,
    remarks = "Ph\225\186\161m vi c\225\186\165p c\195\179 th\225\187\131 th\225\186\165y: 50~200",
    acceptCondition = {
      {101, 50},
      {103, 200}
    },
    conductType = "2"
  },
  {
    id = 1103,
    remarks = "Ph\225\186\161m vi c\225\186\165p c\195\179 th\225\187\131 th\225\186\165y: 100~250",
    acceptCondition = {
      {101, 100},
      {103, 250}
    },
    conductType = "2"
  },
  {
    id = 1104,
    remarks = "Ph\225\186\161m vi c\225\186\165p c\195\179 th\225\187\131 th\225\186\165y: 150~300",
    acceptCondition = {
      {101, 150},
      {103, 300}
    },
    conductType = "2"
  },
  {
    id = 1105,
    remarks = "Ph\225\186\161m vi c\225\186\165p c\195\179 th\225\187\131 th\225\186\165y: 200~350",
    acceptCondition = {
      {101, 200},
      {103, 350}
    },
    conductType = "2"
  },
  {
    id = 1106,
    remarks = "Ph\225\186\161m vi c\225\186\165p c\195\179 th\225\187\131 th\225\186\165y: 250~400",
    acceptCondition = {
      {101, 250},
      {103, 400}
    },
    conductType = "2"
  },
  {
    id = 1107,
    remarks = "Ph\225\186\161m vi c\225\186\165p c\195\179 th\225\187\131 th\225\186\165y: 250~450",
    acceptCondition = {
      {101, 250},
      {103, 450}
    },
    conductType = "2"
  },
  {
    id = 1108,
    remarks = "Ph\225\186\161m vi c\225\186\165p c\195\179 th\225\187\131 th\225\186\165y: 250~500",
    acceptCondition = {
      {101, 250},
      {103, 500}
    },
    conductType = "2"
  },
  {
    id = 1109,
    remarks = "Ph\225\186\161m vi c\225\186\165p c\195\179 th\225\187\131 th\225\186\165y: 250~500",
    acceptCondition = {
      {101, 250},
      {103, 500}
    },
    conductType = "2"
  },
  {
    id = 1111,
    acceptCondition = {
      {101, 30},
      {103, 40}
    },
    conductType = "2"
  },
  {
    id = 1112,
    acceptCondition = {
      {101, 40},
      {103, 70}
    },
    conductType = "2"
  },
  {
    id = 1113,
    acceptCondition = {
      {101, 50},
      {103, 100}
    },
    conductType = "2"
  },
  {
    id = 1131,
    systemChat = "<color=#FBD994>%s</color> \225\187\159 <color=#FBD994>%s</color> ti\195\170u di\225\187\135t <color=#e6e600>%s</color> v\195\160 r\225\187\155t $1<a href=[system:1]>%s</a></color>",
    remarks = "Ph\225\186\161m vi c\225\186\165p c\195\179 th\225\187\131 th\225\186\165y: 40~150",
    acceptCondition = {
      {101, 40},
      {103, 170}
    },
    conductType = "2"
  },
  {
    id = 1132,
    systemChat = "<color=#FBD994>%s</color> \225\187\159 <color=#FBD994>%s</color> ti\195\170u di\225\187\135t <color=#e6e600>%s</color> v\195\160 r\225\187\155t $1<a href=[system:1]>%s</a></color>",
    remarks = "Ph\225\186\161m vi c\225\186\165p c\195\179 th\225\187\131 th\225\186\165y: 50~200",
    acceptCondition = {
      {101, 50},
      {103, 200}
    },
    conductType = "2"
  },
  {
    id = 1133,
    systemChat = "<color=#FBD994>%s</color> \225\187\159 <color=#FBD994>%s</color> ti\195\170u di\225\187\135t <color=#e6e600>%s</color> v\195\160 r\225\187\155t $1<a href=[system:1]>%s</a></color>",
    remarks = "Ph\225\186\161m vi c\225\186\165p c\195\179 th\225\187\131 th\225\186\165y: 100~250",
    acceptCondition = {
      {101, 100},
      {103, 250}
    },
    conductType = "2"
  },
  {
    id = 1134,
    systemChat = "<color=#FBD994>%s</color> \225\187\159 <color=#FBD994>%s</color> ti\195\170u di\225\187\135t <color=#e6e600>%s</color> v\195\160 r\225\187\155t $1<a href=[system:1]>%s</a></color>",
    remarks = "Ph\225\186\161m vi c\225\186\165p c\195\179 th\225\187\131 th\225\186\165y: 150~300",
    acceptCondition = {
      {101, 150},
      {103, 300}
    },
    conductType = "2"
  },
  {
    id = 1135,
    systemChat = "<color=#FBD994>%s</color> \225\187\159 <color=#FBD994>%s</color> ti\195\170u di\225\187\135t <color=#e6e600>%s</color> v\195\160 r\225\187\155t $1<a href=[system:1]>%s</a></color>",
    remarks = "Ph\225\186\161m vi c\225\186\165p c\195\179 th\225\187\131 th\225\186\165y: 200~350",
    acceptCondition = {
      {101, 200},
      {103, 350}
    },
    conductType = "2"
  },
  {
    id = 1136,
    systemChat = "<color=#FBD994>%s</color> \225\187\159 <color=#FBD994>%s</color> ti\195\170u di\225\187\135t <color=#e6e600>%s</color> v\195\160 r\225\187\155t $1<a href=[system:1]>%s</a></color>",
    remarks = "Ph\225\186\161m vi c\225\186\165p c\195\179 th\225\187\131 th\225\186\165y: 250~400",
    acceptCondition = {
      {101, 250},
      {103, 400}
    },
    conductType = "2"
  },
  {
    id = 1137,
    systemChat = "<color=#FBD994>%s</color> \225\187\159 <color=#FBD994>%s</color> ti\195\170u di\225\187\135t <color=#e6e600>%s</color> v\195\160 r\225\187\155t $1<a href=[system:1]>%s</a></color>",
    remarks = "Ph\225\186\161m vi c\225\186\165p c\195\179 th\225\187\131 th\225\186\165y: 250~450",
    acceptCondition = {
      {101, 250},
      {103, 450}
    },
    conductType = "2"
  },
  {
    id = 1138,
    systemChat = "<color=#FBD994>%s</color> \225\187\159 <color=#FBD994>%s</color> ti\195\170u di\225\187\135t <color=#e6e600>%s</color> v\195\160 r\225\187\155t $1<a href=[system:1]>%s</a></color>",
    remarks = "Ph\225\186\161m vi c\225\186\165p c\195\179 th\225\187\131 th\225\186\165y: 250~500",
    acceptCondition = {
      {101, 250},
      {103, 500}
    },
    conductType = "2"
  },
  {
    id = 1139,
    systemChat = "<color=#FBD994>%s</color> \225\187\159 <color=#FBD994>%s</color> ti\195\170u di\225\187\135t <color=#e6e600>%s</color> v\195\160 r\225\187\155t $1<a href=[system:1]>%s</a></color>",
    remarks = "Ph\225\186\161m vi c\225\186\165p c\195\179 th\225\187\131 th\225\186\165y: 250~500",
    acceptCondition = {
      {101, 250},
      {103, 500}
    },
    conductType = "2"
  },
  {
    id = 1141,
    systemChat = "<color=#FBD994>%s</color> \225\187\159 <color=#FBD994>%s</color> ti\195\170u di\225\187\135t <color=#e6e600>%s</color> v\195\160 r\225\187\155t $1<a href=[system:1]>%s</a></color>",
    acceptCondition = {
      {101, 30},
      {103, 40}
    },
    conductType = "2"
  },
  {
    id = 1142,
    systemChat = "<color=#FBD994>%s</color> \225\187\159 <color=#FBD994>%s</color> ti\195\170u di\225\187\135t <color=#e6e600>%s</color> v\195\160 r\225\187\155t $1<a href=[system:1]>%s</a></color>",
    acceptCondition = {
      {101, 40},
      {103, 70}
    },
    conductType = "2"
  },
  {
    id = 1143,
    systemChat = "<color=#FBD994>%s</color> \225\187\159 <color=#FBD994>%s</color> ti\195\170u di\225\187\135t <color=#e6e600>%s</color> v\195\160 r\225\187\155t $1<a href=[system:1]>%s</a></color>",
    acceptCondition = {
      {101, 50},
      {103, 100}
    },
    conductType = "2"
  },
  {
    id = 110120,
    remarks = "Ph\225\186\161m vi c\225\186\165p c\195\179 th\225\187\131 th\225\186\165y: 40~150",
    conductType = "2"
  },
  {
    id = 110220,
    remarks = "Ph\225\186\161m vi c\225\186\165p c\195\179 th\225\187\131 th\225\186\165y: 50~200",
    conductType = "2"
  },
  {
    id = 110320,
    remarks = "Ph\225\186\161m vi c\225\186\165p c\195\179 th\225\187\131 th\225\186\165y: 100~250",
    conductType = "2"
  },
  {
    id = 110420,
    remarks = "Ph\225\186\161m vi c\225\186\165p c\195\179 th\225\187\131 th\225\186\165y: 150~300",
    conductType = "2"
  },
  {
    id = 110520,
    remarks = "Ph\225\186\161m vi c\225\186\165p c\195\179 th\225\187\131 th\225\186\165y: 200~350",
    conductType = "2"
  },
  {
    id = 110620,
    remarks = "Ph\225\186\161m vi c\225\186\165p c\195\179 th\225\187\131 th\225\186\165y: 250~400",
    conductType = "2"
  },
  {
    id = 110720,
    remarks = "Ph\225\186\161m vi c\225\186\165p c\195\179 th\225\187\131 th\225\186\165y: 250~450",
    conductType = "2"
  },
  {
    id = 110820,
    remarks = "Ph\225\186\161m vi c\225\186\165p c\195\179 th\225\187\131 th\225\186\165y: 250~500",
    conductType = "2"
  },
  {
    id = 110920,
    remarks = "Ph\225\186\161m vi c\225\186\165p c\195\179 th\225\187\131 th\225\186\165y: 250~500",
    conductType = "2"
  },
  {
    id = 111120,
    acceptCondition = {
      {101, 30},
      {103, 40}
    },
    conductType = "2"
  },
  {
    id = 111220,
    acceptCondition = {
      {101, 40},
      {103, 70}
    },
    conductType = "2"
  },
  {
    id = 111320,
    acceptCondition = {
      {101, 50},
      {103, 100}
    },
    conductType = "2"
  },
  {
    id = 113120,
    systemChat = "<color=#FBD994>%s</color> \225\187\159 <color=#FBD994>%s</color> ti\195\170u di\225\187\135t <color=#e6e600>%s</color> v\195\160 r\225\187\155t $1<a href=[system:1]>%s</a></color>",
    remarks = "Ph\225\186\161m vi c\225\186\165p c\195\179 th\225\187\131 th\225\186\165y: 40~150",
    conductType = "2"
  },
  {
    id = 113220,
    systemChat = "<color=#FBD994>%s</color> \225\187\159 <color=#FBD994>%s</color> ti\195\170u di\225\187\135t <color=#e6e600>%s</color> v\195\160 r\225\187\155t $1<a href=[system:1]>%s</a></color>",
    remarks = "Ph\225\186\161m vi c\225\186\165p c\195\179 th\225\187\131 th\225\186\165y: 50~200",
    conductType = "2"
  },
  {
    id = 113320,
    systemChat = "<color=#FBD994>%s</color> \225\187\159 <color=#FBD994>%s</color> ti\195\170u di\225\187\135t <color=#e6e600>%s</color> v\195\160 r\225\187\155t $1<a href=[system:1]>%s</a></color>",
    remarks = "Ph\225\186\161m vi c\225\186\165p c\195\179 th\225\187\131 th\225\186\165y: 100~250",
    conductType = "2"
  },
  {
    id = 113420,
    systemChat = "<color=#FBD994>%s</color> \225\187\159 <color=#FBD994>%s</color> ti\195\170u di\225\187\135t <color=#e6e600>%s</color> v\195\160 r\225\187\155t $1<a href=[system:1]>%s</a></color>",
    remarks = "Ph\225\186\161m vi c\225\186\165p c\195\179 th\225\187\131 th\225\186\165y: 150~300",
    conductType = "2"
  },
  {
    id = 113520,
    systemChat = "<color=#FBD994>%s</color> \225\187\159 <color=#FBD994>%s</color> ti\195\170u di\225\187\135t <color=#e6e600>%s</color> v\195\160 r\225\187\155t $1<a href=[system:1]>%s</a></color>",
    remarks = "Ph\225\186\161m vi c\225\186\165p c\195\179 th\225\187\131 th\225\186\165y: 200~350",
    conductType = "2"
  },
  {
    id = 113620,
    systemChat = "<color=#FBD994>%s</color> \225\187\159 <color=#FBD994>%s</color> ti\195\170u di\225\187\135t <color=#e6e600>%s</color> v\195\160 r\225\187\155t $1<a href=[system:1]>%s</a></color>",
    remarks = "Ph\225\186\161m vi c\225\186\165p c\195\179 th\225\187\131 th\225\186\165y: 250~400",
    conductType = "2"
  },
  {
    id = 113720,
    systemChat = "<color=#FBD994>%s</color> \225\187\159 <color=#FBD994>%s</color> ti\195\170u di\225\187\135t <color=#e6e600>%s</color> v\195\160 r\225\187\155t $1<a href=[system:1]>%s</a></color>",
    remarks = "Ph\225\186\161m vi c\225\186\165p c\195\179 th\225\187\131 th\225\186\165y: 250~450",
    conductType = "2"
  },
  {
    id = 113820,
    systemChat = "<color=#FBD994>%s</color> \225\187\159 <color=#FBD994>%s</color> ti\195\170u di\225\187\135t <color=#e6e600>%s</color> v\195\160 r\225\187\155t $1<a href=[system:1]>%s</a></color>",
    remarks = "Ph\225\186\161m vi c\225\186\165p c\195\179 th\225\187\131 th\225\186\165y: 250~500",
    conductType = "2"
  },
  {
    id = 113920,
    systemChat = "<color=#FBD994>%s</color> \225\187\159 <color=#FBD994>%s</color> ti\195\170u di\225\187\135t <color=#e6e600>%s</color> v\195\160 r\225\187\155t $1<a href=[system:1]>%s</a></color>",
    remarks = "Ph\225\186\161m vi c\225\186\165p c\195\179 th\225\187\131 th\225\186\165y: 250~500",
    conductType = "2"
  },
  {
    id = 114120,
    systemChat = "<color=#FBD994>%s</color> \225\187\159 <color=#FBD994>%s</color> ti\195\170u di\225\187\135t <color=#e6e600>%s</color> v\195\160 r\225\187\155t $1<a href=[system:1]>%s</a></color>",
    acceptCondition = {
      {101, 30},
      {103, 40}
    },
    conductType = "2"
  },
  {
    id = 114220,
    systemChat = "<color=#FBD994>%s</color> \225\187\159 <color=#FBD994>%s</color> ti\195\170u di\225\187\135t <color=#e6e600>%s</color> v\195\160 r\225\187\155t $1<a href=[system:1]>%s</a></color>",
    acceptCondition = {
      {101, 40},
      {103, 70}
    },
    conductType = "2"
  },
  {
    id = 114320,
    systemChat = "<color=#FBD994>%s</color> \225\187\159 <color=#FBD994>%s</color> ti\195\170u di\225\187\135t <color=#e6e600>%s</color> v\195\160 r\225\187\155t $1<a href=[system:1]>%s</a></color>",
    acceptCondition = {
      {101, 50},
      {103, 100}
    },
    conductType = "2"
  },
  {
    id = 9001,
    type = "2",
    priority = 2,
    style = 1,
    systemChat = "C\195\178n 5 ph\195\186t n\225\187\175a s\225\187\177 ki\225\187\135n BOSS Guild s\225\186\189 m\225\187\159\239\188\129",
    acceptCondition = {
      {101, 100}
    },
    conductType = "10"
  },
  {
    id = 9002,
    type = "2",
    systemChat = "C\195\178n 60s n\225\187\175a s\225\187\177 ki\225\187\135n BOSS Guild s\225\186\189 m\225\187\159, s\225\186\181n s\195\160ng chi\225\186\191n \196\145\225\186\165u!",
    acceptCondition = {
      {101, 100}
    },
    conductType = "10"
  },
  {
    id = 9101,
    type = "1&3",
    style = 2,
    systemChat = "<color=#1add1f>%s</color><color=#ff8a00> chi\225\186\191m V\198\176\198\161ng Mi\225\187\135n Loren</color>, tr\225\187\159 th\195\160nh ng\198\176\225\187\157i ph\195\178ng th\225\187\167 m\225\187\155i c\225\187\167a V\225\187\177c Roland",
    remarks = "%s: T\195\170n Guild",
    acceptCondition = {
      {101, 100}
    }
  },
  {
    id = 9102,
    type = "1&3",
    style = 2,
    systemChat = "<color=#1add1f>%s</color><color=#ff8a00> cu\225\187\145i c\195\185ng \196\145\195\163 chi\225\186\191m V\198\176\198\161ng Mi\225\187\135n Loren</color>, tr\225\187\159 th\195\160nh ng\198\176\225\187\157i ph\195\178ng th\225\187\167 m\225\187\155i c\225\187\167a V\225\187\177c Roland",
    remarks = "%s: T\195\170n Guild",
    acceptCondition = {
      {101, 100}
    }
  },
  {
    id = 9103,
    type = "2",
    priority = 2,
    style = 1,
    systemChat = "C\195\178n 5 ph\195\186t n\225\187\175a <color=#139D29>C\195\180ng Th\195\160nh Chi\225\186\191n V\225\187\177c Roland</color> s\225\186\189 m\225\187\159\239\188\129",
    acceptCondition = {
      {101, 100}
    }
  },
  {
    id = 9104,
    type = "2",
    systemChat = "C\195\178n 60s n\225\187\175a <color=#139D29>C\195\180ng Th\195\160nh Chi\225\186\191n V\225\187\177c Roland</color> s\225\186\189 m\225\187\159, s\225\186\181n s\195\160ng chi\225\186\191n \196\145\225\186\165u!",
    acceptCondition = {
      {101, 100}
    }
  },
  {
    id = 9901,
    systemChat = "<color=#ff2323>%s</color> g\225\187\173i tuy\195\170n chi\225\186\191n ch\195\173nh th\225\187\169c \196\145\225\186\191n <color=#ff2323>%s</color>!",
    remarks = "%s: T\195\170n Guild"
  },
  {
    id = 9902,
    type = "2",
    style = 1,
    systemChat = "<color=#ff2323>%s</color> g\225\187\173i tuy\195\170n chi\225\186\191n ch\195\173nh th\225\187\169c \196\145\225\186\191n <color=#ff2323>%s</color>!",
    remarks = "%s: T\195\170n Guild"
  },
  {
    id = 2000,
    type = "1&3",
    style = 2,
    systemChat = "<color=#ff8a00>Huy\225\186\191t L\195\162u</color> \196\145\195\163 m\225\187\159, c\225\187\149ng v\195\160o s\225\186\189 \196\145\195\179ng sau <color=#FF0000>15 p</color>",
    acceptCondition = {
      {101, 100}
    },
    conductType = "11"
  },
  {
    id = 2001,
    priority = 2,
    systemChat = "<color=#FBD994>%s</color> \196\145\195\163 v\195\160o <color=#ff8a00>Huy\225\186\191t L\195\162u Lv1 (50-99)</color>, <color=#139D29>v\195\160o ngay</color>",
    remarks = "0: T\195\170n ng\198\176\225\187\157i ch\198\161i",
    acceptCondition = {
      {101, 100}
    },
    conductType = "11"
  },
  {
    id = 2002,
    priority = 2,
    systemChat = "<color=#FBD994>%s</color> \196\145\195\163 v\195\160o <color=#ff8a00>Huy\225\186\191t L\195\162u Lv2 (100-149)</color>, <color=#139D29>l\225\186\173p t\225\187\169c gia nh\225\186\173p</color>",
    remarks = "0: T\195\170n ng\198\176\225\187\157i ch\198\161i",
    acceptCondition = {
      {101, 100}
    },
    conductType = "11"
  },
  {
    id = 2003,
    priority = 2,
    systemChat = "<color=#FBD994>%s</color> \196\145\195\163 v\195\160o <color=#ff8a00>Huy\225\186\191t L\195\162u Lv3 (150-199)</color>, <color=#139D29>v\195\160o ngay</color>",
    remarks = "0: T\195\170n ng\198\176\225\187\157i ch\198\161i",
    acceptCondition = {
      {101, 100}
    },
    conductType = "11"
  },
  {
    id = 2004,
    priority = 2,
    systemChat = "<color=#FBD994>%s</color> \196\145\195\163 v\195\160o <color=#ff8a00>Huy\225\186\191t L\195\162u Lv4 (200-249)</color>, <color=#139D29>v\195\160o ngay</color>",
    remarks = "0: T\195\170n ng\198\176\225\187\157i ch\198\161i",
    acceptCondition = {
      {101, 100}
    },
    conductType = "11"
  },
  {
    id = 2005,
    priority = 2,
    systemChat = "<color=#FBD994>%s</color> \196\145\195\163 v\195\160o <color=#ff8a00>Huy\225\186\191t L\195\162u Lv5 (250-299)</color>, <color=#139D29>v\195\160o ngay</color>",
    remarks = "0: T\195\170n ng\198\176\225\187\157i ch\198\161i",
    acceptCondition = {
      {101, 100}
    },
    conductType = "11"
  },
  {
    id = 2006,
    priority = 2,
    systemChat = "<color=#FBD994>%s</color> \196\145\195\163 v\195\160o <color=#ff8a00>Huy\225\186\191t L\195\162u Lv6 (300-349)</color>, <color=#139D29>v\195\160o ngay</color>",
    remarks = "0: T\195\170n ng\198\176\225\187\157i ch\198\161i",
    acceptCondition = {
      {101, 100}
    },
    conductType = "11"
  },
  {
    id = 2007,
    priority = 2,
    systemChat = "<color=#FBD994>%s</color> \196\145\195\163 v\195\160o <color=#ff8a00>Huy\225\186\191t L\195\162u Lv7 (350-400)</color>, <color=#139D29>v\195\160o ngay</color>",
    remarks = "0: T\195\170n ng\198\176\225\187\157i ch\198\161i",
    acceptCondition = {
      {101, 100}
    },
    conductType = "11"
  },
  {
    id = 2010,
    type = "1&3",
    style = 2,
    systemChat = "<color=#ff8a00>Qu\225\186\163ng Tr\198\176\225\187\157ng Qu\225\187\183</color> \196\145\195\163 m\225\187\159, c\225\187\149ng v\195\160o s\225\186\189 \196\145\195\179ng sau <color=#FF0000>15 p</color>",
    acceptCondition = {
      {101, 100}
    },
    conductType = "12"
  },
  {
    id = 2011,
    priority = 2,
    systemChat = "<color=#FBD994>%s</color> \196\145\195\163 v\195\160o <color=#ff8a00>Qu\225\186\163ng Tr\198\176\225\187\157ng Qu\225\187\183 Lv1 (50-99)</color>, <color=#139D29>v\195\160o ngay</color>",
    remarks = "0: T\195\170n ng\198\176\225\187\157i ch\198\161i",
    acceptCondition = {
      {101, 100}
    },
    conductType = "12"
  },
  {
    id = 2012,
    priority = 2,
    systemChat = "<color=#FBD994>%s</color> \196\145\195\163 v\195\160o <color=#ff8a00>Qu\225\186\163ng Tr\198\176\225\187\157ng Qu\225\187\183 Lv2 (100-149)</color>, <color=#139D29>v\195\160o ngay</color>",
    remarks = "0: T\195\170n ng\198\176\225\187\157i ch\198\161i",
    acceptCondition = {
      {101, 100}
    },
    conductType = "12"
  },
  {
    id = 2013,
    priority = 2,
    systemChat = "<color=#FBD994>%s</color> \196\145\195\163 v\195\160o <color=#ff8a00>Qu\225\186\163ng Tr\198\176\225\187\157ng Qu\225\187\183 Lv3 (150-199)</color>, <color=#139D29>v\195\160o ngay</color>",
    remarks = "0: T\195\170n ng\198\176\225\187\157i ch\198\161i",
    acceptCondition = {
      {101, 100}
    },
    conductType = "12"
  },
  {
    id = 2014,
    priority = 2,
    systemChat = "<color=#FBD994>%s</color> \196\145\195\163 v\195\160o <color=#ff8a00>Qu\225\186\163ng Tr\198\176\225\187\157ng Qu\225\187\183 Lv4 (200-249)</color>, <color=#139D29>v\195\160o ngay</color>",
    remarks = "0: T\195\170n ng\198\176\225\187\157i ch\198\161i",
    acceptCondition = {
      {101, 100}
    },
    conductType = "12"
  },
  {
    id = 2015,
    priority = 2,
    systemChat = "<color=#FBD994>%s</color> \196\145\195\163 v\195\160o <color=#ff8a00>Qu\225\186\163ng Tr\198\176\225\187\157ng Qu\225\187\183 Lv5 (250-299)</color>, <color=#139D29>v\195\160o ngay</color>",
    remarks = "0: T\195\170n ng\198\176\225\187\157i ch\198\161i",
    acceptCondition = {
      {101, 100}
    },
    conductType = "12"
  },
  {
    id = 2016,
    priority = 2,
    systemChat = "<color=#FBD994>%s</color> \196\145\195\163 v\195\160o <color=#ff8a00>Qu\225\186\163ng Tr\198\176\225\187\157ng Qu\225\187\183 Lv6 (300-349)</color>, <color=#139D29>v\195\160o ngay</color>",
    remarks = "0: T\195\170n ng\198\176\225\187\157i ch\198\161i",
    acceptCondition = {
      {101, 100}
    },
    conductType = "12"
  },
  {
    id = 2017,
    priority = 2,
    systemChat = "<color=#FBD994>%s</color> \196\145\195\163 v\195\160o <color=#ff8a00>Qu\225\186\163ng Tr\198\176\225\187\157ng Qu\225\187\183 Lv7 (350-400)</color>, <color=#139D29>v\195\160o ngay</color>",
    remarks = "0: T\195\170n ng\198\176\225\187\157i ch\198\161i",
    acceptCondition = {
      {101, 100}
    },
    conductType = "12"
  },
  {
    id = 3001,
    systemChat = "<color=#FBD994>%s</color> \196\145\195\163 \196\145\225\187\129 xu\225\186\165t \196\144\225\187\153i Huy\225\186\191t L\195\162u Lv1 (50-99), <color=#139D29>v\195\160o ngay</color>",
    remarks = "0: T\195\170n ng\198\176\225\187\157i ch\198\161i",
    acceptCondition = {
      {101, 100}
    },
    conductType = "13"
  },
  {
    id = 3002,
    systemChat = "<color=#FBD994>%s</color> \196\145\195\163 ph\195\161t \196\145\225\187\153ng \196\144\225\187\153i Huy\225\186\191t L\195\162u Lv2 (100-149), <color=#139D29>v\195\160o ngay</color>",
    remarks = "0: T\195\170n ng\198\176\225\187\157i ch\198\161i",
    acceptCondition = {
      {101, 100}
    },
    conductType = "13"
  },
  {
    id = 3003,
    systemChat = "<color=#FBD994>%s</color> \196\145\195\163 ph\195\161t \196\145\225\187\153ng \196\144\225\187\153i Huy\225\186\191t L\195\162u Lv3 (150-199), <color=#139D29>v\195\160o ngay</color>",
    remarks = "0: T\195\170n ng\198\176\225\187\157i ch\198\161i",
    acceptCondition = {
      {101, 100}
    },
    conductType = "13"
  },
  {
    id = 3004,
    systemChat = "<color=#FBD994>%s</color> \196\145\195\163 ph\195\161t \196\145\225\187\153ng \196\144\225\187\153i Huy\225\186\191t L\195\162u Lv4 (200-249), <color=#139D29>v\195\160o ngay</color>",
    remarks = "0: T\195\170n ng\198\176\225\187\157i ch\198\161i",
    acceptCondition = {
      {101, 100}
    },
    conductType = "13"
  },
  {
    id = 3005,
    systemChat = "<color=#FBD994>%s</color> \196\145\195\163 ph\195\161t \196\145\225\187\153ng \196\144\225\187\153i Huy\225\186\191t L\195\162u Lv5 (250-299), <color=#139D29>v\195\160o ngay</color>",
    remarks = "0: T\195\170n ng\198\176\225\187\157i ch\198\161i",
    acceptCondition = {
      {101, 100}
    },
    conductType = "13"
  },
  {
    id = 3006,
    systemChat = "<color=#FBD994>%s</color> \196\145\195\163 ph\195\161t \196\145\225\187\153ng \196\144\225\187\153i Huy\225\186\191t L\195\162u Lv6 (300-349), <color=#139D29>v\195\160o ngay</color>",
    remarks = "0: T\195\170n ng\198\176\225\187\157i ch\198\161i",
    acceptCondition = {
      {101, 100}
    },
    conductType = "13"
  },
  {
    id = 3007,
    systemChat = "<color=#FBD994>%s</color> \196\145\195\163 ph\195\161t \196\145\225\187\153ng \196\144\225\187\153i Huy\225\186\191t L\195\162u Lv7 (350-400), <color=#139D29>v\195\160o ngay</color>",
    remarks = "0: T\195\170n ng\198\176\225\187\157i ch\198\161i",
    acceptCondition = {
      {101, 100}
    },
    conductType = "13"
  },
  {
    id = 3011,
    systemChat = "<color=#FBD994>%s</color> \196\145\195\163 \196\145\225\187\129 xu\225\186\165t \196\144\225\187\153i Qu\225\186\163ng Tr\198\176\225\187\157ng Qu\225\187\183 Lv1 (50-99), <color=#139D29>v\195\160o ngay</color>",
    remarks = "0: T\195\170n ng\198\176\225\187\157i ch\198\161i",
    acceptCondition = {
      {101, 100}
    },
    conductType = "13"
  },
  {
    id = 3012,
    systemChat = "<color=#FBD994>%s</color> \196\145\195\163 ph\195\161t \196\145\225\187\153ng \196\144\225\187\153i Qu\225\186\163ng Tr\198\176\225\187\157ng Qu\225\187\183 Lv2 (100-149), <color=#139D29>v\195\160o ngay</color>",
    remarks = "0: T\195\170n ng\198\176\225\187\157i ch\198\161i",
    acceptCondition = {
      {101, 100}
    },
    conductType = "13"
  },
  {
    id = 3013,
    systemChat = "<color=#FBD994>%s</color> \196\145\195\163 ph\195\161t \196\145\225\187\153ng \196\144\225\187\153i Qu\225\186\163ng Tr\198\176\225\187\157ng Qu\225\187\183 Lv3 (150-199), <color=#139D29>v\195\160o ngay</color>",
    remarks = "0: T\195\170n ng\198\176\225\187\157i ch\198\161i",
    acceptCondition = {
      {101, 100}
    },
    conductType = "13"
  },
  {
    id = 3014,
    systemChat = "<color=#FBD994>%s</color> \196\145\195\163 ph\195\161t \196\145\225\187\153ng \196\144\225\187\153i Qu\225\186\163ng Tr\198\176\225\187\157ng Qu\225\187\183 Lv4 (200-249), <color=#139D29>v\195\160o ngay</color>",
    remarks = "0: T\195\170n ng\198\176\225\187\157i ch\198\161i",
    acceptCondition = {
      {101, 100}
    },
    conductType = "13"
  },
  {
    id = 3015,
    systemChat = "<color=#FBD994>%s</color> \196\145\195\163 ph\195\161t \196\145\225\187\153ng \196\144\225\187\153i Qu\225\186\163ng Tr\198\176\225\187\157ng Qu\225\187\183 Lv5 (250-299), <color=#139D29>v\195\160o ngay</color>",
    remarks = "0: T\195\170n ng\198\176\225\187\157i ch\198\161i",
    acceptCondition = {
      {101, 100}
    },
    conductType = "13"
  },
  {
    id = 3016,
    systemChat = "<color=#FBD994>%s</color> \196\145\195\163 ph\195\161t \196\145\225\187\153ng \196\144\225\187\153i Qu\225\186\163ng Tr\198\176\225\187\157ng Qu\225\187\183 Lv6 (300-349), <color=#139D29>v\195\160o ngay</color>",
    remarks = "0: T\195\170n ng\198\176\225\187\157i ch\198\161i",
    acceptCondition = {
      {101, 100}
    },
    conductType = "13"
  },
  {
    id = 3017,
    systemChat = "<color=#FBD994>%s</color> \196\145\195\163 ph\195\161t \196\145\225\187\153ng \196\144\225\187\153i Qu\225\186\163ng Tr\198\176\225\187\157ng Qu\225\187\183 Lv7 (350-400), <color=#139D29>v\195\160o ngay</color>",
    remarks = "0: T\195\170n ng\198\176\225\187\157i ch\198\161i",
    acceptCondition = {
      {101, 100}
    },
    conductType = "13"
  },
  {
    id = 4001,
    systemChat = "C\195\178n %s ph\195\186t n\225\187\175a H\225\187\143a Long V\198\176\198\161ng t\225\186\173p k\195\173ch, c\195\161c Chi\225\186\191n Binh h\195\163y chu\225\186\169n b\225\187\139 tr\198\176\225\187\155c khi chi\225\186\191n \196\145\225\186\165u!",
    remarks = "0: Th\225\187\157i gian (ph\195\186t)",
    acceptCondition = {
      {101, 100}
    }
  },
  {
    id = 4002,
    type = "1&2",
    systemChat = "H\225\187\143a Long V\198\176\198\161ng xu\225\186\165t hi\225\187\135n \225\187\159 %s, c\195\161c Chi\225\186\191n Binh mau \196\145\225\186\191n th\225\186\163o ph\225\186\161t n\195\160o!",
    remarks = "0: T\195\170n b\225\186\163n \196\145\225\187\147",
    acceptCondition = {
      {101, 100}
    }
  },
  {
    id = 4003,
    systemChat = "H\225\187\143a Long V\198\176\198\161ng T\225\186\173p K\195\173ch c\195\178n 15 ph\195\186t n\225\187\175a k\225\186\191t th\195\186c, H\225\187\143a Long V\198\176\198\161ng l\195\186c n\195\160y s\225\186\189 bi\225\186\191n m\225\186\165t, h\195\163y tranh th\225\187\167 th\225\187\157i gian",
    acceptCondition = {
      {101, 100}
    }
  },
  {
    id = 4004,
    systemChat = "H\225\187\143a Long V\198\176\198\161ng T\225\186\173p K\195\173ch c\195\178n 10 ph\195\186t n\225\187\175a k\225\186\191t th\195\186c, H\225\187\143a Long V\198\176\198\161ng l\195\186c n\195\160y s\225\186\189 bi\225\186\191n m\225\186\165t, h\195\163y tranh th\225\187\167 th\225\187\157i gian",
    acceptCondition = {
      {101, 100}
    }
  },
  {
    id = 4005,
    type = "2",
    style = 2,
    systemChat = "H\225\187\143a Long V\198\176\198\161ng T\225\186\173p K\195\173ch c\195\178n %ss n\225\187\175a k\225\186\191t th\195\186c, H\225\187\143a Long V\198\176\198\161ng l\195\186c n\195\160y s\225\186\189 bi\225\186\191n m\225\186\165t, h\195\163y tranh th\225\187\167 th\225\187\157i gian",
    remarks = "Th\225\187\157i gian (gi\195\162y)",
    countdown = 180,
    acceptCondition = {
      {101, 100}
    }
  },
  {
    id = 5001,
    type = "1&5",
    systemChat = "<color=#3CD937>S\225\187\169c M\225\186\161nh Ch\195\186c Ph\195\186c</color> n\225\186\177m r\225\186\163i r\195\161c kh\225\186\175p quanh b\225\187\165c, n\225\186\191u m\225\186\165t s\225\186\189 nh\225\186\173n \196\145\198\176\225\187\163c kho\225\186\163n t\196\131ng \196\145\195\161ng k\225\187\131",
    countdown = 3,
    acceptCondition = {
      {101, 100}
    }
  },
  {
    id = 5002,
    systemChat = "<color=#FBD994>%s</color> \196\145\195\163 nh\225\186\173n \196\145\198\176\225\187\163c hi\225\187\135u qu\225\186\163 <color=#4cc5fe>%s</color> %s trong %ss",
    acceptCondition = {
      {101, 100}
    }
  },
  {
    id = 5003,
    type = "1&5",
    priority = 2,
    systemChat = "<color=#e6e600>C\225\186\161nh b\225\187\165c s\225\186\175p s\225\187\165p \196\145\225\187\149, h\195\163y tr\195\161nh xa ngay l\225\186\173p t\225\187\169c</color>",
    countdown = 3,
    acceptCondition = {
      {101, 100}
    }
  },
  {
    id = 5004,
    type = "1&5",
    priority = 2,
    systemChat = "<color=#e6e600>Tr\225\186\173n chi\225\186\191n cu\225\187\145i c\195\185ng b\225\186\175t \196\145\225\186\167u, s\225\186\189 tr\225\187\171 t\225\186\165t c\225\186\163 s\225\187\145 l\225\186\167n h\225\187\147i sinh v\195\160 buff</color>",
    countdown = 3,
    acceptCondition = {
      {101, 100}
    }
  },
  {
    id = 6001,
    type = "1&5",
    priority = 2,
    systemChat = "<color=#e6e600>Qu\195\162n \196\145o\195\160n Bakas \196\145ang t\225\186\173p h\225\187\163p b\195\170n ngo\195\160i c\225\187\169 \196\145i\225\187\131m, tr\225\186\173n chi\225\186\191n s\225\186\175p b\225\186\175t \196\145\225\186\167u</color>",
    countdown = 3,
    acceptCondition = {
      {101, 100}
    }
  },
  {
    id = 6002,
    systemChat = "<color=#e6e600>K\225\186\187 \196\145\225\187\139ch b\225\186\175t \196\145\225\186\167u t\225\186\165n c\195\180ng \196\145\225\187\163t %s</color>",
    acceptCondition = {
      {101, 100}
    }
  },
  {
    id = 6003,
    type = "1&5",
    systemChat = "<color=#e6e600>T\198\176\225\187\163ng \196\145ang b\225\187\139 t\225\186\165n c\195\180ng, h\195\163y \196\145\225\186\191n chi vi\225\187\135n</color>",
    countdown = 3,
    acceptCondition = {
      {101, 100}
    }
  },
  {
    id = 6004,
    systemChat = "<color=#e6e600>T\198\176\225\187\163ng b\225\187\139 ph\195\161 h\225\187\167y, ph\195\178ng th\225\187\167 th\225\186\165t b\225\186\161i</color>",
    acceptCondition = {
      {101, 100}
    }
  },
  {
    id = 6005,
    type = "1&5",
    systemChat = "<color=#e6e600>\196\144\225\187\163t <color=#1add1f>%s</color> ph\195\178ng th\225\187\167 th\195\160nh c\195\180ng, th\198\176\225\187\159ng <color=#1add1f>%s</color> EXP Guild</color>",
    countdown = 3,
    acceptCondition = {
      {101, 100}
    }
  },
  {
    id = 7001,
    systemChat = "L\225\187\165c \196\144\225\187\139a K\225\187\179 T\195\173ch b\225\187\139 <color=#ff8a00>H\225\187\143a Long V\198\176\198\161ng t\225\186\173p k\195\173ch</color>, c\195\161c Chi\225\186\191n S\196\169 h\195\163y \196\145\225\186\191n th\225\186\163o ph\225\186\161t!",
    acceptCondition = {
      {101, 100}
    }
  },
  {
    id = 7002,
    systemChat = "<color=#ff8a00>Ph\195\161o \196\144\195\160i H\225\187\147n S\195\179i</color> \196\145\195\163 m\225\187\159, h\195\163y \196\145\225\186\191n Th\225\187\167 H\225\187\153 T\198\176\225\187\163ng H\225\187\147n S\195\179i!",
    acceptCondition = {
      {101, 100}
    }
  },
  {
    id = 7003,
    systemChat = "<color=#ff8a00>Ph\195\161o \196\144\195\160i \196\144\225\187\143</color> \196\145\195\163 m\225\187\159, c\225\187\149ng v\195\160o ch\225\187\137 duy tr\195\172 <color=#FF0000>5 p</color>!",
    acceptCondition = {
      {101, 100}
    }
  },
  {
    id = 7004,
    systemChat = "<color=#ff8a00>C\195\180ng Th\195\160nh Chi\225\186\191n \196\145\195\163 m\225\187\159</color>, ti\225\186\191n c\195\180ng v\225\187\129 ph\195\173a V\225\187\177c Roland!",
    acceptCondition = {
      {101, 100}
    }
  },
  {
    id = 8001,
    type = "1&2",
    systemChat = "Ch\195\186c m\225\187\171ng <color=#FBD994>%s</color> \196\145\195\163 n\225\187\151 l\225\187\177c kh\195\180ng ng\225\187\171ng v\195\160 Chuy\225\187\131n Ch\225\187\169c th\195\160nh c\195\180ng sang <color=#df4be8>%s</color>!"
  },
  {
    id = 8002,
    type = "1&2",
    systemChat = "Ch\195\186c m\225\187\171ng <color=#FBD994>%s</color> \196\145\195\163 n\225\187\151 l\225\187\177c kh\195\180ng ng\225\187\171ng v\195\160 Chuy\225\187\131n Ch\225\187\169c th\195\160nh c\195\180ng sang <color=#f36055>%s</color>!"
  },
  {
    id = 8003,
    type = "1&2",
    systemChat = "Ch\195\186c m\225\187\171ng <color=#FBD994>%s</color> \196\145\195\163 n\225\187\151 l\225\187\177c kh\195\180ng ng\225\187\171ng v\195\160 Chuy\225\187\131n Ch\225\187\169c th\195\160nh c\195\180ng sang <color=#e8d04b>%s</color>!"
  },
  {
    id = 10010,
    type = "5",
    systemChat = "Ch\195\160o m\225\187\171ng \196\145\225\186\191n L\225\187\165c \196\144\225\187\139a K\225\187\179 T\195\173ch&L\225\187\165c \196\145\225\187\139a b\225\187\139 qu\195\161i v\225\186\173t chi\225\186\191m gi\225\187\175, qu\195\162n Kundun \196\145ang r\225\187\165c r\225\187\139ch ng\195\179c \196\145\225\186\167u d\225\186\173y t\225\187\171 trong b\195\179ng t\225\187\145i, c\195\161c Chi\225\186\191n S\196\169 h\195\163y t\225\186\173p h\225\187\163p s\225\187\169c m\225\186\161nh, gi\195\161ng m\225\187\153t \196\145\195\178n&tr\225\187\177c di\225\187\135n v\195\160o b\195\168 l\197\169 x\195\162m l\196\131ng kia!",
    countdown = 30,
    acceptCondition = {
      {104, 0}
    }
  },
  {
    id = 10011,
    type = "5",
    systemChat = "L\225\187\165c \196\144\225\187\139a K\225\187\179 T\195\173ch b\225\187\139 H\225\186\163i Long V\198\176\198\161ng t\225\186\173p k\195\173ch, c\195\161c Chi\225\186\191n S\196\169 h\195\163y \196\145\225\186\191n th\225\186\163o ph\225\186\161t!",
    countdown = 180,
    acceptCondition = {
      {104, 0}
    }
  },
  {
    id = 10012,
    type = "5",
    systemChat = "Ph\195\161o \196\144\195\160i H\225\187\147n S\195\179i \196\145\195\163 m\225\187\159, h\195\163y \196\145\225\186\191n Th\225\187\167 H\225\187\153 T\198\176\225\187\163ng H\225\187\147n S\195\179i!",
    countdown = 120,
    acceptCondition = {
      {104, 0}
    }
  },
  {
    id = 10013,
    type = "5",
    systemChat = "Ph\195\161o \196\144\195\160i \196\144\225\187\143 \196\145\195\163 m\225\187\159, c\225\187\149ng v\195\160o ch\225\187\137 duy tr\195\172 5p",
    countdown = 120,
    acceptCondition = {
      {101, 100}
    }
  },
  {
    id = 10014,
    type = "5",
    systemChat = "C\195\180ng Th\195\160nh Chi\225\186\191n \196\145\195\163 m\225\187\159, ti\225\186\191n c\195\180ng v\225\187\129 V\225\187\177c Roland!",
    countdown = 180,
    acceptCondition = {
      {101, 100}
    }
  },
  {
    id = 11001,
    type = "1&3",
    systemChat = "<color=#FBD994>%s</color> \196\145\195\163 \196\145i \196\145\225\186\167u <color=#ff2323>t\196\131ng l\195\170n Lv%s</color>, nh\225\186\173n \196\145\198\176\225\187\163c ph\225\186\167n th\198\176\225\187\159ng h\225\186\173u h\196\169nh, th\225\187\177c l\225\187\177c t\196\131ng nhi\225\187\129u!",
    remarks = "C\225\186\165p c\195\179 th\225\187\131 th\225\186\165y: 27-40",
    acceptCondition = {
      {104, 0}
    },
    conductType = "16"
  },
  {
    id = 11002,
    type = "1&3",
    systemChat = "<color=#FBD994>%s</color> \196\145\195\163 \196\145i \196\145\225\186\167u <color=#ff2323>t\196\131ng l\195\170n Lv%s</color>, nh\225\186\173n \196\145\198\176\225\187\163c ph\225\186\167n th\198\176\225\187\159ng h\225\186\173u h\196\169nh, th\225\187\177c l\225\187\177c t\196\131ng nhi\225\187\129u!",
    remarks = "C\225\186\165p c\195\179 th\225\187\131 th\225\186\165y: 30-60",
    acceptCondition = {
      {104, 0}
    },
    conductType = "16"
  },
  {
    id = 11003,
    type = "1&3",
    systemChat = "<color=#FBD994>%s</color> \196\145\195\163 \196\145i \196\145\225\186\167u <color=#ff2323>t\196\131ng l\195\170n Lv%s</color>, nh\225\186\173n \196\145\198\176\225\187\163c ph\225\186\167n th\198\176\225\187\159ng h\225\186\173u h\196\169nh, th\225\187\177c l\225\187\177c t\196\131ng nhi\225\187\129u!",
    remarks = "C\225\186\165p c\195\179 th\225\187\131 th\225\186\165y: 50-90",
    acceptCondition = {
      {104, 0}
    },
    conductType = "16"
  },
  {
    id = 11004,
    type = "1&3",
    systemChat = "<color=#FBD994>%s</color> \196\145\195\163 \196\145i \196\145\225\186\167u <color=#ff2323>t\196\131ng l\195\170n Lv%s</color>, nh\225\186\173n \196\145\198\176\225\187\163c ph\225\186\167n th\198\176\225\187\159ng h\225\186\173u h\196\169nh, th\225\187\177c l\225\187\177c t\196\131ng nhi\225\187\129u!",
    remarks = "C\225\186\165p c\195\179 th\225\187\131 th\225\186\165y: 60-100",
    acceptCondition = {
      {101, 60},
      {103, 100}
    },
    conductType = "16"
  },
  {
    id = 11005,
    type = "1&3",
    systemChat = "<color=#FBD994>%s</color> \196\145\195\163 \196\145i \196\145\225\186\167u <color=#ff2323>t\196\131ng l\195\170n Lv%s</color>, nh\225\186\173n \196\145\198\176\225\187\163c ph\225\186\167n th\198\176\225\187\159ng h\225\186\173u h\196\169nh, th\225\187\177c l\225\187\177c t\196\131ng nhi\225\187\129u!",
    remarks = "C\225\186\165p c\195\179 th\225\187\131 th\225\186\165y: 70-110",
    acceptCondition = {
      {104, 0}
    },
    conductType = "16"
  },
  {
    id = 11006,
    type = "1&3",
    systemChat = "<color=#FBD994>%s</color> \196\145\195\163 \196\145i \196\145\225\186\167u <color=#ff2323>t\196\131ng l\195\170n Lv%s</color>, nh\225\186\173n \196\145\198\176\225\187\163c ph\225\186\167n th\198\176\225\187\159ng h\225\186\173u h\196\169nh, th\225\187\177c l\225\187\177c t\196\131ng nhi\225\187\129u!",
    remarks = "C\225\186\165p c\195\179 th\225\187\131 th\225\186\165y: 80-120",
    acceptCondition = {
      {101, 80},
      {103, 120}
    },
    conductType = "16"
  },
  {
    id = 11007,
    type = "1&3",
    systemChat = "<color=#FBD994>%s</color> \196\145\195\163 \196\145i \196\145\225\186\167u <color=#ff2323>t\196\131ng l\195\170n Lv%s</color>, nh\225\186\173n \196\145\198\176\225\187\163c ph\225\186\167n th\198\176\225\187\159ng h\225\186\173u h\196\169nh, th\225\187\177c l\225\187\177c t\196\131ng nhi\225\187\129u!",
    remarks = "C\225\186\165p c\195\179 th\225\187\131 th\225\186\165y: 90-130",
    acceptCondition = {
      {104, 0}
    },
    conductType = "16"
  },
  {
    id = 11008,
    type = "1&3",
    systemChat = "<color=#FBD994>%s</color> \196\145\195\163 \196\145i \196\145\225\186\167u <color=#ff2323>t\196\131ng l\195\170n Lv%s</color>, nh\225\186\173n \196\145\198\176\225\187\163c ph\225\186\167n th\198\176\225\187\159ng h\225\186\173u h\196\169nh, th\225\187\177c l\225\187\177c t\196\131ng nhi\225\187\129u!",
    remarks = "C\225\186\165p c\195\179 th\225\187\131 th\225\186\165y: 100-150",
    acceptCondition = {
      {104, 0}
    },
    conductType = "16"
  },
  {
    id = 11009,
    type = "1&3",
    systemChat = "<color=#FBD994>%s</color> \196\145\195\163 \196\145i \196\145\225\186\167u <color=#ff2323>t\196\131ng l\195\170n Lv%s</color>, nh\225\186\173n \196\145\198\176\225\187\163c ph\225\186\167n th\198\176\225\187\159ng h\225\186\173u h\196\169nh, th\225\187\177c l\225\187\177c t\196\131ng nhi\225\187\129u!",
    remarks = "C\225\186\165p c\195\179 th\225\187\131 th\225\186\165y: 100-160",
    acceptCondition = {
      {104, 0}
    },
    conductType = "16"
  },
  {
    id = 11010,
    type = "1&3",
    systemChat = "<color=#FBD994>%s</color> \196\145\195\163 \196\145i \196\145\225\186\167u <color=#ff2323>t\196\131ng l\195\170n Lv%s</color>, nh\225\186\173n \196\145\198\176\225\187\163c ph\225\186\167n th\198\176\225\187\159ng h\225\186\173u h\196\169nh, th\225\187\177c l\225\187\177c t\196\131ng nhi\225\187\129u!",
    remarks = "C\225\186\165p c\195\179 th\225\187\131 th\225\186\165y: 110-170",
    acceptCondition = {
      {104, 0}
    },
    conductType = "16"
  },
  {
    id = 11011,
    type = "1&3",
    systemChat = "<color=#FBD994>%s</color> \196\145\195\163 \196\145i \196\145\225\186\167u <color=#ff2323>t\196\131ng l\195\170n Lv%s</color>, nh\225\186\173n \196\145\198\176\225\187\163c ph\225\186\167n th\198\176\225\187\159ng h\225\186\173u h\196\169nh, th\225\187\177c l\225\187\177c t\196\131ng nhi\225\187\129u!",
    remarks = "C\225\186\165p c\195\179 th\225\187\131 th\225\186\165y: 120-180",
    acceptCondition = {
      {101, 120},
      {103, 180}
    },
    conductType = "16"
  },
  {
    id = 11012,
    type = "1&3",
    systemChat = "<color=#FBD994>%s</color> \196\145\195\163 \196\145i \196\145\225\186\167u <color=#ff2323>t\196\131ng l\195\170n Lv%s</color>, nh\225\186\173n \196\145\198\176\225\187\163c ph\225\186\167n th\198\176\225\187\159ng h\225\186\173u h\196\169nh, th\225\187\177c l\225\187\177c t\196\131ng nhi\225\187\129u!",
    remarks = "C\225\186\165p c\195\179 th\225\187\131 th\225\186\165y: 130-190",
    acceptCondition = {
      {104, 0}
    },
    conductType = "16"
  },
  {
    id = 11013,
    type = "1&3",
    systemChat = "<color=#FBD994>%s</color> \196\145\195\163 \196\145i \196\145\225\186\167u <color=#ff2323>t\196\131ng l\195\170n Lv%s</color>, nh\225\186\173n \196\145\198\176\225\187\163c ph\225\186\167n th\198\176\225\187\159ng h\225\186\173u h\196\169nh, th\225\187\177c l\225\187\177c t\196\131ng nhi\225\187\129u!",
    remarks = "C\225\186\165p c\195\179 th\225\187\131 th\225\186\165y: 140-200",
    acceptCondition = {
      {104, 0}
    },
    conductType = "16"
  },
  {
    id = 11014,
    type = "1&3",
    systemChat = "<color=#FBD994>%s</color> \196\145\195\163 \196\145i \196\145\225\186\167u <color=#ff2323>t\196\131ng l\195\170n Lv%s</color>, nh\225\186\173n \196\145\198\176\225\187\163c ph\225\186\167n th\198\176\225\187\159ng h\225\186\173u h\196\169nh, th\225\187\177c l\225\187\177c t\196\131ng nhi\225\187\129u!",
    remarks = "C\225\186\165p c\195\179 th\225\187\131 th\225\186\165y: 150-210",
    acceptCondition = {
      {104, 0}
    },
    conductType = "16"
  },
  {
    id = 11015,
    type = "1&3",
    systemChat = "<color=#FBD994>%s</color> \196\145\195\163 \196\145i \196\145\225\186\167u <color=#ff2323>t\196\131ng l\195\170n Lv%s</color>, nh\225\186\173n \196\145\198\176\225\187\163c ph\225\186\167n th\198\176\225\187\159ng h\225\186\173u h\196\169nh, th\225\187\177c l\225\187\177c t\196\131ng nhi\225\187\129u!",
    remarks = "C\225\186\165p c\195\179 th\225\187\131 th\225\186\165y: 160-220",
    acceptCondition = {
      {104, 0}
    },
    conductType = "16"
  },
  {
    id = 11016,
    type = "1&3",
    systemChat = "<color=#FBD994>%s</color> \196\145\195\163 \196\145i \196\145\225\186\167u <color=#ff2323>t\196\131ng l\195\170n Lv%s</color>, nh\225\186\173n \196\145\198\176\225\187\163c ph\225\186\167n th\198\176\225\187\159ng h\225\186\173u h\196\169nh, th\225\187\177c l\225\187\177c t\196\131ng nhi\225\187\129u!",
    remarks = "C\225\186\165p c\195\179 th\225\187\131 th\225\186\165y: 170-230",
    acceptCondition = {
      {101, 170},
      {103, 230}
    },
    conductType = "16"
  },
  {
    id = 11017,
    type = "1&3",
    systemChat = "<color=#FBD994>%s</color> \196\145\195\163 \196\145i \196\145\225\186\167u <color=#ff2323>t\196\131ng l\195\170n Lv%s</color>, nh\225\186\173n \196\145\198\176\225\187\163c ph\225\186\167n th\198\176\225\187\159ng h\225\186\173u h\196\169nh, th\225\187\177c l\225\187\177c t\196\131ng nhi\225\187\129u!",
    remarks = "C\225\186\165p c\195\179 th\225\187\131 th\225\186\165y: 180-240",
    acceptCondition = {
      {104, 0}
    },
    conductType = "16"
  },
  {
    id = 11018,
    type = "1&3",
    systemChat = "<color=#FBD994>%s</color> \196\145\195\163 \196\145i \196\145\225\186\167u <color=#ff2323>t\196\131ng l\195\170n Lv%s</color>, nh\225\186\173n \196\145\198\176\225\187\163c ph\225\186\167n th\198\176\225\187\159ng h\225\186\173u h\196\169nh, th\225\187\177c l\225\187\177c t\196\131ng nhi\225\187\129u!",
    remarks = "C\225\186\165p c\195\179 th\225\187\131 th\225\186\165y: 190-250",
    acceptCondition = {
      {104, 0}
    },
    conductType = "16"
  },
  {
    id = 11019,
    type = "1&3",
    systemChat = "<color=#FBD994>%s</color> \196\145\195\163 \196\145i \196\145\225\186\167u <color=#ff2323>t\196\131ng l\195\170n Lv%s</color>, nh\225\186\173n \196\145\198\176\225\187\163c ph\225\186\167n th\198\176\225\187\159ng h\225\186\173u h\196\169nh, th\225\187\177c l\225\187\177c t\196\131ng nhi\225\187\129u!",
    remarks = "C\225\186\165p c\195\179 th\225\187\131 th\225\186\165y: 200-260",
    acceptCondition = {
      {104, 0}
    },
    conductType = "16"
  },
  {
    id = 11020,
    type = "1&3",
    systemChat = "<color=#FBD994>%s</color> \196\145\195\163 \196\145i \196\145\225\186\167u <color=#ff2323>t\196\131ng l\195\170n Lv%s</color>, nh\225\186\173n \196\145\198\176\225\187\163c ph\225\186\167n th\198\176\225\187\159ng h\225\186\173u h\196\169nh, th\225\187\177c l\225\187\177c t\196\131ng nhi\225\187\129u!",
    remarks = "C\225\186\165p c\195\179 th\225\187\131 th\225\186\165y: 210-270",
    acceptCondition = {
      {104, 0}
    },
    conductType = "16"
  },
  {
    id = 11021,
    type = "1&3",
    systemChat = "<color=#FBD994>%s</color> \196\145\195\163 \196\145i \196\145\225\186\167u <color=#ff2323>t\196\131ng l\195\170n Lv%s</color>, nh\225\186\173n \196\145\198\176\225\187\163c ph\225\186\167n th\198\176\225\187\159ng h\225\186\173u h\196\169nh, th\225\187\177c l\225\187\177c t\196\131ng nhi\225\187\129u!",
    remarks = "C\225\186\165p c\195\179 th\225\187\131 th\225\186\165y: 220-280",
    acceptCondition = {
      {101, 220},
      {103, 280}
    },
    conductType = "16"
  },
  {
    id = 12001,
    type = "1&3",
    systemChat = "<color=#FBD994>%s</color> \196\145\195\163 ti\195\170u di\225\187\135t BOSS Guild t\225\186\167ng <color=#ff2323>%s</color>",
    remarks = "Ng\198\176\225\187\157i ch\198\161i v\195\160o Guild c\195\179 th\225\187\131 th\225\186\165y, %s: T\195\170n Guild, %s: boss th\225\187\169 m\225\186\165y"
  },
  {
    id = 1501,
    type = "1&3",
    systemChat = "<color=#FBD994>%s</color> \196\145i \196\145\225\186\167u qua \225\186\163i Th\225\187\173 Th\195\161ch Can \196\144\225\186\163m t\225\186\167ng <color=#ff2323>%s</color>",
    acceptCondition = {
      {101, 100}
    }
  },
  {
    id = 20001,
    subtype = 2,
    type = "3",
    systemChat = "<color=#FBD994>%s</color> ra m\225\186\175t h\195\160ng m\225\187\155i, gi\195\161 c\225\186\163 ph\225\186\163i ch\196\131ng, gian h\195\160ng <color=#ff2323>%s</color>, ch\195\160o \196\145\195\179n gh\195\169 mua",
    remarks = "0 t\195\170n \196\145\225\186\161o c\225\187\165, 1 t\225\187\141a \196\145\225\187\153",
    cost = "1000021#200",
    chatCd = "60000"
  },
  {
    id = 3000501,
    type = "1&2",
    systemChat = "C\195\161ch BOSS Ng\195\160y L\225\187\133 \196\145\225\186\191n th\196\131m c\195\178n <color=#1add1f>10 ph\195\186t</color>, c\195\161c Chi\225\186\191n Binh h\195\163y chu\225\186\169n b\225\187\139 tr\198\176\225\187\155c \196\145\225\187\131 ngh\195\170nh \196\145\195\179n BOSS Ng\195\160y L\225\187\133 nh\195\169!",
    acceptCondition = {
      {101, 27}
    }
  },
  {
    id = 3000502,
    type = "1&2",
    systemChat = "BOSS Ng\195\160y L\225\187\133 hi\225\187\135n th\195\162n \225\187\159 <color=#1add1f>%s</color>, c\195\161c Chi\225\186\191n Binh h\195\163y nhanh ch\195\179ng \196\145\225\186\191n ngh\195\170nh \196\145\195\179n!",
    remarks = "0: T\195\170n b\225\186\163n \196\145\225\187\147",
    acceptCondition = {
      {101, 27}
    }
  },
  {
    id = 3000503,
    systemChat = "BOSS Ng\195\160y L\225\187\133 \196\145\225\186\191n th\196\131m c\195\178n <color=#1add1f>10 ph\195\186t</color> k\225\186\191t th\195\186c, l\195\186c n\195\160y BOSS Ng\195\160y L\225\187\133 s\225\186\189 bi\225\186\191n m\225\186\165t, h\195\163y kh\225\186\169n tr\198\176\198\161ng l\195\170n!",
    acceptCondition = {
      {101, 27}
    }
  },
  {
    id = 3000304,
    type = "1&3",
    style = 2,
    systemChat = "<color=#FBD994>%s</color> m\225\187\159 <color=#E8D04B><a href=[system:1]>%s</a></color> v\195\160 nh\225\186\173n \196\145\198\176\225\187\163c <color=#E8D04B><a href=[system:2]>%s</a></color>",
    acceptCondition = {
      {101, 70}
    }
  },
  {
    id = 3000305,
    type = "1&3",
    style = 2,
    systemChat = "<color=#FBD994>%s</color> trong SK \196\144o\225\186\161t B\225\186\163o May M\225\186\175n \196\145\195\163 nh\225\186\173n Th\198\176\225\187\159ng L\225\187\155n <color=#E8D04B><a href=[system:1]>%s</a></color>!",
    acceptCondition = {
      {101, 70}
    },
    conductType = "2"
  },
  {
    id = 3001001,
    priority = 2,
    style = 1,
    systemChat = "Ch\195\186c m\225\187\171ng <color=#FBD994>%s</color> mua <color=#e8d04b>%s</color>! Th\225\187\177c l\225\187\177c v\198\176\225\187\163t tr\198\176\225\187\155c, t\225\187\171ng b\198\176\225\187\155c d\225\186\171n \196\145\225\186\167u!",
    acceptCondition = {
      {101, 20},
      {103, 240}
    }
  },
  {
    id = 30001,
    priority = 2,
    systemChat = "<color=#FBD994>%s</color> trong <color=#ff8a00><a href=[system: 1]>\196\144\225\186\167u T\198\176 Th\225\187\167 H\225\187\153</a></color> \196\145\195\163 th\195\160nh c\195\180ng k\195\173ch ho\225\186\161t $1<a href=[system: 2]>%s</a></color>",
    remarks = "0: T\195\170n ng\198\176\225\187\157i ch\198\161i, 1: T\195\170n \196\145\225\186\161o c\225\187\165",
    jumpUi = "4116001",
    acceptCondition = {
      {101, 100}
    },
    conductType = "17#2"
  },
  {
    id = 13001,
    type = "1&2",
    systemChat = "Qu\195\161i V\195\160ng sau 5 ph\195\186t s\225\186\189 xu\225\186\165t hi\225\187\135n \225\187\159 v\225\187\139 tr\195\173 ng\225\186\171u nhi\195\170n tr\195\170n b\225\186\163n \196\145\225\187\147, c\195\161c Chi\225\186\191n Binh h\195\163y chu\225\186\169n b\225\187\139 s\225\186\181n s\195\160ng",
    acceptCondition = {
      {101, 100}
    }
  },
  {
    id = 13002,
    type = "1&2",
    systemChat = "Qu\195\161i V\195\160ng \196\145\195\163 xu\225\186\165t hi\225\187\135n, c\195\161c Chi\225\186\191n Binh h\195\163y kh\225\186\169n tr\198\176\198\161ng t\195\172m ki\225\186\191m v\195\160 th\225\186\163o ph\225\186\161t!",
    acceptCondition = {
      {101, 100}
    }
  },
  {
    id = 13003,
    type = "1&2",
    systemChat = "Qu\195\161i V\195\160ng \196\145\195\163 b\225\187\143 ch\225\186\161y, c\195\161c Chi\225\186\191n Binh h\195\163y \196\145\225\187\163i l\225\186\167n xu\225\186\165t hi\225\187\135n k\225\186\191 ti\225\186\191p",
    acceptCondition = {
      {101, 100}
    }
  },
  {
    id = 14001,
    type = "1&2",
    systemChat = "Ch\195\186c m\225\187\171ng <color=#FBD994>%s</color><color=#e8d04b> \196\145\225\186\191n tr\198\176\225\187\155c 1 b\198\176\225\187\155c, m\225\187\159 Thi\195\170n Ph\195\186 B\225\186\173c Th\225\186\167y</color>!!!",
    condition = "7001#4"
  },
  {
    id = 15001,
    priority = 2,
    style = 1,
    systemChat = "Ch\195\186c m\225\187\171ng <color=#FBD994>%s</color> m\225\187\159 R\198\176\198\161ng V\195\160ng, nh\225\186\173n <color=#e8d04b>%s</color>!",
    remarks = "0: T\195\170n ng\198\176\225\187\157i ch\198\161i, 1: T\195\170n \196\145\225\186\161o c\225\187\165"
  },
  {
    id = 16001,
    priority = 2,
    style = 1,
    systemChat = "Ch\195\186c m\225\187\171ng <color=#FBD994>%s</color>Ho\195\160n th\195\160nh Nhi\225\187\135m V\225\187\165 Thi\195\170n S\225\187\169, nh\225\186\173n <color=#e8d04b>%s</color>!",
    remarks = "0: T\195\170n ng\198\176\225\187\157i ch\198\161i, 1: T\195\170n \196\145\225\186\161o c\225\187\165"
  },
  {
    id = 17001,
    type = "7",
    priority = 3,
    systemChat = "1",
    remarks = "Gi\225\187\141t M\195\161u \196\144\225\186\167u Ti\195\170n",
    acceptCondition = {
      {101, 100}
    },
    audioID = 6301
  },
  {
    id = 17002,
    type = "7",
    systemChat = "2",
    remarks = "Double Kill",
    acceptCondition = {
      {101, 100}
    },
    audioID = 6302
  },
  {
    id = 17003,
    type = "7",
    priority = 2,
    systemChat = "3",
    remarks = "Tam Li\195\170n Quy\225\186\191t Th\225\186\175ng",
    acceptCondition = {
      {101, 100}
    },
    audioID = 6303
  },
  {
    id = 17004,
    type = "7",
    priority = 3,
    systemChat = "4",
    remarks = "T\225\187\169 Li\195\170n Si\195\170u Ph\195\160m",
    acceptCondition = {
      {101, 100}
    },
    audioID = 6304
  },
  {
    id = 17005,
    type = "7",
    priority = 4,
    systemChat = "5",
    remarks = "Ng\197\169 Li\195\170n Tuy\225\187\135t Th\225\186\191",
    acceptCondition = {
      {101, 100}
    },
    audioID = 6305
  },
  {
    id = 17006,
    type = "7",
    priority = 5,
    systemChat = "6",
    remarks = "Nh\198\176 Th\225\186\167n Gi\195\161ng L\195\162m",
    acceptCondition = {
      {101, 100}
    },
    audioID = 6306
  },
  {
    id = 17007,
    type = "7",
    priority = 2,
    systemChat = "A",
    remarks = "\196\144\225\186\161i S\195\161t",
    acceptCondition = {
      {101, 100}
    },
    audioID = 6307
  },
  {
    id = 17008,
    type = "7",
    priority = 3,
    systemChat = "B",
    remarks = "Kh\195\180ng Ai C\225\186\163n N\225\187\149i",
    acceptCondition = {
      {101, 100}
    },
    audioID = 6308
  },
  {
    id = 17009,
    type = "7",
    priority = 3,
    systemChat = "D",
    remarks = "C\195\160n Qu\195\169t V\225\186\161n Qu\195\162n",
    acceptCondition = {
      {101, 100}
    },
    audioID = 6309
  },
  {
    id = 17010,
    type = "7",
    priority = 4,
    systemChat = "C",
    remarks = "Ch\195\186a T\225\187\131 Chi\225\186\191n Tr\198\176\225\187\157ng",
    acceptCondition = {
      {101, 100}
    },
    audioID = 6310
  },
  {
    id = 17011,
    type = "7",
    priority = 5,
    systemChat = "E",
    remarks = "Thi\195\170n H\225\186\161 V\195\180 Song",
    acceptCondition = {
      {101, 100}
    },
    audioID = 6311
  },
  {
    id = 17012,
    type = "7",
    priority = 4,
    systemChat = "F",
    remarks = "M\225\187\153t \196\144\195\178n K\225\186\191t Li\225\187\133u",
    acceptCondition = {
      {101, 100}
    },
    audioID = 6312
  },
  {
    id = 18001,
    priority = 3,
    systemChat = "<color=#FBD994>%s</color> \196\145\195\163 \196\145o\225\186\161t \196\145\198\176\225\187\163c <color=#ff2323>M\195\161u \196\144\225\186\167u</color>!",
    remarks = "Gi\225\187\141t M\195\161u \196\144\225\186\167u Ti\195\170n",
    acceptCondition = {
      {101, 100}
    },
    audioID = 6301
  },
  {
    id = 18002,
    systemChat = "<color=#FBD994>%s</color> \196\145\195\163 ho\195\160n th\195\160nh 1 l\225\186\167n <color=#ff2323>Double Kill</color>!",
    remarks = "Double Kill",
    acceptCondition = {
      {101, 100}
    },
    audioID = 6302
  },
  {
    id = 18003,
    priority = 2,
    systemChat = "<color=#FBD994>%s</color> \196\145\195\163 ho\195\160n th\195\160nh 1 l\225\186\167n <color=#ff2323>Tam Li\195\170n Quy\225\186\191t Th\225\186\175ng</color>!",
    remarks = "Tam Li\195\170n Quy\225\186\191t Th\225\186\175ng",
    acceptCondition = {
      {101, 100}
    },
    audioID = 6303
  },
  {
    id = 18004,
    priority = 3,
    systemChat = "<color=#FBD994>%s</color> \196\145\195\163 ho\195\160n th\195\160nh 1 l\225\186\167n <color=#ff2323>T\225\187\169 Li\195\170n Si\195\170u Ph\195\160m</color>!",
    remarks = "T\225\187\169 Li\195\170n Si\195\170u Ph\195\160m",
    acceptCondition = {
      {101, 100}
    },
    audioID = 6304
  },
  {
    id = 18005,
    priority = 4,
    systemChat = "<color=#FBD994>%s</color> \196\145\195\163 ho\195\160n th\195\160nh 1 l\225\186\167n <color=#ff2323>Ng\197\169 Li\195\170n Tuy\225\187\135t S\195\161t</color>!",
    remarks = "Ng\197\169 Li\195\170n Tuy\225\187\135t Th\225\186\191",
    acceptCondition = {
      {101, 100}
    },
    audioID = 6305
  },
  {
    id = 18006,
    priority = 5,
    systemChat = "<color=#FBD994>%s</color> \196\145\195\163 th\195\160nh <color=#ff2323>Si\195\170u Th\225\186\167n S\195\161t L\225\187\165c</color>, ai \196\145\195\179 h\195\163y ti\195\170u di\225\187\135t h\225\186\175n \196\145i!!!",
    remarks = "Nh\198\176 Th\225\186\167n Gi\195\161ng L\195\162m",
    acceptCondition = {
      {101, 100}
    },
    audioID = 6306
  },
  {
    id = 18007,
    priority = 2,
    systemChat = "<color=#FBD994>%s</color> t\195\173ch l\197\169y \196\145\195\161nh b\225\186\161i 3 ng\198\176\225\187\157i, \196\145ang <color=#ff2323> \196\144\225\186\161i S\195\161t</color>!",
    remarks = "\196\144\225\186\161i S\195\161t",
    acceptCondition = {
      {101, 100}
    },
    audioID = 6307
  },
  {
    id = 18008,
    priority = 3,
    systemChat = "<color=#FBD994>%s</color> t\195\173ch l\197\169y \196\145\195\161nh b\225\186\161i 5 ng\198\176\225\187\157i, \196\145\195\163 <color=#ff2323> Kh\195\180ng Ai C\225\186\163n N\225\187\149i</color>",
    remarks = "Kh\195\180ng Ai C\225\186\163n N\225\187\149i",
    acceptCondition = {
      {101, 100}
    },
    audioID = 6308
  },
  {
    id = 18009,
    priority = 3,
    systemChat = "<color=#FBD994>%s</color> t\195\173ch l\197\169y \196\145\195\161nh b\225\186\161i 8 ng\198\176\225\187\157i, \196\145\195\163 <color=#ff2323> C\195\160n Qu\195\169t V\225\186\161n Qu\195\162n</color>",
    remarks = "C\195\160n Qu\195\169t V\225\186\161n Qu\195\162n",
    acceptCondition = {
      {101, 100}
    },
    audioID = 6309
  },
  {
    id = 18010,
    priority = 4,
    systemChat = "<color=#FBD994>%s</color> t\195\173ch l\197\169y \196\145\195\161nh b\225\186\161i 10 ng\198\176\225\187\157i, \196\145\195\163 th\195\160nh <color=#ff2323>Ch\195\186a T\225\187\131 Chi\225\186\191n Tr\198\176\225\187\157ng</color>",
    remarks = "Ch\195\186a T\225\187\131 Chi\225\186\191n Tr\198\176\225\187\157ng",
    acceptCondition = {
      {101, 100}
    },
    audioID = 6310
  },
  {
    id = 18011,
    priority = 5,
    systemChat = "<color=#FBD994>%s</color> t\195\173ch l\197\169y \196\145\195\161nh b\225\186\161i 20 ng\198\176\225\187\157i, \196\145\195\163 th\195\160nh <color=#ff2323> Thi\195\170n H\225\186\161 V\195\180 Song</color>",
    remarks = "Thi\195\170n H\225\186\161 V\195\180 Song",
    acceptCondition = {
      {101, 100}
    },
    audioID = 6311
  },
  {
    id = 18012,
    priority = 4,
    systemChat = "<color=#FBD994>%s</color> \196\145\195\163 k\225\186\191t li\225\187\133u <color=#ff2323>%s</color>-<color=#ff2323>%s</color>",
    remarks = "M\225\187\153t \196\144\195\178n K\225\186\191t Li\225\187\133u",
    acceptCondition = {
      {101, 100}
    },
    audioID = 6312
  },
  {
    id = 21001,
    systemChat = "Ch\195\186c m\225\187\171ng ng\198\176\225\187\157i ch\198\161i <color=#FBD994>%s</color> <color=#FBD994>%s</color> <color=#FBD994>%s</color> trong <color=#2d9eff>B\225\186\163ng S\196\131n Ma</color> <color=#3CD937>d\197\169ng c\225\186\163m \196\145o\225\186\161t Top 3</color>, <color=#FF2323>v\195\180 \196\145\225\187\139ch kh\195\180ng \196\145\225\187\145i th\225\187\167</color>, nh\225\186\173n <color=#FF0000>BUFF T\196\131ng DMG</color> \196\145\225\187\145i v\225\187\155i qu\195\161i, t\196\131ng m\225\186\161nh Hi\225\187\135u Su\225\186\165t \196\144\195\161nh Qu\195\161i v\195\160 T\225\187\145c \196\144\225\187\153 T\196\131ng C\225\186\165p",
    acceptCondition = {
      {101, 100}
    }
  },
  {
    id = 81001001,
    type = "2",
    priority = 2,
    systemChat = "Th\225\186\161ch Anh phe ta \196\145\195\163 b\225\187\139 ph\195\161 v\225\187\161, <color=#B22222>chi\225\186\191n \196\145\225\186\165u th\225\186\165t b\225\186\161i</color>",
    acceptCondition = {
      {101, 1}
    }
  },
  {
    id = 81001002,
    type = "2",
    priority = 2,
    systemChat = "Th\225\186\161ch Anh phe \196\145\225\187\139ch b\225\187\139 ph\195\161 v\225\187\161, <color=#1add1f>chi\225\186\191n \196\145\225\186\165u th\225\186\175ng l\225\187\163i</color>",
    acceptCondition = {
      {101, 1}
    }
  },
  {
    id = 81001003,
    type = "2",
    priority = 2,
    systemChat = "<color=#1add1f>%s</color> \196\145\195\163 ph\195\161 v\225\187\161 c\225\187\149ng th\195\160nh c\225\187\167a phe \196\145\225\187\139ch",
    acceptCondition = {
      {101, 1}
    }
  },
  {
    id = 81001004,
    type = "2",
    priority = 2,
    systemChat = "C\225\187\149ng th\195\160nh phe ta b\225\187\139 <color=#B22222>%s</color> ph\195\161 v\225\187\161",
    acceptCondition = {
      {101, 1}
    }
  },
  {
    id = 81001005,
    type = "3",
    priority = 2,
    systemChat = "Ph\195\185 V\196\131n H\225\187\143a Long \196\145\195\163 l\195\160m m\225\187\155i trong trung t\195\162m chi\225\186\191n tr\198\176\225\187\157ng",
    acceptCondition = {
      {101, 1}
    }
  },
  {
    id = 81001006,
    type = "3",
    priority = 2,
    systemChat = "<color=#1add1f>%s</color> \196\145\195\163 gi\195\160nh \196\145\198\176\225\187\163c Ph\195\185 V\196\131n H\225\187\143a Long",
    acceptCondition = {
      {101, 1}
    }
  },
  {
    id = 81001007,
    type = "3",
    priority = 2,
    systemChat = "<color=#1add1f>%s</color> \196\145\195\163 ti\195\170u di\225\187\135t Th\225\187\167 H\225\187\153 phe \196\145\225\187\139ch",
    acceptCondition = {
      {101, 1}
    }
  },
  {
    id = 81001008,
    type = "3",
    priority = 2,
    systemChat = "Th\225\187\167 v\225\187\135 phe ta b\225\187\139 <color=#B22222>%s</color> ti\195\170u di\225\187\135t",
    acceptCondition = {
      {101, 1}
    }
  },
  {
    id = 81001009,
    type = "2",
    priority = 2,
    systemChat = "Qua s\225\187\177 \196\145\225\187\147ng \195\189 nh\225\186\165t tr\195\173, phe \196\145\225\187\139ch tuy\195\170n b\225\187\145 <color=#B22222>\196\145\225\186\167u h\195\160ng</color>",
    acceptCondition = {
      {101, 1}
    }
  },
  {
    id = 81001010,
    type = "2",
    priority = 2,
    systemChat = "Sau khi nh\225\186\165t tr\195\173, phe ta tuy\195\170n b\225\187\145 <color=#B22222>\196\145\225\186\167u h\195\160ng</color>",
    acceptCondition = {
      {101, 1}
    }
  },
  {
    id = 81001011,
    type = "2",
    priority = 2,
    systemChat = "HP c\195\178n l\225\186\161i c\225\187\167a c\225\187\149ng th\195\160nh <color=#1add1f>phe ta</color> <color=#B22222>%s</color><color=#B22222>%%</color>"
  },
  {
    id = 81001012,
    type = "2",
    priority = 2,
    systemChat = "C\225\187\149ng th\195\160nh <color=#B22222>phe \196\145\225\187\139ch</color> c\195\178n l\225\186\161i HP <color=#B22222>%s</color><color=#B22222>%%</color>"
  },
  {
    id = 81001013,
    type = "2",
    priority = 2,
    systemChat = "Th\225\186\161ch Anh <color=#1add1f>phe ta</color> c\195\178n l\225\186\161i HP <color=#B22222>%s</color><color=#B22222>%%</color>",
    acceptCondition = {
      {101, 1}
    }
  },
  {
    id = 81001014,
    type = "2",
    priority = 2,
    systemChat = "Th\225\186\161ch Anh <color=#B22222>phe \196\145\225\187\139ch</color> c\195\178n l\225\186\161i HP <color=#B22222>%s</color><color=#B22222>%%</color>",
    acceptCondition = {
      {101, 1}
    }
  },
  {
    id = 81001101,
    type = "3",
    systemChat = "%s \196\145\195\163 ti\195\170u di\225\187\135t %s",
    acceptCondition = {
      {101, 1}
    }
  },
  {
    id = 81001102,
    type = "3",
    systemChat = "%s \196\145\195\163 h\225\187\147i sinh",
    acceptCondition = {
      {101, 1}
    }
  },
  {
    id = 81001103,
    type = "3",
    systemChat = "%s m\225\186\165t k\225\186\191t n\225\187\145i",
    acceptCondition = {
      {101, 1}
    }
  },
  {
    id = 81001104,
    type = "3",
    systemChat = "%s tr\225\187\159 l\225\186\161i chi\225\186\191n tr\198\176\225\187\157ng",
    acceptCondition = {
      {101, 1}
    }
  },
  {
    id = 22001,
    type = "1&2",
    systemChat = "<color=#ff8a00>%s</color> xu\225\186\165t hi\225\187\135n v\225\187\155i uy l\225\187\177c kinh ho\195\160ng, xu\225\186\165t hi\225\187\135n trong <color=#16de32>%s</color>, c\195\161c Chi\225\186\191n Binh h\195\163y mau \196\145\225\186\191n ti\195\170u di\225\187\135t!",
    remarks = "0 t\195\170n qu\195\161i, 1 t\195\170n b\225\186\163n \196\145\225\187\147",
    acceptCondition = {
      {7001, 4}
    }
  },
  {
    id = 22002,
    type = "1&2",
    priority = 2,
    style = 1,
    systemChat = "<color=#FBD994>%s</color> trong <color=#16de32>%s</color> \196\145\195\163 nh\225\186\183t <color=#fa4729>[B\225\187\153 C\225\187\177c Ph\225\186\169m]</color>$1<a href=[system: 1]>%s</a></color>",
    acceptCondition = {
      {7001, 4}
    },
    conductType = "2"
  },
  {
    id = 23001,
    type = "1&2",
    systemChat = "<color=#ff8a00>%s</color> xu\225\186\165t hi\225\187\135n v\225\187\155i uy l\225\187\177c kinh ho\195\160ng, xu\225\186\165t hi\225\187\135n trong <color=#16de32>%s</color>, c\195\161c Chi\225\186\191n Binh h\195\163y mau \196\145\225\186\191n ti\195\170u di\225\187\135t!",
    remarks = "0 t\195\170n qu\195\161i, 1 t\195\170n b\225\186\163n \196\145\225\187\147",
    acceptCondition = {
      {7001, 6}
    }
  },
  {
    id = 23002,
    type = "1&2",
    priority = 2,
    style = 1,
    systemChat = "<color=#FBD994>%s</color> trong <color=#16de32>%s</color> \196\145\195\163 nh\225\186\183t <color=#fa4729>[B\225\187\153 C\225\187\177c Ph\225\186\169m]</color>$1<a href=[system:1]>%s</a>",
    acceptCondition = {
      {7001, 6}
    },
    conductType = "2"
  },
  {
    id = 24001,
    type = "1&2",
    systemChat = "<color=#FBD994>%s</color> trong <color=#16de32>%s</color> tri\225\187\135u h\225\187\147i th\195\160nh c\195\180ng <color=#fa4729>[BOSS Bi\225\186\191n D\225\187\139]</color><color=#ff8a00>%s</color>, ch\225\186\175c ch\225\186\175n n\225\187\149 <color=#fa4729>v\195\180 s\225\187\145 Thu\225\187\145c EXP</color>!!!",
    remarks = "0 t\195\170n ng\198\176\225\187\157i ch\198\161i, 1 t\195\170n b\225\186\163n \196\145\225\187\147: XY t\225\187\141a \196\145\225\187\153, 2 t\195\170n qu\195\161i",
    acceptCondition = {
      {101, 100}
    }
  },
  {
    id = 24002,
    type = "1&2",
    priority = 2,
    style = 1,
    systemChat = "<color=#FBD994>%s</color> trong <color=#16de32>%s</color> ti\195\170u di\225\187\135t <color=#ff8a00>%s</color> \196\145\195\163 r\198\161i ra <color=#fa4729>[B\225\187\153 C\225\187\177c Ph\225\186\169m]</color>$1<a href=[system: 1]>%s</a></color>",
    acceptCondition = {
      {104, 0}
    },
    conductType = "2"
  },
  {
    id = 120001,
    type = "9",
    systemChat = "<color=#16de32>%s</color> trong <color=#FBD994>%s</color> b\225\187\139 Guild <color=#de3716>%s</color>-<color=#de3716>%s</color> ti\195\170u di\225\187\135t, xin h\195\163y <color=#de3716>\196\145\225\186\191n chi vi\225\187\135n</color>!!",
    remarks = "0 t\195\170n \196\145\225\187\147ng minh, 1 t\195\170n b\225\186\163n \196\145\225\187\147, 2 t\195\170n Guild \196\145\225\187\139ch, 3 t\195\170n th\195\160nh vi\195\170n Guild \196\145\225\187\139ch",
    jumpUi = "250001",
    acceptCondition = {
      {7001, 4}
    },
    conductType = "5"
  },
  {
    id = 120002,
    type = "9",
    systemChat = "<color=#16de32>%s</color> trong <color=#FBD994>%s</color> b\225\187\139 Guild <color=#de3716>%s</color>-<color=#de3716>%s</color> ti\195\170u di\225\187\135t, xin h\195\163y <color=#de3716>\196\145\225\186\191n chi vi\225\187\135n</color>!!",
    remarks = "0 t\195\170n \196\145\225\187\147ng minh, 1 t\195\170n b\225\186\163n \196\145\225\187\147, 2 t\195\170n Guild \196\145\225\187\139ch, 3 t\195\170n th\195\160nh vi\195\170n Guild \196\145\225\187\139ch",
    jumpUi = "270001",
    acceptCondition = {
      {7001, 6}
    },
    conductType = "5"
  },
  {
    id = 25001,
    type = "1&2",
    systemChat = "\196\144\195\163 %s gi\225\187\157 tr\195\180i qua t\225\187\171 khi b\225\186\175t \196\145\225\186\167u tr\195\178 ch\198\161i. Ch\198\161i game qu\195\161 nhi\225\187\129u c\195\179 th\225\187\131 \225\186\163nh h\198\176\225\187\159ng \196\145\225\186\191n s\225\187\169c kh\225\187\143e c\225\187\167a b\225\186\161n, h\195\163y ki\225\187\131m so\195\161t th\225\187\157i gian ch\198\161i game.",
    acceptCondition = {
      {101, 1}
    }
  },
  {
    id = 1020601,
    type = "1&5",
    style = 1,
    systemChat = "Guild Tranh \196\144o\225\186\161t \196\145\195\163 m\225\187\159, h\195\163y \196\145\225\186\191n c\198\176\225\187\155p c\225\187\157",
    countdown = 120,
    acceptCondition = {
      {101, 100}
    }
  },
  {
    id = 1020602,
    type = "2",
    priority = 2,
    style = 1,
    systemChat = "Ng\198\176\225\187\157i ch\198\161i Guild <color=#ff8a00>[%s]</color> <color=#FBD994>%s</color> \196\145\195\163 chi\225\186\191m %s, S\196\169 Kh\195\173 t\196\131ng m\225\186\161nh.",
    acceptCondition = {
      {101, 100}
    }
  },
  {
    id = 1020603,
    type = "2",
    priority = 2,
    style = 1,
    systemChat = "Guild <color=#ff8a00>[%s]</color> \196\145\195\163 chi\225\186\191m li\195\170n t\225\187\165c <color=#ff2323>5 l\195\161 c\225\187\157</color>, kh\195\180ng ai c\225\186\163n n\225\187\149i.",
    acceptCondition = {
      {101, 100}
    }
  },
  {
    id = 1020604,
    type = "2",
    priority = 2,
    style = 1,
    systemChat = "Guild <color=#ff8a00>[%s]</color> \196\145\195\163 li\195\170n t\225\187\165c chi\225\186\191m <color=#ff2323>10 l\195\161 c\225\187\157</color>, Ch\195\186a T\225\187\131 c\198\176\225\187\155p c\225\187\157, ai c\195\179 th\225\187\131 c\225\186\161nh tranh?",
    acceptCondition = {
      {101, 100}
    }
  },
  {
    id = 1020605,
    type = "2",
    priority = 2,
    style = 1,
    systemChat = "Ng\198\176\225\187\157i ch\198\161i Guild <color=#ff8a00>[%s]</color> <color=#FBD994>%s</color> c\195\185ng nhi\225\187\129u ng\198\176\225\187\157i ch\198\161i \196\145\195\163 chi\225\186\191m %s, S\196\169 Kh\195\173 t\196\131ng m\225\186\161nh.",
    acceptCondition = {
      {101, 100}
    }
  },
  {
    id = 1020606,
    type = "1&10",
    priority = 2,
    systemChat = "Ng\198\176\225\187\157i ch\198\161i Guild <color=#ff8a00>[%s]</color> <color=#28E529>%s</color> \196\145\195\163 Tam Li\195\170n Quy\225\186\191t Th\225\186\175ng, \196\145o\225\186\161t \196\145\198\176\225\187\163c <color=#FF2323>%s Li\195\170n Tr\225\186\163m</color>",
    acceptCondition = {
      {101, 100}
    },
    remarksUI = "<color=#ff8a00>[%s]</color> \234\184\184\235\147\156\236\155\144 <color=#28E529>%s</color> \237\138\184\235\166\172\237\148\140\237\130\172!"
  },
  {
    id = 1020607,
    type = "1&10",
    priority = 3,
    systemChat = "Ng\198\176\225\187\157i ch\198\161i Guild <color=#ff8a00>[%s]</color> <color=#28E529>%s</color> \196\145\195\163 Ng\197\169 Li\195\170n Tuy\225\187\135t Th\225\186\191, \196\145o\225\186\161t \196\145\198\176\225\187\163c <color=#FF2323>%s Li\195\170n Tr\225\186\163m</color>",
    acceptCondition = {
      {101, 100}
    },
    remarksUI = "<color=#ff8a00>[%s]</color> \234\184\184\235\147\156\236\155\144 <color=#28E529>%s</color> \237\142\156\237\131\128\237\130\172!"
  },
  {
    id = 1020608,
    type = "1&10",
    priority = 4,
    systemChat = "Ng\198\176\225\187\157i ch\198\161i Guild <color=#ff8a00>[%s]</color> <color=#28E529>%s</color> \196\145\195\163 Nh\198\176 Th\225\186\167n Gi\195\161ng L\195\162m, \196\145o\225\186\161t \196\145\198\176\225\187\163c <color=#FF2323>%s Li\195\170n Tr\225\186\163m</color>",
    acceptCondition = {
      {101, 100}
    },
    remarksUI = "<color=#ff8a00>[%s]</color> \234\184\184\235\147\156\236\155\144 <color=#28E529>%s</color> \236\139\160\236\157\152\234\178\189\236\167\128!"
  },
  {
    id = 1020609,
    type = "1&10",
    priority = 5,
    systemChat = "Ng\198\176\225\187\157i ch\198\161i Guild <color=#ff8a00>[%s]</color> <color=#28E529>%s</color> \196\145\195\163 \196\144\225\186\161i S\195\161t, \196\145o\225\186\161t \196\145\198\176\225\187\163c <color=#FF2323>%s Li\195\170n Tr\225\186\163m</color>",
    acceptCondition = {
      {101, 100}
    },
    remarksUI = "<color=#ff8a00>[%s]</color> \234\184\184\235\147\156\236\155\144 <color=#28E529>%s</color> \237\143\173\236\163\188!"
  },
  {
    id = 1020610,
    type = "1&10",
    priority = 6,
    systemChat = "Ng\198\176\225\187\157i ch\198\161i Guild <color=#ff8a00>[%s]</color> <color=#28E529>%s</color> \196\145\195\163 Kh\195\180ng Ai C\225\186\163n N\225\187\149i, \196\145o\225\186\161t \196\145\198\176\225\187\163c <color=#FF2323>%s Li\195\170n Tr\225\186\163m</color>",
    acceptCondition = {
      {101, 100}
    },
    remarksUI = "<color=#ff8a00>[%s]</color> \234\184\184\235\147\156\236\155\144 <color=#28E529>%s</color> \236\151\176\236\160\132\236\151\176\236\138\185!"
  },
  {
    id = 1020611,
    type = "1&10",
    priority = 7,
    systemChat = "Ng\198\176\225\187\157i ch\198\161i Guild <color=#ff8a00>[%s]</color> <color=#28E529>%s</color> \196\145\195\163 C\195\160n Qu\195\169t V\225\186\161n Qu\195\162n, \196\145o\225\186\161t \196\145\198\176\225\187\163c <color=#FF2323>%s Li\195\170n Tr\225\186\163m</color>",
    acceptCondition = {
      {101, 100}
    },
    remarksUI = "<color=#ff8a00>[%s]</color> \234\184\184\235\147\156\236\155\144 <color=#28E529>%s</color> \236\178\156\237\149\152\235\172\180\236\160\129!"
  },
  {
    id = 1020612,
    type = "1&10",
    priority = 8,
    systemChat = "Ng\198\176\225\187\157i ch\198\161i Guild <color=#ff8a00>[%s]</color> <color=#28E529>%s</color> \196\145\195\163 th\195\160nh Ch\195\186a T\225\187\131 Chi\225\186\191n Tr\198\176\225\187\157ng, \196\145o\225\186\161t \196\145\198\176\225\187\163c <color=#FF2323>%s Li\195\170n Tr\225\186\163m</color>",
    acceptCondition = {
      {101, 100}
    },
    remarksUI = "<color=#ff8a00>[%s]</color> \234\184\184\235\147\156\236\155\144 <color=#28E529>%s</color> \236\167\128\235\176\176\236\158\144!"
  },
  {
    id = 1020613,
    type = "1&10",
    priority = 9,
    systemChat = "Ng\198\176\225\187\157i ch\198\161i Guild <color=#ff8a00>[%s]</color> <color=#28E529>%s</color> \196\145\195\163 th\195\160nh Thi\195\170n H\225\186\161 V\195\180 Song, \196\145o\225\186\161t \196\145\198\176\225\187\163c <color=#FF2323>%s Li\195\170n Tr\225\186\163m</color>",
    acceptCondition = {
      {101, 100}
    },
    remarksUI = "<color=#ff8a00>[%s]</color> \234\184\184\235\147\156\236\155\144 <color=#28E529>%s</color> \236\178\156\237\149\152\236\160\156\236\157\188!"
  },
  {
    id = 1020614,
    type = "1&10",
    priority = 5,
    systemChat = "Ng\198\176\225\187\157i ch\198\161i Guild <color=#28E529>%s</color> \196\145\195\163 k\225\186\191t li\225\187\133u ng\198\176\225\187\157i ch\198\161i Guild <color=#FF2323>%s</color>-<color=#FF2323>%s Li\195\170n Tr\225\186\163m</color>",
    acceptCondition = {
      {101, 100}
    }
  },
  {
    id = 1020615,
    type = "1&10",
    priority = 2,
    systemChat = "Ng\198\176\225\187\157i ch\198\161i Guild <color=#ff8a00>[%s]</color> <color=#FF2323>%s</color> \196\145\195\163 Tam Li\195\170n Quy\225\186\191t Th\225\186\175ng, \196\145o\225\186\161t \196\145\198\176\225\187\163c <color=#FF2323>%s Li\195\170n Tr\225\186\163m</color>",
    acceptCondition = {
      {101, 100}
    },
    remarksUI = "<color=#ff8a00>[%s]</color> \234\184\184\235\147\156\236\155\144 <color=#FF2323>%s</color> \237\138\184\235\166\172\237\148\140\237\130\172!"
  },
  {
    id = 1020616,
    type = "1&10",
    priority = 3,
    systemChat = "Ng\198\176\225\187\157i ch\198\161i Guild <color=#ff8a00>[%s]</color> <color=#FF2323>%s</color> \196\145\195\163 Ng\197\169 Li\195\170n Tuy\225\187\135t Th\225\186\191, \196\145o\225\186\161t \196\145\198\176\225\187\163c <color=#FF2323>%s Li\195\170n Tr\225\186\163m</color>",
    acceptCondition = {
      {101, 100}
    },
    remarksUI = "<color=#ff8a00>[%s]</color> \234\184\184\235\147\156\236\155\144 <color=#FF2323>%s</color> \237\142\156\237\131\128\237\130\172!"
  },
  {
    id = 1020617,
    type = "1&10",
    priority = 4,
    systemChat = "Ng\198\176\225\187\157i ch\198\161i Guild <color=#ff8a00>[%s]</color> <color=#FF2323>%s</color> \196\145\195\163 Nh\198\176 Th\225\186\167n Gi\195\161ng L\195\162m, \196\145o\225\186\161t \196\145\198\176\225\187\163c <color=#FF2323>%s Li\195\170n Tr\225\186\163m</color>",
    acceptCondition = {
      {101, 100}
    },
    remarksUI = "<color=#ff8a00>[%s]</color> \234\184\184\235\147\156\236\155\144 <color=#FF2323>%s</color> \236\139\160\236\157\152\234\178\189\236\167\128!"
  },
  {
    id = 1020618,
    type = "1&10",
    priority = 5,
    systemChat = "Ng\198\176\225\187\157i ch\198\161i Guild <color=#ff8a00>[%s]</color> <color=#FF2323>%s</color> \196\145\195\163 \196\144\225\186\161i S\195\161t, \196\145o\225\186\161t \196\145\198\176\225\187\163c <color=#FF2323>%s Li\195\170n Tr\225\186\163m</color>",
    acceptCondition = {
      {101, 100}
    },
    remarksUI = "<color=#ff8a00>[%s]</color> \234\184\184\235\147\156\236\155\144 <color=#FF2323>%s</color> \237\143\173\236\163\188!"
  },
  {
    id = 1020619,
    type = "1&10",
    priority = 6,
    systemChat = "Ng\198\176\225\187\157i ch\198\161i Guild <color=#ff8a00>[%s]</color> <color=#FF2323>%s</color> \196\145\195\163 Kh\195\180ng Ai C\225\186\163n N\225\187\149i, \196\145o\225\186\161t \196\145\198\176\225\187\163c <color=#FF2323>%s Li\195\170n Tr\225\186\163m</color>",
    acceptCondition = {
      {101, 100}
    },
    remarksUI = "<color=#ff8a00>[%s]</color> \234\184\184\235\147\156\236\155\144 <color=#FF2323>%s</color> \236\151\176\236\160\132\236\151\176\236\138\185!"
  },
  {
    id = 1020620,
    type = "1&10",
    priority = 7,
    systemChat = "Ng\198\176\225\187\157i ch\198\161i Guild <color=#ff8a00>[%s]</color> <color=#FF2323>%s</color> \196\145\195\163 C\195\160n Qu\195\169t V\225\186\161n Qu\195\162n, \196\145o\225\186\161t \196\145\198\176\225\187\163c <color=#FF2323>%s Li\195\170n Tr\225\186\163m</color>",
    acceptCondition = {
      {101, 100}
    },
    remarksUI = "<color=#ff8a00>[%s]</color> \234\184\184\235\147\156\236\155\144 <color=#FF2323>%s</color> \236\178\156\237\149\152\235\172\180\236\160\129!"
  },
  {
    id = 1020621,
    type = "1&10",
    priority = 8,
    systemChat = "Ng\198\176\225\187\157i ch\198\161i Guild <color=#ff8a00>[%s]</color> <color=#FF2323>%s</color> \196\145\195\163 th\195\160nh Ch\195\186a T\225\187\131 Chi\225\186\191n Tr\198\176\225\187\157ng, \196\145o\225\186\161t \196\145\198\176\225\187\163c <color=#FF2323>%s Li\195\170n Tr\225\186\163m</color>",
    acceptCondition = {
      {101, 100}
    },
    remarksUI = "<color=#ff8a00>[%s]</color> \234\184\184\235\147\156\236\155\144 <color=#FF2323>%s</color> \236\167\128\235\176\176\236\158\144!"
  },
  {
    id = 1020622,
    type = "1&10",
    priority = 9,
    systemChat = "Ng\198\176\225\187\157i ch\198\161i Guild <color=#ff8a00>[%s]</color> <color=#FF2323>%s</color> \196\145\195\163 th\195\160nh Thi\195\170n H\225\186\161 V\195\180 Song, \196\145o\225\186\161t \196\145\198\176\225\187\163c <color=#FF2323>%s Li\195\170n Tr\225\186\163m</color>",
    acceptCondition = {
      {101, 100}
    },
    remarksUI = "<color=#ff8a00>[%s]</color> \234\184\184\235\147\156\236\155\144 <color=#FF2323>%s</color> \236\178\156\237\149\152\236\160\156\236\157\188!"
  },
  {
    id = 1020623,
    type = "1&10",
    priority = 5,
    systemChat = " ng\198\176\225\187\157i ch\198\161i Guild <color=#FF2323>%s</color> \196\145\195\163 k\225\186\191t li\225\187\133u ng\198\176\225\187\157i ch\198\161i Guild <color=#28E529>%s</color>-<color=#FF2323>%s Li\195\170n Tr\225\186\163m</color>",
    acceptCondition = {
      {101, 100}
    }
  },
  {
    id = 1020624,
    type = "1&10",
    priority = 5,
    systemChat = " ng\198\176\225\187\157i ch\198\161i Guild <color=#FF2323>%s</color> \196\145\195\163 k\225\186\191t li\225\187\133u ng\198\176\225\187\157i ch\198\161i Guild <color=#FF2323>%s</color>-<color=#FF2323>%s Li\195\170n Tr\225\186\163m</color>",
    acceptCondition = {
      {101, 100}
    }
  },
  {
    id = 1020625,
    type = "1&10",
    priority = 10,
    systemChat = "Ng\198\176\225\187\157i ch\198\161i Guild <color=#ff8a00>[%s]</color> <color=#28E529>%s</color> \196\145\195\163 th\195\160nh Thi\195\170n H\225\186\161 V\195\180 Song, \196\145o\225\186\161t \196\145\198\176\225\187\163c <color=#FF2323>%s Li\195\170n Tr\225\186\163m</color>",
    acceptCondition = {
      {101, 100}
    },
    remarksUI = "<color=#ff8a00>[%s]</color> \234\184\184\235\147\156\236\155\144 <color=#28E529>%s</color> \236\178\156\237\149\152\236\160\156\236\157\188!"
  },
  {
    id = 1020626,
    type = "1&10",
    priority = 10,
    systemChat = "Ng\198\176\225\187\157i ch\198\161i Guild <color=#ff8a00>[%s]</color> <color=#FF2323>%s</color> \196\145\195\163 th\195\160nh Thi\195\170n H\225\186\161 V\195\180 Song, \196\145o\225\186\161t \196\145\198\176\225\187\163c <color=#FF2323>%s Li\195\170n Tr\225\186\163m</color>",
    acceptCondition = {
      {101, 100}
    },
    remarksUI = "<color=#ff8a00>[%s]</color> \234\184\184\235\147\156\236\155\144 <color=#FF2323>%s</color> \236\178\156\237\149\152\236\160\156\236\157\188!"
  },
  {
    id = 1020627,
    priority = 2,
    systemChat = "Ng\198\176\225\187\157i ch\198\161i Guild <color=#ff8a00>[%s]</color> <color=#FBD994>%s</color> \196\145\195\163 chi\225\186\191m %s, S\196\169 Kh\195\173 t\196\131ng m\225\186\161nh.",
    acceptCondition = {
      {101, 100}
    }
  },
  {
    id = 1020628,
    priority = 2,
    systemChat = "Ng\198\176\225\187\157i ch\198\161i Guild <color=#ff8a00>[%s]</color> <color=#FBD994>%s</color> c\195\185ng nhi\225\187\129u ng\198\176\225\187\157i ch\198\161i \196\145\195\163 chi\225\186\191m %s, S\196\169 Kh\195\173 t\196\131ng m\225\186\161nh.",
    acceptCondition = {
      {101, 100}
    }
  },
  {
    id = 1020629,
    type = "1&10",
    priority = 10,
    systemChat = "Ng\198\176\225\187\157i ch\198\161i Guild <color=#ff8a00>[%s]</color> <color=#28E529>%s</color> \196\145\195\163 th\195\160nh Thi\195\170n H\225\186\161 V\195\180 Song, \196\145o\225\186\161t \196\145\198\176\225\187\163c <color=#FF2323>%s Li\195\170n Tr\225\186\163m</color>",
    acceptCondition = {
      {101, 100}
    },
    remarksUI = "<color=#ff8a00>[%s]</color> \234\184\184\235\147\156\236\155\144 <color=#28E529>%s</color> \236\178\156\237\149\152\236\160\156\236\157\188!"
  },
  {
    id = 1020630,
    type = "1&10",
    priority = 10,
    systemChat = "Ng\198\176\225\187\157i ch\198\161i Guild <color=#ff8a00>[%s]</color> <color=#FF2323>%s</color> \196\145\195\163 th\195\160nh Thi\195\170n H\225\186\161 V\195\180 Song, \196\145o\225\186\161t \196\145\198\176\225\187\163c <color=#FF2323>%s Li\195\170n Tr\225\186\163m</color>",
    acceptCondition = {
      {101, 100}
    },
    remarksUI = "<color=#ff8a00>[%s]</color> \234\184\184\235\147\156\236\155\144 <color=#FF2323>%s</color> \236\178\156\237\149\152\236\160\156\236\157\188!"
  },
  {
    id = 26001,
    priority = 2,
    style = 1,
    systemChat = "Ch\195\186c m\225\187\171ng <color=#FBD994>%s</color> m\225\187\159 H\225\187\153p Qu\195\160 Gi\195\161ng Sinh, nh\225\186\173n <color=#e8d04b>%s</color>!",
    remarks = "0: T\195\170n ng\198\176\225\187\157i ch\198\161i, 1: T\195\170n \196\145\225\186\161o c\225\187\165"
  },
  {
    id = 10391101,
    type = "1&3",
    style = 2,
    systemChat = "Ng\198\176\225\187\157i ch\198\161i <color=#FBD994>%s</color> Guild <color=#ff8a00>[%s]</color> g\195\162y cho BOSS <color=#ff2323>%s</color> \196\145\195\178n k\225\186\191t li\225\187\133u, to\195\160n Guild nh\225\186\173n \196\145\198\176\225\187\163c l\198\176\225\187\163ng l\225\187\155n nguy\195\170n li\225\187\135u.",
    acceptCondition = {
      {101, 100}
    }
  },
  {
    id = 10391102,
    type = "2",
    priority = 3,
    style = 1,
    systemChat = "Ng\198\176\225\187\157i ch\198\161i <color=#FBD994>%s</color> Guild <color=#ff8a00>[%s]</color> m\225\187\159 r\198\176\198\161ng, nh\225\186\173n \196\145\198\176\225\187\163c <color=#ff2323>%s</color>, c\195\178n l\225\186\161i <color=#B22222>%s</color> r\198\176\198\161ng",
    acceptCondition = {
      {101, 100}
    }
  },
  {
    id = 10391103,
    type = "2",
    priority = 2,
    systemChat = "BOSS t\225\186\167ng 7 Khe H\225\187\159 Th\225\187\157i Kh\195\180ng <color=#ff2323>%s</color> \196\145\195\163 xu\225\186\165t hi\225\187\135n, c\195\161c Chi\225\186\191n Binh mau t\195\172m v\195\160 ti\195\170u di\225\187\135t!",
    acceptCondition = {
      {101, 100}
    }
  },
  {
    id = 27001,
    type = "1&2",
    systemChat = "<color=#ff8a00>%s</color> xu\225\186\165t hi\225\187\135n v\225\187\155i uy l\225\187\177c kinh ho\195\160ng, xu\225\186\165t hi\225\187\135n trong <color=#16de32>%s</color>, c\195\161c Chi\225\186\191n Binh h\195\163y mau \196\145\225\186\191n ti\195\170u di\225\187\135t!",
    remarks = "0 t\195\170n qu\195\161i, 1 t\195\170n b\225\186\163n \196\145\225\187\147",
    acceptCondition = {
      {7001, 6}
    }
  },
  {
    id = 27002,
    type = "1&2",
    priority = 2,
    style = 1,
    systemChat = "<color=#FBD994>%s</color> trong <color=#16de32>%s</color> \196\145\195\163 nh\225\186\183t <color=#fa4729>[B\225\187\153 C\225\187\177c Ph\225\186\169m]</color>$1<a href=[system: 1]>%s</a></color>",
    acceptCondition = {
      {7001, 6}
    },
    conductType = "2"
  },
  {
    id = 126001,
    type = "1&2",
    systemChat = "Qu\195\161i K\225\187\183 Ni\225\187\135m s\225\186\189 xu\225\186\165t hi\225\187\135n \225\187\159 v\225\187\139 tr\195\173 ng\225\186\171u nhi\195\170n trong b\225\186\163n \196\145\225\187\147 sau 5 ph\195\186t, c\195\161c Chi\225\186\191n Binh h\195\163y chu\225\186\169n b\225\187\139 s\225\186\181n s\195\160ng",
    acceptCondition = {
      {101, 100}
    }
  },
  {
    id = 126002,
    type = "1&2",
    systemChat = "Qu\195\161i K\225\187\183 Ni\225\187\135m \196\145\195\163 xu\225\186\165t hi\225\187\135n, c\195\161c Chi\225\186\191n Binh h\195\163y kh\225\186\169n tr\198\176\198\161ng t\195\172m ki\225\186\191m v\195\160 th\225\186\163o ph\225\186\161t!",
    acceptCondition = {
      {101, 100}
    }
  },
  {
    id = 126003,
    type = "1&2",
    systemChat = "Qu\195\161i K\225\187\183 Ni\225\187\135m \196\145\195\163 b\225\187\143 ch\225\186\161y, c\195\161c Chi\225\186\191n Binh h\195\163y \196\145\225\187\163i l\225\186\167n xu\225\186\165t hi\225\187\135n k\225\186\191 ti\225\186\191p",
    acceptCondition = {
      {101, 100}
    }
  },
  {
    id = 1000000,
    type = "2",
    priority = 10,
    style = 1,
    systemChat = "Ch\198\161i qu\195\161 180 ph\195\186t m\225\187\153t ng\195\160y s\225\186\189 \225\186\163nh h\198\176\225\187\159ng x\225\186\165u \196\145\225\186\191n s\225\187\169c kh\225\187\143e",
    acceptCondition = {
      {101, 1}
    }
  },
  {
    id = 10392101,
    type = "1&5",
    style = 1,
    systemChat = "Tranh B\195\161 B\225\187\145n Ph\198\176\198\161ng \196\145\195\163 m\225\187\159, m\225\187\157i b\225\186\161n \196\145\225\186\191n tham gia tranh \196\145o\225\186\161t ",
    countdown = 120,
    acceptCondition = {
      {101, 100}
    }
  },
  {
    id = 10392102,
    type = "2",
    priority = 2,
    style = 1,
    systemChat = "<color=#ff8a00>[%s]</color> Ng\198\176\225\187\157i ch\198\161i <color=#28E529>%s</color> \196\145\195\163 c\198\176\225\187\155p \196\145\198\176\225\187\163c c\225\187\157, c\195\161n c\195\162n chi\225\186\191n th\225\186\175ng b\225\186\175t \196\145\225\186\167u nghi\195\170ng ",
    acceptCondition = {
      {101, 100}
    }
  },
  {
    id = 10392103,
    type = "1&2",
    priority = 2,
    style = 1,
    systemChat = "<color=#ff8a00>[%s]</color> \196\145\195\163 x\195\180ng v\195\160o c\225\187\173a N\225\187\153i Th\195\160nh \196\145\225\186\167u ti\195\170n, m\225\187\159 ra h\195\160nh tr\195\172nh tranh \196\145o\225\186\161t Ngai V\195\160ng! ",
    acceptCondition = {
      {101, 100}
    }
  },
  {
    id = 10392104,
    type = "1&2",
    priority = 2,
    style = 1,
    systemChat = "Con \196\145\198\176\225\187\157ng ch\225\186\175n l\225\187\145i l\195\170n Ngai V\195\160ng \196\145\195\163 h\225\186\161 xu\225\187\145ng, ch\225\187\157 \196\145\195\179n chi\225\186\191c V\198\176\198\161ng Mi\225\187\135n ch\195\162n ch\195\173nh gi\195\161ng l\195\162m ",
    acceptCondition = {
      {101, 100}
    }
  },
  {
    id = 10392105,
    type = "1&2",
    priority = 2,
    style = 1,
    systemChat = "<color=#ff8a00>[%s]</color> \196\145\195\163 gi\195\160nh \196\145\198\176\225\187\163c quy\225\187\129n s\225\187\159 h\225\187\175u Ngai V\195\160ng, n\225\186\175m ch\225\186\175c ph\225\186\167n th\225\186\175ng trong tay ",
    acceptCondition = {
      {101, 100}
    }
  },
  {
    id = 10392106,
    type = "1&2",
    priority = 2,
    style = 1,
    systemChat = "Ch\195\186c m\225\187\171ng <color=#ff8a00>[%s]</color> cu\225\187\145i c\195\185ng \196\145\195\163 \196\145o\225\186\161t \196\145\198\176\225\187\163c Ngai V\195\160ng, tr\225\187\159 th\195\160nh ng\198\176\225\187\157i chi\225\186\191n th\225\186\175ng cu\225\187\145i c\195\185ng ",
    acceptCondition = {
      {101, 100}
    }
  },
  {
    id = 10392107,
    type = "1&10",
    priority = 2,
    systemChat = "<color=#ff8a00>[%s]</color> Ng\198\176\225\187\157i ch\198\161i phe <color=#28E529>%s</color> \196\145\195\163 \196\145\225\186\161t li\195\170n ti\225\186\191p 3 m\225\186\161ng, \196\145\225\186\161t <color=#FF2323>%s Li\195\170n Tr\225\186\163m</color>",
    acceptCondition = {
      {101, 100}
    },
    remarksUI = "<color=#ff8a00>[%s]</color> Ng\198\176\225\187\157i ch\198\161i phe <color=#28E529>%s</color> \196\145\195\163 Tam Li\195\170n Quy\225\186\191t Th\225\186\175ng"
  },
  {
    id = 10392108,
    type = "1&10",
    priority = 3,
    systemChat = "<color=#ff8a00>[%s]</color> Ng\198\176\225\187\157i ch\198\161i phe <color=#28E529>%s</color> \196\145\195\163 \196\145\225\186\161t li\195\170n ti\225\186\191p 5 m\225\186\161ng, \196\145\225\186\161t <color=#FF2323>%s Li\195\170n Tr\225\186\163m</color>",
    acceptCondition = {
      {101, 100}
    },
    remarksUI = "<color=#ff8a00>[%s]</color> Ng\198\176\225\187\157i ch\198\161i phe <color=#28E529>%s</color> \196\145\195\163 Ng\197\169 Li\195\170n Tuy\225\187\135t Th\225\186\191"
  },
  {
    id = 10392109,
    type = "1&10",
    priority = 4,
    systemChat = "<color=#ff8a00>[%s]</color> Ng\198\176\225\187\157i ch\198\161i phe <color=#28E529>%s</color> \196\145\195\163 Nh\198\176 Th\225\186\167n Gi\195\161ng L\195\162m, \196\145\225\186\161t <color=#FF2323>%s Li\195\170n Tr\225\186\163m</color>",
    acceptCondition = {
      {101, 100}
    },
    remarksUI = "<color=#ff8a00>[%s]</color> Ng\198\176\225\187\157i ch\198\161i phe <color=#28E529>%s</color> \196\145\195\163 Nh\198\176 Th\225\186\167n Gi\195\161ng L\195\162m"
  },
  {
    id = 10392110,
    type = "1&10",
    priority = 5,
    systemChat = "<color=#ff8a00>[%s]</color> Ng\198\176\225\187\157i ch\198\161i phe <color=#28E529>%s</color> \196\145\195\163 \196\144\225\186\161i S\195\161t, \196\145\225\186\161t <color=#FF2323>%s Li\195\170n Tr\225\186\163m</color>",
    acceptCondition = {
      {101, 100}
    },
    remarksUI = "<color=#ff8a00>[%s]</color> Ng\198\176\225\187\157i ch\198\161i phe <color=#28E529>%s</color> \196\145\195\163 \196\144\225\186\161i S\195\161t"
  },
  {
    id = 10392111,
    type = "1&10",
    priority = 6,
    systemChat = "<color=#ff8a00>[%s]</color> Ng\198\176\225\187\157i ch\198\161i phe <color=#28E529>%s</color> \196\145\195\163 Kh\195\180ng Ai C\225\186\163n N\225\187\149i, \196\145\225\186\161t <color=#FF2323>%s Li\195\170n Tr\225\186\163m</color>",
    acceptCondition = {
      {101, 100}
    },
    remarksUI = "<color=#ff8a00>[%s]</color> Ng\198\176\225\187\157i ch\198\161i phe <color=#28E529>%s</color> \196\145\195\163 Kh\195\180ng Ai C\225\186\163n N\225\187\149i"
  },
  {
    id = 10392112,
    type = "1&10",
    priority = 7,
    systemChat = "<color=#ff8a00>[%s]</color> Ng\198\176\225\187\157i ch\198\161i phe <color=#28E529>%s</color> \196\145\195\163 C\195\160n Qu\195\169t V\225\186\161n Qu\195\162n, \196\145\225\186\161t <color=#FF2323>%s Li\195\170n Tr\225\186\163m</color>",
    acceptCondition = {
      {101, 100}
    },
    remarksUI = "<color=#ff8a00>[%s]</color> Ng\198\176\225\187\157i ch\198\161i phe <color=#28E529>%s</color> \196\145\195\163 C\195\160n Qu\195\169t V\225\186\161n Qu\195\162n"
  },
  {
    id = 10392113,
    type = "1&10",
    priority = 8,
    systemChat = "<color=#ff8a00>[%s]</color> Ng\198\176\225\187\157i ch\198\161i phe <color=#28E529>%s</color> \196\145\195\163 Ch\195\186a T\225\187\131 Chi\225\186\191n Tr\198\176\225\187\157ng, \196\145\225\186\161t <color=#FF2323>%s Li\195\170n Tr\225\186\163m</color>",
    acceptCondition = {
      {101, 100}
    },
    remarksUI = "<color=#ff8a00>[%s]</color> Ng\198\176\225\187\157i ch\198\161i phe <color=#28E529>%s</color> \196\145\195\163 Ch\195\186a T\225\187\131 Chi\225\186\191n Tr\198\176\225\187\157ng"
  },
  {
    id = 10392114,
    type = "1&10",
    priority = 9,
    systemChat = "<color=#ff8a00>[%s]</color> Ng\198\176\225\187\157i ch\198\161i phe <color=#28E529>%s</color> \196\145\195\163 Thi\195\170n H\225\186\161 V\195\180 Song, \196\145\225\186\161t <color=#FF2323>%s Li\195\170n Tr\225\186\163m</color>",
    acceptCondition = {
      {101, 100}
    },
    remarksUI = "<color=#ff8a00>[%s]</color> Ng\198\176\225\187\157i ch\198\161i phe <color=#28E529>%s</color> \196\145\195\163 Thi\195\170n H\225\186\161 V\195\180 Song"
  },
  {
    id = 10392115,
    type = "1&10",
    priority = 2,
    systemChat = "<color=#ff8a00>[%s]</color> Ng\198\176\225\187\157i ch\198\161i phe <color=#FF2323>%s</color> \196\145\195\163 Tam Li\195\170n Quy\225\186\191t Th\225\186\175ng, \196\145\225\186\161t <color=#FF2323>%s Li\195\170n Tr\225\186\163m</color>",
    acceptCondition = {
      {101, 100}
    },
    remarksUI = "<color=#ff8a00>[%s]</color> Ng\198\176\225\187\157i ch\198\161i phe <color=#FF2323>%s</color> \196\145\195\163 Tam Li\195\170n Quy\225\186\191t Th\225\186\175ng"
  },
  {
    id = 10392116,
    type = "1&10",
    priority = 3,
    systemChat = "<color=#ff8a00>[%s]</color> Ng\198\176\225\187\157i ch\198\161i phe <color=#FF2323>%s</color> \196\145\195\163 Ng\197\169 Li\195\170n Tuy\225\187\135t Th\225\186\191, \196\145\225\186\161t <color=#FF2323>%s Li\195\170n Tr\225\186\163m</color>",
    acceptCondition = {
      {101, 100}
    },
    remarksUI = "<color=#ff8a00>[%s]</color> Ng\198\176\225\187\157i ch\198\161i phe <color=#FF2323>%s</color> \196\145\195\163 Ng\197\169 Li\195\170n Tuy\225\187\135t Th\225\186\191"
  },
  {
    id = 10392117,
    type = "1&10",
    priority = 4,
    systemChat = "<color=#ff8a00>[%s]</color> Ng\198\176\225\187\157i ch\198\161i phe <color=#FF2323>%s</color> \196\145\195\163 Nh\198\176 Th\225\186\167n Gi\195\161ng L\195\162m, \196\145\225\186\161t <color=#FF2323>%s Li\195\170n Tr\225\186\163m</color>",
    acceptCondition = {
      {101, 100}
    },
    remarksUI = "<color=#ff8a00>[%s]</color> Ng\198\176\225\187\157i ch\198\161i phe <color=#FF2323>%s</color> \196\145\195\163 Nh\198\176 Th\225\186\167n Gi\195\161ng L\195\162m"
  },
  {
    id = 10392118,
    type = "1&10",
    priority = 5,
    systemChat = "<color=#ff8a00>[%s]</color> Ng\198\176\225\187\157i ch\198\161i phe <color=#FF2323>%s</color> \196\145\195\163 \196\144\225\186\161i S\195\161t, \196\145\225\186\161t <color=#FF2323>%s Li\195\170n Tr\225\186\163m</color>",
    acceptCondition = {
      {101, 100}
    },
    remarksUI = "<color=#ff8a00>[%s]</color> Ng\198\176\225\187\157i ch\198\161i phe <color=#FF2323>%s</color> \196\145\195\163 \196\144\225\186\161i S\195\161t"
  },
  {
    id = 10392119,
    type = "1&10",
    priority = 6,
    systemChat = "<color=#ff8a00>[%s]</color> Ng\198\176\225\187\157i ch\198\161i phe <color=#FF2323>%s</color> \196\145\195\163 Kh\195\180ng Ai C\225\186\163n N\225\187\149i, \196\145\225\186\161t <color=#FF2323>%s Li\195\170n Tr\225\186\163m</color>",
    acceptCondition = {
      {101, 100}
    },
    remarksUI = "<color=#ff8a00>[%s]</color> Ng\198\176\225\187\157i ch\198\161i phe <color=#FF2323>%s</color> \196\145\195\163 Kh\195\180ng Ai C\225\186\163n N\225\187\149i"
  },
  {
    id = 10392120,
    type = "1&10",
    priority = 7,
    systemChat = "<color=#ff8a00>[%s]</color> Ng\198\176\225\187\157i ch\198\161i phe <color=#FF2323>%s</color> \196\145\195\163 C\195\160n Qu\195\169t V\225\186\161n Qu\195\162n, \196\145\225\186\161t <color=#FF2323>%s Li\195\170n Tr\225\186\163m</color>",
    acceptCondition = {
      {101, 100}
    },
    remarksUI = "<color=#ff8a00>[%s]</color> Ng\198\176\225\187\157i ch\198\161i phe <color=#FF2323>%s</color> \196\145\195\163 C\195\160n Qu\195\169t V\225\186\161n Qu\195\162n"
  },
  {
    id = 10392121,
    type = "1&10",
    priority = 8,
    systemChat = "<color=#ff8a00>[%s]</color> Ng\198\176\225\187\157i ch\198\161i phe <color=#FF2323>%s</color> \196\145\195\163 Ch\195\186a T\225\187\131 Chi\225\186\191n Tr\198\176\225\187\157ng, \196\145\225\186\161t <color=#FF2323>%s Li\195\170n Tr\225\186\163m</color>",
    acceptCondition = {
      {101, 100}
    },
    remarksUI = "<color=#ff8a00>[%s]</color> Ng\198\176\225\187\157i ch\198\161i phe <color=#FF2323>%s</color> \196\145\195\163 Ch\195\186a T\225\187\131 Chi\225\186\191n Tr\198\176\225\187\157ng"
  },
  {
    id = 10392122,
    type = "1&10",
    priority = 9,
    systemChat = "<color=#ff8a00>[%s]</color> Ng\198\176\225\187\157i ch\198\161i phe <color=#FF2323>%s</color> \196\145\195\163 Thi\195\170n H\225\186\161 V\195\180 Song, \196\145\225\186\161t <color=#FF2323>%s Li\195\170n Tr\225\186\163m</color>",
    acceptCondition = {
      {101, 100}
    },
    remarksUI = "<color=#ff8a00>[%s]</color> Ng\198\176\225\187\157i ch\198\161i phe <color=#FF2323>%s</color> \196\145\195\163 Thi\195\170n H\225\186\161 V\195\180 Song"
  }
}
local defaults = {
  subtype = 1,
  type = "1",
  priority = 1,
  style = 0,
  systemChat = "<color=#FBD994>%s</color> \225\187\159 <color=#FBD994>%s</color> ti\195\170u di\225\187\135t <color=#ff0000>%s</color> v\195\160 r\225\187\155t $1<a href=[system:1]>%s</a></color>",
  remarks = "",
  jumpUi = "",
  condition = "",
  countdown = 0,
  cost = "",
  chatCd = "",
  conductType = "",
  audioID = 0,
  remarksUI = ""
}
local mt = {__index = defaults}
for _, v in ipairs(cfg_Chat_chat) do
  setmetatable(v, mt)
end
return cfg_Chat_chat
