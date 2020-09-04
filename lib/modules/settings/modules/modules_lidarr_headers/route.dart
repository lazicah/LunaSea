import 'package:flutter/material.dart';
import 'package:lunasea/core.dart';
import 'package:lunasea/modules/settings.dart';

class SettingsModulesLidarrHeadersRoute extends StatefulWidget {
    static const ROUTE_NAME = '/settings/modules/lidarr/headers';

    @override
    State<SettingsModulesLidarrHeadersRoute> createState() => _State();
}

class _State extends State<SettingsModulesLidarrHeadersRoute> {
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

    @override
    Widget build(BuildContext context) => Scaffold(
        key: _scaffoldKey,
        appBar: _appBar,
        body: _body,
    );

    Widget get _appBar => LSAppBar(title: 'Custom Headers');

    Widget get _body => ValueListenableBuilder(
        valueListenable: Database.profilesBox.listenable(),
        builder: (context, profile, _) => LSListView(
            children: _headers,
        ),
    );

    List<Widget> get _headers => [
        if((Database.currentProfileObject.lidarrHeaders ?? {}).isEmpty) _noHeaders,
        ..._list,
        LSDivider(),
        SettingsModulesLidarrHeadersAddHeaderTile(),
    ];

    Widget get _noHeaders => LSGenericMessage(text: 'No Custom Headers Added');

    List<Widget> get _list {
        Map<String, dynamic> headers = (Database.currentProfileObject.lidarrHeaders ?? {}).cast<String, dynamic>();
        List<SettingsModulesLidarrHeadersHeaderTile> list = [];
        headers.forEach((key, value) => list.add(SettingsModulesLidarrHeadersHeaderTile(
            headerKey: key.toString(),
            headerValue: value.toString(),
        )));
        list.sort((a,b) => a.headerKey.toLowerCase().compareTo(b.headerKey.toLowerCase()));
        return list;
    }
}