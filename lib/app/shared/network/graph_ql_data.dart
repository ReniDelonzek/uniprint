import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hasura_connect/hasura_connect.dart';

class GraphQlObject {
  // static HttpLink httpLink = HttpLink(
  //     uri:
  //         'http://192.168.0.100:8080/v1/graphql' //'https://uniprint-test.herokuapp.com/v1/graphql',
  //     );
  // static AuthLink authLink = AuthLink(getToken: () async {
  //   var user = await FirebaseAuth.instance.currentUser();
  //   var token = await user.getIdToken();
  //   return "Bearer ${token.token}";
  // });

  // static Link link = authLink.concat(httpLink);
  // ValueNotifier<GraphQLClient> client = ValueNotifier(
  //   GraphQLClient(
  //     cache: InMemoryCache(),
  //     link: link,
  //   ),
  // );

  static HasuraConnect hasuraConnect = HasuraConnect(
      'https://uniprint-uv.herokuapp.com/v1/graphql', token: (isError) async {
    var a = await FirebaseAuth.instance.currentUser();
    return "Bearer ${await a?.getIdToken() ?? ''}";
  });
}

GraphQlObject graphQlObject = new GraphQlObject();
