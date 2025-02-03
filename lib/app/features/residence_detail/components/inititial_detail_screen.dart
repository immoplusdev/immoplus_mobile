import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:immoplus/app/features/residence_detail/cubit/residence_cubit.dart';

class InitialDetailLogmentScreen extends StatelessWidget {
  const InitialDetailLogmentScreen({super.key, required this.idProduct});
  final String idProduct;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              context.go('/homePage');
            },
            icon: const Icon(Icons.chevron_left)),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<ResidenceCubit>().getResidence(id: idProduct);
        },
        child: SingleChildScrollView(
          child: Column(children: [
            SizedBox(
              //color: Colors.red,
              height: MediaQuery.of(context).size.height + 10,
              width: double.infinity,
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Aucun produit',
                    style: TextStyle(color: CupertinoColors.systemFill),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Icon(
                    Icons.arrow_circle_down_rounded,
                    size: 40,
                    color: CupertinoColors.systemFill,
                  )
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
