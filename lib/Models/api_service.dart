import 'dart:convert';
import 'dart:developer';
import '../utils/constants.dart';
import 'model.dart';
import 'package:http/http.dart' as http;
class ApiService {
  Future<List<Conference>?> getUsers() async {
    try {
      var url = Uri.parse(ApiConstants.baseUrl + ApiConstants.usersEndpoint);
      var response = await http.get(url);
      var data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        Map<String, dynamic> decodedJson = jsonDecode(response.body);
        List<Conference> conferenceList = (decodedJson['content']['data'] as List)
            .map((conferenceJson) => Conference.fromJson(conferenceJson))
            .toList();
        return conferenceList;
      }
    } catch (e) {
      log(e.toString());
    }
  }
  Future<Conference?> getUsersById(int id) async {
    Conference? detailModel;
    try {
      var url = Uri.parse(ApiConstants.baseUrl + ApiConstants.usersEndpoint + "/"+id.toString());
      var response = await http.get(url);
      var data = jsonDecode(response.body);
      var temp = data['content']['data'];
      if (response.statusCode == 200) {
        detailModel = Conference.fromJson(temp);
        return detailModel;

      }
    } catch (e) {
      log(e.toString());
    }
  }
  Future<List<Conference>?> getUsersBySearch(String word) async {
    try {
      var url = Uri.parse("${ApiConstants.baseUrl}${ApiConstants.usersEndpoint}?search=$word");
      var response = await http.get(url);
      if (response.statusCode == 200) {
        Map<String, dynamic> decodedJson = jsonDecode(response.body);
        List<Conference> conferenceList = (decodedJson['content']['data'] as List)
            .map((conferenceJson) => Conference.fromJson(conferenceJson))
            .toList();
        conferenceList.sort((a, b) => a.dateTime.compareTo(b.dateTime));
        return conferenceList;
      }
    } catch (e) {
      log(e.toString());
    }
  }
}
