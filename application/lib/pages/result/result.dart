import 'package:flutter/material.dart';
import 'package:sensetive/models/reading_models.dart';
import 'mom_reading.dart';
import 'baby_reading.dart';

/// Page showing the result of a reading
class ReadingResultWidget extends StatefulWidget {
  final Reading momReading;
  final Reading babyReading;

  ReadingResultWidget(this.momReading, this.babyReading);

  @override
  _ReadingResultWidgetState createState() => _ReadingResultWidgetState();
}

class _ReadingResultWidgetState extends State<ReadingResultWidget> with SingleTickerProviderStateMixin{
  TabController _tabController;
  Reading _momReading;
  Reading _babyReading;


  void _tabChanged() {
    if (_tabController.indexIsChanging) {
      print('tabChanged: ${_tabController.index}');
    }
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_tabChanged);
    _momReading = widget.momReading;
    _babyReading = widget.babyReading;
  }


  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reading'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(
              text: 'Baby\'s reading',
            ),
            Tab(
              text: 'Moms\'s reading',
            )
          ],
        ),
      ),
      body: SafeArea(
        child: TabBarView(
          controller: _tabController,
          children: [
            BabyReadingWidget(_babyReading),
            MomReadingWidget(_momReading)
          ],
        ),
      ),
    );
  }
}


