import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lifebeat/components/progressCircle.dart';
import 'package:lifebeat/scripts/vars.dart';
import 'package:lifebeat/models/goal_model.dart';

class DetailsButton extends StatelessWidget {
  DetailsButton({
    super.key,
    required this.child,
  });

  Widget child;
  BorderRadius buttonBorderRadius = BorderRadius.circular(8);

  @override
  Widget build(BuildContext context) {
    return Flexible(
      fit: FlexFit.tight,
      child: InkWell(
        onTap: () {},
        borderRadius: buttonBorderRadius,
        child: Container(
            decoration: BoxDecoration(
              color: AppColors.grayBlueLight,
              borderRadius: buttonBorderRadius,
            ),
            height: 30,
            child: Center(child: child)),
      ),
    );
  }
}

class TaskDetailsPage extends StatelessWidget {
  const TaskDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    GoalModel model = GoalModel(
        id: 1,
        completed: false,
        name: 'Сделать проект',
        description:
            'Короче проект называется Taskudy, очень клёвое приложение для учёбы, достижения целей и концентрации... да',
        deadline: DateTime(2023, 11, 21));

    int timeLeft = model.deadline.difference(DateTime.now()).inDays;
    List checkpoints = <Widget>[
      Row(
        children: [
          Checkbox(
            value: false,
            onChanged: (value) {},
          ),
          Text(
            'Тест 01',
            style: AppTexts.body,
          ),
        ],
      ),
      Row(
        children: [
          Checkbox(
            value: false,
            onChanged: (value) {},
          ),
          Text(
            'Тест 02',
            style: AppTexts.body,
          ),
        ],
      ),
      Row(
        children: [
          Checkbox(
            value: true,
            onChanged: (value) {},
          ),
          Text(
            'Тест 03',
            style: AppTexts.body,
          ),
        ],
      ),
    ];

    return Container(
      decoration: const BoxDecoration(
        gradient: AppColors.backgroundGradient,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.arrow_back_ios_new_rounded),
                    color: AppColors.white,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    model.name,
                    style: AppTexts.headingBold,
                  )
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  ProgressCircle(progress: model.progress),
                  const SizedBox(width: 10),
                  const Icon(
                    Icons.timer_rounded,
                    color: AppColors.white,
                    size: 16,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    '$timeLeft дней',
                    style: AppTexts.body,
                  ),
                  const SizedBox(width: 10),
                  const Icon(
                    Icons.calendar_month_rounded,
                    size: 16,
                    color: AppColors.white,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    '${model.deadline.day}.${model.deadline.month}.${model.deadline.year}',
                    style: AppTexts.body,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                model.description,
                style: AppTexts.body,
              ),
              const SizedBox(height: 20),
              Container(
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.grayBlueLight,
                  borderRadius: BorderRadius.circular(9),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  DetailsButton(
                    child: const Icon(
                      Icons.edit_rounded,
                      color: AppColors.white,
                      size: 16,
                    ),
                  ),
                  const SizedBox(width: 10),
                  DetailsButton(
                    child: Text(
                      '+',
                      style: AppTexts.bodyBold,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Flexible(
                  child: ListView.separated(
                      itemBuilder: (context, index) => const SizedBox(
                            height: 10,
                          ),
                      separatorBuilder: (context, index) => checkpoints[index],
                      itemCount: checkpoints.length + 1))
            ],
          ),
        ),
      ),
    );
  }
}
