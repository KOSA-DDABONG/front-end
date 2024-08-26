import 'package:flutter/material.dart';
import 'package:front/component/snack_bar.dart';
import 'package:front/dto/board/board_model.dart';
import 'package:front/dto/comment/comment_request_model.dart';
import 'package:front/dto/hashtag/hashtag_model.dart';
import 'package:front/dto/image/image_model.dart';
import 'package:front/responsive.dart';
import 'package:front/service/board_service.dart';
import 'package:front/service/result.dart';
import 'package:front/service/session_service.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../dto/board/board_detail_get_response_model.dart';
import '../../dto/comment/comment_info_model.dart';
import '../../dto/comment/comment_list_model.dart';
import '../../key/key.dart';
import '../../screen/review/all_review_screen.dart';
import '../map/get_map.dart';

void showDetailReviewDialog(
    BuildContext context,
    String apiKey,
    int postid,
    // AllBoardList review,
    Result<BoardDetailGetResponseModel> result
  ) {
  final PageController pageController = PageController();
  final TextEditingController commentController = TextEditingController();
  List<CommentInfoModel>? commentList = result.value?.data.commentInfoDTOs;
  List<String>? hashtagList = result.value?.data.hashtags;
  List<String>? imageList = result.value?.data.url;



  showDialog(
    context: context,
    builder: (BuildContext context) {
      bool isLiked = result.value!.data.isLike;
      bool showComments = false;
      bool isButtonEnabled = false;

      void updateButtonState(String text, StateSetter setState) {
        final RegExp regex = RegExp(r'^\s*$'); // 공백만으로 이루어졌는지 검사
        setState(() {
          isButtonEnabled = !regex.hasMatch(text) && text.trim().isNotEmpty;
        });
      }

      if(Responsive.isNarrowWidth(context)) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5.0),
                child: Container(
                  color: Colors.white,
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: MediaQuery.of(context).size.height * 0.9,
                  child: Stack(
                    children: [
                      Column(
                        children: [
                          Expanded(
                            flex: 5,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Stack(
                                alignment: Alignment.bottomCenter,
                                children: [
                                  PageView(
                                    controller: pageController,
                                    children: imageList != null && imageList.isNotEmpty
                                      ? imageList.map((imageModel) {
                                          return ClipRRect(
                                            borderRadius: BorderRadius.circular(5.0),
                                            child: Image.network(
                                              imageModel,
                                              fit: BoxFit.cover,
                                              errorBuilder: (context, error, stackTrace) {
                                                return Image.asset(
                                                  'assets/images/noImg.jpg',
                                                  fit: BoxFit.cover,
                                                ); // 대체 이미지
                                              },
                                            ),
                                          );
                                        }).toList()
                                      : [
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(5.0),
                                            child: Image.asset(
                                              'assets/images/noImg.jpg',
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ],
                                  ),
                                  Positioned(
                                    bottom: 8.0,
                                    child: SmoothPageIndicator(
                                      controller: pageController,
                                      count: imageList!.length,
                                      effect: const WormEffect(
                                        dotHeight: 8.0,
                                        dotWidth: 8.0,
                                        spacing: 16.0,
                                        activeDotColor: Colors.black,
                                        dotColor: Colors.grey,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 4,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(5.0),
                                child:Container()
                                // GetMap(
                                //     apiKey: GOOGLE_MAP_KEY,
                                //     origin: LatLng(result.value!.data.tour[0].latitude,result.value!.data.tour[0].longitude).toString(),
                                //     destination: LatLng(result.value!.data.hotel[0].latitude,result.value!.data.hotel[0].longitude).toString(),
                                //     waypoints: LatLng(result.value!.data.restaurant[0].latitude,result.value!.data.restaurant[0].longitude).toString()
                                // ),

                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Row(
                              children: [
                                IconButton(
                                  icon: Icon(
                                    isLiked ? Icons.favorite : Icons.favorite_border,
                                    color: isLiked ? Colors.red : Colors.black,
                                  ),
                                  onPressed: () {
                                    try{
                                      final response = BoardService.updateLikes(result.value!.data.postId);
                                      if(response != null) {
                                        setState(() {
                                          isLiked = !isLiked;
                                        });
                                      }
                                    }
                                    catch (e) {
                                      showCustomSnackBar(context, "좋아요 업데이트에 실패하였습니다.");
                                    }
                                  },
                                ),
                                // Text('$likesNum'),
                                Text('${result.value!.data.likeCnt}'),
                                const SizedBox(width: 16),
                                (!showComments)
                                ? IconButton(
                                    icon: const Icon(Icons.comment_outlined),
                                    onPressed: () {
                                      setState(() {
                                        showComments = !showComments;
                                      });
                                    },
                                  )
                                : IconButton(
                                    icon: const Icon(Icons.comment),
                                    onPressed: () {
                                      setState(() {
                                        showComments = !showComments;
                                      });
                                    },
                                  ),
                                const SizedBox(width: 8),
                                Text('${result.value!.data.commentCnt}'),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 7,
                            child: SingleChildScrollView(
                              padding: const EdgeInsets.only(bottom: 70.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (!showComments) ...[
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 8),
                                              child: Text(
                                                // "$commentContent",
                                                "${result.value?.data.content}",
                                                style: const TextStyle(fontSize: 18),
                                              ),
                                            )
                                          ),
                                          const SizedBox(height: 10),
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 8),
                                              child: Text(
                                                hashtagList != null
                                                    ? hashtagList.map((hashtag) => '#${hashtag}').toSet().join(' ')
                                                    : '',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.blueGrey,
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                        ],
                                      ),
                                    ),
                                  ],
                                  if (showComments) ...[
                                    ListView.builder(
                                      shrinkWrap: true,
                                      physics: const NeverScrollableScrollPhysics(),
                                      itemCount: 100,
                                      itemBuilder: (context, index) {
                                        final comment = commentList![index];
                                        return Column(
                                          children: [
                                            ListTile(
                                              leading: ClipRRect(
                                                borderRadius: BorderRadius.circular(100),
                                                child: Image.network(
                                                  comment.profileUrl,
                                                  fit: BoxFit.cover,
                                                  errorBuilder: (context, error, stackTrace) {
                                                    return Image.asset('assets/images/noImg.jpg',
                                                      fit: BoxFit.cover,
                                                    );
                                                  },
                                                ),
                                              ),
                                              title: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    comment.nickName,
                                                    style: const TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 4),
                                                  Text(comment.content),
                                                ],
                                              ),
                                            ),
                                            Divider(color: Colors.grey[200]),
                                          ],
                                        );
                                      },
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          color: Colors.white,
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: commentController,
                                  onChanged: (text) {
                                    updateButtonState(text, setState);
                                  },
                                  decoration: InputDecoration(
                                    hintText: '댓글을 입력하세요...',
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.send),
                                onPressed: isButtonEnabled ? () async {
                                  try{
                                    final model = CommentRequestModel(postId: postid, comcontent: commentController.text.trim());
                                    final result = BoardService.registerComment(model);

                                    if(result != null) {
                                      // Navigator.of(context).pushReplacement(
                                      //   MaterialPageRoute(
                                      //     builder: (context) => AllReviewScreen(),
                                      //   ),
                                      // );
                                      Navigator.pop(context);
                                      showCustomSnackBar(context, "댓글 작성에 성공하였습니다.");
                                    }
                                    else{
                                      showCustomSnackBar(context, "댓글 작성에 실패하였습니다. 잠시 후 다시 시도해주세요.");
                                    }
                                  } catch (e) {
                                    showCustomSnackBar(context, "에러가 발생하였습니다. 잠시 후 다시 시도해주세요.");
                                  }
                                } : null
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      }
      else {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5.0),
                child: Container(
                  color: Colors.white,
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: MediaQuery.of(context).size.height * 0.9,
                  child: Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Column(
                          children: [
                            Expanded(
                              flex: 5,
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                                child: Stack(
                                  alignment: Alignment.bottomCenter,
                                  children: [
                                    PageView(
                                      controller: pageController,
                                      children: imageList != null && imageList.isNotEmpty
                                        ? imageList.map((imageModel) {
                                            return ClipRRect(
                                              borderRadius: BorderRadius.circular(5.0),
                                              child: Image.network(
                                                imageModel,
                                                errorBuilder: (context, error, stackTrace) {
                                                  return Image.asset(
                                                    'assets/images/noImg.jpg',
                                                    fit: BoxFit.cover,
                                                  ); // 대체 이미지
                                                },
                                                fit: BoxFit.cover,
                                              ),
                                            );
                                          }).toList()
                                        : [
                                            ClipRRect(
                                              borderRadius: BorderRadius.circular(5.0),
                                              child: Image.asset(
                                                'assets/images/noImg.jpg',
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ],
                                    ),
                                    Positioned(
                                      bottom: 8.0,
                                      child: SmoothPageIndicator(
                                        controller: pageController,
                                        count: imageList!.length,
                                        effect: const WormEffect(
                                          dotHeight: 8.0,
                                          dotWidth: 8.0,
                                          spacing: 16.0,
                                          activeDotColor: Colors.black,
                                          dotColor: Colors.grey,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 4,
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(20, 5, 20, 20),
                                child: PageView(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(5.0),
                                      child:Container()
                                      // GetMap(
                                      //     apiKey: GOOGLE_MAP_KEY,
                                      //     origin: LatLng(result.value!.data.tour[0].latitude,result.value!.data.tour[0].longitude).toString(),
                                      //     destination: LatLng(result.value!.data.hotel[0].latitude,result.value!.data.hotel[0].longitude).toString(),
                                      //     waypoints: LatLng(result.value!.data.restaurant[0].latitude,result.value!.data.restaurant[0].longitude).toString()
                                      // ),

                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Column(
                          children: [
                            Expanded(
                              flex: 5,
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(10, 20, 20, 20),
                                        child: Text(
                                          // "$commentContent",
                                          "${result.value?.data.content}",
                                          style: const TextStyle(fontSize: 18),
                                          textAlign: TextAlign.left,
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Padding(
                                        padding: EdgeInsets.fromLTRB(10, 20, 20, 20),
                                        child: Text(
                                          hashtagList != null
                                              ? hashtagList.map((hashtag) => '#${hashtag}').toSet().join(' ')
                                              : '',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.blueGrey,
                                          ),
                                          textAlign: TextAlign.left,
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              )
                            ),
                            Expanded(
                              flex: 1,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  IconButton(
                                    icon: Icon(
                                      isLiked ? Icons.favorite : Icons.favorite_border,
                                      color: isLiked ? Colors.red : Colors.black,
                                    ),
                                    onPressed: () {
                                      try{
                                        final response = BoardService.updateLikes(result.value!.data.postId);
                                        print("[Likes Update Response] $response");
                                        if(response != null) {
                                          setState(() {
                                            isLiked = !isLiked;
                                          });
                                        }
                                      }
                                      catch (e) {
                                        print("[Likes Update Failed] : $e");
                                        showCustomSnackBar(context, "좋아요 업데이트에 실패하였습니다.");
                                      }
                                    },
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                                    child:
                                    // Text('$likesNum'),
                                    Text('${result.value?.data.likeCnt}'),
                                  ),
                                  const Icon(Icons.comment),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                                    child:
                                    // Text('$commentsNum'),
                                    Text('${result.value?.data.commentCnt}'),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 6,
                              child: ListView.builder(
                                // shrinkWrap: true,
                                // physics: NeverScrollableScrollPhysics(),
                                itemCount: commentList?.length ?? 0,
                                itemBuilder: (context, index) {
                                  final comment = commentList![index];
                                  return Column(
                                    children: [
                                      ListTile(
                                        leading: ClipRRect(
                                          borderRadius: BorderRadius.circular(100),
                                          child: Image.network(
                                            comment.profileUrl,
                                            fit: BoxFit.cover,
                                            errorBuilder: (context, error, stackTrace) {
                                              return Image.asset('assets/images/noImg.jpg',
                                                fit: BoxFit.cover,
                                              );
                                            },
                                          ),
                                        ),
                                        title: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              comment.nickName,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(comment.content),
                                          ],
                                        ),
                                      ),
                                      Divider(color: Colors.grey[200]),
                                    ],
                                  );
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 20.0),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: TextField(
                                        controller: commentController,
                                        onChanged: (text) {
                                          updateButtonState(text, setState);
                                        },
                                        decoration: const InputDecoration(
                                          hintText: '댓글을 입력하세요...',
                                          border: OutlineInputBorder(),
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.send),
                                      onPressed: isButtonEnabled ? () async {
                                        try{
                                          final model = CommentRequestModel(postId: postid, comcontent: commentController.text.trim());
                                          final result = BoardService.registerComment(model);

                                          if(result != null) {
                                            // Navigator.of(context).pushReplacement(
                                            //   MaterialPageRoute(
                                            //     builder: (context) => AllReviewScreen(),
                                            //   ),
                                            // );
                                            Navigator.pop(context);
                                            showCustomSnackBar(context, "댓글 작성에 성공하였습니다.");
                                          }
                                          else{
                                            showCustomSnackBar(context, "댓글 작성에 실패하였습니다. 잠시 후 다시 시도해주세요.");
                                          }
                                        } catch (e) {
                                          showCustomSnackBar(context, "댓글 작성에 실패하였습니다. 잠시 후 다시 시도해주세요.");
                                        }
                                      } : null,
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      }
    },
  );
  //     .then((update) {
  //   Navigator.of(context).pushReplacement(
  //     MaterialPageRoute(
  //       builder: (context) => AllReviewScreen(),
  //     ),
  //   );
  // });

}