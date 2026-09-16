import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:otlopapp/core/widgets/product_image.dart';
import 'package:otlopapp/details_view.dart';
import 'package:otlopapp/features/presentation/cubit/products_cubit.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

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
            if (state.products.isEmpty) {
              return const Center(child: Text('No products available'));
            }

            return GridView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: state.products.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemBuilder: (context, index) {
                final product = state.products[index];

                return Card(
                  clipBehavior: Clip.antiAlias,
                  elevation: 2,
                  child: InkWell(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        ProductDetailsView.routeName,
                        arguments: product,
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        children: [
                          Expanded(
                            child: ProductImage(
                              imageUrl: product.thumbnail,
                              width: double.infinity,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            product.title ?? 'No Title',
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
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
