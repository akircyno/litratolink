class AlbumMember {
  const AlbumMember({
    required this.albumId,
    required this.userId,
    required this.role,
    this.email,
    this.displayName,
    this.avatarUrl,
    this.joinedAt,
  });

  final String albumId;
  final String userId;
  final String role;
  final String? email;
  final String? displayName;
  final String? avatarUrl;
  final DateTime? joinedAt;

  String get title {
    final name = displayName?.trim();
    if (name != null && name.isNotEmpty) return name;
    final memberEmail = email?.trim();
    if (memberEmail != null && memberEmail.isNotEmpty) return memberEmail;
    return 'Album member';
  }

  String get subtitle {
    final memberEmail = email?.trim();
    if (memberEmail != null && memberEmail.isNotEmpty && memberEmail != title) {
      return memberEmail;
    }
    return _formatRole(role);
  }

  String get roleLabel => _formatRole(role);

  factory AlbumMember.fromJson(Map<String, dynamic> json) {
    final profile = json['profile'] ?? json['user_profiles'];
    final profileMap = profile is List && profile.isNotEmpty
        ? Map<String, dynamic>.from(profile.first as Map)
        : profile is Map
            ? Map<String, dynamic>.from(profile)
            : <String, dynamic>{};

    return AlbumMember(
      albumId: json['album_id']?.toString() ?? '',
      userId: json['user_id']?.toString() ?? '',
      role: json['role']?.toString() ?? 'viewer',
      email: json['email']?.toString() ?? profileMap['email']?.toString(),
      displayName: json['display_name']?.toString() ??
          profileMap['display_name']?.toString(),
      avatarUrl: json['avatar_url']?.toString() ??
          profileMap['avatar_url']?.toString(),
      joinedAt: DateTime.tryParse(json['joined_at']?.toString() ?? ''),
    );
  }

  static String _formatRole(String role) {
    if (role.isEmpty) return 'Viewer';
    return '${role[0].toUpperCase()}${role.substring(1).toLowerCase()}';
  }
}
