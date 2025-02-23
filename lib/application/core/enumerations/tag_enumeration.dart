import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n_localizations.dart';
import 'package:hugeicons/hugeicons.dart';

/// An enumeration of all game tags present in the application.
enum TagEnumeration {
  action(
    code: 'Action',
    icon: HugeIcons.strokeRoundedEnergy,
  ),
  adventure(
    code: 'Adventurer',
    icon: HugeIcons.strokeRoundedDiscoverCircle,
  ),
  breakout(
    code: 'Breakout',
    icon: HugeIcons.strokeRoundedBlockGame,
  ),
  casual(
    code: 'Casual',
    icon: HugeIcons.strokeRoundedPacman02,
  ),
  error(
    code: '???',
    icon: HugeIcons.strokeRoundedUnavailable,
  ),
  fighting(
    code: 'Fighting',
    icon: HugeIcons.strokeRoundedBoxingGlove01,
  ),
  football(
    code: 'Football',
    icon: HugeIcons.strokeRoundedFootballPitch,
  ),
  openWorld(
    code: 'Open World',
    icon: HugeIcons.strokeRoundedLocation04,
  ),
  platformer(
    code: 'Platformer',
    icon: HugeIcons.strokeRoundedSuperMario,
  ),
  pointAndClick(
    code: "Point 'n' Click",
    icon: HugeIcons.strokeRoundedTouch02,
  ),
  puzzle(
    code: 'Puzzle',
    icon: HugeIcons.strokeRoundedPuzzle,
  ),
  racing(
    code: 'Racing',
    icon: HugeIcons.strokeRoundedCar02,
  ),
  shooter(
    code: 'Shooter',
    icon: HugeIcons.strokeRoundedTarget03,
  ),
  sports(
    code: 'Sports',
    icon: HugeIcons.strokeRoundedWhistle,
  ),
  stealth(
    code: 'Stealth',
    icon: HugeIcons.strokeRoundedEar,
  ),
  survivalHorror(
    code: 'Survival Horror',
    icon: HugeIcons.strokeRoundedDna,
  ),
  terror(
    code: 'Terror',
    icon: HugeIcons.strokeRoundedDanger,
  ),
  threeD(
    code: '3D',
    icon: HugeIcons.strokeRoundedThreeDView,
  ),
  towerDefense(
    code: 'Tower Defense',
    icon: HugeIcons.strokeRoundedCastle01,
  );

  /// Creates a [TagEnumeration] with the given properties.
  const TagEnumeration({
    required this.code,
    required this.icon,
  });

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
    } catch (_) {
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
      TagEnumeration.casual.code: localizations.tagCasual,
      TagEnumeration.error.code: "???",
      TagEnumeration.fighting.code: localizations.tagFighting,
      TagEnumeration.football.code: localizations.tagFootball,
      TagEnumeration.openWorld.code: localizations.tagOpenWorld,
      TagEnumeration.platformer.code: localizations.tagPlatformer,
      TagEnumeration.pointAndClick.code: localizations.tagPointAndClick,
      TagEnumeration.puzzle.code: localizations.tagPuzzle,
      TagEnumeration.racing.code: localizations.tagRacing,
      TagEnumeration.shooter.code: localizations.tagShooter,
      TagEnumeration.sports.code: localizations.tagSports,
      TagEnumeration.stealth.code: localizations.tagStealth,
      TagEnumeration.survivalHorror.code: localizations.tagSurvivalHorror,
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
      TagEnumeration.casual.code: localizations.tagCasual,
      TagEnumeration.fighting.code: localizations.tagFighting,
      TagEnumeration.football.code: localizations.tagFootball,
      TagEnumeration.openWorld.code: localizations.tagOpenWorld,
      TagEnumeration.platformer.code: localizations.tagPlatformer,
      TagEnumeration.pointAndClick.code: localizations.tagPointAndClick,
      TagEnumeration.puzzle.code: localizations.tagPuzzle,
      TagEnumeration.racing.code: localizations.tagRacing,
      TagEnumeration.shooter.code: localizations.tagShooter,
      TagEnumeration.sports.code: localizations.tagSports,
      TagEnumeration.stealth.code: localizations.tagStealth,
      TagEnumeration.survivalHorror.code: localizations.tagSurvivalHorror,
      TagEnumeration.terror.code: localizations.tagTerror,
      TagEnumeration.threeD.code: localizations.tag3D,
      TagEnumeration.towerDefense.code: localizations.tagTowerDefense,
    };

    return table[code] ?? "???";
  }
}