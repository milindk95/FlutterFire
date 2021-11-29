import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class AppOTPTextField extends StatefulWidget {
  final TextEditingController? controller;
  final VoidCallback validValueCallback;

  const AppOTPTextField({
    Key? key,
    this.controller,
    required this.validValueCallback,
  }) : super(key: key);

  @override
  _AppOTPTextFieldState createState() => _AppOTPTextFieldState();
}

class _AppOTPTextFieldState extends State<AppOTPTextField> {
  @override
  Widget build(BuildContext context) {
    return PinCodeTextField(
      appContext: context,
      controller: widget.controller,
      length: 6,
      onChanged: (value) {
        if (value.length > 4) widget.validValueCallback.call();
      },
      keyboardType: TextInputType.numberWithOptions(signed: false),
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp("[0-9]"))],
      cursorColor: Theme.of(context).primaryColor,
      textStyle: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      pinTheme: PinTheme(
        activeColor:
            Theme.of(context).colorScheme.secondaryVariant.withAlpha(100),
        inactiveColor: Theme.of(context).colorScheme.primaryVariant,
        selectedColor: Theme.of(context).primaryColor,
      ),
    );
  }
}
