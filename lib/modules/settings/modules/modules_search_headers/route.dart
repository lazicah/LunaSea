import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:lunasea/core.dart';
import 'package:lunasea/modules/settings.dart';

class SettingsModulesSearchHeadersRouteArguments {
    final IndexerHiveObject indexer;
    final bool saveAfterAction;

    SettingsModulesSearchHeadersRouteArguments({
        @required this.indexer,
        @required this.saveAfterAction,
    });
}

class SettingsModulesSearchHeadersRoute extends StatefulWidget {
    static const ROUTE_NAME = '/settings/modules/search/headers';

    @override
    State<SettingsModulesSearchHeadersRoute> createState() => _State();
}

class _State extends State<SettingsModulesSearchHeadersRoute> {
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
    SettingsModulesSearchHeadersRouteArguments _arguments;

    @override
    void initState() {
        super.initState();
        SchedulerBinding.instance.scheduleFrameCallback((_) => setState(() {
            _arguments = ModalRoute.of(context).settings.arguments;
        }));
    }

    @override
    Widget build(BuildContext context) => _arguments == null
        ? Scaffold()
        : Scaffold(
            key: _scaffoldKey,
            appBar: _appBar,
            body: _body,
        );

    Widget get _appBar => LSAppBar(title: 'Custom Headers');

    Widget get _body => LSListView(
        children: [
            if((_arguments.indexer.headers ?? {}).isEmpty) _noHeaders,
            ..._list,
            LSDivider(),
            _addHeader,
        ],
    );

    Widget get _noHeaders => LSGenericMessage(text: 'No Custom Headers Added');

    List<Widget> get _list {
        Map<String, dynamic> headers = (_arguments.indexer.headers ?? {}).cast<String, dynamic>();
        List<LSCardTile> list = [];
        headers.forEach((key, value) => list.add(_header(key.toString(), value.toString())));
        list.sort((a,b) => (a.title as LSTitle).text.toLowerCase().compareTo((b.title as LSTitle).text.toLowerCase()));
        return list;
    }

    Widget _header(String key, String value) => LSCardTile(
        title: LSTitle(text: key.toString()),
        subtitle: LSSubtitle(text: value.toString()),
        trailing: LSIconButton(
            icon: Icons.delete,
            color: LSColors.red,
            onPressed: () async => _delete(key),
        ),
    );

    Widget get _addHeader => LSButton(
        text: 'Add Header',
        onTap: () async => _add(),
    );

    Future<void> _add() async {
        List results = await SettingsDialogs.addHeader(context);
        if(results[0]) switch(results[1]) {
            case 1:
                _showAuthenticationPrompt(context);
                break;
            case 100:
                _showCustomPrompt(context);
                break;
            default:
                Logger.warning(
                    'SettingsModulesLidarrHeadersAddHeaderTile',
                    '_addPrompt',
                    'Unknown case: ${results[1]}',
                );
                break;
        }
    }

    Future<void> _showAuthenticationPrompt(BuildContext context) async {
        List results = await SettingsDialogs.addAuthenticationHeader(context);
        if(results[0]) {
            Map<String, dynamic> _headers = (_arguments.indexer.headers ?? {}).cast<String, dynamic>();
            String _auth = base64.encode(utf8.encode('${results[1]}:${results[2]}'));
            _headers.addAll({'Authorization': 'Basic $_auth'});
            _arguments.indexer.headers = _headers;
            if(_arguments.saveAfterAction) _arguments.indexer.save();
            LSSnackBar(
                context: context,
                message: 'Authorization',
                title: 'Header Added',
                type: SNACKBAR_TYPE.success,
            );
            setState(() {});
        }
    }

    Future<void> _showCustomPrompt(BuildContext context) async {
        List results = await SettingsDialogs.addCustomHeader(context);
        if(results[0]) {
            Map<String, dynamic> _headers = (_arguments.indexer.headers ?? {}).cast<String, dynamic>();
            _headers.addAll({results[1]: results[2]});
            _arguments.indexer.headers = _headers;
            if(_arguments.saveAfterAction) _arguments.indexer.save();
            LSSnackBar(
                context: context,
                message: results[1],
                title: 'Header Added',
                type: SNACKBAR_TYPE.success,
            );
            setState(() {});
        }
    }

    Future<void> _delete(String key) async {
        List results = await SettingsDialogs.deleteHeader(context);
        if(results[0]) {
            Map<String, dynamic> _headers = (_arguments.indexer.headers ?? {}).cast<String, dynamic>();
            _headers.remove(key);
            _arguments.indexer.headers = _headers;
            if(_arguments.saveAfterAction) _arguments.indexer.save();
            LSSnackBar(
                context: context,
                message: key,
                title: 'Header Deleted',
                type: SNACKBAR_TYPE.success,
            );
            setState(() {});
        }
    }
}
