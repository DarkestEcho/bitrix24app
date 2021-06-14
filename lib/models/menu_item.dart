class MenuItem {
  final String _itemText;
  final String _itemIcon;
  final int _selected;
  final int _position;

  MenuItem(
      {required String itemIcon,
      required String itemText,
      required int selected,
      required int position})
      : this._itemIcon = itemIcon,
        this._itemText = itemText,
        this._selected = selected,
        this._position = position;

  String get itemText => _itemText;
  String get itemIcon => _itemIcon;
  int get selected => _selected;
  int get position => _position;
}
