import 'dart:math';

import 'package:better_player/better_player.dart';
import 'package:example/constants.dart';
import 'package:flutter/material.dart';

class HlsSubtitlesPage extends StatefulWidget {
  @override
  _HlsSubtitlesPageState createState() => _HlsSubtitlesPageState();
}

class _HlsSubtitlesPageState extends State<HlsSubtitlesPage>{
  late BetterPlayerController _betterPlayerController;

  @override
  void initState() {
    BetterPlayerControlsConfiguration controlsConfiguration =
        BetterPlayerControlsConfiguration(
            controlBarColor: Colors.black26,
            iconsColor: Colors.white,
            playIcon: Icons.play_arrow_outlined,
            progressBarPlayedColor: Colors.indigo,
            progressBarHandleColor: Colors.indigo,
            skipBackIcon: Icons.replay_10_outlined,
            skipForwardIcon: Icons.forward_10_outlined,
            backwardSkipTimeInMilliseconds: 10000,
            forwardSkipTimeInMilliseconds: 10000,
            controlBarHeight: 40,
            loadingColor: Colors.red,
            overflowModalColor: Colors.black54,
            overflowModalTextColor: Colors.white,
            overflowMenuIconsColor: Colors.white,
            playerTheme: BetterPlayerTheme.material);

    BetterPlayerConfiguration betterPlayerConfiguration =
        BetterPlayerConfiguration(
            controlsConfiguration: controlsConfiguration,
            aspectRatio: 16 / 9,
            fit: BoxFit.contain,
            autoPlay: true,
            allowedScreenSleep: false,
        );
    BetterPlayerDataSource dataSource = BetterPlayerDataSource(
      BetterPlayerDataSourceType.network,
      Constants.hlsPlaylistUrl,
    );
    _betterPlayerController = BetterPlayerController(betterPlayerConfiguration);
    _betterPlayerController.setupDataSource(dataSource);
    print('开始播放...');
    super.initState();
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
