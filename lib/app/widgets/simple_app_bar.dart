part of sharedWidgets;

class SimpleAppBar extends StatelessWidget implements PreferredSize {
  const SimpleAppBar({
    super.key,
    required this.title,
    required this.icon,
    this.onPressed,
    this.onBack,
    required this.automaticallyImplyLeading,
  });
  final String title;
  final void Function()? onPressed;
  final void Function()? onBack;
  final bool automaticallyImplyLeading;
  final Widget icon;
  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      //backgroundColor: Colors.red,
      backgroundColor: Theme.of(context).primaryColor,

      elevation: 0,
      leading: IconButton(
        icon: const Icon(
          Icons.chevron_left,
          size: 30,
        ),
        onPressed: () async {
          //await LocalStorage().getProduct();
          Constantes.buildNotifier.value = !Constantes.buildNotifier.value;
          context.go("/home");
        },
      ),
      actions: [
        IconButton(
          onPressed: onPressed,
          icon: icon,
        ),
      ],
      centerTitle: true,
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  @override
  // TODO: implement child
  Widget get child => throw UnimplementedError();

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(50);
}
