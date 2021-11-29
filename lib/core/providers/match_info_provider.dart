import 'package:the_super11/models/models.dart';

class MatchInfo {
  late MyMatch _match;

  void setMatchInfo(MyMatch match) => this._match = match;

  MyMatch get match => _match;
}
