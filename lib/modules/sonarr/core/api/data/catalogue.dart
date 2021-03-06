import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lunasea/core.dart';
import 'package:lunasea/modules/sonarr.dart';

class SonarrCatalogueData {
    final Map<String, dynamic> api = Database.currentProfileObject.getSonarr();
    String title;
    String sortTitle;
    String status;
    String previousAiring;
    String nextAiring;
    String added;
    String network;
    String overview;
    String path;
    String type;
    List<dynamic> seasonData;
    int qualityProfile;
    int seasonCount;
    int episodeCount;
    int episodeFileCount;
    int seriesID;
    String profile;
    bool seasonFolder;
    bool monitored;
    int tvdbId;
    int tvMazeId;
    String imdbId;
    int runtime;
    int sizeOnDisk;

    SonarrCatalogueData({
        @required this.title,
        @required this.sortTitle,
        @required this.seasonCount,
        @required this.seasonData,
        @required this.episodeCount,
        @required this.episodeFileCount,
        @required this.status,
        @required this.seriesID,
        @required this.previousAiring,
        @required this.nextAiring,
        @required this.added,
        @required this.network,
        @required this.monitored,
        @required this.path,
        @required this.qualityProfile,
        @required this.type,
        @required this.seasonFolder,
        @required this.overview,
        @required this.tvdbId,
        @required this.tvMazeId,
        @required this.imdbId,
        @required this.runtime,
        @required this.profile,
        @required this.sizeOnDisk,
    });

    DateTime get nextAiringObject => DateTime.tryParse(nextAiring)?.toLocal();

    DateTime get previousAiringObject => DateTime.tryParse(previousAiring)?.toLocal();

    DateTime get dateAddedObject => DateTime.tryParse(added)?.toLocal();

    String get seasonCountString {
        return seasonCount == 1 ? '$seasonCount Season' : '$seasonCount Seasons';
    }

    String get dateAdded {
        if(added != null) {
            return DateFormat('MMMM dd, y').format(dateAddedObject);
        }
        return 'Unknown';
    }

    String get nextEpisode {
        if(nextAiringObject != null) {
            return DateFormat('MMMM dd, y').format(nextAiringObject);
        }
        return 'Unknown';
    }

    int get percentageComplete {
        int _total = episodeCount ?? 0;
        int _available = episodeFileCount ?? 0;
        return _total == 0
            ? 0
            : ((_available/_total)*100).round();
    }

    String get airTimeString {
        if(previousAiringObject != null) {
            return LunaSeaDatabaseValue.USE_24_HOUR_TIME.data
                ? DateFormat.Hm().format(previousAiringObject)
                : DateFormat('KK:mm\na').format(previousAiringObject);
        }
        return 'Unknown';
    }

    String subtitle(SonarrCatalogueSorting sorting) {
        if(previousAiringObject != null) {
            if(network == null) {
                return status == 'ended' ?
                    '$seasonCountString (Ended)\t•\t${_sortSubtitle(sorting)}\nAired on Unknown' :
                    '$seasonCountString\t•\t${_sortSubtitle(sorting)}\n${previousAiringObject.lsDateTime_time} on Unknown';
            }
            return status == 'ended' ?
                '$seasonCountString (Ended)\t•\t${_sortSubtitle(sorting)}\nAired on $network' :
                '$seasonCountString\t•\t${_sortSubtitle(sorting)}\n${previousAiringObject.lsDateTime_time} on $network';
        } else {
            if(network == null) {
                return status == 'ended' ? 
                    '$seasonCountString (Ended)\t•\t${_sortSubtitle(sorting)}\nAired on Unknown' :
                    '$seasonCountString\t•\t${_sortSubtitle(sorting)}\nAirs on Unknown';
            }
            return status == 'ended' ? 
                '$seasonCountString (Ended)\t•\t${_sortSubtitle(sorting)}\nAired on $network' :
                '$seasonCountString\t•\t${_sortSubtitle(sorting)}\nAirs on $network';
        }
    }

    String _sortSubtitle(SonarrCatalogueSorting sorting) {
        switch(sorting) {
            case SonarrCatalogueSorting.type: return type.lsLanguage_Capitalize();
            case SonarrCatalogueSorting.quality: return profile;
            case SonarrCatalogueSorting.episodes: return '${episodeFileCount ?? 0}/${episodeCount ?? 0} ($percentageComplete%)';
            case SonarrCatalogueSorting.nextAiring: return nextEpisode;
            case SonarrCatalogueSorting.dateAdded: return dateAdded;
            case SonarrCatalogueSorting.network:
            case SonarrCatalogueSorting.size:
            case SonarrCatalogueSorting.alphabetical: return sizeOnDisk?.lsBytes_BytesToString() ?? '0.0 B';
        }
        return 'Unknown';
    }

    String posterURI({bool highRes = false}) {
        if(api['enabled']) {
            String _base = (api['host'] as String).endsWith('/')
                ? '${api['host']}api/MediaCover'
                : '${api['host']}/api/MediaCover';
            return highRes
                ? '$_base/$seriesID/poster.jpg?apikey=${api['key']}'
                : '$_base/$seriesID/poster-500.jpg?apikey=${api['key']}';
        }
        return '';
    }

    String fanartURI({bool highRes = false}) {
        if(api['enabled']) {
            String _base = (api['host'] as String).endsWith('/')
                ? '${api['host']}api/MediaCover'
                : '${api['host']}/api/MediaCover';
            return highRes
                ? '$_base/$seriesID/fanart.jpg?apikey=${api['key']}'
                : '$_base/$seriesID/fanart-360.jpg?apikey=${api['key']}'; 
        }
        return '';
    }

    String bannerURI({bool highRes = false}) {
        if(api['enabled']) {
            String _base = (api['host'] as String).endsWith('/')
                ? '${api['host']}api/MediaCover'
                : '${api['host']}/api/MediaCover';
            return highRes
                ? '$_base/$seriesID/banner.jpg?apikey=${api['key']}'
                : '$_base/$seriesID/banner-70.jpg?apikey=${api['key']}'; 
        }
        return '';
    }
}