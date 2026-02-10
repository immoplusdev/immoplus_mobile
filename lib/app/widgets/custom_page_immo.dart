import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:immoplus/app/utils/app_colors.dart';

const _backIconSize = 31.0;

class CustomPageImmo extends StatefulWidget {
  final String title;
  final Widget content;

  const CustomPageImmo({super.key, required this.title, required this.content});

  @override
  State<CustomPageImmo> createState() => _ChooseAccountTypePageState();
}

class _ChooseAccountTypePageState extends State<CustomPageImmo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE9E9E9),
      body: Column(
        children: [
          Gap(100),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(50),
                ),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 20, left: 20, right: 20),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () => context.pop(),
                          child: Container(
                            width: _backIconSize,
                            height: _backIconSize,
                            padding: EdgeInsets.only(left: 5),
                            decoration: BoxDecoration(
                                color: AppColors.blue65BAF0,
                                shape: BoxShape.circle),
                            child: Center(
                              child: Icon(
                                Icons.arrow_back_ios,
                                size: 15,
                                color: AppColors.white,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                            child: Text(
                          widget.title,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        )),
                        SizedBox(
                          width: _backIconSize,
                          height: _backIconSize,
                        )
                      ],
                    ),
                  ),
                  Divider(),
                  Expanded(
                    child: widget.content,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
