import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../l10n/l10n_localizations.dart';

// TAG ENUMERATION 🏷️: ========================================================================================================================================================== //

/// An enumeration representing various game tags used in the application.
///
/// Each tag corresponds to a specific category or genre of games, such as action, adventure, or puzzle.
/// These tags are utilized for organizing and categorizing games, providing users with a better understanding of the game's content.
enum TagEnumeration {
  action('Action', HugeIcons.strokeRoundedEnergy),
  adventure('Adventure', HugeIcons.strokeRoundedDiscoverCircle),
  breakout('Breakout', HugeIcons.strokeRoundedBlockGame),
  casual('Casual', HugeIcons.strokeRoundedPacman02),
  driving('Driving', HugeIcons.strokeRoundedSteering),
  extremeSports('Extreme Sports', HugeIcons.strokeRoundedFlyingHuman),
  error('???', HugeIcons.strokeRoundedUnavailable),
  fighting('Fighting', HugeIcons.strokeRoundedBoxingGlove01),
  football('Football', HugeIcons.strokeRoundedFootballPitch),
  offRoad('Off-Road', HugeIcons.strokeRoundedRoad01),
  openWorld('Open World', HugeIcons.strokeRoundedLocation04),
  platformer('Platformer', HugeIcons.strokeRoundedSuperMario),
  pointAndClick("Point 'n' Click", HugeIcons.strokeRoundedTouch02),
  puzzle('Puzzle', HugeIcons.strokeRoundedPuzzle),
  racing('Racing', HugeIcons.strokeRoundedRacingFlag),
  rally('Rally', HugeIcons.strokeRoundedCar03),
  scifi('Sci-Fi', HugeIcons.strokeRoundedMachineRobot),
  shooter('Shooter', HugeIcons.strokeRoundedTarget03),
  shootEmUp('Shoot \'Em Up', HugeIcons.strokeRoundedAircraftGame),
  sports('Sports', HugeIcons.strokeRoundedWhistle),
  starfighter('Starfighter', HugeIcons.strokeRoundedSaturn),
  stealth('Stealth', HugeIcons.strokeRoundedEar),
  survivalHorror('Survival Horror', HugeIcons.strokeRoundedDna),
  takedown('Takedown', HugeIcons.strokeRoundedAccident),
  terror('Terror', HugeIcons.strokeRoundedDanger),
  threeD('3D', HugeIcons.strokeRoundedCube),
  towerDefense('Tower Defense', HugeIcons.strokeRoundedCastle01);

  const TagEnumeration(this.code, this.icon);

  /// The tag's icon.
  ///
  /// This icon is used on labels.
  final IconData icon;

  /// The tag's code.
  ///
  /// The code is the tag's name in English.
  final String code;

  /// Returns a [TagEnumeration] based on the provided [code].
  ///
  /// If [code] does not match any tag, returns [TagEnumeration.error].
  static TagEnumeration fromCode(String code) {
    try {
      return TagEnumeration.values.firstWhere((element) => element.code == code);
    }
    catch (_) {
      return TagEnumeration.error;
    }
  }

  /// Translates a list of tag codes into their respective localized strings.
  ///
  /// If a tag code does not have a localized name, the function returns a string with three question marks.
  static List<String> fromList(AppLocalizations localizations, List<String> tags) {
    final Map<String, String> table = <String, String> {
      TagEnumeration.action.code: localizations.tagAction,
      TagEnumeration.adventure.code: localizations.tagAdventure,
      TagEnumeration.breakout.code: localizations.tagBreakout,
      TagEnumeration.casual.code: localizations.tagCasual,
      TagEnumeration.driving.code: localizations.tagDriving,
      TagEnumeration.extremeSports.code: localizations.tagExtremeSports,
      TagEnumeration.error.code: "???",
      TagEnumeration.fighting.code: localizations.tagFighting,
      TagEnumeration.football.code: localizations.tagFootball,
      TagEnumeration.offRoad.code: localizations.tagOffRoad,
      TagEnumeration.openWorld.code: localizations.tagOpenWorld,
      TagEnumeration.platformer.code: localizations.tagPlatformer,
      TagEnumeration.pointAndClick.code: localizations.tagPointAndClick,
      TagEnumeration.puzzle.code: localizations.tagPuzzle,
      TagEnumeration.racing.code: localizations.tagRacing,
      TagEnumeration.rally.code: localizations.tagRally,
      TagEnumeration.scifi.code: localizations.tagSciFi,
      TagEnumeration.shooter.code: localizations.tagShooter,
      TagEnumeration.shootEmUp.code: localizations.tagShootEmUp,
      TagEnumeration.sports.code: localizations.tagSports,
      TagEnumeration.starfighter.code: localizations.tagStarfighter,
      TagEnumeration.stealth.code: localizations.tagStealth,
      TagEnumeration.survivalHorror.code: localizations.tagSurvivalHorror,
      TagEnumeration.takedown.code: localizations.tagTakedown,
      TagEnumeration.terror.code: localizations.tagTerror,
      TagEnumeration.threeD.code: localizations.tag3D,
      TagEnumeration.towerDefense.code: localizations.tagTowerDefense,
    };

    return tags.map((tag) => table[tag] ?? "???").toList();
  }

  /// Translates a tag code into its respective localized string.
  ///
  /// If a tag code does not have a localized name, the function returns a string with three question marks.
  String fromLocale(AppLocalizations localizations) {
    final Map<String, String> table = <String, String> {
      TagEnumeration.action.code: localizations.tagAction,
      TagEnumeration.adventure.code: localizations.tagAdventure,
      TagEnumeration.breakout.code: localizations.tagBreakout,
      TagEnumeration.casual.code: localizations.tagCasual,
      TagEnumeration.driving.code: localizations.tagDriving,
      TagEnumeration.extremeSports.code: localizations.tagExtremeSports,
      TagEnumeration.fighting.code: localizations.tagFighting,
      TagEnumeration.football.code: localizations.tagFootball,
      TagEnumeration.offRoad.code: localizations.tagOffRoad,
      TagEnumeration.openWorld.code: localizations.tagOpenWorld,
      TagEnumeration.platformer.code: localizations.tagPlatformer,
      TagEnumeration.pointAndClick.code: localizations.tagPointAndClick,
      TagEnumeration.puzzle.code: localizations.tagPuzzle,
      TagEnumeration.racing.code: localizations.tagRacing,
      TagEnumeration.rally.code: localizations.tagRally,
      TagEnumeration.scifi.code: localizations.tagSciFi,
      TagEnumeration.shooter.code: localizations.tagShooter,
      TagEnumeration.shootEmUp.code: localizations.tagShootEmUp,
      TagEnumeration.sports.code: localizations.tagSports,
      TagEnumeration.starfighter.code: localizations.tagStarfighter,
      TagEnumeration.stealth.code: localizations.tagStealth,
      TagEnumeration.survivalHorror.code: localizations.tagSurvivalHorror,
      TagEnumeration.takedown.code: localizations.tagTakedown,
      TagEnumeration.terror.code: localizations.tagTerror,
      TagEnumeration.threeD.code: localizations.tag3D,
      TagEnumeration.towerDefense.code: localizations.tagTowerDefense,
    };

    return table[code] ?? "???";
  }
}