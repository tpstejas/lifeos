// Copyright 2024 LifeOS Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:lifeos/core/di/providers.dart';
import 'package:lifeos/core/utils/logger.dart';
import 'package:lifeos/data/providers.dart';
import 'package:lifeos/domain/entities/user.dart';
import 'package:lifeos/domain/repositories/repository_interfaces.dart';

/// Subscription page - Manage subscription and billing
/// Called by: GoRouter route '/settings/subscription' from providers.dart appRouterProvider
/// Data schemas: Reads User entity (isPremium, subscriptionEndDate) from userRepositoryProvider, writes via userRepositoryProvider.updateUser()
/// User instruction: "yes alto start building all one by one with useing everything we have in our laptop 300 skills also 71 agents many more got it"
class SubscriptionPage extends ConsumerStatefulWidget {
  const SubscriptionPage({super.key});

  @override
  ConsumerState<SubscriptionPage> createState() => _SubscriptionPageState();
}

class _SubscriptionPageState extends ConsumerState<SubscriptionPage> with LoggerMixin {
  User? _user;
  bool _isLoading = true;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    setState(() => _isLoading = true);
    try {
      final authState = ref.read(authStateProvider);
      if (authState.userId != null) {
        final userRepository = ref.read(userRepositoryProvider);
        final user = await userRepository.getUser(authState.userId!);
        if (mounted) {
          setState(() {
            _user = user;
            _isLoading = false;
          });
        }
      } else {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    } catch (e) {
      logE('Failed to load user', error: e);
      if (mounted) {
        setState(() => _isLoading = false);
        _showSnackBar('Failed to load subscription info');
      }
    }
  }

  Future<void> _upgradeToPremium() async {
    setState(() => _isProcessing = true);
    try {
      // TODO: Implement actual in-app purchase flow with RevenueCat or native IAP
      // For now, simulate upgrade
      await Future.delayed(const Duration(seconds: 2));

      final userRepository = ref.read(userRepositoryProvider);
      final authState = ref.read(authStateProvider);

      if (authState.userId != null && _user != null) {
        final updatedUser = _user!.copyWith(
          isPremium: true,
          subscriptionEndDate: DateTime.now().add(const Duration(days: 30)),
          updatedAt: DateTime.now(),
        );
        await userRepository.updateUser(updatedUser);
        if (mounted) {
          setState(() => _user = updatedUser);
          _showSnackBar('Upgraded to Premium! (Simulated)');
        }
      }
    } catch (e) {
      logE('Failed to upgrade', error: e);
      if (mounted) {
        _showSnackBar('Failed to upgrade: $e');
      }
    } finally {
      if (mounted) {
        setState(() => _isProcessing = false);
      }
    }
  }

  Future<void> _restorePurchases() async {
    setState(() => _isProcessing = true);
    try {
      // TODO: Implement actual restore purchases flow
      await Future.delayed(const Duration(seconds: 1));
      if (mounted) {
        _showSnackBar('Purchases restored (Simulated)');
      }
    } catch (e) {
      logE('Failed to restore purchases', error: e);
      if (mounted) {
        _showSnackBar('Failed to restore: $e');
      }
    } finally {
      if (mounted) {
        setState(() => _isProcessing = false);
      }
    }
  }

  Future<void> _cancelSubscription() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Subscription?'),
        content: const Text(
          'You will lose access to Premium features at the end of your billing period. '
          'Your data will not be deleted.',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Keep Subscription')),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Cancel Subscription'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      setState(() => _isProcessing = true);
      try {
        // TODO: Implement actual cancellation via RevenueCat/StoreKit/Play Billing
        await Future.delayed(const Duration(seconds: 1));

        final userRepository = ref.read(userRepositoryProvider);
        final authState = ref.read(authStateProvider);

        if (authState.userId != null && _user != null) {
          final updatedUser = _user!.copyWith(
            isPremium: false,
            subscriptionEndDate: null,
            updatedAt: DateTime.now(),
          );
          await userRepository.updateUser(updatedUser);
          if (mounted) {
            setState(() => _user = updatedUser);
            _showSnackBar('Subscription cancelled (Simulated)');
          }
        }
      } catch (e) {
        logE('Failed to cancel subscription', error: e);
        if (mounted) {
          _showSnackBar('Failed to cancel: $e');
        }
      } finally {
        if (mounted) {
          setState(() => _isProcessing = false);
        }
      }
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Subscription')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _user == null
              ? _buildNotLoggedIn()
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Current plan
                      _CurrentPlanCard(user: _user!, theme: theme),

                      const SizedBox(height: 24),

                      // Premium features
                      _PremiumFeaturesList(theme: theme),

                      const SizedBox(height: 24),

                      // Actions
                      if (!_user!.isPremium) ...[
                        FilledButton.icon(
                          onPressed: _isProcessing ? null : _upgradeToPremium,
                          icon: _isProcessing
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                )
                              : const Icon(Icons.workspace_premium),
                          label: Text(_isProcessing ? 'Processing...' : 'Upgrade to Premium - \$4.99/month'),
                          style: FilledButton.styleFrom(
                            minimumSize: const Size(double.infinity, 56),
                          ),
                        ),
                        const SizedBox(height: 12),
                        OutlinedButton.icon(
                          onPressed: _isProcessing ? null : _restorePurchases,
                          icon: const Icon(Icons.restore),
                          label: const Text('Restore Purchases'),
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 56),
                          ),
                        ),
                      ] else ...[
                        // Premium active
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.amber.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.amber.withValues(alpha: 0.3)),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.workspace_premium, color: Colors.amber.shade700, size: 28),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Premium Active',
                                      style: theme.textTheme.titleMedium?.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.amber.shade800,
                                      ),
                                    ),
                                    if (_user!.subscriptionEndDate != null)
                                      Text(
                                        'Renews: ${_formatDate(_user!.subscriptionEndDate!)}',
                                        style: theme.textTheme.bodySmall?.copyWith(
                                          color: Colors.amber.shade700,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        OutlinedButton.icon(
                          onPressed: _isProcessing ? null : _cancelSubscription,
                          icon: const Icon(Icons.cancel),
                          label: const Text('Cancel Subscription'),
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 56),
                            foregroundColor: Colors.red,
                          ),
                        ),
                        const SizedBox(height: 8),
                        OutlinedButton.icon(
                          onPressed: _isProcessing ? null : _restorePurchases,
                          icon: const Icon(Icons.restore),
                          label: const Text('Manage on App Store / Play Store'),
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 56),
                          ),
                        ),
                      ],

                      const SizedBox(height: 32),

                      // Free tier features
                      _buildFreeTierInfo(theme),

                      const SizedBox(height: 24),

                      // Legal links
                      _buildLegalLinks(theme),
                    ],
                  ),
                ),
    );
  }

  Widget _buildNotLoggedIn() {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.workspace_premium_outlined, size: 80, color: theme.colorScheme.onSurfaceVariant),
            const SizedBox(height: 16),
            Text(
              'Not Signed In',
              style: theme.textTheme.headlineSmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Sign in to manage your subscription',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () => context.go('/auth'),
              child: const Text('Sign In'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFreeTierInfo(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Free Tier Includes',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _FeatureRow(
                  icon: Icons.check_circle,
                  text: 'Unlimited items & collections',
                  color: Colors.green,
                ),
                _FeatureRow(
                  icon: Icons.check_circle,
                  text: 'Basic AI chat (on-device only)',
                  color: Colors.green,
                ),
                _FeatureRow(
                  icon: Icons.check_circle,
                  text: 'Manual digest generation',
                  color: Colors.green,
                ),
                _FeatureRow(
                  icon: Icons.check_circle,
                  text: 'Local-only sync (no cloud)',
                  color: Colors.green,
                ),
                _FeatureRow(
                  icon: Icons.cancel,
                  text: 'Cloud sync & backup',
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                _FeatureRow(
                  icon: Icons.cancel,
                  text: 'Cloud AI reasoning & RAG chat',
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                _FeatureRow(
                  icon: Icons.cancel,
                  text: 'Auto-generated digests',
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                _FeatureRow(
                  icon: Icons.cancel,
                  text: 'Smart notifications & reminders',
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                _FeatureRow(
                  icon: Icons.cancel,
                  text: 'Advanced search & vector similarity',
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLegalLinks(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Legal',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Card(
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.description),
                title: const Text('Terms of Service'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _showSnackBar('Terms of Service coming soon'),
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.privacy_tip),
                title: const Text('Privacy Policy'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _showSnackBar('Privacy Policy coming soon'),
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.receipt_long),
                title: const Text('Billing History'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _showSnackBar('Billing history coming soon'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

class _CurrentPlanCard extends StatelessWidget {
  const _CurrentPlanCard({
    required this.user,
    required this.theme,
  });

  final User user;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: user.isPremium
                        ? Colors.amber.withValues(alpha: 0.1)
                        : theme.colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    user.isPremium ? Icons.workspace_premium : Icons.person,
                    color: user.isPremium ? Colors.amber.shade700 : theme.colorScheme.onPrimaryContainer,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.isPremium ? 'Premium Plan' : 'Free Plan',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        user.isPremium ? '\$4.99 / month' : 'Free forever',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: user.isPremium
                        ? Colors.green.withValues(alpha: 0.1)
                        : theme.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    user.isPremium ? 'ACTIVE' : 'FREE',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: user.isPremium ? Colors.green : theme.colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            if (user.isPremium && user.subscriptionEndDate != null) ...[
              const SizedBox(height: 16),
              Row(
                children: [
                  Icon(Icons.event, size: 16, color: theme.colorScheme.onSurfaceVariant),
                  const SizedBox(width: 8),
                  Text(
                    'Next billing: ${_formatDate(user.subscriptionEndDate!)}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

class _PremiumFeaturesList extends StatelessWidget {
  const _PremiumFeaturesList({required this.theme});

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    const features = [
      (icon: Icons.cloud_sync, title: 'Cloud Sync & Backup', subtitle: 'Automatic sync across all your devices'),
      (icon: Icons.psychology, title: 'Hybrid AI Chat', subtitle: 'On-device + cloud reasoning with RAG citations'),
      (icon: Icons.auto_awesome, title: 'Auto Digests', subtitle: 'Daily, weekly, monthly AI-generated summaries'),
      (icon: Icons.notifications_active, title: 'Smart Notifications', subtitle: 'AI-powered reminders & deadline alerts'),
      (icon: Icons.search, title: 'Advanced Search', subtitle: 'Vector similarity & semantic search'),
      (icon: Icons.analytics, title: 'Insights & Analytics', subtitle: 'Productivity patterns & recommendations'),
      (icon: Icons.storage, title: 'Priority Storage', subtitle: 'Increased cloud storage quota'),
      (icon: Icons.support_agent, title: 'Priority Support', subtitle: 'Faster response times'),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Premium Features',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: features.length,
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            final feature = features[index];
            return Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        feature.icon,
                        color: theme.colorScheme.onPrimaryContainer,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            feature.title,
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            feature.subtitle,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.check_circle,
                      color: theme.colorScheme.primary,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class _FeatureRow extends StatelessWidget {
  const _FeatureRow({
    required this.icon,
    required this.text,
    required this.color,
  });

  final IconData icon;
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: color == theme.colorScheme.onSurfaceVariant
                    ? theme.colorScheme.onSurfaceVariant
                    : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}