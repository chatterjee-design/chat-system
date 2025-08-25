final List<Map<String, dynamic>> messages = [
  // --- Starting Conversation ---
  {
    "senderId": "1",
    "name": "Alice Brown",
    "avatar":
        "https://images.pexels.com/photos/3760854/pexels-photo-3760854.jpeg",
    "isOnline": true,
    "timestamp": "2025-08-21T07:55:00Z",
    "type": "text",
    "content": "Hello",
    "replied": null,
  },
  {
    "senderId": "2",
    "name": "Bob Smith",
    "avatar":
        "https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg",
    "isOnline": true,
    "timestamp": "2025-08-21T07:58:00Z",
    "type": "text",
    "content":
        "Morning Alice! Great, please share the draft. I’ll also attach the **official requirements doc** so we align.",
    "replied": {
      "name": "Alice Brown",
      "avatar":
          "https://images.pexels.com/photos/3760854/pexels-photo-3760854.jpeg",
      "type": "text",
      "content":
          "Good morning! I just finished drafting the **API integration guide** 📄. Need your review before we finalize.",
    },
  },

  // --- Documentation Exchange ---
  {
    "senderId": "1",
    "name": "Alice Brown",
    "avatar":
        "https://images.pexels.com/photos/3760854/pexels-photo-3760854.jpeg",
    "isOnline": true,
    "timestamp": "2025-08-21T08:10:00Z",
    "type": "pdf",
    "content": "assets/pdf/api_guide.pdf",
    "replied": null,
  },
  {
    "senderId": "2",
    "name": "Bob Smith",
    "avatar":
        "https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg",
    "isOnline": true,
    "timestamp": "2025-08-21T08:12:00Z",
    "type": "pdf",
    "content":
        "https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf",
    "replied": {
      "name": "Alice Brown",
      "avatar":
          "https://images.pexels.com/photos/3760854/pexels-photo-3760854.jpeg",
      "type": "pdf",
      "content": "assets/pdf/api_guide.pdf",
    },
  },

  // --- Continuous Notes ---
  {
    "senderId": "1",
    "name": "Alice Brown",
    "avatar":
        "https://images.pexels.com/photos/3760854/pexels-photo-3760854.jpeg",
    "isOnline": true,
    "timestamp": "2025-08-21T08:20:00Z",
    "type": "text",
    "content":
        "I also added a **sequence diagram** for the request flow. It should help new developers.",
    "replied": null,
  },
  {
    "senderId": "1",
    "name": "Alice Brown",
    "avatar":
        "https://images.pexels.com/photos/3760854/pexels-photo-3760854.jpeg",
    "isOnline": true,
    "timestamp": "2025-08-21T08:22:00Z",
    "type": "image",
    "content":
        "https://images.pexels.com/photos/1181675/pexels-photo-1181675.jpeg",
    "replied": null,
  },
  {
    "senderId": "2",
    "name": "Bob Smith",
    "avatar":
        "https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg",
    "isOnline": true,
    "timestamp": "2025-08-21T08:25:00Z",
    "type": "text",
    "content":
        "Nice diagram! Can we also add an example request/response payload in the guide?",
    "replied": {
      "name": "Alice Brown",
      "avatar":
          "https://images.pexels.com/photos/3760854/pexels-photo-3760854.jpeg",
      "type": "text",
      "content":
          "I also added a **sequence diagram** for the request flow. It should help new developers.",
    },
  },
  {
    "senderId": "2",
    "name": "Bob Smith",
    "avatar":
        "https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg",
    "isOnline": true,
    "timestamp": "2025-08-21T08:28:00Z",
    "type": "text",
    "content":
        "Also, remember to include the authentication section clearly. That’s a frequent support ticket issue.",
    "replied": null,
  },

  // --- Evening Messages ---
  {
    "senderId": "2",
    "name": "Bob Smith",
    "avatar":
        "https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg",
    "isOnline": true,
    "timestamp": "2025-08-21T18:30:00Z",
    "type": "text",
    "content":
        "Just reviewed the doc 📖. It’s solid, but let’s polish the **error handling** part before release.",
    "replied": null,
  },
  {
    "senderId": "1",
    "name": "Alice Brown",
    "avatar":
        "https://images.pexels.com/photos/3760854/pexels-photo-3760854.jpeg",
    "isOnline": true,
    "timestamp": "2025-08-21T18:35:00Z",
    "type": "text",
    "content":
        "Got it 👍. I’ll refine the error section and push the final draft to Confluence.\n\nHere’s a quick reference: https://www.docsapi.com/errors",
    "replied": {
      "name": "Bob Smith",
      "avatar":
          "https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg",
      "type": "text",
      "content":
          "Just reviewed the doc 📖. It’s solid, but let’s polish the **error handling** part before release.",
    },
  },

  // --- Night Messages ---
  {
    "senderId": "2",
    "name": "Bob Smith",
    "avatar":
        "https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg",
    "isOnline": true,
    "timestamp": "2025-08-21T22:10:00Z",
    "type": "text",
    "content":
        "Good work today Alice 👏. Let’s finalize tomorrow morning. I’ll prepare the checklist tonight.",
    "replied": null,
  },
  {
    "senderId": "1",
    "name": "Alice Brown",
    "avatar":
        "https://images.pexels.com/photos/3760854/pexels-photo-3760854.jpeg",
    "isOnline": true,
    "timestamp": "2024-10-21T22:15:00Z",
    "type": "text",
    "content":
        "Thanks Bob 🌙. I’ll be ready with the final version tomorrow. Have a good night!",
    "replied": {
      "name": "Bob Smith",
      "avatar":
          "https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg",
      "type": "text",
      "content":
          "Good work today Alice 👏. Let’s finalize tomorrow morning. I’ll prepare the checklist tonight.",
    },
  },
];
