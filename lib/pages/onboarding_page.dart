import 'package:betting_tennis/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:betting_tennis/globals.dart' as globals;

class OnboardingPage extends StatefulWidget {
  OnboardingPage({Key? key}) : super(key: key);

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  double? _deviceHeight, _deviceWidth;

  final controller = LiquidController();

  int currentPage = 0;
  bool slideIcon = true;

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          LiquidSwipe(
            pages: [
              _onboardingContent(
                const Color(0xffffdcbd),
                'assets/images/ml-tennis.svg',
                "Integrated with AI",
                "Based on an AI model trained on over 10,000 professional tennis matches",
                "1/2",
              ),
              _onboardingContent(
                const Color(0xfffddcdf),
                "assets/images/conversation-tennis.svg",
                "Bet on Matches",
                "Find and use the odds of your favorite tennis player's matches to impress your friends",
                "2/2",
              )
            ],
            liquidController: controller,
            onPageChangeCallback: _onPageChangeCallback,
            slideIconWidget:
                slideIcon ? const Icon(Icons.arrow_back_ios) : null,
            enableSideReveal: true,
            enableLoop: false,
          ),
          Positioned(
            bottom: 80.0,
            child: OutlinedButton(
              onPressed: () async {
                if (currentPage == 0) {
                  int nextPage = controller.currentPage + 1;
                  controller.animateToPage(page: nextPage);
                } else {
                  final prefs = await SharedPreferences.getInstance();
                  prefs.setBool('showHome', true);

                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext _context) {
                        return HomePage();
                      },
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                side: const BorderSide(color: Colors.black26),
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(20),
                foregroundColor: Colors.white,
              ),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: Color(0xff272727),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_forward_ios),
              ),
            ),
          ),
          Positioned(
            top: _deviceHeight! * 0.05,
            right: _deviceWidth! * 0.05,
            child: TextButton(
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();
                prefs.setBool('showHome', true);

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext _context) {
                      return HomePage();
                    },
                  ),
                );
              },
              child: const Text(
                "Skip",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 15,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: _deviceHeight! * 0.03,
            child: AnimatedSmoothIndicator(
              activeIndex: controller.currentPage,
              count: 2,
              effect: const WormEffect(
                activeDotColor: Color(0xff272727),
                dotHeight: 5.0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _onboardingContent(
      Color color, String image, String text1, String text2, String text3) {
    return Container(
      padding: const EdgeInsets.all(30),
      color: color,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            image,
            height: _deviceHeight! * 0.45,
          ),
          Column(
            children: [
              Text(
                text1,
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 10),
                child: Text(
                  text2,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          Text(
            text3,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: _deviceHeight! * 0.08),
        ],
      ),
    );
  }

  _onPageChangeCallback(int activePageIndex) {
    setState(() {
      if (activePageIndex == 1) {
        slideIcon = false;
      } else {
        slideIcon = true;
      }

      currentPage = activePageIndex;
    });
  }
}
