import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

extension CommonUtils on BuildContext {
  bool get isKeyboardVisible => MediaQuery.of(this).viewInsets.bottom != 0;

  double bottomPadding(double padding) =>
      MediaQuery.of(this).padding.bottom != 0
          ? MediaQuery.of(this).padding.bottom
          : padding;

  double topPadding(double padding) =>
      MediaQuery.of(this).padding.top != 0
          ? MediaQuery.of(this).padding.top
          : padding;
}

extension ValidationUtils on String {
  bool get isValidEmail => RegExp(
          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
      .hasMatch(this);

  bool get isValidMobileNo => _isValidMobileNumber();

  bool _isValidMobileNumber() {
    try {
      if (this.length == 10 && int.tryParse(this) != null) return true;
      return false;
    } catch (e) {
      return false;
    }
  }

  bool get isValidPassword => this.length >= 6;

  bool get isValidPANCardNumber =>
      RegExp(r'^[a-zA-Z]{5}[0-9]{4}[a-zA-Z]{1}').hasMatch(this);

  bool get isValidBankAccountNumber => RegExp(r'^\d{9,18}$').hasMatch(this);

  bool get isValidIFSC => RegExp(r'^([A-Za-z0]{4})(0\d{6})$').hasMatch(this);

  bool get isValidUPIAddress => RegExp(r'^[\w.-]+@[A-Za-z]+$').hasMatch(this);
}

extension StringUtils on String {
  String get capitalize {
    try {
      return '${this[0].toUpperCase()}${this.substring(1)}';
    } catch (e) {
      return '';
    }
  }

  String get playerShortName {
    try {
      if (this.isNotEmpty)
        return '${this.trim().split(' ').first[0]} ${this.split(' ').last.capitalize}';
      return '';
    } catch (e) {
      return '';
    }
  }
}

extension ColorUtils on String {
  Color getHexColor({Color defaultColor = Colors.white}) {
    try {
      String hexColor = this.toUpperCase().replaceAll("#", "");
      if (hexColor.length == 6) hexColor = "FF" + hexColor;
      return Color(int.parse(hexColor, radix: 16));
    } catch (e) {
      return defaultColor;
    }
  }
}

extension Alerts on BuildContext {
  Future<bool?> showConfirmation({
    String? title,
    required String message,
    String positiveText = 'OK',
    String negativeText = 'Cancel',
    VoidCallback? positiveAction,
    VoidCallback? negativeAction,
  }) =>
      showCupertinoDialog<bool>(
        context: this,
        builder: (context) => CupertinoAlertDialog(
          title: title != null ? Text(title) : null,
          content: Text(
            message,
            style: TextStyle(fontSize: 14),
          ),
          actions: [
            CupertinoDialogAction(
              child: Text(positiveText),
              onPressed: () {
                Navigator.of(context).pop();
                positiveAction?.call();
              },
              isDefaultAction: true,
            ),
            CupertinoDialogAction(
              child: Text(negativeText),
              onPressed: () {
                Navigator.of(context).pop();
                negativeAction?.call();
              },
              isDestructiveAction: true,
            )
          ],
        ),
      );

  Future<bool?> showAlert({
    String? title,
    required String message,
    VoidCallback? action,
  }) =>
      showCupertinoDialog<bool>(
        context: this,
        builder: (context) => CupertinoAlertDialog(
          title: title != null ? Text(title) : null,
          content: Text(
            message,
            style: TextStyle(fontSize: 14),
          ),
          actions: [
            CupertinoDialogAction(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                action?.call();
              },
              isDefaultAction: true,
            )
          ],
        ),
      );
}

extension DatePicker on BuildContext {
  void showDatePicker({
    required String title,
    required ValueChanged<DateTime> onDateTimeChanged,
    required DateTime? initialDate,
    DateTime? maximumDate,
  }) {
    final currentDate = DateTime.now();
    final initialDateTime = initialDate ??
        DateTime(currentDate.year, currentDate.month, currentDate.day);
    DateTime selectedDateTime = initialDateTime;
    _showCupertinoPopUp(
      context: this,
      title: title,
      child: CupertinoDatePicker(
        onDateTimeChanged: (dateTime) => selectedDateTime = dateTime,
        mode: CupertinoDatePickerMode.date,
        maximumDate: maximumDate ?? DateTime.now(),
        initialDateTime: initialDateTime,
        minimumDate: DateTime(1900),
      ),
      onChanged: () => onDateTimeChanged.call(selectedDateTime),
    );
  }
}

extension ValuePicker on BuildContext {
  void showValuePicker<T>({
    required String title,
    required List<T> items,
    required ValueChanged<T> onValueChanged,
    int initialItem = 0,
  }) {
    T selectedItem = items[initialItem >= 0 ? initialItem : 0];
    _showCupertinoPopUp(
      context: this,
      title: title,
      child: CupertinoPicker(
        scrollController: FixedExtentScrollController(initialItem: initialItem),
        children: List.generate(
          items.length,
          (i) => Center(
            child: Text(
              '${items[i]}',
              maxLines: 1,
            ),
          ),
        ),
        onSelectedItemChanged: (i) => selectedItem = items[i],
        itemExtent: 36,
      ),
      onChanged: () => onValueChanged.call(selectedItem),
    );
  }
}

void _showCupertinoPopUp({
  required BuildContext context,
  required String title,
  required Widget child,
  required Function onChanged,
}) {
  showCupertinoModalPopup(
    context: context,
    builder: (context) => Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          color: Theme.of(context).colorScheme.secondary,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CupertinoButton(
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () => Navigator.of(context).pop(),
                padding: EdgeInsets.all(8),
              ),
              Material(
                color: Colors.transparent,
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              CupertinoButton(
                child: Text(
                  'Done',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () {
                  onChanged.call();
                  Navigator.of(context).pop();
                },
                padding: EdgeInsets.all(8),
              )
            ],
          ),
        ),
        Divider(
          height: 0,
        ),
        Container(
          height: MediaQuery.of(context).size.height * 0.3,
          color: Theme.of(context).colorScheme.secondary,
          child: CupertinoTheme(
            data: CupertinoThemeData(
              brightness: Theme.of(context).brightness == Brightness.dark
                  ? Brightness.dark
                  : Brightness.light,
            ),
            child: child,
          ),
        ),
      ],
    ),
  );
}

extension RankPicker on BuildContext {
  void showRankPicker<T>({
    required String title,
    required List<T> items,
    required int startRank,
    required ValueChanged<T> onValueChanged,
    int initialIndex = 0,
  }) {
    T selectedItem = items[initialIndex];
    _showRankPopUp(
      context: this,
      title: title,
      startRank: startRank,
      child: CupertinoPicker(
        scrollController:
            FixedExtentScrollController(initialItem: initialIndex),
        children: List.generate(
          items.length,
          (i) => Center(
            child: Text(
              '${items[i]}',
              maxLines: 1,
            ),
          ),
        ),
        onSelectedItemChanged: (i) => selectedItem = items[i],
        itemExtent: 36,
      ),
      onChanged: () => onValueChanged.call(selectedItem),
    );
  }
}

void _showRankPopUp({
  required BuildContext context,
  required String title,
  required Widget child,
  required int startRank,
  required Function onChanged,
}) {
  showCupertinoModalPopup(
    context: context,
    builder: (context) => Material(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            color: Theme.of(context).colorScheme.secondary,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CupertinoButton(
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                  padding: EdgeInsets.all(8),
                ),
                Material(
                  color: Colors.transparent,
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                CupertinoButton(
                  child: Text(
                    'Done',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () {
                    onChanged.call();
                    Navigator.of(context).pop();
                  },
                  padding: EdgeInsets.all(8),
                )
              ],
            ),
          ),
          Divider(
            height: 0,
          ),
          Row(
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '$startRank',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    Text(
                      'to',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.3,
                  color: Theme.of(context).colorScheme.secondary,
                  child: CupertinoTheme(
                    data: CupertinoThemeData(
                      brightness:
                          Theme.of(context).brightness == Brightness.dark
                              ? Brightness.dark
                              : Brightness.light,
                    ),
                    child: child,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
