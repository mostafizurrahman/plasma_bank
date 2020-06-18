


import 'dart:convert';

import 'package:http/http.dart';
abstract class Authentication {

  /// Apply authentication settings to header and query params.
  void applyToParams(List<QueryParam> queryParams, Map<String, String> headerParams);
}

class OAuth implements Authentication {
  String accessToken;

  OAuth({this.accessToken});

  @override
  void applyToParams(List<QueryParam> queryParams, Map<String, String> headerParams) {
    if (accessToken != null) {
      headerParams["Authorization"] = "Bearer " + accessToken;
    }
  }

  void setAccessToken(String accessToken) {
    this.accessToken = accessToken;
  }
}

class ApiException implements Exception {
  int code = 0;
  String message;
  Exception innerException;
  StackTrace stackTrace;

  ApiException(this.code, this.message);

  ApiException.withInner(this.code, this.message, this.innerException, this.stackTrace);

  String toString() {
    if (message == null) return "ApiException";

    if (innerException == null) {
      return "ApiException $code: $message";
    }

    return "ApiException $code: $message (Inner exception: ${innerException})\n\n" +
        stackTrace.toString();
  }
}

class ApiKeyAuth implements Authentication {

  final String location;
  final String paramName;
  String apiKey;
  String apiKeyPrefix;

  ApiKeyAuth(this.location, this.paramName);

  @override
  void applyToParams(List<QueryParam> queryParams, Map<String, String> headerParams) {
    String value;
    if (apiKeyPrefix != null) {
      value = '$apiKeyPrefix $apiKey';
    } else {
      value = apiKey;
    }

    if (location == 'query' && value != null) {
      queryParams.add(new QueryParam(paramName, value));
    } else if (location == 'header' && value != null) {
      headerParams[paramName] = value;
    }
  }
}

class QueryParam {
  String name;
  String value;

  QueryParam(this.name, this.value);
}

class ApiClient {
  final String basePath;
  var client = new Client();

  Map<String, String> _defaultHeaderMap = {};
//  Map<String, Authentication> _authentications = {};

  final _RegList = new RegExp(r'^List<(.*)>$');
  final _RegMap = new RegExp(r'^Map<String,(.*)>$');

  ApiClient({this.basePath = 'https://api.imgur.com/3/image'});


  dynamic _deserialize(dynamic value, String targetType) {
    try {
      switch (targetType) {
        case 'String':
          return '$value';
        case 'int':
          return value is int ? value : int.parse('$value');
        case 'bool':
          return value is bool ? value : '$value'.toLowerCase() == 'true';
//        case 'double':
//          return value is double ? value : double.parse('$value');
//        case 'AccountResp':
//          return new AccountResp.fromJson(value);
//        case 'ActivityRequest':
//          return new ActivityRequest.fromJson(value);
//        case 'AgentPaymentRequest':
//          return new AgentPaymentRequest.fromJson(value);
//        case 'BalanceCheckRequest':
//          return new BalanceCheckRequest.fromJson(value);
//        case 'ChangePinReq':
//          return new ChangePinReq.fromJson(value);
//        case 'CheckBillResp':
//          return new CheckBillResp.fromJson(value);
//        case 'CustomerPaymentRequest':
//          return new CustomerPaymentRequest.fromJson(value);
//        case 'DeleteDeviceInfo':
//          return new DeleteDeviceInfo.fromJson(value);
//        case 'DeviceInfo':
//          return new DeviceInfo.fromJson(value);
//        case 'DeviceRegistrationRequest':
//          return new DeviceRegistrationRequest.fromJson(value);
//        case 'DirectWithdrawRequest':
//          return new DirectWithdrawRequest.fromJson(value);
//        case 'EnglishToBangla':
//          return new EnglishToBangla.fromJson(value);
//        case 'EnquiryData':
//          return new EnquiryData.fromJson(value);
//        case 'ExecutePushResp':
//          return new ExecutePushResp.fromJson(value);
//        case 'ExternalMerchantData':
//          return new ExternalMerchantData.fromJson(value);
//        case 'HashMap':
//          return new HashMap.fromJson(value);
//        case 'JsonNode':
//          return new JsonNode.fromJson(value);
//        case 'LoginRequest':
//          return new LoginRequest.fromJson(value);
//        case 'LoginResponse':
//          return new LoginResponse.fromJson(value);
//        case 'LookupResp':
//          return new LookupResp.fromJson(value);
//        case 'MerchantCustomerBean':
//          return new MerchantCustomerBean.fromJson(value);
//        case 'MerchantCustomerUpdateRequest':
//          return new MerchantCustomerUpdateRequest.fromJson(value);
//        case 'MerchantCustomerUpdateResponse':
//          return new MerchantCustomerUpdateResponse.fromJson(value);
//        case 'MerchantCustomers':
//          return new MerchantCustomers.fromJson(value);
//        case 'MerchantInfo':
//          return new MerchantInfo.fromJson(value);
//        case 'MobileInfo':
//          return new MobileInfo.fromJson(value);
//        case 'ObviousPin':
//          return new ObviousPin.fromJson(value);
//        case 'OpenAccountRequest':
//          return new OpenAccountRequest.fromJson(value);
//        case 'PhotoUploadReq':
//          return new PhotoUploadReq.fromJson(value);
//        case 'PhotoUploadResp':
//          return new PhotoUploadResp.fromJson(value);
//        case 'PushLessWallet':
//          return new PushLessWallet.fromJson(value);
//        case 'PushLessWalletWrapper':
//          return new PushLessWalletWrapper.fromJson(value);
//        case 'RechargeRequest':
//          return new RechargeRequest.fromJson(value);
//        case 'ResponseEntity':
//          return new ResponseEntity.fromJson(value);
//        case 'SRDailySummaryResponse':
//          return new SRDailySummaryResponse.fromJson(value);
//        case 'SendMoneyRequest':
//          return new SendMoneyRequest.fromJson(value);
//        case 'SrDailySummaryReq':
//          return new SrDailySummaryReq.fromJson(value);
//        case 'SrLimitInfoResponse':
//          return new SrLimitInfoResponse.fromJson(value);
//        case 'SrLimitUpdateReq':
//          return new SrLimitUpdateReq.fromJson(value);
//        case 'TrnxResponse':
//          return new TrnxResponse.fromJson(value);
//        case 'TxnRequest':
//          return new TxnRequest.fromJson(value);
//        case 'WalletStatementDetail':
//          return new WalletStatementDetail.fromJson(value);
//        case 'WalletStatementResponse':
//          return new WalletStatementResponse.fromJson(value);
//        case 'WithdrawByPushRequest':
//          return new WithdrawByPushRequest.fromJson(value);
//        case 'OtpResponse':
//          return new OtpResponse.fromJson(value);
        default:
          {
            Match match;
            if (value is List &&
                (match = _RegList.firstMatch(targetType)) != null) {
              var newTargetType = match[1];
              return value.map((v) => _deserialize(v, newTargetType)).toList();
            } else if (value is Map &&
                (match = _RegMap.firstMatch(targetType)) != null) {
              var newTargetType = match[1];
              return new Map.fromIterables(value.keys,
                  value.values.map((v) => _deserialize(v, newTargetType)));
            }
          }
      }
    } catch (e, stack) {
      throw new ApiException.withInner(
          500, 'Exception during deserialization.', e, stack);
    }
    throw new ApiException(
        500, 'Could not find a suitable class for deserialization');
  }

  dynamic deserialize(String jsonVal, String targetType) {
    // Remove all spaces.  Necessary for reg expressions as well.
    targetType = targetType.replaceAll(' ', '');

    if (targetType == 'String') return jsonVal;

    var decodedJson = json.decode(jsonVal);
    return _deserialize(decodedJson, targetType);
  }

  String serialize(Object obj) {
    String serialized = '';
    if (obj == null) {
      serialized = '';
    } else {
      serialized = json.encode(obj);
    }
    return serialized;
  }

  // We don't use a Map<String, String> for queryParams.
  // If collectionFormat is 'multi' a key might appear multiple times.

  Future<Response> invokeAPI(
      String path,
      String method,
      Iterable<QueryParam> queryParams,
      Object body,
      Map<String, String> headerParams,
      Map<String, String> formParams,
      String contentType,
      List<String> authNames,
      {bool doUpdateTimer = true}) async {
    return callAPI(path, method, queryParams, body, headerParams, formParams,
        contentType, authNames)
        .then((response) {
      if (response.statusCode >= 200 && response.statusCode < 300) {

      }
      return response;
    });
  }

  Future<Response> callAPI(
      String path,
      String method,
      Iterable<QueryParam> queryParams,
      Object body,
      Map<String, String> headerParams,
      Map<String, String> formParams,
      String contentType,
      List<String> authNames) async {
    //_updateParamsForAuth(authNames, queryParams, headerParams);

    var ps = queryParams
        .where((p) => p.value != null)
        .map((p) => '${p.name}=${p.value}');
    String queryString = ps.isNotEmpty ? '?' + ps.join('&') : '';

    String url = basePath + path + queryString;

    headerParams.addAll(_defaultHeaderMap);
    headerParams['Content-Type'] = contentType;

    if (body is MultipartRequest) {
      var request = new MultipartRequest(method, Uri.parse(url));
      request.fields.addAll(body.fields);
      request.files.addAll(body.files);
      request.headers.addAll(body.headers);
      request.headers.addAll(headerParams);
      var response = await client.send(request);
      return Response.fromStream(response);
    } else {
      print(url);
      var msgBody = contentType == "application/x-www-form-urlencoded"
          ? formParams
          : serialize(body);
      switch (method) {
        case "POST":
          return client
              .post(url, headers: headerParams, body: msgBody)
              .timeout(const Duration(seconds: 150));
        case "PUT":
          return client
              .put(url, headers: headerParams, body: msgBody)
              .timeout(const Duration(seconds: 150));
        case "DELETE":
          return client
              .delete(url, headers: headerParams)
              .timeout(const Duration(seconds: 150));
        case "PATCH":
          return client
              .patch(url, headers: headerParams, body: msgBody)
              .timeout(const Duration(seconds: 150));
        case "SEND":
          return Response.fromStream(
              await client.send(Request("DELETE", Uri.parse(url))
                ..headers.addAll(headerParams)
                ..body = msgBody))
            ..timeout(const Duration(seconds: 150));
        default:
          return client
              .get(url, headers: headerParams)
              .timeout(const Duration(seconds: 150));
      }
    }
  }
}
