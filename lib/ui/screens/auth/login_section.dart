part of 'login_sign_up_screen.dart';

class LoginSection extends StatefulWidget {
  final BuildContext screenContext;

  const LoginSection({Key? key, required this.screenContext}) : super(key: key);

  @override
  _LoginSectionState createState() => _LoginSectionState();
}

class _LoginSectionState extends State<LoginSection> {
  final _formKey = GlobalKey<FormState>();
  AutovalidateMode _autoValidateMode = AutovalidateMode.disabled;
  final _mobileNoOrEmailCtrl = TextEditingController(),
      _passwordCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is LoginAuthenticationFailure) {
          if (state.statusCode != 400)
            showTopSnackBar(
              context,
              CustomSnackBar.error(
                message: state.error,
              ),
            );
          else
            Navigator.of(context).pushNamed(
              SignUpVerificationScreen.route,
              arguments: SignUpVerificationData(
                userId: state.userId,
                mobileNoOrEmail: _mobileNoOrEmailCtrl.text,
              ),
            );
        } else if (state is LoginAuthenticationSuccess) {
          context.read<UserInfo>().setLoggedUserInfo(state.user);
          Navigator.of(context)
              .pushNamedAndRemoveUntil(HomeScreen.route, (route) => false);
        }
      },
      builder: (context, state) {
        return UIBlocker(
          block: state is LoginAuthenticating,
          child: _loginForm(),
        );
      },
    );
  }

  Widget _loginForm() => Form(
        key: _formKey,
        autovalidateMode: _autoValidateMode,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Login to your account',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    AppTextField(
                      controller: _mobileNoOrEmailCtrl,
                      hintText: 'Mobile / Email',
                      textInputAction: TextInputAction.next,
                      formatters: Formatters.acceptEmailFormat,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) =>
                          value!.isValidEmail || value.isValidMobileNo
                              ? null
                              : 'Enter valid mobile number / email id',
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    AppTextField(
                      controller: _passwordCtrl,
                      hintText: 'Password',
                      obscureText: true,
                      formatters: Formatters.acceptWithoutEmojis,
                      onFieldSubmitted: (_) => _login(),
                      validator: (value) =>
                          value!.isValidPassword ? null : passwordError,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: _forgotPassword,
                        child: Text('Forgot Password?'),
                      ),
                    )
                  ],
                ),
              ),
            ),
            if (!widget.screenContext.isKeyboardVisible)
              AuthButton(
                progress:
                    context.read<LoginBloc>().state is LoginAuthenticating,
                onPressed: _login,
              )
          ],
        ),
      );

  void _login() {
    if (_formKey.currentState!.validate())
      context.read<LoginBloc>().add(_mobileNoOrEmailCtrl.text.isValidEmail
          ? LoginWithEmailAndPassword(
              _mobileNoOrEmailCtrl.text.trim(), _passwordCtrl.text)
          : LoginWithMobileNoAndPassword(
              _mobileNoOrEmailCtrl.text.trim(), _passwordCtrl.text));
    else
      setState(() => _autoValidateMode = AutovalidateMode.onUserInteraction);
  }

  void _forgotPassword() {
    Navigator.of(context).pushNamed(
      ForgotPasswordScreen.route,
      arguments: ForgotPasswordScreenData(_mobileNoOrEmailCtrl.text),
    );
  }

  @override
  void dispose() {
    [_mobileNoOrEmailCtrl, _passwordCtrl].forEach((ctrl) => ctrl.dispose());
    super.dispose();
  }
}
