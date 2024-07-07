import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; 
import 'dart:math';
import 'package:just_audio/just_audio.dart';
import 'package:kibiyu/page_two.dart';
import 'package:kibiyu/page_four.dart';
import 'home_page.dart';

class PageThree extends StatefulWidget {
  @override
  _PageThreeState createState() => _PageThreeState();
}

class _PageThreeState extends State<PageThree>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  AudioPlayer backgroundAudioPlayer = AudioPlayer();
  AudioPlayer voiceOverAudioPlayer = AudioPlayer();
  bool isPlaying = false;
  bool isVoiceOverPlaying = false;
  AnimationController? _animationController;
  Animation<double>? _scaleAnimation;
  Animation<double>? _fadeAnimation;
  Animation<double>? _rotationAnimation;
  String soundButton = 'assets/button_sound.png';

  @override
  void initState() {
    super.initState();
        WidgetsBinding.instance.addObserver(this);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky); 
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 20), // Rotasi lebih lambat
    )..repeat(); // Animasi akan berputar terus menerus tanpa reverse
    _rotationAnimation = Tween<double>(begin: 0.0, end: 2 * pi).animate(
      CurvedAnimation(
        parent: _animationController!,
        curve: Curves.linear, // Animasi bergerak dengan kecepatan konstan
      ),
    );
    _scaleAnimation =
        Tween<double>(begin: 1.0, end: 1.2).animate(_animationController!);
    _fadeAnimation =
        Tween<double>(begin: 0.5, end: 1.0).animate(_animationController!);

    initPlayers(); // Memanggil initPlayers untuk menginisialisasi pemutar audio
    playBackgroundAudio('assets/perawalan.mp3'); // Memulai musik latar
    playVoiceOverAudio('assets/hal_3.mp3'); // Memulai voice over
  }

  void initPlayers() async {
    await backgroundAudioPlayer.setVolume(0.3); // Mengurangi volume latar
    await voiceOverAudioPlayer.setVolume(1.0); // Meningkatkan volume voice over
    playBackgroundAudio('assets/perawalan.mp3');
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
      playBackgroundAudio('assets/perawalan.mp3');
      playVoiceOverAudio('assets/hal_3.mp3');
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
                  'assets/hal_3.png',
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
                top: 10,
                left: 60,
                child: AnimatedBuilder(
                  animation: _animationController!,
                  builder: (context, child) {
                    return Transform.rotate(
                      angle: _rotationAnimation!.value,
                      child: Image.asset(
                        'assets/cahaya.png',
                        width: width * 0.1,
                        fit: BoxFit.cover,
                      ),
                    );
                  },
                ),
              ),
              Positioned(
                top: 1,
                left: 150,
                child: AnimatedBuilder(
                  animation: _animationController!,
                  builder: (context, child) {
                    return Transform.rotate(
                      angle: _rotationAnimation!.value,
                      child: Image.asset(
                        'assets/cahaya.png',
                        width: width * 0.1,
                        fit: BoxFit.cover,
                      ),
                    );
                  },
                ),
              ),
              Positioned(
                top: 80,
                left: 300,
                child: AnimatedBuilder(
                  animation: _animationController!,
                  builder: (context, child) {
                    return Transform.rotate(
                      angle: _rotationAnimation!.value,
                      child: Image.asset(
                        'assets/cahaya.png',
                        width: width * 0.1,
                        fit: BoxFit.cover,
                      ),
                    );
                  },
                ),
              ),
              Positioned(
                top: 180,
                left: 270,
                child: AnimatedBuilder(
                  animation: _animationController!,
                  builder: (context, child) {
                    return Transform.rotate(
                      angle: _rotationAnimation!.value,
                      child: Image.asset(
                        'assets/cahaya.png',
                        width: width * 0.1,
                        fit: BoxFit.cover,
                      ),
                    );
                  },
                ),
              ),
              Positioned(
                top: 150,
                left: 350,
                child: AnimatedBuilder(
                  animation: _animationController!,
                  builder: (context, child) {
                    return Transform.rotate(
                      angle: _rotationAnimation!.value,
                      child: Image.asset(
                        'assets/cahaya.png',
                        width: width * 0.1,
                        fit: BoxFit.cover,
                      ),
                    );
                  },
                ),
              ),
              Positioned(
                top: 100,
                left: 200,
                child: AnimatedBuilder(
                  animation: _animationController!,
                  builder: (context, child) {
                    return Transform.rotate(
                      angle: _rotationAnimation!.value,
                      child: Image.asset(
                        'assets/cahaya.png',
                        width: width * 0.1,
                        fit: BoxFit.cover,
                      ),
                    );
                  },
                ),
              ),
              Positioned(
                top: 90,
                left: 100,
                child: AnimatedBuilder(
                  animation: _animationController!,
                  builder: (context, child) {
                    return Transform.rotate(
                      angle: _rotationAnimation!.value,
                      child: Image.asset(
                        'assets/cahaya.png',
                        width: width * 0.1,
                        fit: BoxFit.cover,
                      ),
                    );
                  },
                ),
              ),
              Positioned(
                top: 270,
                left: 230,
                child: AnimatedBuilder(
                  animation: _animationController!,
                  builder: (context, child) {
                    return Transform.rotate(
                      angle: _rotationAnimation!.value,
                      child: Image.asset(
                        'assets/cahaya.png',
                        width: width * 0.1,
                        fit: BoxFit.cover,
                      ),
                    );
                  },
                ),
              ),
              Positioned(
                top: 250,
                left: 330,
                child: AnimatedBuilder(
                  animation: _animationController!,
                  builder: (context, child) {
                    return Transform.rotate(
                      angle: _rotationAnimation!.value,
                      child: Image.asset(
                        'assets/cahaya.png',
                        width: width * 0.1,
                        fit: BoxFit.cover,
                      ),
                    );
                  },
                ),
              ),
              Positioned(
                top: 320,
                left: 330,
                child: AnimatedBuilder(
                  animation: _animationController!,
                  builder: (context, child) {
                    return Transform.rotate(
                      angle: _rotationAnimation!.value,
                      child: Image.asset(
                        'assets/cahaya.png',
                        width: width * 0.1,
                        fit: BoxFit.cover,
                      ),
                    );
                  },
                ),
              ),
               Positioned(
                top: 230,
                left: 400,
                child: AnimatedBuilder(
                  animation: _animationController!,
                  builder: (context, child) {
                    return Transform.rotate(
                      angle: _rotationAnimation!.value,
                      child: Image.asset(
                        'assets/cahaya.png',
                        width: width * 0.1,
                        fit: BoxFit.cover,
                      ),
                    );
                  },
                ),
              ),
              Positioned(
                bottom: 3,
                left: 10,
                child: AnimatedBuilder(
                  animation: _animationController!,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(0, 20 * _scaleAnimation!.value - 10),
                      child: Image.asset(
                        'assets/karakter3.png',
                        width: width * 0.4,
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
                        Navigator.of(context)
                            .pushReplacement(_createRouteBack());
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
      pageBuilder: (context, animation, secondaryAnimation) => PageTwo(),
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
      pageBuilder: (context, animation, secondaryAnimation) => PageFour(),
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
