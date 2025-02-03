part of homePage;

class HeaderSection extends StatelessWidget {
  HeaderSection({Key? key, required this.title, this.onTap}) : super(key: key);
  final String title;
  final Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(
        //color: Colors.red,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.grey[800],
            ),
          ),
          Visibility(
            visible: onTap != null,
            child: SizedBox(
              height: 20,
              child: TextButton(
                onPressed: onTap,
                child: Row(
                  children: [
                    Text(
                      'Voir plus',
                      style: TextStyle(fontSize: 12),
                    ),
                    Icon(
                      Icons.arrow_forward,
                      size: 12,
                    )
                  ],
                ),
                style: TextButton.styleFrom(
                  textStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                  padding: EdgeInsets.zero,
                ),
              ),
            ),
          ),
        ],
      ),
    );

    // SliverList(
    //     delegate: SliverChildBuilderDelegate((context, index) {
    //   return Padding(
    //     padding: const EdgeInsets.only(
    //       top: 5,
    //       left: 10,
    //       bottom: 0,
    //       right: 10,
    //     ),
    //     child: Container(
    //       padding: EdgeInsets.all(8),
    //       decoration: BoxDecoration(
    //         //color: Theme.of(context).colorScheme.surface,
    //         borderRadius: BorderRadius.circular(5),
    //       ),
    //       child: Text(
    //         title,
    //         style: TextStyle(
    //             fontWeight: FontWeight.bold,
    //             fontSize: 20,
    //             color: Colors.grey[800]),
    //       ),
    //     ),
    //   );
    // }, childCount: 1));
  }
}
