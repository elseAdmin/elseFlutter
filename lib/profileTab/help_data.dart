class HelpData {
  String _title, _body;
  bool _expanded;

  HelpData(this._title, this._body, this._expanded);

  @override
  String toString() {
    return 'HelpData{_title: $_title, _body: $_body, _expanded: $_expanded}';
  }

  bool get expanded => _expanded;

  set expanded(bool value) {
    _expanded = value;
  }

  get body => _body;

  set body(value) {
    _body = value;
  }

  String get title => _title;

  set title(String value) {
    _title = value;
  }
}

class HelpDataList {

  List<HelpData> helpDataList = [
    new HelpData('Want to request something regarding your help and faq', 'Requesting something to mall is simple', false),
    new HelpData('Want to request something', 'Requesting something to mall is simple', false),
    new HelpData('Want to request something', 'Requesting something to mall is simple', false),
    new HelpData('Want to request something', 'Requesting something to mall is simple', false),
    new HelpData('Want to request something', 'Requesting something to mall is simple', false)
    ];

  List<HelpData> getHelpData(){
    return helpDataList;
  }

  HelpDataList();
}