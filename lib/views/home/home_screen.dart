import 'package:ezymember_backend/constants/app_constants.dart';
import 'package:ezymember_backend/constants/app_routes.dart';
import 'package:ezymember_backend/controllers/authentication_controller.dart';
import 'package:ezymember_backend/helpers/responsive_helper.dart';
import 'package:ezymember_backend/helpers/session_helper.dart';
import 'package:ezymember_backend/language/globalization.dart';
import 'package:ezymember_backend/widgets/custom_list_tile.dart';
import 'package:ezymember_backend/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _authController = Get.find<AuthController>();
  final List<MenuEntry> _entries = AppRoutes().entries;
  final SessionHelper _sessionHelper = SessionHelper();

  late MenuItem _selectedItem;

  @override
  void initState() {
    super.initState();

    _sessionHelper.startTimer();

    String currentPath = Uri.base.fragment;

    final initialItem = _entries
        .expand(
          (entry) => switch (entry) {
            MenuItemEntry e => [e.item],
            MenuGroupEntry e => e.items,
          },
        )
        .firstWhere((item) => item.route == currentPath, orElse: () => (_entries.first as MenuItemEntry).item);

    _selectedItem = initialItem;
  }

  @override
  void dispose() {
    _sessionHelper.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Theme.of(context).colorScheme.surface,
    appBar: context.isDesktop ? null : AppBar(title: Image.asset("assets/images/app_logo.png", height: kToolbarHeight * 0.5)),
    body: Row(
      children: <Widget>[
        if (context.isDesktop) _buildMenu(),
        Expanded(child: _buildContent()),
      ],
    ),
    drawer: context.isDesktop ? null : Drawer(child: _buildMenu()),
  );

  Widget _buildMenu() => SizedBox(
    width: kMenuWidth,
    child: Material(
      color: Theme.of(context).colorScheme.primary,
      child: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 36.0,
              children: <Widget>[
                Image.asset("assets/images/logo_w.png", alignment: Alignment.centerLeft, height: 30.0),
                Row(
                  spacing: 8.0,
                  children: <Widget>[
                    Icon(Icons.person_2_rounded, size: 20.0),
                    CustomText(
                      _authController.user.value.name,
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ],
                ),
              ],
            ),
          ),
          CustomMenuListTile(isSelected: false, label: Globalization.changePassword.tr, onTap: () {}),
          CustomMenuListTile(isSelected: false, label: Globalization.logout.tr, onTap: () => _authController.signOut()),
          Divider(color: Theme.of(context).colorScheme.surfaceContainerLowest, height: 0.0),
          for (final entry in _entries)
            switch (entry) {
              MenuItemEntry e => _buildMenuItem(e.item),
              MenuGroupEntry e => CustomExpansionListTile(label: e.title, children: e.items.map(_buildMenuItem).toList()),
            },
        ],
      ),
    ),
  );

  Widget _buildMenuItem(MenuItem item) => CustomMenuListTile(
    isSelected: _selectedItem == item,
    label: item.label,
    onTap: () {
      setState(() => _selectedItem = item);
      SystemNavigator.routeInformationUpdated(uri: Uri.parse(item.route), replace: true);
    },
  );

  Widget _buildContent() => Scaffold(
    appBar: AppBar(
      automaticallyImplyLeading: false,
      centerTitle: false,
      backgroundColor: Colors.white,
      title: Text(
        _selectedItem.label,
        style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold),
      ),
    ),
    body: _selectedItem.screen,
  );
}
