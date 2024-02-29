import 'package:flutter/material.dart';
import 'dao.dart';
import 'database.dart';
import 'model.dart';

class PostAndCommentsWidget extends StatefulWidget {
  final MyAppDatabase database;

  const PostAndCommentsWidget({Key? key, required this.database})
      : super(key: key);

  @override
  _PostAndCommentsWidgetState createState() => _PostAndCommentsWidgetState();
}

class _PostAndCommentsWidgetState extends State<PostAndCommentsWidget> {
  final TextEditingController _postController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();
  List<Post> _posts = [];
  List<Comment> _comments = [];
  int? _selectedPostId;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final posts = await widget.database.postDao.findAllPosts();
    setState(() {
      _posts = posts;
    });
  }

  Future<void> _addPost(String title) async {
    final post = Post(null, title);
    await widget.database.postDao.insertPost(post);
    await _loadData();
    if (post.id != null) {
      _loadCommentsForPost(post.id!);
    }
  }

  Future<void> _loadCommentsForPost(int postId) async {
    if (_selectedPostId == postId) {
      setState(() {
        _selectedPostId = null;
        _comments = [];
      });
    } else {
      final comments =
          await widget.database.commentDao.findCommentsForPost(postId);
      setState(() {
        _selectedPostId = postId;
        _comments = comments;
      });
    }
  }

  Future<void> _addCommentToPost(int postId, String content) async {
    final comment = Comment(null, content, postId);
    await widget.database.commentDao.insertComment(comment);
    _loadCommentsForPost(postId);
  }

  Future<void> _deletePost(int postId) async {
    await widget.database.commentDao.deleteCommentsByPostId(postId);
    await widget.database.postDao.deletePostById(postId);
    await _loadData();
    if (_posts.isNotEmpty) {
      _loadCommentsForPost(_posts.first.id!);
    }
  }

  Future<void> _deleteComment(int commentId) async {
    await widget.database.commentDao.deleteCommentsByPostId(commentId);
    if (_selectedPostId != null) {
      await _loadCommentsForPost(_selectedPostId!);
    }
  }

  Future<void> _updatePost(Post post) async {
    await widget.database.postDao.updatePost(post);
    await _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[900],
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _posts.length,
              itemBuilder: (context, index) {
                final post = _posts[index];
                return Column(
                  children: [
                    ListTile(
                      title: Text(
                        post.title,
                        style: const TextStyle(color: Colors.white),
                      ),
                      onTap: () {
                        _loadCommentsForPost(post.id!);
                      },
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              _showEditPostDialog(post);
                            },
                          ),
                          PopupMenuButton<String>(
                            onSelected: (value) async {
                              if (value == 'Delete') {
                                _deletePost(post.id!);
                              } else if (value == 'Add') {
                                final content = await _showAddCommentDialog();
                                if (content != null) {
                                  await _addCommentToPost(post.id!, content);
                                  _loadCommentsForPost(post.id!);
                                }
                              }
                            },
                            itemBuilder: (context) => [
                              PopupMenuItem(
                                value: 'Delete',
                                child: Text('Delete Post'),
                              ),
                              PopupMenuItem(
                                value: 'Add',
                                child: Text('Add Comment'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    ..._comments
                        .where((comment) => comment.postId == post.id)
                        .map((comment) {
                      return Padding(
                        padding: EdgeInsets.only(left: 30.0),
                        child: ListTile(
                          title: Text(
                            comment.content,
                            style: TextStyle(color: Colors.black),
                          ),
                          leading: Icon(Icons.comment, color: Colors.red),
                          trailing: PopupMenuButton<String>(
                            onSelected: (value) {
                              if (value == 'Delete') {
                                _deleteComment(comment.id!);
                              }
                            },
                            itemBuilder: (context) => [
                              PopupMenuItem(
                                value: 'Delete',
                                child: Text('Delete Comment'),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ],
                );
              },
            ),
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _postController,
                  decoration: InputDecoration(
                    labelText: 'Write a post',
                    labelStyle: TextStyle(
                        color: Colors.white), // Change label text color
                    contentPadding: EdgeInsets.all(10.0),
                    fillColor: Colors.grey[800], // Change fill color
                    filled: true,
                  ),
                  style: TextStyle(color: Colors.white), // Change text color
                ),
              ),
              FloatingActionButton(
                backgroundColor: Colors.blue, // Change button color
                onPressed: () {
                  _addPost(_postController.text);
                  _postController.clear();
                },
                child:
                    Icon(Icons.add, color: Colors.white), // Change icon color
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<String?> _showAddCommentDialog() async {
    return showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Comment'),
          content: TextField(
            controller: _commentController,
            decoration: InputDecoration(
              labelText: 'Write a comment',
              contentPadding: EdgeInsets.all(10.0),
            ),
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(_commentController.text);
                _commentController.clear();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showEditPostDialog(Post post) async {
  final TextEditingController _editPostController = TextEditingController(text: post.title);

  await showDialog<String>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Edit Post'),
        content: TextField(
          controller: _editPostController,
          decoration: InputDecoration(
            labelText: 'Edit your post',
          ),
        ),
        actions: [
          TextButton(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text('Save'),
            onPressed: () {
              _editPost(post, _editPostController.text);
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
  Future<void> _editPost(Post post, String newTitle) async {
    final updatedPost = Post(
        post.id, newTitle); 
    await _updatePost(updatedPost);
  }
  
}
