part of appli;

class HomeIcon extends StatelessWidget {
  const HomeIcon({
    super.key,
    required this.expetedState,
    required this.currentState,
    required this.title,
    required this.immoIcons,
  });
  final PageState expetedState;
  final PageState currentState;
  final String title;
  final ImmoIcons immoIcons;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ImmoIcon(
          immoIcons,
          size: 25,
          color: (currentState == expetedState)
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.surface,
        ),
        const SizedBox(
          height: 4,
        ),
        Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: (currentState == expetedState)
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.surface,
          ),
        )
      ],
    );
  }
}
