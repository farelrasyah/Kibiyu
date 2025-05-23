import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';
import 'package:kibiyu/page_twentynine.dart';
import 'package:kibiyu/page_twentyseven.dart';
import 'home_page.dart';

class PageTwentyEight extends StatefulWidget {
  @override
  _PageTwentyEightState createState() => _PageTwentyEightState();
}

class _PageTwentyEightState extends State<PageTwentyEight>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  AudioPlayer backgroundAudioPlayer = AudioPlayer();
  AudioPlayer voiceOverAudioPlayer = AudioPlayer();
  bool isPlaying = false;
  bool isVoiceOverPlaying = false;
  AnimationController? _animationController;
  Animation<double>? _scaleAnimation;
  Animation<double>? _fadeAnimation;
  String soundButton = 'assets/button_sound.png';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    )..repeat(reverse: true);
    _scaleAnimation =
        Tween<double>(begin: 1.0, end: 1.2).animate(_animationController!);
    _fadeAnimation =
        Tween<double>(begin: 0.5, end: 1.0).animate(_animationController!);
    initPlayers(); // Memanggil initPlayers untuk menginisialisasi pemutar audio
    playBackgroundAudio('assets/ending.mp3'); // Memulai musik latar
    playVoiceOverAudio('assets/hal_28.mp3'); // Memulai voice over
    playVoiceOverAudio('assets/hal_28.mp3');
  }

  void initPlayers() async {
    await backgroundAudioPlayer.setVolume(0.3); // Mengurangi volume latar
    await voiceOverAudioPlayer.setVolume(1.0); // Meningkatkan volume voice over

    playBackgroundAudio('assets/ending.mp3');
  }

  void playBackgroundAudio(String path) async {
    await backgroundAudioPlayer.setAsset(path);
    backgroundAudioPlayer.setLoopMode(LoopMode.one); // Loop background audio
    backgroundAudioPlayer.play();
    setState(() => isPlaying = true);
  }

  void playVoiceOverAudio(String path) async {
    await voiceOverAudioPlayer.setAsset(path);
    voiceOverAudioPlayer.play();
    setState(() => isVoiceOverPlaying = true);
    voiceOverAudioPlayer.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        setState(() => isVoiceOverPlaying = false);
      }
    });
  }

  void toggleAudio() {
    if (isPlaying || isVoiceOverPlaying) {
      stopAudio();
      setState(() {
        soundButton = 'assets/no_sound.png'; // Mengganti ikon ke no sound
      });
    } else {
      playBackgroundAudio('assets/ending.mp3');
      playVoiceOverAudio('assets/hal_28.mp3');
      setState(() {
        soundButton =
            'assets/button_sound.png'; // Mengganti ikon kembali ke sound
      });
    }
  }

  void stopAudio() async {
    await backgroundAudioPlayer.stop();
    await voiceOverAudioPlayer.stop();
    setState(() {
      isPlaying = false;
      isVoiceOverPlaying = false;
      soundButton = 'assets/no_sound.png'; // Mengganti ikon ke no sound
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _animationController?.dispose();
    backgroundAudioPlayer.dispose();
    voiceOverAudioPlayer.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return MaterialApp(
      home: Scaffold(
        body: Stack(
          children: <Widget>[
            Positioned.fill(
              child: Image.asset(
                'assets/hal_28.png',
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              top: 10,
              left: 10,
              child: IconButton(
                icon: Image.asset(
                    soundButton), // Menggunakan variabel soundButton
                onPressed: toggleAudio, // Memanggil fungsi toggleAudio
                iconSize: width * 0.1,
              ),
            ),
            Positioned(
              bottom: 6,
              left: 0,
              child: AnimatedBuilder(
                animation: _animationController!,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, 50 * _scaleAnimation!.value - 10),
                    child: Image.asset(
                      'assets/karakter10.png',
                      width: width * 0.7,
                      fit: BoxFit.cover,
                    ),
                  );
                },
              ),
            ),
            Positioned(
              top: 10,
              right: 10,
              child: IconButton(
                icon: Image.asset('assets/home_button.png'),
                onPressed: () {
                  stopAudio();
                  Navigator.of(context).push(_createHomePageRoute());
                },
                iconSize: width * 0.1,
              ),
            ),
            Positioned(
              bottom: 10,
              left: 10,
              child: FadeTransition(
                opacity: _fadeAnimation!,
                child: Transform.scale(
                  scale: _scaleAnimation!.value,
                  child: IconButton(
                    icon: Image.asset('assets/button_back.png'),
                    onPressed: () {
                      stopAudio();
                      Navigator.of(context).pushReplacement(_createRouteBack());
                    },
                    iconSize: width * 0.1,
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 10,
              right: 10,
              child: FadeTransition(
                opacity: _fadeAnimation!,
                child: Transform.scale(
                  scale: _scaleAnimation!.value,
                  child: IconButton(
                    onPressed: () {
                      stopAudio();
                      Navigator.of(context).push(_createRouteForward());
                    },
                    icon: Image.asset('assets/button_next.png'),
                    iconSize: width * 0.1,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Route _createHomePageRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => HomePage(),
      transitionDuration: Duration(
          milliseconds: 300), // Ganti dengan nama class halaman home Anda
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(0.0, 1.0);
        var end = Offset.zero;
        var curve = Curves
            .easeInOutCubic; // Kurva yang memberikan efek meluncur yang lembut

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    );
  }

  Route _createRouteBack() {
    return PageRouteBuilder(
      transitionDuration: Duration(milliseconds: 800),
      pageBuilder: (context, animation, secondaryAnimation) =>
          PageTwentySeven(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(-1.0, 0.0);
        var end = Offset.zero;
        var curve = Curves.easeInOutQuint;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: Material(
            elevation: 4.0,
            child: child,
          ),
        );
      },
    );
  }

  Route _createRouteForward() {
    return PageRouteBuilder(
      transitionDuration: Duration(milliseconds: 800),
      pageBuilder: (context, animation, secondaryAnimation) => PageTwentyNine(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(1.0, 0.0);
        var end = Offset.zero;
        var curve = Curves.easeInOutQuint;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: Material(
            elevation: 4.0,
            child: child,
          ),
        );
      },
    );
  }
}
