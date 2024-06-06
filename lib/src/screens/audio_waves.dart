import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vedanta_frontend/src/controllers/audio_recorder_controller.dart';

class AudioWavesView extends StatefulWidget {
  const AudioWavesView({super.key});

  @override
  State<AudioWavesView> createState() => _AudioWavesViewState();
}

class _AudioWavesViewState extends State<AudioWavesView> {
  final ScrollController scrollController = ScrollController();
  List<double> amplitudes = [];
  late StreamSubscription<double> amplitudeSubscription;

  double wavesMaxHeight = 50;
  final double minimumAmpl = -50;

  @override
  void initState() {
    super.initState();
    final audioRecorderController = context.read<AudioRecorderController>();
    amplitudeSubscription =
        audioRecorderController.amplitudeStream.listen((amp) {
      setState(() {
        amplitudes.add(amp);
      });

      if (scrollController.positions.isNotEmpty) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          curve: Curves.linear,
          duration: const Duration(milliseconds: 160),
        );
      }
    });
  }

  @override
  void dispose() {
    amplitudeSubscription.cancel();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: wavesMaxHeight,
      child: ListView.builder(
        controller: scrollController,
        itemCount: amplitudes.length,
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          double amplitude = amplitudes[index].clamp(minimumAmpl + 1, 0);
          double amplPercentage = 1 - (amplitude / minimumAmpl).abs();
          double waveHeight = wavesMaxHeight * amplPercentage;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2.0),
            child: Center(
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: waveHeight),
                duration: const Duration(milliseconds: 120),
                curve: Curves.decelerate,
                builder: (context, animatedWaveHeight, child) {
                  return SizedBox(
                    height: animatedWaveHeight,
                    width: 8,
                    child: child,
                  );
                },
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.purple,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
