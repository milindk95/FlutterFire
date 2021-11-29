import 'package:flutter/material.dart';
import 'package:the_super11/core/preferences.dart';
import 'package:the_super11/models/models.dart';

class UserInfo with ChangeNotifier {
  late User _user;

  void setLoggedUserInfo(User user) {
    this._user = user;
  }

  void updateLoggedUserInfo(User user) {
    _user = _user.copyWith(
      name: user.name,
      birthDate: user.birthDate,
      gender: user.gender,
      address: user.address,
      city: user.city,
      state: user.state,
      zip: user.zip,
      winningAmount: user.winningAmount,
      avatar: user.avatar,
      realAmount: user.realAmount,
      validEmail: user.validEmail ? true : null,
    );
    notifyListeners();
  }

  void updateValidEmail() {
    _user.copyWith(validEmail: true);
    notifyListeners();
  }

  Future<void> updateAmounts({
    double? depositAmount,
    double? bonusAmount,
    double? winningAmount,
  }) async {
    _user = _user.copyWith(
      realAmount: depositAmount,
      redeemAmount: bonusAmount,
      winningAmount: winningAmount,
    );
    await Preference.setUserData(_user);
    notifyListeners();
  }

  User get user => _user;
}
