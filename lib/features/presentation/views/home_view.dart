import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:otlopapp/core/widgets/product_image.dart';
import 'package:otlopapp/details_view.dart';
import 'package:otlopapp/features/cart/cart_cubit.dart';
import 'package:otlopapp/features/presentation/cubit/products_cubit.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.white,
    body: SafeArea(
      bottom: false,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Text(
              'home.market'.tr(),
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: BlocBuilder<ProductsCubit, ProductsState>(
              builder: (context, state) {
                if (state is ProductsFailure) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(state.errorMessage, textAlign: TextAlign.center),
                          TextButton(
                            onPressed: () =>
                                context.read<ProductsCubit>().getAllProducts(),
                            child: Text('common.retry'.tr()),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                if (state is! ProductsSucess) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state.products.isEmpty) {
                  return Center(child: Text('home.no_products'.tr()));
                }
                return LayoutBuilder(
                  builder: (context, constraints) {
                    final columns = constraints.maxWidth < 340
                        ? 1
                        : (constraints.maxWidth / 180).floor().clamp(2, 4);
                    final scale =
                        MediaQuery.textScalerOf(context).scale(14) / 14;
                    return GridView.builder(
                      key: const PageStorageKey('market-grid'),
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      itemCount: state.products.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: columns,
                        mainAxisExtent: 286 + (scale - 1).clamp(0, 3) * 110,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 16,
                      ),
                      itemBuilder: (context, index) {
                        final product = state.products[index];
                        return Card(
                          margin: EdgeInsets.zero,
                          color: Colors.white,
                          surfaceTintColor: Colors.transparent,
                          elevation: 2,
                          shadowColor: Colors.black12,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: InkWell(
                            onTap: () => Navigator.pushNamed(
                              context,
                              ProductDetailsView.routeName,
                              arguments: product,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                children: [
                                  Expanded(
                                    child: ProductImage(
                                      imageUrl: product.thumbnail,
                                      width: double.infinity,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  SizedBox(
                                    height: 40 * scale,
                                    child: Center(
                                      child: Text(
                                        product.title ?? 'common.product'.tr(),
                                        textAlign: TextAlign.center,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    product.price == null
                                        ? 'common.price_unavailable'.tr()
                                        : '\$${product.price!.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      color: Color(0xffD61355),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  SizedBox(
                                    width: double.infinity,
                                    child: FilledButton(
                                      style: FilledButton.styleFrom(
                                        backgroundColor: const Color(
                                          0xffE50046,
                                        ),
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 6,
                                          vertical: 10,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                      ),
                                      onPressed: product.price == null
                                          ? null
                                          : () {
                                              context
                                                  .read<CartCubit>()
                                                  .addProduct(product);
                                              ScaffoldMessenger.of(context)
                                                ..hideCurrentSnackBar()
                                                ..showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                      'home.added_to_cart'.tr(
                                                        namedArgs: {
                                                          'product':
                                                              product.title ??
                                                              'common.product'
                                                                  .tr(),
                                                        },
                                                      ),
                                                    ),
                                                    duration: const Duration(
                                                      seconds: 1,
                                                    ),
                                                  ),
                                                );
                                            },
                                      child: Text(
                                        'home.add_to_cart'.tr(),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    ),
  );
}
