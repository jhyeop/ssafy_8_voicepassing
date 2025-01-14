import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'package:intl/intl.dart';
import 'package:voicepassing/models/receive_message_model.dart';
import 'package:voicepassing/models/result_model.dart';
import 'package:voicepassing/style/color_style.dart';
import 'package:voicepassing/widgets/alarm_widget/in_call_notification.dart';

class AfterCallNotification extends StatefulWidget {
  const AfterCallNotification({
    super.key,
    required this.resultData,
    required this.phoneNumber,
    required this.androidId,
    required this.phishingNumber,
  });

  final ReceiveMessageModel resultData;
  final String phoneNumber;
  final String androidId;
  final int phishingNumber;

  @override
  State<AfterCallNotification> createState() => _AfterCallNotificationState();
}

class _AfterCallNotificationState extends State<AfterCallNotification> {
  @override
  void initState() {
    super.initState();
    final res = IsolateNameServer.registerPortWithName(
      _receivePort.sendPort,
      _kPortNameOverlay,
    );
  }

  late ResultModel caseInfo;
  static const String _kPortNameOverlay = 'OVERLAY';
  static const String _kPortNameHome = 'UI';
  final _receivePort = ReceivePort();
  SendPort? homePort;

  final MethodChannel platform =
      const MethodChannel('com.example.voicepassing/navigation');

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      elevation: 0.0,
      child: GestureDetector(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: widget.resultData.result!.totalCategoryScore >= 0.8
                ? ColorStyles.backgroundRed
                : ColorStyles.backgroundYellow,
            shape: BoxShape.rectangle,
            borderRadius: const BorderRadius.all(Radius.circular(15)),
          ),
          padding: const EdgeInsets.fromLTRB(8, 6, 8, 12),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
                width: 320,
                height: 40,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(
                      DateFormat('a h:mm').format(DateTime.now()),
                      style: const TextStyle(
                        color: ColorStyles.textBlack,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 6),
              InCallNotification(resultData: widget.resultData),
              const SizedBox(height: 6),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(12),
                ),
                width: 320,
                height: 80,
                padding: const EdgeInsets.fromLTRB(36, 15, 36, 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          widget.phoneNumber,
                          style: const TextStyle(
                            color: ColorStyles.themeRed,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(
                          height: 6,
                        ),
                        const Text(
                          '피싱 범죄 이력',
                          style: TextStyle(
                            color: ColorStyles.textDarkGray,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        )
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${widget.phishingNumber} 건',
                          style: const TextStyle(
                            color: ColorStyles.textBlack,
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 6),
              SizedBox(
                width: 320,
                height: 40,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () async {
                        homePort = IsolateNameServer.lookupPortByName(
                          _kPortNameHome,
                        );
                        homePort?.send('navigate');
                        FlutterOverlayWindow.resizeOverlay(0, 0);
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.white),
                        overlayColor:
                            MaterialStateProperty.all(ColorStyles.subLightGray),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        fixedSize:
                            MaterialStateProperty.all(const Size(153, 40)),
                      ),
                      child: const Text(
                        '상세보기',
                        style: TextStyle(
                          color: ColorStyles.textBlack,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () async {
                        await FlutterOverlayWindow.closeOverlay();
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.white),
                        overlayColor:
                            MaterialStateProperty.all(ColorStyles.subLightGray),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        fixedSize:
                            MaterialStateProperty.all(const Size(153, 40)),
                      ),
                      child: const Text(
                        '닫기',
                        style: TextStyle(
                          color: ColorStyles.textBlack,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
