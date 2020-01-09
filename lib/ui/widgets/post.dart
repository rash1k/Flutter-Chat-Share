import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_share/data/remotes/models/fire_store_post.dart';
import 'package:flutter_chat_share/data/remotes/models/fire_store_user.dart';

class Post extends StatefulWidget {
  final FireStorePost post;
  final FireStoreUser user;

  Post({Key key, this.post, this.user}) : super(key: key);

  @override
  _PostState createState() => _PostState();
}

class _PostState extends State<Post> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        _buildPostHeader(),
        _buildPostImage(),
        _buildPostFooter(),
      ],
    );
  }

  Widget _buildPostHeader() {
    var textStyle = TextStyle(color: Colors.black, fontWeight: FontWeight.bold);

    return ListTile(
      leading: CircleAvatar(
        backgroundImage: CachedNetworkImageProvider(widget.user.photoUrl),
      ),
      title: Text(
        widget.user.userName,
        style: textStyle,
      ),
      subtitle: Text(widget.user.location),
      trailing: IconButton(
        icon: Icon(Icons.more_vert),
        onPressed: () {},
      ),
      onTap: () => print('showing profile'),
    );
  }

  Widget _buildPostImage() {
    return GestureDetector(
      onDoubleTap: () => print('liking post'),
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[Image.network(widget.post.mediaUrl)],
      ),
    );
  }

  Widget _buildPostFooter() {
    var textStyle = TextStyle(color: Colors.black, fontWeight: FontWeight.bold);
    return Wrap(
      children: <Widget>[
        IconButton(
            icon: Icon(
              Icons.favorite_border,
              size: 28.0,
              color: Colors.pink,
            ),
            onPressed: () => print('liking post')),
        IconButton(
            icon: Icon(
              Icons.chat,
              size: 28.0,
              color: Colors.blue[900],
            ),
            onPressed: () => print('showing comments')),
        Text(
          '${widget.post.likeCount} likes',
          style: textStyle,
        ),
        Text(
          '${widget.user.userName}',
          style: textStyle,
        ),
        Expanded(child: Text(widget.post.description))
      ],
    );
  }
}
