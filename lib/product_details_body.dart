import 'package:flutter/material.dart';
import 'package:otlopapp/core/widgets/product_image.dart';
import 'package:otlopapp/models/product_model.dart';

class ProductDetailsBody extends StatelessWidget {
  const ProductDetailsBody({super.key, required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          product.title ?? '',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),

        // Rating and Order Count Row
        Row(
          children: [
            Image.asset('assets/icons/star.png', width: 20, height: 20),
            const SizedBox(width: 6),
            Text(
              product.rating?.toString() ?? '',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
            const SizedBox(width: 30),
            Image.asset('assets/icons/shopping-bag.png', width: 20, height: 20),
            const SizedBox(width: 6),
            Text(
              product.stock?.toString() ?? '',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // Description
        Text(
          product.description ?? '',
          style: TextStyle(fontSize: 16, height: 1.5, color: Colors.black87),
        ),
        if (product.images?.isNotEmpty ?? false) ...[
          const SizedBox(height: 20),
          SizedBox(
            height: 96,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: product.images!.length,
              separatorBuilder: (_, _) => const SizedBox(width: 10),
              itemBuilder: (context, index) {
                return ProductImage(
                  imageUrl: product.images![index],
                  width: 96,
                  height: 96,
                  borderRadius: BorderRadius.circular(10),
                );
              },
            ),
          ),
        ],
        const SizedBox(height: 40),
      ],
    );
  }
}
