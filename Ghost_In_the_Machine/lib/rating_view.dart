import 'dart:math';

import 'package:flutter/material.dart';

class RatingView extends StatefulWidget {
  //const RatingView({Key? key}) : super(key: key);

  @override
  State<RatingView> createState() => _RatingViewState();
}

class _RatingViewState extends State<RatingView> {
  var _ratingPageController = PageController();
  var _starPosition = 140.0;
  var _rating =0;
  var _selectedChipIndex = -1;
  var _isMoreDetailActive = false;
  var _moreDetailFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
      ),
      clipBehavior: Clip.antiAlias,
      child:Stack(
        children: [
          //thanks note
          Container(
            height: max(300, MediaQuery.of(context).size.height*0.3),
            child: PageView(
              controller:_ratingPageController ,
              physics: NeverScrollableScrollPhysics(),
              children: [
                _buildThanksNote(),
                _causeOfRating(),
              ],
            ),
          ),
          //done button
          Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                color: Colors.amber,
                child: MaterialButton(
                    onPressed: _hideDialog,
                    child: Text('Done'),
                    textColor: Colors.black,
                ),
              ),
          ),
          //skip button
          Positioned(
            right: 0,
            child: MaterialButton(
                onPressed: _hideDialog,
                child: Text('Skip'),
            ),
          ),
          //star rating
          AnimatedPositioned(
            top: _starPosition,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                  5,
                  (index) => IconButton(
                    icon: index < _rating ? Icon(Icons.star,size: 32):Icon(Icons.star_border,size: 32),
                    color: Colors.amber,
                    onPressed: (){
                      _ratingPageController.nextPage(duration: Duration(milliseconds:300), curve: Curves.easeIn);
                      setState((){
                        _starPosition = 30.0;
                        _rating = index +1;
                      });
                    },
                  ),
              ),
            ), duration: Duration(milliseconds: 300),
          ),
          //back button
          if(_isMoreDetailActive)
            Positioned(
              left: 0,
              top: 0,
              child: MaterialButton(
                  onPressed: (){
                    setState((){
                      _isMoreDetailActive = false;
                    });
                  },
                child: Icon(Icons.arrow_back_ios),
              ),
            ),
        ],
      ),
    );
  }

  _buildThanksNote(){
    return Column(
      //文字位置
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Thanks for using this \n"Ghost In The Machine" app',
          style: TextStyle(
            fontSize: 20,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        Text('We\'d love to get your feedback'),
        //Text('How was your ride today'),
      ],
    );
  }

  _causeOfRating(){
    return Stack(
      alignment: Alignment.center,
      children: [
        Visibility(
          visible: ! _isMoreDetailActive,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('How do you feel?'),
                //选择框
                Wrap(
                  spacing: 8.0,
                  alignment: WrapAlignment.center,

                  children: const [
                    Chip(
                      label: Text('I\'m scared of these images'),
                      labelStyle: TextStyle(color: Colors.white),
                      //avatar: Icon(Icons.backup,color: Colors.white),
                      backgroundColor: Colors.black45,
                    ),

                    Chip(
                      label: Text('This machine received a curse'),
                      labelStyle: TextStyle(color: Colors.white),
                      //avatar: Icon(Icons.all_inbox,color: Colors.white),
                      backgroundColor: Colors.black45,

                    ),

                  ]

                ),
                SizedBox(height: 16),
                InkWell(
                  onTap: (){
                    _moreDetailFocusNode.requestFocus();
                    setState((){
                      _isMoreDetailActive = true;
                    });
                  },
                  child:Text(
                    'Tell us more about how you feel',
                    style: TextStyle(decoration: TextDecoration.underline),
                  ),
                ),
              ],
            ),
          replacement: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Tell us more'),
              Chip(label: Text('Text ${_selectedChipIndex + 1}')),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TextField(
                  focusNode: _moreDetailFocusNode,
                  decoration: InputDecoration(
                    hintText: 'Write your review here...',
                    hintStyle: TextStyle(
                      color: Colors.grey[400],
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),

            ],
          ),
        ),
      ],
    );
  }
  _hideDialog(){
    if(Navigator.canPop(context)) Navigator.pop(context);
  }
}
