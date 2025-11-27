import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'payment_models.dart';

/// Service class to handle all payment-related operations
/// Integrates with Supabase Edge Functions and Stripe
class PaymentService {
  final SupabaseClient _supabase;

  PaymentService(this._supabase);

  /// Get the current user's subscription status
  Future<UserSubscription?> getUserSubscription() async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      final response = await _supabase
          .from('user_subscriptions')
          .select()
          .eq('user_id', userId)
          .maybeSingle();

      if (response == null) {
        return null;
      }

      return UserSubscription.fromJson(response);
    } catch (e) {
      debugPrint('Error fetching user subscription: $e');
      rethrow;
    }
  }

  /// Check if the current user has an active subscription
  Future<bool> hasActiveSubscription() async {
    try {
      final subscription = await getUserSubscription();
      return subscription?.hasAccess ?? false;
    } catch (e) {
      debugPrint('Error checking subscription status: $e');
      return false;
    }
  }

  /// Create a Stripe checkout session and return the checkout URL
  /// This calls a Supabase Edge Function that creates the session server-side
  Future<String> createCheckoutSession({
    required SubscriptionPlan plan,
    String? successUrl,
    String? cancelUrl,
  }) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      // Call Supabase Edge Function to create checkout session
      final response = await _supabase.functions.invoke(
        'create-checkout-session',
        body: {
          'price_id': plan.stripePriceId,
          'user_id': userId,
          'success_url': successUrl ?? 'foxykids://payment-success',
          'cancel_url': cancelUrl ?? 'foxykids://payment-cancel',
        },
      );

      if (response.status != 200) {
        throw Exception('Failed to create checkout session: ${response.data}');
      }

      final data = response.data as Map<String, dynamic>;
      final checkoutUrl = data['url'] as String?;

      if (checkoutUrl == null) {
        throw Exception('No checkout URL returned');
      }

      return checkoutUrl;
    } catch (e) {
      debugPrint('Error creating checkout session: $e');
      rethrow;
    }
  }

  /// Create a customer portal session for managing subscriptions
  /// Allows users to update payment methods, cancel subscriptions, etc.
  Future<String> createCustomerPortalSession({
    String? returnUrl,
  }) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      final response = await _supabase.functions.invoke(
        'create-portal-session',
        body: {
          'user_id': userId,
          'return_url': returnUrl ?? 'foxykids://settings',
        },
      );

      if (response.status != 200) {
        throw Exception('Failed to create portal session: ${response.data}');
      }

      final data = response.data as Map<String, dynamic>;
      final portalUrl = data['url'] as String?;

      if (portalUrl == null) {
        throw Exception('No portal URL returned');
      }

      return portalUrl;
    } catch (e) {
      debugPrint('Error creating portal session: $e');
      rethrow;
    }
  }

  /// Get all available subscription plans
  Future<List<SubscriptionPlan>> getSubscriptionPlans() async {
    try {
      final response = await _supabase
          .from('subscription_plans')
          .select()
          .order('price', ascending: true);

      return (response as List)
          .map((json) => SubscriptionPlan.fromJson(json))
          .toList();
    } catch (e) {
      debugPrint('Error fetching subscription plans: $e');
      // Return hardcoded plans as fallback
      return FoxySubscriptionPlans.allPlans;
    }
  }

  /// Get payment history for the current user
  Future<List<PaymentTransaction>> getPaymentHistory() async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      final response = await _supabase
          .from('payment_history')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      return (response as List)
          .map((json) => PaymentTransaction.fromJson(json))
          .toList();
    } catch (e) {
      debugPrint('Error fetching payment history: $e');
      rethrow;
    }
  }

  /// Listen to subscription changes in real-time
  /// Returns a stream that emits whenever the user's subscription changes
  Stream<UserSubscription?> subscriptionStream() {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) {
      return Stream.value(null);
    }

    return _supabase
        .from('user_subscriptions')
        .stream(primaryKey: ['user_id'])
        .eq('user_id', userId)
        .map((data) {
          if (data.isEmpty) return null;
          return UserSubscription.fromJson(data.first);
        });
  }

  /// Cancel subscription at the end of the current billing period
  Future<void> cancelSubscription() async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      final response = await _supabase.functions.invoke(
        'cancel-subscription',
        body: {'user_id': userId},
      );

      if (response.status != 200) {
        throw Exception('Failed to cancel subscription: ${response.data}');
      }
    } catch (e) {
      debugPrint('Error canceling subscription: $e');
      rethrow;
    }
  }

  /// Reactivate a canceled subscription
  Future<void> reactivateSubscription() async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      final response = await _supabase.functions.invoke(
        'reactivate-subscription',
        body: {'user_id': userId},
      );

      if (response.status != 200) {
        throw Exception('Failed to reactivate subscription: ${response.data}');
      }
    } catch (e) {
      debugPrint('Error reactivating subscription: $e');
      rethrow;
    }
  }
}
