import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_fire/blocs/auth/sign_up_verification/sign_up_verification_bloc.dart';
import 'package:flutter_fire/blocs/profile/verification/email_verification/email_verification_bloc.dart';
import 'package:flutter_fire/blocs/profile/verification/send_email_otp/send_email_otp_bloc.dart';
import 'package:flutter_fire/core/extensions.dart';
import 'package:flutter_fire/core/providers/user_info_provider.dart';
import 'package:flutter_fire/ui/resources/resources.dart';
import 'package:flutter_fire/ui/widgets/widgets.dart';

class EmailVerificationScreen extends StatefulWidget {
  static const route = '/email-verification';

  const EmailVerificationScreen({Key? key}) : super(key: key);

  @override
  _EmailVerificationScreenState createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  final _otpCtrl = TextEditingController();

  void _backConfirmation() => context.showConfirmation(
        title: 'Confirmation',
        message: 'Are you sure to go to back?',
        positiveAction: () => Navigator.of(context).pop(),
      );

  @override
  Widget build(BuildContext context) {
    return UIBlocker(
      block: BlocProvider.of<EmailVerificationBloc>(context, listen: true).state
          is EmailVerificationInProgress,
      onBack: _backConfirmation,
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
              BlocBuilder<SendEmailOtpBloc, SendEmailOtpState>(
                builder: (context, state) {
                  if (state is SendEmailOtpSuccess)
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: _verificationView(),
                    );
                  else if (state is SendEmailOtpFailure)
                    return ErrorView(error: state.error);
                  return LoadingIndicator();
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _verificationView() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Verify your email',
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
            '"${context.read<UserInfo>().user.email}"',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 30,
          ),
          Center(
            child: Image.asset(
              icEmail,
              width: 100,
            ),
          ),
          Center(
            child: Text(
              'Check your email inbox',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(
            height: 20,
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
      );

  Widget _verifyButton() =>
      BlocConsumer<EmailVerificationBloc, EmailVerificationState>(
        listener: (context, state) {
          if (state is EmailVerificationSuccess) {
            showTopSnackBar(
                context, CustomSnackBar.success(message: state.message));
            context.read<UserInfo>().updateValidEmail();
            Navigator.of(context).pop();
          } else if (state is EmailVerificationFailure)
            showTopSnackBar(
                context, CustomSnackBar.error(message: state.error));
        },
        builder: (context, state) {
          return SubmitButton(
            label: 'Verify',
            onPressed: () => context
                .read<EmailVerificationBloc>()
                .add(VerifyEmail(int.parse(_otpCtrl.text))),
            progress: state is SignUpVerificationInProgress,
          );
        },
      );
}
