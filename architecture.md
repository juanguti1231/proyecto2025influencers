# Influencer Marketplace MVP - Flutter Web

## Architecture Overview

**State Management:** Provider with ChangeNotifier

**Data Layer:** Mock data with in-memory storage (reset on refresh)

**Auth:** Simple role selection without real authentication (session storage)

**Images:** Image picker for web with local preview

**Routing:** Go Router for clean navigation

**UI Framework:** Material 3 with custom theme

## Project Structure

```
lib/
├── main.dart
├── models/          # Data models (User, Campaign, Application, etc.)
├── providers/       # State management (AuthProvider, CampaignProvider, etc.)
├── screens/         # All screen widgets organized by role
├── widgets/         # Reusable components (cards, filters, modals)
├── services/        # Mock data service
├── utils/           # Constants, helpers, theme
└── router.dart      # Navigation configuration
```

## Implementation Phases

### Phase 1: Foundation & Core Models

- Setup dependencies (provider, go_router, image_picker, intl, uuid)
- Define data models: User, InfluencerProfile, CompanyProfile, Campaign, Application, ChatThread, Message, Payment, Review
- Create mock data service with sample data (10+ influencers, 5+ campaigns)
- Setup Material 3 theme with modern color scheme
- Configure routing structure with role-based guards

### Phase 2: Authentication & Navigation

- Landing page with hero section, value proposition, categorías grid
- Auth screens: role selection → registration form (different fields per role)
- Simple session management (AuthProvider storing current user)
- Top bar component with logo, search, "Explorar", CTAs
- Side navigation for dashboards

### Phase 3: Public Discovery (Influencers & Campaigns)

- **Explorar Influencers:** 
  - Grid/list view with InfluencerCard
  - Lateral filter panel (ubicación, plataforma, categoría, rango audiencia, tarifa, idioma)
  - Search bar and sorting
  - Empty states with illustrations
- **Influencer Profile (public):**
  - Header with avatar, platforms, stats, badges
  - Services & pricing section
  - Mock metrics dashboard
  - Portfolio grid with image preview
  - Reviews display
  - CTA buttons (Contactar/Postular)
- **Explorar Campañas (for Influencers):**
  - Campaign cards with filtering
  - Status badges, budget display
  - Navigate to campaign detail

### Phase 4: Campaign Management (Company Side)

- **Create/Edit Campaign form:**
  - Multi-section form (básicos, entregables, audiencia, presupuesto)
  - Chip input for hashtags/interests
  - Date picker for deadline
  - Validation and preview
- **Campaign Detail:**
  - Full campaign info display
  - Applications table for company (view profiles, chat, hire buttons)
  - Application form for influencers (propuesta, mensaje)
  - Status management

### Phase 5: Dashboards

- **Company Dashboard:**
  - KPI cards (active campaigns, applications, hired, spending)
  - "Mis Campañas" table with states and quick actions
  - "Postulaciones" filtered by campaign
  - Navigation to messaging and payments
- **Influencer Dashboard:**
  - KPI cards (applications, contracts, earnings)
  - "Mis Postulaciones" table with status
  - "Campañas Guardadas" list
  - Profile completion reminder

### Phase 6: Messaging System

- Chat interface with thread list (left) and conversation (right)
- Campaign context panel
- Message persistence in provider
- Simple text messages with link support
- Read status indicators

### Phase 7: Payments & Reviews

- **Payment flow:**
  - Modal with payment summary
  - Mock payment form with card input fields (visual only)
  - "Simulate Payment" button updates campaign status to "hired"
  - Payment record in history
- **Reviews:**
  - Post-campaign review form (rating 1-5 + comment)
  - Display on influencer profiles
  - Bidirectional (company ↔ influencer)

### Phase 8: Settings & Admin

- **Settings:**
  - Profile editor with image picker (web)
  - Platform handles for influencers
  - Company info for businesses
  - Niche/interest chips
  - Password change form (mock)
- **Admin panel:**
  - User list with verify/suspend actions
  - Campaign moderation queue
  - Reports viewer

### Phase 9: Polish & Responsiveness

- Responsive breakpoints (mobile <768, tablet 768-1199, desktop ≥1200)
- Loading states and spinners
- Toast notifications (success/error)
- Empty state illustrations
- Form validation feedback
- Keyboard navigation
- Focus management

## Key Components to Build

**Cards:** InfluencerCard, CampaignCard, ApplicationCard, MessageItem, ReviewCard

**Forms:** InputField, SelectField, ChipInput, MoneyInput, RangeSlider, DatePicker, ImageUpload

**Navigation:** TopBar, SideBar, BottomNav (mobile)

**Filters:** FilterChip, FilterPanel, SortDropdown

**Modals:** ConfirmDialog, PaymentModal, ReportModal, InviteModal

**Feedback:** Toast, EmptyState, LoadingSpinner, ErrorWidget

## Critical User Flows

**A) Company hires influencer:**

Landing → Explorar Influencers → Profile → Create Campaign → Receive Applications → Review → Chat → Hire (payment) → Review

**B) Influencer applies to campaign:**

Auth (role select) → Dashboard → Explorar Campañas → Filter → Detail → Apply → Chat → Hired → Payment received → Review

**C) Onboarding:**

Landing → Register → Role selection → Complete profile (photo, niches/platforms) → Dashboard with tips

## Mock Data Requirements

- 15+ influencers across categories (food, fitness, tech, fashion, music)
- Varied follower counts (nano: 1K-10K, micro: 10K-100K)
- 8+ sample campaigns in different states
- Platform data (Instagram, TikTok, YouTube)
- Sample reviews and ratings
- Chat message history for demo

## Testing Checklist

- All 3 roles can register and access their dashboards
- Filters combine correctly and update results
- Campaign creation saves and appears in listings
- Application flow changes states correctly
- Payment simulation updates campaign to "hired"
- Messages persist during session
- Reviews display on profiles
- Navigation works on mobile/tablet/desktop
- Images can be selected and previewed
- All CTAs lead to correct destinations

## Implementation Status

✅ **Completed:**
- [x] Add dependencies to pubspec.yaml (provider, go_router, image_picker, intl, uuid) and configure Flutter web assets
- [x] Build data models for User, InfluencerProfile, CompanyProfile, Campaign, Application, ChatThread, Message, Payment, Review
- [x] Create mock data service with 15+ influencers, 8+ campaigns, sample reviews, and chat history
- [x] Setup Material 3 theme, configure go_router with role-based routes and guards
- [x] Build landing page, auth screens (role selection + registration), and AuthProvider with session management
- [x] Create reusable components: TopBar, SideBar, cards (Influencer/Campaign), filters, modals, form inputs, toasts
- [x] Build Explorar Influencers screen with filters, search, sorting, and InfluencerCard grid
- [x] Create public Influencer Profile with header, services, metrics, portfolio grid, reviews, and CTAs
- [x] Build Explorar Campañas for influencers with filtering and campaign cards
- [x] Create Campaign creation/edit form with validation and Campaign detail view with applications
- [x] Build Company Dashboard with KPIs, campaign table, applications manager, and navigation
- [x] Build Influencer Dashboard with KPIs, applications table, saved campaigns, profile completion
- [x] Implement chat interface with thread list, conversation view, campaign context, and message provider
- [x] Create payment modal with mock card form, simulate payment flow, update campaign status, payment history
- [x] Build review submission form and display on profiles (bidirectional)
- [x] Create Settings screen with profile editor (image picker for web) and basic Admin panel
- [x] Add responsive breakpoints, loading states, empty states, validation feedback, keyboard navigation
- [x] Test all 3 critical user flows (company hire, influencer apply, onboarding) on web

## Technical Stack

**Frontend:** Flutter Web
**State Management:** Provider
**Routing:** Go Router
**UI Framework:** Material 3
**Data:** Mock Data Service (in-memory)
**Authentication:** Session-based (mock)
**Images:** Image Picker for Web
**Internationalization:** Intl package
**UUID Generation:** UUID package
**Image Caching:** Cached Network Image
**SVG Support:** Flutter SVG

## Project Statistics

- **Total Files:** 156 files
- **Lines of Code:** 12,210+ lines
- **Models:** 9 data models
- **Screens:** 15+ screens
- **Widgets:** 20+ reusable components
- **Providers:** 2 state management providers
- **Routes:** 20+ navigation routes
