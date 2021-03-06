import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lunasea/core.dart';
import 'package:lunasea/modules/tautulli.dart';
import 'package:tautulli/tautulli.dart';

class TautulliRecentlyAddedContentTile extends StatelessWidget {
    final TautulliRecentlyAdded recentlyAdded;
    final double _imageDimension = 83.0;
    final double _padding = 8.0;

    TautulliRecentlyAddedContentTile({
        Key key,
        @required this.recentlyAdded,
    }) : super(key: key);

    @override
    Widget build(BuildContext context) => LSCard(
        child: InkWell(
            borderRadius: BorderRadius.circular(Constants.UI_BORDER_RADIUS),
            child: Row(
                children: [
                    _poster(context),
                    _details(context),
                ],
            ),
            onTap: () async => _onTap(context),
        ),
        decoration: recentlyAdded.art != null && recentlyAdded.art.isNotEmpty
            ? LSCardBackground(
                darken: true,
                uri: Provider.of<TautulliState>(context, listen: false).getImageURLFromPath(recentlyAdded.art),
                headers: Provider.of<TautulliState>(context, listen: false).headers.cast<String, String>(),
            )
            : null,
    );

    String get _posterLink {
        if(recentlyAdded.grandparentThumb != null && recentlyAdded.grandparentThumb.isNotEmpty) return recentlyAdded.grandparentThumb;
        if(recentlyAdded.parentThumb != null && recentlyAdded.parentThumb.isNotEmpty) return recentlyAdded.parentThumb;
        if(recentlyAdded.thumb != null && recentlyAdded.thumb.isNotEmpty) return recentlyAdded.thumb;
        return '';
    }

    Widget _poster(BuildContext context) => CachedNetworkImage(
        fadeInDuration: Duration(milliseconds: Constants.UI_NAVIGATION_SPEED),
        fadeOutDuration: Duration(milliseconds: Constants.UI_NAVIGATION_SPEED),
        imageUrl: Provider.of<TautulliState>(context, listen: false).getImageURLFromPath(_posterLink),
        httpHeaders: Provider.of<TautulliState>(context, listen: false).headers.cast<String, String>(),
        imageBuilder: (context, imageProvider) => Container(
            height: _imageDimension,
            width: _imageDimension/1.5,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Constants.UI_BORDER_RADIUS),
                image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.cover,
                ),
            ),
        ),
        placeholder: (context, url) => _placeholder,
        errorWidget: (context, url, error) => _placeholder,
    );

    Widget get _placeholder => Container(
        height: _imageDimension,
        width: _imageDimension/1.5,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Constants.UI_BORDER_RADIUS),
            image: DecorationImage(
                image: AssetImage('assets/images/sonarr/noseriesposter.png'),
                fit: BoxFit.cover,
            ),
        ),
    );

    Widget _details(BuildContext context) => Expanded(
        child: Padding(
            child: Container(
                child: Column(
                    children: [
                        _title,
                        _subtitle,
                        _library,
                        _addedAt,
                    ],
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                ),
                height: (_imageDimension-(_padding*2)),
            ),
            padding: EdgeInsets.all(_padding),
        ),
    );

    Widget get _title {
        String title = 'Unknown Title';
        if(recentlyAdded.title != null && recentlyAdded.title.isNotEmpty) title = recentlyAdded.title;
        if(recentlyAdded.parentTitle != null && recentlyAdded.parentTitle.isNotEmpty) title = recentlyAdded.parentTitle;
        if(recentlyAdded.grandparentTitle != null && recentlyAdded.grandparentTitle.isNotEmpty) title = recentlyAdded.grandparentTitle;
        return LSTitle(
            text: title,
            maxLines: 1,
        );
    }

    Widget get _subtitle => RichText(
        text: TextSpan(
            style: TextStyle(
                color: Colors.white70,
                fontSize: Constants.UI_FONT_SIZE_SUBTITLE,
            ),
            children: <TextSpan>[
                // Television
                if(recentlyAdded.mediaType == TautulliMediaType.EPISODE) TextSpan(text: 'S${recentlyAdded.parentMediaIndex}\t${Constants.TEXT_BULLET}\tE${recentlyAdded.mediaIndex}'),
                if(recentlyAdded.mediaType == TautulliMediaType.EPISODE) TextSpan(text: '\t${Constants.TEXT_EMDASH}\t${recentlyAdded.title}'),
                if(recentlyAdded.mediaType == TautulliMediaType.SHOW) TextSpan(text: recentlyAdded.year.toString()),
                if(recentlyAdded.mediaType == TautulliMediaType.SEASON) TextSpan(text: recentlyAdded.fullTitle),
                // Movie
                if(recentlyAdded.mediaType == TautulliMediaType.MOVIE) TextSpan(text: recentlyAdded.year.toString()),
                // Music
                if(recentlyAdded.mediaType == TautulliMediaType.ARTIST) TextSpan(text: Constants.TEXT_EMDASH),
                if(recentlyAdded.mediaType == TautulliMediaType.ALBUM) TextSpan(text: Constants.TEXT_EMDASH),
                if(recentlyAdded.mediaType == TautulliMediaType.TRACK) TextSpan(text: recentlyAdded.title),
                if(recentlyAdded.mediaType == TautulliMediaType.TRACK) TextSpan(text: '\t${Constants.TEXT_EMDASH}\t${recentlyAdded.parentTitle}'),
                // Other
                if(recentlyAdded.mediaType == TautulliMediaType.LIVE) TextSpan(text: Constants.TEXT_EMDASH),
                if(recentlyAdded.mediaType == TautulliMediaType.COLLECTION) TextSpan(text: Constants.TEXT_EMDASH),
            ],
        ),
        softWrap: false,
        maxLines: 1,
        overflow: TextOverflow.fade,
    );

    Widget get _addedAt => LSSubtitle(text: DateTime.now().lsDateTime_ageString(recentlyAdded.addedAt));

    Widget get _library => LSSubtitle(text: recentlyAdded.libraryName);

    Future<void> _onTap(BuildContext context) async => LSSnackBar(
        context: context,
        title: 'Coming Soon!',
        message: 'This feature has not yet been implemented',
        type: SNACKBAR_TYPE.info,
    );
}
