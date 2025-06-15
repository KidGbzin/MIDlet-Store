import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../l10n/l10n_localizations.dart';

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
  pinball("Pinball", HugeIcons.strokeRoundedJoystick05),
  platformer('Platformer', HugeIcons.strokeRoundedSuperMario),
  pointAndClick("Point 'n' Click", HugeIcons.strokeRoundedTouch02),
  powerUps("Power-Ups", HugeIcons.strokeRoundedPackageOpen),
  puzzle('Puzzle', HugeIcons.strokeRoundedPuzzle),
  racing('Racing', HugeIcons.strokeRoundedRacingFlag),
  rally('Rally', HugeIcons.strokeRoundedCar03),
  runAndGun("Run 'n' Gun", HugeIcons.strokeRoundedGun),
  scifi('Sci-Fi', HugeIcons.strokeRoundedMachineRobot),
  strategy("Strategy", HugeIcons.strokeRoundedStrategy),
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

  /// Icon used to visually represent the tag.
  final IconData icon;

  /// Tag's identifier name in English.
  final String code;

  const TagEnumeration(this.code, this.icon);

  /// Returns a [TagEnumeration] based on the provided [code].
  ///
  /// If the [code] does not match any tag in [TagEnumeration.values], returns [TagEnumeration.error] as a fallback.
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
      TagEnumeration.action.code: localizations.tgAction,
      TagEnumeration.adventure.code: localizations.tgAdventure,
      TagEnumeration.breakout.code: localizations.tgBreakout,
      TagEnumeration.casual.code: localizations.tgCasual,
      TagEnumeration.driving.code: localizations.tgDriving,
      TagEnumeration.extremeSports.code: localizations.tgExtremeSports,
      TagEnumeration.fighting.code: localizations.tgFighting,
      TagEnumeration.football.code: localizations.tgFootball,
      TagEnumeration.offRoad.code: localizations.tgOffRoad,
      TagEnumeration.openWorld.code: localizations.tgOpenWorld,
      TagEnumeration.pinball.code: localizations.tgPinball,
      TagEnumeration.platformer.code: localizations.tgPlatformer,
      TagEnumeration.pointAndClick.code: localizations.tgPointAndClick,
      TagEnumeration.powerUps.code: localizations.tgPowerUps,
      TagEnumeration.puzzle.code: localizations.tgPuzzle,
      TagEnumeration.racing.code: localizations.tgRacing,
      TagEnumeration.rally.code: localizations.tgRally,
      TagEnumeration.runAndGun.code: localizations.tgRunAndGun,
      TagEnumeration.scifi.code: localizations.tgSciFi,
      TagEnumeration.shooter.code: localizations.tgShooter,
      TagEnumeration.shootEmUp.code: localizations.tgShootEmUp,
      TagEnumeration.sports.code: localizations.tgSports,
      TagEnumeration.starfighter.code: localizations.tgStarfighter,
      TagEnumeration.stealth.code: localizations.tgStealth,
      TagEnumeration.strategy.code: localizations.tgStrategy,
      TagEnumeration.survivalHorror.code: localizations.tgSurvivalHorror,
      TagEnumeration.takedown.code: localizations.tgTakedown,
      TagEnumeration.terror.code: localizations.tgTerror,
      TagEnumeration.threeD.code: localizations.tg3D,
      TagEnumeration.towerDefense.code: localizations.tgTowerDefense,
    };

    return tags.map((tag) => table[tag] ?? "???").toList();
  }

  /// Translates a tag code into its respective localized string.
  ///
  /// If a tag code does not have a localized name, the function returns a string with three question marks.
  String fromLocale(AppLocalizations localizations) {
    final Map<String, String> table = <String, String> {
      TagEnumeration.action.code: localizations.tgAction,
      TagEnumeration.adventure.code: localizations.tgAdventure,
      TagEnumeration.breakout.code: localizations.tgBreakout,
      TagEnumeration.casual.code: localizations.tgCasual,
      TagEnumeration.driving.code: localizations.tgDriving,
      TagEnumeration.extremeSports.code: localizations.tgExtremeSports,
      TagEnumeration.fighting.code: localizations.tgFighting,
      TagEnumeration.football.code: localizations.tgFootball,
      TagEnumeration.offRoad.code: localizations.tgOffRoad,
      TagEnumeration.openWorld.code: localizations.tgOpenWorld,
      TagEnumeration.pinball.code: localizations.tgPinball,
      TagEnumeration.platformer.code: localizations.tgPlatformer,
      TagEnumeration.pointAndClick.code: localizations.tgPointAndClick,
      TagEnumeration.powerUps.code: localizations.tgPowerUps,
      TagEnumeration.puzzle.code: localizations.tgPuzzle,
      TagEnumeration.racing.code: localizations.tgRacing,
      TagEnumeration.rally.code: localizations.tgRally,
      TagEnumeration.runAndGun.code: localizations.tgRunAndGun,
      TagEnumeration.scifi.code: localizations.tgSciFi,
      TagEnumeration.shooter.code: localizations.tgShooter,
      TagEnumeration.shootEmUp.code: localizations.tgShootEmUp,
      TagEnumeration.sports.code: localizations.tgSports,
      TagEnumeration.starfighter.code: localizations.tgStarfighter,
      TagEnumeration.stealth.code: localizations.tgStealth,
      TagEnumeration.strategy.code: localizations.tgStrategy,
      TagEnumeration.survivalHorror.code: localizations.tgSurvivalHorror,
      TagEnumeration.takedown.code: localizations.tgTakedown,
      TagEnumeration.terror.code: localizations.tgTerror,
      TagEnumeration.threeD.code: localizations.tg3D,
      TagEnumeration.towerDefense.code: localizations.tgTowerDefense,
    };

    return table[code] ?? "???";
  }
}