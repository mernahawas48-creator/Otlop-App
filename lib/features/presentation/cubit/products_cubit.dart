import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:otlopapp/models/product_model.dart';

part 'products_state.dart';

class ProductsCubit extends Cubit<ProductsState> {
  List<ProductModel> products = [];

  ProductsCubit() : super(ProductsInitial());

  getAllProducts() async {
    try {
      emit(ProductsLoading());
      Response response = await Dio().get('https://dummyjson.com/products');
      response.data['products'].forEach((product) {
        products.add(ProductModel.fromJson(product));
      });
      print('Products: ${products.length}');
      print('Product details:');
      emit(ProductsSucess(products: products));
    } on DioException catch (e) {
      emit(ProductsFailure(errorMessage: e.message ?? 'An error has occurred'));
      // TODO
    }
  }
}
