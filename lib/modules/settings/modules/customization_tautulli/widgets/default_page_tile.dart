import 'package:flutter/material.dart';
import 'package:lunasea/core.dart';
import 'package:lunasea/modules/tautulli.dart';

class SettingsCustomizationTautulliDefaultPageTile extends StatelessWidget {
    @override
    Widget build(BuildContext context) => ValueListenableBuilder(
        valueListenable: Database.lunaSeaBox.listenable(keys: [TautulliDatabaseValue.NAVIGATION_INDEX.key]),
        builder: (context, box, _) => LSCardTile(
            title: LSTitle(text: 'Default Page'),
            subtitle: LSSubtitle(text: TautulliNavigationBar.titles[TautulliDatabaseValue.NAVIGATION_INDEX.data]),
            trailing: LSIconButton(icon: TautulliNavigationBar.icons[TautulliDatabaseValue.NAVIGATION_INDEX.data]),
            onTap: () async => _defaultPage(context),
        ),
    );

    Future<void> _defaultPage(BuildContext context) async {
        List<dynamic> _values = await TautulliDialogs.defaultPage(context);
        if(_values[0]) TautulliDatabaseValue.NAVIGATION_INDEX.put(_values[1]);
    }
}
