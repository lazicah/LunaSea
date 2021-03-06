import 'package:flutter/material.dart';
import 'package:lunasea/core.dart';
import 'package:lunasea/modules/tautulli.dart';
import 'package:tautulli/tautulli.dart';

class TautulliActivityDetailsTerminateSession extends StatelessWidget {
    final TautulliSession session;

    TautulliActivityDetailsTerminateSession({
        Key key,
        @required this.session,
    }): super(key: key);

    @override
    Widget build(BuildContext context) => LSButton(
        text: 'Terminate Session',
        backgroundColor: LSColors.red,
        onTap: () async => _onPressed(context),
    );

    Future<void> _onPressed(BuildContext context) async {
        List _values = await TautulliDialogs.terminateSession(context);
        if(_values[0]) {
            Provider.of<TautulliState>(context, listen: false).api.activity.terminateSession(
                sessionId: session.sessionId,
                message: _values[1] != null && (_values[1] as String).isNotEmpty ? _values[1] : null,
            )
            .then((_) {
                LSSnackBar(
                    context: context,
                    title: 'Terminated Session',
                    message: '${session.friendlyName}\t${Constants.TEXT_EMDASH}\t${session.title}',
                );
                TautulliRouter.router.pop(context);
            })
            .catchError((error, trace) {
                Logger.error(
                    'TautulliActivityDetailsTerminateSession',
                    '_onPressed',
                    'Unable to terminate session: ${session.sessionId}',
                    error,
                    trace,
                    uploadToSentry: !(error is DioError),
                );
                LSSnackBar(
                    context: context,
                    title: 'Failed to Terminate Session',
                    type: SNACKBAR_TYPE.failure,
                );
            });
        }
    }
}