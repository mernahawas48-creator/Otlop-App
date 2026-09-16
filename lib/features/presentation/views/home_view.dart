// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:otlopapp/details_view.dart';
import 'package:otlopapp/features/presentation/cubit/products_cubit.dart';
import 'package:otlopapp/features/cart/cart_cubit.dart';

// import 'package:otlopapp/models/product_model.dart';

class HomeView extends StatelessWidget {
  HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<ProductsCubit, ProductsState>(
        builder: (context, state) {
          if (state is ProductsLoading) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.blue),
            );
          } else if (state is ProductsFailure) {
            return Center(child: Text(state.errorMessage));
          } else if (state is ProductsSucess) {
            return GridView.builder(
              itemCount: state.products.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
              ),
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.all(8),

                  child: Padding(
                    padding: const EdgeInsets.all(8),

                    child: Column(
                      children: [
                        Expanded(
                          child: Image.network(
                            state.products[index].thumbnail ?? '',
                            fit: BoxFit.contain,
                          ),
                        ),

                        const SizedBox(height: 8),

                        Text(
                          state.products[index].title ?? 'No Title',
                          textAlign: TextAlign.center,

                          maxLines: 2,

                          overflow: TextOverflow.ellipsis,

                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),

                        const SizedBox(height: 5),

                        Text(
                          '\$${state.products[index].price ?? 0}',

                          style: const TextStyle(
                            color: Color(0xFFE50046),
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 8),

                        SizedBox(
                          width: double.infinity,

                          child: ElevatedButton(
                            onPressed: () {
                              context.read<CartCubit>().addProduct(
                                state.products[index],
                              );

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    '${state.products[index].title} added to cart',
                                  ),

                                  duration: const Duration(seconds: 1),
                                ),
                              );
                            },

                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFE50046),

                              foregroundColor: Colors.white,
                            ),

                            child: const Text('Add to Cart'),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }

          // child: ,

          return Container();
        },
      ),
    );
  }
}

// class HomeView extends StatefulWidget {
//   HomeView({super.key});

//   @override
//   State<HomeView> createState() => _HomeViewState();
// }

// class _HomeViewState extends State<HomeView> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: GridView.builder(
//           itemCount: products.length,
//           gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//               crossAxisCount: 2, childAspectRatio: 0.75),
//           itemBuilder: (context, index) {
//             return Card(
//               child: Column(
//                 children: [
//                   Image.network(products[index]['thumbnail']),
//                   Text(
//                     products[index]['title'],
//                     textAlign: TextAlign.center,
//                   ),
//                 ],
//               ),
//             );
//           }),
//     );
//   }

//   getAllProducts() async {
//     Dio dio = Dio();
//     Response response = await dio.get('https://dummyjson.com/products');

//     // response.data['products'].forEach((prdouct) {
//     //   products.add(prdouct);
//     //   setState(() {});
//     // });

//     // response.data['products'].map((product) {
//     //   products.add(product);
//     // }).toList();

//     for (var product in response.data['products']) {
//       products.add(product);
//     }
//     print(products[0]['title']);
//     return products;
//   }
// }
