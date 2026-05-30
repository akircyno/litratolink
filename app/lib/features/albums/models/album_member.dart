class AlbumMember {
  const AlbumMember({
    required this.albumId,
    required this.userId,
    required this.role,
  });

  final String albumId;
  final String userId;
  final String role;

  factory AlbumMember.fromJson(Map<String, dynamic> json) {
    return AlbumMember(
      albumId: json['album_id']?.toString() ?? '',
      userId: json['user_id']?.toString() ?? '',
      role: json['role']?.toString() ?? 'viewer',
    );
  }
}
