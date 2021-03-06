import 'package:flutter/material.dart';
import 'package:lunasea/core.dart';

class TautulliLogsLoginsTile extends StatelessWidget {
    @override
    Widget build(BuildContext context) => LSCardTile(
        title: LSTitle(text: 'Logins'),
        subtitle: LSSubtitle(text: 'Tautulli Login Logs'),
        trailing: LSIconButton(
            icon: Icons.vpn_key,
            color: LSColors.list(5),
        ),
        onTap: () async => _onTap(context),
    );

    Future<void> _onTap(BuildContext context) async => LSSnackBar(
        context: context,
        title: 'Coming Soon!',
        message: 'This feature has not yet been implemented',
        type: SNACKBAR_TYPE.info,
    );
}
