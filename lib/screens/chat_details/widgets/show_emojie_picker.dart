import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';

Future<void> showEmojiPickerBottomSheet(BuildContext context, controller) {
  return showModalBottomSheet(
    context: context,
    backgroundColor: Colors.white,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      final height = MediaQuery.of(context).size.height * 0.95;
      return SizedBox(
        height: height,
        child: ClipRRect(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),

          child: Padding(
            padding: EdgeInsets.only(bottom: 20, right: 10, left: 10),

            child: EmojiPicker(
              onEmojiSelected: (category, emoji) {
                Navigator.pop(context);
              },

              config: Config(
                viewOrderConfig: ViewOrderConfig(
                  bottom: EmojiPickerItem.categoryBar,
                  top: EmojiPickerItem.searchBar,
                  middle: EmojiPickerItem.emojiView,
                ),
                emojiViewConfig: EmojiViewConfig(
                  columns: 9,
                  emojiSizeMax: 27,
                  verticalSpacing: 5,
                  horizontalSpacing: 5,
                  backgroundColor: Colors.white,
                ),

                searchViewConfig: SearchViewConfig(
                  backgroundColor: Colors.white,
                ),
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
                      padding: EdgeInsets.symmetric(
                        // horizontal: 10,
                        vertical: 10,
                      ),
                      color: Colors.white, // background color
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: Icon(Icons.close),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: OutlinedButton.icon(
                                onPressed: showSearchView,
                                icon: Icon(
                                  Icons.search,
                                  color: Colors.blueGrey,
                                ),
                                label: Text(
                                  'Search',
                                  style: TextStyle(color: Colors.blueGrey),
                                ),
                                style: OutlinedButton.styleFrom(
                                  side: BorderSide(color: Colors.blueGrey),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  padding: EdgeInsets.symmetric(vertical: 12),
                                  backgroundColor: Colors.white,
                                ),
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
              textEditingController: controller,
            ),
          ),
        ),
      );
    },
  );
}
