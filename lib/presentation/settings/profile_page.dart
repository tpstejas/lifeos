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

/// Profile page - View and manage user profile
/// Called by: GoRouter route '/settings/profile' from providers.dart appRouterProvider
/// Data schemas: Reads User entity from userRepositoryProvider, writes via userRepositoryProvider.updateUser()
/// User instruction: "yes alto start building all one by one with useing everything we have in our laptop 300 skills also 71 agents many more got it"
class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> with LoggerMixin {
  User? _user;
  bool _isLoading = true;
  bool _isEditing = false;
  bool _isSaving = false;

  final TextEditingController _displayNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  @override
  void dispose() {
    _displayNameController.dispose();
    _emailController.dispose();
    super.dispose();
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
            _displayNameController.text = user?.displayName ?? '';
            _emailController.text = user?.email ?? '';
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
        _showSnackBar('Failed to load profile');
      }
    }
  }

  Future<void> _saveProfile() async {
    if (_user == null) return;

    setState(() => _isSaving = true);

    try {
      final userRepository = ref.read(userRepositoryProvider);
      final updatedUser = _user!.copyWith(
        displayName: _displayNameController.text.trim().isEmpty
            ? null
            : _displayNameController.text.trim(),
        email: _emailController.text.trim(),
        updatedAt: DateTime.now(),
      );
      await userRepository.updateUser(updatedUser);
      if (mounted) {
        setState(() {
          _user = updatedUser;
          _isEditing = false;
        });
        _showSnackBar('Profile updated!');
      }
    } catch (e) {
      logE('Failed to save profile', error: e);
      if (mounted) {
        _showSnackBar('Failed to save: $e');
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
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
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          if (!_isLoading && _user != null)
            TextButton(
              onPressed: _isSaving
                  ? null
                  : (_isEditing ? _saveProfile : () => setState(() => _isEditing = true)),
              child: Text(_isEditing ? 'Save' : 'Edit'),
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _user == null
              ? _buildNotLoggedIn()
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Avatar
                      Stack(
                        children: [
                          CircleAvatar(
                            radius: 60,
                            backgroundColor: theme.colorScheme.primaryContainer,
                            backgroundImage: _user!.photoUrl != null
                                ? NetworkImage(_user!.photoUrl!)
                                : null,
                            child: _user!.photoUrl == null
                                ? Text(
                                    _user!.displayName?.isNotEmpty == true
                                        ? _user!.displayName![0].toUpperCase()
                                        : _user!.email?[0].toUpperCase() ?? '?',
                                    style: theme.textTheme.headlineLarge?.copyWith(
                                      color: theme.colorScheme.onPrimaryContainer,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  )
                                : null,
                          ),
                          if (_isEditing)
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.primary,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: theme.colorScheme.surface, width: 3),
                                ),
                                child: IconButton(
                                  icon: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                                  onPressed: _pickImage,
                                  tooltip: 'Change photo',
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Display name
                      TextFormField(
                        controller: _displayNameController,
                        enabled: _isEditing,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        decoration: InputDecoration(
                          labelText: 'Display Name',
                          border: _isEditing ? const OutlineInputBorder() : InputBorder.none,
                          hintText: 'Enter your name',
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Email
                      TextFormField(
                        controller: _emailController,
                        enabled: _isEditing && false, // Email change requires verification
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        decoration: InputDecoration(
                          labelText: 'Email',
                          border: InputBorder.none,
                          helperText: _isEditing ? 'Email changes require verification' : null,
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Account info
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Account',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 16),
                              _InfoRow(
                                label: 'User ID',
                                value: _user!.id,
                                icon: Icons.badge,
                              ),
                              _InfoRow(
                                label: 'Account Type',
                                value: _user!.isPremium ? 'Premium' : 'Free',
                                icon: _user!.isPremium ? Icons.workspace_premium : Icons.person,
                                valueColor: _user!.isPremium ? Colors.amber : null,
                              ),
                              _InfoRow(
                                label: 'Member Since',
                                value: _formatDate(_user!.createdAt),
                                icon: Icons.calendar_today,
                              ),
                              _InfoRow(
                                label: 'Last Active',
                                value: _formatDate(_user!.updatedAt),
                                icon: Icons.access_time,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Stats
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Statistics',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Expanded(child: _StatItem(label: 'Items', value: _user!.stats.totalItems.toString())),
                                  Expanded(child: _StatItem(label: 'Collections', value: _user!.stats.collectionsCount.toString())),
                                  Expanded(child: _StatItem(label: 'Chats', value: _user!.stats.chatSessionsCount.toString())),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Expanded(child: _StatItem(label: 'Digests', value: _user!.stats.digestsGenerated.toString())),
                                  Expanded(child: _StatItem(label: 'Tasks', value: _user!.stats.tasksCompleted.toString())),
                                  Expanded(child: _StatItem(label: 'Storage', value: _formatBytes(_user!.stats.storageUsedBytes))),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Actions
                      if (!_isEditing) ...[
                        FilledButton.tonalIcon(
                          onPressed: () => context.push('/settings/subscription'),
                          icon: const Icon(Icons.workspace_premium),
                          label: const Text('Manage Subscription'),
                        ),
                        const SizedBox(height: 12),
                        OutlinedButton.icon(
                          onPressed: _signOut,
                          icon: const Icon(Icons.logout),
                          label: const Text('Sign Out'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.red,
                          ),
                        ),
                      ],
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
            Icon(Icons.person_outline, size: 80, color: theme.colorScheme.onSurfaceVariant),
            const SizedBox(height: 16),
            Text(
              'Not Signed In',
              style: theme.textTheme.headlineSmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Sign in to view and manage your profile',
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

  void _pickImage() {
    _showSnackBar('Image picker coming soon');
  }

  Future<void> _signOut() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Out?'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        final authRepository = ref.read(authRepositoryProvider);
        await authRepository.signOut();
        if (mounted) {
          context.go('/auth');
        }
      } catch (e) {
        logE('Failed to sign out', error: e);
        if (mounted) {
          _showSnackBar('Failed to sign out');
        }
      }
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.label,
    required this.value,
    required this.icon,
    this.valueColor,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: theme.colorScheme.onSurfaceVariant),
          const SizedBox(width: 12),
          Text(
            '$label: ',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
                color: valueColor,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Text(
          value,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.primary,
          ),
        ),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}