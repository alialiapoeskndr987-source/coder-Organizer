import 'package:flutter/material.dart';

/// Preset icon registry for nodes (FR-03: icon on every level).
const Map<String, IconData> kNodeIcons = {
  'folder': Icons.folder_outlined,
  'code': Icons.code,
  'web': Icons.language,
  'cart': Icons.shopping_cart_outlined,
  'mail': Icons.mail_outline,
  'cloud': Icons.cloud_outlined,
  'phone': Icons.smartphone_outlined,
  'game': Icons.sports_esports_outlined,
  'brush': Icons.brush_outlined,
  'server': Icons.dns_outlined,
  'school': Icons.school_outlined,
  'rocket': Icons.rocket_launch_outlined,
  'bug': Icons.bug_report_outlined,
  'extension': Icons.extension_outlined,
  'chart': Icons.insights_outlined,
  'store': Icons.storefront_outlined,
  'money': Icons.attach_money,
  'book': Icons.menu_book_outlined,
  'key': Icons.vpn_key_outlined,
  'devices': Icons.devices_outlined,
  'terminal': Icons.terminal_outlined,
  'database': Icons.storage_outlined,
  'api': Icons.api_outlined,
  'globe': Icons.public_outlined,
  'star': Icons.star_border_outlined,
  'work': Icons.work_outline,
  'person': Icons.person_outline,
  'idea': Icons.lightbulb_outline,
  'chat': Icons.chat_bubble_outline,
  'doc': Icons.article_outlined,
  'layers': Icons.layers_outlined,
  'link': Icons.link,
};

IconData iconFor(String key) => kNodeIcons[key] ?? Icons.folder_outlined;

/// Icon picker dialog (FR-03: change icon at any level).
Future<String?> pickIconDialog(BuildContext context, String current) {
  return showDialog<String>(
    context: context,
    builder: (ctx) => AlertDialog(
      contentPadding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
      content: SizedBox(
        width: 320,
        child: GridView.builder(
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 56,
            mainAxisSpacing: 6,
            crossAxisSpacing: 6,
          ),
          itemCount: kNodeIcons.length,
          itemBuilder: (ctx, i) {
            final e = kNodeIcons.entries.elementAt(i);
            return IconButton.filledTonal(
              isSelected: e.key == current,
              icon: Icon(e.value, size: 22),
              onPressed: () => Navigator.pop(ctx, e.key),
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: const Text('✕'),
        ),
      ],
    ),
  );
}
