part of '../modals_factory.dart';

/// Creates a [Modals.midlets] content showing the midlets available from a game.
class _MIDlets extends StatefulWidget {

  const _MIDlets({
    required this.installMIDlet,
    required this.midlets,
  });

  /// The current game midlets available.
  final List<MIDlet> midlets;

  /// The function to install the midlet into the enulator.
  final void Function(MIDlet) installMIDlet;

  @override
  State<_MIDlets> createState() => _MIDletsState();
}

class _MIDletsState extends State<_MIDlets> with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  late final List<String> _resolutions;

  @override
  void initState() {
    _resolutions = _getResolutionsAvailable();
    _tabController = TabController(
      length: _resolutions.length,
      vsync: this,
    );

    super.initState();
  }

  /// Get all the current resolutions available.
  /// 
  /// This resolution list will be used to build the [TabBar].
  List<String> _getResolutionsAvailable() {
    final List<String> resolutions = <String> [];
    for (MIDlet element in widget.midlets) {
      if (!resolutions.contains(element.resolution)) {
        resolutions.add(element.resolution);
      }
    }
    return resolutions;
  }

  /// Return a list of MIDlets categorized by screen resolution.
  /// 
  /// This lists will be used to build the [TabBarView].
  List<List<MIDlet>> _getMIDletsFromResolution() {
    final List<List<MIDlet>> temporary = <List<MIDlet>> [];
    for (String index in _resolutions) {
      temporary.add(widget.midlets.where((midlet) {
        return midlet.resolution == index;
      }).toList());
    }
    return temporary;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget> [
        SizedBox(
          height: 45,
          child: Material(
            color: Palette.background.color,
            child: TabBar(
              controller: _tabController,
              isScrollable: true,
              physics: const ClampingScrollPhysics(),
              tabs: _resolutions.map(_tab).toList(),
              tabAlignment: TabAlignment.start,
              indicatorSize: TabBarIndicatorSize.tab,
            ),
          ),
        ),
        Container(
          height: 45,
          padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
          child: Row(
            children: <Widget> [
              SizedBox(
                width: 60,
                child: Text(
                  "Version",
                  style: Typographies.body(Palette.disabled).style,
                ),
              ),
              SizedBox(
                width: 75,
                child: Center(
                  child: Text(
                    "Size",
                    style: Typographies.body(Palette.disabled).style,
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: Text(
                    "Language",
                    style: Typographies.body(Palette.disabled).style,
                  ),
                ),
              ),
              const SizedBox.square(
                dimension: 40,
              ),
            ],
          ),
        ),
        Divider(
          color: Palette.divider.color,
          height: 1,
          thickness: 1,
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: _getMIDletsFromResolution().map(_listView).toList(),
          ),
        ),
      ],
    );
  }

  Widget _listView(List<MIDlet> midlets) {
    return ListView.separated(
      itemBuilder: (BuildContext context, int index) {
        return _Tile(
          midlet: midlets[index],
          installMIDlet: widget.installMIDlet,
        );
      },
      itemCount: midlets.length,
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 25),
      separatorBuilder: (context, index) {
        return Divider(
          color: Palette.transparent.color,
          height: 1,
          thickness: 1,
        );
      },
    );
  }

  Widget _tab(String resolution) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 2.5, 0, 0),
      child: Tab(
        text: resolution.replaceAll('x', ' x '),
      ),
    );
  }
}

/// The midlet tile widget.
class _Tile extends StatelessWidget {

  const _Tile({
    required this.installMIDlet,
    required this.midlet,
  });

  /// The current midlet.
  final MIDlet midlet;

  /// A function to be actived when the tile is tapped.
  final void Function(MIDlet) installMIDlet;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        installMIDlet(midlet);
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
        child: SizedBox(
          height: 45,
          child: Row(
            children: <Widget> [
              SizedBox(
                width: 60,
                child: Text(
                  midlet.version,
                  style: Typographies.body(Palette.elements).style,
                ),
              ),
              SizedBox(
                width: 75,
                child: Center(
                  child: Text(
                    "${(midlet.size / 1024).round()} KB",
                    style: Typographies.body(Palette.elements).style,
                  ),
                ),
              ),
              Expanded(
                child: Wrap(
                  alignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 2.5,
                  runSpacing: 2.5,
                  children: midlet.languages.map(_flag).toList(),
                ),
              ),
              SizedBox.square(
                dimension: 40,
                child: Icon(
                  Icons.arrow_right_rounded,
                  color: Palette.elements.color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Create a flag icon using a country code.
  Widget _flag(String code) {
    if (code == "EN") code = "UK";
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          width: 1,
          color: Palette.disabled.color,
        ),
        borderRadius: BorderRadius.circular(5),
        image: DecorationImage(
          image: AssetImage(
            'assets/flags/$code.png',
          ),
          fit: BoxFit.cover,
        ),
      ),
      foregroundDecoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        gradient: RadialGradient(
          colors: <Color> [
            Palette.transparent.color,
            Palette.background.color,
          ],
          radius: 1.75,
        ),
      ),
      height: 15,
      width: 15 * 1.45,
    );
  }
}