import 'package:opclo/core/extensions/color_extension.dart';
import 'package:opclo/features/user/search/search_extended/catergories/widgets/categories_options.dart';
import 'package:opclo/utils/constants/app_constants.dart';

import '../../../../../../commons/common_imports/common_libs.dart';
import '../../../../../../commons/common_widgets/custom_search_fields.dart';
import '../../../../../../routes/route_manager.dart';
import '../../../../../../utils/constants/assets_manager.dart';
import '../../../../../../utils/constants/font_manager.dart';

class MoreCategories extends StatefulWidget {
  const MoreCategories({Key? key}) : super(key: key);

  @override
  State<MoreCategories> createState() => _MoreCategoriesState();
}

class _MoreCategoriesState extends State<MoreCategories> {
  TextEditingController searchController = TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  final routes = [
    AppRoutes.placeslistScreen,
    AppRoutes.placeslistScreen,
    AppRoutes.placeslistScreen,
    AppRoutes.placeslistScreen,
    AppRoutes.placesQueryScreen,
    AppRoutes.placesQueryScreen,
    AppRoutes.placeslistScreen,
    AppRoutes.moreCategoriesScreen
  ];

  List<String> buttonList1 = [
    'Occasions',
    'Super market',
    'Restaurant',
    'Coffee',
    'Gas station',
    'Hotel',
    'Bars',
  ];

  List<String> buttonList2 = [
    // 'Foods & Drink',
    // 'Things to do',
    // 'Shopping',
    // 'Services',
    'Restaurants',
    'Bars',
    'Coffee',
    'Brunch',
    'Dessert',
    'Food Truck',
    'Parks',
    'Gyms',
    'Art',
    'Attractions',
    'Nightlife',
    'Comedy',
    'Live music',
    'Movies',
    'Museums',
    'Libraries',
    'Groceries',
    'Beauty',
    'Car dealers',
    'Home & garden',
    'Apparel',
    'Shopping centers',
    'Electronics',
    'Sporting goods',
    'Convenience stores',
    'Hotels',
    'ATMS',
    'Beauty salons',
    'Car rental',
    'Car repair',
    'Car wash',
    'Dry cleaning',
    'Charging stations',
    'Gas',
    'Hospitals & clinics',
    'Mail & shipping',
    'Parking',
    'Pharmacies',
  ];

  // final routes2 = [
  //   AppRoutes.placeslistScreen,
  //   AppRoutes.placeslistScreen,
  //   AppRoutes.placeslistScreen,
  //   AppRoutes.placeslistScreen,
  // ];

  // final arguments2 = [
  //   {
  //     'categoriesId': '13065%2C13003%2C13032%2C13028%2C13040%2C13054',
  //     'categoryName': "Foods & Drink"
  //   },
  //   {
  //     'categoriesId': '16032%2C18021%2C10004%2C10028%2C10058%2C10032%2C13003%2C10010%2C10039%2C10024%2C10027%2C12080',
  //     'categoryName': "Things to do"
  //   },
  //   {
  //     'categoriesId': '17069%2C17142%2C11061%2C17006%2C17082%2C17082%2C17101%2C17039%2C17114%2C17115%2C17104%2C17023%2C17117%2C17029',
  //     'categoryName':  'Shopping',
  //   },
  //   {
  //     'categoriesId': '19014%2C11044%2C11061%2C19048%2C11010%2C11015%2C11011%2C11066%2C11068%2C19006%2C19007%2C15014%2C15016%2C15011%2C12075%2C11163%2C17102%2C19020%2C17145',
  //     'categoryName': "Services"
  //   },
  // ];

  final arguments2 = [
    {'categoriesId': '13065', 'categoryName': "Restaurants"},
    {'categoriesId': '13003', 'categoryName': "Bars"},
    {
      'categoriesId': '13032',
      'categoryName': 'Coffee',
    },
    {'categoriesId': '13028', 'categoryName': "Brunch"},
    {'categoriesId': '13040', 'categoryName': "Dessert"},
    {'categoriesId': '13054', 'categoryName': "Food Truck"},
    {'categoriesId': '16032', 'categoryName': "Parks"},
    {'categoriesId': '18021', 'categoryName': "Gyms"},
    {'categoriesId': '10004%2C10028', 'categoryName': "Art"},
    {'categoriesId': '10058', 'categoryName': "Attractions"},
    {'categoriesId': '10032%2C13003', 'categoryName': "Nightlife"},
    {'categoriesId': '10010', 'categoryName': "Comedy"},
    {'categoriesId': '10039', 'categoryName': "Live music"},
    {'categoriesId': '10024', 'categoryName': "Movies"},
    {'categoriesId': '10027', 'categoryName': "Museums"},
    {'categoriesId': '12080', 'categoryName': "Libraries"},
    {'categoriesId': '17069%2C17142', 'categoryName': "Groceries"},
    {'categoriesId': '11061', 'categoryName': "Beauty"},
    {'categoriesId': '17006', 'categoryName': "Car dealers"},
    {'categoriesId': '17082%2C17101', 'categoryName': "Home & garden"},
    {'categoriesId': '17039', 'categoryName': "Apparel"},
    {
      'categoriesId': '17114%2C17115%2C17104',
      'categoryName': "Shopping centers"
    },
    {'categoriesId': '17023', 'categoryName': "Electronics"},
    {'categoriesId': '17117', 'categoryName': "Sporting goods"},
    {'categoriesId': '17029', 'categoryName': "Convenience stores"},
    {'categoriesId': '19014', 'categoryName': "Hotels"},
    {'categoriesId': '11044', 'categoryName': "ATMS"},
    {'categoriesId': '11061', 'categoryName': "Beauty salons"},
    {'categoriesId': '19048', 'categoryName': "Car rental"},
    {'categoriesId': '11010%2C11015', 'categoryName': "Car repair"},
    {'categoriesId': '11011', 'categoryName': "Car wash"},
    {'categoriesId': '11066%2C11068', 'categoryName': "Dry cleaning"},
    {'categoriesId': '19006', 'categoryName': "Charging stations"},
    {'categoriesId': '19007', 'categoryName': "Gas"},
    {
      'categoriesId': '15014%2C15016%2C15011',
      'categoryName': "Hospitals & clinics"
    },
    {
      'categoriesId': '12075%2C11163%2C17102',
      'categoryName': "Mail & shipping"
    },
    {'categoriesId': '19020', 'categoryName': "Parking"},
    {'categoriesId': '17145', 'categoryName': "Pharmacies"},
  ];

  final arguments = [
    {
      'categoriesId': '11007%2C11019%2C11029%2C11039%2C11130%2C11131%2C11177',
      'categoryName': "Occasions"
    },
    {
      'categoriesId':
          '17064%2C17065%2C17066%2C17067%2C17068%2C17069%2C17070%2C17071%2C17072%2C17073%2C17074%2C17075%2C17077%2C17078%2C17079%2C17080%2C17142',
      'categoryName': "Super Market"
    },
    {
      'categoriesId':
          '13000%2C13001%2C13002%2C13026%2C13027%2C13028%2C13029%2C13030%2C13031%2C13032%2C13033%2C13034%2C13035%2C13036%2C13037%2C13038%2C13039%2C13040%2C13041%2C13042%2C13043%2C13044%2C13045%2C13046%2C13047%2C13048%2C13049%2C13050%2C13051%2C13052%2C13053%2C13054%2C13055%2C13056%2C13057%2C13058%2C13059%2C13060%2C13061%2C13062%2C13063%2C13064%2C13065%2C13066%2C13067%2C13068%2C13069%2C13070%2C13071%2C13072%2C13073%2C13074%2C13075%2C13076%2C13077%2C13078%2C13079%2C13080%2C13081%2C13082%2C13083%2C13084%2C13085%2C13086%2C13087%2C13088%2C13089%2C13090%2C13091%2C13092%2C13093%2C13094%2C13095%2C13096%2C13097%2C13098%2C13099%2C13100%2C13101%2C13102%2C13103%2C13104%2C13105%2C13106%2C13107%2C13108%2C13109%2C13110%2C13111%2C13112%2C13113%2C13114%2C13115%2C13116%2C13117%2C13118%2C13119%2C13120%2C13121%2C13122%2C13123%2C13124%2C13125%2C13126%2C13127%2C13128%2C13129%2C13130%2C13131%2C13132%2C13133%2C13134%2C13135%2C13136%2C13137%2C13138%2C13139%2C13140%2C13141%2C13142%2C13143%2C13144%2C13145%2C13146%2C13147%2C13148%2C13149%2C13150%2C13151%2C13152%2C13153%2C13154%2C13155%2C13156%2C13157%2C13158%2C13159%2C13160%2C13161%2C13162%2C13163%2C13164%2C13165%2C13166%2C13167%2C13168%2C13169%2C13170%2C13171%2C13172%2C13173%2C13174%2C13175%2C13176%2C13177%2C13178%2C13179%2C13180%2C13181%2C13182%2C13183%2C13184%2C13185%2C13186%2C13187%2C13188%2C13189%2C13190%2C13191%2C13192%2C13193%2C13194%2C13195%2C13196%2C13197%2C13198%2C13199%2C13200%2C13201%2C13202%2C13203%2C13204%2C13205%2C13206%2C13207%2C13208%2C13209%2C13210%2C13211%2C13212%2C13213%2C13214%2C13215%2C13216%2C13217%2C13218%2C13219%2C13220%2C13221%2C13222%2C13223%2C13224%2C13225%2C13226%2C13227%2C13228%2C13229%2C13230%2C13231%2C13232%2C13233%2C13234%2C13235%2C13236%2C13237%2C13238%2C13239%2C13240%2C13241%2C13242%2C13243%2C13244%2C13245%2C13246%2C13247%2C13248%2C13249%2C13250%2C13251%2C13252%2C13253%2C13254%2C13255%2C13256%2C13257%2C13258%2C13259%2C13260%2C13261%2C13262%2C13263%2C13264%2C13265%2C13266%2C13267%2C13268%2C13269%2C13270%2C13271%2C13272%2C13273%2C13274%2C13275%2C13276%2C13277%2C13278%2C13279%2C13280%2C13281%2C13282%2C13283%2C13284%2C13285%2C13286%2C13287%2C13288%2C13289%2C13290%2C13291%2C13292%2C13293%2C13294%2C13295%2C13296%2C13297%2C13298%2C13299%2C13300%2C13301%2C13302%2C13303%2C13304%2C13305%2C13306%2C13307%2C13308%2C13309%2C13310%2C13311%2C13312%2C13313%2C13314%2C13315%2C13316%2C13317%2C13318%2C13319%2C13320%2C13321%2C13322%2C13323%2C13324%2C13325%2C13326%2C13327%2C13328%2C13329%2C13330%2C13331%2C13332%2C13333%2C13334%2C13335%2C13336%2C13337%2C13338%2C13339%2C13340%2C13341%2C13342%2C13343%2C13344%2C13345%2C13346%2C13347%2C13348%2C13349%2C13350%2C13351%2C13352%2C13353%2C13354%2C13355%2C13356%2C13357%2C13358%2C13359%2C13360%2C13361%2C13362%2C13363%2C13364%2C13365%2C13366%2C13367%2C13368%2C13369%2C13370%2C13371%2C13372%2C13373%2C13374%2C13375%2C13376%2C13377%2C13378%2C13379%2C13380%2C13381%2C13382%2C13383%2C13384%2C13386%2C13387%2C13388%2C13389%2C13390%2C13392',
      'categoryName': 'Restaurant',
    },
    {'categoriesId': '13033%2C13034%2C13035%2C13036', 'categoryName': "Coffee"},
    {'query': 'shell', 'categoryName': 'Gas station'},
    {'query': 'hotel', 'categoryName': 'Hotel'},
    {
      'categoriesId':
          '13003%2C13004%2C13005%2C13006%2C13007%2C13008%2C13009%2C13010%2C13011%2C13012%2C13013%2C13014%2C13015%2C13016%2C13017%2C13018%2C13019%2C13020%2C13021%2C13022%2C13023%2C13024%2C13025',
      'categoryName': 'Bars'
    },
  ];

  List<String> buttonListIcon1 = [
    AppAssets.categoriesOccasions,
    AppAssets.categoriesSuperMarket,
    AppAssets.categoriesRestaurant,
    AppAssets.categoriesCoffee,
    AppAssets.categoriesGasStation,
    AppAssets.categoriesHotel,
    AppAssets.categoriesBar,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.whiteColor,
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: context.whiteColor,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(
            Icons.arrow_back_ios_new_outlined,
            color: context.titleColor,
          ),
        ),
        title: Text(
          'More Categories',
          style: getSemiBoldStyle(
              color: context.titleColor, fontSize: MyFonts.size18),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(AppConstants.padding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Container(
              //   decoration: BoxDecoration(
              //     color: context.containerColor,
              //     borderRadius: BorderRadius.circular(12.r),
              //   ),
              //   child: CustomSearchField(
              //     controller: searchController,
              //     hintText: 'Search favorites...',
              //     verticalMargin: 0,
              //     borderSide: BorderSide.none,
              //   ),
              // ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10.h),
                child: Text(
                  'Popular Categories',
                  style: getSemiBoldStyle(
                      color: context.titleColor, fontSize: MyFonts.size18),
                ),
              ),
              ListView.builder(
                  itemCount: buttonListIcon1.length,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return InkWell(
                      overlayColor:
                          MaterialStateProperty.all(Colors.transparent),
                      onTap: () {
                        Navigator.pushNamed(context, routes[index],
                            arguments: arguments[index]);
                      },
                      child: CategoriesOptions(
                        title: buttonList1[index],
                        icon: buttonListIcon1[index],
                        // trilling: index == 0 ? Icon(Icons.keyboard_arrow_down_rounded,
                        //     color: context.primaryColor, size: 16.r) : null,
                      ),
                    );
                  }),
              Padding(
                padding: EdgeInsets.only(top: 18.h),
                child: Text(
                  'All Categories',
                  style: getSemiBoldStyle(
                      color: context.titleColor, fontSize: MyFonts.size18),
                ),
              ),
              ListView.builder(
                itemCount: buttonList2.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return InkWell(
                    overlayColor: MaterialStateProperty.all(Colors.transparent),
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.placeslistScreen,
                        arguments: arguments2[index],
                      );
                    },
                    child: CategoriesOptions(
                      title: buttonList2[index],
                    ),
                  );
                },
              ),
              // CategoriesOptions(
              //   title: 'Airport', // trilling:
              // )
            ],
          ),
        ),
      ),
    );
  }
}
