import 'package:flutter/material.dart';
import 'package:flutter_fire/models/models.dart';
import 'package:flutter_fire/ui/widgets/widgets.dart';

class MaxEntryAndBonusView extends StatelessWidget {
  final Contest contest;

  const MaxEntryAndBonusView({Key? key, required this.contest})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (contest.bonusPerEntry > 0)
          Padding(
            padding: const EdgeInsets.only(left: 12),
            child: AppTooltip(
              message: 'Maximum ${contest.bonusPerEntry}% bonus usable',
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  borderRadius: BorderRadius.circular(6),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context)
                          .colorScheme
                          .primaryVariant
                          .withOpacity(0.1),
                      spreadRadius: 2,
                      blurRadius: 2.4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Text(
                      '${contest.bonusPerEntry}%',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      width: 3,
                    ),
                    Text(
                      'BONUS',
                      style: TextStyle(
                        fontSize: 8,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
      ],
    );
  }
}
