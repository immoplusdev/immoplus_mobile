part of homePage;

class HomeSectionLoading extends StatelessWidget {
  const HomeSectionLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: (Colors.grey[300])!,
      highlightColor: Colors.white,
      period: Duration(milliseconds: 500),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 25,
            width: 100,
            margin: EdgeInsets.only(left: 8),
            decoration: BoxDecoration(
                color: Colors.red, borderRadius: BorderRadius.circular(30)),
          ),
          SizedBox(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 5,
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  elevation: 0,
                  margin: EdgeInsets.zero,
                  clipBehavior: Clip.antiAlias,
                  child: SizedBox(
                    width: 170,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
