enum PlaythroughTime {
  oneHour,
  threeHours,
  fiveHours,
  tenHours,
  twentyHours;

  static PlaythroughTime toIndex(String value) {
    switch (value) {
      case '1H':
        return PlaythroughTime.oneHour;
      case '3H':
        return PlaythroughTime.threeHours;
      case '5H':
        return PlaythroughTime.fiveHours;
      case '10H':
        return PlaythroughTime.tenHours;
      case '20H':
        return PlaythroughTime.twentyHours;
      default:
        return PlaythroughTime.oneHour;
    }
  }
}