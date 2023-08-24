import 'package:json_annotation/json_annotation.dart';

import '../../restaurant/model/restaurant_model.dart';

part 'cursor_pagination_model.g.dart';

abstract class CursorPaginationBase {}

class CursorPaginationError extends CursorPaginationBase {
  final String message;

  CursorPaginationError({
    required this.message,
  });
}

class CursorPaginationLoding extends CursorPaginationBase {}

@JsonSerializable(
  genericArgumentFactories: true, //제너릭을 고려한 코드를 생성하게 합니다.
)
//api 데이터를 보면 meta,data로 리스트가 형성되어 있습니다.
// 하지만,data값에 있는 변수들은 주문,상세페이지,pagination값에 따라 바뀌므로 cursorPagination<T> 제너레이션으로 받아서 바꿀 수 있게 변경합니다.

class CursorPagination<T> extends CursorPaginationBase {
  final CursorPaginationMeta meta;
  final List<T> data;

  CursorPagination({
    required this.meta,
    required this.data,
  });

  CursorPagination copyWith({
    CursorPaginationMeta? meta,
    List<T>? data,
  }) {
    return CursorPagination(
      meta: meta ?? this.meta,
      data: data ?? this.data,
    );
  }

  factory CursorPagination.fromJson(Map<String, dynamic> json,
      T Function(Object? json) fromJsonT) =>
      _$CursorPaginationFromJson(json, fromJsonT);
}

@JsonSerializable()
class CursorPaginationMeta {
  final int count;
  final bool hasMore;

  CursorPaginationMeta({
    required this.count,
    required this.hasMore,
  });

  CursorPaginationMeta copywith({
    int? count,
    bool? hasMore,
  }) {
    return CursorPaginationMeta(
      count: count ?? this.count, hasMore: hasMore ?? this.hasMore,);
  }

  factory CursorPaginationMeta.fromJson(Map<String, dynamic> json) =>
      _$CursorPaginationMetaFromJson(json);
}

//새로고침
class CursorPaginationRefetching<T> extends CursorPagination<T> {
  CursorPaginationRefetching({required super.meta, required super.data});
}

// 리스트의 맨 아래로 내려서
// 추가 데이터를 요청하는 중
class CursorPaginationFetchingMore<T> extends CursorPagination<T> {
  CursorPaginationFetchingMore({
    required super.meta,
    required super.data,
  });
}
