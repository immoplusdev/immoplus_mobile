part of homePage;

class AboutSection extends StatelessWidget {
  AboutSection({Key? key}) : super(key: key);
  final List<Map> _data = [
    {
      'title': 'PLANS',
      'img': 'cd87caf9-a2b6-4a15-a683-fe0430932308',
    },
    {
      'title': 'PARTENAIRE',
      'img': '8fdde96f-a962-4e37-b009-3960c5b3c204',
    },
    {
      'title': 'DEMARCHEUR',
      'img': '031d92e4-406b-427b-850c-0a51e711fd29',
    },
    {
      'title': 'PLANS',
      'img': 'cd87caf9-a2b6-4a15-a683-fe0430932308',
    },
    {
      'title': 'PARTENAIRE',
      'img': '8fdde96f-a962-4e37-b009-3960c5b3c204',
    },
    {
      'title': 'DEMARCHEUR',
      'img': '031d92e4-406b-427b-850c-0a51e711fd29',
    },
  ];
  // NetworkImage(
  //                                 '${Constantes.baseUrl}/file/${listTwoSet.toList()[index].directusFilesId}'),
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        //color: Colors.yellow,
        height: 200,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Padding(
            //   padding: const EdgeInsets.only(
            //     top: 0,
            //     left: 10,
            //     bottom: 0,
            //     right: 10,
            //   ),
            //   child: Container(
            //     width: double.infinity,
            //     padding: EdgeInsets.all(10),
            //     decoration: BoxDecoration(
            //       borderRadius: BorderRadius.circular(5),
            //     ),
            //     child: Text(
            //       'Encore plus',
            //       style: TextStyle(
            //         fontWeight: FontWeight.bold,
            //         fontSize: 17,
            //         color: Colors.grey[800],
            //       ),
            //     ),
            //   ),
            // ),
            Expanded(
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _data.length,
                itemExtent: 160,
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    padding: EdgeInsets.all(7),
                    width: 100,
                    height: 250,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Color.fromARGB(255, 229, 228, 228),
                          spreadRadius: 2,
                          blurRadius: 7,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    //color: Colors.red,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: CachedNetworkImageProvider(
                                'https://api.immoplus.ci/file/${_data[index]['img']}',
                              ),
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          height: 120,
                        ),
                        Container(
                          width: 100,
                          height: 30,
                          padding: EdgeInsets.all(8),
                          child: Center(
                              child: Text(
                            _data[index]['title'],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          )),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
