import 'package:flutter/material.dart';
import 'package:lunasea/core.dart';
import 'package:lunasea/modules/settings.dart';

class SettingsModulesSonarrRoute extends StatefulWidget {
    static const ROUTE_NAME = '/settings/modules/sonarr';

    @override
    State<SettingsModulesSonarrRoute> createState() => _State();
}

class _State extends State<SettingsModulesSonarrRoute> {
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

    @override
    Widget build(BuildContext context) => Scaffold(
        key: _scaffoldKey,
        appBar: _appBar,
        body: _body,
    );

    Widget get _appBar => LSAppBar(
        title: 'Sonarr',
        actions: [
            LSIconButton(
                icon: Icons.brush,
                onPressed: () async => Navigator.of(context).pushNamed(SettingsCustomizationSonarrRoute.ROUTE_NAME),
            ),
        ]
    );

    Widget get _body => ValueListenableBuilder(
        valueListenable: Database.profilesBox.listenable(),
        builder: (context, box, _) => LSListView(
            children: [
                ..._mandatory,
                LSDivider(),
                SettingsModulesSonarrTestConnectionTile(),
                ..._advanced,
            ],
        ),
    );

    List<Widget> get _mandatory => [
        LSHeader(
            text: 'Mandatory',
            subtitle: 'Configuration that is required for functionality',
        ),
        SettingsModulesSonarrEnabledTile(),
        SettingsModulesSonarrHostTile(),
        SettingsModulesSonarrAPIKeyTile(),
    ];

    List<Widget> get _advanced => [
        LSHeader(
            text: 'Advanced',
            subtitle: 'Options for non-standard networking configurations',
        ),
        SettingsModulesSonarrCustomHeadersTile(),
        SettingsModulesSonarrStrictTLSTile(),
    ];
}
