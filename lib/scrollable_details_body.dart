import 'package:flutter/material.dart';
import 'package:otlopapp/models/product_model.dart';
import 'package:otlopapp/product_details_body.dart';

class ScrollableDetailsBody extends StatelessWidget {
  const ScrollableDetailsBody({super.key, required this.product});
  final ProductModel product;

  @override
  Widget build(BuildContext context) => SliverToBoxAdapter(
    child: Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
      child: ProductDetailsBody(product: product),
    ),
  );
}
