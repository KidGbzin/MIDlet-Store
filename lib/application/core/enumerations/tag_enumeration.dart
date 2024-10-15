import 'package:flutter/material.dart';

/// A enumeration of all game tags present in the application.
enum Tag {
  threed(
    description: 'Discover new worlds with stunning realism! In the 3D category, immersion is total, with immersive graphics, dynamic gameplay and breathtaking three-dimensional environments. Get ready to live an experience beyond the screens!',
    icon: Icons.threed_rotation_rounded,
    name: '3D',
  ),
  action(
    description: 'Get ready for adrenaline-pumping action and thrilling challenges! In the Action category, each game offers intense battles, quick reflexes and breathtaking missions. Master your skills and face powerful enemies in thrilling adventures!',
    icon: Icons.electric_bolt_rounded,
    name: 'Action',
  ),
  adventure(
    description: 'Embark on epic journeys filled with mystery and exploration! In the Adventure category, each game takes you to incredible worlds where you will face unexpected challenges, solve puzzles, and experience unforgettable stories. Fun awaits!',
    icon: Icons.explore_rounded,
    name: 'Adventure',
  ),
  casual(
    description: 'Relax and have fun with quick and easy games! In the Casual category, you will find easy-to-learn games, perfect for passing the time and relaxing. Simple and addictive challenges await you at any time!',
    name: 'Casual',
    icon: Icons.house_rounded,
  ),
  football(
    description: 'Get on the field and show off your talent with the ball! In the Soccer category, you control the plays, perform incredible dribbles and score decisive goals. Build your dream team and win championships in exciting matches!',
    name: 'Football',
    icon: Icons.sports_soccer_rounded,
  ),
  openWorld(
    description: 'Explore a vast and limitless universe! In the Open World category, you have complete freedom to discover incredible landscapes, undertake quests and create your own adventure. Immerse yourself in an expansive world and experience unique stories your way!',
    name: 'Open World',
    icon: Icons.navigation_rounded,
  ),
  platformer(
    description: 'Get ready to jump and climb your way through vibrant and challenging worlds! In the Platformer category, you’ll face obstacles, perform acrobatic maneuvers and explore action-packed levels. Test your skills and conquer each level with agility and precision.',
    name: 'Platformer',
    icon: Icons.directions_run,
  ),
  pointAndClick(
    description: 'Unravel mysteries and explore intriguing worlds with just one click! In the Point & Click category, each scenario is full of secrets waiting to be discovered. Solve puzzles, make decisions and embark on immersive adventures where the story is in your hands!',
    name: 'Point & Click',
    icon: Icons.touch_app_rounded,
  ),
  puzzle(
    description: 'Challenge your mind and test your reasoning skills! In the Puzzle category, each game offers clever riddles and addictive puzzles that will keep you engaged. Get ready to train your brain and find creative solutions!',
    name: 'Puzzle',
    icon: Icons.extension_rounded,
  ),
  racing(
    description: 'Step on the gas and feel the adrenaline rush on the tracks! In the Racing category, speed is your best ally. Compete in exciting races, challenge your limits and achieve victory in mind-blowing scenarios. Are you ready to be the champion?',
    name: 'Racing',
    icon: Icons.motorcycle_rounded,
  ),
  shooter(
    description: 'Enter the battlefield and test your aim! In the Shooting category, the action is intense, with powerful weapons, realistic scenarios and relentless enemies. Get ready to challenge your reflexes and be the last one standing!',
    icon: Icons.local_fire_department_rounded,
    name: 'Shooter',
  ),
  sports(
    description: 'Experience the excitement of major sporting events! In the Sports category, you can compete in a variety of sports, from football to basketball, in exciting and realistic challenges. Show off your skills and lead your team to victory!',
    name: 'Sports',
    icon: Icons.sports_rounded,
  ),
  stealth(
    description: 'Be silent, strategic and lethal! In the Stealth category, patience and planning are your greatest weapons. Infiltrate enemy territories, avoid detection and complete your missions without leaving a trace. Every move counts in the art of stealth!',
    name: 'Stealth',
    icon: Icons.noise_aware_rounded,
  ),
  terror(
    description: 'Face your fears and dive into the unknown! In the Horror category, the tension is constant and the suspense is palpable. Face terrifying creatures, solve sinister mysteries and survive hair-raising experiences. Get ready for a true dose of fear!',
    name: 'Terror',
    icon: Icons.church_rounded,
  ),
  zombies(
    description: 'Survive the apocalypse and face the terror of the undead! In the Zombies category, you will fight against hordes of reanimated creatures, scavenge for resources and try to keep hope alive in a devastated world. Prepare for battle and defy the end of times!',
    name: 'Zombies',
    icon: Icons.coronavirus_rounded,
  );

  const Tag({
    required this.description,
    required this.icon,
    required this.name,
  });

  /// The tag's description.
  /// 
  /// This description is used on the [Home] view category section.
  final String description;

  /// The tag's icon.
  /// 
  /// This icon is used on labels.
  final IconData icon;

  /// The tag's name.
  final String name;
}