import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//item tap korle jei pg ashbe
class Itempage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:ListView(
        children: [
          Container(
            color:Colors.white,
            width: double.infinity,
            height:320,
            padding: EdgeInsets.symmetric(vertical: 15),
            child:Column(
              children: [
                Padding(padding: EdgeInsets.symmetric(vertical: 15,horizontal: 30),

                child:Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: (){
                        Navigator.pop(context);
                      },
                      child:Icon(
                        Icons.arrow_back,
                        size:28,
                      )
                    ),
                    Container( //r8 side a star
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color:Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow:[
                          BoxShadow(
                              color: Colors.grey,spreadRadius: 1,blurRadius: 5,
                          ),
                        ]
                      ),
                      child:Icon(
                        Icons.star,
                        size:30,
                        color:Colors.green[300],
                      ),
                    ),
                  ],
                ),
                ),
                Image.asset("assets/images/pic8.png",height: 200,width:280,fit:BoxFit.contain),
              ],
            ),
          ),


          SizedBox(height: 15,),
          Container(
            padding: EdgeInsets.all(15),
            margin:EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color:Colors.white,
              boxShadow:[
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 1,
                  blurRadius: 5,
                ),
              ],
            ),
            child:Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children:[
                Text(
                  "Item name",
                  style:TextStyle(
                      fontSize: 20,fontWeight: FontWeight.bold),
                ),
                Text("\$50",
                      style:TextStyle(fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color:Colors.green),
                    ),


              ],
            ),
          ),
          SizedBox(height: 15,),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15,vertical: 8),
            margin: EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color:Colors.grey.withOpacity(0.3),
                  spreadRadius: 1,
                  blurRadius: 5,
                ),
              ],
            ),
            child:Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Product Details",
                  style:TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,),
                ),
                SizedBox(height: 8,),
                Text ("This is the description of the product This is the description of the product"
                    "This is the description of the product This is the description of the product."
                    "This is the description of the product This is the description of the product "
                    "This is the description of the product",
                   style:TextStyle(fontSize: 16)),
              ],
            ),
          ),
          SizedBox(height: 15,),

          //scroll item
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children:[
              Padding(
                  padding:EdgeInsets.only(left:30),
                  child:Text(
                    "Only For You",
                    style:TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,),
                  ),
              ),
              SizedBox(height: 5,),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child:Row(
                  children: [
                    for(int i=7;i<19;i++)
                    Container(
                      height: 100,
                      width: 140,
                      padding: EdgeInsets.all(5),
                      margin:EdgeInsets.only(top:8,bottom: 8,left:20),
                      decoration: BoxDecoration(
                        color:Colors.green[300],
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color:Colors.grey.withOpacity(0.3),
                            spreadRadius: 1,
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child:Image.asset("assets/images/pic$i.png",
                           fit:BoxFit.contain,
                      )
                    )
                  ],
                )
              )
            ],
          ),
        ],
      ),


      bottomNavigationBar: Container(
        height: 80,
        padding: EdgeInsets.symmetric(vertical: 12,horizontal: 25),
          decoration: BoxDecoration(
            color:Colors.white,
          ),
        child:Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children:[
            GestureDetector(
              onTap:(){
                Navigator.pushNamed(context,"cartPage");
              },
              child:Container(
                height: 60,
                width: 80,
                alignment: Alignment.center,
                decoration: BoxDecoration(color:Colors.green[300],borderRadius: BorderRadius.circular(10),),
                child:Icon
                  (CupertinoIcons.cart_fill,color:Colors.white,size:35),

                ),
              ),
            GestureDetector(
              onTap:(){},
              child:Container(
                height: 60,
                width: 220,
                alignment: Alignment.center,
                decoration: BoxDecoration(color:Colors.green[300],borderRadius: BorderRadius.circular(10),),
                child:Text(
                  "Buy Now",style:TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,color: Colors.white,letterSpacing: 1),
                ),
              ),
            ),
          ],
        ),
      ),
    );

  }

}