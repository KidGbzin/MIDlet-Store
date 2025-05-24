enum Language {
  brazil("assets/flags/BR.gif", "Português Brasileiro"),
  czechRepublic("assets/flags/CZ.gif", "Čeština"),
  france("assets/flags/FR.gif", "Français"),
  germany("assets/flags/DE.gif", "Deutsch"),
  indonesia("assets/flags/ID.gif", "Bahasa Indonesia"),
  italy("assets/flags/IT.gif", "Italiano"),
  poland("assets/flags/PL.gif", "Polski"),
  portugal("assets/flags/PT.gif", "Português"),
  russia("assets/flags/RU.gif", "Русский"),
  spain("assets/flags/ES.gif", "Español"),
  unitedStates("assets/flags/US.gif", "English");

  final String asset;

  final String title;

  const Language(this.asset, this.title);

  static Language? fromCode(String code) {
    switch (code.toUpperCase()) {
      case "BR": return Language.brazil;
      case "CZ": return Language.czechRepublic;
      case "DE": return Language.germany;
      case "EN": return Language.unitedStates;
      case "ES": return Language.spain;
      case "FR": return Language.france;
      case "ID": return Language.indonesia;
      case "IT": return Language.italy;
      case "PL": return Language.poland;
      case "PT": return Language.portugal;
      case "RU": return Language.russia;
      default: return null;
    }
  }
}