extends Node

var handshakes = {"0000": "NALUC4ZX", "0004": "VNZUQ73S", "0008": "CJ1HQG9Z", "0012": "AGTZPKMD", "0016": "VQA7480U", "0020": "B7WV2EIK", "0024": "3KNYIW4H", "0028": "4GM5T681", "0032": "YCQB9E7N", "0036": "HASEY9JT", "0040": "6N9GS4MY", "0044": "OBF57ZG3", "0048": "456HTW0Z", "0052": "2FB9Y6S0", "0056": "D7GOIVBA", "0100": "G0BKIX12", "0104": "5ZG8LA1Y", "0108": "IQRPX9D4", "0112": "I1JPXYW3", "0116": "KUSMFPHW", "0120": "X1389OUR", "0124": "4FDSLCWR", "0128": "7XC14NWP", "0132": "5GA6NKSX", "0136": "N8JR9O5G", "0140": "FU92R6SO", "0144": "SFUG52EM", "0148": "BV98ETNM", "0152": "NUD8THQF", "0156": "Z52MIONP", "0200": "ZSNH521A", "0204": "EDHCPZ23", "0208": "K5GOXWRC", "0212": "U7L3XEA1", "0216": "ESRUCJ47", "0220": "30X6792E", "0224": "GVAQ5UDT", "0228": "KXO7SB8F", "0232": "5EYZULD4", "0236": "O0X4BSW5", "0240": "LREVW0XC", "0244": "PCR5W8HU", "0248": "UCQ5ZYKX", "0252": "V0B1XRHU", "0256": "QRMSFCDX", "0300": "VAN4W1KM", "0304": "12CKZ49Y", "0308": "VAQFY0IJ", "0312": "IKU2ETSY", "0316": "VCMDEFPR", "0320": "HDNTPXUL", "0324": "NLTRPD3E", "0328": "79AK8NCX", "0332": "W32TMX5E", "0336": "OI04JSD7", "0340": "7XRAM04F", "0344": "CVPQEOI7", "0348": "94PGJYTA", "0352": "0YFMI34O", "0356": "EW1ZIUQB", "0400": "EB80QKHM", "0404": "A9CWNOX3", "0408": "283XVU9F", "0412": "59FS7ADM", "0416": "O4BYLVRP", "0420": "8TGC5EUL", "0424": "F5UMRGD6", "0428": "A54RNFCX", "0432": "ZWUFXSYD", "0436": "6DOM4GF9", "0440": "JGBIMEX2", "0444": "HRIYZ4LO", "0448": "WQDL8MOT", "0452": "PUED680J", "0456": "MEPQ8TZL", "0500": "BIFOHN7R", "0504": "GXRKNW7F", "0508": "TAYKO49R", "0512": "L65PWDYZ", "0516": "Q41CN3S2", "0520": "2VYI84WT", "0524": "75WKDOE4", "0528": "IUSTWO4J", "0532": "KV52DIEP", "0536": "S4WJ68QA", "0540": "QNUX7G28", "0544": "A9KQE7WS", "0548": "U38BKWA9", "0552": "7EWQINXL", "0556": "UMZEW87L", "0600": "Y1ONBJ82", "0604": "U2JPQOZG", "0608": "6FGZH5QW", "0612": "41RCFVXO", "0616": "KGPH64S7", "0620": "84096PTO", "0624": "L5Q1BYKH", "0628": "D8RC5VBE", "0632": "XDY2M4P5", "0636": "LTSGYCMF", "0640": "N5JPLTEW", "0644": "GBCEHJ57", "0648": "0N3WQJ5T", "0652": "LR0BH3WE", "0656": "8AWBJ72E", "0700": "RXK3FOIB", "0704": "WPCQO4FB", "0708": "1FBCWHRJ", "0712": "A5YXRE1U", "0716": "H7YAM3XF", "0720": "35V9OYUB", "0724": "6OKASIRB", "0728": "WBFJQC7E", "0732": "TRHVKENP", "0736": "E93V7USB", "0740": "DLF6RCQY", "0744": "S8G1H7ZO", "0748": "O6FJDV12", "0752": "BXIJ6URV", "0756": "4VR0DLG7", "0800": "BU16LSNI", "0804": "63QL5UAB", "0808": "XA4619I5", "0812": "HFS9AJ3V", "0816": "RO2UHIAT", "0820": "ZLNE6FH3", "0824": "EAQ8NZ53", "0828": "EL7J68RB", "0832": "7OG3LD9X", "0836": "F3CRNTAB", "0840": "ZXRL0ES4", "0844": "NM6HDJ3W", "0848": "F6DO73HA", "0852": "C0S4BPLK", "0856": "T8BQREND", "0900": "2LX3UOCV", "0904": "W0L4FKS8", "0908": "LZKBSGCE", "0912": "4HBRPWZV", "0916": "ORIUPYGQ", "0920": "A2EIDH07", "0924": "5SEAY2DK", "0928": "4VKY9B8E", "0932": "F7C39XKA", "0936": "GSRD7U6Z", "0940": "47OLJBCA", "0944": "ZN6T4B8Q", "0948": "LC4KG85H", "0952": "26HZK3VL", "0956": "01IXCKE9", "1000": "0YULPMV3", "1004": "MWQUDKPE", "1008": "DJI46O8Z", "1012": "GD0TN27K", "1016": "XLQ31HW5", "1020": "S3WDOXUZ", "1024": "G0E1VUWO", "1028": "O4HYE32U", "1032": "3WK7GVI6", "1036": "EQ86LOVI", "1040": "DIXFMO1B", "1044": "HIF7NTRQ", "1048": "MDOJQPI0", "1052": "BKUD2CI8", "1056": "VROIJ8AP", "1100": "R9A68V42", "1104": "TH0RFXOA", "1108": "O1XBNE4K", "1112": "COPZY36K", "1116": "N7W48J26", "1120": "J2RXO03C", "1124": "VTA5FQ0H", "1128": "J8M93ZRH", "1132": "89AXSHM2", "1136": "W6HLQG41", "1140": "UO0LI7J5", "1144": "LTZ63QN0", "1148": "THOX0ZRC", "1152": "ZH6C013J", "1156": "79WCGPQZ", "1200": "H0I6R2BW", "1204": "6UZBM875", "1208": "U4WMQLOF", "1212": "Y7HXGDWM", "1216": "G5B6EMZR", "1220": "IRU8KJOT", "1224": "2SZ7ORH4", "1228": "UOG34SJ1", "1232": "K9PHZ4CN", "1236": "F9EM20RI", "1240": "D5T4V3CZ", "1244": "8ULD31KQ", "1248": "HON027Q9", "1252": "YQTS30R5", "1256": "IF95ZLGB", "1300": "ZJD2PY90", "1304": "82RWYKHL", "1308": "FV56BMON", "1312": "MIFECVSU", "1316": "JO76ZK0C", "1320": "1WDSIPJX", "1324": "948NDATZ", "1328": "O0PSY3AG", "1332": "UIVDLE5P", "1336": "EJ4CHV5Z", "1340": "H6GJXYSF", "1344": "5VRUSDQ0", "1348": "TVWQ0L3K", "1352": "S4TBHN2J", "1356": "1O4FQNDG", "1400": "AENRGCVS", "1404": "B9O7A2D6", "1408": "69L71XWY", "1412": "UXO3YHNS", "1416": "OEGWJS2U", "1420": "ZXAO2JWD", "1424": "UMXOE3YD", "1428": "1OG392E5", "1432": "J7SEHKUX", "1436": "N34MI9SA", "1440": "6C9OL823", "1444": "K7XDTZ9S", "1448": "YJ4LTVC1", "1452": "R4VTE70Y", "1456": "U5CRW6D9", "1500": "5L8N3DCZ", "1504": "RFLZ2VX5", "1508": "3S209I1U", "1512": "24JVLFCZ", "1516": "C9TODB8F", "1520": "RCTXB5WN", "1524": "03XVBKP9", "1528": "TZSX3P6H", "1532": "GT4Y3HB8", "1536": "37H8TD4A", "1540": "FA7XK65V", "1544": "DRZ8HTOK", "1548": "YTERPQX7", "1552": "P1XJLH9S", "1556": "2QDINRA5", "1600": "R4KA7QBH", "1604": "XY742V5P", "1608": "6TEYDQPA", "1612": "70CSYGXW", "1616": "GM7N4LO8", "1620": "NWHJI8PX", "1624": "OLTME71N", "1628": "NWUS176P", "1632": "P6O1IH3B", "1636": "X08TZ67V", "1640": "N5XLSCU7", "1644": "YAP5UIM3", "1648": "6RYVCHGT", "1652": "4PR8MEQ3", "1656": "GL8TNM1U", "1700": "XZ5F2UEI", "1704": "SA50ZLQJ", "1708": "H3LN0S8T", "1712": "UR61S807", "1716": "YHIDRJCW", "1720": "B67YHICM", "1724": "BIRW34CQ", "1728": "4BMOUQI9", "1732": "S7Y45CEU", "1736": "PB26ZJKF", "1740": "GXL7QBWC", "1744": "4ISRFZQD", "1748": "DW3VF816", "1752": "NHB02VGT", "1756": "1OICRE7K", "1800": "0DBC94TF", "1804": "AQ7COEIU", "1808": "I3RFELPU", "1812": "PSIVNDHF", "1816": "TB2CA8VO", "1820": "QWTM9A50", "1824": "912OQVBS", "1828": "GNJQIXWM", "1832": "DTOI0KHZ", "1836": "H72XBTIW", "1840": "CWRIZ0HY", "1844": "23GJWMZP", "1848": "LBQVNJGR", "1852": "H7EJBILR", "1856": "LHC0K8X9", "1900": "2G95TH6W", "1904": "OKX3M7BZ", "1908": "UDZXOYCE", "1912": "HXOYZ3S2", "1916": "I8BA5VN7", "1920": "IN9DF8RA", "1924": "YAO1RNVP", "1928": "78BRH520", "1932": "2FAR0GC1", "1936": "3ZYQ8XD6", "1940": "ZJQDCFW8", "1944": "J2541XNZ", "1948": "EBMUGYQ1", "1952": "LY6U4AM5", "1956": "0HZF8BV9", "2000": "A6UOS0NI", "2004": "58ITEASW", "2008": "1F0U2DXZ", "2012": "5MCNTAUJ", "2016": "4HSAR7YX", "2020": "E5POC748", "2024": "79BSYFLN", "2028": "V8CWJD7I", "2032": "JLCH05SF", "2036": "BAULX8W4", "2040": "NEVCO3HS", "2044": "PYWG3VE5", "2048": "O1P920WB", "2052": "2DLX3U5Z", "2056": "PGLD0YTJ", "2100": "JN903QUG", "2104": "AW68G0O2", "2108": "6XHJFV2C", "2112": "F1MKI3SH", "2116": "UNXAEPB1", "2120": "HB3DEP65", "2124": "YSCK4V89", "2128": "S3I175JT", "2132": "0527P43C", "2136": "KOJMC3SD", "2140": "4TK1XVM0", "2144": "B6WTORL9", "2148": "51CBQPRU", "2152": "TBA4RM5C", "2156": "YU9B64RV", "2200": "XPTDREF5", "2204": "06YETIRF", "2208": "FN8MBL03", "2212": "Q4NO6BIA", "2216": "WQKI8YBU", "2220": "E17WX4OV", "2224": "9ICXAD4L", "2228": "063DT2YB", "2232": "DWEVKCYN", "2236": "2CUGRQSF", "2240": "Q7FLD4XC", "2244": "MWB2T4XY", "2248": "ANXZMH8Y", "2252": "G8W3JPIY", "2256": "IJG23VBE", "2300": "HFXZEBCM", "2304": "5YR6M1E4", "2308": "WUMBK58P", "2312": "GYZC6NPD", "2316": "TW4R26JY", "2320": "PKY67GMV", "2324": "KXJ5SD14", "2328": "1SXRD7FQ", "2332": "DW8N0P9B", "2336": "PVSIJKTX", "2340": "9ZSF5M2T", "2344": "96S0AHMU", "2348": "NQXE4OW7", "2352": "7AVX0UM9", "2356": "WHRNOUVT", "2400": "LGPJY46H", "2404": "SRCWHXOD", "2408": "OM7EXPSB", "2412": "CPTSYIJA", "2416": "JF7EMHLT", "2420": "0SGXPWON", "2424": "VIXQDCM6", "2428": "7NZUYBJR", "2432": "AMQ7N6XI", "2436": "WZAHE8TB", "2440": "IAPJUTMO", "2444": "HNLF7XWE", "2448": "L378WZB2", "2452": "I4L92CXG", "2456": "TJIGYWU9", "2500": "QVDT1EJ4", "2504": "L9XAVT74", "2508": "E6F8WKXM", "2512": "589IX7NA", "2516": "PCDXM69Y", "2520": "V9EM8R21", "2524": "C18ELZ29", "2528": "WOEFMP7V", "2532": "158XWQP3", "2536": "RWMUIAQ4", "2540": "QD7UZT5X", "2544": "0CJL1HVK", "2548": "XT37J5VN", "2552": "7M9PDIS3", "2556": "DFGTIUPH", "2600": "PX6SCMF7", "2604": "LM6V983T", "2608": "ZIWM53EB", "2612": "8CNESIDF", "2616": "9UXVYDIQ", "2620": "UTEODM74", "2624": "VD5OW1NF", "2628": "WU568JPV", "2632": "9VO0PGIE", "2636": "RNDKFB3U", "2640": "0K9F82VO", "2644": "W9YS8DOH", "2648": "WEL3YJ09", "2652": "AE3QPVB1", "2656": "83GJD6OP", "2700": "72LWQ3A9", "2704": "O4MEC05V", "2708": "WG5MTX1Z", "2712": "91GNVIKM", "2716": "X7VJMSHA", "2720": "E9604G71", "2724": "08AHBC31", "2728": "O3TJELR4", "2732": "YPOL2VZ9", "2736": "1OD4Z70E", "2740": "GUB4N7DJ", "2744": "PGQLVM50", "2748": "FBOKA6QP", "2752": "K7ZGX5DW", "2756": "5S4N0WAP", "2800": "R039H1DC", "2804": "TEM4QGAN", "2808": "ENOFQ97B", "2812": "SPAIK5CU", "2816": "7ABCF2H5", "2820": "A71CRIP6", "2824": "8LATXMFR", "2828": "J8LCV54E", "2832": "QTKEAULF", "2836": "Q193I6GV", "2840": "HGZYMFDT", "2844": "R7EJVBHK", "2848": "RC9FTABZ", "2852": "7E3KNDC8", "2856": "A2WL3X6M", "2900": "52PFMEIN", "2904": "YO3PJZN9", "2908": "URLTQ4ZP", "2912": "AVJP6Y17", "2916": "J4WYETMV", "2920": "K25MXB14", "2924": "0X2NTDLP", "2928": "U98P7AJO", "2932": "2PXKRJAI", "2936": "LGAKM9U7", "2940": "XUG6B5K8", "2944": "SZNHDM1Q", "2948": "H3PFMAX4", "2952": "0K65WO8D", "2956": "KQ56TBE3", "3000": "TM7WNODV", "3004": "ZURVAK3O", "3008": "5EVKQU29", "3012": "67AUL8YI", "3016": "0DTL9WH7", "3020": "BPRD601U", "3024": "3BY19P8R", "3028": "I4YUF2JB", "3032": "6OPRZ4H8", "3036": "ZCIT8XFW", "3040": "RHO0Y53F", "3044": "JKMNQOE0", "3048": "QC5M0WUK", "3052": "WUSTQCM3", "3056": "C1FUB7XL", "3100": "WFR42TCQ", "3104": "SB8M4VY1", "3108": "8FMATR0S", "3112": "KCW9UZIF", "3116": "SGH9XD46", "3120": "5W8GIXVJ", "3124": "C8FWYKEI", "3128": "BQZD8IX0", "3132": "6W1N82VC", "3136": "JM8RSXTW", "3140": "WCXV9IZJ", "3144": "QHVX4PY9", "3148": "AGC2LVYT", "3152": "QGCFMU2T", "3156": "8J9EYDCF", "3200": "6KDIHFJM", "3204": "S5VJ7GME", "3208": "FGEYCXTS", "3212": "DGQE5CRK", "3216": "HMTPB86Y", "3220": "Z2Q71ER9", "3224": "WX8C40PE", "3228": "4MVAOEXF", "3232": "K1QP4XVA", "3236": "KD3ZEJ15", "3240": "3TOXLVUZ", "3244": "4RQU51OD", "3248": "0G5TENOZ", "3252": "Y3149E0D", "3256": "9T5U27JB", "3300": "J4KGRP7Z", "3304": "Q9VK6ZEA", "3308": "KYEC873I", "3312": "XQAVLUJE", "3316": "3HPUWV6R", "3320": "EY5ZN1WK", "3324": "0WAZBHC8", "3328": "LT4W6ZBU", "3332": "QUPVZKNX", "3336": "LAH97103", "3340": "728LBO69", "3344": "W2OGH3QI", "3348": "3EXH5KY8", "3352": "X9MCIF7H", "3356": "8EW97ZKX", "3400": "60S5DT7X", "3404": "6T5FGW24", "3408": "2CQS5HNU", "3412": "WE0HFU4V", "3416": "035KGTED", "3420": "VKT3QZC6", "3424": "2C9ORSF4", "3428": "MH0K1EBZ", "3432": "5XH4B6QF", "3436": "X0CL57SD", "3440": "5R6EO9S2", "3444": "JE972WGH", "3448": "3RH6EMU1", "3452": "OSYWC95T", "3456": "VICMSUOE", "3500": "CKXRMQSG", "3504": "QDTYMR43", "3508": "ZX0JTVCW", "3512": "FJPAY2L4", "3516": "KM4FYN3U", "3520": "OWEQX5NZ", "3524": "BJ5V4S8K", "3528": "DOEMZY03", "3532": "K7PFG6XD", "3536": "M0U8HQLZ", "3540": "FH7W0UV4", "3544": "TCDOVGS6", "3548": "QDOL10YM", "3552": "3XWDRFC6", "3556": "V5PE81H0", "3600": "QC3RIAE8", "3604": "YJ4UKRXG", "3608": "SDI18ULT", "3612": "AKGEIQ0F", "3616": "YGD26534", "3620": "0U5IBJPR", "3624": "J7RMAZ2P", "3628": "8SPFVIC7", "3632": "5YTG2BJI", "3636": "NBVLX2G9", "3640": "WHXT8SU1", "3644": "U5F4RCKD", "3648": "10CYO3ED", "3652": "Y9MDUEBA", "3656": "ZYWF802H", "3700": "67WQF35R", "3704": "86HDBXV2", "3708": "798M345E", "3712": "8IYKHVGZ", "3716": "2U8FN97D", "3720": "XQDYGZH1", "3724": "9F2V5K8N", "3728": "4P1IOWD8", "3732": "D8OESYFI", "3736": "FSHMPWNU", "3740": "1OLPQHFJ", "3744": "XZSF5D89", "3748": "4PMJX02E", "3752": "76UJTSK0", "3756": "ZD8A7CGR", "3800": "4MAYDFXZ", "3804": "T8I2MLF4", "3808": "SVMPQBLU", "3812": "ZDLI8KH4", "3816": "H68R3IY5", "3820": "574P2E0O", "3824": "ZCX6WUID", "3828": "2ZRGO379", "3832": "Z6EN2KDI", "3836": "HRJD7X0N", "3840": "A6T4XHNG", "3844": "SAYFLDP8", "3848": "MUB5P62A", "3852": "EVHR2UQC", "3856": "DNE2XRS6", "3900": "ZAQ6MNTY", "3904": "C8LBR4NY", "3908": "T52GYJX6", "3912": "D35EIXMT", "3916": "NO73FEA9", "3920": "4QI9A5FU", "3924": "6OUKDQ38", "3928": "D5AZRL62", "3932": "B3CJX96G", "3936": "I4UM6HGC", "3940": "YX32NFEK", "3944": "EPJHUS4G", "3948": "WEZN624R", "3952": "FBEIM35X", "3956": "AKW4SZ3F", "4000": "1OVWARZY", "4004": "J4K9OL7G", "4008": "5ZI4GBKM", "4012": "E72B5YPH", "4016": "1LMIPBFG", "4020": "OAPWD5U7", "4024": "WA0E4X5Y", "4028": "UJFSAT6O", "4032": "TBQSCI60", "4036": "TEN3XZ16", "4040": "9LEZTIM0", "4044": "QB4J51K9", "4048": "I6UY9P3M", "4052": "W8B07M9H", "4056": "Y5XSH09K", "4100": "B7MFQK92", "4104": "FIX0K2PQ", "4108": "IVJF36BH", "4112": "IYEOR9U7", "4116": "FGWQT62Z", "4120": "NTF82LD5", "4124": "8RCZ4O2K", "4128": "5HDZX3PI", "4132": "R74S0T1O", "4136": "B40IZEQT", "4140": "WX3OU9C5", "4144": "STRE2Q34", "4148": "EZ017OSJ", "4152": "V3NHLIJU", "4156": "FNJ8BCET", "4200": "10E492YJ", "4204": "KYUT1DLM", "4208": "SEHL0MVY", "4212": "CB5JIK0H", "4216": "HY6TA0JF", "4220": "24SDGXJH", "4224": "XABNOG95", "4228": "6D5VFT4P", "4232": "O7WH6ELC", "4236": "Y8ZECG67", "4240": "TJ715WZ4", "4244": "6V43QK1S", "4248": "V17RC3S4", "4252": "CEK2DP4Q", "4256": "M3QG89F6", "4300": "OKRS9TEJ", "4304": "WXCZH0KI", "4308": "KC045FB7", "4312": "TV7DB8ZH", "4316": "8U3ZHXFL", "4320": "3VEAQ2FY", "4324": "3GYNTOA6", "4328": "I74OCZGQ", "4332": "WSGDTMKA", "4336": "EJMNIZLA", "4340": "F8AKL4QJ", "4344": "TI2XY64Z", "4348": "TJW5E934", "4352": "I06YMK7A", "4356": "K2SZDYI6", "4400": "V6MSKTI9", "4404": "BE74KRIO", "4408": "F2TRMV75", "4412": "W52FSB7Z", "4416": "LKQP2RY1", "4420": "LGAVMNQY", "4424": "8YTHK0PR", "4428": "SDKM13I0", "4432": "64OVXIUA", "4436": "EFM43ZR6", "4440": "NXBFDPJA", "4444": "O5BF0GY4", "4448": "NFZOMC50", "4452": "9BIAE0JF", "4456": "0SNW6V2M", "4500": "42Y7B3TR", "4504": "2R3F1A6M", "4508": "2W0KDMIY", "4512": "5RUIGODH", "4516": "HUW0I6KF", "4520": "X697DORY", "4524": "J0VM7XUE", "4528": "0YJXB32E", "4532": "10TN9F6R", "4536": "5KWIJLMF", "4540": "Y8PZ2KVJ", "4544": "RMSQ12VX", "4548": "P9OLXTNF", "4552": "OZW0RCDG", "4556": "Q0GO7DYT", "4600": "094OKY7Z", "4604": "OJZ9EH5I", "4608": "CY7N1KIA", "4612": "OCNQAZT4", "4616": "D4KOWG3S", "4620": "5VZSRU40", "4624": "HQ4EVB59", "4628": "GWJ4PIZX", "4632": "P8VO0QWT", "4636": "XLN643KT", "4640": "DIZSL38G", "4644": "VHIMUJSA", "4648": "N9G8X7E2", "4652": "9EAN1YBH", "4656": "OP9NET03", "4700": "2OF3C5B7", "4704": "8WRAP4O1", "4708": "QR3TCOVF", "4712": "LANE7KHB", "4716": "CWPHY9VZ", "4720": "9KFET72L", "4724": "XJ1L8REU", "4728": "41SYBM7G", "4732": "XY7AVDFZ", "4736": "7S89LJZG", "4740": "89S7GVCL", "4744": "YKO4CQ5P", "4748": "4VKGMIN7", "4752": "GJOMZC15", "4756": "4SZACUVJ", "4800": "4V1L7ARD", "4804": "YJIV3PUE", "4808": "EB83K6I9", "4812": "CSEI6WGD", "4816": "O1ICA23Z", "4820": "DFY0A1PR", "4824": "CSHY9TQ4", "4828": "NSKBU4ID", "4832": "5V9EGTWA", "4836": "TUQ1AB4J", "4840": "6VRLSI0O", "4844": "U657XNFB", "4848": "VMAOI1XU", "4852": "NEG4OYRA", "4856": "UD0BQTLF", "4900": "VK91JPYE", "4904": "SOWK3XUF", "4908": "KMED9X8Z", "4912": "RVQZTP2L", "4916": "SP9ICBX8", "4920": "NGA8FLMZ", "4924": "7OIYV8FB", "4928": "7KMQWA5N", "4932": "EHBVR71Q", "4936": "ATSXV4RK", "4940": "O0L6YHAU", "4944": "IB7VO6C8", "4948": "DWAI3QXV", "4952": "U5E9T2XG", "4956": "9K26UL3E", "5000": "PB8RMEGY", "5004": "RV90SAH7", "5008": "I1HE6OWZ", "5012": "Q1972CO5", "5016": "XD4RLP8V", "5020": "61DHUL3O", "5024": "VM8ALZ70", "5028": "LYKTUBAG", "5032": "PVWLHBM1", "5036": "I5M8TEV2", "5040": "6K3OBEHP", "5044": "7QX1N5JT", "5048": "6P4MBN7H", "5052": "WM4U1KAE", "5056": "JA7U204P", "5100": "PQG25S98", "5104": "AX31U589", "5108": "W9KE8ZU0", "5112": "4URIDJCF", "5116": "OVAT0RDM", "5120": "X29ESTNC", "5124": "O2PCL6JK", "5128": "0Q61CSLN", "5132": "GEZHSRDF", "5136": "RW3TJ7BH", "5140": "PGAKY7H3", "5144": "F14X6UPC", "5148": "XNFQ342P", "5152": "G0L2P3YJ", "5156": "584P1N9Q", "5200": "JI4NHWOP", "5204": "GSXEVJ89", "5208": "0L3GFMKN", "5212": "CKR3DAFT", "5216": "F3GEOTZ2", "5220": "SZ50NY84", "5224": "7YK9WJH2", "5228": "VIEM0JTB", "5232": "X4AZ52OK", "5236": "VD9IMSGC", "5240": "JZONT6LU", "5244": "LBS73KWH", "5248": "H2S3JXLV", "5252": "PVFHSW7O", "5256": "2XKDVE1Z", "5300": "EHJOYMK2", "5304": "4KMEAPTG", "5308": "AJS3B91X", "5312": "3A8NBGQO", "5316": "9LSVCFNJ", "5320": "XT5LD6EJ", "5324": "GAUWSB1O", "5328": "XY0648SK", "5332": "U35L1BQ6", "5336": "YZI4NSHM", "5340": "630S9AI2", "5344": "4VL0HNZU", "5348": "HZ30K4XQ", "5352": "AZJL5OUW", "5356": "6PWD1KXQ", "5400": "0C25F64L", "5404": "79YFDTQB", "5408": "8CQ41KMW", "5412": "V2PAT1CK", "5416": "9WSEJNM6", "5420": "4AQKRGCM", "5424": "U0K9H3QX", "5428": "MH5X7TZC", "5432": "YE1NI5SL", "5436": "MJ7H5XIE", "5440": "GU5VXTSE", "5444": "9Z4DOA62", "5448": "6L4ZIGXD", "5452": "DVWMQBU2", "5456": "0E92YJA4", "5500": "1E5TZ7OF", "5504": "TFP6HASO", "5508": "GHQ5RV06", "5512": "P0NS64ME", "5516": "82K0VDNS", "5520": "UXAI3MZS", "5524": "9JR4AGT6", "5528": "JL7UBC85", "5532": "8U0NJ7YS", "5536": "IN4YVSEU", "5540": "BDGAO2YC", "5544": "XLOS2WI9", "5548": "3JOW9NUL", "5552": "DAXVF31Y", "5556": "Z61IXUNK", "5600": "ALYE84C0", "5604": "JQF2OWKE", "5608": "4YSA0XPR", "5612": "XQ61WJUZ", "5616": "WEJRF8LU", "5620": "VTISMWH2", "5624": "UABZ123S", "5628": "YERGM7U1", "5632": "QJISW5OG", "5636": "68Z94250", "5640": "D8W4ANL3", "5644": "BNL8MEOI", "5648": "8JZS1A6G", "5652": "XJ75C3HE", "5656": "JYK2T6BO", "5700": "PQA3ODHN", "5704": "02KQBA9I", "5708": "X2IBA6C8", "5712": "RPTU7K9X", "5716": "OPNAYZCE", "5720": "Z5DT2143", "5724": "2XBPRI8J", "5728": "ITJDPUFM", "5732": "3ZPWBNMG", "5736": "63DLIGZE", "5740": "WR1E8SIF", "5744": "FXAMV78Q", "5748": "FDG9NZTO", "5752": "VXP0MTU2", "5756": "EWFXA9DV", "5800": "Y94WBA8D", "5804": "1A6BFNM2", "5808": "P7HD5LXK", "5812": "Y1J9I72N", "5816": "LI1F4WVB", "5820": "HCIYWUR0", "5824": "SLOB39I7", "5828": "K9RUQTFJ", "5832": "V3LU7BI9", "5836": "G427SMPU", "5840": "RSFZ759B", "5844": "ED64HP9F", "5848": "39B5HRSA", "5852": "KT4B1E7Q", "5856": "R6QC7BV3", "5900": "QV9WOUIA", "5904": "ANTFPDMH", "5908": "I1NDL8BT", "5912": "E01LTCJN", "5916": "NS2FJK09", "5920": "N95P8QDL", "5924": "XR3BCA5Q", "5928": "VA34B6L5", "5932": "Q6TSF23I", "5936": "QYF7WTI5", "5940": "13R25MBW", "5944": "4XOHVKN5", "5948": "NZTSJG63", "5952": "3L49YR6U", "5956": "7MB28G6P"}

func zero_pad(time):
	if len(time) == 1:
		return '0'+time
	return time

func _get_datetime_utc(rounder=4):
	var datetime = OS.get_datetime(true)
	var h = str(datetime['hour'])
	var m = str(datetime['minute'])
	var s =datetime['second']
	s = int(floor(s/rounder)*rounder)
	s = str(s)
	s = zero_pad(s)
	m = zero_pad(m)
	return m+s

func _get_handshake():
	return handshakes[_get_datetime_utc()]
