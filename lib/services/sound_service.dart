import 'package:audioplayers/audioplayers.dart';
import 'game_storage.dart';

class SoundService {
  static final AudioPlayer _player = AudioPlayer();

  static Future<void> _play(String asset) async {
    if (!GameStorage.isSoundEnabled()) return;
    try {
      await _player.stop();
      await _player.play(AssetSource(asset));
    } catch (_) {
      // Asset may be a placeholder during development — fail silently
    }
  }

  static Future<void> correct() => _play('sounds/correct.mp3');
  static Future<void> wrong()   => _play('sounds/wrong.mp3');
  static Future<void> hint()    => _play('sounds/hint.mp3');

  static void dispose() => _player.dispose();
}
