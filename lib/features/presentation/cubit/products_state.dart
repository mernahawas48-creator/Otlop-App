part of 'products_cubit.dart';

@immutable
sealed class ProductsState {}

final class ProductsInitial extends ProductsState {}

final class ProductsLoading extends ProductsState {}

final class ProductsSucess extends ProductsState {
  final List<ProductModel> products;
  ProductsSucess({required this.products});
}

final class ProductsFailure extends ProductsState {
  final String errorMessage;
  ProductsFailure({required this.errorMessage});
}
