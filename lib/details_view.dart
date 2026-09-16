import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:otlopapp/core/widgets/product_image.dart';
import 'package:otlopapp/features/cart/cart_cubit.dart';
import 'package:otlopapp/models/product_model.dart';
import 'package:otlopapp/scrollable_details_body.dart';

class ProductDetailsView extends StatelessWidget {
  static const routeName = '/productDetails';
  const ProductDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    final product = ModalRoute.of(context)!.settings.arguments as ProductModel;
    final image =
        (product.images ?? const <String>[])
            .where((url) => url.trim().isNotEmpty)
            .firstOrNull ??
        product.thumbnail;
    final imageHeight = (MediaQuery.sizeOf(context).height * .45).clamp(
      280.0,
      440.0,
    );
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.transparent,
            expandedHeight: imageHeight,
            leading: Padding(
              padding: const EdgeInsets.all(6),
              child: IconButton.filled(
                tooltip: 'Back',
                style: IconButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xffD61355),
                ),
                onPressed: () => Navigator.maybePop(context),
                icon: const Icon(Icons.arrow_back),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.pin,
              background: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 56, 24, 16),
                  child: ProductImage(
                    imageUrl: image,
                    fallbackUrl: product.thumbnail,
                    width: double.infinity,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),
          ScrollableDetailsBody(product: product),
        ],
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        minimum: const EdgeInsets.fromLTRB(20, 12, 20, 12),
        child: FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: const Color(0xffD61355),
            padding: const EdgeInsets.all(16),
          ),
          onPressed: product.price == null
              ? null
              : () {
                  context.read<CartCubit>().addProduct(product);
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                      const SnackBar(
                        content: Text('Added to cart'),
                        duration: Duration(seconds: 1),
                      ),
                    );
                },
          child: const Text(
            'Add to Cart',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
