// CustomLocationWidget code remains the same as above
import '../../../../../config.dart';

class CustomLocationWidget extends StatelessWidget {
  final String locationName;

  const CustomLocationWidget({
    super.key,
    required this.locationName,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Square Icon on the Left
          Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                  color: Colors.black,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(AppRadius.r5)),
              child:
                  Icon(Icons.stop, // This icon can represent the stop location
                      color: Colors.white,
                      size: Insets.i16)),
          SizedBox(width: Insets.i8), // Spacing between icon and text

          // Location Name
          Text(
            locationName,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(width: Insets.i8), // Spacing between text and arrow

          // Right Arrow Icon
          const Icon(
            Icons.arrow_forward_ios,
            color: Colors.black,
            size: 16,
          ),
        ],
      ),
    );
  }
}
