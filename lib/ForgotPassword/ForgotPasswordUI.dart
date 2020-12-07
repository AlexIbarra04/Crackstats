import 'package:flutter/material.dart';
import '../Constants.dart';
import 'SendEmail.dart';
import 'ForgotPasswordPopUp.dart';
import '../ConnectDB.dart';

class ForgotPasswordUI extends StatefulWidget {
  @override
  _ForgotPasswordUIState createState() => _ForgotPasswordUIState();
}

class _ForgotPasswordUIState extends State<ForgotPasswordUI> {
  TextEditingController emailfgtController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            FORGOTPASSWORDMESSAGE,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          Container(
              width: MediaQuery.of(context).size.width / 2,
              padding: EdgeInsets.only(top: 5, bottom: 5),
              child: TextField(
                controller: emailfgtController,
                decoration: InputDecoration(
                  border: new OutlineInputBorder(
                      borderSide: new BorderSide(color: Colors.black)),
                  hintText: EMAIL,
                ),
              )),
          RaisedButton(
            color: PRIMARYCOLOR,
            textColor: WHITE,
            child: Text(SENDCODE),
            onPressed: ()  async {
              var mailInstance = new SendEmail(emailfgtController.text);
              var isSend = await mailInstance.sendmail();
              if (isSend=='true'){
                var chngOnDB = new ConnectDB();
                chngOnDB.tempPswUpdate(emailfgtController.text);
                var pswpop = new ForgotPasswordPopUp();
                pswpop.showMyDialog(context,true);
              }
              else
              {
                var pswpop = new ForgotPasswordPopUp();
                pswpop.showMyDialog(context,false);
              }
            },
          )
        ],
      )),
    );
  }
}
