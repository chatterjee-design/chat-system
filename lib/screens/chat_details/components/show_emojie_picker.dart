import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';

class ShowEmojiePicker extends StatefulWidget {
  const ShowEmojiePicker({super.key});

  @override
  State<ShowEmojiePicker> createState() => _ShowEmojiePickerState();
}

class _ShowEmojiePickerState extends State<ShowEmojiePicker> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,

      child: Scaffold(
        appBar: AppBar(),
        body: Container(
          height: MediaQuery.of(context).size.height * 1,
          child: EmojiPicker(
            onEmojiSelected: (category, emoji) {
              setState(() {
                _controller.text += emoji.emoji;
              });
              Navigator.pop(context);
            },
            config: Config(
              viewOrderConfig: ViewOrderConfig(
                bottom: EmojiPickerItem.categoryBar,
                top: EmojiPickerItem.searchBar,
                middle: EmojiPickerItem.emojiView,
              ),
              emojiViewConfig: EmojiViewConfig(
                emojiSizeMax: 30,
                verticalSpacing: 5,
                horizontalSpacing: 5,
                backgroundColor: Colors.white,
              ),

              searchViewConfig: SearchViewConfig(backgroundColor: Colors.white),
              categoryViewConfig: CategoryViewConfig(
                indicatorColor: Colors.teal,
                iconColorSelected: Colors.teal,
                dividerColor: Colors.transparent,
                backgroundColor: Colors.white,
              ),
              bottomActionBarConfig: BottomActionBarConfig(
                showBackspaceButton: true,
                showSearchViewButton: true,
                customBottomActionBar: (config, state, showSearchView) {
                  return Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    color: Colors.white, // background color
                    child: Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: showSearchView,
                            icon: Icon(Icons.search, color: Colors.blueGrey),
                            label: Text(
                              'Search',
                              style: TextStyle(color: Colors.blueGrey),
                            ),
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: Colors.blueGrey),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: EdgeInsets.symmetric(vertical: 12),
                              backgroundColor: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },

                backgroundColor: Colors.white,
              ),
            ),
            onBackspacePressed: () {},
            textEditingController: _controller,
          ),
        ),
      ),
    );
  }
}
