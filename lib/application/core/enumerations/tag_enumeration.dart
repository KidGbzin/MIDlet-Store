import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n_localizations.dart';
import 'package:hugeicons/hugeicons.dart';

/// A enumeration of all game tags present in the application.
enum TagEnumeration {
  threeD(
    icon: HugeIcons.strokeRoundedThreeDView,
    code: '3D',
  ),
  action(
    icon: HugeIcons.strokeRoundedEnergy,
    code: 'ACT',
  ),
  adventure(
    icon: HugeIcons.strokeRoundedDiscoverCircle,
    code: 'ADV',
  ),
  casual(
    icon: HugeIcons.strokeRoundedPacman02,
    code: 'CAS',
  ),
  football(
    icon: HugeIcons.strokeRoundedFootballPitch,
    code: 'FOO',
  ),
  fighting(
    icon: HugeIcons.strokeRoundedBoxingGlove01,
    code: 'FIG',
  ),
  openWorld(
    icon: HugeIcons.strokeRoundedLocation04,
    code: 'OPW',
  ),
  platformer(
    code: 'PLA',
    icon: HugeIcons.strokeRoundedSuperMario,
  ),
  pointAndClick(
    icon: HugeIcons.strokeRoundedTouch02,
    code: 'P&C',
  ),
  puzzle(
    icon: HugeIcons.strokeRoundedPuzzle,
    code: 'PUZ',
  ),
  racing(
    icon: HugeIcons.strokeRoundedCar02,
    code: 'RAC',
  ),
  shooter(
    icon: HugeIcons.strokeRoundedTarget03,
    code: 'SHO',
  ),
  sports(
    icon: HugeIcons.strokeRoundedFootball,
    code: 'SPO',
  ),
  stealth(
    icon: HugeIcons.strokeRoundedEar,
    code: 'STE',
  ),
  survivalHorror(
    icon: HugeIcons.strokeRoundedDna,
    code: 'SUH',
  ),
  terror(
    icon: HugeIcons.strokeRoundedDanger,
    code: 'TER',
  ),
  towerDefense(
    icon: HugeIcons.strokeRoundedCastle01,
    code: 'TWD',
  );

  const TagEnumeration({
    required this.icon,
    required this.code,
  });

  /// The tag's icon.
  /// 
  /// This icon is used on labels.
  final IconData icon;

  /// The tag's name.
  final String code;

  /// Translates a list of tag codes into their respective localized strings.
  ///
  /// If a tag code does not have a localized name, the function returns a string with three question marks.
  static List<String> fromList(AppLocalizations localizations, List<String> tags) {
    final Map<String, String> table = <String, String> {
      "3D": localizations.tag3D,
      "ACT": localizations.tagAction,
      "ADV": localizations.tagAdventure,
      "CAS": localizations.tagCasual,
      "FIG": localizations.tagFighting,
      "FOO": localizations.tagFootball,
      "H&S": localizations.tagHackAndSlash,
      "MET": localizations.tagMetroidvania,
      "OPW": localizations.tagOpenWorld,
      "PLA": localizations.tagPlatformer,
      "P&C": localizations.tagPointAndClick,
      "PUZ": localizations.tagPuzzle,
      "RAC": localizations.tagRacing,
      "SHO": localizations.tagShooter,
      "SPO": localizations.tagSports,
      "STE": localizations.tagStealth,
      "SUH": localizations.tagSurvivalHorror,
      "TER": localizations.tagTerror,
      "TWD": localizations.tagTowerDefense,
    };

    return tags.map((tag) => table[tag] ?? "???").toList();
  }

  /// Translates a tag code into its respective localized string.
  ///
  /// If a tag code does not have a localized name, then function returns a strig with three question marks.
  String fromLocale(AppLocalizations localizations) {
    final Map<String, String> table = <String, String> {
      "3D": localizations.tag3D,
      "ACT": localizations.tagAction,
      "ADV": localizations.tagAdventure,
      "CAS": localizations.tagCasual,
      "FIG": localizations.tagFighting,
      "FOO": localizations.tagFootball,
      "H&S": localizations.tagHackAndSlash,
      "MET": localizations.tagMetroidvania,
      "OPW": localizations.tagOpenWorld,
      "PLA": localizations.tagPlatformer,
      "P&C": localizations.tagPointAndClick,
      "PUZ": localizations.tagPuzzle,
      "RAC": localizations.tagRacing,
      "SHO": localizations.tagShooter,
      "SPO": localizations.tagSports,
      "STE": localizations.tagStealth,
      "SUH": localizations.tagSurvivalHorror,
      "TER": localizations.tagTerror,
      "TWD": localizations.tagTowerDefense,
    };

    return table[code] ?? "???";
  }
}

