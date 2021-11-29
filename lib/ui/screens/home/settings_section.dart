import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:the_super11/blocs/app_update/app_update_bloc.dart';
import 'package:the_super11/blocs/theme/theme_bloc.dart';
import 'package:the_super11/core/extensions.dart';
import 'package:the_super11/core/preferences.dart';
import 'package:the_super11/core/providers/user_info_provider.dart';
import 'package:the_super11/core/utility.dart';
import 'package:the_super11/ui/resources/resources.dart';
import 'package:the_super11/ui/screens/auth/login_sign_up_screen.dart';
import 'package:the_super11/ui/screens/commons/coming_soon_screen.dart';
import 'package:the_super11/ui/screens/commons/refer_and_earn_screen.dart';
import 'package:the_super11/ui/screens/profile/user_profile_screen.dart';
import 'package:the_super11/ui/widgets/widgets.dart';

class SettingsSection extends StatefulWidget {
  const SettingsSection({Key? key}) : super(key: key);

  @override
  _SettingsSectionState createState() => _SettingsSectionState();
}

class _SettingsSectionState extends State<SettingsSection> {
  final _labels = ['Dark Theme', 'Notifications', 'Refer & Earn'];
  final _icons = [icTheme, icNotification, icReferEarn];

  @override
  void initState() {
    super.initState();
    if (context.read<AppUpdateBloc>().state is AppHasSoftUpdate) {
      _labels.add('Update App');
      _icons.add(icUpdate);
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        CupertinoSliverNavigationBar(
          largeTitle: Text(
            'Settings',
            style: homeSectionsHeaderTextStyles,
          ),
        ),
        SliverList(
          delegate: SliverChildListDelegate(
            <Widget>[
              _userProfile(),
              SizedBox(
                height: 20,
              ),
              _settingsItems(
                labels: _labels,
                icons: _icons,
                color: Colors.orange,
                onTaps: [
                  () {},
                  () => Navigator.of(context).pushNamed(
                        ComingSoonScreen.route,
                        arguments: 'Notifications',
                      ),
                  () =>
                      Navigator.of(context).pushNamed(ReferAndEarnScreen.route),
                  () => Utility.launchUrl(
                      Platform.isIOS ? appStoreUrl : androidApkUrl),
                ],
                rights: [
                  BlocBuilder<ThemeBloc, ThemeState>(
                    builder: (context, state) {
                      return Container(
                        height: 24,
                        child: CupertinoSwitch(
                          value: state is ThemeDark,
                          onChanged: (value) => context.read<ThemeBloc>().add(
                                ChangeTheme(isDark: value),
                              ),
                        ),
                      );
                    },
                  ),
                  null,
                  null,
                  null,
                ],
              ),
              SizedBox(
                height: 20,
              ),
              _settingsItems(
                labels: [
                  'About Us',
                  'Support',
                  'How to play',
                  'How to withdraw',
                  'Fantasy Point System'
                ],
                icons: [
                  icAboutUs,
                  icSupport,
                  icMyMatches,
                  icWithdraw,
                  icFantasy
                ],
                onTaps: [
                  () => Utility.launchUrl(aboutUsUrl),
                  () => Utility.launchUrl(helpUrl),
                  () => Utility.launchUrl(howToPlayUrl),
                  () => Utility.launchUrl(howToWithdrawUrl),
                  () => Utility.launchUrl(fantasyPointUrl),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              _settingsItems(
                labels: ['Privacy Policy', 'Terms & Conditions'],
                icons: [icPrivacyPolicy, icTermsConditions],
                onTaps: [
                  () => Utility.launchUrl(privacyPolicyUrl),
                  () => Utility.launchUrl(termsAndConditionsUrl),
                ],
                color: Colors.green,
              ),
              SizedBox(
                height: 20,
              ),
              _settingsItems(
                labels: ['Log Out'],
                icons: [icLogout],
                color: Colors.redAccent,
                onTaps: [
                  () async {
                    context.showConfirmation(
                      title: 'Log Out',
                      message: 'Are you sure to want to log out?',
                      positiveText: 'Log Out',
                      positiveAction: () async {
                        await Preference.clearUserData();
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            LoginSignUpScreen.route, (route) => false);
                      },
                    );
                  }
                ],
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _userProfile() => Container(
        color: Colors.white,
        child: Material(
          child: InkWell(
            onTap: () =>
                Navigator.of(context).pushNamed(UserProfileScreen.route),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  child: Consumer<UserInfo>(
                    builder: (context, state, child) {
                      return Row(
                        children: [
                          ClipOval(
                            child: AppNetworkImage(
                              url: state.user.avatar,
                              width: 54,
                              height: 54,
                              errorIcon: imgProfilePlaceholder,
                            ),
                          ),
                          SizedBox(
                            width: 12,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  state.user.teamName,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(
                                  height: 2,
                                ),
                                Text(state.user.email),
                              ],
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.grey,
                            size: 20,
                          )
                        ],
                      );
                    },
                  ),
                ),
                Divider(
                  height: 0,
                ),
              ],
            ),
          ),
        ),
      );

  Widget _settingsItems({
    required List<String> labels,
    required List<String> icons,
    required List<GestureTapCallback> onTaps,
    Color color = Colors.blue,
    List<Widget?> rights = const [],
  }) =>
      Column(
        children: [
          Divider(
            height: 0,
          ),
          ListView.separated(
            itemCount: labels.length,
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, i) => Container(
              color: Colors.white,
              child: Material(
                child: InkWell(
                  onTap:
                      rights.isNotEmpty && rights[i] != null ? null : onTaps[i],
                  child: Padding(
                    padding: const EdgeInsets.only(left: 12),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 12,
                            bottom: 12,
                            right: 12,
                          ),
                          child: Row(
                            children: [
                              Container(
                                child: SvgPicture.asset(
                                  icons[i],
                                  width: 18,
                                  height: 18,
                                  color: Colors.white,
                                ),
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  color: color,
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: Text(
                                  labels[i],
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              rights.isNotEmpty && rights[i] != null
                                  ? rights[i]!
                                  : Icon(
                                      Icons.arrow_forward_ios,
                                      color: Colors.grey,
                                      size: 18,
                                    )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            separatorBuilder: (context, i) => Container(
              margin: const EdgeInsets.only(left: 34),
              child: Divider(
                height: 0,
              ),
            ),
          ),
          Divider(
            height: 0,
          ),
        ],
      );
}
