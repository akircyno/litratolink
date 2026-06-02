import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/routes.dart';
import '../../../app/theme.dart';
import '../../../core/errors/app_error.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_empty_state.dart';
import '../../../core/widgets/app_screen.dart';
import '../../../core/widgets/invite_form.dart';
import '../../../core/widgets/role_chip.dart';
import '../../auth/providers/auth_provider.dart';
import '../models/album.dart';
import '../models/album_member.dart';
import '../providers/album_provider.dart';

class MembersScreen extends ConsumerWidget {
  const MembersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final routeAlbum = ModalRoute.of(context)?.settings.arguments;
    if (routeAlbum is! Album) {
      return Scaffold(
        appBar: AppBar(title: const Text('Members')),
        body: AppScreen(
          children: [
            AppEmptyState(
              title: 'Album unavailable',
              message: 'Open Members from an album.',
              actionLabel: 'Back to Albums',
              onAction: () =>
                  Navigator.pushReplacementNamed(context, AppRoutes.home),
            ),
          ],
        ),
      );
    }

    final album = routeAlbum;
    final membersAsync = ref.watch(albumMembersProvider(album.id));
    final inviteState = ref.watch(inviteMemberControllerProvider);
    final leaveState = ref.watch(leaveAlbumControllerProvider);
    final currentProfile = ref.watch(currentUserProfileProvider);

    // Navigate home after successful leave
    if (leaveState.left) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) {
          Navigator.pushNamedAndRemoveUntil(
              context, AppRoutes.home, (_) => false);
        }
      });
    }

    final loadedMembers = membersAsync.asData?.value;
    final currentMember = _currentMember(loadedMembers, currentProfile?.id);
    final effectiveRole = currentMember?.role ?? album.role;
    final isAdmin = effectiveRole.toLowerCase() == 'admin';
    final memberCount = loadedMembers?.length ?? album.memberCount;

    return Scaffold(
      body: AppScreen(
        padding: EdgeInsets.zero,
        children: [
          // ── Header ─────────────────────────────────────────────────────
          Container(
            padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
            decoration: const BoxDecoration(
              color: AppColors.deepMaroon,
              borderRadius:
                  BorderRadius.vertical(bottom: Radius.circular(28)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () => Navigator.pop(context),
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    width: 28,
                    height: 28,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.white.withValues(alpha: 0.10),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.chevron_left,
                        color: AppColors.white, size: 18),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Members',
                  style: Theme.of(context)
                      .textTheme
                      .headlineLarge
                      ?.copyWith(color: AppColors.warmCream),
                ),
                const SizedBox(height: 2),
                Text(
                  album.name,
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(color: AppColors.goldLight),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.group_outlined,
                        color: AppColors.warmCream, size: 12),
                    const SizedBox(width: 4),
                    Text(
                      '$memberCount member${memberCount == 1 ? '' : 's'}',
                      style: TextStyle(
                          color: AppColors.warmCream.withValues(alpha: 0.70),
                          fontSize: 12),
                    ),
                    const SizedBox(width: 12),
                    const Icon(Icons.verified_user_outlined,
                        color: AppColors.warmCream, size: 12),
                    const SizedBox(width: 4),
                    Text(
                      'Your role: ${_roleLabel(effectiveRole)}',
                      style: TextStyle(
                          color: AppColors.warmCream.withValues(alpha: 0.70),
                          fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // ── Invite form (admin only) ────────────────────────────────────
          if (isAdmin) ...[
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: AppCard(
                child: InviteForm(
                  isSending: inviteState.isSending,
                  successMessage: inviteState.successMessage,
                  errorMessage: inviteState.errorMessage,
                  onInvite: (email, role) {
                    return ref
                        .read(inviteMemberControllerProvider.notifier)
                        .invite(
                          albumId: album.id,
                          email: email,
                          role: role,
                        );
                  },
                ),
              ),
            ),
          ],

          // ── Member list ────────────────────────────────────────────────
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text('Members',
                style: Theme.of(context).textTheme.titleLarge),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: membersAsync.when(
              loading: () => const Center(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child:
                      CircularProgressIndicator(color: AppColors.softGold),
                ),
              ),
              error: (err, _) => AppEmptyState(
                title: 'Members unavailable',
                message: AppError.messageFor(err),
                actionLabel: 'Try Again',
                onAction: () =>
                    ref.invalidate(albumMembersProvider(album.id)),
              ),
              data: (members) => Column(
                children: [
                  for (final member in members) ...[
                    _MemberRow(
                      member: member,
                      isCurrentUser: member.userId == currentProfile?.id,
                      canManageMember:
                          isAdmin && member.userId != currentProfile?.id,
                      canEditRole: member.email?.isNotEmpty == true,
                      isSaving: inviteState.isSending,
                      onRoleSelected: (role) {
                        final email = member.email;
                        if (email == null || email.isEmpty) return;
                        ref
                            .read(inviteMemberControllerProvider.notifier)
                            .invite(
                              albumId: album.id,
                              email: email,
                              role: role,
                            );
                      },
                      onRemoveSelected: () => _confirmRemoveMember(
                        context,
                        ref,
                        album: album,
                        member: member,
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                ],
              ),
            ),
          ),

          // ── Leave button (non-admin only) ──────────────────────────────
          if (!isAdmin) ...[
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: leaveState.errorMessage != null
                  ? Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Text(
                        leaveState.errorMessage!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            color: AppColors.maroon,
                            fontSize: 12,
                            fontWeight: FontWeight.w700),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: AppButton(
                label: leaveState.isLeaving ? 'Leaving...' : 'Leave this album',
                icon: Icons.exit_to_app_outlined,
                secondary: true,
                onPressed: leaveState.isLeaving
                    ? null
                    : () => _confirmLeave(context, ref, album: album),
              ),
            ),
          ],

          const SizedBox(height: 28),
        ],
      ),
    );
  }

  Future<void> _confirmRemoveMember(
    BuildContext context,
    WidgetRef ref, {
    required Album album,
    required AlbumMember member,
  }) async {
    final confirmed = await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Remove member?'),
            content: Text('Remove ${member.title} from ${album.name}?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(false),
                child: const Text('Cancel'),
              ),
              FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.maroon,
                  foregroundColor: AppColors.white,
                ),
                onPressed: () => Navigator.of(ctx).pop(true),
                child: const Text('Remove'),
              ),
            ],
          ),
        ) ??
        false;

    if (!confirmed || !context.mounted) return;

    await ref.read(inviteMemberControllerProvider.notifier).remove(
          albumId: album.id,
          member: member,
        );
  }

  Future<void> _confirmLeave(
    BuildContext context,
    WidgetRef ref, {
    required Album album,
  }) async {
    final confirmed = await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Leave album?'),
            content: Text(
                'You will lose access to all files in "${album.name}". The Admin can re-invite you later.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(false),
                child: const Text('Cancel'),
              ),
              FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.maroon,
                  foregroundColor: AppColors.white,
                ),
                onPressed: () => Navigator.of(ctx).pop(true),
                child: const Text('Leave'),
              ),
            ],
          ),
        ) ??
        false;

    if (!confirmed || !context.mounted) return;

    await ref
        .read(leaveAlbumControllerProvider.notifier)
        .leave(albumId: album.id);
  }

  AlbumMember? _currentMember(List<AlbumMember>? members, String? profileId) {
    if (members == null || profileId == null || profileId.isEmpty) return null;
    for (final member in members) {
      if (member.userId == profileId) return member;
    }
    return null;
  }

  String _roleLabel(String role) {
    if (role.isEmpty) return 'Viewer';
    return '${role[0].toUpperCase()}${role.substring(1).toLowerCase()}';
  }
}

class _MemberRow extends StatelessWidget {
  const _MemberRow({
    required this.member,
    this.isCurrentUser = false,
    this.canManageMember = false,
    this.canEditRole = false,
    this.isSaving = false,
    this.onRoleSelected,
    this.onRemoveSelected,
  });

  final AlbumMember member;
  final bool isCurrentUser;
  final bool canManageMember;
  final bool canEditRole;
  final bool isSaving;
  final ValueChanged<String>? onRoleSelected;
  final VoidCallback? onRemoveSelected;

  @override
  Widget build(BuildContext context) {
    final normalizedRole = member.role.toLowerCase();

    return AppCard(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: isCurrentUser
                ? AppColors.maroon
                : AppColors.maroonFaint,
            foregroundColor:
                isCurrentUser ? AppColors.white : AppColors.maroon,
            child: Text(
              member.title.substring(0, 1).toUpperCase(),
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        member.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 12),
                      ),
                    ),
                    if (isCurrentUser) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.maroonFaint,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text('You',
                            style: TextStyle(
                                color: AppColors.maroon,
                                fontSize: 9,
                                fontWeight: FontWeight.w600)),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  member.subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style:
                      const TextStyle(color: AppColors.mutedInk, fontSize: 11),
                ),
              ],
            ),
          ),
          RoleChip(label: member.roleLabel, selected: true),
          if (canManageMember) ...[
            const SizedBox(width: 4),
            PopupMenuButton<String>(
              enabled: !isSaving,
              tooltip: 'Manage member',
              icon: const Icon(Icons.more_horiz,
                  color: AppColors.mutedInk, size: 18),
              onSelected: (value) {
                if (value == 'remove') {
                  onRemoveSelected?.call();
                  return;
                }
                if (value == normalizedRole) return;
                onRoleSelected?.call(value);
              },
              itemBuilder: (context) => [
                if (canEditRole) ...const [
                  PopupMenuItem(value: 'admin', child: Text('Admin')),
                  PopupMenuItem(
                      value: 'contributor', child: Text('Contributor')),
                  PopupMenuItem(value: 'viewer', child: Text('Viewer')),
                  PopupMenuDivider(),
                ],
                const PopupMenuItem(
                  value: 'remove',
                  child: Text('Remove member'),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
