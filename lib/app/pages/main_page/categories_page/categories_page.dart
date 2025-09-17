import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:webinar/app/pages/main_page/categories_page/filter_category_page/filter_category_page.dart';
import 'package:webinar/app/providers/app_language_provider.dart';
import 'package:webinar/app/providers/drawer_provider.dart';
import 'package:webinar/app/services/guest_service/categories_service.dart';
import 'package:webinar/common/common.dart';
import 'package:webinar/common/data/app_language.dart';
import 'package:webinar/common/shimmer_component.dart';
import 'package:webinar/common/utils/app_text.dart';
import 'package:webinar/config/assets.dart';
import 'package:webinar/config/colors.dart';
import 'package:webinar/config/styles.dart';
import 'package:webinar/locator.dart';

import '../../../../common/utils/object_instance.dart';
import '../../../models/category_model.dart';
import '../../../../common/components.dart';
import '../home_page/search_page/suggested_search_page.dart';

class CategoriesPage extends StatefulWidget {
  static const String pageName = '/CategoriesPage';
  const CategoriesPage({super.key});

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  bool isLoading = true;
  List<CategoryModel> trendCategories = [];
  List<CategoryModel> categories = [];
  List<CategoryModel> searchedCategories = [];

  TextEditingController searchController = TextEditingController();
  FocusNode searchNode = FocusNode();

  @override
  void initState() {
    super.initState();

    Future.wait([getCategoriesData(), getTrendCategoriessData()]).then((value) {
      setState(() {
        isLoading = false;
        searchedCategories = categories; // Initialize with all categories
      });
    });

    searchController.addListener(() {
      searchedCategoriesFun(searchController.text);
    });
  }

  void searchedCategoriesFun(String query) {
    setState(() {
      if (query.isEmpty) {
        searchedCategories = categories;
      } else {
        searchedCategories = categories
            .where((category) =>
                category.title!.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  Future getCategoriesData() async {
    categories = await CategoriesService.categories();
  }

  Future getTrendCategoriessData() async {
    trendCategories = await CategoriesService.trendCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppLanguageProvider>(
        builder: (context, appLanguageProvider, _) {
      return directionality(child:
          Consumer<DrawerProvider>(builder: (context, drawerProvider, _) {
        return ClipRRect(
          borderRadius:
              borderRadius(radius: drawerProvider.isOpenDrawer ? 20 : 0),
          child: Scaffold(
            backgroundColor: greyFA,
            appBar: appbar(
                title: appText.categories,
                leftIcon: AppAssets.menuSvg,
                onTapLeftIcon: () {
                  drawerController.showDrawer();
                }),
            body: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  space(16),

                  input(
                    searchController,
                    searchNode,
                    appText.searchCategories,
                    iconPathLeft: AppAssets.searchSvg,
                    isReadOnly: false, // Make it editable
                    onChange: (value) {
                      searchedCategoriesFun(value);
                    },
                  ),

                  space(15),

                  Padding(
                    padding: padding(),
                    child: Text(
                      appText.trending,
                      style: style16Regular(),
                    ),
                  ),

                  space(14),

                  // trend categories
                  SizedBox(
                    width: getSize().width,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      padding: padding(),
                      child: Row(
                        children: List.generate(
                            isLoading ? 3 : trendCategories.length, (index) {
                          return isLoading
                              ? horizontalCategoryItemShimmer()
                              : horizontalCategoryItem(
                                  trendCategories[index].color ?? blueF2(),
                                  trendCategories[index].icon ?? '',
                                  trendCategories[index].title ?? '',
                                  trendCategories[index]
                                          .webinarsCount
                                          ?.toString() ??
                                      '0', () {
                                  nextRoute(FilterCategoryPage.pageName,
                                      arguments: trendCategories[index]);
                                });
                        }),
                      ),
                    ),
                  ),

                  space(30),

                  Padding(
                    padding: padding(),
                    child: Text(
                      appText.browseCategories,
                      style: style16Regular().copyWith(color: grey3A),
                    ),
                  ),

                  space(14),

                  // categories
                  Container(
                    width: getSize().width,
                    margin: padding(),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: borderRadius(),
                    ),
                    child: Column(
                      children: [
                        ...List.generate(isLoading ? 8 : searchedCategories.length,
                            (index) {
                          return isLoading
                              ? categoryItemShimmer()
                              : Container(
                                  width: getSize().width,
                                  padding: padding(),
                                  child: Column(
                                    children: [
                                      space(16),

                                      // category
                                      GestureDetector(
                                        onTap: () {
                                          if ((searchedCategories[index]
                                                  .subCategories
                                                  ?.isEmpty ??
                                              false)) {
                                            nextRoute(
                                                FilterCategoryPage.pageName,
                                                arguments: searchedCategories[index]);
                                          } else {
                                            setState(() {
                                              searchedCategories[index].isOpen =
                                                  !searchedCategories[index].isOpen;
                                            });
                                          }
                                        },
                                        behavior: HitTestBehavior.opaque,
                                        child: Row(
                                          children: [
                                            Container(
                                              width: 34,
                                              height: 34,
                                              decoration: BoxDecoration(
                                                color: greyF8,
                                                shape: BoxShape.circle,
                                              ),
                                              alignment: Alignment.center,
                                              child: Image.network(
                                                searchedCategories[index].icon ?? '',
                                                width: 22,
                                              ),
                                            ),
                                            space(0, width: 10),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  searchedCategories[index].title ?? '',
                                                  style: style14Bold(),
                                                ),
                                                Text(
                                                  '${searchedCategories[index].webinarsCount} ${appText.courses}',
                                                  style: style12Regular()
                                                      .copyWith(color: greyA5),
                                                ),
                                              ],
                                            ),
                                            const Spacer(),
                                            if (searchedCategories[index]
                                                    .subCategories
                                                    ?.isNotEmpty ??
                                                false) ...{
                                              AnimatedRotation(
                                                turns: searchedCategories[index].isOpen
                                                    ? 90 / 360
                                                    : locator<AppLanguage>()
                                                            .isRtl()
                                                        ? 180 / 360
                                                        : 0,
                                                duration: const Duration(
                                                    milliseconds: 200),
                                                child: SvgPicture.asset(
                                                    AppAssets.arrowRightSvg),
                                              )
                                            }
                                          ],
                                        ),
                                      ),

                                      // subCategories
                                      AnimatedCrossFade(
                                          firstChild: Stack(
                                            children: [
                                              // vertical dash
                                              PositionedDirectional(
                                                start: 15,
                                                top: 0,
                                                bottom: 35,
                                                child: CustomPaint(
                                                  size: const Size(
                                                      .5, double.infinity),
                                                  painter:
                                                      DashedLineVerticalPainter(),
                                                  child: const SizedBox(),
                                                ),
                                              ),

                                              // sub category
                                              SizedBox(
                                                child: Column(
                                                  children: List.generate(
                                                      searchedCategories[index]
                                                              .subCategories
                                                              ?.length ??
                                                          0, (i) {
                                                    return GestureDetector(
                                                      onTap: () {
                                                        nextRoute(
                                                            FilterCategoryPage
                                                                .pageName,
                                                            arguments: categories[
                                                                    index]
                                                                .subCategories![i]);
                                                      },
                                                      behavior: HitTestBehavior
                                                          .opaque,
                                                      child: Column(
                                                        children: [
                                                          space(15),

                                                          // sub categories item
                                                          Padding(
                                                            padding: padding(
                                                                horizontal: 10),
                                                            child: Row(
                                                              children: [
                                                                // circle
                                                                Container(
                                                                  width: 10,
                                                                  height: 10,
                                                                  decoration: BoxDecoration(
                                                                      color: Colors
                                                                          .white,
                                                                      border: Border.all(
                                                                          color:
                                                                              greyE7,
                                                                          width:
                                                                              1),
                                                                      shape: BoxShape
                                                                          .circle),
                                                                ),

                                                                space(0,
                                                                    width: 22),

                                                                // sub category details
                                                                Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Text(
                                                                      searchedCategories[index]
                                                                              .subCategories?[i]
                                                                              .title ??
                                                                          '',
                                                                      style:
                                                                          style14Bold(),
                                                                      maxLines:
                                                                          1,
                                                                    ),
                                                                    Text(
                                                                      searchedCategories[index].subCategories?[i].webinarsCount ==
                                                                              0
                                                                          ? appText
                                                                              .noCourse
                                                                          : '${searchedCategories[index].subCategories?[i].webinarsCount} ${appText.courses}',
                                                                      style: style12Regular().copyWith(
                                                                          color:
                                                                              greyA5),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          ),

                                                          space(15),
                                                        ],
                                                      ),
                                                    );
                                                  }),
                                                ),
                                              )
                                            ],
                                          ),
                                          secondChild: SizedBox(
                                            width: getSize().width,
                                          ),
                                          crossFadeState:
                                              searchedCategories[index].isOpen
                                                  ? CrossFadeState.showFirst
                                                  : CrossFadeState.showSecond,
                                          duration: const Duration(
                                              milliseconds: 300)),

                                      space(15),

                                      Container(
                                        width: getSize().width,
                                        height: 1,
                                        decoration:
                                            BoxDecoration(color: greyF8),
                                      )
                                    ],
                                  ),
                                );
                        })
                      ],
                    ),
                  ),

                  space(120),
                ],
              ),
            ),
          ),
        );
      }));
    });
  }
}

class DashedLineVerticalPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double dashHeight = 6, dashSpace = 5, startY = 0;
    final paint = Paint()
      ..color = Colors.grey.withOpacity(.5)
      ..strokeWidth = .4;
    while (startY < size.height) {
      canvas.drawLine(Offset(0, startY), Offset(0, startY + dashHeight), paint);
      startY += dashHeight + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:provider/provider.dart';
// import 'package:webinar/app/pages/main_page/categories_page/filter_category_page/filter_category_page.dart';
// import 'package:webinar/app/providers/app_language_provider.dart';
// import 'package:webinar/app/providers/drawer_provider.dart';
// import 'package:webinar/app/services/guest_service/categories_service.dart';
// import 'package:webinar/common/common.dart';
// import 'package:webinar/common/data/app_language.dart';
// import 'package:webinar/common/shimmer_component.dart';
// import 'package:webinar/common/utils/app_text.dart';
// import 'package:webinar/config/assets.dart';
// import 'package:webinar/config/colors.dart';
// import 'package:webinar/config/styles.dart';
// import 'package:webinar/locator.dart';
//
// import '../../../../common/utils/object_instance.dart';
// import '../../../models/category_model.dart';
// import '../../../../common/components.dart';
//
// class CategoriesPage extends StatefulWidget {
//   static const String pageName = '/CategoriesPage';
//
//   const CategoriesPage({super.key});
//
//   @override
//   State<CategoriesPage> createState() => _CategoriesPageState();
// }
//
// class _CategoriesPageState extends State<CategoriesPage> with TickerProviderStateMixin {
//
//   bool isLoading = true;
//   List<CategoryModel> trendCategories = [];
//   List<CategoryModel> categories = [];
//   late TabController _tabController;
//   //search ///
//   List<CategoryModel> originalCategories = [];
//   List<CategoryModel> filteredCategories = [];
//   TextEditingController _searchController = TextEditingController();
//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 2, vsync: this);
//     Future.wait([getCategoriesData(), getTrendCategoriessData()]).then((value) {
//       setState(() {
//         isLoading = false;
//         originalCategories = List.from(categories);
//         filteredCategories = List.from(categories);
//       });
//     });
//   }
//
//   void filterCategories(String query) {
//     if (query.isEmpty) {
//       setState(() {
//         filteredCategories = List.from(categories);
//       });
//       return;
//     }
//
//     List<CategoryModel> tempCategories = [];
//
//     for (var category in categories) {
//       // البحث في اسم الفئة الرئيسية
//       bool matchesCategory = category.title != null && category.title!.toLowerCase().contains(query.toLowerCase());
//
//       // البحث داخل الفئات الفرعية
//       List<CategoryModel> matchingSubCategories = (category.subCategories ?? []).where((sub) {
//         return sub.title != null && sub.title!.toLowerCase().contains(query.toLowerCase());
//       }).toList();
//
//       if (matchesCategory || matchingSubCategories.isNotEmpty) {
//         tempCategories.add(
//           CategoryModel(
//             id: category.id,
//             title: category.title,
//             color: category.color,
//             icon: category.icon,
//             subCategories: matchingSubCategories.isNotEmpty ? matchingSubCategories : category.subCategories,
//             webinarsCount: category.webinarsCount,
//           ),
//         );
//       }
//     }
//
//     setState(() {
//       filteredCategories = tempCategories;
//     });
//   }
//   Future getCategoriesData() async {
//     categories = await CategoriesService.categories();
//   }
//
//   Future getTrendCategoriessData() async {
//     trendCategories = await CategoriesService.trendCategories();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Consumer<AppLanguageProvider>(
//       builder: (context, appLanguageProvider, _) {
//         return directionality(
//           child: Consumer<DrawerProvider>(
//             builder: (context, drawerProvider, _) {
//               return ClipRRect(
//                 borderRadius: borderRadius(radius: drawerProvider.isOpenDrawer ? 20 : 0),
//                 child: Scaffold(
//                   backgroundColor: greyFA,
//                   appBar: appbar(
//                     title: appText.categories,
//                     leftIcon: AppAssets.menuSvg,
//                     onTapLeftIcon: () {
//                       drawerController.showDrawer();
//                     },
//                   ),
//                   body: SingleChildScrollView(
//                     physics: const BouncingScrollPhysics(),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         // Search Bar
//                         Padding(
//                           padding: EdgeInsets.all(25),
//                           child: SizedBox(
//                             height: 40,
//                             child: TextField(
//                               controller: _searchController,
//                               onChanged: filterCategories,
//                               decoration: InputDecoration(
//                                 hintText: "ابحث عن فئة أو فئة فرعية...",
//                                 prefixIcon: Icon(Icons.search, size: 20),
//                                 contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
//                                 border: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(8), // تقليل استدارة الحواف
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                         space(15),
//                         Padding(
//                           padding: padding(),
//                           child: Text(
//                             appText.trending,
//                             style: style16Regular(),
//                           ),
//                         ),
//                         space(14),
//                         // trend categories
//                         // SizedBox(
//                         //   width: getSize().width,
//                         //   child: SingleChildScrollView(
//                         //     scrollDirection: Axis.horizontal,
//                         //     physics: const BouncingScrollPhysics(),
//                         //     padding: padding(),
//                         //     child: Row(
//                         //       children: List.generate(
//                         //           isLoading ? 3 : trendCategories.length,
//                         //               (index) {
//                         //             return isLoading
//                         //                 ? horizontalCategoryItemShimmer()
//                         //                 : horizontalCategoryItem(
//                         //                 trendCategories[index].color ?? blueF2(),
//                         //                 trendCategories[index].icon ?? '',
//                         //                 trendCategories[index].title ?? '',
//                         //                 trendCategories[index].webinarsCount?.toString() ?? '0',
//                         //                     () {
//                         //                   nextRoute(FilterCategoryPage.pageName, arguments: trendCategories[index]);
//                         //                 }
//                         //             );
//                         //           }
//                         //       ),
//                         //     ),
//                         //   ),
//                         // ),
//                         space(30),
//                         Padding(
//                           padding: padding(),
//                           child: Text(
//                             appText.browseCategories,
//                             style: style16Regular().copyWith(color: grey3A),
//                           ),
//                         ),
//                         space(14),
//
//
//
//                         ConstrainedBox(
//                           constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height),
//                           child: Container(
//                             width: getSize().width,
//                             margin: padding(),
//                             decoration: BoxDecoration(
//                               color: Colors.white,
//                               borderRadius: borderRadius(),
//                             ),
//                             child: Column(
//                               children: [
//                                 TabBar(
//                                   indicatorPadding: const EdgeInsets.symmetric(horizontal: 50.0),
//                                   unselectedLabelColor: Colors.black,
//                                   labelColor: Colors.blue,
//                                   labelStyle: const TextStyle(fontSize: 17),
//                                   controller: _tabController,
//                                   tabs: [
//                                     Tab(text: appText.categories),
//                                     Tab(text: appText.subcategories),
//                                   ],
//                                 ),
//                                 Expanded(
//                                   child: TabBarView(
//                                     controller: _tabController,
//                                     children: [
//                                       ListView.builder(
//                                         itemCount: isLoading ? 8 : filteredCategories.length,
//                                         itemBuilder: (context, index) {
//                                           return isLoading
//                                               ? categoryItemShimmer()
//                                               : Container(
//                                             width: getSize().width,
//                                             padding: padding(),
//                                             child: Column(
//                                               children: [
//                                                 space(16),
//                                                 GestureDetector(
//                                                   onTap: () {
//                                                     if ((filteredCategories[index].subCategories?.isEmpty ?? false)) {
//                                                       nextRoute(FilterCategoryPage.pageName, arguments: filteredCategories[index]);
//                                                     } else {
//                                                       setState(() {
//                                                         filteredCategories[index].isOpen = !filteredCategories[index].isOpen;
//                                                       });
//                                                     }
//                                                   },
//                                                   behavior: HitTestBehavior.opaque,
//                                                   child: Row(
//                                                     children: [
//                                                       Container(
//                                                         width: 34,
//                                                         height: 34,
//                                                         decoration: BoxDecoration(
//                                                           color: greyF8,
//                                                           shape: BoxShape.circle,
//                                                         ),
//                                                         alignment: Alignment.center,
//                                                         child: Image.network(
//                                                           filteredCategories[index].icon ?? '',
//                                                           width: 22,
//                                                         ),
//                                                       ),
//                                                       space(0, width: 10),
//                                                       Column(
//                                                         crossAxisAlignment: CrossAxisAlignment.start,
//                                                         mainAxisAlignment: MainAxisAlignment.center,
//                                                         children: [
//                                                           Text(
//                                                             filteredCategories[index].title ?? '',
//                                                             style: style14Bold(),
//                                                           ),
//                                                           Text(
//                                                             '${filteredCategories[index].webinarsCount} ${appText.courses}',
//                                                             style: style12Regular().copyWith(color: greyA5),
//                                                           ),
//                                                         ],
//                                                       ),
//                                                       const Spacer(),
//                                                       if (filteredCategories[index].subCategories?.isNotEmpty ?? false)
//                                                         AnimatedRotation(
//                                                           turns: filteredCategories[index].isOpen
//                                                               ? 90 / 360
//                                                               : locator<AppLanguage>().isRtl()
//                                                               ? 180 / 360
//                                                               : 0,
//                                                           duration: const Duration(milliseconds: 200),
//                                                           child: SvgPicture.asset(AppAssets.arrowRightSvg),
//                                                         ),
//                                                     ],
//                                                   ),
//                                                 ),
//                                                 AnimatedCrossFade(
//                                                   firstChild: Stack(
//                                                     children: [
//                                                       PositionedDirectional(
//                                                         start: 15,
//                                                         top: 0,
//                                                         bottom: 35,
//                                                         child: CustomPaint(
//                                                           size: const Size(.5, double.infinity),
//                                                           painter: DashedLineVerticalPainter(),
//                                                           child: const SizedBox(),
//                                                         ),
//                                                       ),
//                                                       Column(
//                                                         children: List.generate(filteredCategories[index].subCategories?.length ?? 0, (i) {
//                                                           return GestureDetector(
//                                                             onTap: () {
//                                                               nextRoute(FilterCategoryPage.pageName, arguments: filteredCategories[index].subCategories![i]);
//                                                             },
//                                                             behavior: HitTestBehavior.opaque,
//                                                             child: Column(
//                                                               children: [
//                                                                 space(15),
//                                                                 Padding(
//                                                                   padding: padding(horizontal: 10),
//                                                                   child: Row(
//                                                                     children: [
//                                                                       Container(
//                                                                         width: 10,
//                                                                         height: 10,
//                                                                         decoration: BoxDecoration(
//                                                                           color: Colors.white,
//                                                                           border: Border.all(color: greyE7, width: 1),
//                                                                           shape: BoxShape.circle,
//                                                                         ),
//                                                                       ),
//                                                                       space(0, width: 22),
//                                                                       Column(
//                                                                         crossAxisAlignment: CrossAxisAlignment.start,
//                                                                         mainAxisAlignment: MainAxisAlignment.center,
//                                                                         children: [
//                                                                           Text(
//                                                                             filteredCategories[index].subCategories?[i].title ?? '',
//                                                                             style: style14Bold(),
//                                                                             maxLines: 1,
//                                                                           ),
//                                                                           Text(
//                                                                             filteredCategories[index].subCategories?[i].webinarsCount == 0
//                                                                                 ? appText.noCourse
//                                                                                 : '${filteredCategories[index].subCategories?[i].webinarsCount} ${appText.courses}',
//                                                                             style: style12Regular().copyWith(color: greyA5),
//                                                                           ),
//                                                                         ],
//                                                                       ),
//                                                                     ],
//                                                                   ),
//                                                                 ),
//                                                                 space(15),
//                                                               ],
//                                                             ),
//                                                           );
//                                                         }),
//                                                       ),
//                                                     ],
//                                                   ),
//                                                   secondChild: SizedBox(width: getSize().width),
//                                                   crossFadeState: filteredCategories[index].isOpen ? CrossFadeState.showFirst : CrossFadeState.showSecond,
//                                                   duration: const Duration(milliseconds: 300),
//                                                 ),
//                                                 space(15),
//                                                 Container(
//                                                   width: getSize().width,
//                                                   height: 1,
//                                                   decoration: BoxDecoration(color: greyF8),
//                                                 ),
//                                               ],
//                                             ),
//                                           );
//                                         },
//                                       ),
//                                       ListView.builder(
//                                         itemCount: isLoading
//                                             ? 8
//                                             : filteredCategories.fold<int>(0, (int sum, category) {
//                                           return sum + (category.subCategories?.length ?? 0);
//                                         }),
//                                         itemBuilder: (context, index) {
//                                           int subCategoryIndex = 0;
//                                           for (var category in filteredCategories) {
//                                             if (category.subCategories != null && category.subCategories!.isNotEmpty) {
//                                               if (index < subCategoryIndex + category.subCategories!.length) {
//                                                 final subCategory = category.subCategories![index - subCategoryIndex];
//                                                 return isLoading
//                                                     ? categoryItemShimmer()
//                                                     : Padding(
//                                                   padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
//                                                   child: Container(
//                                                     padding: EdgeInsets.all(12),
//                                                     decoration: BoxDecoration(
//                                                       color: Colors.grey[100],
//                                                       borderRadius: BorderRadius.circular(8),
//                                                     ),
//                                                     child: Column(
//                                                       crossAxisAlignment: CrossAxisAlignment.start,
//                                                       children: [
//                                                         Row(
//                                                           children: [
//                                                             Padding(
//                                                               padding: const EdgeInsets.only(right: 8.0),
//                                                               child: subCategory.icon != null && subCategory.icon!.isNotEmpty
//                                                                   ? Image.network(
//                                                                 subCategory.icon!,
//                                                                 width: 24,
//                                                                 height: 24,
//                                                                 errorBuilder: (context, error, stackTrace) {
//                                                                   return Icon(Icons.image_not_supported, color: Colors.grey);
//                                                                 },
//                                                               )
//                                                                   : Image.asset(
//                                                                 'assets/image/png/splash_logo.png',
//                                                                 width: 30,
//                                                                 height: 30,
//                                                                 fit: BoxFit.cover,
//                                                               ), // أيقونة افتراضية
//                                                             ),
//                                                             Text(
//                                                               subCategory.title ?? '',
//                                                               style: TextStyle(
//                                                                 fontSize: 16,
//                                                                 fontWeight: FontWeight.bold,
//                                                                 color: category.color ?? Colors.black,
//                                                               ),
//                                                             ),
//                                                             SizedBox(width: 8),
//                                                             Text(
//                                                               '${subCategory.webinarsCount} ${appText.courses}',
//                                                               style: TextStyle(
//                                                                 fontSize: 14,
//                                                                 color: greyA5,
//                                                               ),
//                                                             ),
//                                                           ],
//                                                         ),
//                                                       ],
//                                                     ),
//                                                   ),
//                                                 );
//                                               }
//                                               subCategoryIndex += category.subCategories!.length;
//                                             }
//                                           }
//                                           return Container();
//                                         },
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                         space(120),
//                       ],
//                     ),
//                   ),
//                 ),
//               );
//             },
//           ),
//         );
//       },
//     );
//   }
// }
//
// class DashedLineVerticalPainter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     double dashHeight = 6, dashSpace = 5, startY = 0;
//     final paint = Paint()
//       ..color = greyA5
//       ..strokeWidth = 1
//       ..style = PaintingStyle.stroke;
//
//     while (startY < size.height) {
//       canvas.drawLine(
//           Offset(0, startY), Offset(0, startY + dashHeight), paint);
//       startY += dashHeight + dashSpace;
//     }
//   }
//
//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) {
//     return false;
//   }
// }