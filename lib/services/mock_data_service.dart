import '../models/user.dart';
import '../models/influencer_profile.dart';
import '../models/company_profile.dart';
import '../models/campaign.dart';
import '../models/application.dart';
import '../models/chat.dart';
import '../models/payment.dart';
import '../models/review.dart';

class MockDataService {
  
  // Users
  static final List<User> users = [
    User(
      id: '1',
      name: 'Sofia Martinez',
      email: 'sofia@example.com',
      avatar: 'https://images.unsplash.com/photo-1494790108755-2616b612b786?w=150&h=150&fit=crop&crop=face',
      location: 'Madrid, España',
      role: UserRole.influencer,
      verified: true,
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
    ),
    User(
      id: '2',
      name: 'Carlos Rodriguez',
      email: 'carlos@example.com',
      avatar: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop&crop=face',
      location: 'Barcelona, España',
      role: UserRole.influencer,
      verified: true,
      createdAt: DateTime.now().subtract(const Duration(days: 25)),
    ),
    User(
      id: '3',
      name: 'Ana Garcia',
      email: 'ana@example.com',
      avatar: 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=150&h=150&fit=crop&crop=face',
      location: 'Valencia, España',
      role: UserRole.influencer,
      verified: false,
      createdAt: DateTime.now().subtract(const Duration(days: 20)),
    ),
    User(
      id: '4',
      name: 'TechStart Inc.',
      email: 'contact@techstart.com',
      avatar: 'https://images.unsplash.com/photo-1560472354-b33ff0c44a43?w=150&h=150&fit=crop&crop=face',
      location: 'Madrid, España',
      role: UserRole.company,
      verified: true,
      createdAt: DateTime.now().subtract(const Duration(days: 60)),
    ),
    User(
      id: '5',
      name: 'Fashion Forward',
      email: 'hello@fashionforward.com',
      avatar: 'https://images.unsplash.com/photo-1556742049-0cfed4f6a45d?w=150&h=150&fit=crop&crop=face',
      location: 'Barcelona, España',
      role: UserRole.company,
      verified: true,
      createdAt: DateTime.now().subtract(const Duration(days: 45)),
    ),
    User(
      id: '6',
      name: 'Admin User',
      email: 'admin@example.com',
      location: 'Madrid, España',
      role: UserRole.admin,
      verified: true,
      createdAt: DateTime.now().subtract(const Duration(days: 90)),
    ),
  ];

  // Influencer Profiles
  static final List<InfluencerProfile> influencerProfiles = [
    InfluencerProfile(
      userId: '1',
      bio: 'Food blogger y chef amateur. Comparto recetas saludables y deliciosas en mis redes sociales.',
      handles: [
        PlatformHandle(platform: 'Instagram', username: '@sofia_cocina', followers: 45000, url: 'https://instagram.com/sofia_cocina'),
        PlatformHandle(platform: 'TikTok', username: '@sofia_cocina', followers: 32000, url: 'https://tiktok.com/@sofia_cocina'),
        PlatformHandle(platform: 'YouTube', username: 'Sofia Cocina', followers: 15000, url: 'https://youtube.com/c/SofiaCocina'),
      ],
      niches: ['Comida', 'Salud', 'Lifestyle'],
      languages: ['Español', 'Inglés'],
      pricing: [
        Pricing(type: 'Post', priceFrom: 500, priceTo: 800),
        Pricing(type: 'Story', priceFrom: 200, priceTo: 300),
        Pricing(type: 'Reel', priceFrom: 800, priceTo: 1200),
        Pricing(type: 'Video', priceFrom: 1500, priceTo: 2500),
      ],
      metrics: Metrics(
        engagementRate: 4.2,
        avgViews: 25000,
        topCountries: ['España', 'México', 'Argentina'],
        topAges: ['25-34', '18-24', '35-44'],
        postsPerWeek: 5,
      ),
      portfolio: [
        PortfolioItem(title: 'Receta de Pasta Carbonara', url: 'https://instagram.com/p/example1', platform: 'Instagram'),
        PortfolioItem(title: 'Tutorial de Pan Casero', url: 'https://tiktok.com/@sofia_cocina/video/123', platform: 'TikTok'),
        PortfolioItem(title: '10 Desayunos Saludables', url: 'https://youtube.com/watch?v=example', platform: 'YouTube'),
      ],
    ),
    InfluencerProfile(
      userId: '2',
      bio: 'Fitness coach y motivador. Te ayudo a alcanzar tus objetivos de forma saludable y sostenible.',
      handles: [
        PlatformHandle(platform: 'Instagram', username: '@carlos_fitness', followers: 78000, url: 'https://instagram.com/carlos_fitness'),
        PlatformHandle(platform: 'TikTok', username: '@carlos_fitness', followers: 95000, url: 'https://tiktok.com/@carlos_fitness'),
        PlatformHandle(platform: 'YouTube', username: 'Carlos Fitness', followers: 42000, url: 'https://youtube.com/c/CarlosFitness'),
      ],
      niches: ['Fitness', 'Salud', 'Motivación'],
      languages: ['Español', 'Inglés'],
      pricing: [
        Pricing(type: 'Post', priceFrom: 800, priceTo: 1200),
        Pricing(type: 'Story', priceFrom: 300, priceTo: 500),
        Pricing(type: 'Reel', priceFrom: 1200, priceTo: 1800),
        Pricing(type: 'Video', priceFrom: 2000, priceTo: 3500),
      ],
      metrics: Metrics(
        engagementRate: 5.8,
        avgViews: 45000,
        topCountries: ['España', 'Colombia', 'Venezuela'],
        topAges: ['18-24', '25-34', '35-44'],
        postsPerWeek: 6,
      ),
      portfolio: [
        PortfolioItem(title: 'Rutina de 30 min', url: 'https://instagram.com/p/example2', platform: 'Instagram'),
        PortfolioItem(title: 'Desafío de 7 días', url: 'https://tiktok.com/@carlos_fitness/video/456', platform: 'TikTok'),
        PortfolioItem(title: 'Guía de Nutrición', url: 'https://youtube.com/watch?v=example2', platform: 'YouTube'),
      ],
    ),
    InfluencerProfile(
      userId: '3',
      bio: 'Fashionista y lifestyle blogger. Comparto mi estilo personal y las últimas tendencias de moda.',
      handles: [
        PlatformHandle(platform: 'Instagram', username: '@ana_fashion', followers: 25000, url: 'https://instagram.com/ana_fashion'),
        PlatformHandle(platform: 'TikTok', username: '@ana_fashion', followers: 18000, url: 'https://tiktok.com/@ana_fashion'),
      ],
      niches: ['Moda', 'Lifestyle', 'Beauty'],
      languages: ['Español'],
      pricing: [
        Pricing(type: 'Post', priceFrom: 300, priceTo: 500),
        Pricing(type: 'Story', priceFrom: 150, priceTo: 250),
        Pricing(type: 'Reel', priceFrom: 500, priceTo: 800),
      ],
      metrics: Metrics(
        engagementRate: 3.5,
        avgViews: 15000,
        topCountries: ['España', 'México'],
        topAges: ['18-24', '25-34'],
        postsPerWeek: 4,
      ),
      portfolio: [
        PortfolioItem(title: 'Outfit del día', url: 'https://instagram.com/p/example3', platform: 'Instagram'),
        PortfolioItem(title: 'Tutorial de maquillaje', url: 'https://tiktok.com/@ana_fashion/video/789', platform: 'TikTok'),
      ],
    ),
  ];

  // Company Profiles
  static final List<CompanyProfile> companyProfiles = [
    CompanyProfile(
      userId: '4',
      companyName: 'TechStart Inc.',
      website: 'https://techstart.com',
      industry: 'Tecnología',
      verified: true,
    ),
    CompanyProfile(
      userId: '5',
      companyName: 'Fashion Forward',
      website: 'https://fashionforward.com',
      industry: 'Moda',
      verified: true,
    ),
  ];

  // Campaigns
  static final List<Campaign> campaigns = [
    Campaign(
      id: '1',
      companyId: '4',
      title: 'Lanzamiento App de Fitness',
      description: 'Buscamos influencers del sector fitness para promocionar nuestra nueva app de entrenamientos personalizados.',
      category: 'Fitness',
      deliverables: [
        Deliverable(
          type: 'Post',
          quantity: 3,
          guidelines: 'Mostrar la app en uso durante un entrenamiento real',
          hashtags: ['#TechStartFitness', '#AppFitness', '#EntrenamientoPersonalizado'],
          mentions: ['@techstart'],
        ),
        Deliverable(
          type: 'Story',
          quantity: 5,
          guidelines: 'Tutoriales rápidos de ejercicios usando la app',
          hashtags: ['#TechStartFitness', '#TutorialFitness'],
          mentions: ['@techstart'],
        ),
      ],
      audience: Audience(
        countries: ['España', 'México', 'Argentina'],
        cities: ['Madrid', 'Barcelona', 'Valencia'],
        ageRanges: ['18-24', '25-34', '35-44'],
        interests: ['Fitness', 'Salud', 'Tecnología'],
      ),
      budget: Budget(min: 2000, max: 5000, currency: 'EUR'),
      deadline: DateTime.now().add(const Duration(days: 30)),
      status: CampaignStatus.open,
      visibility: CampaignVisibility.public,
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
    ),
    Campaign(
      id: '2',
      companyId: '5',
      title: 'Colección Primavera 2024',
      description: 'Campaña para promocionar nuestra nueva colección de ropa de primavera con enfoque en sostenibilidad.',
      category: 'Moda',
      deliverables: [
        Deliverable(
          type: 'Post',
          quantity: 2,
          guidelines: 'Outfit completo de la colección en diferentes ocasiones',
          hashtags: ['#FashionForward', '#Primavera2024', '#ModaSostenible'],
          mentions: ['@fashionforward'],
        ),
        Deliverable(
          type: 'Reel',
          quantity: 1,
          guidelines: 'Transformación de look con piezas de la colección',
          hashtags: ['#FashionForward', '#ReelModa', '#Transformación'],
          mentions: ['@fashionforward'],
        ),
      ],
      audience: Audience(
        countries: ['España', 'México'],
        cities: ['Madrid', 'Barcelona', 'Valencia', 'México DF'],
        ageRanges: ['18-24', '25-34'],
        interests: ['Moda', 'Sostenibilidad', 'Lifestyle'],
      ),
      budget: Budget(fixed: 3000, currency: 'EUR'),
      deadline: DateTime.now().add(const Duration(days: 45)),
      status: CampaignStatus.open,
      visibility: CampaignVisibility.public,
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
    ),
  ];

  // Applications
  static final List<Application> applications = [
    Application(
      id: '1',
      campaignId: '1',
      influencerId: '2',
      proposalAmount: 3500,
      message: 'Hola! Me encanta la propuesta de vuestra app. Tengo mucha experiencia creando contenido fitness y creo que puedo aportar valor mostrando ejercicios reales con la app.',
      status: ApplicationStatus.submitted,
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
    Application(
      id: '2',
      campaignId: '1',
      influencerId: '1',
      proposalAmount: 2800,
      message: 'Soy chef pero también me apasiona el fitness. Podría crear contenido único combinando nutrición saludable con vuestra app de entrenamientos.',
      status: ApplicationStatus.submitted,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ];

  // Chat Threads
  static final List<ChatThread> chatThreads = [
    ChatThread(
      id: '1',
      campaignId: '1',
      companyId: '4',
      influencerId: '2',
      lastMessageAt: DateTime.now().subtract(const Duration(hours: 2)),
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
  ];

  // Messages
  static final List<Message> messages = [
    Message(
      id: '1',
      threadId: '1',
      senderId: '2',
      text: 'Hola! Gracias por considerar mi propuesta. ¿Podrían darme más detalles sobre el timeline de la campaña?',
      attachments: [],
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
    Message(
      id: '2',
      threadId: '1',
      senderId: '4',
      text: 'Hola Carlos! Perfecto, la campaña durará 4 semanas. ¿Te parece bien empezar la próxima semana?',
      attachments: [],
      createdAt: DateTime.now().subtract(const Duration(days: 1, hours: 20)),
    ),
    Message(
      id: '3',
      threadId: '1',
      senderId: '2',
      text: 'Perfecto! Sí, puedo empezar la próxima semana. ¿Necesitan algún contenido específico para el lanzamiento?',
      attachments: [],
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
    ),
  ];

  // Payments
  static final List<Payment> payments = [
    Payment(
      id: '1',
      campaignId: '1',
      companyId: '4',
      influencerId: '2',
      amount: 3500,
      status: PaymentStatus.pending,
      currency: 'EUR',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ];

  // Reviews
  static final List<Review> reviews = [
    Review(
      id: '1',
      fromUserId: '4',
      toUserId: '2',
      campaignId: '1',
      rating: 5,
      comment: 'Excelente trabajo! Carlos fue muy profesional y el contenido superó nuestras expectativas.',
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
    ),
    Review(
      id: '2',
      fromUserId: '2',
      toUserId: '4',
      campaignId: '1',
      rating: 5,
      comment: 'Muy buena comunicación y flexibilidad. La app es genial y fue un placer trabajar con TechStart.',
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
    ),
  ];

  // Helper methods
  static User? getUserById(String id) {
    try {
      return users.firstWhere((user) => user.id == id);
    } catch (e) {
      return null;
    }
  }

  static InfluencerProfile? getInfluencerProfileByUserId(String userId) {
    try {
      return influencerProfiles.firstWhere((profile) => profile.userId == userId);
    } catch (e) {
      return null;
    }
  }

  static CompanyProfile? getCompanyProfileByUserId(String userId) {
    try {
      return companyProfiles.firstWhere((profile) => profile.userId == userId);
    } catch (e) {
      return null;
    }
  }

  static List<Campaign> getCampaignsByCompanyId(String companyId) {
    return campaigns.where((campaign) => campaign.companyId == companyId).toList();
  }

  static List<Application> getApplicationsByCampaignId(String campaignId) {
    return applications.where((app) => app.campaignId == campaignId).toList();
  }

  static List<Application> getApplicationsByInfluencerId(String influencerId) {
    return applications.where((app) => app.influencerId == influencerId).toList();
  }

  static List<ChatThread> getChatThreadsByUserId(String userId) {
    return chatThreads.where((thread) => 
      thread.companyId == userId || thread.influencerId == userId
    ).toList();
  }

  static List<Message> getMessagesByThreadId(String threadId) {
    return messages.where((message) => message.threadId == threadId).toList();
  }

  static List<Review> getReviewsByUserId(String userId) {
    return reviews.where((review) => review.toUserId == userId).toList();
  }

  static double getAverageRatingByUserId(String userId) {
    final userReviews = getReviewsByUserId(userId);
    if (userReviews.isEmpty) return 0.0;
    return userReviews.map((r) => r.rating).reduce((a, b) => a + b) / userReviews.length;
  }

  // Add new data methods
  static void addApplication(Application application) {
    applications.add(application);
  }

  static void addMessage(Message message) {
    messages.add(message);
  }

  static void addPayment(Payment payment) {
    payments.add(payment);
  }

  static void addReview(Review review) {
    reviews.add(review);
  }

  static void updateApplicationStatus(String applicationId, ApplicationStatus status) {
    final index = applications.indexWhere((app) => app.id == applicationId);
    if (index != -1) {
      applications[index] = Application(
        id: applications[index].id,
        campaignId: applications[index].campaignId,
        influencerId: applications[index].influencerId,
        proposalAmount: applications[index].proposalAmount,
        message: applications[index].message,
        status: status,
        createdAt: applications[index].createdAt,
        updatedAt: DateTime.now(),
      );
    }
  }

  static void updateCampaignStatus(String campaignId, CampaignStatus status) {
    final index = campaigns.indexWhere((campaign) => campaign.id == campaignId);
    if (index != -1) {
      campaigns[index] = Campaign(
        id: campaigns[index].id,
        companyId: campaigns[index].companyId,
        title: campaigns[index].title,
        description: campaigns[index].description,
        category: campaigns[index].category,
        deliverables: campaigns[index].deliverables,
        audience: campaigns[index].audience,
        budget: campaigns[index].budget,
        deadline: campaigns[index].deadline,
        status: status,
        visibility: campaigns[index].visibility,
        createdAt: campaigns[index].createdAt,
        updatedAt: DateTime.now(),
      );
    }
  }
}
