import 'package:better_player/better_player.dart';
import 'package:example/constants.dart';
import 'package:flutter/material.dart';

class HlsSubtitlesPage extends StatefulWidget {
  @override
  _HlsSubtitlesPageState createState() => _HlsSubtitlesPageState();
}

class _HlsSubtitlesPageState extends State<HlsSubtitlesPage> {
  late BetterPlayerController _betterPlayerController;
  List<String> srcs = Constants.bigestMan;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();

    BetterPlayerControlsConfiguration controlsConfiguration =
        BetterPlayerControlsConfiguration(
      controlBarColor: Colors.black26,
      iconsColor: Colors.white,
      playerTheme: BetterPlayerTheme.material,
      playIcon: Icons.play_arrow_outlined,
      progressBarPlayedColor: Colors.indigo,
      progressBarHandleColor: Colors.indigo,
      skipBackIcon: Icons.replay_10_outlined,
      skipForwardIcon: Icons.forward_10_outlined,
      backwardSkipTimeInMilliseconds: 10000,
      forwardSkipTimeInMilliseconds: 10000,
      enableSkips: true,
      enableFullscreen: true,
      enablePip: true,
      enablePlayPause: true,
      enableMute: true,
      enableAudioTracks: true,
      enableProgressText: true,
      enableSubtitles: true,
      showControlsOnInitialize: true,
      enablePlaybackSpeed: true,
      controlBarHeight: 40,
      loadingColor: Colors.red,
      overflowModalColor: Colors.black54,
      overflowModalTextColor: Colors.white,
      overflowMenuIconsColor: Colors.white
    );

    BetterPlayerConfiguration betterPlayerConfiguration =
        BetterPlayerConfiguration(
            controlsConfiguration: controlsConfiguration,
            // aspectRatio: 16 / 9,
            fit: BoxFit.contain,
            handleLifecycle: true,
            autoPlay: true,
            autoDispose: false,
            startAt: Duration(seconds: 0),
            subtitlesConfiguration: BetterPlayerSubtitlesConfiguration(
              fontSize: 16.0,
            ));
    BetterPlayerDataSource dataSource = BetterPlayerDataSource(
        BetterPlayerDataSourceType.network, Constants.hlsPlaylistUrl,
        notificationConfiguration:
            BetterPlayerNotificationConfiguration(showNotification: true),
        useAsmsSubtitles: true);
    _betterPlayerController = BetterPlayerController(betterPlayerConfiguration);
    // changeUrl(betterPlayerConfiguration);
    _betterPlayerController.addEventsListener(_event);
    play();
  }

  Future<void> play() async {
    // _betterPlayerController.removeEventsListener(_event);
    if (_currentIndex >= srcs.length) _currentIndex = 0;
    BetterPlayerDataSource dataSource = BetterPlayerDataSource(
        BetterPlayerDataSourceType.network, srcs[_currentIndex]);
    await _betterPlayerController.setupDataSource(dataSource);
    _betterPlayerController.seekTo(Duration(seconds: 0));
  }

  void _event(BetterPlayerEvent event) async {
    if (event.betterPlayerEventType == BetterPlayerEventType.finished) {
      _betterPlayerController.clearCache();
      _betterPlayerController.pause();
      _betterPlayerController.seekTo(Duration(seconds: 0));
      _currentIndex++;
      play();
    }
  }

  Future<void> changeUrl(
      BetterPlayerConfiguration betterPlayerConfiguration) async {
    String url1 = 'https://v.cdnlz22.com/20241219/9891_cd2c710e/index.m3u8';
    String url2 = Constants.hlsPlaylistUrl;

    for (int i = 0; i < srcs.length; i++) {
      _betterPlayerController.pause();
      BetterPlayerDataSource dataSource = BetterPlayerDataSource(
          BetterPlayerDataSourceType.network, srcs[i],
          notificationConfiguration:
              BetterPlayerNotificationConfiguration(showNotification: true));
      await _betterPlayerController.setupDataSource(dataSource);
      _betterPlayerController.seekTo(Duration(seconds: 0));

      await Future.delayed(Duration(seconds: 20));
      // await _betterPlayerController.pause();
    }
  }

  @override
  void reassemble() {
    // TODO: implement reassemble
    super.reassemble();
  }

  @override
  void dispose() {
    _betterPlayerController.videoPlayerController?.dispose();
    _betterPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("HLS subtitles"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "Player with HLS stream which loads subtitles from HLS."
                " You can choose subtitles by using overflow menu (3 dots in right corner).",
                style: TextStyle(fontSize: 16),
              ),
            ),
            AspectRatio(
              aspectRatio: 16 / 9,
              child: BetterPlayer(controller: _betterPlayerController),
            ),
          ],
        ),
      ),
    );
  }
}
