import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:otlopapp/core/widgets/product_image.dart';
import 'package:otlopapp/models/product_model.dart';

class ProductDetailsBody extends StatelessWidget {
  const ProductDetailsBody({super.key, required this.product});
  final ProductModel product;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        product.title ?? 'common.product'.tr(),
        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 12),
      Text(
        product.price == null
            ? 'common.price_unavailable'.tr()
            : '\$${product.price!.toStringAsFixed(2)}',
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Color(0xffD61355),
        ),
      ),
      const SizedBox(height: 16),
      Wrap(
        spacing: 24,
        runSpacing: 12,
        children: [
          if (product.rating != null)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.star_rounded, color: Colors.amber),
                const SizedBox(width: 6),
                Text('${product.rating}'),
              ],
            ),
          if (product.stock != null)
            Text(
              'details.in_stock'.tr(
                namedArgs: {'count': product.stock.toString()},
              ),
            ),
        ],
      ),
      const SizedBox(height: 20),
      Text(
        product.description ?? '',
        style: const TextStyle(
          fontSize: 16,
          height: 1.6,
          color: Colors.black87,
        ),
      ),
      if (product.images?.isNotEmpty ?? false) ...[
        const SizedBox(height: 24),
        SizedBox(
          height: 112,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: product.images!.length,
            separatorBuilder: (_, _) => const SizedBox(width: 12),
            itemBuilder: (context, index) => ProductImage(
              imageUrl: product.images![index],
              width: 112,
              height: 112,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ],
    ],
  );
}
