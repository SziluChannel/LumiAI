import 'package:flutter/material.dart';

// Egy általános widget a beállítási elemek megjelenítéséhez
class SettingsTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? trailing; // Pl. Switch, Dropdown, Icon
  final VoidCallback? onTap;

  const SettingsTile({
    super.key,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle!) : null,
      trailing: trailing,
      onTap: onTap,
    );
  }
}