import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tagyourtaxi_driver/functions/functions.dart';
import 'package:tagyourtaxi_driver/pages/loadingPage/loading.dart';
import 'package:tagyourtaxi_driver/pages/referralcode/referral_code.dart';
import 'package:tagyourtaxi_driver/styles/styles.dart';
import 'package:tagyourtaxi_driver/translations/translation.dart';
import 'package:tagyourtaxi_driver/widgets/widgets.dart';
import './login.dart';

class GetStarted extends StatefulWidget {
  const GetStarted({Key? key}) : super(key: key);

  @override
  _GetStartedState createState() => _GetStartedState();
}

String name = ''; //name of user
String email = ''; // email of user

class _GetStartedState extends State<GetStarted> {
  bool _loading = false;
  var verifyEmailError = '';

  TextEditingController emailText =
      TextEditingController(); //email textediting controller
  TextEditingController nameText =
      TextEditingController(); //name textediting controller

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    return Material(
      child: Directionality(
        textDirection: (languageDirection == 'rtl')
            ? TextDirection.rtl
            : TextDirection.ltr,
        child: Stack(
          children: [
            Container(
              padding: EdgeInsets.only(
                  left: media.width * 0.08, right: media.width * 0.08),
              height: media.height * 1,
              width: media.width * 1,
              color: page,
              child: Column(
                children: [
                  Container(
                      height: media.height * 0.12,
                      width: media.width * 1,
                      color: topBar,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: const Icon(Icons.arrow_back)),
                        ],
                      )),
                  Expanded(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: media.height * 0.04,
                      ),
                      SizedBox(
                        width: media.width * 1,
                        child: Text(
                          languages[choosenLanguage]['text_get_started'],
                          style: GoogleFonts.roboto(
                              fontSize: media.width * twentyeight,
                              fontWeight: FontWeight.bold,
                              color: textColor),
                        ),
                      ),
                      SizedBox(
                        height: media.height * 0.012,
                      ),
                      Text(
                        languages[choosenLanguage]['text_fill_form'],
                        style: GoogleFonts.roboto(
                            fontSize: media.width * sixteen,
                            color: textColor.withOpacity(0.3)),
                      ),
                      SizedBox(height: media.height * 0.04),
                      InputField(
                        icon: Icons.person_outline_rounded,
                        text: languages[choosenLanguage]['text_name'],
                        onTap: (val) {
                          setState(() {
                            name = nameText.text;
                          });
                        },
                        textController: nameText,
                      ),
                      SizedBox(
                        height: media.height * 0.012,
                      ),
                      InputField(
                        icon: Icons.email_outlined,
                        text: languages[choosenLanguage]['text_email'],
                        onTap: (val) {
                          setState(() {
                            email = emailText.text;
                          });
                        },
                        textController: emailText,
                        color: (verifyEmailError == '') ? null : Colors.red,
                      ),
                      SizedBox(
                        height: media.height * 0.012,
                      ),

                      Container(
                        decoration: BoxDecoration(
                            border:
                                Border(bottom: BorderSide(color: underline))),
                        padding: const EdgeInsets.only(left: 5, right: 5),
                        child: Row(
                          children: [
                            Container(
                              height: 50,
                              alignment: Alignment.center,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    countries[phcode]['dial_code'],
                                    style: GoogleFonts.roboto(
                                        fontSize: media.width * sixteen,
                                        color: textColor),
                                  ),
                                  const SizedBox(
                                    width: 2,
                                  ),
                                  const Icon(Icons.keyboard_arrow_down)
                                ],
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              phnumber,
                              style: GoogleFonts.roboto(
                                  fontSize: media.width * sixteen,
                                  color: textColor,
                                  letterSpacing: 2),
                            )
                          ],
                        ),
                      ),
                      //email already exist error
                      (verifyEmailError != '')
                          ? Container(
                              width: media.width * 0.8,
                              margin: EdgeInsets.only(top: media.height * 0.03),
                              alignment: Alignment.center,
                              child: Text(
                                verifyEmailError,
                                style: GoogleFonts.roboto(
                                    fontSize: media.width * sixteen,
                                    color: Colors.red),
                              ),
                            )
                          : Container(),

                      SizedBox(
                        height: media.height * 0.065,
                      ),
                      (nameText.text.isNotEmpty && emailText.text.isNotEmpty)
                          ? Container(
                              width: media.width * 1,
                              alignment: Alignment.center,
                              child: Button(
                                  onTap: () async {
                                    String pattern = r"^[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])*$";
                                    RegExp regex = RegExp(pattern);
                                if(regex.hasMatch(emailText.text)){
                                    FocusManager.instance.primaryFocus
                                        ?.unfocus();

                                    setState(() {
                                      verifyEmailError = '';
                                      _loading = true;
                                    });
                                    //validate email already exist
                                    var result = await validateEmail();

                                    if (result == 'success') {
                                      setState(() {
                                        verifyEmailError = '';
                                      });
                                      var _register = await registerUser();
                                      if (_register == 'true') {
                                        //referral page
                                        Navigator.pushAndRemoveUntil(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const Referral()),
                                            (route) => false);
                                      } else {
                                        setState(() {
                                          verifyEmailError =
                                              _register.toString();
                                        });
                                      }
                                    } else {
                                      setState(() {
                                        verifyEmailError = result.toString();
                                      });
                                    }
                                    setState(() {
                                      _loading = false;
                                    });
                                }else{
                                  setState(() {
                                        verifyEmailError = languages[choosenLanguage]['text_email_validation'];
                                      });
                                }
                                  },
                                  text: languages[choosenLanguage]
                                      ['text_next']))
                          : Container()
                    ],
                  )),
                ],
              ),
            ),

            //loader
            (_loading == true)
                ? const Positioned(top: 0, child: Loading())
                : Container()
          ],
        ),
      ),
    );
  }
}
