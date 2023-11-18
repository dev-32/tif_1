import 'package:flutter/material.dart';
import 'package:tif_1/Models/api_service.dart';
import 'package:tif_1/Models/model.dart';
import 'package:velocity_x/velocity_x.dart';
import 'eventDetailsScreen.dart';
import 'eventScreen.dart';

class EventSearchScreen extends StatefulWidget {
  const EventSearchScreen({super.key});

  @override
  State<EventSearchScreen> createState() => _EventSearchScreenState();
}

class _EventSearchScreenState extends State<EventSearchScreen> {
  List<Conference>? userModels = [];
  TextEditingController searchController = TextEditingController();
  Stream? listen(TextEditingController val) {
    print(val.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('Search'),
        centerTitle: false,
      ),
      body: FutureBuilder<dynamic>(
          future: ApiService().getUsersBySearch(searchController.text),
          builder: (context, snapshot) {
            userModels = snapshot.data;
            if(!snapshot.hasData){
              return const VxZeroList();
            }
            else {
              return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                VxTextField(
                  controller: searchController,
                  onChanged: (value) {
                    searchController.text = value;
                    setState(() {
                      listen(searchController);
                    });
                  },
                  fillColor: Vx.gray100,
                  borderType: VxTextFieldBorderType.roundLine,
                  borderColor: Vx.gray300,
                  contentPaddingLeft: 12,
                  borderRadius: 17,
                  height: context.percentHeight*5.6,
                  icon:  Icon(Icons.search,
                  size: context.percentHeight*3.5,),
                  hint: 'Type Event Name',
                ).pSymmetric(h: 20,v: 15),
                Expanded(
                  child: ListView.builder(
                      addAutomaticKeepAlives: true,
                      itemCount: userModels!.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => EventDetailsScreen(
                                        idData: userModels![index].id)));
                          },
                          child: KCustomContainer(
                              mainTitle: userModels![index].title,
                              imageUrl: userModels![index].organiserIcon,
                              venueName: userModels![index].venueName,
                              venueCity: userModels![index].venueCity,
                              venueCountry: userModels![index].venueCountry,
                              dateTime: userModels![index].dateTime),
                        );
                      }),
                )
              ],
            );
            }
          }),
    );
  }
}
