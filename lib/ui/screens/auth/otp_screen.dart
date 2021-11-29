import 'package:flutter/material.dart';
import 'package:the_super11/core/extensions.dart';
import 'package:the_super11/ui/screens/auth/new_password_screen.dart';
import 'package:the_super11/ui/widgets/submit_button.dart';
import 'package:the_super11/ui/widgets/widgets.dart';

class OTPScreenData {
  final String mobileNoOrEmail;
  final String userId;
  final String forgotPasswordId;

  OTPScreenData({
    required this.mobileNoOrEmail,
    required this.userId,
    required this.forgotPasswordId,
  });
}

class OTPScreen extends StatefulWidget {
  static const route = '/otp';
  final OTPScreenData data;

  const OTPScreen({Key? key, required this.data}) : super(key: key);

  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final _otpCtrl = TextEditingController();

  void _backConfirmation() => context.showConfirmation(
        title: 'Confirmation',
        message: 'Are you sure to go to back?',
        positiveAction: () => Navigator.of(context).pop(),
      );

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _backConfirmation();
        return false;
      },
      child: Scaffold(
        body: SingleChildScrollView(
          padding:
              EdgeInsets.only(top: MediaQuery.of(context).padding.top, left: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                onPressed: _backConfirmation,
                splashRadius: 22,
                icon: Icon(
                  Icons.arrow_back,
                  size: 24,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Verify OTP',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      'Enter the 6 digits OTP that you received on',
                      style: TextStyle(fontSize: 15),
                    ),
                    Text(
                      '"${widget.data.mobileNoOrEmail}"',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: AppOTPTextField(
                        controller: _otpCtrl,
                        validValueCallback: () => setState(() {}),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    if (_otpCtrl.text.length == 6) _verifyButton()
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _verifyButton() => SubmitButton(
        label: 'Verify',
        onPressed: () {
          Navigator.of(context).pushNamed(
            NewPasswordScreen.route,
            arguments: NewPasswordScreenData(
              widget.data,
              int.parse(_otpCtrl.text),
            ),
          );
        },
      );
}
