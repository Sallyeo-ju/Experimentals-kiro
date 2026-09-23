import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../services/models/analysis_models.dart';
import '../../services/models/stock_models.dart';
import 'chat_controller.dart';
import 'widgets/analysis_card.dart';

/// The AI chat screen.
///
/// Teal conversation canvas with a header, a scrolling message list, an animated
/// thinking indicator, and a rounded input with a gold circular send button. It
/// accepts an optional [seed] prompt and [ticker] so it can open pre-seeded from
/// Home or Stock Detail and send the first message automatically.
class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key, this.seed, this.ticker});

  final String? seed;
  final String? ticker;

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final TextEditingController _input = TextEditingController();
  final ScrollController _scroll = ScrollController();

  @override
  void initState() {
    super.initState();
    // Seed the conversation once the first frame is ready so the controller and
    // providers are available.
    WidgetsBinding.instance.addPostFrameCallback((_) => _maybeSeed());
  }

  void _maybeSeed() {
    final String? seed = widget.seed?.trim();
    final String? ticker = widget.ticker?.trim();
    if ((seed == null || seed.isEmpty) && (ticker == null || ticker.isEmpty)) {
      return;
    }
    final String prompt = (seed != null && seed.isNotEmpty)
        ? seed
        : 'Tolong analisis saham $ticker';
    // Opening the chat with a new seed starts a fresh conversation.
    final ChatController controller =
        ref.read(chatControllerProvider.notifier);
    controller.reset();
    controller.sendMessage(prompt, ticker: ticker);
  }

  @override
  void dispose() {
    _input.dispose();
    _scroll.dispose();
    super.dispose();
  }

  void _send() {
    final String text = _input.text.trim();
    if (text.isEmpty) {
      return;
    }
    ref.read(chatControllerProvider.notifier).sendMessage(text);
    _input.clear();
  }

  void _scrollToEnd() {
    if (!_scroll.hasClients) {
      return;
    }
    _scroll.animateTo(
      _scroll.position.maxScrollExtent,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<ChatMessage> messages = ref.watch(chatControllerProvider);
    ref.listen<List<ChatMessage>>(chatControllerProvider, (_, __) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToEnd());
    });

    return Scaffold(
      backgroundColor: AppColors.bgSunken,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            const _ChatHeader(),
            Expanded(
              child: messages.isEmpty
                  ? const _EmptyState()
                  : ListView.separated(
                      controller: _scroll,
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                      itemCount: messages.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (BuildContext context, int index) {
                        return _MessageBubble(message: messages[index]);
                      },
                    ),
            ),
            _ChatInput(controller: _input, onSend: _send),
          ],
        ),
      ),
    );
  }
}

/// The chat header: BOB AI title, a green online status, and a gold B avatar.
class _ChatHeader extends StatelessWidget {
  const _ChatHeader();

  @override
  Widget build(BuildContext context) {
    final TextTheme text = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: AppColors.bgBase,
        border: Border(bottom: BorderSide(color: AppColors.bgSunken)),
      ),
      child: Row(
        children: <Widget>[
          Container(
            height: 40,
            width: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.accent,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Text(
              'B',
              style: TextStyle(
                color: AppColors.textOnAccent,
                fontWeight: FontWeight.w900,
                fontSize: 20,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'BOB AI',
                style: text.titleMedium?.copyWith(
                  color: AppColors.textOnTeal,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Row(
                children: <Widget>[
                  Container(
                    height: 8,
                    width: 8,
                    decoration: const BoxDecoration(
                      color: AppColors.bullish,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Online',
                    style: text.bodySmall?.copyWith(
                      color: AppColors.textOnTeal2,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Shown before any message is sent.
class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    final TextTheme text = Theme.of(context).textTheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Icon(
              Icons.auto_awesome_outlined,
              color: AppColors.accent,
              size: 40,
            ),
            const SizedBox(height: 16),
            Text(
              'Tanya saham apa saja',
              textAlign: TextAlign.center,
              style: text.titleMedium?.copyWith(
                color: AppColors.textOnTeal,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Dapat jawaban yang dimengerti, lengkap dengan sinyal teknikal, '
              'fundamental, dan berita.',
              textAlign: TextAlign.center,
              style: text.bodyMedium?.copyWith(color: AppColors.textOnTeal2),
            ),
          ],
        ),
      ),
    );
  }
}

/// Renders one message. User messages are gold bubbles aligned right. Assistant
/// messages are either the thinking indicator or an analysis card.
class _MessageBubble extends StatelessWidget {
  const _MessageBubble({required this.message});

  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    if (message.isUser) {
      return Align(
        alignment: Alignment.centerRight,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.78,
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.accent,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(AppColors.radiusCard),
                topRight: Radius.circular(AppColors.radiusCard),
                bottomLeft: Radius.circular(AppColors.radiusCard),
                bottomRight: Radius.circular(AppColors.radiusSmall),
              ),
            ),
            child: Text(
              message.text ?? '',
              style: const TextStyle(
                color: AppColors.textOnAccent,
                fontWeight: FontWeight.w600,
                height: 1.35,
              ),
            ),
          ),
        ),
      );
    }

    if (message.isThinking) {
      return const Align(
        alignment: Alignment.centerLeft,
        child: _ThinkingIndicator(),
      );
    }

    final StockAnalysis? analysis = message.analysis;
    if (analysis == null) {
      return const SizedBox.shrink();
    }
    return AnalysisCard(analysis: analysis);
  }
}

/// An animated three-dot thinking indicator with a short status label.
class _ThinkingIndicator extends StatefulWidget {
  const _ThinkingIndicator();

  @override
  State<_ThinkingIndicator> createState() => _ThinkingIndicatorState();
}

class _ThinkingIndicatorState extends State<_ThinkingIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1100),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppColors.radiusCard),
        border: Border.all(color: AppColors.surfaceLine),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          AnimatedBuilder(
            animation: _controller,
            builder: (BuildContext context, _) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: List<Widget>.generate(3, (int i) {
                  final double t = (_controller.value + i * 0.2) % 1.0;
                  final double opacity = 0.3 + 0.7 * (1 - (t - 0.5).abs() * 2);
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: Opacity(
                      opacity: opacity.clamp(0.3, 1.0),
                      child: Container(
                        height: 7,
                        width: 7,
                        decoration: const BoxDecoration(
                          color: AppColors.accentPress,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  );
                }),
              );
            },
          ),
          const SizedBox(width: 10),
          Text(
            'BOB sedang menganalisis...',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }
}

/// The bottom input: a rounded surface field with a gold circular send button.
class _ChatInput extends StatelessWidget {
  const _ChatInput({required this.controller, required this.onSend});

  final TextEditingController controller;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
      color: AppColors.bgBase,
      child: Row(
        children: <Widget>[
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppColors.radiusPill),
                border: Border.all(color: AppColors.surfaceLine),
              ),
              child: TextField(
                controller: controller,
                textInputAction: TextInputAction.send,
                minLines: 1,
                maxLines: 4,
                onSubmitted: (_) => onSend(),
                decoration: const InputDecoration(
                  hintText: 'Tulis pertanyaan kamu',
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  filled: false,
                  isCollapsed: true,
                  contentPadding: EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Material(
            color: AppColors.accent,
            shape: const CircleBorder(),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: onSend,
              child: const Padding(
                padding: EdgeInsets.all(12),
                child: Icon(
                  Icons.send_rounded,
                  color: AppColors.textOnAccent,
                  size: 22,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
