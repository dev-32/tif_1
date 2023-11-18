
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:svg_flutter/svg.dart';
import 'package:tif_1/Models/api_service.dart';
import 'package:tif_1/screens/eventDetailsScreen.dart';
import 'package:tif_1/utils/constants.dart';
import 'package:velocity_x/velocity_x.dart';
import '../Models/model.dart';

class EventScreen extends StatefulWidget {
  const EventScreen({super.key});

  @override
  State<EventScreen> createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  List<Conference>? userModel = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: false,
        title: Text('Events',style: GoogleFonts.inter(
        ),),
        actions: [
          IconButton(
              onPressed: (){
            Navigator.pushNamed(context, '/eventSearchScreen');
          }, icon: const Icon(CupertinoIcons.search,)),
          IconButton(onPressed: (){}, icon: const Icon(CupertinoIcons.ellipsis_vertical))
        ],
      ),
      body:  FutureBuilder(
        future: ApiService().getUsers(),
        builder: (context,snapshot) {
          if(!snapshot.hasData){
            return const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                VxZeroList(),
              ],
            ).scrollVertical();
          }
          else {
            userModel = snapshot.data;
            return ListView.builder(
            addAutomaticKeepAlives: true,
              itemCount: userModel!.length,
             itemBuilder: (context,index){
                 return GestureDetector(
                   onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>
                    EventDetailsScreen(idData: userModel![index].id)));
                   },
                   child: KCustomContainer(mainTitle: userModel![index].title,
            imageUrl: userModel![index].organiserIcon,
                     venueName: userModel![index].venueName,
                   venueCity: userModel![index].venueCity,
                     venueCountry : userModel![index].venueCountry,
                   dateTime : userModel![index].dateTime),
                 );
               });
          }
        }
      ),
    );
  }
}

class KCustomContainer extends StatelessWidget {
  const KCustomContainer({super.key, required this.imageUrl, required this.mainTitle, required this.venueName, required this.venueCity, required this.venueCountry, required this.dateTime,});
  final String imageUrl;
  final String mainTitle;
  final String venueName;
  final String venueCity;
  final String venueCountry;
  final DateTime dateTime;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Vx.gray50,
      height: context.percentHeight*14,
      child: Row(
        children: [
          Container(
            height: context.percentHeight*13,
              width: context.percentWidth*25,
              color: Vx.gray100,
              child:
              Image.network(imageUrl,
                fit: BoxFit.contain,
                errorBuilder:
                    (BuildContext context, Object exception, StackTrace? stackTrace) {
                  return SvgPicture.network(imageUrl);
                },),
          ).cornerRadius(12).pOnly(right: 8),
          KCustomColumn(
              mainTitle: mainTitle,
            venueName: venueName,
            venueCity: venueCity,
            venueCountry : venueCountry,
            dateTime : dateTime
          ),
        ],
      ).p4(),
    ).cornerRadius(12).glassMorphic(shadowStrength: 5).pSymmetric(h: 20,v: 8);
  }
}

class KCustomColumn extends StatelessWidget {
  const KCustomColumn({super.key, required this.mainTitle, required this.venueName, required this.venueCity, required this.venueCountry, required this.dateTime});
  final String mainTitle;
  final String venueName;
  final String venueCity;
  final String venueCountry;
  final DateTime dateTime;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text( '${DateFormat('d MMM').format(dateTime)} · ${DateFormat('h:mm a').format(dateTime)}',style:GoogleFonts.inter(
              color: Vx.hexToColor('#5669FF'),
              fontWeight: FontWeight.w400,
              fontSize: context.percentHeight*1.75
            ),),
          ],
        ),
        SizedBox(
          width: context.percentWidth*60,
          child: Text(mainTitle,
            softWrap: true,
            textAlign: TextAlign.start,
            style: GoogleFonts.inter(
                fontSize: context.percentHeight*2.1,
              fontWeight: FontWeight.w500,
            ),),
        ),
        10.heightBox,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(Icons.location_on_sharp,
            color: Vx.hexToColor('#747688')),
            5.widthBox,
            venueName.length < 15  && venueCity.length < 10?
                Text('$venueName · $venueCity, ${countryCodes[venueCountry]!}' ,
                style: GoogleFonts.inter(
                color: Vx.hexToColor('#747688'),
                fontSize: context.percentHeight*1.5,
                fontWeight: FontWeight.w400,
                ),)
                :venueName.length < 24 ? Text('$venueName · $venueCity, \n${countryCodes[venueCountry]!}' ,
              overflow: TextOverflow.clip,
              maxLines: 2,
              style: GoogleFonts.inter(
                  color: Vx.hexToColor('#747688'),
                  fontSize: context.percentHeight*1.5,
                  fontWeight: FontWeight.w400,
              ),):
            venueCity.length <12 ? Text('$venueCity, ${countryCodes[venueCountry]!}' ,
              overflow: TextOverflow.clip,
              maxLines: 2,
              style: GoogleFonts.inter(
                color: Vx.hexToColor('#747688'),
                fontSize: context.percentHeight*1.5,
                fontWeight: FontWeight.w400,
              ),):
            Text(countryCodes[venueCountry]! ,
              overflow: TextOverflow.clip,
              maxLines: 2,
              style: GoogleFonts.inter(
                color: Vx.hexToColor('#747688'),
                fontSize: context.percentHeight*1.5,
                fontWeight: FontWeight.w400,
              ),)
          ],
        )

      ],
    );
  }
}

