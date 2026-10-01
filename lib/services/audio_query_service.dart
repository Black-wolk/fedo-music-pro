import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';

class LocalAudioQueryService {
  final OnAudioQuery _audioQuery = OnAudioQuery();

  Future<bool> requestStoragePermission() async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      status = await Permission.storage.request();
    }
    
    var audioStatus = await Permission.audio.status;
    if (!audioStatus.isGranted) {
      audioStatus = await Permission.audio.request();
    }

    return status.isGranted || audioStatus.isGranted;
  }

  Future<List<SongModel>> fetchLocalSongs() async {
    bool permissionGranted = await requestStoragePermission();
    if (permissionGranted) {
      return await _audioQuery.querySongs(
        sortType: null,
        orderType: OrderType.ASC_OR_SMALLER,
        uriType: UriType.EXTERNAL,
        ignoreCase: true,
      );
    } else {
      return [];
    }
  }
}
