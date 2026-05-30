import 'package:flutter/material.dart';

import '../../app/theme.dart';
import 'app_button.dart';
import 'role_chip.dart';

class InviteForm extends StatefulWidget {
  const InviteForm({super.key});

  @override
  State<InviteForm> createState() => _InviteFormState();
}

class _InviteFormState extends State<InviteForm> {
  String role = 'Viewer';

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Invite member', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 12),
        const TextField(
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            labelText: 'Email address',
            prefixIcon: Icon(Icons.mail_outline),
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          children: [
            for (final option in ['Admin', 'Contributor', 'Viewer'])
              RoleChip(
                label: option,
                selected: role == option,
                onTap: () => setState(() => role = option),
              ),
          ],
        ),
        const SizedBox(height: 16),
        AppButton(
          label: 'Send Invite',
          icon: Icons.send_outlined,
          onPressed: () {},
        ),
        const SizedBox(height: 8),
        const Text(
          'Admins can invite. Viewers can only view and download originals.',
          style: TextStyle(color: AppColors.mutedInk, fontSize: 12),
        ),
      ],
    );
  }
}
