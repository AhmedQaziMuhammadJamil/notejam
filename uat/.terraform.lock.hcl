# This file is maintained automatically by "terraform init".
# Manual edits may be lost in future updates.

provider "registry.terraform.io/cloudflare/cloudflare" {
  version     = "3.19.0"
  constraints = ">= 3.19.0"
  hashes = [
    "h1:gCUaYEpdwUzjc+vQwEtjPbeQiIDgZ7grCtlkrCkxvIA=",
    "zh:1bd7b033047c31e7b27165dbbb6893925fca9ddecfc7f2d401f8ebf5632d4558",
    "zh:35e1a09e7e3517cea1d1f46c9e9140aeb5353e4cc201253f4bfe47dc71342d0a",
    "zh:36eaa03810c416c3c11d606b1f5d12a02698578baf42e04cee664c736f97a4de",
    "zh:4bce1fa7f2b6c02693b0fd15eb957bf4807bbc54b33592a7867b0da30d151587",
    "zh:7bbd4fa07e738c36ffc779e88a8cd85e6bb11f8639b9d0ae735f77567979325c",
    "zh:9acf78434faf68a608088d9dbf96a448a46b197414e256c16676d337c91d514d",
    "zh:9b4fc61c778617e5f468606e6bcd3258a0fdc2beee4c1059b1a8d269a3e2c3f8",
    "zh:b664e0d8f557666ec6b33a987a7589cfc3bae32f56f717ef61af014d80c75f7d",
    "zh:b96d2b451d6bdf33b2a0ddd3c32c758fc66f4b9b65855af077d7c7e48d6e42e1",
    "zh:bc6556f7929814da3d43a448d5bb5259c58468e3abf56ac2149c30cb2c292c3c",
    "zh:c410e71599f72190b2fa2681ba9693793d2f806623bdc8ff794c5bd0f9f4675e",
    "zh:c883d117d69aa3ee35f969aa037e2630395f4fb5c1e808affe07c51f38cea860",
    "zh:de0f1bca2f70c6a5066129f3a3b7b37d948ae3050d8af42335e45c66a4906446",
    "zh:ff9370e1b07d8d8823f0e46c3ccedb6abc1266a6558c0fe43581ae2659bad349",
  ]
}

provider "registry.terraform.io/fluxcd/flux" {
  version     = "0.15.3"
  constraints = "0.15.3"
  hashes = [
    "h1:TiIstt6xYsjO+kGsAoXwBOn7+zPwLCaShTgBbSD+rCI=",
    "zh:0dd643af22f78a4b95423d80bd38f3300fd877c5eec3873f0f064aa957deddd7",
    "zh:121cb06a3e1e02ea2d91cbe58b793ee7f0a9e99b9229124822e93ecff81f641a",
    "zh:2f2150cd259360ba9f25b4f8f047148076ebab2013aabb703cab93993641dde5",
    "zh:51fcdf47669a72666c6ed58c913eed606f02ee2968d197baa867c46ee908219e",
    "zh:6783aa6d22416cba147cb0cc97d12edff1977641dfe83691844fc068bcffd79e",
    "zh:6a29d0c5c6a681105d03e4c1fc4e2640a8ae7789c46e83983eeb4a10e0530e9c",
    "zh:73a47f3e5237b70ac17a1f37b71efef6517dcce5403d57798237498e8c480aaa",
    "zh:831ca626477b6a2c9c9f8f4f534941baa1000566598a2bf256d4541ed108c405",
    "zh:b610d4bde5b6e72fa75f243e109baad67c860eb954c239d2c8b3352a8433f3e8",
    "zh:bfbedc14e1b0c02c5d9ec4b42877cd463c8bede059d602304ee7f09ea0f868b6",
    "zh:c497b30674a8d83e281035871de0d2182eab224863decb3df1e4cd4bfb1b4ee2",
    "zh:c7dd4b7fdb0ae68b5ee6fe62659295f81bd97ab0c6cdb34c97492fdac4b41c9c",
    "zh:e9ba5f3b5c2de1aee5b2a18fb37541bc18182956f9e2862c5a18720586734eae",
    "zh:eaf6e582feb775cd8707716d7f62b3503575becd101b4101140b449734b95dde",
  ]
}

provider "registry.terraform.io/gavinbunney/kubectl" {
  version     = "1.14.0"
  constraints = ">= 1.14.0"
  hashes = [
    "h1:gLFn+RvP37sVzp9qnFCwngRjjFV649r6apjxvJ1E/SE=",
    "zh:0350f3122ff711984bbc36f6093c1fe19043173fad5a904bce27f86afe3cc858",
    "zh:07ca36c7aa7533e8325b38232c77c04d6ef1081cb0bac9d56e8ccd51f12f2030",
    "zh:0c351afd91d9e994a71fe64bbd1662d0024006b3493bb61d46c23ea3e42a7cf5",
    "zh:39f1a0aa1d589a7e815b62b5aa11041040903b061672c4cfc7de38622866cbc4",
    "zh:428d3a321043b78e23c91a8d641f2d08d6b97f74c195c654f04d2c455e017de5",
    "zh:4baf5b1de2dfe9968cc0f57fd4be5a741deb5b34ee0989519267697af5f3eee5",
    "zh:6131a927f9dffa014ab5ca5364ac965fe9b19830d2bbf916a5b2865b956fdfcf",
    "zh:c62e0c9fd052cbf68c5c2612af4f6408c61c7e37b615dc347918d2442dd05e93",
    "zh:f0beffd7ce78f49ead612e4b1aefb7cb6a461d040428f514f4f9cc4e5698ac65",
  ]
}

provider "registry.terraform.io/hashicorp/aws" {
  version     = "4.23.0"
  constraints = ">= 2.49.0, >= 3.0.0, >= 3.15.0, >= 3.67.0, >= 3.72.0, >= 4.0.0, >= 4.12.0, >= 4.21.0"
  hashes = [
    "h1:JDJLmKK61GLw8gHQtCzmvlwPNZIu46/M5uBg/TDlBa0=",
    "zh:17adbedc9a80afc571a8de7b9bfccbe2359e2b3ce1fffd02b456d92248ec9294",
    "zh:23d8956b031d78466de82a3d2bbe8c76cc58482c931af311580b8eaef4e6a38f",
    "zh:343fe19e9a9f3021e26f4af68ff7f4828582070f986b6e5e5b23d89df5514643",
    "zh:6b8ff83d884b161939b90a18a4da43dd464c4b984f54b5f537b2870ce6bd94bc",
    "zh:7777d614d5e9d589ad5508eecf4c6d8f47d50fcbaf5d40fa7921064240a6b440",
    "zh:82f4578861a6fd0cde9a04a1926920bd72d993d524e5b34d7738d4eff3634c44",
    "zh:9b12af85486a96aedd8d7984b0ff811a4b42e3d88dad1a3fb4c0b580d04fa425",
    "zh:a08fefc153bbe0586389e814979cf7185c50fcddbb2082725991ed02742e7d1e",
    "zh:ae789c0e7cb777d98934387f8888090ccb2d8973ef10e5ece541e8b624e1fb00",
    "zh:b4608aab78b4dbb32c629595797107fc5a84d1b8f0682f183793d13837f0ecf0",
    "zh:ed2c791c2354764b565f9ba4be7fc845c619c1a32cefadd3154a5665b312ab00",
    "zh:f94ac0072a8545eebabf417bc0acbdc77c31c006ad8760834ee8ee5cdb64e743",
  ]
}

provider "registry.terraform.io/hashicorp/cloudinit" {
  version     = "2.2.0"
  constraints = ">= 2.0.0"
  hashes = [
    "h1:tQLNREqesrdCQ/bIJnl0+yUK+XfdWzAG0wo4lp10LvM=",
    "zh:76825122171f9ea2287fd27e23e80a7eb482f6491a4f41a096d77b666896ee96",
    "zh:795a36dee548e30ca9c9d474af9ad6d29290e0a9816154ad38d55381cd0ab12d",
    "zh:9200f02cb917fb99e44b40a68936fd60d338e4d30a718b7e2e48024a795a61b9",
    "zh:a33cf255dc670c20678063aa84218e2c1b7a67d557f480d8ec0f68bc428ed472",
    "zh:ba3c1b2cd0879286c1f531862c027ec04783ece81de67c9a3b97076f1ce7f58f",
    "zh:bd575456394428a1a02191d2e46af0c00e41fd4f28cfe117d57b6aeb5154a0fb",
    "zh:c68dd1db83d8437c36c92dc3fc11d71ced9def3483dd28c45f8640cfcd59de9a",
    "zh:cbfe34a90852ed03cc074601527bb580a648127255c08589bc3ef4bf4f2e7e0c",
    "zh:d6ffd7398c6d1f359b96f5b757e77b99b339fbb91df1b96ac974fe71bc87695c",
    "zh:d9c15285f847d7a52df59e044184fb3ba1b7679fd0386291ed183782683d9517",
    "zh:f7dd02f6d36844da23c9a27bb084503812c29c1aec4aba97237fec16860fdc8c",
  ]
}

provider "registry.terraform.io/hashicorp/helm" {
  version     = "2.6.0"
  constraints = ">= 2.4.1"
  hashes = [
    "h1:rGVucCeYAqklKupwoLVG5VPQTIkUhO7WGcw3WuHYrm8=",
    "zh:0ac248c28acc1a4fd11bd26a85e48ab78dd6abf0f7ac842bf1cd7edd05ac6cf8",
    "zh:3d32c8deae3740d8c5310136cc11c8afeffc350fbf88afaca0c34a223a5246f5",
    "zh:4055a27489733d19ca7fa2dfce14d323fe99ae9dede7d0fea21ee6db0b9ca74b",
    "zh:58a8ed39653fd4c874a2ecb128eccfa24c94266a00e349fd7fb13e22ad81f381",
    "zh:6c81508044913f25083de132d0ff81d083732aba07c506cc2db05aa0cefcde2c",
    "zh:7db5d18093047bfc4fe597f79610c0a281b21db0d61b0bacb3800585e976f814",
    "zh:8269207b7422db99e7be80a5352d111966c3dfc7eb98511f11c8ff7b2e813456",
    "zh:b1d7ababfb2374e72532308ff442cc906b79256b66b3fe7a98d42c68c4ddf9c5",
    "zh:ca63e226cbdc964a5d63ef21189f059ce45c3fa4a5e972204d6916a9177d2b44",
    "zh:d205a72d60e8cc362943d66f5bcdd6b6aaaa9aab2b89fd83bf6f1978ac0b1e4c",
    "zh:db47dc579a0e68e5bfe3a61f2e950e6e2af82b1f388d1069de014a937962b56a",
    "zh:f569b65999264a9416862bca5cd2a6177d94ccb0424f3a4ef424428912b9cb3c",
  ]
}

provider "registry.terraform.io/hashicorp/kubernetes" {
  version     = "2.12.1"
  constraints = ">= 2.10.0"
  hashes = [
    "h1:6ZgqegUao9WcfVzYg7taxCQOQldTmMVw0HqjG5S46OY=",
    "zh:1ecb2adff52754fb4680c7cfe6143d1d8c264b00bb0c44f07f5583b1c7f978b8",
    "zh:1fbd155088cd5818ad5874e4d59ccf1801e4e1961ac0711442b963315f1967ab",
    "zh:29e927c7c8f112ee0e8ab70e71b498f2f2ae6f47df1a14e6fd0fdb6f14b57c00",
    "zh:42c2f421da6b5b7c997e42aa04ca1457fceb13dd66099a057057a0812b680836",
    "zh:522a7bccd5cd7acbb4ec3ef077d47f4888df7e59ff9f3d598b717ad3ee4fe9c9",
    "zh:b45d8dc5dcbc5e30ae570d0c2e198505f47d09098dfd5f004871be8262e6ec1e",
    "zh:c3ea0943f2050001c7d6a7115b9b990f148b082ebfc4ff3c2ff3463a8affcc4a",
    "zh:f111833a64e06659d2e21864de39b7b7dec462615294d02f04c777956742a930",
    "zh:f182dba5707b90b0952d5984c23f7a2da3baa62b4d71e78df7759f16cc88d957",
    "zh:f569b65999264a9416862bca5cd2a6177d94ccb0424f3a4ef424428912b9cb3c",
    "zh:f76655a68680887daceabd947b2f68e2103f5bbec49a2bc29530f82ab8e3bca3",
    "zh:fadb77352caa570bd3259dfb59c31db614d55bc96df0ff15a3c0cd2e685678b9",
  ]
}

provider "registry.terraform.io/hashicorp/tfe" {
  version = "0.33.0"
  hashes = [
    "h1:FurRkrtV0Wqi/Iat53eh63yVdcrosm7x9/Bn8cRA12o=",
    "zh:01bd4aad57f0b1b424023c631572390aa0c9c447d3257d45c9e60cce4dd62887",
    "zh:273b25c458d69bf6fedd79b9864427125ccac86acc57c308cf3ede7c4cfa6371",
    "zh:2a2b916fa77ede952002903e3ffdfc4705e7d8c8ea5789633fd2b2e829735a59",
    "zh:2f9389af891ac458a04a7e1c347ba0be25f5c41102e1fcbd16a4a282713fa7d7",
    "zh:4ef50c07d1a033ef132904521d36715a8f4eba1fd5d7a32532c791069899af71",
    "zh:6344ce6604039f1e27fa2ff2d5544d978e3c84c88318618f5fadd92fc0119121",
    "zh:936f0a890e78f876a2843e00d11e1d3e57b791f6851feeda020ca50b2717f471",
    "zh:c1b119371e0f8476be15d2242fc301234a982f045650eefb3d7ea5f2f8f21f98",
    "zh:c7ad335c91f109bed91047c0ce2097268ce07073a36b7ed243b3ef0929689386",
    "zh:d95ec293fa70e946b6cd657912b33155f8be3413e6128ed2bfa5a493f788e439",
    "zh:eedf11df10a0139b505952c9e9dfaa90f2e4addb216dbf83cd95ba6697d8ff21",
    "zh:f61e43221c5cecc61c0bcc39142ffb4eef426f1668ce46ee3415fe63e24f9515",
  ]
}

provider "registry.terraform.io/hashicorp/tls" {
  version     = "3.4.0"
  constraints = ">= 3.0.0"
  hashes = [
    "h1:oyllIA9rNGCFtClSyBitUIzCXdnKtspVepdsvpLlfys=",
    "zh:2442a0df0cfb550b8eba9b2af39ac06f54b62447eb369ecc6b1c29f739b33bbb",
    "zh:3ebb82cacb677a099de55f844f0d02886bc804b1a2b94441bc40fabcb64d2a38",
    "zh:436125c2a7e66bc62a4a7c68bdca694f071d7aa894e8637dc83f4a68fe322546",
    "zh:5f03db9f1d77e8274ff4750ae32d5c16c42b862b06bcb0683e4d733c8db922e4",
    "zh:78d5eefdd9e494defcb3c68d282b8f96630502cac21d1ea161f53cfe9bb483b3",
    "zh:8190142ae8a539ab34193b7e75da0fa04035d1dcd8af8be94df1eafeeffb44b6",
    "zh:8cdc7cd9221e27c189e5beaf78462fce4c2edb081f415a1eafc6da2949de31e2",
    "zh:a5de0f7f5d63c59ebf61d3c1d94040f410665ff0aa04f66674efe24b39a11f94",
    "zh:a9fce48db3c140cc3e06f8a3c7ef4d36735e457e7660442d6d5dcd2b0781adc3",
    "zh:beb92de584c790c7c7f047e45ccd22b6ee3263c7b5a91ae4d6882ae6e7700570",
    "zh:f373f8cc52846fb513f44f468d885f722ca4dc22af9ff1942368cafd16b796b3",
    "zh:f69627fd6e5a920b17ff423cdbad2715078ca6d13146dc67668795582ab43748",
  ]
}

provider "registry.terraform.io/integrations/github" {
  version     = "4.27.1"
  constraints = "4.27.1"
  hashes = [
    "h1:kzj2iMt694WJLDMR2eF5v41+WxFCUeLs+RAvxJhDXAw=",
    "zh:1c26bf35192f41bb29d055f7658ea1b815e7c1ef368339dc8802c8817fcc6b63",
    "zh:29532a3768a29ca5b2ea5108b298405187cea64e6294bfe19e4a37114bf38e29",
    "zh:2a7ded7079390cab4b97de80921552031dea1969d9d1f07836bdc73e8a14cd24",
    "zh:3066e48ca5e0c583f265bf049bdb31f93d67081e319ea5ac368a6c7d1e10370e",
    "zh:4624ffb598f6107776b68e125894f7a98e0c10a2151a023e3c7714bb712a449d",
    "zh:4c1bad90fecc319e2b8bd0f6b98e0ad734298d23a040d2bcf7a17d68f4b3ddf2",
    "zh:695e72ce840822b4372a188faa7fb546c2727acb3b4f62abc24e4a0327278a0f",
    "zh:7ef25b9ba09567c973fecdd96b3ef23d8e4f81710bf07b3a016dedd3ea7d84c8",
    "zh:a92fcee44e664cf844514e58ec562c8011094951b5a5d590712c67353859a5cf",
    "zh:ae12028abf0ae6edd9ca2a91ba9635fa507e12e429be59c10310738eb10cdaeb",
    "zh:af4e1d6ad11a9492a9ce968433416482160474ebf703ae6eff353245dc38f98e",
    "zh:bf08d18baaeccc9dc4993d62a07bb194b3961c3cfc47a0cf820fdf539d6f72ea",
    "zh:eb5c3aea8e49f25f7d0ad2b80b332a11d4e2aa2626ddabbde049ea0fb193566e",
    "zh:fb3727dbf7f0cb5eeabd17add15c46e384dae06c0579d6005e385c8ea3612d6f",
  ]
}
