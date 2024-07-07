import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';
import 'package:kibiyu/page_one.dart';
import 'dart:io';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin, WidgetsBindingObserver {
  late AudioPlayer audioPlayer;
  bool isPlaying = false;
  late AnimationController _playController;
  late AnimationController _quitController;
  late AnimationController _iyaButtonController;
  late AnimationController _tidakButtonController;
  late AnimationController _silangButtonController;
  late AnimationController _aboutController;
  late AnimationController _titleController;
  late AnimationController _secondaryTitleController;
  late AnimationController _pulseController;
  late Animation<double> _playAnimation;
  late Animation<double> _quitAnimation;
  late Animation<double> _iyaButtonAnimation;
  late Animation<double> _tidakButtonAnimation;
  late Animation<double> _silangButtonAnimation;
  late Animation<double> _aboutAnimation;
  late Animation<double> _titleFadeAnimation;
  late Animation<Offset> _titleSlideAnimation;
  late Animation<double> _pulseAnimation;
  late AnimationController _charaController;
  late AnimationController _kaktusController;

  String soundButton = 'assets/button_sound.png';

  @override
  void initState() {
    super.initState();

    // Menyembunyikan status bar
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    WidgetsBinding.instance.addObserver(this);

    audioPlayer = AudioPlayer();
    playAudio();

    _playController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
      value: 1.0,
      lowerBound: 0.8,
      upperBound: 1.0,
    );
    _quitController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
      value: 1.0,
      lowerBound: 0.8,
      upperBound: 1.0,
    );
    _iyaButtonController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
      value: 1.0,
      lowerBound: 0.8,
      upperBound: 1.0,
    );
    _tidakButtonController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
      value: 1.0,
      lowerBound: 0.8,
      upperBound: 1.0,
    );
    _silangButtonController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
      value: 1.0,
      lowerBound: 0.8,
      upperBound: 1.0,
    );
    _aboutController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
      value: 0.0,
      upperBound: 1.0,
    );

    _titleController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _secondaryTitleController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _charaController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    )..repeat(reverse: true);

    _kaktusController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3),
    )..repeat(reverse: true);

    _playAnimation =
        CurvedAnimation(parent: _playController, curve: Curves.easeInOut);
    _quitAnimation =
        CurvedAnimation(parent: _quitController, curve: Curves.easeInOut);
    _iyaButtonAnimation =
        CurvedAnimation(parent: _iyaButtonController, curve: Curves.easeInOut);
    _tidakButtonAnimation = CurvedAnimation(
        parent: _tidakButtonController, curve: Curves.easeInOut);
    _silangButtonAnimation = CurvedAnimation(
        parent: _silangButtonController, curve: Curves.easeInOut);
    _aboutAnimation =
        CurvedAnimation(parent: _aboutController, curve: Curves.easeInOut);

    _titleFadeAnimation = CurvedAnimation(
      parent: _titleController,
      curve: Curves.easeInOut,
    );

    _titleSlideAnimation = Tween<Offset>(
      begin: Offset(0, -0.5),
      end: Offset(0, 0),
    ).animate(CurvedAnimation(
      parent: _titleController,
      curve: Curves.easeInOut,
    ));

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _titleController.forward();

    _titleController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _secondaryTitleController.forward();
        _pulseController.repeat(reverse: true);
      }
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      // Mengatur ulang mode layar penuh ketika aplikasi kembali dari latar belakang
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    }
  }

  void playAudio() async {
    try {
      await audioPlayer.setAsset('assets/Sound_Homepage.mp3');
      audioPlayer.setLoopMode(LoopMode.one);
      audioPlayer.play();
      setState(() {
        isPlaying = true;
        soundButton = 'assets/button_sound.png';
      });
    } catch (e) {
      print("Error loading audio: $e");
    }
  }

  void stopAudio() async {
    await audioPlayer.stop();
    setState(() {
      isPlaying = false;
      soundButton = 'assets/no_sound.png';
    });
  }

  void toggleAudio() {
    if (isPlaying) {
      stopAudio();
    } else {
      playAudio();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    audioPlayer.dispose();
    _playController.dispose();
    _quitController.dispose();
    _iyaButtonController.dispose();
    _tidakButtonController.dispose();
    _silangButtonController.dispose();
    _aboutController.dispose();
    _titleController.dispose();
    _secondaryTitleController.dispose();
    _pulseController.dispose();
    _charaController.dispose();
    _kaktusController.dispose();
    super.dispose();
  }

  void showQuitPopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ScaleTransition(
          scale: _quitAnimation,
          child: AlertDialog(
            backgroundColor: Colors.transparent,
            content: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Image.asset('assets/pop_up.png'),
                Positioned(
                  top: 0,
                  right: 0,
                  child: GestureDetector(
                    onTapDown: (_) => _silangButtonController.reverse(),
                    onTapUp: (_) => _silangButtonController.forward(),
                    onTapCancel: () => _silangButtonController.forward(),
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: AnimatedBuilder(
                      animation: _silangButtonController,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _silangButtonAnimation.value,
                          child: Image.asset('assets/silang.png', width: 70),
                        );
                      },
                    ),
                  ),
                ),
                Transform.translate(
                  offset: Offset(0, MediaQuery.of(context).size.height * 0.1),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      GestureDetector(
                        onTapDown: (_) => _iyaButtonController.reverse(),
                        onTapUp: (_) => _iyaButtonController.forward(),
                        onTapCancel: () => _iyaButtonController.forward(),
                        onTap: () {
                          exit(0);
                        },
                        child: AnimatedBuilder(
                          animation: _iyaButtonController,
                          builder: (context, child) {
                            return Transform.scale(
                              scale: _iyaButtonAnimation.value,
                              child: Image.asset('assets/iya.png', width: 100),
                            );
                          },
                        ),
                      ),
                      GestureDetector(
                        onTapDown: (_) => _tidakButtonController.reverse(),
                        onTapUp: (_) => _tidakButtonController.forward(),
                        onTapCancel: () => _tidakButtonController.forward(),
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: AnimatedBuilder(
                          animation: _tidakButtonController,
                          builder: (context, child) {
                            return Transform.scale(
                              scale: _tidakButtonAnimation.value,
                              child:
                                  Image.asset('assets/tidak.png', width: 100),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void showAboutPopup() {
    _aboutController.forward();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ScaleTransition(
          scale: _aboutAnimation,
          child: AlertDialog(
            backgroundColor: Colors.transparent,
            content: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Image.asset('assets/pop_up_about.png'),
                Positioned(
                  top: 0,
                  right: 0,
                  child: GestureDetector(
                    onTapDown: (_) => _silangButtonController.reverse(),
                    onTapUp: (_) => _silangButtonController.forward(),
                    onTapCancel: () => _silangButtonController.forward(),
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: AnimatedBuilder(
                      animation: _silangButtonController,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _silangButtonAnimation.value,
                          child: Image.asset('assets/silang.png', width: 70),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ).then((_) => _aboutController.reverse());
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return MaterialApp(
      home: Scaffold(
        extendBody: true,
        body: Stack(
          children: <Widget>[
            Positioned.fill(
              child: Image.asset(
                'assets/home page versi 1.png',
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              top: 10,
              left: 10,
              child: IconButton(
                icon: Image.asset(soundButton),
                onPressed: toggleAudio,
                iconSize: width * 0.1,
              ),
            ),
            Positioned(
              top: 10,
              right: 10,
              child: IconButton(
                icon: Image.asset('assets/about_button.png'),
                onPressed: () {
                  _aboutController.forward(from: 0.0);
                  showAboutPopup();
                },
                iconSize: width * 0.1,
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  FadeTransition(
                    opacity: _titleFadeAnimation,
                    child: SlideTransition(
                      position: _titleSlideAnimation,
                      child: AnimatedBuilder(
                        animation: _pulseController,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: _pulseAnimation.value,
                            child:
                                Image.asset('assets/judul.png', width: 500),
                          );
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 50),

                  // Tombol Main
                  GestureDetector(
                    onTapDown: (_) => _playController.reverse(),
                    onTapUp: (_) => _playController.forward(),
                    onTapCancel: () => _playController.forward(),
                    onTap: () {
                      stopAudio();
                      Navigator.of(context).push(
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  PageOne(),
                          transitionsBuilder: (context, animation,
                              secondaryAnimation, child) {
                            return FadeTransition(
                              opacity: animation,
                              child: child,
                            );
                          },
                        ),
                      );
                    },
                    child: AnimatedBuilder(
                      animation: _playController,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _playAnimation.value,
                          child: Image.asset(
                            'assets/button_play.png',
                            width: width * 0.3,
                            fit: BoxFit.cover,
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 10),
                  GestureDetector(
                    onTapDown: (_) => _quitController.reverse(),
                    onTapUp: (_) => _quitController.forward(),
                    onTapCancel: () => _quitController.forward(),
                    onTap: () {
                      _quitController.forward(from: 0.0);
                      showQuitPopup();
                    },
                    child: AnimatedBuilder(
                      animation: _quitController,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _quitAnimation.value,
                          child: Image.asset(
                            'assets/button_quit.png',
                            width: 200,
                            fit: BoxFit.cover,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            AnimatedBuilder(
              animation: _charaController,
              builder: (context, child) {
                return Positioned(
                  bottom: 0,
                  left: 15,
                  child: Transform.translate(
                    offset: Offset(
                      0.0,
                      20 * _charaController.value,
                    ),
                    child: Image.asset(
                      'assets/chara1.png',
                      width: width * 0.3,
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            ),

            // Animated Kaktus
            AnimatedBuilder(
              animation: _kaktusController,
              builder: (context, child) {
                return Positioned(
                  bottom: 0,
                  right: 20,
                  child: Transform.translate(
                    offset: Offset(
                      0.0,
                      20 * _kaktusController.value,
                    ),
                    child: Image.asset(
                      'assets/kaktus.png',
                      width: width * 0.2,
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
