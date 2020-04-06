import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fresto_apps/apis/client_api.dart';
import 'package:fresto_apps/models_data/maps_data/map_track_data.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class MapTrackScreen extends StatefulWidget {
  @override
  _MapTrackScreenState createState() => _MapTrackScreenState();
}

class _MapTrackScreenState extends State<MapTrackScreen> {
  Widget _logicSection(
      MapTrackData mapTrackData, List<DocumentSnapshot> documents) {
    mapTrackData
        .setClientPosition(mapTrackData.clientFromSnapshot(documents).position);
    return SizedBox();
  }

  Widget _mapSection(BuildContext context, MapTrackData mapTrackData) {
    return GoogleMap(
      onMapCreated: mapTrackData.onMapCreated,
      initialCameraPosition: mapTrackData.initialCameraPosition(),
      markers: mapTrackData.markers,
      circles: mapTrackData.circles,
      onCameraMove: mapTrackData.updatePosition,
    );
  }

  Widget _loadingScreen(BuildContext context, MapTrackData mapTrackData) {
    if (!mapTrackData.isFetching) return SizedBox();
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.white.withOpacity(0.5),
      child: Center(
        child: CircularProgressIndicator(
          backgroundColor: Colors.green,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MapTrackData>(
      builder: (context, mapTrackData, child) {
        return StreamBuilder<QuerySnapshot>(
          stream: ClientAPI.listenSingleClient(
              clientUid: mapTrackData.client.userUid),
          builder: (context, snapshot) {
            return Scaffold(
              appBar: AppBar(
                title: Text("Track Client"),
                actions: <Widget>[
                  IconButton(
                    onPressed: mapTrackData.onButtonPressed1,
                    icon: Icon(Icons.email),
                  ),
                ],
              ),
              body: Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  _logicSection(mapTrackData, snapshot.data.documents),
                  _mapSection(context, mapTrackData),
                  _loadingScreen(context, mapTrackData)
                ],
              ),
            );
          },
        );
      },
    );
  }
}
