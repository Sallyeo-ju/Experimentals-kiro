import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/ghost_button.dart';
import '../../core/widgets/primary_button.dart';

/// A single onboarding slide.
class _Slide {
  const _Slide({
    required this.icon,
    required this.title,
    required this.body,
  });

  final IconData icon;
  final String title;
  final String body;
}

const List<_Slide> _slides = <_Slide>[
  _Slide(
    icon: Icons.chat_bubble_outline,
    title: 'Tanya saham pakai bahasa sehari-hari',
    body:
        'Ketik pertanyaan seperti ngobrol biasa. BOB menjawab dengan bahasa yang gampang dimengerti, bukan istilah yang bikin pusing.',
  ),
  _Slide(
    icon: Icons.insights_outlined,
    title: 'Teknikal, fundamental, dan berita jadi satu',
    body:
        'Satu ringkasan menggabungkan sinyal teknikal, angka fundamental, dan sentimen berita terbaru, semuanya rapi dalam satu tampilan.',
  ),
  _Slide(
    icon: Icons.shield_outlined,
    title: 'Selalu ingat, riset mandiri tetap penting',
    body:
        'BOB memberi konteks, bukan ajakan beli atau jual. Keputusan tetap di tangan kamu setelah melakukan riset mandiri (DYOR).',
  ),
];

/// Three swipeable intro slides with page indicators, Lewati and Lanjut
/// controls, and a Mulai button on the final slide that moves on to auth.
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _controller = PageController();
  int _index = 0;

  bool get _isLast => _index == _slides.length - 1;

  void _next() {
    if (_isLast) {
      _finish();
      return;
    }
    _controller.nextPage(
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOut,
    );
  }

  void _finish() => context.go(AppRoutes.auth);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme text = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: AppColors.bgBase,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: _finish,
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.textOnTeal2,
                ),
                child: const Text('Lewati'),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: _slides.length,
                onPageChanged: (int value) => setState(() => _index = value),
                itemBuilder: (BuildContext context, int i) {
                  final _Slide slide = _slides[i];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 28),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        // Weighted spacers instead of plain centering. More
                        // room sits above the content, near the already open
                        // Lewati row, and less sits below it, so the block
                        // reads closer to the dots instead of leaving a bare
                        // gap right before them.
                        const Spacer(flex: 3),
                        Container(
                          height: 80,
                          width: 80,
                          decoration: BoxDecoration(
                            color: AppColors.bgElevated,
                            borderRadius:
                                BorderRadius.circular(AppColors.radiusCard),
                          ),
                          child: Icon(
                            slide.icon,
                            color: AppColors.accent,
                            size: 36,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          slide.title,
                          style: text.headlineSmall?.copyWith(
                            color: AppColors.textOnTeal,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          slide.body,
                          style: text.bodyLarge?.copyWith(
                            color: AppColors.textOnTeal2,
                            height: 1.5,
                          ),
                        ),
                        const Spacer(flex: 2),
                      ],
                    ),
                  );
                },
              ),
            ),
            _Dots(count: _slides.length, active: _index),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.fromLTRB(28, 0, 28, 28),
              child: _isLast
                  ? PrimaryButton(label: 'Mulai', onPressed: _finish)
                  : GhostButton(label: 'Lanjut', onPressed: _next),
            ),
          ],
        ),
      ),
    );
  }
}

/// Page indicator dots. The active dot uses the gold accent.
class _Dots extends StatelessWidget {
  const _Dots({required this.count, required this.active});

  final int count;
  final int active;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List<Widget>.generate(count, (int i) {
        final bool isActive = i == active;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          height: 8,
          width: isActive ? 22 : 8,
          decoration: BoxDecoration(
            color: isActive ? AppColors.accent : AppColors.textOnTeal2,
            borderRadius: BorderRadius.circular(AppColors.radiusPill),
          ),
        );
      }),
    );
  }
}
