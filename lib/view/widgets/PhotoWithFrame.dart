import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ahlachat/util/images.dart';
import 'package:flutter_svga/flutter_svga.dart';

class PhotoFrame extends StatelessWidget {
  String? image;
  String? Frame;

  PhotoFrame({this.image, this.Frame});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      child: Stack(
        fit: StackFit.loose,
        alignment: Alignment.center,
        children: [
          image == null || image == ''
              ? const SizedBox()
              : CircleAvatar(
                  backgroundColor: Colors.transparent,
                  radius: 29,
                  backgroundImage: CachedNetworkImageProvider(image ?? '')),
          Frame == null || Frame == ''
              ? const SizedBox()
              : SVGAEasyPlayer(resUrl: Frame ?? '', fit: BoxFit.contain),
          image == null
              ? Container(child: Image.asset(Images.Chairs))
              : const SizedBox(),
        ],
      ),
    );
  }
}

class UserFrame extends StatelessWidget {
  String? image;
  String? Frame;

  UserFrame({this.image, this.Frame});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 80,
      child: Stack(
        fit: StackFit.loose,
        alignment: Alignment.center,
        children: [
          image == null || image == ''
              ? const SizedBox()
              : CircleAvatar(
                  backgroundColor: Colors.transparent,
                  radius: 25,
                  backgroundImage: CachedNetworkImageProvider(image ?? '')),
          Frame == null || Frame == ''
              ? const SizedBox()
              : SVGAEasyPlayer(resUrl: Frame ?? '', fit: BoxFit.contain),
          image == null
              ? Container(child: Image.asset(Images.Chairs))
              : const SizedBox(),
        ],
      ),
    );
  }
}

class MainFrame extends StatelessWidget {
  String? image;
  String? Frame;

  MainFrame({this.image, this.Frame});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        image == null || image == ''
            ? const SizedBox()
            : CircleAvatar(
                backgroundColor: Colors.transparent,
                radius: 30,
                backgroundImage: CachedNetworkImageProvider(image ?? '')),
        Frame == null || Frame == ''
            ? const SizedBox()
            : SizedBox(
                height: 90,
                child: Container(
                    child: SVGAEasyPlayer(
                        resUrl: Frame ?? '', fit: BoxFit.contain))),
      ],
    );
  }
}

class PhotoFrame2 extends StatelessWidget {
  String? image;
  String? Frame;

  PhotoFrame2({this.image, this.Frame});

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.center,
        child: CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: 70,
            child: Stack(
              children: [
                image == null || image == ''
                    ? const SizedBox()
                    : Align(
                        alignment: Alignment.center,
                        child: CircleAvatar(
                            backgroundColor: Colors.transparent,
                            radius: 47,
                            backgroundImage:
                                CachedNetworkImageProvider(image ?? ''))),
                Frame == null || Frame == ''
                    ? const SizedBox()
                    : SVGAEasyPlayer(resUrl: Frame ?? '', fit: BoxFit.contain),
              ],
            )));
  }
}

class FrameUserProfile extends StatelessWidget {
  String? image;
  String? Frame;

  FrameUserProfile({this.image, this.Frame});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      width: 70,
      child: Stack(
        children: [
          image == null || image == ''
              ? const SizedBox()
              : Align(
                  alignment: Alignment.center,
                  child: CircleAvatar(
                      backgroundColor: Colors.transparent,
                      radius: 25,
                      backgroundImage:
                          CachedNetworkImageProvider(image ?? ''))),
          Frame == null || Frame == ''
              ? const SizedBox()
              : SVGAEasyPlayer(resUrl: Frame ?? '', fit: BoxFit.contain),
        ],
      ),
    );
  }
}

class FrameRelationsProfile extends StatelessWidget {
  String? image;
  String? Frame;

  FrameRelationsProfile({this.image, this.Frame});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      width: 80,
      child: Stack(
        children: [
          image == null || image == ''
              ? const SizedBox()
              : Align(
                  alignment: Alignment.center,
                  child: CircleAvatar(
                      backgroundColor: Colors.transparent,
                      backgroundImage:
                          CachedNetworkImageProvider(image ?? ''))),
          Frame == null || Frame == ''
              ? const SizedBox()
              : SVGAEasyPlayer(resUrl: Frame ?? '', fit: BoxFit.contain),
        ],
      ),
    );
  }
}

class LeaderboardFrame extends StatelessWidget {
  String? image;
  String? Frame;

  LeaderboardFrame({this.image, this.Frame});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 50,
        child: Stack(
          children: [
            image == null || image == ''
                ? const SizedBox()
                : Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 0),
                      child: CircleAvatar(
                          backgroundColor: Colors.transparent,
                          radius: 30,
                          backgroundImage:
                              CachedNetworkImageProvider(image ?? '')),
                    )),
            Frame == null || Frame == ''
                ? const SizedBox()
                : Image.asset(Frame ?? ''),
          ],
        ));
  }
}
