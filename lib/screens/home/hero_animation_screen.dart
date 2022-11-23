import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:furniture_app/data/model/response/category_model.dart';
import 'package:furniture_app/data/model/response/product_model.dart';
import 'package:furniture_app/utils/color_resources.dart';

class HeroAnimationScreen extends StatefulWidget {
  final ProductModel product;

  const HeroAnimationScreen({Key? key, required this.product})
      : super(key: key);

  @override
  State<HeroAnimationScreen> createState() => _HeroAnimationScreenState();
}

class _HeroAnimationScreenState extends State<HeroAnimationScreen> {
  @override
  Widget build(BuildContext context) {
    String languageCode = Localizations.localeOf(context).languageCode;
    String productName = '';
    if (languageCode == 'en') {
      productName = widget.product.nameEn;
    } else if (languageCode == 'ru') {
      productName = widget.product.nameRu;
    } else if (languageCode == 'tr') {
      productName = widget.product.nameTr;
    } else if (languageCode == 'uz') {
      productName = widget.product.nameUz;
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorsResources.PRIMARY_BACKROUND_COLOR,
        elevation: 0,
        leading: Container(),
        leadingWidth: 0,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(
              Icons.cancel,
              color: Colors.white,
              size: 40,
            ),
          ),
          SizedBox(
            width: 12,
          ),
        ],
      ),
      body: Container(
        color: ColorsResources.PRIMARY_BACKROUND_COLOR,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Hero(
                tag: "heroOne",
                child: Container(
                  color: Colors.white,
                  child: CachedNetworkImage(
                    imageUrl: '${widget.product.img}',
                    placeholder: (BuildContext context, String url) =>
                        Container(
                      width: 320,
                      height: 240,
                      color: Colors.grey,
                    ),
                    errorWidget: (context, url, error) => new Icon(Icons.error),
                    width: double.infinity,
                    height: 307,
                  ),
                ),
              ),
              SizedBox(
                height: 24,
              ),
              Text(
                productName,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
