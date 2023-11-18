import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:svg_flutter/svg.dart';
import 'package:tif_1/utils/constants.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Models/api_service.dart';
import '../Models/model.dart';

class EventDetailsScreen extends StatefulWidget {
  const EventDetailsScreen({super.key, required this.idData});
  final int idData;

  @override
  State<EventDetailsScreen> createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> {
  Conference? userModelId;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: PreferredSize(
          preferredSize: const Size(double.infinity, 56),
          child: ClipRRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 4, sigmaY: 5),
              child: AppBar(
                elevation: 0,
                forceMaterialTransparency: true,
                foregroundColor: Colors.white,
                title: Text(
                  'Event Details',
                  style: GoogleFonts.inter(fontWeight: FontWeight.w500,
                  ),
                ),
                actions: [
                  VxBox(
                          child: const Center(
                    child: Icon(Icons.bookmark),
                  ).pSymmetric(h: 12, v: 14))
                      .roundedLg
                      .make()
                      .glassMorphic(shadowStrength: 5,blur: 60)
                      .pOnly(right: 14,bottom: 8,)
                ],
                centerTitle: false,
              ),
            ),
          ),
        ),
        body: FutureBuilder(
            future: ApiService().getUsersById(widget.idData),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Column(
                  children: [
                    const VxZeroCard()
                        .pOnly(bottom: context.percentHeight * 30),
                    const CircularProgressIndicator(),
                  ],
                );
              } else {
                userModelId = snapshot.data;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(children: [
                      Image.network(
                       errorBuilder: (v, i, s) => const VxZeroCard(),
                          userModelId!.bannerImage),
                    ]),
                    Center(
                      child: Text(
                        userModelId!.title,
                        softWrap: true,
                        style: GoogleFonts.inter(
                          fontSize: context.percentHeight * 3.5,
                        ),
                      ),
                    ).p8(),
                    KCustomRowDetail(
                        organiserImage: Image.network(
                          isAntiAlias: true,
                          userModelId!.organiserIcon,
                          fit: BoxFit.contain,
                          errorBuilder: (BuildContext context, Object exception,
                              StackTrace? stackTrace) {
                            return SvgPicture.network(
                                userModelId!.organiserIcon);
                          },
                        ),
                        organiserName: userModelId!.organiserName,
                        subText: 'Organiser'),
                    KCustomRowDetail(
                        organiserImage: Icon(
                          Icons.calendar_month,
                          size: context.percentHeight * 5,
                          color: Vx.blue500,
                        ),
                        organiserName: DateFormat('d MMMM, y').format(userModelId!.dateTime),
                        subText: DateFormat('EEEE, h:mma').format(userModelId!.dateTime)),
                    KCustomRowDetail(
                      organiserImage: Icon(
                        Icons.location_on_sharp,
                        size: context.percentHeight * 5,
                        color: Vx.blue500,
                      ),
                      organiserName: userModelId!.venueName,
                      subText: "${userModelId!.venueCity}, ${countryCodes[userModelId!.venueCountry]}",
                    ),
                    KCustomDescription(eventDescrp: userModelId!.description,),
                  ],
                ).scrollVertical();
              }
            }),
      bottomNavigationBar: const KCustomBookButton(),
    );
  }
}
class KCustomDescription extends StatelessWidget {
  const KCustomDescription({super.key, required this.eventDescrp});
  final String eventDescrp;
  @override
  Widget build(BuildContext context) {
    return  Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
         Text('About Event',
        style: GoogleFonts.inter(fontSize: context.percentHeight*2.6,
        fontWeight: FontWeight.w400),),
        14.heightBox,
        Text(eventDescrp,
       style: GoogleFonts.inter(
         fontSize: context.percentHeight*1.9
       )
        )
      ],
    ).p16();
  }
}

class KCustomRowDetail extends StatelessWidget {
  const KCustomRowDetail(
      {super.key,
      required this.organiserImage,
      required this.organiserName,
      required this.subText});
  final Widget organiserImage;
  final String organiserName;
  final String subText;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: context.percentHeight * 8,
          width: context.percentWidth * 20,
          color: Vx.gray100,
          child: Center(child: organiserImage),
        ).cornerRadius(12).pOnly(right: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              organiserName,
              softWrap: true,
              maxLines: 4,
              style: GoogleFonts.inter(fontSize: context.percentHeight * 1.7),
            ),
            Text(
              subText,
              softWrap: true,
              style: GoogleFonts.inter(
                  fontSize: context.percentHeight * 1.5,
                  color: Vx.hexToColor('#706E8F')),
            )
          ],
        ),
      ],
    ).pSymmetric(h: 16, v: 10);
  }
}

class KCustomBookButton extends StatelessWidget {
  const KCustomBookButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: context.percentHeight*7.5,
      color: Vx.hexToColor('#5669FF'),
      child:
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Center(child: Text("BOOK NOW",
              style: GoogleFonts.inter(
                fontSize: context.percentHeight*2,
                fontWeight: FontWeight.w500,
                color: Colors.white
              ),)),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: Vx.hexToColor('#3D56F0'),
              ),
                child: const Icon(Icons.arrow_forward,color: Colors.white,)).pOnly(right: 8)
          ],
        ),
      ).cornerRadius(20).pOnly(left: 50,right: 50,
    bottom: 35);
  }
}

