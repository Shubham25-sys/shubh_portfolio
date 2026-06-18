class PortfolioData {
  static const String name = 'Shubham Wani';
  static const String title = 'Associate Software Developer';
  static const List<String> roles = [
    'Flutter Developer',
    'Generative AI Engineer',
    'Mobile App Developer',
    'Agentic AI Builder',
    'Cross-Platform Engineer',
    'Full Stack Developer',
  ];

  static const String summary =
      'Associate Software Developer with 2+ years building high-performance '
      'cross-platform Flutter apps and full-stack Generative AI solutions. '
      'Delivered 3+ production apps — including an AI chatbot powered by GPT-4.5 — '
      'boosting user engagement by up to 80% through optimized architecture, '
      'agentic AI pipelines, and scalable API-driven solutions.';

  static const String email = 'shubhamwani2508@gmail.com';
  static const String phone = '+91-7743968124';
  static const String location = 'Chhatrapati Sambhajinagar, Maharashtra';
  static const String linkedin = 'https://www.linkedin.com/in/shubham-wani-641763191';
  static const String resumePath = '/resume/shubham_wani_resume.pdf';

  static const List<Map<String, dynamic>> experience = [
    {
      'title': 'Associate Software Developer',
      'company': 'BinYuga Pvt. Ltd',
      'type': 'Remote',
      'duration': 'Jun 2024 – Present',
      'current': true,
      'points': [
        'Built and deployed cross-platform Flutter apps using MVVM architecture with GitHub Copilot, published on cPanel and Google Play Store',
        'Improved performance and scalability using GetX/Provider state management, REST API integration, and Google APIs for geolocation',
        'Implemented real-time video communication with the Agora SDK and secure payments via Stripe and Razorpay',
      ],
    },
    {
      'title': 'Member of Technical Staff',
      'company': 'Synnefa Tech Pvt. Ltd',
      'type': 'Nashik',
      'duration': 'Feb 2024 – May 2024',
      'current': false,
      'points': [
        'Implemented secure Stripe payment integration for Flutter applications',
        'Developed backend services using Node.js and Express.js',
        'Enabled geolocation and navigation features through Google Maps API integration',
      ],
    },
    {
      'title': 'Flutter Developer',
      'company': 'BinYuga Pvt. Ltd',
      'type': 'Remote',
      'duration': 'Jan 2023 – Feb 2024',
      'current': false,
      'points': [
        'Improved application reliability and performance through thorough testing',
        'Delivered scalable solutions through troubleshooting and optimization',
      ],
    },
  ];

  static const List<Map<String, dynamic>> projects = [
    {
      'name': 'CognitoSphere AI',
      'duration': '2025 – Present',
      'description':
          'A full-stack Generative AI chatbot platform powered by OpenAI GPT-4.5 — delivering a ChatGPT-like experience with enterprise-grade security. Features a complete authentication system (JWT, hashed passwords, session management, remember-me), secure server-side API key handling to prevent key exposure, rate limiting, input sanitization against prompt injection, and HTTPS/SSL enforcement. Deployed live on Render with production-grade stability.',
      'tags': ['Python', 'OpenAI GPT-4.5', 'Generative AI', 'JWT Auth', 'REST API', 'Full Stack', 'Render'],
      'accentColor': 0xFFFF79C6,
      'gradientColors': [0xFFFF79C6, 0xFFBD93F9],
      'url': 'https://cognitosphere-ai.onrender.com/',
      'featured': true,
    },
    {
      'name': 'ProHealth Management',
      'duration': 'Jun 2024 – Present',
      'description':
          'A comprehensive web application for hospitals and healthcare organizations to streamline company, office, and service operations. Features document compliance management, HR and employee onboarding workflows, patient and clinician profile management with RBAC, and secure communication via chat, voice/video calls, and an Outlook-style internal mail system.',
      'tags': ['Flutter', 'Firebase', 'REST API', 'GetX', 'Agora SDK', 'RBAC', 'Chat'],
      'accentColor': 0xFF64FFDA,
      'gradientColors': [0xFF64FFDA, 0xFF00B4D8],
      'url': '',
      'featured': false,
    },
    {
      'name': 'MAINT',
      'duration': 'Aug 2025 – Nov 2025',
      'description':
          'Multi-platform maintenance service app (Android & Web) connecting users with professional service providers for on-demand repairs. Supports real-time service booking, live location tracking, in-app communication, and a robust admin panel for managing vendors, subscriptions, and service operations. Deployed on the Google Play Store with production-grade stability.',
      'tags': ['Flutter', 'Android', 'Web', 'Google Maps', 'Real-time', 'Admin Panel'],
      'accentColor': 0xFFBD93F9,
      'gradientColors': [0xFFBD93F9, 0xFF00B4D8],
      'url': '',
      'featured': false,
    },
  ];

  static const Map<String, List<String>> skills = {
    'Mobile & Framework': ['Flutter', 'Dart', 'MVVM Architecture', 'GetX', 'Provider'],
    'Generative AI & ML': ['OpenAI GPT-4.5', 'LangChain', 'Agentic AI', 'Prompt Engineering', 'RAG', 'Python'],
    'Backend & APIs': ['Node.js', 'Express.js', 'REST API', 'Firebase', 'FastAPI'],
    'Integrations': ['Agora SDK', 'Stripe', 'Razorpay', 'Google Maps API'],
    'Tools & DevOps': ['Git', 'Bitbucket', 'GitHub Copilot', 'cPanel', 'Render', 'Google Play Store'],
  };

  static const List<Map<String, String>> education = [
    {
      'degree': 'Master of Computer Application (MCA)',
      'university': 'Dr. Babasaheb Ambedkar Marathwada University',
      'location': 'Chhatrapati Sambhajinagar, Maharashtra',
      'duration': 'Jul 2021 – Aug 2023',
      'grade': 'CGPA: 8.0',
    },
  ];

  static const List<Map<String, dynamic>> certificates = [
    {
      'title': 'Full Stack Generative & Agentic AI with Python',
      'platform': 'Udemy',
      'instructors': 'Hitesh Choudhary, Piyush Garg',
      'date': 'April 7, 2026',
      'hours': '32.5 hrs',
      'certNo': 'UC-8e27d21d-b2f3-4e4a-9433-5b2f348c64e7',
      'certUrl': 'https://ude.my/UC-8e27d21d-b2f3-4e4a-9433-5b2f348c64e7',
      'pdfPath': '/certificates/agentic_ai_certificate.pdf',
      'featured': true,
      'description':
          'Comprehensive 32.5-hour course covering full-stack Generative AI and Agentic AI development with Python — from LLM fundamentals and prompt engineering to building autonomous AI agents, memory systems, and production-ready deployments.',
      'topics': [
        'LLM Fundamentals',
        'LangGraph',
        'Prompt Serialization',
        'Building AI Agents',
        'Short-term Memory',
        'Long-term Memory',
        'Semantic Memory',
        'MCP (Model Context Protocol)',
        'Docker',
        'RAG Pipelines',
      ],
      'accentColor': 0xFFFF79C6,
    },
    {
      'title': 'Machine Learning use in Flutter – The Complete 2025 Guide',
      'platform': 'Udemy',
      'instructors': 'Mobile ML Academy by Hamza Asif',
      'date': 'Sept. 21, 2025',
      'hours': '14.5 hrs',
      'certNo': 'UC-45b9682d-62e5-49f9-a556-97e126dbd36d',
      'certUrl': 'https://ude.my/UC-45b9682d-62e5-49f9-a556-97e126dbd36d',
      'pdfPath': '/certificates/ml_flutter_certificate.pdf',
      'featured': false,
      'description':
          'Comprehensive 14.5-hour Udemy course on integrating ML models directly into Flutter apps — covering on-device inference, real-time computer vision pipelines, barcode scanning, NLP translation, and production deployment on Android & iOS.',
      'topics': [
        'Image Recognition',
        'Barcode Scanning',
        'Face Detection',
        'Text Translation',
        'Object Detection',
        'On-device Inference',
        'ML Kit',
        'TensorFlow Lite',
      ],
      'accentColor': 0xFFBD93F9,
    },
  ];

  static const List<Map<String, dynamic>> stats = [
    {'value': '2+', 'label': 'Years Experience'},
    {'value': '3+', 'label': 'Production Apps'},
    {'value': '80%', 'label': 'Engagement Boost'},
    {'value': '3', 'label': 'Companies'},
  ];
}
