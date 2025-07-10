import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:newsee/AppSamples/ReactiveForms/view/login_mpin.dart';
 
createMpin(BuildContext context) {
  showModalBottomSheet<void>(
    isScrollControlled: true,

    context: context,
    builder: (BuildContext context) {
      final size = MediaQuery.of(context).size;
      final screenWidth = size.width;
      final screenHeight = size.height;
      return GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Container(
          height: screenHeight * 0.82,
          decoration: BoxDecoration(),
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Align(
                child: Padding(
                  padding: const EdgeInsets.all(20),

                  child: Title(
                    color: Colors.black,
                    child: Text(
                      'Create  MPIN',
                      style: TextStyle(fontSize: 20),
                      textAlign: TextAlign.start,
                    ),
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Text('Set new 4 digit MPIN' ,style: TextStyle(fontSize: 16,fontWeight:  FontWeight.w400),),
                  ),
                   Row(
                  // Four TextFields for entering a numeric MPIN
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: List.generate(4, (i) {
                    return Container(
                      width: screenWidth * 0.15,
                      height: screenHeight * 0.06,
                      margin: EdgeInsets.symmetric(horizontal: 2),
                      decoration: BoxDecoration(
                      border: Border.all(width: 1.0, color: Colors.black),
                      borderRadius: BorderRadius.circular(10),
                    ),
                
                      child:
                          Center(
                                child: TextField(
                                  keyboardType: TextInputType.number,
                                  maxLength: 1,
                                  textAlign: TextAlign.center,
                                  decoration: InputDecoration(
                                    counterText: '',
                                    border: InputBorder.none,
                                  ),
                
                                  onChanged: (v) {
                                    if (v.isNotEmpty && i + 1 < 5) {
                                      print('onChanged Value V:  $v' );
                                      

                                      FocusScope.of(context).nextFocus();
                                    }
                                  },
                                ),
                              ),
                    );
                  }),
                ),
                SizedBox(height: screenHeight * 0.05,),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Text('Confirm new 4 digit MPIN',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w400)),
                  ),

                  Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  
                  children: List.generate(4, (i) {
                    return Container(
                      width: screenWidth * 0.15,
                      height: screenHeight * 0.06,
                      margin: EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                      border: Border.all(width: 1.0, color: Colors.black),
                      borderRadius: BorderRadius.circular(10),
                    ),
                
                      child:
                          Center(
                                child: TextField(
                                  keyboardType: TextInputType.number,
                                  maxLength: 1,
                                  textAlign: TextAlign.center,
                                  decoration: InputDecoration(
                                    counterText: '',
                                    border: InputBorder.none,
                                  ),
                
                                  onChanged: (v) {
                                    if (v.isNotEmpty && i + 1 < 5) {
                                      FocusScope.of(context).nextFocus();
                                    }
                                  },
                                ),
                              ),
                    );
                  }),
                ),

                ],
              
              ),
              
              SizedBox(height: 50),
               ElevatedButton(
                            style: const ButtonStyle(
                              backgroundColor: WidgetStatePropertyAll<Color>(
                                Color.fromARGB(255, 2, 59, 105),
                              ),
                              foregroundColor: WidgetStatePropertyAll(
                                Colors.white,
                              ),
                              minimumSize: WidgetStatePropertyAll(
                                Size(230, 40),
                              ),
                            ),
                            onPressed:(){
                              context.pop();
                              mpin(context);
                            },
                                
                                    
                            child:
                               
                                  Text("Create"),
                                  
                          ),
            ],
          ),
        ),
      );
    },
  );
}
