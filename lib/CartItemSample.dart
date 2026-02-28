import 'package:flutter/material.dart';


//cart er majher part

class CartItemSample extends StatefulWidget{
  @override
  State<CartItemSample> createState() => _CartItemSampleState();
}

class _CartItemSampleState extends State<CartItemSample>{
  bool checkedValue=false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for(int i=1;i<4;i++)
        Container(
          margin:EdgeInsets.symmetric(vertical: 5,horizontal: 12),
          child:Column(
            children: [
              Row(
                children: [
                  Checkbox(
                      activeColor: Colors.green[300],
                      value: checkedValue,
                      onChanged: (newValue){
                        setState(() {
                          checkedValue=newValue!;
                        });
                      }
                  ),
                  Container(
                    height: 70,width: 70,
                    padding: EdgeInsets.all(5),
                    margin: EdgeInsets.only(left:5),
                    decoration: BoxDecoration(
                      color:Colors.green[100],
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color:Colors.black.withOpacity(0.2),

                        ),
                      ],
                    ),
                    child:Image.asset(
                        "assets/images/pic11.png",fit:BoxFit.contain,
                    ),
                  ),

                  Padding(
                      padding: EdgeInsetsGeometry.symmetric(horizontal: 10),
                      child:Column(
                        children: [
                          Text(
                            "Item name",
                             style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color:Colors.black),
                          ),
                          SizedBox(height: 12,),
                          Row(
                            children: [
                              Text("\$50", style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold,color:Colors.green[100],)
                              ),
                            ],
                          )
                        ],
                     ),
                  ),
                  Spacer(),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children:[
                      Icon(
                        Icons.delete,color:Colors.redAccent,
                      ),
                      SizedBox(height: 10,),
                      Row(
                        children: [
                          Container(
                            height: 25,width: 25,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color:Colors.green[300],
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child:Icon(
                              Icons.remove,color:Colors.white,size:18,
                            ),
                          ),

                          Container(
                            margin:EdgeInsets.symmetric(horizontal: 15),
                            child:Text("01", style: TextStyle(fontSize: 16,
                                fontWeight: FontWeight.bold,color:Colors.black)
                            ),
                          ),

                          Container(
                            height: 25,width: 25,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color:Colors.green[300],
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child:Icon(
                              Icons.add,color:Colors.white,size:18,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20,),
              Divider(thickness: 1,),
          ],
          ),


        ),
      ],
    );
  }

}