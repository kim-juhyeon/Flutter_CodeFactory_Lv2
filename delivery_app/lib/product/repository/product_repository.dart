import 'package:delivery_app/common/dio/dio.dart';
import 'package:delivery_app/common/model/pagination_params.dart';
import 'package:delivery_app/common/repository/base_pagination_repository.dart';
import 'package:delivery_app/product/model/product_model.dart';
import 'package:dio/dio.dart' hide Header;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retrofit/http.dart';

import '../../common/model/cursor_pagination_model.dart';
part 'product_model.g.dart';
//repository를 provider에 넣어야 함
final productRepositoryProvider = Provider<ProductRepository>(
    (ref) {
      final dio = ref.watch(dioProvider);
      return ProductRepository(dio, baseUrl: 'http://$ip/product');
    }
);


@RestApi()
abstract class ProductRepository implements IBasePaginationRepository<ProductModel>{
  factory ProductRepository(Dio dio, {String baseUrl}) =
      _ProductRepository;

  @GET('/')
  @Headers({'accessToken' : 'true'})
  Future<CursorPagination<ProductModel>> paginate({
    @Queries() PaginationParams? paginationParams = const PaginationParams(),
})
}