import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../l10n/l10n_localizations.dart';

/// An enumeration representing various game tags used in the application.
///
/// Each tag corresponds to a specific category or genre of games, such as action, adventure, or puzzle.
/// These tags are utilized for organizing and categorizing games, providing users with a better understanding of the game's content.
enum Category {
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

  const Category(this.code, this.icon);

  /// Returns a [Category] based on the provided [code].
  ///
  /// If the [code] does not match any tag in [Category.values], returns [Category.error] as a fallback.
  static Category fromCode(String code) {
    try {
      return Category.values.firstWhere((element) => element.code == code);
    }
    catch (_) {
      return Category.error;
    }
  }

  /// Translates a list of tag codes into their respective localized strings.
  ///
  /// If a tag code does not have a localized name, the function returns a string with three question marks.
  static List<String> fromList(AppLocalizations localizations, List<String> tags) {
    final Map<String, String> table = <String, String> {
      Category.action.code: localizations.tgAction,
      Category.adventure.code: localizations.tgAdventure,
      Category.breakout.code: localizations.tgBreakout,
      Category.casual.code: localizations.tgCasual,
      Category.driving.code: localizations.tgDriving,
      Category.extremeSports.code: localizations.tgExtremeSports,
      Category.fighting.code: localizations.tgFighting,
      Category.football.code: localizations.tgFootball,
      Category.offRoad.code: localizations.tgOffRoad,
      Category.openWorld.code: localizations.tgOpenWorld,
      Category.pinball.code: localizations.tgPinball,
      Category.platformer.code: localizations.tgPlatformer,
      Category.pointAndClick.code: localizations.tgPointAndClick,
      Category.powerUps.code: localizations.tgPowerUps,
      Category.puzzle.code: localizations.tgPuzzle,
      Category.racing.code: localizations.tgRacing,
      Category.rally.code: localizations.tgRally,
      Category.runAndGun.code: localizations.tgRunAndGun,
      Category.scifi.code: localizations.tgSciFi,
      Category.shooter.code: localizations.tgShooter,
      Category.shootEmUp.code: localizations.tgShootEmUp,
      Category.sports.code: localizations.tgSports,
      Category.starfighter.code: localizations.tgStarfighter,
      Category.stealth.code: localizations.tgStealth,
      Category.strategy.code: localizations.tgStrategy,
      Category.survivalHorror.code: localizations.tgSurvivalHorror,
      Category.takedown.code: localizations.tgTakedown,
      Category.terror.code: localizations.tgTerror,
      Category.threeD.code: localizations.tg3D,
      Category.towerDefense.code: localizations.tgTowerDefense,
    };

    return tags.map((tag) => table[tag] ?? "???").toList();
  }

  /// Translates a tag code into its respective localized string.
  ///
  /// If a tag code does not have a localized name, the function returns a string with three question marks.
  String fromLocale(AppLocalizations localizations) {
    final Map<String, String> table = <String, String> {
      Category.action.code: localizations.tgAction,
      Category.adventure.code: localizations.tgAdventure,
      Category.breakout.code: localizations.tgBreakout,
      Category.casual.code: localizations.tgCasual,
      Category.driving.code: localizations.tgDriving,
      Category.extremeSports.code: localizations.tgExtremeSports,
      Category.fighting.code: localizations.tgFighting,
      Category.football.code: localizations.tgFootball,
      Category.offRoad.code: localizations.tgOffRoad,
      Category.openWorld.code: localizations.tgOpenWorld,
      Category.pinball.code: localizations.tgPinball,
      Category.platformer.code: localizations.tgPlatformer,
      Category.pointAndClick.code: localizations.tgPointAndClick,
      Category.powerUps.code: localizations.tgPowerUps,
      Category.puzzle.code: localizations.tgPuzzle,
      Category.racing.code: localizations.tgRacing,
      Category.rally.code: localizations.tgRally,
      Category.runAndGun.code: localizations.tgRunAndGun,
      Category.scifi.code: localizations.tgSciFi,
      Category.shooter.code: localizations.tgShooter,
      Category.shootEmUp.code: localizations.tgShootEmUp,
      Category.sports.code: localizations.tgSports,
      Category.starfighter.code: localizations.tgStarfighter,
      Category.stealth.code: localizations.tgStealth,
      Category.strategy.code: localizations.tgStrategy,
      Category.survivalHorror.code: localizations.tgSurvivalHorror,
      Category.takedown.code: localizations.tgTakedown,
      Category.terror.code: localizations.tgTerror,
      Category.threeD.code: localizations.tg3D,
      Category.towerDefense.code: localizations.tgTowerDefense,
    };

    return table[code] ?? "???";
  }
}