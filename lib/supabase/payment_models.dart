/// Represents a subscription plan available for purchase
class SubscriptionPlan {
  final String id;
  final String name;
  final String description;
  final double price;
  final String currency;
  final String interval; // 'month' or 'year'
  final List<String> features;
  final String stripePriceId; // Stripe Price ID from dashboard

  const SubscriptionPlan({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.currency,
    required this.interval,
    required this.features,
    required this.stripePriceId,
  });

  factory SubscriptionPlan.fromJson(Map<String, dynamic> json) {
    return SubscriptionPlan(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      currency: json['currency'] as String,
      interval: json['interval'] as String,
      features: List<String>.from(json['features'] as List),
      stripePriceId: json['stripe_price_id'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'currency': currency,
      'interval': interval,
      'features': features,
      'stripe_price_id': stripePriceId,
    };
  }
}

/// Represents a user's subscription status
class UserSubscription {
  final String userId;
  final String? subscriptionId; // Stripe subscription ID
  final String? planId;
  final SubscriptionStatus status;
  final DateTime? currentPeriodStart;
  final DateTime? currentPeriodEnd;
  final bool cancelAtPeriodEnd;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const UserSubscription({
    required this.userId,
    this.subscriptionId,
    this.planId,
    required this.status,
    this.currentPeriodStart,
    this.currentPeriodEnd,
    this.cancelAtPeriodEnd = false,
    this.createdAt,
    this.updatedAt,
  });

  bool get isActive =>
      status == SubscriptionStatus.active ||
      status == SubscriptionStatus.trialing;

  bool get hasAccess {
    if (!isActive) return false;
    if (currentPeriodEnd == null) return false;
    return DateTime.now().isBefore(currentPeriodEnd!);
  }

  factory UserSubscription.fromJson(Map<String, dynamic> json) {
    return UserSubscription(
      userId: json['user_id'] as String,
      subscriptionId: json['subscription_id'] as String?,
      planId: json['plan_id'] as String?,
      status: SubscriptionStatus.fromString(json['status'] as String),
      currentPeriodStart: json['current_period_start'] != null
          ? DateTime.parse(json['current_period_start'] as String)
          : null,
      currentPeriodEnd: json['current_period_end'] != null
          ? DateTime.parse(json['current_period_end'] as String)
          : null,
      cancelAtPeriodEnd: json['cancel_at_period_end'] as bool? ?? false,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'subscription_id': subscriptionId,
      'plan_id': planId,
      'status': status.value,
      'current_period_start': currentPeriodStart?.toIso8601String(),
      'current_period_end': currentPeriodEnd?.toIso8601String(),
      'cancel_at_period_end': cancelAtPeriodEnd,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}

/// Subscription status enum
enum SubscriptionStatus {
  active('active'),
  canceled('canceled'),
  incomplete('incomplete'),
  incompleteExpired('incomplete_expired'),
  pastDue('past_due'),
  trialing('trialing'),
  unpaid('unpaid'),
  none('none');

  final String value;
  const SubscriptionStatus(this.value);

  static SubscriptionStatus fromString(String value) {
    return SubscriptionStatus.values.firstWhere(
      (status) => status.value == value,
      orElse: () => SubscriptionStatus.none,
    );
  }
}

/// Represents a payment transaction
class PaymentTransaction {
  final String id;
  final String userId;
  final String? subscriptionId;
  final double amount;
  final String currency;
  final PaymentStatus status;
  final String? stripePaymentIntentId;
  final DateTime createdAt;

  const PaymentTransaction({
    required this.id,
    required this.userId,
    this.subscriptionId,
    required this.amount,
    required this.currency,
    required this.status,
    this.stripePaymentIntentId,
    required this.createdAt,
  });

  factory PaymentTransaction.fromJson(Map<String, dynamic> json) {
    return PaymentTransaction(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      subscriptionId: json['subscription_id'] as String?,
      amount: (json['amount'] as num).toDouble(),
      currency: json['currency'] as String,
      status: PaymentStatus.fromString(json['status'] as String),
      stripePaymentIntentId: json['stripe_payment_intent_id'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'subscription_id': subscriptionId,
      'amount': amount,
      'currency': currency,
      'status': status.value,
      'stripe_payment_intent_id': stripePaymentIntentId,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

/// Payment status enum
enum PaymentStatus {
  succeeded('succeeded'),
  pending('pending'),
  failed('failed'),
  refunded('refunded');

  final String value;
  const PaymentStatus(this.value);

  static PaymentStatus fromString(String value) {
    return PaymentStatus.values.firstWhere(
      (status) => status.value == value,
      orElse: () => PaymentStatus.pending,
    );
  }
}

/// Predefined subscription plans for Foxy Kids
class FoxySubscriptionPlans {
  static const monthly = SubscriptionPlan(
    id: 'foxy_monthly',
    name: 'Monthly Plan',
    description: 'Full access to all lessons and games',
    price: 9.99,
    currency: 'USD',
    interval: 'month',
    features: [
      'Unlimited lessons',
      'All games unlocked',
      'Progress tracking',
      'Parent dashboard',
      'No ads',
    ],
    stripePriceId: 'price_xxxxxxxxxxxxx', // Replace with actual Stripe Price ID
  );

  static const yearly = SubscriptionPlan(
    id: 'foxy_yearly',
    name: 'Yearly Plan',
    description: 'Full access with 2 months free',
    price: 99.99,
    currency: 'USD',
    interval: 'year',
    features: [
      'Unlimited lessons',
      'All games unlocked',
      'Progress tracking',
      'Parent dashboard',
      'No ads',
      'Save 17% vs monthly',
    ],
    stripePriceId: 'price_yyyyyyyyyyyyy', // Replace with actual Stripe Price ID
  );

  static List<SubscriptionPlan> get allPlans => [monthly, yearly];
}
