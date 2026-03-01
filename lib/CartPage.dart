import 'package:flutter/material.dart';

import 'CartItemSample.dart';

class  CartPage extends StatefulWidget{
  @override
  State<CartPage> createState()=> _CartPageState();

  }
  class _CartPageState extends State<CartPage>{
  bool checkedValue=false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:ListView(
        children: [
         Padding(
             padding:EdgeInsetsGeometry.symmetric(vertical: 15,horizontal: 15),
             child:Row(
               children: [
                 InkWell(
                   onTap: (){
                     Navigator.pop(context);
                   },
                  child: Icon(
                    Icons.arrow_back,
                    size:28,
                  ),
                 ),
                 SizedBox(width: 15,),
                 Text(
                   "My Cart",style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold,color:Colors.green[300]),
                 ),
                 Spacer(),
                 Container(
                   padding: EdgeInsets.all(8),
                   decoration:BoxDecoration(
                       color:Colors.white,
                       borderRadius: BorderRadius.circular(10),
                       boxShadow: [
                         BoxShadow(
                           color:Colors.grey.withOpacity(0.3),
                           spreadRadius: 1,
                           blurRadius: 1,
                         )
                       ],
                   ),
                   child: Icon(
                       Icons.notifications,
                       size:30,
                       color:Colors.green[300],
                   ),
                 ),
               ],
             ),
         ),


         Container(
           padding: EdgeInsets.only(top:10),
           color:Colors.white,
           child:Column(
             children: [
               CheckboxListTile(
                 activeColor:Colors.green,
                 title:Text("Select all items",style: TextStyle(fontSize: 18),),
                 value:checkedValue,
                 onChanged: (newvalue) {
                   setState(() {
                     checkedValue=newvalue!;
                   });
                 },
                 controlAffinity: ListTileControlAffinity.leading,
               ),
               Divider(height: 30,thickness: 1,),
               CartItemSample(),//cart er majher part ta
             ],
           )
         ),



          //cart er nicher dabba
          Container(
            margin:EdgeInsets.symmetric(horizontal: 15,vertical: 10),
            padding: EdgeInsets.all(15),
            decoration:BoxDecoration(
              color:Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color:Colors.black.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 5,
                )
              ],
            ),
            child:Column(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Sub-Total:",
                    style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color:Colors.black),
                  ),
                  Text("\$100",
                    style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color:Colors.black),
                  ),

                ],
              ),
              Divider(height: 20,thickness: 1,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Delivery Fee:",
                    style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color:Colors.black),
                  ),
                  Text("\$10",
                    style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color:Colors.black),
                  ),

                ],
              ),
              Divider(height: 20,thickness: 1,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Discount:",
                    style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color:Colors.black),
                  ),
                  Text("-\$100",
                    style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color:Colors.black),
                  ),

                ],
              ),
            ],
            ),
          ),
        ],
      ),



     //cart page er  niche

     bottomNavigationBar: Container(
       height: 130,
       padding: EdgeInsets.symmetric(horizontal: 20),
       decoration: BoxDecoration(
         color: Colors.white,
         boxShadow: [
           BoxShadow(
             color:Colors.black.withOpacity(0.2),
             spreadRadius: 1,
             blurRadius: 5,
           )
         ],
       ),
       child:Row(
         mainAxisAlignment: MainAxisAlignment.spaceBetween,
             children: [
               Text("Total : \$150 ",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold,),),


              GestureDetector(
             onTap:(){

             },
             child:Container(
               padding: EdgeInsets.symmetric(vertical: 15,horizontal: 20),
               decoration: BoxDecoration(color:Colors.green[300],
               borderRadius: BorderRadius.circular(10),
               ),
               child:Text("Check out",
                 style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color:Colors.white),
               ),
             )
           ),
         ],
       ),



     ),
    );
  }



  }