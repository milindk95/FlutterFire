import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:the_super11/blocs/auth/login/login_bloc.dart';
import 'package:the_super11/blocs/auth/sign_up/sign_up_bloc.dart';
import 'package:the_super11/core/extensions.dart';
import 'package:the_super11/core/providers/user_info_provider.dart';
import 'package:the_super11/core/utility.dart';
import 'package:the_super11/ui/resources/resources.dart';
import 'package:the_super11/ui/screens/auth/auth_button.dart';
import 'package:the_super11/ui/screens/auth/forgot_password_screen.dart';
import 'package:the_super11/ui/screens/auth/sign_up_verification_screen.dart';
import 'package:the_super11/ui/screens/home/home_screen.dart';
import 'package:the_super11/ui/widgets/widgets.dart';

part 'login_section.dart';
part 'sign_up_section.dart';

class LoginSignUpScreen extends StatefulWidget {
  static const route = '/login_sign_up';

  const LoginSignUpScreen({Key? key}) : super(key: key);

  @override
  _LoginSignUpScreenState createState() => _LoginSignUpScreenState();
}

class _LoginSignUpScreenState extends State<LoginSignUpScreen> {
  final _tabs = ['Login', 'Sign Up'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<LoginBloc, LoginState>(
        builder: (_, state) {
          return AbsorbPointer(
            absorbing: state is LoginAuthenticating,
            child: DefaultTabController(
              length: _tabs.length,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).padding.top + 12,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 16,
                      right: 16,
                      bottom: 40,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TabBar(
                            isScrollable: true,
                            labelColor: Theme.of(context).primaryColor,
                            labelStyle: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            indicator: UnderlineTabIndicator(
                              borderSide: BorderSide(
                                width: 2,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            tabs: List.generate(
                              2,
                              (index) => Tab(
                                text: _tabs[index],
                              ),
                            ),
                          ),
                        ),
                        Image.asset(
                          imgSuper11Logo,
                          height: 50,
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                      physics: NeverScrollableScrollPhysics(),
                      children: [
                        LoginSection(screenContext: context),
                        SignUpSection(screenContext: context),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
