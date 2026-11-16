// Copyright 2024 LifeOS Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:lifeos/core/config/app_config.dart';
import 'package:lifeos/core/di/providers.dart';
import 'package:lifeos/core/utils/logger.dart';

/// Settings page
class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> with LoggerMixin {
  @override
  Widget build(BuildContext context) {
    final theme = ref.watch(themeProvider);
    final authState = ref.watch(authStateProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Account section
          _SectionHeader(title: 'Account'),
          _SettingsTile(
            leading: authState.isAuthenticated
                ? CircleAvatar(
                    backgroundImage: authState.photoUrl != null
                        ? NetworkImage(authState.photoUrl!)
                        : null,
                    child: authState.photoUrl == null
                        ? Text(authState.displayName
                                ?.substring(0, 1)
                                .toUpperCase() ??
                            'U')
                        : null,
                  )
                : const CircleAvatar(child: Icon(Icons.person)),
            title: authState.isAuthenticated
                ? (authState.displayName ?? 'Signed in')
                : 'Sign in',
            subtitle: authState.isAuthenticated
                ? authState.email ?? 'Anonymous'
                : 'Sign in to sync across devices',
            trailing: authState.isAuthenticated
                ? TextButton(
                    onPressed: () => _signOut(ref),
                    child: const Text('Sign Out'),
                  )
                : FilledButton(
                    onPressed: () => _signIn(ref),
                    child: const Text('Sign In'),
                  ),
            onTap: authState.isAuthenticated ? null : () => _signIn(ref),
          ),

          const SizedBox(height: 24),

          // Appearance section
          _SectionHeader(title: 'Appearance'),
          _SettingsTile(
            leading: Icon(
              theme.themeMode == ThemeMode.dark
                  ? Icons.dark_mode
                  : theme.themeMode == ThemeMode.light
                      ? Icons.light_mode
                      : Icons.brightness_auto,
            ),
            title: 'Theme',
            subtitle: _getThemeSubtitle(theme.themeMode),
            trailing: PopupMenuButton<ThemeMode>(
              initialValue: theme.themeMode,
              onSelected: (mode) =>
                  ref.read(themeProvider.notifier).setThemeMode(mode),
              itemBuilder: (context) => const [
                PopupMenuItem(value: ThemeMode.system, child: Text('System')),
                PopupMenuItem(value: ThemeMode.light, child: Text('Light')),
                PopupMenuItem(value: ThemeMode.dark, child: Text('Dark')),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // AI Settings section
          _SectionHeader(title: 'AI Settings'),
          _SettingsTile(
            leading: const Icon(Icons.smart_toy),
            title: 'Inference Preference',
            subtitle: _getInferenceSubtitle(AppConfig.inferencePreference),
            trailing: PopupMenuButton<InferencePreference>(
              initialValue: AppConfig.inferencePreference,
              onSelected: (pref) async {
                await AppConfig.setInferencePreference(pref);
                setState(() {});
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                    value: InferencePreference.auto, child: Text('Auto')),
                const PopupMenuItem(
                    value: InferencePreference.preferOnDevice,
                    child: Text('Prefer On-Device')),
                const PopupMenuItem(
                    value: InferencePreference.preferCloud,
                    child: Text('Prefer Cloud')),
                const PopupMenuItem(
                    value: InferencePreference.forceOnDevice,
                    child: Text('Force On-Device')),
                const PopupMenuItem(
                    value: InferencePreference.forceCloud,
                    child: Text('Force Cloud')),
              ],
            ),
          ),

          _SettingsTile(
            leading: const Icon(Icons.privacy_tip),
            title: 'Privacy Mode',
            subtitle: 'Force on-device processing only',
            trailing: Switch(
              value: AppConfig.inferencePreference ==
                  InferencePreference.forceOnDevice,
              onChanged: (value) async {
                if (value) {
                  await AppConfig.setInferencePreference(
                      InferencePreference.forceOnDevice);
                } else {
                  await AppConfig.setInferencePreference(
                      InferencePreference.auto);
                }
                setState(() {});
              },
            ),
          ),

          const SizedBox(height: 24),

          // Sync section
          _SectionHeader(title: 'Sync & Backup'),
          _SettingsTile(
            leading: const Icon(Icons.sync),
            title: 'Auto Sync',
            subtitle: 'Automatically sync when online',
            trailing: Switch(
              value: AppConfig.syncEnabled,
              onChanged: (value) async {
                await AppConfig.setSyncEnabled(value);
                setState(() {});
              },
            ),
          ),

          _SettingsTile(
            leading: const Icon(Icons.cloud_upload),
            title: 'Sync Now',
            subtitle: 'Manually trigger sync',
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _syncNow(ref),
          ),

          _SettingsTile(
            leading: const Icon(Icons.backup),
            title: 'Export Data',
            subtitle: 'Download all your data as JSON',
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _exportData(ref),
          ),

          const SizedBox(height: 24),

          // Notifications section
          _SectionHeader(title: 'Notifications'),
          _SettingsTile(
            leading: const Icon(Icons.notifications),
            title: 'Push Notifications',
            subtitle: 'Receive digests and reminders',
            trailing: Switch(
              value: AppConfig.notificationsEnabled,
              onChanged: (value) async {
                await AppConfig.setNotificationsEnabled(value);
                setState(() {});
              },
            ),
          ),

          _SettingsTile(
            leading: const Icon(Icons.fingerprint),
            title: 'Biometric Lock',
            subtitle: 'Require biometric to open app',
            trailing: Switch(
              value: AppConfig.biometricEnabled,
              onChanged: (value) async {
                await AppConfig.setBiometricEnabled(value);
                setState(() {});
              },
            ),
          ),

          const SizedBox(height: 24),

          // About section
          _SectionHeader(title: 'About'),
          _SettingsTile(
            leading: const Icon(Icons.info),
            title: 'Version',
            subtitle: '1.0.0 (Build 1)',
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showVersionInfo(),
          ),

          _SettingsTile(
            leading: const Icon(Icons.article),
            title: 'Privacy Policy',
            subtitle: 'Read our privacy policy',
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _launchUrl('https://lifeos.app/privacy'),
          ),

          _SettingsTile(
            leading: const Icon(Icons.gavel),
            title: 'Terms of Service',
            subtitle: 'Read our terms of service',
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _launchUrl('https://lifeos.app/terms'),
          ),

          _SettingsTile(
            leading: const Icon(Icons.star),
            title: 'Rate LifeOS',
            subtitle: 'Help us improve',
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _launchUrl('https://apps.apple.com/app/lifeos'),
          ),

          _SettingsTile(
            leading: const Icon(Icons.share),
            title: 'Share LifeOS',
            subtitle: 'Tell your friends about LifeOS',
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _shareApp(),
          ),

          const SizedBox(height: 24),

          // Danger zone
          _SectionHeader(title: 'Danger Zone'),
          _SettingsTile(
            leading: Icon(Icons.delete_forever, color: Colors.red),
            title: 'Clear All Local Data',
            subtitle: 'Remove all local data (keeps cloud backup)',
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _clearLocalData(),
            titleStyle: TextStyle(color: Colors.red),
          ),

          _SettingsTile(
            leading: Icon(Icons.delete_forever, color: Colors.red),
            title: 'Delete Account',
            subtitle: 'Permanently delete your account and all data',
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _deleteAccount(),
            titleStyle: TextStyle(color: Colors.red),
          ),
        ],
      ),
    );
  }

  String _getThemeSubtitle(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.system:
        return 'Follows system setting';
      case ThemeMode.light:
        return 'Always light';
      case ThemeMode.dark:
        return 'Always dark';
    }
  }

  String _getInferenceSubtitle(InferencePreference pref) {
    switch (pref) {
      case InferencePreference.auto:
        return 'Automatically choose best option';
      case InferencePreference.preferOnDevice:
        return 'Prefer on-device, fallback to cloud';
      case InferencePreference.preferCloud:
        return 'Prefer cloud, fallback to on-device';
      case InferencePreference.forceOnDevice:
        return 'Always use on-device (privacy mode)';
      case InferencePreference.forceCloud:
        return 'Always use cloud (max capability)';
    }
  }

  void _signIn(WidgetRef ref) {
    logD('Sign in tapped');
    ref.read(authStateProvider.notifier).signInAnonymously();
  }

  void _signOut(WidgetRef ref) {
    logD('Sign out tapped');
    ref.read(authStateProvider.notifier).signOut();
  }

  void _syncNow(WidgetRef ref) {
    logD('Sync now tapped');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Sync started...')),
    );
  }

  void _exportData(WidgetRef ref) {
    logD('Export data tapped');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Export feature coming soon')),
    );
  }

  void _showVersionInfo() {
    showAboutDialog(
      context: context,
      applicationName: 'LifeOS',
      applicationVersion: '1.0.0',
      applicationIcon:
          const Icon(Icons.psychology, size: 48, color: Color(0xFF6366F1)),
      children: [
        const Text('Your Second Brain with Hybrid AI'),
        const SizedBox(height: 8),
        const Text('Built with Flutter & Firebase AI Logic'),
      ],
    );
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  void _shareApp() {
    Share.share(
      'Check out LifeOS - Your Second Brain with Hybrid AI! '
      'Capture everything. Organize automatically. Chat with your life. '
      'https://lifeos.app',
      subject: 'LifeOS - Your Second Brain',
    );
  }

  void _clearLocalData() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All Local Data?'),
        content: const Text(
          'This will remove all locally stored items, embeddings, and settings. '
          'Your cloud backup will not be affected.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.pop(context);
              await AppConfig.clearAll();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Local data cleared')),
              );
            },
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  void _deleteAccount() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account?'),
        content: const Text(
          'This will permanently delete your account and ALL data including '
          'cloud backups. This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Account deletion not implemented yet')),
              );
            },
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

/// Section header widget
class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
      ),
    );
  }
}

/// Settings tile widget
class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.leading,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.titleStyle,
  });

  final Widget leading;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final TextStyle? titleStyle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: leading,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleSmall
                          ?.copyWith(
                            fontWeight: FontWeight.w600,
                          )
                          .merge(titleStyle),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        subtitle!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (trailing != null) trailing!,
            ],
          ),
        ),
      ),
    );
  }
}
