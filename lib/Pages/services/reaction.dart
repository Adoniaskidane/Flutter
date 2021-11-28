import 'package:bunamedia/Pages/services/db.dart';
import 'package:bunamedia/Pages/services/user.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class UserReaction{
    String user;
    CollectionReference usersinstance = FirebaseFirestore.instance.collection('Users');
    UserReaction({required this.user});

    Future<bool> ReactingMethod(String postID,String postuser,String type)async{
      final path=usersinstance.doc(postuser).collection('Post').doc(postID).collection('Reaction');
      //Check if user reacted 
      final res=await path.where('react',isEqualTo: user).get();
      
      //if the person is not reacted=>react
      if(res.docs.isEmpty){
       path.add({'react':user,'type':type});
      }
      //if the person change the reaction type
      else{
        final reacttype=res.docs[0].get('type');
        //Change here
        if(reacttype!=type){
          final id=res.docs[0].id;
          path.doc(id).update({'type':type});
        }//otherwise remove reaction
        else{
          final id=res.docs[0].id;
          path.doc(id).delete();
        }
      }
      return true;
    }

    Future<ReactionData> reactionData(String postID,String postuser)async{
    final path=usersinstance.doc(postuser).collection('Post').doc(postID).collection('Reaction');
    //check all number of reaction
    final hearted=await path.where('type',isEqualTo:'Heart').get();
    final heartBroken=await path.where('type',isEqualTo:'heartBroken').get();
    final smile=await path.where('type',isEqualTo:'smile').get();
    final thumbup=await path.where('type',isEqualTo:'thumbup').get();
    final thumbdown=await path.where('type',isEqualTo:'thumbdown').get();
    final reactionres=await path.where('react',isEqualTo: user).get();
    bool isreacted=false;
    final reacttype;
    if(reactionres.docs.isEmpty){
      isreacted=false;
      reacttype='Noreaction';
    }else{
      isreacted=true;
      reacttype=reactionres.docs[0].get('type');
    }
      final heartedsize=hearted.docs.length;
      final heartBrokensize=heartBroken.docs.length;
      final smilesize=smile.docs.length;
      final thumbupsize=thumbup.docs.length;
      final thumbdownsize=thumbdown.docs.length;
      //print('hearted $heartedsize : brokenhearted $heartBrokensize');
      return ReactionData(
        isreacted: isreacted,
        type:reacttype, 
        heartBorken:heartBrokensize, 
        hearted:heartedsize,
        smile:smilesize,
        thumbsUp:thumbupsize,
        thumbsDown:thumbdownsize,
      );
    }
}

