import 'package:dio/dio.dart';
import 'package:e_connect_mobile/ui/helpers/ui_utils.dart';

class ApiError {
  static void dio(DioError e) {
    if (e.response != null) {
      final data = e.response?.data;
      try {
        UiUtils.showMessage(
          message: data["message"] ?? "Unkown error occured",
          title: data["data"] ?? "Something went wrong",
          type: MessageType.error,
        );
      } catch (e) {
        UiUtils.showMessage(
          message:
              "Something went wrong | Unknown error occured, try again later or contact admin",
          title: "Internal Server Error",
          type: MessageType.error,
        );
      }
    } else {
      String msg = e.message ?? "Unkown error";
      if (DioErrorType.receiveTimeout == e.type ||
          DioErrorType.sendTimeout == e.type) {
        msg =
            "Server is not reachable. Please verify your internet connection and try again";
      } else
      // if (e.type != DioErrorType.unknown)
      {
        msg = "Problem connecting to the server. Please try again.";
      }
      UiUtils.showMessage(
        message: msg,
        title: "Something went wrong",
        type: MessageType.error,
      );
    }
  }

 static void unknown(Object e) {
    UiUtils.showMessage(
      message: e.toString(),
      title: "Something went wrong",
      type: MessageType.error,
    );
  }
}

class ApiSuccess {
  static void show({required String title, required String message}) {
    UiUtils.showMessage(
      message: message,
      title: title,
      type: MessageType.success,
    );
  }
}
