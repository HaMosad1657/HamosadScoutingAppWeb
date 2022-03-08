import 'package:flutter/material.dart';
import 'package:hamosad_scouting_app/pages/pages.dart';
import 'package:hamosad_scouting_app/widgets/widgets.dart';
import 'package:hamosad_scouting_app/misc/data_container.dart';

class TeleopPage extends StatefulWidget {
  TeleopPage({Key? key}) : super(key: key);

  final DataContainer<bool> canShootWhileMovingData = DataContainer(false);
  final DataContainer<bool> canPickMultipleData = DataContainer(false);
  final DataContainer<bool> cantShootDynamicallyData = DataContainer(false);
  final DataContainer<String> anchorPointData = DataContainer("");
  final DataContainer<int> ballsPickedFloorData = DataContainer(0);
  final DataContainer<int> ballsPickedFeederData = DataContainer(0);
  final DataContainer<int> ballsMissedData = DataContainer(0);
  final DataContainer<int> lowerScoreData = DataContainer(0);
  final DataContainer<int> upperScoreData = DataContainer(0);
  final DataContainer<String> notesData = DataContainer("");

  @override
  State<TeleopPage> createState() => _TeleopPageState();
}

class _TeleopPageState extends State<TeleopPage>
    with LastPageButton, NextPageButton {
  late final ToggleButton canShootWhileMoving;
  late final ToggleButton canPickMultiple;
  late final ToggleButton cantShootDynamically;
  late final TextEdit anchorPoint;
  late final ScoreCounter ballsPickedFloorCounter;
  late final ScoreCounter ballsPickedFeederCounter;
  late final ScoreCounter ballsMissedCounter;
  late final ScoreCounter lowerScoreCounter;
  late final ScoreCounter upperScoreCounter;
  late final TextEdit notes;

  @override
  void initState() {
    canShootWhileMoving = ToggleButton(
      title: "Can the robot shoot while moving?",
      container: widget.canShootWhileMovingData,
    );
    canPickMultiple = ToggleButton(
      title: "Can the robot pick up more than one ball at once?",
      container: widget.canPickMultipleData,
    );
    cantShootDynamically = ToggleButton(
      title: "Does the robot need an anchor point to shoot?",
      container: widget.cantShootDynamicallyData,
      onChanged: (newValue) {
        setState(
          () {
            widget.cantShootDynamicallyData.value = newValue;
          },
        );
      },
    );
    anchorPoint = TextEdit(
      title: "Anchor point...",
      container: widget.anchorPointData,
      lines: 1,
      titleInLine: true,
    );
    ballsPickedFloorCounter = ScoreCounter(
      title: "Balls picked from floor:",
      container: widget.ballsPickedFloorData,
    );
    ballsPickedFeederCounter = ScoreCounter(
      title: "Balls picked from feeder:",
      container: widget.ballsPickedFeederData,
    );
    ballsMissedCounter = ScoreCounter(
      title: "Balls missed:",
      container: widget.ballsMissedData,
    );
    lowerScoreCounter = ScoreCounter(
      title: "Balls entered the lower hub:",
      container: widget.lowerScoreData,
    );
    upperScoreCounter = ScoreCounter(
      title: "Balls entered the upper hub:",
      container: widget.upperScoreData,
    );
    notes = TextEdit(
      title: "Additional Notes:",
      container: widget.notesData,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PageAppBar(
        title: "Teleop",
      ),
      floatingActionButton: Stack(
        children: [
          getLastPageButton(context),
          getNextPageButton(context, nextPage: pages["endgame"]!)
        ],
      ),
      body: WidgetList(
        children: [
          canShootWhileMoving,
          canPickMultiple,
          cantShootDynamically,
          widget.cantShootDynamicallyData.value ? anchorPoint : Container(),
          ballsPickedFeederCounter,
          ballsPickedFloorCounter,
          ballsMissedCounter,
          lowerScoreCounter,
          upperScoreCounter,
          notes,
        ],
      ),
    );
  }
}
