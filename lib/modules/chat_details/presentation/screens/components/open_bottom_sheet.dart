import 'package:chat_system/provider/chat_details_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OptionsBottomSheet {
  static Future<void> show(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        final chatDetailsProvider = Provider.of<ChatDetailsProvider>(
          context,
          listen: false,
        );
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Builder(
            builder: (context) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildOption(Icons.photo, 'Photos', () {
                    Navigator.pop(context);
                    chatDetailsProvider.pickImageFromGallery();
                  }),
                  _buildOption(Icons.camera_alt, 'Camera', () {
                    Navigator.pop(context);
                    chatDetailsProvider.pickImageFromCamera();
                  }),
                  _buildOption(Icons.gif, 'GIF', () {}),
                  _buildOption(Icons.link, 'Meet link', () {}),

                  _buildOption(Icons.upload_file, 'Files', () {
                    Navigator.pop(context);
                    chatDetailsProvider.pickFileFromDrive();
                  }),
                  _buildOption(Icons.drive_folder_upload, 'Drive', () {
                    Navigator.pop(context);
                    chatDetailsProvider.pickFileFromDrive();
                  }),
                  _buildOption(Icons.text_fields, 'Format', () {
                    // TODO: Implement
                  }),
                  _buildOption(Icons.calendar_today, 'Calendar invitation', () {
                    // TODO: Implement
                  }),
                ],
              );
            },
          ),
        );
      },
    );
  }

  static Widget _buildOption(IconData icon, String title, VoidCallback onTap) {
    return ListTile(leading: Icon(icon), title: Text(title), onTap: onTap);
  }
}
