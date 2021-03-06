import 'package:flutter/material.dart';
import 'package:lunasea/core.dart';

class HomeConstants {
    HomeConstants._();

    static const MODULE_KEY = 'home';

    static const ModuleMap MODULE_MAP = ModuleMap(
        name: 'Home',
        description: 'Home',
        settingsDescription: 'Configure the Home Screen',
        icon: CustomIcons.home,
        route: '/',
        color: Color(Constants.ACCENT_COLOR),
    );

    //ignore: non_constant_identifier_names
    static final ShortcutItem MODULE_QUICK_ACTION = ShortcutItem(
        type: MODULE_KEY,
        localizedTitle: MODULE_MAP.name,
    );
}
