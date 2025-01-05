import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:step_ai/features/authentication/notifier/login_notifier.dart';

import 'package:step_ai/features/plan/domain/usecases/get_subscription_usecase.dart';
import 'package:step_ai/features/plan/presentation/notifier/subscription_notifier.dart';
import 'package:step_ai/features/plan/presentation/widgets/current_plan.dart';
import 'package:step_ai/shared/styles/horizontal_spacing.dart';
import 'package:step_ai/shared/styles/vertical_spacing.dart';
import 'package:step_ai/shared/usecases/pricing_redirect_service.dart';
import 'package:step_ai/shared/widgets/history_drawer.dart';

import '../../../../config/routes/routes.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../shared/styles/colors.dart';
import '../../../../shared/widgets/gradient_text.dart';
import '../../domain/entity/plan.dart';
import '../widgets/basic_plan.dart';
import '../widgets/pro_plan.dart';
import '../widgets/starter_plan.dart';

class PlanPricingPage extends StatefulWidget {
  const PlanPricingPage({super.key});

  @override
  State<PlanPricingPage> createState() => _PlanPricingPageState();
}

class _PlanPricingPageState extends State<PlanPricingPage> {
  @override
  void initState() {
    super.initState();

    final notifier = Provider.of<SubscriptionNotifier>(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<SubscriptionNotifier>(context, listen: false).getPlan();
    });

    notifier.addListener(() {
      if (notifier.hasError) {
        Navigator.of(context).pushReplacementNamed(Routes.authenticate);
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final notifier = Provider.of<SubscriptionNotifier>(context, listen: false);
        notifier.removeListener(() {});
      }
    });

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SubscriptionNotifier>(
        builder: (context, subscriptionNotifier, child) {
      if (subscriptionNotifier.isLoading || subscriptionNotifier.plan == null) {
        return _buildProgressIndicator();
      }

      return _buildPlanAndPricing(context, subscriptionNotifier);
    });
  }

  Scaffold _buildPlanAndPricing(
      BuildContext context, SubscriptionNotifier notifier) {
    return Scaffold(
      onDrawerChanged: (isOpened) {
        if (isOpened) {
          FocusScope.of(context).unfocus();
        }
      },
      appBar: _buildAppBar(),
      drawer: HistoryDrawer(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Wrap(
            spacing: 20,
            runSpacing: 10,
            alignment: WrapAlignment.center,
            children: [
              Column(
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GradientText(
                        "Choose your plan",
                        style: Theme.of(context).textTheme.titleMedium,
                        gradient: LinearGradient(colors: [
                          TColor.tamarama,
                          TColor.goldenState,
                        ]),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8.0),
                    height: 100,
                    child: Text(
                        "Upgrade plan now for a seamless, user-friendly experience. Unlock the full potential of our app and enjoy convenience at your fingertips.",
                        maxLines: 3,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium),
                  ),
                ],
              ),
              CurrentPlan(plan: notifier.plan!),
              BasicPlan(isSelected: notifier.plan!.name == 'basic',),
              StarterPlan(isSelected: notifier.plan!.name == 'starter'),
              ProPlan(isSelected: notifier.plan!.name == 'pro'),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 20,
              ),
              Column(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: const Text(
                      "* Our subscription plan is designed with flexibility and transparency in mind. While it offers unlimited usage, we acknowledge the possibility of adjustments in the future to meet evolving needs. Rest assured, any such changes will be communicated well in advance, providing our customers with the information they need to make informed decisions. Additionally, we understand that adjustments may not align with everyone's expectations, which is why we've implemented a generous refund program. Subscribers can terminate their subscription within 7 days of the announced adjustments and receive a refund if they so choose. Moreover, our commitment to customer satisfaction is further emphasized by allowing subscribers the freedom to cancel their subscription at any time, providing ultimate flexibility in managing their subscription preferences.",
                      maxLines: 20,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  VSpacing.sm,
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: const Text(
                      "* By subscribing, you are enrolling in automatic payments. Cancel or manage your subscription through Stripe's customer portal from \"Dashboard\".",
                      maxLines: 5,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  VSpacing.sm,
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: const Text(
                      "* All services are delivered according to the Terms of Service you confirm with your sign-up.",
                      maxLines: 5,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      centerTitle: true,
      leading: Builder(
        builder: (context) {
          return IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () async {
              if (context.mounted) {
                Scaffold.of(context).openDrawer();
              }
            },
          );
        },
      ),
      title: const Text(
        "Plan & Pricing",
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Scaffold(
      backgroundColor: TColor.doctorWhite,
      body: Center(
        child: SizedBox(
          width: 200,
          child: Center(
            child: LoadingAnimationWidget.twistingDots(
              size: 50,
              leftDotColor: TColor.tamarama,
              rightDotColor: TColor.daJuice,
            ),
          ),
        ),
      ),
    );
  }
}


