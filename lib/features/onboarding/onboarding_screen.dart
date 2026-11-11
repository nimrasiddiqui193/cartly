import 'package:flutter/material.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();

  int _currentPage = 0;

  final List<_OnboardingPage> _pages = const [
    _OnboardingPage(
      icon: Icons.search_rounded,
      title: 'Discover Amazing Products',
      description:
          'Explore a wide collection of products and find exactly what you need.',
      color: Color(0xFFE68A45),
    ),
    _OnboardingPage(
      icon: Icons.favorite_rounded,
      title: 'Save Your Favorites',
      description:
          'Create your wishlist and keep all your favorite products in one place.',
      color: Color(0xFFE47777),
    ),
    _OnboardingPage(
      icon: Icons.shopping_bag_rounded,
      title: 'Shopping Made Easy',
      description:
          'Enjoy a smooth shopping experience with a simple and secure checkout.',
      color: Color(0xFF4C9B83),
    ),
  ];

  bool get _isLastPage => _currentPage == _pages.length - 1;

  void _nextPage() {
    if (_isLastPage) {
      _finishOnboarding();
      return;
    }

    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _skipOnboarding() {
    _pageController.animateToPage(
      _pages.length - 1,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _finishOnboarding() {
    // Final navigation will be connected during app integration.
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final backgroundColor = Theme.of(context).scaffoldBackgroundColor;
    final textColor = isDark ? Colors.white : const Color(0xFF252525);
    final secondaryTextColor =
        isDark ? Colors.white70 : const Color(0xFF777777);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: _isLastPage ? null : _skipOnboarding,
                  child: Text(
                    'Skip',
                    style: TextStyle(
                      color:
                          _isLastPage
                              ? secondaryTextColor.withValues(alpha: 0.3)
                              : secondaryTextColor,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),

              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _pages.length,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    final page = _pages[index];

                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 230,
                          width: 230,
                          decoration: BoxDecoration(
                            color: page.color.withValues(alpha: 0.12),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(page.icon, size: 105, color: page.color),
                        ),

                        const SizedBox(height: 55),

                        Text(
                          page.title,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),

                        const SizedBox(height: 18),

                        Text(
                          page.description,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 15,
                            height: 1.6,
                            color: secondaryTextColor,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(_pages.length, (index) {
                  final isActive = _currentPage == index;

                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    height: 8,
                    width: isActive ? 26 : 8,
                    decoration: BoxDecoration(
                      color:
                          isActive
                              ? const Color(0xFFE68A45)
                              : const Color(0xFFE68A45).withValues(alpha: 0.25),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  );
                }),
              ),

              const SizedBox(height: 35),

              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: _isLastPage ? _finishOnboarding : _nextPage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE68A45),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Text(
                    _isLastPage ? 'Get Started' : 'Next',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 25),
            ],
          ),
        ),
      ),
    );
  }
}

class _OnboardingPage {
  final IconData icon;
  final String title;
  final String description;
  final Color color;

  const _OnboardingPage({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
  });
}
