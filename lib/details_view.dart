import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:otlopapp/core/utils/back_button.dart';
import 'package:otlopapp/core/widgets/product_image.dart';
import 'package:otlopapp/models/product_model.dart';
import 'package:otlopapp/scrollable_details_body.dart';

class ProductDetailsView extends StatelessWidget {
  static const routeName = '/productDetails';

  const ProductDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final ProductModel product =
        ModalRoute.of(context)!.settings.arguments as ProductModel;
    final String? headerImage = _bestProductImage(product);

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 20.0, left: 24.0, right: 24.0),
        child: Container(
          width: double.infinity,
          height: 60.h,
          decoration: BoxDecoration(
            color: const Color(0xffD61355),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Center(
            child: Text(
              "Order Now",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          // 1. Collapsible Image Header with Back Button
          SliverAppBar(
            expandedHeight: height * 0.45,
            pinned: true,
            automaticallyImplyLeading: false,
            backgroundColor: Colors.transparent,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  ProductImage(
                    imageUrl: headerImage,
                    fit: BoxFit.contain,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                  CustomBackButton(
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
          ),

          // 2. Scrollable Details Body
          ScrollableDetailsBody(product: product),
        ],
      ),
    );
  }

  String? _bestProductImage(ProductModel product) {
    final images = product.images ?? const <String>[];
    for (final image in images) {
      if (image.trim().isNotEmpty) {
        return image;
      }
    }

    return product.thumbnail;
  }
}
