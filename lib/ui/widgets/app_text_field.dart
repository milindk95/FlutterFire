import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTextField extends StatefulWidget {
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? hintText;
  final ValueChanged<String>? onFieldSubmitted;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String>? validator;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final int maxLength;
  final Formatters formatters;
  final bool? enabled;
  final TextCapitalization textCapitalization;
  final bool dropDown;

  const AppTextField({
    Key? key,
    this.controller,
    this.focusNode,
    this.hintText,
    this.onFieldSubmitted,
    this.onChanged,
    this.validator,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction,
    this.maxLength = 50,
    this.formatters = Formatters.acceptNumbersAndCharacters,
    this.enabled,
    this.textCapitalization = TextCapitalization.none,
    this.dropDown = false,
  }) : super(key: key);

  @override
  _AppTextFieldState createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  bool _obscureText = false;
  final List<TextInputFormatter> _inputFormatters = [];

  @override
  void initState() {
    super.initState();
    if (widget.obscureText) _obscureText = true;
    switch (widget.formatters) {
      case Formatters.acceptAll:
        break;
      case Formatters.acceptNumbers:
        _inputFormatters.add(FilteringTextInputFormatter.allow(RegExp("[0-9]")));
        break;
      case Formatters.acceptCharacters:
        _inputFormatters
            .add(FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]")));
        break;
      case Formatters.acceptCharactersAndSpace:
        _inputFormatters
            .add(FilteringTextInputFormatter.allow(RegExp("[a-zA-Z ]")));
        break;
      case Formatters.acceptNumbersAndCharacters:
        _inputFormatters
            .add(FilteringTextInputFormatter.allow(RegExp("[a-zA-Z0-9]")));
        break;
      case Formatters.acceptEmailFormat:
        _inputFormatters
            .add(FilteringTextInputFormatter.allow(RegExp("[a-zA-Z0-9@.]")));
        break;
      case Formatters.acceptUPIFormat:
        _inputFormatters
            .add(FilteringTextInputFormatter.allow(RegExp("[a-zA-Z0-9@]")));
        break;
      case Formatters.acceptSpace:
        _inputFormatters.add(FilteringTextInputFormatter.allow(RegExp("[0-9]")));
        break;
      case Formatters.acceptWithoutEmojis:
        _inputFormatters.add(FilteringTextInputFormatter.deny(RegExp(
            '(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])')));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        TextFormField(
          controller: widget.controller,
          focusNode: widget.focusNode,
          onFieldSubmitted: widget.onFieldSubmitted,
          onChanged: widget.onChanged,
          validator: widget.validator,
          obscureText: _obscureText,
          keyboardType: widget.keyboardType,
          textInputAction: widget.textInputAction,
          maxLength: widget.maxLength,
          enabled: widget.enabled,
          textCapitalization: widget.textCapitalization,
          inputFormatters: _inputFormatters,
          style: TextStyle(fontSize: 16),
          decoration: InputDecoration(
            hintText: widget.hintText,
            labelText: widget.hintText,
            counterText: "",
            suffixIcon:
                widget.dropDown ? Icon(Icons.keyboard_arrow_down) : null,
          ),
        ),
        if (widget.obscureText)
          Positioned(
            right: 0,
            top: 14,
            child: InkWell(
              canRequestFocus: false,
              borderRadius: BorderRadius.circular(50),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Icon(
                  _obscureText
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  size: 24,
                ),
              ),
              onTap: () => setState(() => _obscureText = !_obscureText),
            ),
          )
      ],
    );
  }
}

enum Formatters {
  acceptAll,
  acceptNumbers,
  acceptCharacters,
  acceptCharactersAndSpace,
  acceptNumbersAndCharacters,
  acceptEmailFormat,
  acceptUPIFormat,
  acceptSpace,
  acceptWithoutEmojis
}
