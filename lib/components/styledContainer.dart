import 'package:flutter/material.dart';
import 'package:point_of_sales/components/textstyle.dart';

class StyledContainer extends StatelessWidget {
  final Widget child;

  const StyledContainer({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Color(0xFFDDDDDD), // Ganti dengan warna yang diinginkan
              width: 2,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.only(
              left: 10,
              right: 16,
            ),
            child: child,
          ),
          height: 158,
        ),
      ),
    );
  }
}

class PickFilesWidget extends StatelessWidget {
  final VoidCallback onPressed;

  const PickFilesWidget({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StyledContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Pick Files",
            style: TextStyles.poppinsMedium.copyWith(
              fontSize: 14,
              color: Color(0xFF757575),
            ),
          ),
          const SizedBox(
            height: 40,
          ),
          Center(
              child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFFF8D4D),
              elevation: 5, // Ganti dengan tinggi shadow yang diinginkan
            ),
            onPressed: onPressed,
            child: Text(
              "Tambah Gambar",
              style: TextStyles.poppinsBold.copyWith(
                fontSize: 15,
                color: Colors.white,
              ),
            ),
          )),
        ],
      ),
    );
  }
}
