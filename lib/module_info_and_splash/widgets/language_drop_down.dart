import 'package:flutter/material.dart';

class LangugeDropDownWidget extends StatefulWidget {
  const LangugeDropDownWidget({Key? key}) : super(key: key);

  @override
  State<LangugeDropDownWidget> createState() => _LangugeDropDownWidgetState();
}

class _LangugeDropDownWidgetState extends State<LangugeDropDownWidget> {
  String? _selected;
  List<Map<String, String>> _myJson = [
    {"id": '1', "image": "assets/arabic_flag.png", "name": "Arabic"},
    {"id": '2', "image": "assets/english_flag.jpg", "name": "English"},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
          border: Border.all(width: 1, color: Colors.grey),
          borderRadius: BorderRadius.circular(10)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: DropdownButtonHideUnderline(
              child: ButtonTheme(
                alignedDropdown: true,
                child: DropdownButton<String>(
                  icon: const Icon(
                    Icons.arrow_drop_down,
                    size: 28,
                  ),
                  isDense: true,
                  hint: Text("Select Language"),
                  value: _selected,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selected = newValue;
                    });
                  },
                  items: _myJson.map((Map map) {
                    return DropdownMenuItem<String>(
                      value: map["id"].toString(),
                      child: Row(
                        children: <Widget>[
                          Image.asset(
                            map["image"],
                            width: 40,
                          ),
                          Container(
                              margin: EdgeInsets.only(left: 10),
                              child: Text(
                                map["name"],
                                style: TextStyle(color: Colors.black),
                              )),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
