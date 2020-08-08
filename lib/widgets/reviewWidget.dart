import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:neer/models/review.dart';
import 'package:rating_bar/rating_bar.dart';

class ReviewWidget extends StatelessWidget {
  final Review review;

  ReviewWidget(this.review);

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          review.name,
          style: textTheme.subtitle1,
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            RatingBar.readOnly(
              filledIcon: Icons.star,
              emptyIcon: Icons.star_border,
              isHalfAllowed: true,
              halfFilledIcon: Icons.star_half,
              emptyColor: Colors.black,
              filledColor: Colors.black,
              halfFilledColor: Colors.black,
              maxRating: 5,
              initialRating: review.rating / 2,
              size: 20,
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              getFormattedDate(),
              style: textTheme.caption,
            )
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Text(review.review),
      ],
    );
  }

  String getFormattedDate() {
    return DateFormat(DateFormat.YEAR_ABBR_MONTH_DAY).format(
      DateTime.fromMillisecondsSinceEpoch(
        review.date,
        isUtc: true,
      ),
    );
  }
}
