import 'package:e_shop/Config/config.dart';
import 'package:e_shop/Store/storehome.dart';
import 'package:e_shop/Widgets/customAppBar.dart';
import 'package:e_shop/Models/address.dart';
import 'package:flutter/material.dart';
import 'packagE:url_launcher/url_launcher.dart';

class AddAddress extends StatelessWidget
{
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final cName = TextEditingController();
  final cPhoneNumber = TextEditingController();
  final cFlatHomeNumber = TextEditingController();
  final cCity = TextEditingController();
  final cState = TextEditingController();
  final cPinCode = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: scaffoldKey,
        appBar: MyAppBar(),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: ()
          {
            if(formKey.currentState.validate())
            {
              final model = AddressModel(
                name: cName.text.trim(),
                state: cState.text.trim(),
                pincode: cPinCode.text,
                phoneNumber: cPhoneNumber.text,
                flatNumber: cFlatHomeNumber.text,
                city: cCity.text.trim(),
              ).toJson();

              //add to firestore
              EcommerceApp.firestore.collection(EcommerceApp.collectionUser)
                  .document(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID))
                  .collection(EcommerceApp.subCollectionAddress)
                  .document(DateTime.now().millisecondsSinceEpoch.toString())
                  .setData(model)
                  .then((value){
                    final snack = SnackBar(content: Text("New Client Info Added Successfully."));
                    scaffoldKey.currentState.showSnackBar(snack);
                    FocusScope.of(context).requestFocus(FocusNode());
                    formKey.currentState.reset();
              });

              Route route = MaterialPageRoute(builder: (c) => StoreHome());
              Navigator.pushReplacement(context, route);
            }
          },
          label: Text("Done"),
          backgroundColor: Colors.orange,
          icon: Icon(Icons.check),



        ),




        body: SingleChildScrollView(
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Customer's Info",
                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,fontSize: 20.0),

                  ),
                ),
              ),
              Form(
                key: formKey,
                child: Column(
                  children: [
                    MyTextField(
                      hint: "Customer's Name",
                      controller: cName,
                    ),
                    MyTextField(
                      hint: "Phone Number",
                      controller: cPhoneNumber,
                    ),
                    MyTextField(
                      hint: "Address",
                      controller: cFlatHomeNumber,
                    ),
                    MyTextField(
                      hint: "Order Comment",
                      controller: cCity,
                    ),

                    MaterialButton(
                      height: 30.0,
                      minWidth: 380.0,
                      color: Colors.orange,
                      textColor: Colors.white,
                      splashColor: Colors.deepOrange,
                      onPressed: (){
                        openurl();
                      },
                      child: Text("Fill contact tracing form", style: TextStyle(fontSize: 20.0),),
                    ),




                   // MyTextField(
                    //  hint: "State",
                     // controller: cState,
                   // ),
                   // MyTextField(
                     // hint: "PinCode",
                    //  controller: cPinCode,
                   // ),
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


openurl() async{
  String urll= "https://docs.google.com/forms/d/e/1FAIpQLSclVMENvay2ckQiEqzfKi1Ka1Fq94CAEWRRJQsA5LfbE04SzA/viewform";
  launch(urll);
}

class MyTextField extends StatelessWidget
{
  final String hint;
  final TextEditingController controller;

  MyTextField({Key key, this.hint , this.controller,}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(8.0),
        child: TextFormField(
          controller: controller,
          decoration: InputDecoration.collapsed(hintText: hint),
          validator: (val) => val.isEmpty ? "Field can not be empty." : null,
        ),
    );
  }



}
