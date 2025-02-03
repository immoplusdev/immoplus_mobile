part of homePage;

class CustomAppBar extends StatefulWidget {
  const CustomAppBar({super.key});

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  final sessionManager = getIt<SessionManager>();
  List<dynamic> listBaske = [];

  void getCity() async {
    // villeUser = await ItemsRepository(context: context)
    //     .getCityOne(id: UserModel().city!);
    // Constantes.villeUser.value = villeUser;
  }

  String _currentValue = '';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      Constantes.buildNotifier.value = !Constantes.buildNotifier.value;
      //if (UserModel.singleton.id != '') getCity();
    });
  }

  @override
  Widget build(BuildContext context) {
    Constantes.buildNotifier.value = !Constantes.buildNotifier.value;

    return ValueListenableBuilder(
        valueListenable: Constantes.buildNotifier,
        builder: (context, bool value, child) {
          return SliverAppBar(
            backgroundColor: Theme.of(context).colorScheme.primary,
            toolbarHeight: 50,
            titleSpacing: 0,
            elevation: 2,
            leadingWidth: 70,
            actions: const [
              // Container(
              //     color: Theme.of(context).colorScheme.primary,
              //     margin: EdgeInsets.all(0),
              //     padding: EdgeInsets.only(right: 5),
              //     child: IconButton(
              //       onPressed: () {
              //         Navigator.push(
              //             context,
              //             MaterialPageRoute(
              //               builder: (context) => BasketPage(),
              //             ));
              //       },
              //       icon: FutureBuilder(
              //         future: LocalStorage().getProduct(),
              //         builder: (context, snapshot) => (snapshot.hasData)
              //             ? Badge(
              //                 isLabelVisible: snapshot.data!.isNotEmpty,
              //                 label: Text(
              //                   '${snapshot.data!.length}',
              //                   style: const TextStyle(
              //                     color: Colors.white,
              //                     fontSize: 12,
              //                   ),
              //                 ),
              //                 child: SvgPicture.asset(
              //                   "assets/icons/panier.svg",
              //                   width: 25,
              //                   color: Colors.white,
              //                 ),
              //               )
              //             : SvgPicture.asset(
              //                 "assets/icons/panier.svg",
              //                 width: 25,
              //                 color: Colors.white,
              //               ),
              //       ),
              //     )),
            ],
            // leading: Container(
            //     width: 100,
            //     height: 100,
            //     color: Theme.of(context).colorScheme.primary,
            //     child: BlocBuilder<NavigationCubit, PageState>(
            //       builder: (context, state) => IconButton(
            //         onPressed: () {
            //           // if (UserModel().id == 0) {
            //           //   // Navigator.push(
            //           //   //     context,
            //           //   //     MaterialPageRoute(
            //           //   //       builder: (context) => LoginPage(),
            //           //   //     ));
            //           // } else {
            //           //   // NavigationCubit().switchPage(PageState.acount);
            //           //   context
            //           //       .read<NavigationCubit>()
            //           //       .switchPage(PageState.acount);
            //           // }
            //         },
            //         icon:
            //             (SessionManager().currentUser!.avatar != null)
            //                 ? CircleAvatar(
            //                     backgroundColor: Colors.grey,
            //                     radius: 150,
            //                     backgroundImage: Utils.getImage(
            //                         id: UserModel.singleton.avatar ?? ''),
            //                   )
            //                 : SvgPicture.asset(
            //                     "assets/icons/compte.svg",
            //                     width: 22,
            //                     color: Colors.white,
            //                   ),
            //       ),
            //     )),
            pinned: false,
            snap: false,
            floating: true,
            expandedHeight: 104.0,
            title: Container(
              color: Theme.of(context).colorScheme.primary,
              padding: const EdgeInsets.only(bottom: 27),
              margin: EdgeInsets.only(
                  top: (sessionManager.currentUser!.id != '') ? 15 : 8),
              child: Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Container(
                  //color: Colors.red,

                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(
                            'assets/icon/logo_blanc.png',
                          ),
                          fit: BoxFit.contain)),

                  padding: const EdgeInsets.only(top: 40),
                  height: 100,
                ),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: SizedBox(
                  //color: Colors.red,
                  height: 25,
                  child: SizedBox(
                    child: CupertinoTextField(
                      padding: const EdgeInsets.only(left: 10),
                      textInputAction: TextInputAction.search,
                      onSubmitted: (keyword) {
                        print(keyword);
                        if (keyword.trim() != '') {
                          // FilterSearchModel().keyWord = keyword.trim();
                          //context.read<SearchBloc>().getListTicket(FilterSearchModel());
                          context
                              .read<NavigationCubit>()
                              .switchPage(PageState.explore);
                        }
                      },
                      onChanged: (val) {
                        print(val);
                        _currentValue = val;
                      },
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.transparent),
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.white,
                      ),
                      style: const TextStyle(
                        fontSize: 11,
                      ),
                      cursorColor: Colors.black26,
                      cursorHeight: 11,
                      placeholder: 'Maison, Appartement, Meubles etc...',
                      placeholderStyle: const TextStyle(
                        color: Color(0xFF82858D),
                        fontSize: 11,
                      ),
                      suffix: Align(
                        widthFactor: 0.6,
                        child: TextButton(
                          style: IconButton.styleFrom(
                            padding: const EdgeInsets.all(0),
                            elevation: 0,
                            shape: const CircleBorder(),
                            backgroundColor:
                                Colors.transparent, // <-- Button color
                          ),
                          //padding: const EdgeInsets.all(8.0),
                          onPressed: () {
                            if (_currentValue.trim() != '') {
                              // FilterSearchModel().keyWord =
                              //     _currentValue.trim();
                              //context.read<SearchBloc>().getListTicket(FilterSearchModel());
                              context
                                  .read<NavigationCubit>()
                                  .switchPage(PageState.explore);
                            }
                          },
                          child: const Icon(
                            CupertinoIcons.search,
                            size: 15,
                            //color: Theme.of(context).colorScheme.primaryVariant,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              background: Container(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          );
        });
  }
}
