import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:otlopapp/core/widgets/product_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:otlopapp/features/cart/cart_cubit.dart';
import 'package:otlopapp/features/cart/cart_state.dart';

class CartView extends StatelessWidget {
  const CartView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('cart.my_cart'.tr()), centerTitle: true),

      body: BlocBuilder<CartCubit, CartState>(
        builder: (context, state) {
          if (state.items.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,

                children: [
                  const Icon(
                    Icons.shopping_cart_outlined,
                    size: 80,
                    color: Colors.grey,
                  ),

                  const SizedBox(height: 16),

                  Text(
                    'cart.empty'.tr(),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: state.items.length,

                  itemBuilder: (context, index) {
                    final item = state.items[index];

                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),

                      child: Padding(
                        padding: const EdgeInsets.all(10),

                        child: Row(
                          children: [
                            ProductImage(
                              imageUrl: item.product.thumbnail,

                              width: 80,
                              height: 80,

                              fit: BoxFit.contain,
                            ),

                            const SizedBox(width: 12),

                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,

                                children: [
                                  Text(
                                    item.product.title ?? '',

                                    maxLines: 2,

                                    overflow: TextOverflow.ellipsis,

                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),

                                  const SizedBox(height: 5),

                                  Text(
                                    '\$${item.product.price ?? 0}',

                                    style: const TextStyle(
                                      color: Color(0xFFE50046),

                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),

                                  const SizedBox(height: 8),

                                  Row(
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          context
                                              .read<CartCubit>()
                                              .decreaseQuantity(item.product);
                                        },

                                        icon: const Icon(Icons.remove),
                                      ),

                                      Text(
                                        '${item.quantity}',

                                        style: const TextStyle(
                                          fontSize: 16,

                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),

                                      IconButton(
                                        onPressed: () {
                                          context
                                              .read<CartCubit>()
                                              .increaseQuantity(item.product);
                                        },

                                        icon: const Icon(Icons.add),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            IconButton(
                              onPressed: () {
                                context.read<CartCubit>().removeProduct(
                                  item.product,
                                );
                              },

                              icon: const Icon(
                                Icons.delete_outline,

                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              Container(
                padding: const EdgeInsets.all(20),

                decoration: BoxDecoration(
                  color: Colors.white,

                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),

                      blurRadius: 10,
                    ),
                  ],
                ),

                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,

                      children: [
                        Text(
                          'cart.total'.tr(),

                          style: const TextStyle(
                            fontSize: 18,

                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        Text(
                          '\$${state.totalPrice.toStringAsFixed(2)}',

                          style: const TextStyle(
                            fontSize: 20,

                            fontWeight: FontWeight.bold,

                            color: Color(0xFFE50046),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 15),

                    SizedBox(
                      width: double.infinity,
                      height: 50,

                      child: ElevatedButton(
                        onPressed: () {
                          showDialog(
                            context: context,

                            builder: (_) => AlertDialog(
                              title: Text('cart.checkout'.tr()),

                              content: Text(
                                'cart.total_payment'.tr(
                                  namedArgs: {
                                    'amount':
                                        '\$${state.totalPrice.toStringAsFixed(2)}',
                                  },
                                ),
                              ),

                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },

                                  child: Text('common.cancel'.tr()),
                                ),

                                ElevatedButton(
                                  onPressed: () {
                                    context.read<CartCubit>().clearCart();

                                    Navigator.pop(context);

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'cart.completed'.tr(),
                                        ),
                                      ),
                                    );
                                  },

                                  child: Text('cart.pay'.tr()),
                                ),
                              ],
                            ),
                          );
                        },

                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE50046),

                          foregroundColor: Colors.white,
                        ),

                        child: Text('cart.proceed_to_checkout'.tr()),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
