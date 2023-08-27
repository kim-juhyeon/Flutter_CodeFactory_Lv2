//api에서 id값이 진짜로 있는지 없는지 확인할 수 없기 때문에 따로 id 함수를 정의합니다.
abstract class IModelWithId {
  final String id;

  IModelWithId({
    required this.id,
  });
}
