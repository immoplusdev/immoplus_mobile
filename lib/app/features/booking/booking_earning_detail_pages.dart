import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:immoplus/app/features/booking/widgets/booking_list_info.dart';
import 'package:immoplus/app/utils/app_colors.dart';
import 'package:immoplus/app/widgets/custom_button.dart';

class BookingEarningDetailPage extends StatefulWidget {
  const BookingEarningDetailPage({super.key});

  @override
  State<BookingEarningDetailPage> createState() =>
      _BookingEarningDetailPageState();
}

class _BookingEarningDetailPageState extends State<BookingEarningDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Détail du Gain',
            style: Theme.of(context).textTheme.titleLarge!),
        backgroundColor: AppColors.scafold,
      ),
      backgroundColor: AppColors.scafold,
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // BookingListInfo(
          //   title: 'Status',
          //   info: 'En attente de validation',
          // ),
          BookingListInfo(
            title: 'Logement',
            info: 'Residence les rose',
          ),
          ListTile(
            tileColor: Colors.white,
            title: Text('ID réservation'),
            titleTextStyle: Theme.of(context)
                .textTheme
                .titleSmall!
                .copyWith(color: Colors.grey),
            subtitleTextStyle: Theme.of(context).textTheme.bodyLarge!,
            subtitle:
                SelectableText('praizoeuroieazhfoiehafherfhrzeugfzuregbvztr'),
            trailing: Icon(
              Icons.copy,
              color: AppColors.primary,
            ),
          )
        ],
      ),
      bottomNavigationBar: Container(
        height: 120,
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            CupertinoActionSheetAction(
              onPressed: () {
                showModalBottomSheet(
                  backgroundColor: AppColors.scafold,
                  showDragHandle: true,
                  enableDrag: true,
                  isScrollControlled: true,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  context: context,
                  builder: (context) => Container(
                    height: MediaQuery.of(context).size.height * 0.5,
                    child: Scaffold(
                      backgroundColor: AppColors.scafold,
                      appBar: AppBar(
                        title: Text('Pour quel raison réfusez-vous ?',
                            style: Theme.of(context).textTheme.titleLarge!),
                        backgroundColor: AppColors.scafold,
                      ),
                      body: ListView.builder(
                        itemCount: 4,
                        itemBuilder: (context, index) => Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: ListTile(
                            tileColor: Colors.white,
                            title: Text('La résidence est indisponible'),
                            trailing: Checkbox(
                              value: true,
                              onChanged: (value) {},
                            ),
                          ),
                        ),
                      ),
                      bottomNavigationBar: Container(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        height: 100,
                        child: CustomButtom(
                          text: 'Confirmer',
                          onClick: () {},
                        ),
                      ),
                    ),
                  ),
                );
              },
              child: const Text(
                "Retirer l'argent",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
