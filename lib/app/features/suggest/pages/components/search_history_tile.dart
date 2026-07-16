import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class SearchHistoryTile extends StatelessWidget {
  final String query;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  const SearchHistoryTile({
    super.key,
    required this.query,
    required this.onTap,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16),
        child: Row(
          children: [
            const Icon(Icons.access_time_filled, color: Colors.grey, size: 18),
            const Gap(12),
            Expanded(
              child: Text(
                query,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.close, color: Colors.grey, size: 18),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              onPressed: onRemove,
            ),
          ],
        ),
      ),
    );
  }
}
