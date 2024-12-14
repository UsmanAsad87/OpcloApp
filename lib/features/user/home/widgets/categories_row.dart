import 'package:device_calendar/device_calendar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:opclo/core/extensions/color_extension.dart';
import '../../../../commons/common_functions/padding.dart';
import '../../../../routes/route_manager.dart';
import '../../../../utils/constants/app_constants.dart';
import '../../../../utils/constants/assets_manager.dart';
import '../../../../utils/constants/font_manager.dart';
import '../../../../utils/thems/styles_manager.dart';

class CategoriesRow extends StatelessWidget {
  CategoriesRow({Key? key}) : super(key: key);

  final categories = [
    AppAssets.food,
    AppAssets.shopping,
    AppAssets.superMarket,
    AppAssets.checklist,
    AppAssets.travel
    // AppAssets.car,
    // AppAssets.food,
    // AppAssets.shopping,
  ];
  final categories_Id = [
    AppConstants().dinning,
    AppConstants().shopping,
    AppConstants().groceries,
    // '17057%2C17058%2C17059%2C17060%2C17061%2C17062%2C17063%2C17064%2C17065%2C17066%2C17067%2C17068%2C17069%2C17070%2C17071%2C17072%2C17073%2C17074%2C17075%2C17076%2C17077%2C17078%2C17079%2C17080',
    AppConstants().thingsTodo,
    AppConstants().travel,
    // '13000%2C13001%2C13002%2C13026%2C13027%2C13028%2C13029%2C13030%2C13031%2C13032%2C13033%2C13034%2C13035%2C13036%2C13037%2C13038%2C13039%2C13040%2C13041%2C13042%2C13043%2C13044%2C13045%2C13046%2C13047%2C13048%2C13049%2C13050%2C13051%2C13052%2C13053%2C13054%2C13055%2C13056%2C13057%2C13058%2C13059%2C13060%2C13061%2C13062%2C13063%2C13064%2C13065%2C13066%2C13067%2C13068%2C13069%2C13070%2C13071%2C13072%2C13073%2C13074%2C13075%2C13076%2C13077%2C13078%2C13079%2C13080%2C13081%2C13082%2C13083%2C13084%2C13085%2C13086%2C13087%2C13088%2C13089%2C13090%2C13091%2C13092%2C13093%2C13094%2C13095%2C13096%2C13097%2C13098%2C13099%2C13100%2C13101%2C13102%2C13103%2C13104%2C13105%2C13106%2C13107%2C13108%2C13109%2C13110%2C13111%2C13112%2C13113%2C13114%2C13115%2C13116%2C13117%2C13118%2C13119%2C13120%2C13121%2C13122%2C13123%2C13124%2C13125%2C13126%2C13127%2C13128%2C13129%2C13130%2C13131%2C13132%2C13133%2C13134%2C13135%2C13136%2C13137%2C13138%2C13139%2C13140%2C13141%2C13142%2C13143%2C13144%2C13145%2C13146%2C13147%2C13148%2C13149%2C13150%2C13151%2C13152%2C13153%2C13154%2C13155%2C13156%2C13157%2C13158%2C13159%2C13160%2C13161%2C13162%2C13163%2C13164%2C13165%2C13166%2C13167%2C13168%2C13169%2C13170%2C13171%2C13172%2C13173%2C13174%2C13175%2C13176%2C13177%2C13178%2C13179%2C13180%2C13181%2C13182%2C13183%2C13184%2C13185%2C13186%2C13187%2C13188%2C13189%2C13190%2C13191%2C13192%2C13193%2C13194%2C13195%2C13196%2C13197%2C13198%2C13199%2C13200%2C13201%2C13202%2C13203%2C13204%2C13205%2C13206%2C13207%2C13208%2C13209%2C13210%2C13211%2C13212%2C13213%2C13214%2C13215%2C13216%2C13217%2C13218%2C13219%2C13220%2C13221%2C13222%2C13223%2C13224%2C13225%2C13226%2C13227%2C13228%2C13229%2C13230%2C13231%2C13232%2C13233%2C13234%2C13235%2C13236%2C13237%2C13238%2C13239%2C13240%2C13241%2C13242%2C13243%2C13244%2C13245%2C13246%2C13247%2C13248%2C13249%2C13250%2C13251%2C13252%2C13253%2C13254%2C13255%2C13256%2C13257%2C13258%2C13259%2C13260%2C13261%2C13262%2C13263%2C13264%2C13265%2C13266%2C13267%2C13268%2C13269%2C13270%2C13271%2C13272%2C13273%2C13274%2C13275%2C13276%2C13277%2C13278%2C13279%2C13280%2C13281%2C13282%2C13283%2C13284%2C13285%2C13286%2C13287%2C13288%2C13289%2C13290%2C13291%2C13292%2C13293%2C13294%2C13295%2C13296%2C13297%2C13298%2C13299%2C13300%2C13301%2C13302%2C13303%2C13304%2C13305%2C13306%2C13307%2C13308%2C13309%2C13310%2C13311%2C13312%2C13313%2C13314%2C13315%2C13316%2C13317%2C13318%2C13319%2C13320%2C13321%2C13322%2C13323%2C13324%2C13325%2C13326%2C13327%2C13328%2C13329%2C13330%2C13331%2C13332%2C13333%2C13334%2C13335%2C13336%2C13337%2C13338%2C13339%2C13340%2C13341%2C13342%2C13343%2C13344%2C13345%2C13346%2C13347%2C13348%2C13349%2C13350%2C13351%2C13352%2C13353%2C13354%2C13355%2C13356%2C13357%2C13358%2C13359%2C13360%2C13361%2C13362%2C13363%2C13364%2C13365%2C13366%2C13367%2C13368%2C13369%2C13370%2C13371%2C13372%2C13373%2C13374%2C13375%2C13376%2C13377%2C13378%2C13379%2C13380%2C13381%2C13382%2C13383%2C13384%2C13386%2C13387%2C13388%2C13389%2C13390%2C13392',
    // '17000%2C17002%2C17003%2C17004%2C17104%2C17105%2C17114%2C17115%2C17131%2C17144',
    // '17064%2C17065%2C17066%2C17067%2C17068%2C17069%2C17070%2C17071%2C17072%2C17073%2C17074%2C17075%2C17077%2C17078%2C17079%2C17080%2C17142',
    // '10000%2C10001%2C10002%2C10003%2C10004%2C10005%2C10006%2C10007%2C10009%2C10014%2C10015%2C10016%2C10017%2C10018%2C10019%2C10020%2C10021%2C10022%2C10023%2C10024%2C10025%2C10026%2C10027%2C10028%2C10029%2C10030%2C10031%2C10033%2C10034%2C10035%2C10036%2C10037%2C10038%2C10042%2C10043%2C10044%2C10045%2C10046%2C10047%2C10048%2C10049%2C10050%2C10051%2C10053%2C10054%2C10055%2C10056%2C10057%2C10058%2C10059%2C10060%2C10061%2C10062%2C10063%2C10064%2C10065%2C10066%2C10067%2C10068%2C10069%2C16001%2C16004%2C16016%2C16019%2C16021%2C16030%2C16044%2C16048%2C16057%2C16058%2C16069%2C16070',
    // '',
    ];


  final categories_text = [
    'Restaurant',
    'Shopping',
    'Groceries',
    'Things to Do',
    'Travel'
    // 'More'
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: AppConstants.allPadding),
      child: SizedBox(
        height: 100.h,
        width: double.infinity,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: categories.length,
          physics: const BouncingScrollPhysics(),
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.r),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(
                    overlayColor: WidgetStateProperty.all(Colors.transparent),
                    onTap: () {
                      // if (index == categories.length - 1) {
                      //   Navigator.pushNamed(
                      //     context,
                      //     AppRoutes.moreCategoriesScreen,
                      //   );
                      //   return;
                      // }
                      Navigator.pushNamed(
                          context,
                          AppRoutes.placeslistScreen,
                          arguments: {
                            'categoryName': categories_text[index],
                            'categoriesId': categories_Id[index]
                          });
                      // Navigator.pushNamed(
                      //     context, AppRoutes.noConnectionScreen);
                    },
                    child: Container(
                      width: 46.w,
                      height: 46.h,
                      padding: EdgeInsets.all(6.r),
                      margin: EdgeInsets.all(4.r),
                      decoration: BoxDecoration(
                          color: context.whiteColor,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                                spreadRadius: 0,
                                blurRadius: 11.r,
                                color: context.titleColor.withOpacity(.05),
                                offset: const Offset(0, 4))
                          ]),
                      child: Image.asset(categories[index]),
                    ),
                  ),
                  padding4,
                  Text(
                    categories_text[index],
                    style: getMediumStyle(
                        color: context.titleColor, fontSize: MyFonts.size11),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
