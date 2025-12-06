import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lumiai/core/features/feature_action.dart';
import 'package:lumiai/core/features/feature_controller.dart';
import 'package:lumiai/core/services/feedback_service.dart';
import 'package:lumiai/features/accessibility/font_size_feature.dart';
import 'package:lumiai/features/live_chat/ui/live_chat_screen.dart';
import 'package:lumiai/features/accessibility/color_identifier/color_identifier_screen.dart';
import 'package:lumiai/core/l10n/app_localizations.dart';

class PartialFunctionalUI extends ConsumerWidget {
  const PartialFunctionalUI({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return _buildMenu(context, ref);
  }

  Widget _buildMenu(BuildContext context, WidgetRef ref) {
    final featureController = ref.read(featureControllerProvider.notifier);
    final l10n = AppLocalizations.of(context);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _SectionHeader(title: l10n.objectAndScene),
        _FeatureCard(
          children: [
            _FeatureButton(
              label: l10n.identifyObject,
              icon: Icons.camera_alt,
              onPressed: () {
                featureController.handleAction(FeatureAction.identifyObject);
              },
            ),
          ],
        ),
        const SizedBox(height: 10),
        _FeatureCard(
          children: [
            _FeatureButton(
              label: l10n.describeScene,
              icon: Icons.landscape,
              onPressed: () {
                featureController.handleAction(FeatureAction.describeScene);
              },
            ),
          ],
        ),
        const SizedBox(height: 10),
        _FeatureCard(
          children: [
            _FeatureButton(
              label: l10n.colorIdentifier,
              icon: Icons.palette,
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const ColorIdentifierScreen(),
                  ),
                );
              },
            ),
          ],
        ),
        const SizedBox(height: 20),
        _SectionHeader(title: l10n.textAssistance),
        _FeatureCardRow(
          left: _FeatureButton(
            label: l10n.readText,
            icon: Icons.text_fields,
            onPressed: () {
              featureController.handleAction(FeatureAction.readText);
            },
          ),
          right: _FeatureButton(
            label: l10n.readMenu,
            icon: Icons.restaurant_menu,
            onPressed: () {
              featureController.handleAction(FeatureAction.readMenu);
            },
          ),
        ),
        const SizedBox(height: 20),
        _SectionHeader(title: l10n.dailyHelpers),
        _FeatureCardRow(
          left: _FeatureButton(
            label: l10n.readCurrency,
            icon: Icons.attach_money,
            onPressed: () {
              featureController.handleAction(FeatureAction.readCurrency);
            },
          ),
          right: _FeatureButton(
            label: l10n.describeClothing,
            icon: Icons.checkroom,
            onPressed: () {
              featureController.handleAction(FeatureAction.describeClothing);
            },
          ),
        ),
        const SizedBox(height: 8),
        _FeatureCardRow(
          left: _FeatureButton(
            label: l10n.expiryDate,
            icon: Icons.calendar_today,
            onPressed: () {
              featureController.handleAction(FeatureAction.readExpiryDate);
            },
          ),
          right: _FeatureButton(
            label: l10n.findObject,
            icon: Icons.search,
            onPressed: () {
              _showFindObjectDialog(context, ref, l10n);
            },
          ),
        ),
        const SizedBox(height: 20),
        _SectionHeader(title: l10n.chat),
        _FeatureCard(
          children: [
            _FeatureButton(
              label: l10n.liveChat,
              icon: Icons.chat,
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const LiveChatScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ],
    );
  }

  void _showFindObjectDialog(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
  ) {
    final textController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.findObjectTitle),
        content: TextField(
          controller: textController,
          autofocus: true,
          decoration: InputDecoration(
            hintText: l10n.findObjectHint,
            labelText: l10n.objectName,
          ),
          onSubmitted: (value) {
            if (value.trim().isNotEmpty) {
              Navigator.of(dialogContext).pop();
              ref
                  .read(featureControllerProvider.notifier)
                  .handleActionWithInput(
                    FeatureAction.findObject,
                    value.trim(),
                  );
            }
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              final value = textController.text.trim();
              if (value.isNotEmpty) {
                Navigator.of(dialogContext).pop();
                ref
                    .read(featureControllerProvider.notifier)
                    .handleActionWithInput(FeatureAction.findObject, value);
              }
            },
            child: Text(l10n.search),
          ),
        ],
      ),
    );
  }
}

// --- styled widgets for Partial UI ---

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(title, style: Theme.of(context).textTheme.titleLarge),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final List<Widget> children;
  const _FeatureCard({required this.children});
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Light mode: Indigo-purple | Dark mode: Deep purple-dark blue
    final colors = isDark
        ? [
            const Color(0xFF4A148C), // Deep purple
            const Color(0xFF311B92), // Deep indigo
            const Color(0xFF311B92), // Deep indigo
            const Color(0xFF4A148C), // Deep purple
          ]
        : [
            const Color(0xFF5C6BC0), // Indigo blue
            const Color(0xFF7E57C2), // Soft purple
            const Color(0xFF7E57C2), // Soft purple
            const Color(0xFF5C6BC0), // Indigo blue
          ];

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: colors,
          stops: const [0.0, 0.15, 0.85, 1.0],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: (isDark ? Colors.black : Colors.deepPurple).withAlpha(60),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: children,
        ),
      ),
    );
  }
}

/// A row of separate gradient cards displayed side by side
class _FeatureCardRow extends StatelessWidget {
  final Widget left;
  final Widget right;
  const _FeatureCardRow({required this.left, required this.right});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _SingleFeatureCard(child: left)),
        const SizedBox(width: 10),
        Expanded(child: _SingleFeatureCard(child: right)),
      ],
    );
  }
}

/// A single gradient card containing one feature button
class _SingleFeatureCard extends StatelessWidget {
  final Widget child;
  const _SingleFeatureCard({required this.child});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Light mode: Indigo-purple | Dark mode: Deep purple-dark blue
    final colors = isDark
        ? [
            const Color(0xFF4A148C), // Deep purple
            const Color(0xFF311B92), // Deep indigo
            const Color(0xFF311B92), // Deep indigo
            const Color(0xFF4A148C), // Deep purple
          ]
        : [
            const Color(0xFF5C6BC0), // Indigo blue
            const Color(0xFF7E57C2), // Soft purple
            const Color(0xFF7E57C2), // Soft purple
            const Color(0xFF5C6BC0), // Indigo blue
          ];

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: colors,
          stops: const [0.0, 0.15, 0.85, 1.0],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: (isDark ? Colors.black : Colors.deepPurple).withAlpha(60),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(padding: const EdgeInsets.all(16.0), child: child),
    );
  }
}

class _FeatureButton extends ConsumerWidget {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  const _FeatureButton({
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fontSizeState = ref.watch(fontSizeProvider);
    final double scaleFactor = fontSizeState.scaleFactor;

    return InkWell(
      onTap: () {
        ref.read(feedbackServiceProvider).triggerSuccessFeedback();
        onPressed();
      },
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 120 * scaleFactor, // Scale button width
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Column(
          children: [
            Icon(
              icon,
              size: 40 * scaleFactor,
              color: const Color(0xFFFFD54F), // Vibrant amber/gold
            ), // Scale icon size
            SizedBox(height: 8 * scaleFactor), // Scale spacing
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16 * scaleFactor, // Scale text size
                color: const Color(0xFFFFD54F), // Matching amber/gold
              ),
            ),
          ],
        ),
      ),
    );
  }
}
