import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_chat_share/data/remotes/models/fire_store_user.dart';
import 'package:flutter_svg/svg.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

import 'SearchStore.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor.withOpacity(.8),
      appBar: _buildSearchField(),
      body: StateBuilder<SearchStore>(
        models: [Injector.getAsReactive<SearchStore>()],
        builder: (context, reactiveModel) {
          if (reactiveModel.isWaiting)
            return CircularProgressIndicator();
          else if (reactiveModel.hasData)
            return _buildSearchResult(reactiveModel.state.users);
          else if (reactiveModel.hasError) return _buildNoContent();

          return _buildNoContent();
        },
      ),
    );

    /*BlocBuilder<SearchBloc, SearchBlocState>(
        builder: (_, SearchBlocState state) {
          if (state is InitialSearchBlocState || state is SearchUsersNotFound)
            return _buildNoContent();
          if (state is SearchUserProgress) return CircularProgressIndicator();
          if (state is SearchUsersState) return _buildSearchResult(state.users);

          return _buildNoContent();
        },
      ),
    );*/
  }

  AppBar _buildSearchField() {
    return AppBar(
      backgroundColor: Colors.white,
      title: TextFormField(
        controller: _controller,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'Search for a user...',
          suffixIcon: IconButton(
            icon: Icon(Icons.clear),
            onPressed: () => _controller.clear(),
          ),
        ),
        onFieldSubmitted: _handleSearch,
      ),
    );
  }

  Widget _buildNoContent() {
    final Orientation orientation = MediaQuery.of(context).orientation;

    return Container(
      child: Center(
        child: ListView(
          shrinkWrap: true,
          children: [
            SvgPicture.asset(
              'assets/images/search.svg',
              height: orientation == Orientation.portrait ? 300 : 150,
            ),
            Text(
              'Find Users',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w600,
                fontSize: 60.0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchResult(List<FireStoreUser> users) {
    return Column(
      children: [
        ListView.builder(
            shrinkWrap: true,
            itemCount: users.length,
            itemBuilder: (_, index) => _buildUserItem(users[index])),
        Divider(
          color: Colors.white,
          thickness: 1,
        ),
      ],
    );
  }

  ListTile _buildUserItem(FireStoreUser user) {
    return ListTile(
      leading: CircleAvatar(
          backgroundImage: user.photoUrl != null
              ? CachedNetworkImageProvider(user.photoUrl)
              : null),
      title: Text(
        user.displayName,
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        user.userName,
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  void _handleSearch(String value) {
    if (value.isNotEmpty) {
      final reactiveModel = Injector.getAsReactive<SearchStore>();
      reactiveModel.setState((store) => store.getUserByQuery(value));
//      BlocProvider.of<SearchBloc>(context).add(SearchUserEvent(value));
    }
  }
}
