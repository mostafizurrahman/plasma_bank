

class dialog{


   void showDialog(){
    await Navigator.of(context).push(PageRouteBuilder(
        opaque: false,
        pageBuilder: (BuildContext context, _, __) {
          return SafeArea(
            child: WillPopScope(
              onWillPop: () async {
                return Future<bool>.value(false);
              },
              child: Material(
                color: Colors.transparent,
                child: BackdropFilter(
                  filter: ui.ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                  child: Center(
                    child: Container(
                      width: displayData.width,
                      height: displayData.height,
                      decoration: new BoxDecoration(
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                            color: Colors.white.withOpacity(0.15),
                            blurRadius: 8.0,
                          ),
                        ],
//                  color: Colors.transparent,
                        borderRadius:
                        new BorderRadius.all(const Radius.circular(12.0)),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,

                        children: <Widget>[

                          Expanded(
                            child: Container(
                              child: Ink(
                                child: InkWell(
                                  onTap: ()=>Navigator.pop(context),

                                ),
                              ),
                            ),
                          ),

                          Container(
                              width: displayData.width,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Color.fromRGBO(0, 0, 0, 0.15),
                                    offset: Offset(0, 0),
                                    blurRadius: 12,
                                    spreadRadius: 8,
                                  ),
                                ],
                                borderRadius: const BorderRadius.only(
                                  topLeft: const Radius.circular(16),
                                  topRight: const Radius.circular(16),
                                ),
                              ),
                              child:Padding(
                                padding: const EdgeInsets.all(24),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.only(top: 8, bottom: 16),
                                      child: Text("PIN পুনরুদ্ধার করুন ",style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18, color: Colors.green)),
                                    ),
                                    Text("This is the first paragraph, you can write here more.... the reason of the failure goes her, other cause and effects can also be placed here. ",
                                      style: TextStyle( fontSize: 14),),
                                    Padding(
                                      padding: EdgeInsets.only(top: 12, bottom: 16),
                                      child: Text("The possible solution and the action of the failure case goes here. it will be more shorter than previous one!",
                                          style: TextStyle( fontSize: 14)),
                                    ),

                                    Padding(
                                      padding: EdgeInsets.only(top: 8, bottom: 12),
                                      child: Container(
                                        height: 40,
                                        child: RaisedButton(
                                          color: ColorUtils.blueAccent,
                                          onPressed: _verifyMobileNumber,
                                          child: Center(
                                            child: Text(
                                              localization.getValue("NextButton"),
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),

                                    )
                                  ],
                                ),
                              )
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        }));
  }
}