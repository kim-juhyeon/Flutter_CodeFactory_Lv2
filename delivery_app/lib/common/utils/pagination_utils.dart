import 'package:delivery_app/common/provider/pagination_provider.dart';
import 'package:flutter/cupertino.dart';

class PaginationUtils {
  static void paginate({
    required ScrollController controller,
    required PaginationProvider provider,
}) {
    if (controller.offset > controller.position.maxScrollExtent - 300) {
      provider.paginate(
            fetchMore:
                true, //초기 fetchMore은 false였고, scrollController를 통해 true 값으로 데이터를 가져온다.
          );
    }
  }
}
