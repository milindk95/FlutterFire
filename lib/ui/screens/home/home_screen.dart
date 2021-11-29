import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:the_super11/blocs/matches/my_matches/my_matches_bloc.dart';
import 'package:the_super11/blocs/profile/user_profile/user_profile_bloc.dart';
import 'package:the_super11/ui/resources/resources.dart';
import 'package:the_super11/ui/screens/home/home_section.dart';
import 'package:the_super11/ui/screens/home/my_matches_section.dart';
import 'package:the_super11/ui/screens/home/settings_section.dart';
import 'package:the_super11/ui/screens/home/wallet_section.dart';

class HomeScreen extends StatefulWidget {
  static const route = '/home';

  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedTabIndex = 0;
  final _tabIcons = [icHome, icMyMatches, icWallet, icSettings];
  final _tabLabels = ['Home', 'My Matches', 'Wallet', 'Settings'];
  late final List<Widget> _sections;

  @override
  void initState() {
    super.initState();
    _sections = [
      HomeSection(
        viewAllCallback: () => setState(() => _selectedTabIndex = 1),
      ),
      BlocProvider<MyMatchesBloc>(
        create: (context) => MyMatchesBloc()..add(GetMyMatches(0)),
        child: MyMatchesSection(),
      ),
      BlocProvider<UserProfileBloc>(
        create: (context) => UserProfileBloc()..add(GetUserProfile()),
        child: WalletSection(),
      ),
      SettingsSection()
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _sections[_selectedTabIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: List.generate(
            _tabIcons.length,
            (i) => _bottomNavigationBarItem(
                  icon: _tabIcons[i],
                  label: _tabLabels[i],
                )),
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Theme.of(context).colorScheme.secondaryVariant,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        onTap: (index) => setState(() => _selectedTabIndex = index),
        currentIndex: _selectedTabIndex,
      ),
    );
  }

  BottomNavigationBarItem _bottomNavigationBarItem(
          {required String icon, required String label}) =>
      BottomNavigationBarItem(
        icon: SvgPicture.asset(
          icon,
          height: 20,
          color: Theme.of(context).colorScheme.secondaryVariant,
        ),
        activeIcon: SvgPicture.asset(
          icon,
          height: 20,
          color: Theme.of(context).primaryColor,
        ),
        label: label,
      );
}
