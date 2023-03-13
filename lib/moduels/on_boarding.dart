import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../network/local/shared_preferences.dart';
import '../../style/color.dart';
import '../componoents/components.dart';
import 'hello_screen.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);
  static var pageViewController = PageController();
  static List<OnBoardingModel> screen = [
    OnBoardingModel(
      image: 'assets/image/on_boarding/im.png',
      body: 'Purchase your items online',
    ),
    OnBoardingModel(
      image: 'assets/image/on_boarding/im1.png',
      body: 'Choose in-store pick-up',
    ),
    OnBoardingModel(
      image: 'assets/image/on_boarding/im3.png',
      body: 'Or, choose home delivery',
    )
  ];

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  bool last = false;
  bool first = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:HexColor('ff83a8') ,
        body: Column(
      children: [
        Expanded(
          child: PageView.builder(
            onPageChanged: (index){
              if(index == OnBoardingScreen.screen.length-1){
                setState((){
                  last = true;
                });
              }else{
                setState((){
                  last = false;
                });
              }
              if(index == 0){
                setState((){
                  first = true;
                });
              }else{
                setState((){
                  first = false;
                });
              }
            },
            physics: const BouncingScrollPhysics(),
            controller: OnBoardingScreen.pageViewController,
            itemBuilder: (context, index) => itemOnBoarding(OnBoardingScreen.screen[index],context),
            scrollDirection: Axis.horizontal,
            itemCount: OnBoardingScreen.screen.length,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if(first == false)
              Expanded(
                child: TextButton(
                  onPressed: (){
                    OnBoardingScreen.pageViewController.previousPage(duration: const Duration(milliseconds: 400), curve:Curves.easeInExpo);
                  },
                  child: Text('previous'.toUpperCase(),
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge),
                ),
              ),
            if(first)
              Expanded(child: Text('',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: HexColor('FF9263')
                  )),),
            SmoothPageIndicator(
               effect: ExpandingDotsEffect(
                 dotColor: HexColor('FF6C98'),
                 activeDotColor: defShopColor,
                 dotHeight: 10,
                 dotWidth: 10
               ),
              controller: OnBoardingScreen.pageViewController,
              count: OnBoardingScreen.screen.length,
            ),
            if(last == false)
            Expanded(
              child: TextButton(
                onPressed: (){
                  if(last == false) {
                    OnBoardingScreen.pageViewController.nextPage(duration: const Duration(milliseconds: 400), curve:Curves.easeInExpo);
                  }
                },
                child: Text('NEXT',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge),
              ),
            ),
            if(last)
              Expanded(child: Text('',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: HexColor('FF9263')
                )),)
          ],
        ),
        const SizedBox(
          height: 10,
        )
      ],
    )
    );
  }
}

Widget itemOnBoarding(OnBoardingModel model, context) =>  Column(
  // crossAxisAlignment: CrossAxisAlignment.center,
  children: [
    Expanded(
      child: Image(
        width: double.infinity,
        height: double.infinity,
        image: AssetImage(model.image,),
      ),
    ),
    Text(
      model.body,
      style:  const TextStyle(
          fontWeight: FontWeight.bold, fontFamily: 'extrabob'),
    ),
    const SizedBox(
      height: 20,
    ),
    const Text(
      'Natus error sit voluptatem accusantium \n natuslaudantium totam rem aperiam.',
      maxLines: 2,
    ),
    const SizedBox(
      height: 30,
    ),
    defButton(
      onPressed: (){
        SharedHelper.saveData(key: 'onBoarding', value: true)?.then((value) {
          navigateAndFinish(context, const HelloScreen());
        });
      },
        text: 'LETS GO SHOPPING!',
        width: 180,
        radius: 30,
        color: HexColor('ff5486')),
  ],
);

class OnBoardingModel {
  String image;
  String body;

  OnBoardingModel({
    required this.image,
    required this.body,
  });
}
