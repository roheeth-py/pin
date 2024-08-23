import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pin_point/models/place_model.dart';
import 'package:pin_point/screens/details_screen.dart';

import '../providers/place_provider.dart';
import 'new_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() {
    return HomeScreenState();
  }
}

class HomeScreenState extends ConsumerState<HomeScreen> {
  late Future<void> places;

  void newScreenNavigator(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) {
          return NewScreen();
        },
      ),
    );
  }

  @override
  void initState() {
    places = ref.read(placeProvider.notifier).loadPlace();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<PlaceModel> dataset = ref.watch(placeProvider);

    return Scaffold(
      appBar: AppBar(

        title:
            Image.asset("lib/assest/app.png", width: 95, fit: BoxFit.contain,),
        centerTitle: true,
      ),
      body: FutureBuilder(
          future: places,
          builder: (ctx, snapshot) {
            return snapshot.connectionState == ConnectionState.waiting
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : dataset.isNotEmpty
                    ? ListView.builder(
                        itemCount: dataset.length,
                        itemBuilder: (ctx, item) {
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundImage: FileImage(dataset[item].picture),
                            ),
                            title: Text(dataset[item].title),
                            isThreeLine: false,
                            subtitle: Text(
                              dataset[item].location.address,
                              overflow: TextOverflow.ellipsis,
                            ),
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (ctx) =>
                                      DetailsScreen(dataset[item]),
                                ),
                              );
                            },
                          );
                        },
                      )
                    : Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "You haven't saved any places yet.",
                              style: TextStyle(
                                fontSize: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .fontSize,
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            const Text("Let's start exploring!"),
                          ],
                        ),
                      );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => newScreenNavigator(context),
        shape: const CircleBorder(),
        child: const Icon(Icons.add_location_alt_rounded),
      ),
    );
  }
}
