import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lunasea/core.dart';

class LSLoader extends StatelessWidget {
    final double size;
    final Color color;

    LSLoader({
        Key key,
        this.size = 25.0,
        this.color, 
    }): super(key: key);

    @override
    Widget build(BuildContext context) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
            SpinKitThreeBounce(
                color: color != null ? color : LSColors.accent,
                size: size,
            ),
        ],
    );
}
