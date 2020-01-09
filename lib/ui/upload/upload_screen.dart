import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_share/ui/upload/bloc.dart';
import 'package:flutter_chat_share/ui/widgets/progress_indicators.dart';
import 'package:flutter_svg/flutter_svg.dart';

class UploadScreen extends StatefulWidget {
  @override
  _UploadScreenState createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  TextEditingController _locationController = TextEditingController();
  TextEditingController _captionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UploadBloc, UploadState>(
      builder: (context, UploadState state) {
        return _buildUploadForm(state);
      },
    );
  }

  Widget _buildSplashScreen() {
    return Container(
      color: Theme.of(context).accentColor.withOpacity(.6),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SvgPicture.asset('assets/images/upload.svg', height: 260),
          SizedBox(height: 20),
          RaisedButton(
            shape: StadiumBorder(),
            color: Colors.deepOrange,
            child: Text('Upload Image',
                style: TextStyle(color: Colors.white, fontSize: 22)),
            onPressed: () => _showSelectImageDialog(context),
          ),
        ],
      ),
    );
  }

  //--------------------------Upload Form--------------------------------------
  //region
  Widget _buildUploadForm(UploadState state) {
    return Scaffold(
      appBar: _buildAppBar(state),
      body: Container(
        margin: EdgeInsets.all(16),
        child: _buildBody(state),
      ),
    );
  }

  AppBar _buildAppBar(UploadState state) {
    return AppBar(
      backgroundColor: Colors.white70,
      title: Text('Caption Post'),
      actions: <Widget>[
        FlatButton(
            onPressed: state.isSubmitUpload ? handleSubmitUpload : null,
            child: Text('Post',
                style: TextStyle(
                    color:
                        state.isSubmitUpload ? Colors.blueAccent : Colors.grey,
                    fontWeight: FontWeight.bold,
                    fontSize: 20))),
      ],
    );
  }

  Widget _buildBody(UploadState state) {
    return ListView(
      children: <Widget>[
        if (state.progressUpload >= 0 && state.progressUpload < 100)
          buildLinearProgress(state.progressUpload),
        _buildPickImage(state),
        SizedBox(height: 16),
        _buildCaptionField(state),
        Divider(),
        _buildLocationField(),
        _buildMyLocationButton(),
      ],
    );
  }

  ListTile _buildCaptionField(UploadState state) {
    return ListTile(
      leading: CircleAvatar(
          backgroundImage: state.fireStoreUserPhotoUrl != null
              ? CachedNetworkImageProvider(state.fireStoreUserPhotoUrl)
              : null),
      title: TextField(
        controller: _captionController,
        decoration: InputDecoration(
            hintText: 'Write a caption...', border: InputBorder.none),
      ),
    );
  }

  Widget _buildPickImage(UploadState state) {
    Widget child;
    if (state.pickImageFile != null) {
      child = Image.file(
        state.pickImageFile,
        width: MediaQuery.of(context).size.width * .8,
        height: 200,
      );
    } else {
      child = SvgPicture.asset(
        'assets/images/upload.svg',
        height: 200,
      );
    }

    return GestureDetector(
        child: child, onTap: () => _showSelectImageDialog(context));
  }

  ListTile _buildLocationField() {
    return ListTile(
      leading: Icon(Icons.pin_drop, color: Colors.orange, size: 35),
      title: TextField(
        controller: _locationController,
        decoration: InputDecoration(
            hintText: 'where was this photo  taken?', border: InputBorder.none),
      ),
    );
  }

  Widget _buildMyLocationButton() {
    return RaisedButton.icon(
      onPressed: () {},
      icon: Icon(Icons.my_location, color: Colors.white),
      label:
          Text('Use Current Location', style: TextStyle(color: Colors.white)),
      shape: StadiumBorder(),
      color: Colors.blue,
    );
  }

//--------------------------------Utils-----------------------------------------

  Future<void> handleSubmitUpload() async {
    BlocProvider.of<UploadBloc>(context).add(UploadPhotoEvent(
      _locationController.text ?? "",
      _captionController.text ?? "",
    ));

    _captionController.clear();
    _locationController.clear();
  }

//endregion

  //---------------------------Select image-------------------------------------
  Future<void> _showSelectImageDialog(BuildContext parentContext) {
    return showDialog(
      context: parentContext,
      builder: (_) => SimpleDialog(
        title: Text('Create Post'),
        children: <Widget>[
          SimpleDialogOption(
            child: Text('Photo with Camera'),
            onPressed: () => _getImage(chooseIsCamera: true),
          ),
          SimpleDialogOption(
            child: Text('Image from Gallery'),
            onPressed: () => _getImage(chooseIsCamera: false),
          ),
          SimpleDialogOption(
            child: Text('Cancel'),
            onPressed: () => Navigator.pop(context),
          )
        ],
      ),
    );
  }

  void _getImage({@required bool chooseIsCamera}) {
    Navigator.pop(context);
    BlocProvider.of<UploadBloc>(context).add(PickImageEvent(chooseIsCamera));
  }
}
