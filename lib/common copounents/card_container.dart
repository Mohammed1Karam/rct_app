import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

class CardContainer extends StatelessWidget {
  final String image;
  final String title;
  final void Function() onTap;
  final Widget? favoriteIcon;

  const CardContainer({
    super.key,
    required this.image,
    required this.title,
    required this.onTap,
    this.favoriteIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      color: Colors.white,
      padding: const EdgeInsets.all(8.0),
      child: Card(
        color: Colors.white,
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Stack(
                children: [
                  Container(
                    height: 200,
                    width: double.infinity,
                    color: Colors.white,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(15),
                      ),
                      child: FadeInImage.memoryNetwork(
                        placeholder: kTransparentImage,
                        image: image,
                        fit: BoxFit.fill,
                        imageErrorBuilder: (context, error, stackTrace) {
                          return const Icon(
                            Icons.image,
                            size: 50,
                            color: Colors.grey,
                          );
                        },
                      ),
                    ),
                  ),
                  if (favoriteIcon != null)
                    Positioned(
                      right: 2,
                      child: favoriteIcon!,
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(2),
              child: Container(
                height: 35,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        maxLines: 1,
                        title,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add_circle_outlined),
                      onPressed: onTap,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
