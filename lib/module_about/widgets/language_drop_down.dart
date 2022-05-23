import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_kom/generated/l10n.dart';
import 'package:my_kom/module_localization/service/localization_service/localization_b;oc_service.dart';

class LangugeDropDownWidget extends StatefulWidget {
  final LocalizationService localizationService ;
   LangugeDropDownWidget({ required this.localizationService, Key? key}) : super(key: key);

  @override
  State<LangugeDropDownWidget> createState() => _LangugeDropDownWidgetState();
}

class _LangugeDropDownWidgetState extends State<LangugeDropDownWidget> {
  String? _selected;

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> _myJson = [
      {"id": 'ar', "image": "assets/arabic_flag.png", "name": S.of(context)!.arabic},
      {"id": 'en', "image": "assets/english_flag.jpg", "name": S.of(context)!.english},
    ];

    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
          border: Border.all(width: 1, color: Colors.grey),
          borderRadius: BorderRadius.circular(10)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child:BlocBuilder<LocalizationService,LocalizationState>(

              bloc: widget.localizationService ,
              builder: (context, state){
                String lang ;
                if(state is LocalizationArabicState){
                  lang = 'ar';
                }else{
                  lang = 'en';
                }
                return DropdownButtonHideUnderline(
                  child: ButtonTheme(
                    alignedDropdown: true,
                    child: DropdownButton<String>(

                      icon: const Icon(
                        Icons.arrow_drop_down,
                        size: 28,
                      ),
                      isDense: true,
                      hint: Text(S.of(context)!.language),
                      style:  GoogleFonts.lato(
                          color: Colors.black38,
                          fontWeight: FontWeight.w600
                      ),
                      value: lang,
                      onChanged: (String? newValue) {
                        widget.localizationService.setLanguage(newValue!);
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
                                    style:  GoogleFonts.lato(
                                        color: Colors.black87,
                                        fontWeight: FontWeight.w600
                                    ),
                                  )),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                );

              },
            ),

          ),
        ],
      ),
    );
  }
}

