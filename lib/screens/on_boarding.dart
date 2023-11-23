import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../network/local/shared_preferences.dart';
import '../../style/color.dart';
import '../componoents/components.dart';
import '../models/on_boarding_model.dart';
import 'hello_screen.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);
  static List<OnBoardingModel> screen = [
    OnBoardingModel(
      image: 'assets/image/on_boarding/Send Gift Pink.png',
      body: 'Purchase your items online',
    ),
    OnBoardingModel(
      image: 'assets/image/on_boarding/Shopping Pink.png',
      body: 'Choose in-store pick-up',
    ),
    OnBoardingModel(
      image: 'assets/image/on_boarding/Shopping Pink 2.png',
      body: 'Or, choose home delivery',
    )
  ];


  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  bool last = false;
  bool first = true;
   var pageViewController = PageController();

   int currentPageIndex = 0;
   final double requiredWidthAndHeight = 400;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final double availableWidth = constraints.maxWidth;
          final double availableHeight = constraints.maxHeight;
          final double screenWidth = MediaQuery.of(context).size.width;
          return Column(
            children: [
              /// image
              Expanded(
                flex: 2 ,
                child: PageView.builder(
                  onPageChanged: (index) {
                    currentPageIndex = index;
                    if (index == OnBoardingScreen.screen.length - 1) {
                      setState(() {
                        last = true;
                      });
                    } else {
                      setState(() {
                        last = false;
                      });
                    }
                    if (index == 0) {
                      setState(() {
                        first = true;
                      });
                    } else {
                      setState(() {
                        first = false;
                      });
                    }
                  },
                  physics: const BouncingScrollPhysics(),
                  controller: pageViewController,
                  itemBuilder: (context, index) =>
                      Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            alignment: Alignment.center,
                            fit: BoxFit.fitWidth,
                            image: AssetImage(
                              OnBoardingScreen.screen[index].image,
                            ),
                          ),
                        ),
                      ),
                  scrollDirection: Axis.horizontal,
                  itemCount: OnBoardingScreen.screen.length,
                ),
              ),
              if(requiredWidthAndHeight < availableHeight)
              /// BOTTOM SHEET
              Expanded(
                child: Container(
                  width: double.infinity,
                  margin: const EdgeInsetsDirectional.symmetric(horizontal: 30),
                  decoration:  BoxDecoration(
                    color: defShopColor,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(40),
                    ),
                  ),
                  child: Column(
                    children: [
                      /// TEXT
                      Expanded(
                        child:   Center(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                                OnBoardingScreen.screen[currentPageIndex].body.toUpperCase(),
                                style:Theme.of(context).textTheme.bodyMedium
                            ),
                          ),
                        ),
                      ),

                      /// indicator and icons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          /// previous
                          Expanded(
                              child: first  ? Text('',
                                textAlign: TextAlign.center,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(color: secondShopColor,
                                ),
                              ) : TextButton(
                                onPressed: () {
                                  pageViewController.previousPage(
                                    duration: const Duration(milliseconds: 400),
                                    curve: Curves.easeInExpo,
                                  );
                                },
                                child: Text(
          availableWidth > requiredWidthAndHeight ?   'previous'.toUpperCase() : 'P',
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ) ,
                            ),
                          /// indicator and text button
                          Container(
                            width: screenWidth / 2.5,
                            padding: const EdgeInsetsDirectional.symmetric(vertical: 15),
                            decoration:  const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(40),
                              ),
                            ),
                            child: Column(
                              children: [
                                /// BUTTON
                                defButton(
                                  onPressed: () {
                                    SharedHelper.saveData(key: 'onBoarding', value: true)
                                        ?.then((value) {
                                      navigateAndFinish(context, const HelloScreen());
                                    },
                                    );
                                  },
                                  text: 'LETS GO SHOPPING!',
                                  textColor: secondShopColor,
                                  width: screenWidth / 4,
                                  radius: 30,
                                  fontSize: 12,
                                  color: defShopColor,
                                ),
                                const SizedBox(height: 15,),
                                SmoothPageIndicator(
                                  effect: ExpandingDotsEffect(
                                    dotColor: HexColor('FF6C98'),
                                    activeDotColor: defShopColor,
                                    dotHeight: 10,
                                    dotWidth: screenWidth / 28,
                                  ),
                                  controller: pageViewController,
                                  count: OnBoardingScreen.screen.length,
                                ),
                              ],
                            ),
                          ),
                          /// next
                          Expanded(
                              child: last ?Text('',
                                textAlign: TextAlign.center,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(color: secondShopColor,
                                ),
                              ) : TextButton(
                                onPressed: () {
                                  if (last == false) {
                                    pageViewController.nextPage(
                                      duration: const Duration(milliseconds: 400),
                                      curve: Curves.easeInExpo,
                                    );
                                  }
                                },
                                child: Text(
                                  availableWidth > requiredWidthAndHeight ? 'NEXT' : 'N',
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              )  ,
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              if(requiredWidthAndHeight > availableHeight)
                /// button
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: defButton(
                    onPressed: () {
                      SharedHelper.saveData(key: 'onBoarding', value: true)
                          ?.then((value) {
                        navigateAndFinish(context, const HelloScreen());
                      },
                      );
                    },
                    text: 'LETS GO SHOPPING!',
                    textColor: secondShopColor,
                    width: screenWidth / 4,
                    radius: 30,
                    fontSize: 12,
                    color: defShopColor,
                  ),
                ),
            ],
          );
        }
        )
    );
  }
}