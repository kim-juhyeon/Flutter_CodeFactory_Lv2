import 'package:delivery_app/common/provider/pagination_provider.dart';
import 'package:delivery_app/product/model/product_model.dart';
import 'package:delivery_app/product/repository/product_repository.dart';

class ProductStateNotifier extends PaginationProvider<ProductModel, ProductRepository>{
  ProductStateNotifier({
    required super.repository
});

}