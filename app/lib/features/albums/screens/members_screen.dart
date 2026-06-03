import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/routes.dart';
import '../../../app/theme.dart';
import '../../../core/errors/app_error.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_empty_state.dart';
import '../../../core/widgets/app_screen.dart';
import '../../../core/widgets/invite_form.dart';
import '../../../core/widgets/pressable_scale.dart';
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
    final bottomPad = MediaQuery.of(context).padding.bottom;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: AppColors.warmCream,
        body: Column(
          children: [
            _Header(
              album: album,
              memberCount: memberCount,
              roleLabel: _roleLabel(effectiveRole),
              onBack: () => Navigator.pop(context),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                    AppSpacing.md, AppSpacing.lg, AppSpacing.md, AppSpacing.lg + bottomPad),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Invite form (admin only) ───────────────────────────
                    if (isAdmin) ...[
                      AppCard(
                        child: InviteForm(
                          isSending: inviteState.isSending,
                          successMessage: inviteState.successMessage,
                          errorMessage: inviteState.errorMessage,
                          onInvite: (email, role) => ref
                              .read(inviteMemberControllerProvider.notifier)
                              .invite(
                                albumId: album.id,
                                email: email,
                                role: role,
                              ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                    ],

                    // ── Section heading ────────────────────────────────────
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 2, bottom: AppSpacing.sm),
                      child: Text(
                        'People in this space.',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),

                    // ── Member list ────────────────────────────────────────
                    membersAsync.when(
                      loading: () => const Padding(
                        padding: EdgeInsets.all(32),
                        child: Center(
                          child: CircularProgressIndicator(
                            color: AppColors.brightGold,
                            strokeWidth: 2,
                          ),
                        ),
                      ),
                      error: (err, _) => AppEmptyState(
                        title: 'Could not load members',
                        message: AppError.messageFor(err),
                        actionLabel: 'Try Again',
                        onAction: () =>
                            ref.invalidate(albumMembersProvider(album.id)),
                      ),
                      data: (members) => Column(
                        children: [
                          for (final member in members)
                            Padding(
                              padding: const EdgeInsets.only(
                                  bottom: AppSpacing.sm),
                              child: _MemberRow(
                                member: member,
                                isCurrentUser:
                                    member.userId == currentProfile?.id,
                                canManageMember: isAdmin &&
                                    member.userId != currentProfile?.id,
                                canEditRole:
                                    member.email?.isNotEmpty == true,
                                isSaving: inviteState.isSending,
                                onRoleSelected: (role) {
                                  final email = member.email;
                                  if (email == null || email.isEmpty) return;
                                  ref
                                      .read(inviteMemberControllerProvider
                                          .notifier)
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
                            ),
                        ],
                      ),
                    ),

                    // ── Leave button (non-admin) ───────────────────────────
                    if (!isAdmin) ...[
                      const SizedBox(height: AppSpacing.xl),
                      if (leaveState.errorMessage != null) ...[
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Text(
                            leaveState.errorMessage!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: AppColors.velvetMaroon,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                      _LeaveButton(
                        isLeaving: leaveState.isLeaving,
                        onLeave: leaveState.isLeaving
                            ? null
                            : () => _confirmLeave(context, ref, album: album),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
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
                  backgroundColor: AppColors.velvetMaroon,
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
            title: const Text('Leave this space?'),
            content: Text(
                'You\'ll lose access to all files in "${album.name}". The admin can invite you back later.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(false),
                child: const Text('Cancel'),
              ),
              FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.velvetMaroon,
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
    for (final m in members) {
      if (m.userId == profileId) return m;
    }
    return null;
  }

  String _roleLabel(String role) {
    if (role.isEmpty) return 'Viewer';
    return '${role[0].toUpperCase()}${role.substring(1).toLowerCase()}';
  }
}

// ── Private widgets ───────────────────────────────────────────────────────────

class _Header extends StatelessWidget {
  const _Header({
    required this.album,
    required this.memberCount,
    required this.roleLabel,
    required this.onBack,
  });

  final Album album;
  final int memberCount;
  final String roleLabel;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.of(context).padding.top;
    return Container(
      decoration: const BoxDecoration(
        gradient: AppGradients.header,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
      ),
      padding: EdgeInsets.fromLTRB(16, top + 12, 16, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PressableScale(
            onTap: onBack,
            borderRadius: BorderRadius.circular(10),
            child: Container(
              width: 32,
              height: 32,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.white.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.chevron_left,
                  color: AppColors.white, size: 20),
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'People in this space.',
            style: TextStyle(
              fontFamily: AppTheme.headingFont,
              color: AppColors.pearlCream,
              fontSize: 22,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            album.name,
            style: TextStyle(
              color: AppColors.warmCream.withValues(alpha: 0.55),
              fontSize: 13,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _MetaChip(
                icon: Icons.group_outlined,
                label: '$memberCount member${memberCount == 1 ? '' : 's'}',
              ),
              const SizedBox(width: 10),
              _MetaChip(
                icon: Icons.verified_user_outlined,
                label: roleLabel,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  const _MetaChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon,
            color: AppColors.warmCream.withValues(alpha: 0.55), size: 12),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            color: AppColors.warmCream.withValues(alpha: 0.55),
            fontSize: 12,
          ),
        ),
      ],
    );
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
    final initial = member.title.isNotEmpty
        ? member.title[0].toUpperCase()
        : '?';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(
          color: isCurrentUser
              ? AppColors.velvetMaroon.withValues(alpha: 0.18)
              : AppColors.creamLine,
          width: 0.8,
        ),
        boxShadow: AppShadows.card,
      ),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 38,
            height: 38,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isCurrentUser
                  ? AppColors.velvetMaroon
                  : AppColors.maroonFaint,
              shape: BoxShape.circle,
            ),
            child: Text(
              initial,
              style: TextStyle(
                fontFamily: AppTheme.headingFont,
                fontWeight: FontWeight.w700,
                fontSize: 14,
                color: isCurrentUser
                    ? AppColors.pearlCream
                    : AppColors.velvetMaroon,
              ),
            ),
          ),
          const SizedBox(width: 10),

          // Name + subtitle
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
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                          color: AppColors.charcoalInk,
                        ),
                      ),
                    ),
                    if (isCurrentUser) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.velvetMaroon
                              .withValues(alpha: 0.10),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'You',
                          style: TextStyle(
                            color: AppColors.velvetMaroon,
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  member.subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.featherTaupe,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),

          // Role chip
          RoleChip(label: member.roleLabel, selected: true),

          // Manage menu (admin only)
          if (canManageMember) ...[
            const SizedBox(width: 2),
            PopupMenuButton<String>(
              enabled: !isSaving,
              tooltip: 'Manage member',
              icon: const Icon(Icons.more_horiz,
                  color: AppColors.featherTaupe, size: 18),
              shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(AppSpacing.radiusMd)),
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
                  child: Text(
                    'Remove member',
                    style: TextStyle(color: AppColors.velvetMaroon),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _LeaveButton extends StatelessWidget {
  const _LeaveButton({required this.isLeaving, required this.onLeave});

  final bool isLeaving;
  final VoidCallback? onLeave;

  @override
  Widget build(BuildContext context) {
    return PressableScale(
      onTap: onLeave,
      borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      child: Container(
        height: 52,
        width: double.infinity,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          border: Border.all(
            color: AppColors.velvetMaroon.withValues(alpha: 0.30),
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isLeaving
                  ? Icons.hourglass_top_rounded
                  : Icons.exit_to_app_outlined,
              color: AppColors.velvetMaroon,
              size: 17,
            ),
            const SizedBox(width: 8),
            Text(
              isLeaving ? 'Leaving...' : 'Leave this album',
              style: const TextStyle(
                color: AppColors.velvetMaroon,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
