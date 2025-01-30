// import 'dart:convert';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter_appauth/flutter_appauth.dart';
// import 'package:googleapis/sheets/v4.dart' as sheets;
// import 'package:http/http.dart' as http;

// class SyncService {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   // Future<void> fetchDataFromExcel() async {
//   //   try {
//   //     // Utiliser l'API Google Sheets pour récupérer les données
//   //     var sheet = await sheets.SheetsApi(http.Client()).spreadsheets.values.get(
//   //       '', 
//   //       'Feuil1!A1:C',
//   //     );

//   //     print(sheet.values);
//   //   } catch (e) {
//   //     print("Erreur: $e");
//   //   }

//   //   // Enregistrer les données dans Firestore
//   //   // for (var row in sheet.values!) {
//   //   //   await _firestore.collection('data').add({
//   //   //     'column1': row[0],
//   //   //     'column2': row[1],
//   //   //     'column3': row[2],
//   //   //   });
//   //   // }
//   // }



//   final FlutterAppAuth _authState = FlutterAppAuth();
//   String clientId = '';
//   String clientSecret = '';
//   String redirectUri = 'http://localhost';
//   List<String> scopes = ['https://www.googleapis.com/auth/spreadsheets.readonly', 'https://www.googleapis.com/auth/spreadsheets'];
//   String issuer = 'https://accounts.google.com';

//   List<Map<String, dynamic>> _data = [];
//   // bool _isLoading = false;

//   Future<void> handleSignIn() async {
//     try {
//       // _authState.token(TokenRequest(clientId, redirectUrl))
//       final result = await _authState.authorizeAndExchangeCode(
//         AuthorizationTokenRequest(clientId, redirectUri, clientSecret: clientSecret, scopes: scopes, issuer: issuer)
//         // authorizationEndpoint: _authInfo.authorizationEndpoint,
//         // tokenEndpoint: _authInfo.tokenEndpoint,
//         // clientId: _authInfo.clientId,
//         // clientSecret: _authInfo.clientSecret,
//         // redirectUri: _authInfo.redirectUri,
//         // scopes: _authInfo.scopes,
//       );
//       // Stocker le token d'accès
//       await fetchData();
//     } catch (e) {
//       print("Erreur: $e");
//     }
//   }

//   Future<void> fetchData() async {
//     // setState(() {
//     //   _isLoading = true;
//     // });
//     // final token = await _authState.getAccessToken();

//     try {
//       final token = await _authState.token(TokenRequest(clientId, redirectUri, clientSecret: clientSecret, scopes: scopes, issuer: issuer));
//       final headers = {'Authorization': 'Bearer $token'};
//       final response = await http.get(
//         Uri.parse('https://sheets.googleapis.com/v4/spreadsheets/YOUR_SPREADSHEET_ID/values/Feuil1!A1:C'),
//         headers: headers,
//       );
//       // if (response.statusCode == 200) {
//         final values = jsonDecode(response.body)['values'];
//           _data = values.map((row) => {
//             'column1': row[0],
//             'column2': row[1],
//             'column3': row[2],
//           }).toList();
//         // setState(() {
//         //   // _isLoading = false;
//         // });
//       // } else {
//       //   // Gérer les erreurs
//       // }
      
//     } catch (e) {
//       print("Erreur: $e");
//     }
//   }

//   // // Méthode pour synchroniser les données
//   // Future<void> synchronizeData() async {
//   //   try {
//   //     // Exemple : Récupérer les données depuis une source externe
//   //     final externalData = await fetchExternalData();

//   //     // Envoyer les données vers Firestore
//   //     for (var item in externalData) {
//   //       await _firestore.collection('matches').doc(item['id']).set(item);
//   //     }

//   //     print('Données synchronisées avec succès.');
//   //   } catch (e) {
//   //     print('Erreur lors de la synchronisation : $e');
//   //   }
//   // }

//   // // Exemple : Récupérer des données d'une API externe
//   // Future<List<Map<String, dynamic>>> fetchExternalData() async {
//   //   // Simule des données, mais ici vous pourriez utiliser une requête HTTP
//   //   return [
//   //     {'id': '1', 'homeTeam': 'Équipe A', 'awayTeam': 'Équipe B', 'score': '2-1'},
//   //     {'id': '2', 'homeTeam': 'Équipe C', 'awayTeam': 'Équipe D', 'score': '1-1'},
//   //   ];
//   // }
// }


