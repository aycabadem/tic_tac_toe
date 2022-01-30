import 'dart:math';

enum TileState { EMPTY, CROSS, CIRCLE }

List<List<TileState>> chunk(List<TileState> list, int size) {
  // final List<List<TileState>> _myList = [];
  // _myList.add(list.sublist(0, 3));
  // _myList.add(list.sublist(3, 6));
  // _myList.add(list.sublist(6, 9));
  // return _myList;
  return List.generate(
      (list.length / size).ceil(),
      (index) =>
          list.sublist(index * size, min(index * size + size, list.length)));
}
