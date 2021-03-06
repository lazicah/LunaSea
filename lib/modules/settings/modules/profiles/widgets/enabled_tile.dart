import 'package:flutter/material.dart';
import 'package:lunasea/core.dart';
import 'package:lunasea/modules/settings.dart';

class SettingsProfileEnabledTile extends StatelessWidget {
    @override
    Widget build(BuildContext context) => LSCardTile(
        title: LSTitle(text: 'Enabled Profile'),
        subtitle: ValueListenableBuilder(
            valueListenable: Database.lunaSeaBox.listenable(keys: [LunaSeaDatabaseValue.ENABLED_PROFILE.key]),
            builder: (context, box, widget) => LSSubtitle(text: box.get(LunaSeaDatabaseValue.ENABLED_PROFILE.key)),
        ),
        trailing: LSIconButton(icon: Icons.person),
        onTap: () => _changeProfile(context),
    );

    Future<void> _changeProfile(BuildContext context) async {
        List<dynamic> values = await SettingsDialogs.enabledProfile(
            context,
            Database.profilesBox.keys.map((x) => x as String).toList()..sort((a,b) => a.toLowerCase().compareTo(b.toLowerCase())),
        );
        if(values[0]) {
            if(values[1] != LunaSeaDatabaseValue.ENABLED_PROFILE.data) {
                LunaSeaDatabaseValue.ENABLED_PROFILE.put(values[1]);
                Providers.reset(context);
            }
            LSSnackBar(
                context: context,
                title: 'Changed Profile',
                message: 'Using profile "${values[1]}"',
                type: SNACKBAR_TYPE.info,
            );
        }
    }
}
