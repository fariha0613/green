import 'package:flutter/material.dart';


// home pg e jei tab bar er category ase oitar dart file


class hpCategory extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return  Padding(
        padding:  EdgeInsets.all(12),
        child: GridView.builder(
            itemCount: 6,
            gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.45,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
            ),
            itemBuilder: (context, index) {
              final i = index + 7; // pic7 -> pic12
              return GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, "itemPage");
                  },
                child:Container(        //grid er items design
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 1,
                      blurRadius: 5,
                    )
                  ],
                ),
                child: Column(
                  children: [
                       Image.asset("assets/images/pic$i.png",
                        fit: BoxFit.contain,
                        height: 200,
                        width: 200,
                      ),

                    SizedBox(height: 15,),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Item name",
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 20,),
                          Text("\$50",
                            style: TextStyle(fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                           Align(alignment: Alignment.bottomRight,
                            child:
                            Icon(Icons.star_border, color: Colors.black,),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              );

            },
            ),

    );



  }

}