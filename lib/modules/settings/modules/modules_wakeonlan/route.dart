import 'package:flutter/material.dart';
import 'package:lunasea/core.dart';
import 'package:lunasea/modules/settings.dart';

class SettingsModulesWakeOnLANRoute extends StatefulWidget {
    static const ROUTE_NAME = '/settings/modules/wakeonlan';

    @override
    State<SettingsModulesWakeOnLANRoute> createState() => _State();
}

class _State extends State<SettingsModulesWakeOnLANRoute> {
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

    @override
    Widget build(BuildContext context) => Scaffold(
        key: _scaffoldKey,
        appBar: _appBar,
        body: _body,
    );

    Widget get _appBar => LSAppBar(title: 'Wake on LAN');

    Widget get _body => ValueListenableBuilder(
        valueListenable: Database.profilesBox.listenable(),
        builder: (context, box, _) => LSListView(
            children: [
                ..._mandatory,
            ],
        ),
    );

    List<Widget> get _mandatory => [
        LSHeader(
            text: 'Mandatory',
            subtitle: 'Configuration that is required for functionality',
        ),
        SettingsModulesWakeOnLANEnabledTile(),
        SettingsModulesWakeOnLANBroadcastAddressTile(),
        SettingsModulesWakeOnLANMACAddressTile(),
    ];
}
