import 'package:hamosad_scouting_app/pages/pages.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:math';

FirebaseDatabase database = FirebaseDatabase.instance;
DatabaseReference districtReference = database.ref('district');
late DatabaseReference gameReportsReference;
late DatabaseReference pitReportsReference;
late DatabaseReference averagesReference;
late DatabaseReference notesReference;
DatabaseReference gamesReference = database.ref('games');
dynamic lastReport;
dynamic gameTeamsData;
late dynamic gameTeams;
late int numberOfGames;

void initData() {
  districtReference.onValue.listen((DatabaseEvent event) {
    String? district = event.snapshot.value.toString();
    gameReportsReference = database.ref('$district/reports');
    pitReportsReference = database.ref('$district/pit');
    averagesReference = database.ref('$district/averages');
    notesReference = database.ref('$district/notes');
  });
}

void set1657() {
  gameReportsReference = database.ref('dcmp-1657/reports');
  pitReportsReference = database.ref('dcmp-1657/pit');
  averagesReference = database.ref('dcmp-1657/averages');
  notesReference = database.ref('dcmp-1657/notes');
}

void getTeams() {
  gamesReference.onValue.listen((DatabaseEvent event) {
    gameTeamsData = event.snapshot.value;
    gameTeams = gameTeamsData.asMap();
    numberOfGames = gameTeams.length;
  });
}

String generateReportId() {
  var r = Random();
  const _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  final signature =
      List.generate(3, (index) => _chars[r.nextInt(_chars.length)]).join();
  return '~$signature~${pages['home'].reporterNameData.value}_${pages['home'].reporterTeamData.value}-${reportType == ReportType.game ? int.tryParse(pages['info'].currentTeamData.value) ?? pages['info'].currentTeamData.value : int.tryParse(pages['pit_info'].currentTeamData.value) ?? pages['pit_info'].currentTeamData.value}_${int.tryParse(pages['info'].gameNumberData.value) ?? pages['info'].gameNumberData.value}';
}

dynamic getDatetime() {
  DateTime now = DateTime.now();

  return {
    'day': now.day.toString(),
    'month': now.month.toString(),
    'year': now.year.toString(),
    'time': now.hour.toString() + ':' + now.minute.toString(),
    'timeValue': now.hour * 60 * 60 + now.minute * 60 + now.second,
  };
}

dynamic generateGameReportData(
    {String? id, String? reporterName, String? reporterTeam}) {
  return {
    id ?? generateReportId(): {
      'info': {
        'reporterName': reporterName ?? pages['home'].reporterNameData.value,
        'reporterTeamNumber':
            reporterTeam ?? pages['home'].reporterTeamData.value,
        'teamNumber': int.tryParse(pages['info'].currentTeamData.value) ??
            pages['info'].currentTeamData.value,
        'datetime': getDatetime(),
        'gameNumber': int.tryParse(pages['info'].gameNumberData.value) ??
            pages['info'].gameNumberData.value,
        'alliance': pages['info'].allianceData.value,
      },
      'summary': {
        'totalScore': pages['summary'].totalScoreData.value,
        'robotFocus': pages['summary'].robotFocusData.value,
        'hubLower': pages['autonomus'].lowerScoreData.value +
            pages['teleop'].lowerScoreData.value,
        'hubUpper': pages['autonomus'].upperScoreData.value +
            pages['teleop'].upperScoreData.value,
        'hubMissed': pages['autonomus'].ballsMissedData.value +
            pages['teleop'].ballsMissedData.value,
        'ballsShot': pages['autonomus'].ballsMissedData.value +
            pages['autonomus'].lowerScoreData.value +
            pages['autonomus'].upperScoreData.value +
            pages['teleop'].ballsMissedData.value +
            pages['teleop'].lowerScoreData.value +
            pages['teleop'].upperScoreData.value,
      },
      'stageAutonomus': {
        'moved': pages['autonomus'].robotMovedData.value,
        'pickedFloor': pages['autonomus'].ballsPickedFloorData.value,
        'pickedFeeder': pages['autonomus'].ballsPickedFeederData.value,
        'hubMissed': pages['autonomus'].ballsMissedData.value,
        'hubLower': pages['autonomus'].lowerScoreData.value,
        'hubUpper': pages['autonomus'].upperScoreData.value,
        'totalScore': pages['autonomus'].lowerScoreData.value * 2 +
            pages['autonomus'].upperScoreData.value * 4,
        'ballsShot': pages['autonomus'].ballsMissedData.value +
            pages['autonomus'].lowerScoreData.value +
            pages['autonomus'].upperScoreData.value,
        'notes': pages['autonomus'].notesData.value,
      },
      'stageTeleop': {
        'cantShootDynamically': pages['teleop'].cantShootDynamicallyData.value,
        'anchorPoint': pages['teleop'].anchorPointData.value,
        'pickedFloor': pages['teleop'].ballsPickedFloorData.value,
        'pickedFeeder': pages['teleop'].ballsPickedFeederData.value,
        'hubMissed': pages['teleop'].ballsMissedData.value,
        'hubLower': pages['teleop'].lowerScoreData.value,
        'hubUpper': pages['teleop'].upperScoreData.value,
        'ballsShot': pages['teleop'].ballsMissedData.value +
            pages['teleop'].lowerScoreData.value +
            pages['teleop'].upperScoreData.value,
        'totalScore': pages['teleop'].lowerScoreData.value +
            pages['teleop'].upperScoreData.value * 2,
        'notes': pages['teleop'].notesData.value,
      },
      'stageEndgame': {
        'barClimbed': pages['endgame'].barClimbedData.value.toInt(),
        'secondsClimbed': pages['endgame'].secondsClimbedData.value,
        'notes': pages['endgame'].notesData.value,
      },
    }
  };
}

dynamic generatePitReportData(
    {String? id, String? reporterName, String? reporterTeam}) {
  return {
    id ?? generateReportId(): {
      'info': {
        'reporterName': reporterName ?? pages['home'].reporterNameData.value,
        'reporterTeam': reporterTeam ?? pages['home'].reporterTeamData.value,
        'teamNumber': int.tryParse(pages['pit_info'].currentTeamData.value) ??
            pages['info'].currentTeamData.value,
        'datetime': getDatetime(),
      },
      'shooting': {
        'canShootUpper': pages['pit'].canShootUpperData.value,
        'canShootLower': pages['pit'].canShootLowerData.value,
        'canAdjustShootAngle': pages['pit'].canAdjustShootAngleData.value,
        'hasTurret': pages['pit'].hasTurretData.value,
        'canShootWhileMoving': pages['pit'].canShootWhileMovingData.value,
        'cantShootDynamically': pages['pit'].cantShootDynamicallyData.value,
        'anchorPoint': pages['pit'].anchorPointData.value,
        'shootingHeight': pages['pit'].shootingHeightData.value,
      },
      'drivingType': pages['pit'].drivingTypeData.value,
      'whichBarCanClimb': pages['pit'].whichBarCanClimbData.value,
      'weaknesses': pages['pit'].weaknessesData.value,
      'notes': pages['pit'].notesData.value,
    }
  };
}

Future<void> sendReportToDatabase() async {
  if (lastReportType == ReportType.game) {
    await gameReportsReference.update(lastReport);
  } else {
    await pitReportsReference.update(lastReport);
  }
}

Future<void> updateNotes() async {
  dynamic notes = (await notesReference.get()).value;

  String teamNumber = pages['info'].currentTeamData.value.toString();

  notes ??= {};
  if (!notes.containsKey(teamNumber)) {
    notes[teamNumber] = {
      gameNumber! + '_' + pages['home'].reporterNameData.value: {
        'autonomus': pages['autonomus'].notesData.value,
        'teleop': pages['teleop'].notesData.value,
        'endgame': pages['endgame'].notesData.value,
      },
    };
  } else {
    notes[teamNumber].addAll({
      gameNumber! + '_' + pages['home'].reporterNameData.value: {
        'autonomus': pages['autonomus'].notesData.value,
        'teleop': pages['teleop'].notesData.value,
        'endgame': pages['endgame'].notesData.value,
      },
    });
  }

  await notesReference.update(Map<String, Object?>.from(notes));
}

Future<void> updateAverages() async {
  final snapshot = await averagesReference.get();
  dynamic averages = snapshot.value;

  String teamNumber = pages['info'].currentTeamData.value.toString();

  Map<dynamic, dynamic> currentTeamData = {};

  int ballsScored = pages['teleop'].lowerScoreData.value +
      pages['teleop'].upperScoreData.value;
  double scorePercent = (ballsScored /
          (ballsScored + pages['teleop'].ballsMissedData.value) *
          100)
      .toDouble();
  if (scorePercent.isNaN) scorePercent = 0.0;

  var barsCanClimb = [false, false, false, false];
  if (pages['endgame'].barClimbedData.value.toInt() != 0) {
    barsCanClimb[pages['endgame'].barClimbedData.value.toInt() - 1] = true;
  }

  if (averages == null || !averages.containsKey(teamNumber)) {
    currentTeamData = {
      'avgBallsAutonomus': pages['autonomus'].lowerScoreData.value +
          pages['autonomus'].upperScoreData.value,
      'avgScoreAutonomus': pages['autonomus'].lowerScoreData.value * 2 +
          pages['autonomus'].upperScoreData.value * 4 +
          (pages['autonomus'].robotMovedData.value ? 2 : 0),
      'avgLowerTeleop': pages['teleop'].lowerScoreData.value,
      'avgUpperTeleop': pages['teleop'].upperScoreData.value,
      'avgScorePercent': scorePercent,
      'avgScoreTeleop': pages['teleop'].lowerScoreData.value +
          pages['teleop'].upperScoreData.value * 2,
      'avgScoreTotal': pages['summary'].totalScoreData.value,
      'avgBarClimbed': pages['endgame'].barClimbedData.value.toInt(),
      'avgTimeClimbed':
          (pages['endgame'].secondsClimbedData.value ?? 0).toDouble(),
      'barsCanClimb': barsCanClimb,
      'avgRobotFocus': pages['summary'].robotFocusData.value,
      'numberOfReports': 1,
    };
  } else {
    currentTeamData = averages[teamNumber];
    double numberOfReports =
        (currentTeamData['numberOfReports'] ?? 1).toDouble();
    currentTeamData['numberOfReports'] = ++numberOfReports;

    double averageBallsAutonomus =
        (currentTeamData['avgBallsAutonomus'] ?? 0).toDouble();
    double ballsAutonomus = ((pages['autonomus'].lowerScoreData.value +
                pages['autonomus'].upperScoreData.value) ??
            0)
        .toDouble();
    currentTeamData['avgBallsAutonomus'] = averageBallsAutonomus +
        (ballsAutonomus - averageBallsAutonomus) / numberOfReports;

    double averageScoreAutonomus =
        (currentTeamData['avgScoreAutonomus'] ?? 0).toDouble();
    double scoreAutonomus = ((pages['autonomus'].lowerScoreData.value * 2 +
                pages['autonomus'].upperScoreData.value * 4 +
                (pages['autonomus'].robotMovedData.value ? 2 : 0)) ??
            0)
        .toDouble();
    currentTeamData['avgScoreAutonomus'] = averageScoreAutonomus +
        (scoreAutonomus - averageScoreAutonomus) / numberOfReports;

    double averageLowerHub =
        (currentTeamData['avgLowerTeleop'] ?? 0).toDouble();
    double lowerHub = (pages['teleop'].lowerScoreData.value ?? 0).toDouble();
    currentTeamData['avgLowerTeleop'] =
        averageLowerHub + (lowerHub - averageLowerHub) / numberOfReports;

    double averageUpperHub =
        (currentTeamData['avgUpperTeleop'] ?? 0).toDouble();
    double upperHub = (pages['teleop'].upperScoreData.value ?? 0).toDouble();
    currentTeamData['avgUpperTeleop'] =
        averageUpperHub + (upperHub - averageUpperHub) / numberOfReports;

    double averageScorePercent =
        (currentTeamData['avgScorePercent'] ?? 0).toDouble();
    int ballsScored = (pages['teleop'].lowerScoreData.value +
            pages['teleop'].upperScoreData.value)
        .toDouble();
    double scorePercent = (ballsScored /
            (ballsScored + pages['teleop'].ballsMissedData.value) *
            100)
        .toDouble();
    currentTeamData['avgScorePercent'] = averageScorePercent +
        (scorePercent - averageScorePercent) / numberOfReports;
    if (currentTeamData['avgScorePercent'].isNaN) {
      currentTeamData['avgScorePercent'] = 0.0;
    }

    double averageScoreTeleop =
        (currentTeamData['avgScoreTeleop'] ?? 0).toDouble();
    double scoreTeleop = ((pages['teleop'].lowerScoreData.value +
                pages['teleop'].upperScoreData.value * 2) ??
            0)
        .toDouble();
    currentTeamData['avgScoreTeleop'] = averageScoreTeleop +
        (scoreTeleop - averageScoreTeleop) / numberOfReports;

    double averageTotalScore =
        (currentTeamData['avgScoreTotal'] ?? 0).toDouble();
    double totalScore =
        ((pages['summary'].totalScoreData.value) ?? 0).toDouble();
    currentTeamData['avgScoreTotal'] =
        averageTotalScore + (totalScore - averageTotalScore) / numberOfReports;

    double averageBars = (currentTeamData['avgBarClimbed'] ?? 0).toDouble();
    double barClimbed = (pages['endgame'].barClimbedData.value ?? 0).toDouble();
    currentTeamData['avgBarClimbed'] =
        averageBars + (barClimbed - averageBars) / numberOfReports;

    double averageSecondsClimbed =
        (currentTeamData['avgSecondsClimbed'] ?? 0).toDouble();
    double secondsClimbed =
        (pages['endgame'].secondsClimbedData.value ?? 0).toDouble();
    currentTeamData['avgSecondsClimbed'] = averageSecondsClimbed +
        (secondsClimbed - averageSecondsClimbed) / numberOfReports;

    var barsCanClimb = currentTeamData['barsCanClimb'];
    if (pages['endgame'].barClimbedData.value.toInt() != 0) {
      barsCanClimb[pages['endgame'].barClimbedData.value.toInt() - 1] = true;
    }
    currentTeamData['barsCanClimb'] = barsCanClimb;

    double averageRobotFocus =
        (currentTeamData['avgRobotFocus'] ?? 0).toDouble();
    double robotFocus = (pages['summary'].robotFocusData.value ?? 0).toDouble();
    currentTeamData['avgRobotFocus'] =
        averageRobotFocus + (robotFocus - averageRobotFocus) / numberOfReports;
  }

  await averagesReference.update(
    {teamNumber: Map<String, Object?>.from(currentTeamData)},
  );
}
