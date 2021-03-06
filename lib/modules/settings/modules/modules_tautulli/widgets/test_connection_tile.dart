import 'package:flutter/material.dart';
import 'package:lunasea/core.dart';
import 'package:lunasea/modules/tautulli.dart';

class SettingsModulesTautulliTestConnectionTile extends StatelessWidget {
    @override
    Widget build(BuildContext context) => LSButton(
        text: 'Test Connection',
        onTap: () async => _testConnection(context),
    );

    Future<void> _testConnection(BuildContext context) async {
        TautulliState state = Provider.of<TautulliState>(context, listen: false);
        if(!state.enabled) {
            LSSnackBar(context: context, title: 'Tautulli Not Enabled', message: 'Tautulli needs to be enabled', type: SNACKBAR_TYPE.failure);
            return;
        }
        if(state.host == null || state.host.isEmpty) {
            LSSnackBar(context: context, title: 'Host Required', message: 'Host is required to connect to Tautulli', type: SNACKBAR_TYPE.failure);
            return;
        }
        if(state.apiKey == null || state.apiKey.isEmpty) {
            LSSnackBar(context: context, title: 'API Key Required', message: 'API key is required to connect to Tautulli', type: SNACKBAR_TYPE.failure);
            return;
        }
        state.api.miscellaneous.arnold()
        .then((_) {
            LSSnackBar(context: context, title: 'Connected Successfully', message: 'Tautulli is ready to use with LunaSea', type: SNACKBAR_TYPE.success);
        }).catchError((error, trace) {
            Logger.error('SettingsModulesTautulli', '_testConnection', 'Failed Connection', error, trace, uploadToSentry: false);
            LSSnackBar(context: context, title: 'Connection Test Failed', message: Constants.CHECK_LOGS_MESSAGE, type: SNACKBAR_TYPE.failure);
        });
    }
}
