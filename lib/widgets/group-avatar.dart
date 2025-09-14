// widgets/group_avatar.dart
import 'package:chatthing/models/user-model.dart';
import 'package:flutter/material.dart';

class GroupAvatar extends StatelessWidget {
  final List<User> members;
  final double radius;

  const GroupAvatar({super.key, required this.members, this.radius = 28});

  @override
  Widget build(BuildContext context) {
    // مرتب‌سازی برای اینکه پروفایل "ما" همیشه اول باشد
    final sortedMembers = List<User>.from(members)
      ..sort((a, b) => a.type == UserType.me ? -1 : 1);

    final displayedMembers = sortedMembers.take(3).toList();

    return SizedBox(
      width: (radius * 2) + (displayedMembers.length - 1) * (radius * 0.7),
      height: radius * 2,
      child: Stack(
        children: List.generate(displayedMembers.length, (index) {
          final member = displayedMembers[index];
          final bool isEllipsis = members.length > 3 && index == 2;

          return Positioned(
            left: index * (radius * 0.7),
            child: CircleAvatar(
              radius: radius,
              backgroundColor: Colors.white.withOpacity(0.8),
              child: CircleAvatar(
                radius: radius - 2, // برای ایجاد حاشیه سفید
                backgroundColor: isEllipsis
                    ? Colors.grey.shade700
                    : _getAvatarColor(member.name),
                child: isEllipsis
                    ? const Icon(Icons.more_horiz, color: Colors.white, size: 24)
                    : Icon(
                        member.type == UserType.me
                            ? Icons.person_rounded // آیکون برای ما
                            : Icons.smart_toy_outlined, // آیکون برای دیگران
                        color: Colors.white.withOpacity(0.9),
                      ),
              ),
            ),
          );
        }),
      ),
    );
  }

  // یک تابع کمکی برای ایجاد رنگ‌های مختلف برای آواتارها
  Color _getAvatarColor(String name) {
    return Colors.primaries[name.hashCode % Colors.primaries.length].shade700;
  }
}