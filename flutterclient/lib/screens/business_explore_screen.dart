import 'package:flutterclient/models/business_data.dart';
import 'package:flutterclient/models/category.dart';
//import 'package:flutterclient/models/top_submissions.dart';
import 'package:flutterclient/screens/projects_screen.dart';
import 'package:flutterclient/utilities/common_objects.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutterclient/api/api_submissions.dart';
import 'package:flutterclient/api/api_problems.dart';
import 'package:flutterclient/utilities/constants.dart';
import 'package:flutterclient/utilities/utility_helper.dart';
import 'package:flutterclient/screens/project_summary_screen.dart';

class BusinessExploreScreen extends StatefulWidget {
  @override
  _BusinessExploreScreenState createState() => _BusinessExploreScreenState();
}

class _BusinessExploreScreenState extends State<BusinessExploreScreen> with SingleTickerProviderStateMixin{

  ExplorePage_Tab currentTab = ExplorePage_Tab.explore_tab;
  String searchText= "";
  bool _isSolutions = true;
  CommonContainer activeProject;

  List<SubmissionItem> topSubmissions;
  List<ProblemItem> topProblems;

  void togglePage(ExplorePage_Tab currTab, bool isSol, [CommonContainer container]) {
    setState(() {
      currentTab = currTab;
      _isSolutions = isSol;
      activeProject = container;
    });
  }

  void setSearchAndToggle(String text){
    setState(() { searchText = text; currentTab = ExplorePage_Tab.projects_tab; });
  }

  void setTopSubmissions(List<SubmissionItem> submissions){
    topSubmissions = submissions;
  }

  void setTopProblems(List<ProblemItem> problems){
    topProblems = problems;
  }

  @override
  void initState() {
    //TODO: implement initState
    super.initState();
    currentTab = ExplorePage_Tab.explore_tab;
    topSubmissions = [];
  }

  @override
  Widget build(BuildContext context) {
    switch (currentTab) {
      case ExplorePage_Tab.explore_tab:
        return ExploreWidget();
        break;
      case ExplorePage_Tab.projects_tab:
        return ProjectsWidget(context, togglePage, searchText, _isSolutions);
        break;
      case ExplorePage_Tab.summary_tab:
        return ProjectSummaryPage(context: context, togglePage: togglePage, container: activeProject);
      default:
        return ExploreWidget();
    }
  }


  Container ExploreWidget() {
    final Shader linearGradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xff0062ff), Color(0xff33b1ff)],
    ).createShader(
        Rect.fromCircle(
          center: Offset(28, 270),
          radius: 28 / 0.4,
        )
    );
    return Container(
        color: Colors.grey[100],
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center, //TODO: maybe remove
            children: <Widget>[
              Container(
                  margin: EdgeInsets.only(top: 16, left:16, right: 16, bottom: 4),
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey[200],
                            offset: Offset(0.0, 1.0),
                            blurRadius: 4
                        )
                      ]
                  ),
                  child: TextField(
                    onChanged: (text) { setSearchAndToggle(text); },
                    decoration: InputDecoration(
                        hintText: "Browse By Customer",
                        alignLabelWithHint: true,
                        border: InputBorder.none,
                        hintStyle: TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 1.0,
                        ),
                        prefixIcon: Icon(Icons.search)
                    ),
                  )
              ),
              Container( //TODO: use Expanded?
                  height: 550.0,
                  color: Colors.grey[100],
                  child: ListView(
                      children: <Widget>[
                        //   buildExploreFilterWidget(),
/*                        Container(
                          height: 50,
                          padding: EdgeInsets.only(top: 24, left: 16),
                          child:
                          Text(
                            "Favorite Businesses",
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.normal,
                              fontFamily: 'roboto',
                              foreground: Paint()..shader = linearGradient,
                            ),
                          ),
                        ),*/
                        buildCategoryWidget(),
                        // TopRatedWidget(setTopSubmissions),
                        // ProblemsWidget(setTopProblems),
                        // buildFooter(),
                      ]
                  )
              )
            ]
        )
    );
  }

  Container buildFooter() {
    return Container(
        height: 200,
        color: Color(0xffffffff),
        padding: EdgeInsets.only(bottom: 46, top: 28, left: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "Keep yourself updated",
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.w600,
                fontFamily: 'roboto',
                color: Color(0xff171717),
              ),
            ),
            SizedBox(height: 15,),
            Text(
                "Resource links",
                style: TextStyle(
                  fontSize: 15,
                  color: Color(0xff171717),
                  letterSpacing: 1.0,
                )
            ),
            SizedBox(height: 6,),
            Text(
                "Covid-Safe care practices",
                style: TextStyle(
                  fontSize: 15,
                  color: Color(0xff171717),
                  letterSpacing: 1.0,
                )
            ),
            SizedBox(height: 6,),
            Text(
                "Social distancing procedures",
                style: TextStyle(
                  fontSize: 15,
                  color: Color(0xff171717),
                  letterSpacing: 1.0,
                )
            ),
          ],
        )
    );
  }

  StatefulWidget TopRatedWidget(setTopSubmissions) {
    return new FutureBuilder<SubmissionsList>(future: fetchTopSubmissionsPost(3), builder: (context, snapshot){
      if(snapshot.hasData) {
        setTopSubmissions(snapshot.data.submissionItems);
        return buildTopRatedWidget();
      } else if (snapshot.hasError){
        print(snapshot.error);
        return new Container();
      } else {
        print("failed to get submissions for unknown reasons");
        return new Container();
      }
    });
  }

  Container buildTopRatedWidget() {
    return Container(
        height: 354,
        color: Colors.black,
        padding: EdgeInsets.only(bottom: 46, top: 16, left: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "Top-rated submissions",
              style: TextStyle(
                fontSize: 26,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 10,),
            Text(
                "Check out how others like you are changing the world",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  letterSpacing: 1.0,
                )
            ),
            Expanded(
                child: Container(
                    padding: EdgeInsets.symmetric(vertical: 2),
                    height: double.infinity,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 3,
                        itemBuilder: (BuildContext context, int index){
                          SubmissionItem submission = topSubmissions[index];
                          return Container(
                              width: 160,
                              margin: index == 0 ? EdgeInsets.only(right: 16, top: 4, bottom: 12) : EdgeInsets.only(right: 16, top: 4, bottom: 12),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.grey[850],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Expanded(
                                      child: Container(
                                          width: double.infinity,
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.only(topLeft: Radius.circular(5), topRight: Radius.circular(5)),
                                            child: Image(
                                              image: AssetImage(getCoverImage(submission.uploads)),
                                              fit: BoxFit.cover,
                                            ),
                                          )
                                      )
                                  ),
                                  Container(
                                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                                submission.country,
                                                style: TextStyle(
                                                  letterSpacing: 1,
                                                  color: Colors.white,
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w600,
                                                )
                                            ),
                                            Text(
                                                submission.name,
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white
                                                )
                                            ),
                                            Row(
                                              children: <Widget>[
//                                              Text('🔥'), can use emojis too, comment for later
                                                Icon(
                                                  FontAwesomeIcons.solidHeart,
                                                  size: 12,
                                                  color: Color(0xff0062ff),
                                                ),
                                                SizedBox(width: 2,),
                                                Text(
                                                  " " + submission.numLikes.toString(),
                                                  style: TextStyle(
                                                      fontSize: 11,
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.white
                                                  ),
                                                ),
                                                SizedBox(width: 8,),
                                              ],
                                            )
                                          ]
                                      )
                                  )
                                ],
                              )
                          );
                        }
                    )
                )
            ),
            OutlineButton(
              onPressed: () { togglePage(ExplorePage_Tab.projects_tab, true); },
              color: Colors.black,
              padding: EdgeInsets.only(left: 32, right: 32),
              borderSide: BorderSide(color: Colors.white),
              child: const Text('View all solutions', style: TextStyle(fontSize: 14, color: Colors.white)),
            ),
          ],
        )
    );
  }

  Container buildCategoryWidget() {
    return Container(
        height: 600,
        margin: const EdgeInsets.only(top: 10.0, bottom: 10.0, left:5.0, right: 5.0),
        decoration: BoxDecoration(
        gradient: LinearGradient(
        colors: [Colors.grey[100], Colors.grey[100]],
        begin: FractionalOffset(0.0, 1.0),
        end: FractionalOffset(0.5, 0.0),
        stops: [0.5, 1.0],
        tileMode: TileMode.clamp),
        ),
       // color: Colors.transparent, //TODO: Or Colors.black12
       // padding: EdgeInsets.only(top: 32, bottom: 32, left: 16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: <Widget>[
            Text(
                "  Customer Transaction Summary",
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'roboto',
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.0,
                  color: Colors.deepOrangeAccent,
                  )
            ),
            SizedBox(height: 20,),
            Expanded(
                child: Container(
                   // padding: EdgeInsets.symmetric(vertical: 2),
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    height: double.infinity,
                    child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: businesses.length,
                        itemBuilder: (BuildContext context, int index){
                          BusinessData business = businesses[index];
                          return InkWell(
                    //        onTap: () => setSearchAndToggle( business.customerName),
                            child: Container(
                                width: 170,
                                margin: index == 0 ? EdgeInsets.only(right: 16, top: 4, bottom: 4) : EdgeInsets.only(right: 16, top: 4, bottom: 4),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.transparent, //TODO: Colors.grey[200]
                                          offset: Offset(0.0, 4.0),
                                          blurRadius: 4
                                      )
                                    ]
                                ),
                                child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 1),
                                    margin: EdgeInsets.only(left: 6),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        gradient: new LinearGradient(
                                            colors: [Colors.white, Colors.white],),
                                        boxShadow: [
                                          BoxShadow(
                                              color: Colors.grey[200],
                                              offset: Offset(1.0, 1.0),
                                              blurRadius: 4
                                          )
                                        ]
                                    ),
                                    child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: <Widget>[
                                          Padding(
                                            padding: EdgeInsets.only(bottom: 5),
                                            child: ListTile(
                                              contentPadding: EdgeInsets.symmetric(horizontal: 0.0),
                                              leading: Container(
                                                width: 46.0,
                                                height: 46.0,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black45.withOpacity(0.1),
                                                      offset: Offset(0, 2),
                                                      blurRadius: 6.0,
                                                    ),
                                                  ],
                                                ),
                                                child: CircleAvatar(
                                                  child: ClipOval(
                                                    child: Image(
                                                      height: 47.0,
                                                      width: 47.0,
                                                      image: AssetImage("images/userIcon.png"),
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              title: Text(
                                                business.customerName,
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontFamily: 'roboto',
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.grey[800]
                                                ),
                                              ),
                                              subtitle: Text(
                                                business.phoneNum + business.dealR,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              trailing: Text(

                                                  business.amount,
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontFamily: 'roboto',
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.grey[800]
                                                  )
                                              ),
                                            ),
                                          )
                                        ]
                                    )
                                )
                            ),
                          );
                        }
                    )
                )
            )
          ],
        )
    );
  }

  Container buildExploreFilterWidget() {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
            children: <Widget>[
              InkWell(
                onTap: () => setSearchAndToggle("Covid"),
                child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    margin: EdgeInsets.only(right: 6),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50.0),
                        color: Colors.white,
                        border: Border.all(
                          color: Colors.grey[300],
                          width: 1.0,
                        )
                    ),
                    child: Text("Covid")
                ),
              ),
              InkWell(
                onTap: () => setSearchAndToggle("Park"),
                child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    margin: EdgeInsets.only(right: 6),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50.0),
                        color: Colors.white,
                        border: Border.all(
                          color: Colors.grey[300],
                          width: 1.0,
                        )
                    ),
                    child: Text("Parks")
                ),
              ),
              InkWell(
                onTap: () => setSearchAndToggle("Forest Fires"),
                child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    margin: EdgeInsets.only(right: 6),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50.0),
                        color: Colors.white,
                        border: Border.all(
                          color: Colors.grey[300],
                          width: 1.0,
                        )
                    ),
                    child: Text("Forest Fires")
                ),
              )
            ]
        )
    );
  }


  StatefulWidget ProblemsWidget(setTopProblems) {
    return new FutureBuilder<ProblemsList>(future: fetchTopProblemsPost(3), builder: (context, snapshot){
      if(snapshot.hasData) {
        setTopProblems(snapshot.data.problemItems);
        return buildProblemsWidget();
      } else if (snapshot.hasError){
        print(snapshot.error);
        return new Container();
      } else {
        print("failed to get submissions for unknown reasons");
        return new Container();
      }
    });
  }

  Container buildProblemsWidget() {
    return Container(
        height: 374,
        color: Color(0xfff4f4f4),
        padding: EdgeInsets.only(bottom: 46, top: 16, left: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "Problems at a glance",
              style: TextStyle(
                fontSize: 26,
                color: Color(0xff171717),
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 10,),
            Text(
                "Feel inspired? Want to help? This is the best place to start.",
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xff171717),
                  letterSpacing: 1.0,
                )
            ),
            Expanded(
                child: Container(
                    padding: EdgeInsets.symmetric(vertical: 2),
                    height: double.infinity,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 6,
                        itemBuilder: (BuildContext context, int index){
                          ProblemItem problem = topProblems[index];
                          return Container(
                              width: 160,
                              margin: index == 0 ? EdgeInsets.only(right: 16, top: 4, bottom: 12) : EdgeInsets.only(right: 16, top: 4, bottom: 12),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Color(0xfff4f4f4),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Expanded(
                                      child: Container(
                                          width: double.infinity,
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.only(topLeft: Radius.circular(5), topRight: Radius.circular(5)),
                                            child: Image(
                                              image: AssetImage(getCoverImage(problem.uploads)),
                                              fit: BoxFit.cover,
                                            ),
                                          )
                                      )
                                  ),
                                  Container(
                                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                                problem.country,
                                                style: TextStyle(
                                                  letterSpacing: 1,
                                                  color: Color(0xff171717),
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w600,
                                                )
                                            ),
                                            Text(
                                                problem.name,
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                    color: Color(0xff171717)
                                                )
                                            ),
                                            Row(
                                              children: <Widget>[
//                                              Text('🔥'), can use emojis too, comment for later
                                                Icon(
                                                  FontAwesomeIcons.solidHeart,
                                                  size: 12,
                                                  color: Color(0xff0062ff),
                                                ),
                                                SizedBox(width: 2,),
                                                Text(
                                                  " " + problem.numLikes.toString(),
                                                  style: TextStyle(
                                                      fontSize: 11,
                                                      fontWeight: FontWeight.bold,
                                                      color: Color(0xff171717)
                                                  ),
                                                ),
                                                SizedBox(width: 8,),
                                              ],
                                            )
                                          ]
                                      )
                                  )
                                ],
                              )
                          );
                        }
                    )
                )
            ),
            OutlineButton(
              onPressed: () { togglePage(ExplorePage_Tab.projects_tab, false); },
              color: Color(0xff171717),
              padding: EdgeInsets.only(left: 32, right: 32),
              borderSide: BorderSide(color: Color(0xff171717)),
              child: const Text('View All Problems', style: TextStyle(fontSize: 14, color: Color(0xff171717))),
            ),
          ],
        )
    );
  }


}