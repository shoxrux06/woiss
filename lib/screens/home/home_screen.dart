import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:furniture_app/controller/product_controller.dart';
import 'package:furniture_app/providers/cart_provider.dart';
import 'package:furniture_app/data/repository/product_repository.dart';
import 'package:furniture_app/screens/home/category_screen.dart';
import 'package:furniture_app/utils/app_constants.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:provider/provider.dart';
import '../../data/model/response/category_model.dart';
import '../../localization/app_localization.dart';
import '../../utils/color_resources.dart';
import '../../utils/custom_themes.dart';
import '../../utils/size_config.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController searchController = TextEditingController();

  final _controller = Get.put(ProductController(productRepo: ProductRepository()));

  @override
  void initState() {
    super.initState();
    _controller.getCategoryList();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    Future.delayed(Duration.zero,(){
      _controller.updateCategoryString('');
    });

  }
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    var size = MediaQuery.of(context).size;

    final isLandscape = MediaQuery.of(context).orientation ==
        Orientation.landscape;

    SizeConfig().init(context);

    /*24 is for notification bar on Android*/
    final double itemHeight = (size.height - kToolbarHeight - 24) / 2;
    final double itemWidth = size.width / 2;
    return Scaffold(
      backgroundColor: ColorsResources.PRIMARY_BACKROUND_COLOR,
      body: AnnotatedRegion(
        child: SafeArea(
          child: Material(
            child: Container(
              child: RefreshIndicator(
                onRefresh: () async {},
                child: GetBuilder<ProductController>(
                    init: ProductController(productRepo: ProductRepository()),
                    builder: (controller) {
                      if(screenWidth >= 600 && screenWidth <= 700){
                        return Container(
                          color: ColorsResources.PRIMARY_BACKROUND_COLOR,
                          child: CustomScrollView(
                            slivers: [
                              SliverAppBar(
                                toolbarHeight: 100,
                                expandedHeight: 70,
                                floating: true,
                                stretch: true,
                                elevation: 0,
                                centerTitle: false,
                                automaticallyImplyLeading: false,
                                backgroundColor:
                                ColorsResources.PRIMARY_BACKROUND_COLOR,
                                leadingWidth: 150,
                                leading: Padding(
                                  padding: EdgeInsets.only(left: 24),
                                  child: Image.asset(
                                    'assets/icons/logotwo.png',
                                    width: 200,
                                    height: 80,
                                  ),
                                ),
                                title:   Container(
                                  padding: EdgeInsets.only(top: 4, bottom: 8, left: 100, right: 35),
                                  color: ColorsResources.PRIMARY_BACKROUND_COLOR,
                                  height: 56,
                                  child: TextFormField(
                                    onChanged: (String value) => controller.updateCategoryString(value),
                                    style: titleRegular.copyWith(fontSize: 18),
                                    controller: searchController,
                                    decoration: InputDecoration(
                                      // contentPadding: const EdgeInsets.all(10.0),
                                      alignLabelWithHint: false,
                                      floatingLabelBehavior:
                                      FloatingLabelBehavior.always,
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          width: 1,
                                          color: Color.fromRGBO(171, 116, 64, 0.9),
                                        ),
                                        borderRadius: BorderRadius.circular(0),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          width: 1,
                                          color: ColorsResources.PRIMARY_COLOR,
                                        ),
                                        borderRadius: BorderRadius.circular(0),
                                      ),
                                      labelText: AppLocalization.of(context)
                                          ?.translate('search_category') ??
                                          '',
                                      labelStyle: titleRegular,
                                      hintStyle: titleRegular,
                                      suffixIcon: IconButton(
                                        onPressed: () {

                                        },
                                        icon: Icon(
                                          Icons.search,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                actions: [
                                  // IconButton(onPressed: (){}, icon: Icon(Icons.add_a_photo))
                                ],
                              ),
                              SliverToBoxAdapter(
                                child: Container(
                                  padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
                                  child: GridView.builder(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2,
                                          childAspectRatio: isLandscape? SizeConfig.aspectRatio * 1.4:SizeConfig.aspectRatio * 2.2,
                                          crossAxisSpacing: 20
                                      ),
                                      itemCount: controller.categoryList.length,
                                      itemBuilder: (context, index){
                                        return Material(
                                          color: ColorsResources.PRIMARY_BACKROUND_COLOR,
                                          child: InkWell(
                                            onTap: () {
                                              Navigator.of(context).push(
                                                MaterialPageRoute(
                                                  builder: (context) => CategoryScreen(
                                                    catId: controller.categoryList[index].id,
                                                    catName: controller.categoryList[index].name,
                                                  ),
                                                ),
                                              );
                                              searchController.text = '';
                                            },
                                            child: Container(
                                              padding: EdgeInsets.symmetric(vertical: 10),
                                              child: Stack(
                                                children: [
                                                  CachedNetworkImage(
                                                    imageUrl: controller.categoryList[index].img,
                                                    placeholder: (BuildContext context, String url) => Container(
                                                      width: 320,
                                                      height: 270,
                                                      color: Colors.grey,
                                                    ),
                                                    errorWidget: (context,url,error) => new Icon(Icons.error),
                                                    width: double.infinity,
                                                    height: 270,
                                                    fit: BoxFit.fitWidth,
                                                  ),
                                                  Positioned(
                                                    bottom: 0,
                                                    right: 0,
                                                    child: Container(
                                                      width: 100,
                                                      height: 40,
                                                      color: Colors.black54,
                                                      child: Center(
                                                        child: Text(
                                                          controller.categoryList[index].name,
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      }),
                                ),
                              )
                            ],
                          ),
                        );
                      }else if(screenWidth > 700){
                        return Container(
                          color: ColorsResources.PRIMARY_BACKROUND_COLOR,
                          child: CustomScrollView(
                            slivers: [
                              SliverAppBar(
                                toolbarHeight: 100,
                                expandedHeight: 70,
                                floating: true,
                                stretch: true,
                                elevation: 0,
                                centerTitle: false,
                                automaticallyImplyLeading: false,
                                backgroundColor:
                                ColorsResources.PRIMARY_BACKROUND_COLOR,
                                leadingWidth: 150,
                                leading: Padding(
                                  padding: EdgeInsets.only(left: 24),
                                  child: Image.asset(
                                    'assets/icons/logotwo.png',
                                    width: 200,
                                    height: 80,
                                  ),
                                ),
                                title:   Container(
                                  padding: EdgeInsets.only(top: 4, bottom: 8, left: 100, right: 35),
                                  color: ColorsResources.PRIMARY_BACKROUND_COLOR,
                                  height: 56,
                                  child: TextFormField(
                                    onChanged: (String value) => controller.updateCategoryString(value),
                                    style: titleRegular.copyWith(fontSize: 18),
                                    controller: searchController,
                                    decoration: InputDecoration(
                                      // contentPadding: const EdgeInsets.all(10.0),
                                      alignLabelWithHint: false,
                                      floatingLabelBehavior:
                                      FloatingLabelBehavior.always,
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          width: 1,
                                          color: Color.fromRGBO(171, 116, 64, 0.9),
                                        ),
                                        borderRadius: BorderRadius.circular(0),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          width: 1,
                                          color: ColorsResources.PRIMARY_COLOR,
                                        ),
                                        borderRadius: BorderRadius.circular(0),
                                      ),
                                      labelText: AppLocalization.of(context)
                                          ?.translate('search_category') ??
                                          '',
                                      labelStyle: titleRegular,
                                      hintStyle: titleRegular,
                                      suffixIcon: IconButton(
                                        onPressed: () {

                                        },
                                        icon: Icon(
                                          Icons.search,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                actions: [
                                  // IconButton(onPressed: (){}, icon: Icon(Icons.add_a_photo))
                                ],
                              ),
                              SliverToBoxAdapter(
                                child: Container(
                                  padding: EdgeInsets.only(left: 50, right: 50, bottom: 50),
                                  child: GridView.builder(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2,
                                          childAspectRatio: isLandscape? SizeConfig.aspectRatio * 1.4:SizeConfig.aspectRatio * 2.2,
                                          crossAxisSpacing: 20
                                      ),
                                      itemCount: controller.categoryList.length,
                                      itemBuilder: (context, index){
                                        return Material(
                                          color: ColorsResources.PRIMARY_BACKROUND_COLOR,
                                          child: InkWell(
                                            onTap: () {
                                              Navigator.of(context).push(
                                                MaterialPageRoute(
                                                  builder: (context) => CategoryScreen(
                                                    catId: controller.categoryList[index].id,
                                                    catName: controller.categoryList[index].name,
                                                  ),
                                                ),
                                              );
                                              searchController.text = '';
                                            },
                                            child: Container(
                                              padding: EdgeInsets.symmetric(vertical: 10),
                                              child: Stack(
                                                children: [
                                                  CachedNetworkImage(
                                                    imageUrl: controller.categoryList[index].img,
                                                    placeholder: (BuildContext context, String url) => Container(
                                                      width: 320,
                                                      height: 270,
                                                      color: Colors.grey,
                                                    ),
                                                    errorWidget: (context,url,error) => new Icon(Icons.error),
                                                    width: double.infinity,
                                                    height: 270,
                                                    fit: BoxFit.fitWidth,
                                                  ),
                                                  Positioned(
                                                    bottom: 0,
                                                    right: 0,
                                                    child: Container(
                                                      width: 100,
                                                      height: 40,
                                                      color: Colors.black54,
                                                      child: Center(
                                                        child: Text(
                                                          controller.categoryList[index].name,
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      }),
                                ),
                              )
                            ],
                          ),
                        );
                      }else{
                        return Container(
                          padding: EdgeInsets.all(20),
                          color: ColorsResources.PRIMARY_BACKROUND_COLOR,
                          child: CustomScrollView(
                            slivers: [
                              SliverAppBar(
                                toolbarHeight: 70,
                                expandedHeight: 70,
                                floating: true,
                                stretch: true,
                                elevation: 0,
                                centerTitle: false,
                                automaticallyImplyLeading: false,
                                backgroundColor:
                                ColorsResources.PRIMARY_BACKROUND_COLOR,
                                leading: Image.asset(
                                  'assets/icons/logotwo.png',
                                  width: 200,
                                  height: 80,
                                ),
                              ),
                              SliverPersistentHeader(
                                floating: true,
                                pinned: true,
                                delegate: SliverDelegate(
                                  child: Container(
                                    padding: EdgeInsets.only(top: 4, bottom: 8),
                                    color: ColorsResources.PRIMARY_BACKROUND_COLOR,
                                    height: 56,
                                    child: TextFormField(
                                      onChanged: (String value) => controller.updateCategoryString(value),
                                      style: titleRegular.copyWith(fontSize: 18),
                                      controller: searchController,
                                      decoration: InputDecoration(
                                        // contentPadding: const EdgeInsets.all(10.0),
                                        alignLabelWithHint: false,
                                        floatingLabelBehavior:
                                        FloatingLabelBehavior.always,
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            width: 1,
                                            color: Color.fromRGBO(171, 116, 64, 0.9),
                                          ),
                                          borderRadius: BorderRadius.circular(0),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            width: 1,
                                            color: ColorsResources.PRIMARY_COLOR,
                                          ),
                                          borderRadius: BorderRadius.circular(0),
                                        ),
                                        labelText: AppLocalization.of(context)
                                            ?.translate('search_category') ??
                                            '',
                                        labelStyle: titleRegular,
                                        hintStyle: titleRegular,
                                        suffixIcon: IconButton(
                                          onPressed: () {

                                          },
                                          icon: Icon(
                                            Icons.search,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SliverToBoxAdapter(
                                  child: Container(
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        return Material(
                                          color: ColorsResources.PRIMARY_BACKROUND_COLOR,
                                          child: InkWell(
                                            onTap: () {
                                              Navigator.of(context).push(
                                                MaterialPageRoute(
                                                  builder: (context) => CategoryScreen(
                                                    catId: controller.categoryList[index].id,
                                                    catName: controller.categoryList[index].name,
                                                  ),
                                                ),
                                              );
                                              searchController.text = '';
                                            },
                                            child: Container(
                                              padding: EdgeInsets.symmetric(vertical: 8),
                                              child: Stack(
                                                children: [
                                                  CachedNetworkImage(
                                                    imageUrl: controller.categoryList[index].img,
                                                    placeholder: (BuildContext context, String url) => Container(
                                                      width: 320,
                                                      height: 240,
                                                      color: Colors.grey,
                                                    ),
                                                    errorWidget: (context,url,error) => new Icon(Icons.error),
                                                    width: double.infinity,
                                                    height: 154,
                                                    fit: BoxFit.fitWidth,
                                                  ),
                                                  Positioned(
                                                    bottom: 0,
                                                    right: 0,
                                                    child: Container(
                                                      width: 100,
                                                      height: 40,
                                                      color: Colors.black54,
                                                      child: Center(
                                                        child: Text(
                                                          controller
                                                              .categoryList[index].name,
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                      itemCount: controller.categoryList.length,
                                    ),
                                  )),
                            ],
                          ),
                        );
                      }
                    }),
              ),
            ),
          ),
        ),
        value: SystemUiOverlayStyle.light,
      )
    );
  }

}

class SliverDelegate extends SliverPersistentHeaderDelegate {
  Widget child;

  SliverDelegate({required this.child});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  double get maxExtent => 60;

  @override
  double get minExtent => 60;

  @override
  bool shouldRebuild(SliverDelegate oldDelegate) {
    return oldDelegate.maxExtent != 70 ||
        oldDelegate.minExtent != 70 ||
        child != oldDelegate.child;
  }
}
