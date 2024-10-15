part of '../details_handler.dart';

class _Details extends StatefulWidget {

  const _Details({
    required this.controller,
  });

  final _Controller controller;

  @override
  State<_Details> createState() => __DetailsState();
}

class __DetailsState extends State<_Details> with WidgetsBindingObserver {
  late AudioPlayer player;
  late ScaffoldMessengerState snackbar;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    player = AudioPlayer();
    playAudio();

    super.initState();
  }

  @override
  void didChangeDependencies() {
    snackbar = ScaffoldMessenger.of(context);
    snackbar.clearSnackBars();

    super.didChangeDependencies();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // If the application returns to resume state, then resume de music player.
    if (state == AppLifecycleState.resumed) {
      player.resume();
    }

    // If the application is not in the main view, then stops the music player.
    else {
      player.pause();
    }

    super.didChangeAppLifecycleState(state);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    player.dispose();
    snackbar.clearSnackBars();

    super.dispose();
  }

  /// Play the game's theme audio.
  /// 
  /// Try to load the audio, if for some reason it can't it just doesn't do anything.
  Future<void> playAudio() async {
    try {
      final File file = await widget.controller.audio;
      await player.play(DeviceFileSource(file.path));
    }
    catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: <Widget> [
            Button(
              icon: Icons.arrow_back_rounded,
              onTap: context.pop,
            ),
            _Bookmark(
              controller: widget.controller,
            ),
          ],
        ),
      ),
      body: ListView(
        padding: EdgeInsets.zero,
        physics: const ClampingScrollPhysics(),
        children: <Widget> [
          _Cover(
            controller: widget.controller,
          ),
          _About(
            description: widget.controller.game.description ?? '',
          ),
          _divider(),
          _Preview(
            controller: widget.controller,
          ),
          _divider(),
          _Install(
            controller: widget.controller,
          ),
        ],
      ),
    );
  }

  Widget _divider() {
    return Divider(
      color: Palette.divider.color,
      height: 1,
      thickness: 1,
    );
  }
}