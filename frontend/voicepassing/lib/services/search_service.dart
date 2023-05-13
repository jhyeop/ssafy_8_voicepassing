import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:voicepassing/models/result_model.dart';
import 'package:voicepassing/services/api_service.dart';
import 'package:voicepassing/style/color_style.dart';
import 'package:voicepassing/widgets/search_widget/search_detail.dart';

class SearchWidget extends StatefulWidget {
  const SearchWidget({
    super.key,
  });

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  final myController = TextEditingController();
  String phoneNumber = '';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    myController.addListener(_printLatestValue);
  }

  @override
  void dispose() {
    // 텍스트에디팅컨트롤러를 제거하고, 등록된 리스너도 제거된다.
    myController.dispose();
    super.dispose();
  }

  // myController의 텍스트를 콘솔에 출력하는 메소드
  void _printLatestValue() {}

  late List<ResultModel>? caseInfo;
  void setText(String txt) {
    setState(() {
      String mytext = myController.text;
      myController.text = txt;
    });
  }

  bool hasData = false;
  @override
  Widget build(BuildContext context) {
    String textValue = myController.text;
    bool showSuffixIcon = textValue.isNotEmpty;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                  height: 34,
                  decoration: BoxDecoration(
                    color: ColorStyles.themeLightBlue,
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    child: Row(
                      textBaseline: TextBaseline.alphabetic,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const Icon(
                            Icons.arrow_back_ios,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: SizedBox(
                              height: 50,
                              child: Card(
                                color: ColorStyles.themeLightBlue,
                                child: TextField(
                                  textInputAction: TextInputAction.go,
                                  onSubmitted: (value) async {
                                    caseInfo =
                                        await ApiService.getPhoneNumber(value);
                                    setState(() {
                                      phoneNumber = value;
                                      hasData = true;
                                    });
                                    //Todo: 전화번호인지 확인하는 로직 나중에 추가할것
                                  },
                                  controller: myController,
                                  onChanged: (value) {
                                    setState(() {
                                      textValue = value;
                                    });
                                  },
                                  autofocus: true,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 12),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 20,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 0),
                            child: showSuffixIcon
                                ? IconButton(
                                    padding: EdgeInsets.zero,
                                    onPressed: () {
                                      setState(() {
                                        myController.clear();
                                        textValue = '';
                                      });
                                    },
                                    icon: const Icon(
                                      Icons.cancel,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                                  )
                                : null,
                          ),
                        ),
                      ],
                    ),
                  )),
            ),
            const SizedBox(
              width: 5,
            ),
            Container(
              height: 34,
              width: 34,
              decoration: BoxDecoration(
                color: ColorStyles.themeLightBlue,
                borderRadius: BorderRadius.circular(12),
              ),
              child: GestureDetector(
                  onTap: () async {
                    FlutterClipboard.paste().then((value) {
                      myController.text = value;
                      print(value);
                      setState(() {});
                    });
                    // ClipboardData? data =
                    //     await Clipboard.getData(Clipboard.kTextPlain);
                    // String str = data?.text ?? '';
                    // print(myController.text);
                    // if (str.isNotEmpty) {
                    //   print('뭔가 값이있음');
                    //   myController.text = (str);
                    // } else {
                    //   print(data);
                    //   print(data?.text);
                    //   print('눌값?');
                    // }
                    // setState(() {});
                  },
                  child: const Icon(
                    Icons.paste_sharp,
                    color: Colors.white,
                    size: 17,
                  )),
            )
          ],
        ),
        // hasData
        //     ? SingleChildScrollView(child: Text(caseInfo.toString()))
        //     : const Text('데이터없음')
        phoneNumber.isNotEmpty
            ? Expanded(
                child: SearchDetail(
                  phoneNumber: phoneNumber,
                  resultList: caseInfo,
                ),
              )
            : const Text('')
      ],
    );
  }
}
