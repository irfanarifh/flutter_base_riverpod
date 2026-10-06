import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_template/core/config/env.dart';
import 'package:flutter_template/core/extensions/context_extension.dart';
import 'package:flutter_template/core/theme/app_radius.dart';
import 'package:flutter_template/core/theme/app_spacing.dart';
import 'package:flutter_template/features/settings/controller/locale_controller.dart';
import 'package:flutter_template/features/settings/controller/theme_mode_controller.dart';
import 'package:flutter_template/shared/providers/auth_actions_provider.dart';
import 'package:flutter_template/shared/widgets/dialogs/confirm_dialog.dart';
import 'package:flutter_template/shared/widgets/layout/app_scaffold.dart';
import 'package:flutter_template/shared/widgets/layout/section_header.dart';

/// Settings screen providing theme, localization, application information,
/// and decoupled session termination.
class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({
    super.key,
    this.onLogout,
  });

  /// Optional callback to trigger logout. If null, falls back to [logoutActionProvider].
  final Future<void> Function()? onLogout;

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  Future<void> _handleLogout() async {
    final confirmed = await ConfirmDialog.show(
      context,
      title: context.l10n.logout,
      message: 'Are you sure you want to log out of your account?',
      confirmLabel: context.l10n.logout,
      cancelLabel: context.l10n.cancel,
      isDestructive: true,
    );

    if (confirmed && mounted) {
      final logoutCallback = widget.onLogout;
      if (logoutCallback != null) {
        await logoutCallback();
      } else {
        await ref.read(logoutActionProvider)();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = context.theme;
    final colorScheme = context.colorScheme;

    final currentTheme = ref.watch(themeModeControllerProvider);
    final currentLocale = ref.watch(localeControllerProvider);

    return AppScaffold(
      appBar: AppBar(
        title: Text(l10n.settings),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
        children: [
          SectionHeader(title: l10n.theme),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: SegmentedButton<ThemeMode>(
              segments: [
                ButtonSegment(
                  value: ThemeMode.system,
                  label: Text(l10n.themeSystem),
                  icon: const Icon(Icons.brightness_auto),
                ),
                ButtonSegment(
                  value: ThemeMode.light,
                  label: Text(l10n.themeLight),
                  icon: const Icon(Icons.light_mode),
                ),
                ButtonSegment(
                  value: ThemeMode.dark,
                  label: Text(l10n.themeDark),
                  icon: const Icon(Icons.dark_mode),
                ),
              ],
              selected: {currentTheme},
              onSelectionChanged: (selection) {
                ref
                    .read(themeModeControllerProvider.notifier)
                    .setThemeMode(selection.first);
              },
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          SectionHeader(title: l10n.language),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: SegmentedButton<String>(
              segments: [
                ButtonSegment(
                  value: 'en',
                  label: Text(l10n.languageEnglish),
                  icon: const Icon(Icons.language),
                ),
                ButtonSegment(
                  value: 'id',
                  label: Text(l10n.languageIndonesian),
                  icon: const Icon(Icons.translate),
                ),
              ],
              selected: {currentLocale?.languageCode ?? 'en'},
              onSelectionChanged: (selection) {
                ref
                    .read(localeControllerProvider.notifier)
                    .setLocale(Locale(selection.first));
              },
            ),
          ),
          const Divider(height: AppSpacing.xl),
          const SectionHeader(title: 'Account & Application'),
          ListTile(
            leading: Icon(Icons.logout, color: colorScheme.error),
            title: Text(
              l10n.logout,
              style: TextStyle(
                color: colorScheme.error,
                fontWeight: FontWeight.w600,
              ),
            ),
            shape: const RoundedRectangleBorder(borderRadius: AppRadius.roundedMd),
            onTap: _handleLogout,
          ),
          const Divider(height: AppSpacing.xl),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      Env.appName,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      'Flavor: ${Env.flavor.name.toUpperCase()}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    Text(
                      'Base URL: ${Env.baseUrl}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
