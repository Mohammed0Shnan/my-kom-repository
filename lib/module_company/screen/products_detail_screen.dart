import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:my_kom/consts/colors.dart';
import 'package:my_kom/module_company/models/product_model.dart';
import 'package:my_kom/module_shoping/shoping_routes.dart';
import 'package:my_kom/utils/size_configration/size_config.dart';

class PriductDetailScreen extends StatefulWidget {
  final String companyImge;
  final ProductModel productModel;
  const PriductDetailScreen(
      {required this.productModel, required this.companyImge, Key? key})
      : super(key: key);

  @override
  State<PriductDetailScreen> createState() => _PriductDetailScreenState();
}

class _PriductDetailScreenState extends State<PriductDetailScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: SafeArea(
      child: CustomScrollView(slivers: [
        SliverPersistentHeader(
            pinned: true,
            floating: true,
            delegate: _CustomizeAppBar(
                id: widget.productModel.id,
                maxExpand: 250,
                minExpand: 50,
                companyImageUrl: widget.companyImge,
                productImage: widget.companyImge,
                size: size,
                title: widget.productModel.title)),
        SliverToBoxAdapter(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
              SizedBox(
                height: 20,
              ),
              Container(
                child: Text(
                  widget.productModel.description +
                      '      ' +
                      widget.productModel.description +
                      widget.productModel.description +
                      widget.productModel.description +
                      widget.productModel.description +
                      widget.productModel.description +
                      widget.productModel.description,
                  style: TextStyle(
                      fontSize: 17,
                      color: Colors.black54,
                      fontWeight: FontWeight.w600),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                'المواصفات',
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.black87,
                    fontWeight: FontWeight.w600),
              ),
              Container(
                height: 100,
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Column(children: [
                  Divider(
                    indent: 10,
                    endIndent: 10,
                  ),
                  Row(
                    children: [
                      Spacer(),
                      Text('12 g  '),
                      Text(
                        ': البوتاسيوم',
                        style: TextStyle(fontWeight: FontWeight.w800),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Spacer(),
                      Text('12 g  '),
                      Text(': الصوديوم',
                          style: TextStyle(fontWeight: FontWeight.w800))
                    ],
                  ),
                  Row(
                    children: [
                      Spacer(),
                      Text('12 g  '),
                      Text(': الحديد',
                          style: TextStyle(fontWeight: FontWeight.w800))
                    ],
                  ),
                ]),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(children: [
                  Row(
                    children: [
                      Expanded(child: Text('28.00 AED')),
                      Expanded(child: LayoutBuilder(
                        builder:
                            (BuildContext context, BoxConstraints constraints) {
                          double w = constraints.maxWidth;

                          return Container(
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                              boxShadow: [BoxShadow(color: Colors.black12)],
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.white.withOpacity(0.1),
                            ),
                            child: Stack(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      color: ColorsConst.mainColor,
                                      width: w / 3,
                                      child: IconButton(
                                          onPressed: () {},
                                          icon: Icon(
                                            Icons.minimize_sharp,
                                            size: SizeConfig.imageSize * 5,
                                            color: Colors.white,
                                          )),
                                    ),
                                    Container(
                                      child: Text('100'),
                                    ),
                                    Container(
                                      width: w / 3,
                                      color: ColorsConst.mainColor,
                                      child: Center(
                                        child: IconButton(
                                            onPressed: () {},
                                            icon: Icon(
                                              Icons.add,
                                              size: SizeConfig.imageSize * 5,
                                              color: Colors.white,
                                            )),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ))
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                        color: ColorsConst.mainColor,
                        borderRadius: BorderRadius.circular(10)),
                    child: MaterialButton(
                      onPressed: () {},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Add to cart',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: SizeConfig.titleSize * 2.7),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Icon(Icons.shopping_cart_outlined,
                              color: Colors.white)
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ]),
              )
            ]),
          ),
        )
      ]),
    ));
  }
}

class _CustomizeAppBar extends SliverPersistentHeaderDelegate {
  final String id;
  final double maxExpand;
  final double minExpand;
  final Size size;
  final String companyImageUrl;
  final String productImage;
  final String title;

  _CustomizeAppBar(
      {required this.id,
      required this.maxExpand,
      required this.minExpand,
      required this.size,
      required this.companyImageUrl,
      required this.productImage,
      required this.title});
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    double percent = shrinkOffset / maxExpand;
    num rotateLimit = 0.2;

    double angle = 10;
    num valueBack = (1 - percent - 0.6).clamp(0, rotateLimit);
    print(percent);
    print(valueBack);
    return Stack(
      children: [
        Container(),
        Container(
          width: double.infinity,
          child: productImage.length != 0
              ? Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: new ExactAssetImage('assets/product_image.png'),
                      fit: BoxFit.fill,
                    ),
                  ),
                )
              : CachedNetworkImage(
                  maxHeightDiskCache: 5,
                  imageUrl: productImage,
                  progressIndicatorBuilder: (context, l, ll) =>
                      CircularProgressIndicator(
                    value: ll.progress,
                  ),
                  errorWidget: (context, s, l) => Icon(Icons.error),
                  fit: BoxFit.cover,
                ),
        ),
        if (percent < rotateLimit) ...[
          SliverBottomBar(fixAppBarValue: percent, size: size, title: title),
          Positioned(
              bottom: 10,
              left: 20,
              child: Transform(
                  alignment: Alignment.topRight,
                  transform: Matrix4.identity()
                    ..rotateZ(percent < rotateLimit
                        ? percent * angle
                        : valueBack * angle),
                  child: _buildCompanyImage(companyImageUrl)))
        ] else ...[
          Positioned(
              bottom: 10,
              left: 20,
              child: Transform(
                alignment: Alignment.topRight,
                transform: Matrix4.identity()
                  ..rotateZ(percent < rotateLimit
                      ? percent * angle
                      : valueBack * angle),
                child: _buildCompanyImage(companyImageUrl),
              )),
          SliverBottomBar(fixAppBarValue: percent, size: size, title: title),
        ],
        Positioned(
            top: 5,
            right: 10,
            child: Badge(
              position: BadgePosition.topEnd(top: 0, end: 3),
              animationDuration: Duration(milliseconds: 300),
              animationType: BadgeAnimationType.slide,
              badgeContent: Text(
                '1',
                style: TextStyle(color: Colors.white),
              ),
              child: IconButton(
                  icon: Icon(Icons.shopping_cart_outlined),
                  onPressed: () {
                    Navigator.pushNamed(context, ShopingRoutes.SHOPE_SCREEN);
                  }),
            )),
      ],
    );
  }

  Widget _buildCompanyImage(String ImageUrl) {
    return Container(
      height: SizeConfig.imageSize * 38,
      width: SizeConfig.imageSize * 28,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: companyImageUrl.length != 0
            ? Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: new ExactAssetImage(companyImageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              )
            : CachedNetworkImage(
                maxHeightDiskCache: 5,
                imageUrl: companyImageUrl,
                progressIndicatorBuilder: (context, l, ll) =>
                    CircularProgressIndicator(
                  value: ll.progress,
                ),
                errorWidget: (context, s, l) => Icon(Icons.error),
                fit: BoxFit.cover,
              ),
      ),
    );
  }

  @override
  // TODO: implement maxExtent
  double get maxExtent => maxExpand;

  @override
  // TODO: implement minExtent
  double get minExtent => minExpand;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      false;
}

class SliverBottomBar extends StatelessWidget {
  final String title;
  final double fixAppBarValue;
  final Size size;
  SliverBottomBar({
    required this.fixAppBarValue,
    required this.size,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: -size.width * fixAppBarValue.clamp(0, 0.3),
      right: 0,
      child: Container(
        height: 70,
        padding: EdgeInsets.only(left: 150, top: 20),
        child: Text(
          title,
          style: TextStyle(
              fontSize: SizeConfig.titleSize * 4, fontWeight: FontWeight.bold),
        ),
        decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 5,
                offset: Offset(0, -5),
              ),
            ],
            borderRadius: BorderRadius.only(topLeft: Radius.circular(200))),
      ),
    );
  }
}
