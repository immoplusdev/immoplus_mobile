import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:immoplus/app/utils/app_colors.dart';

class SeeMoreButton extends StatelessWidget {
  const SeeMoreButton({super.key, required this.text});
  final String text;
  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      sliver: SliverToBoxAdapter(
        child: OutlinedButton(
          style: OutlinedButton.styleFrom(
              side: BorderSide(color: AppColors.primary)),
          onPressed: () {
            showModalBottomSheet<void>(
              context: context,
              isScrollControlled: true,
              useSafeArea: true,
              showDragHandle: true,
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              builder: (BuildContext context) {
                return Container(
                  padding: EdgeInsets.only(top: 10),
                  height: MediaQuery.of(context).size.height * 0.8,
                  color: Colors.transparent,
                  child: Scaffold(
                    backgroundColor: Colors.transparent,
                    appBar: AppBar(
                      automaticallyImplyLeading: false,
                      title: Text('À propos du logement'),
                      titleTextStyle: Theme.of(context).textTheme.headlineSmall,
                    ),
                    body: Markdown(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      data: text, //state.finishData.data!.description!,
                      //styleSheet: MarkdownStyleSheet(),
                    ),
                  ),
                );
              },
            );
          },
          child: Text('Lire toute la description'),
        ),
      ),
    );
  }
}
