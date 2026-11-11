import 'package:flutter/material.dart';

class PromotionalBanner extends StatelessWidget {
  final String title;
  final String subtitle;
  final String offer;
  final String buttonText;
  final VoidCallback? onTap;

  const PromotionalBanner({
    super.key,
    this.title = 'Big Deals,',
    this.subtitle = 'Better Shopping!',
    this.offer = 'UP TO 40% OFF',
    this.buttonText = 'Shop Now',
    this.onTap,
  });

  static const Color _orange = Color(0xFFE98743);
  static const Color _deepOrange = Color(0xFFB95325);
  static const Color _gold = Color(0xFFFFC477);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFF5A45F), _orange, _deepOrange],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: _deepOrange.withValues(alpha: 0.28),
            blurRadius: 20,
            offset: const Offset(0, 9),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: Stack(
          children: [
            // Decorative background circles
            Positioned(
              top: -65,
              right: 35,
              child: Container(
                height: 170,
                width: 170,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.07),
                ),
              ),
            ),

            Positioned(
              bottom: -95,
              right: -20,
              child: Container(
                height: 210,
                width: 210,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.10),
                    width: 2,
                  ),
                ),
              ),
            ),

            // Shopping bag illustration
            Positioned(
              right: 12,
              bottom: -10,
              child: Icon(
                Icons.shopping_bag_rounded,
                size: 142,
                color: Colors.white.withValues(alpha: 0.15),
              ),
            ),

            Positioned(
              right: 33,
              top: 27,
              child: Icon(
                Icons.star_rounded,
                size: 22,
                color: _gold.withValues(alpha: 0.75),
              ),
            ),

            // Banner content
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Offer label
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.18),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.20),
                      ),
                    ),
                    child: Text(
                      offer,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.3,
                      ),
                    ),
                  ),

                  const SizedBox(height: 11),

                  // Main heading
                  Text(
                    '$title\n$subtitle',
                    maxLines: 2,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 23,
                      height: 1.15,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.4,
                    ),
                  ),

                  const SizedBox(height: 13),

                  // Golden action button
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: onTap,
                      borderRadius: BorderRadius.circular(30),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 9,
                        ),
                        decoration: BoxDecoration(
                          color: _gold,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.12),
                              blurRadius: 7,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              buttonText,
                              style: const TextStyle(
                                color: Color(0xFF713817),
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(width: 7),
                            const Icon(
                              Icons.arrow_forward_rounded,
                              size: 15,
                              color: Color(0xFF713817),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
