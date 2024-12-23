import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:step_ai/features/authentication/notifier/login_notifier.dart';

import 'package:step_ai/features/plan/domain/usecases/get_subscription_usecase.dart';
import 'package:step_ai/features/plan/presentation/notifier/subscription_notifier.dart';
import 'package:step_ai/shared/styles/horizontal_spacing.dart';
import 'package:step_ai/shared/styles/vertical_spacing.dart';
import 'package:step_ai/shared/usecases/pricing_redirect_service.dart';
import 'package:step_ai/shared/widgets/history_drawer.dart';

import '../../../../config/routes/routes.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../shared/styles/colors.dart';
import '../../../../shared/widgets/gradient_text.dart';
import '../../domain/entity/plan.dart';

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
              BasicPlan(
                isSelected: notifier.plan!.name == 'basic',
              ),
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
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
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

class BasicPlan extends StatelessWidget {
  final bool isSelected;

  const BasicPlan({super.key, this.isSelected = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 350,
      height: 910,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
              offset: const Offset(-3, 3),
              color: TColor.slate.withOpacity(0.5),
              blurRadius: 5.0)
        ],
        color: TColor.doctorWhite,
        border: Border.all(color: TColor.petRock.withOpacity(0.5)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20),
        child: Stack(
          children: [
            if (isSelected)
              Positioned(
                right: 0,
                child: Transform.translate(
                  offset: const Offset(17, -5),
                  child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: TColor.finePine, width: 2),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 4.0),
                        child: Text("Current plan",
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  color: TColor.finePine,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w800,
                                  fontStyle: FontStyle.italic,
                                )),
                      )),
                ),
              ),
            Column(
              children: [
                VSpacing.sm,
                Text(
                  "Basic",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                VSpacing.sm,
                const Text(""),
                VSpacing.sm,
                Text("Free", style: Theme.of(context).textTheme.titleMedium),
                VSpacing.sm,
                const Text(""),
                VSpacing.sm,
                const Text(""),
                VSpacing.sm,
                Divider(
                  color: TColor.petRock.withOpacity(0.5),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Basic features",
                      style: Theme.of(context).textTheme.bodyLarge),
                ),
                VSpacing.sm,
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.check_circle_outline_rounded,
                        color: TColor.finePine),
                    HSpacing.sm,
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("AI Models",
                            style: Theme.of(context).textTheme.titleSmall),
                        const SizedBox(
                            width: 250,
                            child: Text(
                              "GPT-3.5 & GPT-4.0/Turbo & Gemini Pro & Gemini Ultra",
                              maxLines: 3,
                            )),
                      ],
                    ),
                  ],
                ),
                VSpacing.sm,
                Row(
                  children: [
                    Icon(Icons.check_circle_outline_rounded,
                        color: TColor.finePine),
                    HSpacing.sm,
                    Text("AI Action Injection",
                        style: Theme.of(context).textTheme.titleSmall),
                  ],
                ),
                VSpacing.sm,
                Row(
                  children: [
                    Icon(Icons.check_circle_outline_rounded,
                        color: TColor.finePine),
                    HSpacing.sm,
                    Text("Select Text for AI Action",
                        style: Theme.of(context).textTheme.titleSmall),
                  ],
                ),
                VSpacing.sm,
                Text("", style: Theme.of(context).textTheme.titleSmall),
                Divider(
                  color: TColor.petRock.withOpacity(0.5),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Limited queries per day",
                      style: Theme.of(context).textTheme.bodyLarge),
                ),
                VSpacing.sm,
                Row(
                  children: [
                    Icon(
                      Icons.check_circle_outline_rounded,
                      color: TColor.finePine,
                    ),
                    HSpacing.sm,
                    Text("50 free queries per day",
                        style: Theme.of(context).textTheme.titleSmall),
                  ],
                ),
                Divider(
                  color: TColor.petRock.withOpacity(0.5),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Advanced features",
                      style: Theme.of(context).textTheme.bodyLarge),
                ),
                VSpacing.sm,
                Row(
                  children: [
                    Icon(Icons.check_circle_outline_rounded,
                        color: TColor.finePine),
                    HSpacing.sm,
                    Text("AI Reading Assistant",
                        style: Theme.of(context).textTheme.titleSmall),
                  ],
                ),
                VSpacing.sm,
                Row(
                  children: [
                    Icon(Icons.check_circle_outline_rounded,
                        color: TColor.finePine),
                    HSpacing.sm,
                    Text("Real-time Web Access",
                        style: Theme.of(context).textTheme.titleSmall),
                  ],
                ),
                VSpacing.sm,
                Row(
                  children: [
                    Icon(Icons.check_circle_outline_rounded,
                        color: TColor.finePine),
                    HSpacing.sm,
                    Text("AI Writing Assistant",
                        style: Theme.of(context).textTheme.titleSmall),
                  ],
                ),
                VSpacing.sm,
                Row(
                  children: [
                    Text("", style: Theme.of(context).textTheme.titleSmall),
                  ],
                ),
                VSpacing.sm,
                Row(
                  children: [
                    Text("", style: Theme.of(context).textTheme.titleSmall),
                  ],
                ),
                VSpacing.sm,
                Text.rich(
                  TextSpan(
                    text: "",
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall
                        ?.copyWith(color: TColor.petRock.withOpacity(0.8)),
                    children: [
                      TextSpan(
                          text: "",
                          style:
                              Theme.of(context).textTheme.titleSmall!.copyWith(
                                    fontWeight: FontWeight.w700,
                                  )),
                      const TextSpan(text: ""),
                    ],
                  ),
                ),
                Divider(
                  color: TColor.petRock.withOpacity(0.5),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Other benefits",
                      style: Theme.of(context).textTheme.bodyLarge),
                ),
                VSpacing.sm,
                Row(
                  children: [
                    Icon(Icons.check_circle_outline_rounded,
                        color: TColor.finePine),
                    HSpacing.sm,
                    SizedBox(
                      width: 270,
                      child: Text("Lower response speed during high-traffic",
                          maxLines: 2,
                          style: Theme.of(context).textTheme.titleSmall),
                    ),
                  ],
                ),
                VSpacing.sm,
                Row(
                  children: [
                    Text("", style: Theme.of(context).textTheme.titleSmall),
                  ],
                ),
                VSpacing.sm,
                Row(
                  children: [
                    Text("", style: Theme.of(context).textTheme.titleSmall),
                  ],
                ),
                VSpacing.sm,
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class StarterPlan extends StatelessWidget {
  final bool isSelected;

  const StarterPlan({super.key, this.isSelected = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 350,
      height: 910,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
              offset: const Offset(-3, 3),
              color: TColor.slate.withOpacity(0.5),
              blurRadius: 5.0)
        ],
        color: TColor.doctorWhite,
        border: Border.all(color: TColor.petRock.withOpacity(0.5)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20),
        child: Stack(
          children: [
            if (isSelected)
              Positioned(
                right: 0,
                child: Transform.translate(
                  offset: const Offset(17, -5),
                  child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: TColor.finePine, width: 2),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 4.0),
                        child: Text("Current plan",
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  color: TColor.finePine,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w800,
                                  fontStyle: FontStyle.italic,
                                )),
                      )),
                ),
              ),
            Column(
              children: [
                VSpacing.sm,
                Text("Starter", style: Theme.of(context).textTheme.titleLarge),
                VSpacing.sm,
                Text("1-month Free Trial",
                    style: Theme.of(context).textTheme.titleSmall),
                const Text("then"),
                VSpacing.sm,
                Text.rich(
                  TextSpan(
                    text: "\$9.99",
                    style: Theme.of(context).textTheme.titleMedium,
                    children: [
                      TextSpan(
                          text: "/month",
                          style: Theme.of(context).textTheme.titleSmall)
                    ],
                  ),
                ),
                VSpacing.sm,
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () async => await PricingRedirectService.call(),
                    borderRadius: BorderRadius.circular(4),
                    child: Ink(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: TColor.goldenState,
                          gradient: LinearGradient(
                              colors: [TColor.tamarama, TColor.royalBlue])),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 6.0, horizontal: 50),
                        child: Text(
                          isSelected ? "Unsubscribe" : "Choose Plan",
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(
                                  fontSize: 20,
                                  color: TColor.doctorWhite,
                                  fontWeight: FontWeight.w800),
                        ),
                      ),
                    ),
                  ),
                ),
                Divider(
                  color: TColor.petRock.withOpacity(0.5),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Basic features",
                      style: Theme.of(context).textTheme.bodyLarge),
                ),
                VSpacing.sm,
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.check_circle_outline_rounded,
                        color: TColor.finePine),
                    HSpacing.sm,
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("AI Models",
                            style: Theme.of(context).textTheme.titleSmall),
                        const SizedBox(
                            width: 250,
                            child: Text(
                              "GPT-3.5 & GPT-4.0/Turbo & Gemini Pro & Gemini Ultra",
                              maxLines: 3,
                            )),
                      ],
                    ),
                  ],
                ),
                VSpacing.sm,
                Row(
                  children: [
                    Icon(Icons.check_circle_outline_rounded,
                        color: TColor.finePine),
                    HSpacing.sm,
                    Text("AI Action Injection",
                        style: Theme.of(context).textTheme.titleSmall),
                  ],
                ),
                VSpacing.sm,
                Row(
                  children: [
                    Icon(Icons.check_circle_outline_rounded,
                        color: TColor.finePine),
                    HSpacing.sm,
                    Text("Select Text for AI Action",
                        style: Theme.of(context).textTheme.titleSmall),
                  ],
                ),
                VSpacing.sm,
                Row(
                  children: [
                    Icon(
                      Icons.check_circle_outline_rounded,
                      color: TColor.finePine,
                    ),
                    HSpacing.sm,
                    Text("No ads",
                        style: Theme.of(context).textTheme.titleSmall),
                  ],
                ),
                Divider(
                  color: TColor.petRock.withOpacity(0.5),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text("More queries per month",
                      style: Theme.of(context).textTheme.bodyLarge),
                ),
                VSpacing.sm,
                Row(
                  children: [
                    Icon(
                      Icons.check_circle_outline_rounded,
                      color: TColor.finePine,
                    ),
                    HSpacing.sm,
                    Text("Unlimited queries per month",
                        style: Theme.of(context).textTheme.titleSmall),
                  ],
                ),
                Divider(
                  color: TColor.petRock.withOpacity(0.5),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Advanced features",
                      style: Theme.of(context).textTheme.bodyLarge),
                ),
                VSpacing.sm,
                Row(
                  children: [
                    Icon(Icons.check_circle_outline_rounded,
                        color: TColor.finePine),
                    HSpacing.sm,
                    Text("AI Reading Assistant",
                        style: Theme.of(context).textTheme.titleSmall),
                  ],
                ),
                VSpacing.sm,
                Row(
                  children: [
                    Icon(Icons.check_circle_outline_rounded,
                        color: TColor.finePine),
                    HSpacing.sm,
                    Text("Real-time Web Access",
                        style: Theme.of(context).textTheme.titleSmall),
                  ],
                ),
                VSpacing.sm,
                Row(
                  children: [
                    Icon(Icons.check_circle_outline_rounded,
                        color: TColor.finePine),
                    HSpacing.sm,
                    Text("AI Writing Assistant",
                        style: Theme.of(context).textTheme.titleSmall),
                  ],
                ),
                VSpacing.sm,
                Row(
                  children: [
                    Icon(Icons.check_circle_outline_rounded,
                        color: TColor.finePine),
                    HSpacing.sm,
                    Text("Jira Copilot Assistant",
                        style: Theme.of(context).textTheme.titleSmall),
                  ],
                ),
                VSpacing.sm,
                Row(
                  children: [
                    Icon(Icons.check_circle_outline_rounded,
                        color: TColor.finePine),
                    HSpacing.sm,
                    Text("Github Copilot Assistant",
                        style: Theme.of(context).textTheme.titleSmall),
                  ],
                ),
                VSpacing.sm,
                Text.rich(
                  TextSpan(
                    text: "Maximize productivity with ",
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall
                        ?.copyWith(color: TColor.petRock.withOpacity(0.8)),
                    children: [
                      TextSpan(
                          text: "unlimited*",
                          style:
                              Theme.of(context).textTheme.titleSmall!.copyWith(
                                    fontWeight: FontWeight.w700,
                                  )),
                      const TextSpan(text: " queries"),
                    ],
                  ),
                ),
                Divider(
                  color: TColor.petRock.withOpacity(0.5),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Other benefits",
                      style: Theme.of(context).textTheme.bodyLarge),
                ),
                VSpacing.sm,
                Row(
                  children: [
                    Icon(Icons.check_circle_outline_rounded,
                        color: TColor.finePine),
                    HSpacing.sm,
                    Text("No request limits during high-traffic",
                        style: Theme.of(context).textTheme.titleSmall),
                  ],
                ),
                VSpacing.sm,
                Row(
                  children: [
                    Icon(Icons.check_circle_outline_rounded,
                        color: TColor.finePine),
                    HSpacing.sm,
                    Text("2X faster response speed",
                        style: Theme.of(context).textTheme.titleSmall),
                  ],
                ),
                VSpacing.sm,
                Row(
                  children: [
                    Icon(Icons.check_circle_outline_rounded,
                        color: TColor.finePine),
                    HSpacing.sm,
                    Text("Priority email support",
                        style: Theme.of(context).textTheme.titleSmall),
                  ],
                ),
                VSpacing.sm,
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ProPlan extends StatelessWidget {
  final bool isSelected;

  const ProPlan({super.key, this.isSelected = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 350,
      height: 910,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
              offset: const Offset(-3, 3),
              color: TColor.slate.withOpacity(0.5),
              blurRadius: 5.0)
        ],
        color: TColor.doctorWhite,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: TColor.petRock.withOpacity(0.5)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20),
        child: Stack(
          children: [
            if (isSelected)
              Positioned(
                  right: 0,
                  child: Transform.translate(
                    offset: const Offset(17, -5),
                    child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: TColor.finePine, width: 2),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 4.0),
                          child: Text("Current plan",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(
                                    color: TColor.finePine,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w800,
                                    fontStyle: FontStyle.italic,
                                  )),
                        )),
                  )),
            Column(
              children: [
                VSpacing.sm,
                Text("Pro Annually",
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                        )),
                VSpacing.sm,
                Text("1-month Free Trial",
                    style: Theme.of(context).textTheme.titleSmall),
                const Text("then"),
                VSpacing.sm,
                Text.rich(
                  TextSpan(
                    text: "\$79.99",
                    style: Theme.of(context).textTheme.titleMedium,
                    children: [
                      TextSpan(
                          text: "/year",
                          style: Theme.of(context).textTheme.titleSmall)
                    ],
                  ),
                ),
                VSpacing.sm,
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () async => await PricingRedirectService.call(),
                    borderRadius: BorderRadius.circular(4),
                    child: Ink(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: TColor.goldenState,
                          gradient: LinearGradient(
                              colors: [TColor.goldenState, Colors.deepOrange])),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 6.0, horizontal: 50),
                        child: Text(
                          isSelected ? "Unsubscribe" : "Choose Plan",
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(
                                  fontSize: 20,
                                  color: TColor.doctorWhite,
                                  fontWeight: FontWeight.w800),
                        ),
                      ),
                    ),
                  ),
                ),
                Divider(
                  color: TColor.petRock.withOpacity(0.5),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Basic features",
                      style: Theme.of(context).textTheme.bodyLarge),
                ),
                VSpacing.sm,
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.check_circle_outline_rounded,
                        color: TColor.finePine),
                    HSpacing.sm,
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("AI Models",
                            style: Theme.of(context).textTheme.titleSmall),
                        const SizedBox(
                            width: 250,
                            child: Text(
                              "GPT-3.5 & GPT-4.0/Turbo & Gemini Pro & Gemini Ultra",
                              maxLines: 3,
                            )),
                      ],
                    ),
                  ],
                ),
                VSpacing.sm,
                Row(
                  children: [
                    Icon(Icons.check_circle_outline_rounded,
                        color: TColor.finePine),
                    HSpacing.sm,
                    Text("AI Action Injection",
                        style: Theme.of(context).textTheme.titleSmall),
                  ],
                ),
                VSpacing.sm,
                Row(
                  children: [
                    Icon(Icons.check_circle_outline_rounded,
                        color: TColor.finePine),
                    HSpacing.sm,
                    Text("Select Text for AI Action",
                        style: Theme.of(context).textTheme.titleSmall),
                  ],
                ),
                VSpacing.sm,
                Row(
                  children: [
                    Icon(
                      Icons.check_circle_outline_rounded,
                      color: TColor.finePine,
                    ),
                    HSpacing.sm,
                    Text("No ads",
                        style: Theme.of(context).textTheme.titleSmall),
                  ],
                ),
                Divider(
                  color: TColor.petRock.withOpacity(0.5),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text("More queries per year",
                      style: Theme.of(context).textTheme.bodyLarge),
                ),
                VSpacing.sm,
                Row(
                  children: [
                    Icon(
                      Icons.check_circle_outline_rounded,
                      color: TColor.finePine,
                    ),
                    HSpacing.sm,
                    Text("Unlimited queries per year",
                        style: Theme.of(context).textTheme.titleSmall),
                  ],
                ),
                Divider(
                  color: TColor.petRock.withOpacity(0.5),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Advanced features",
                      style: Theme.of(context).textTheme.bodyLarge),
                ),
                VSpacing.sm,
                Row(
                  children: [
                    Icon(Icons.check_circle_outline_rounded,
                        color: TColor.finePine),
                    HSpacing.sm,
                    Text("AI Reading Assistant",
                        style: Theme.of(context).textTheme.titleSmall),
                  ],
                ),
                VSpacing.sm,
                Row(
                  children: [
                    Icon(Icons.check_circle_outline_rounded,
                        color: TColor.finePine),
                    HSpacing.sm,
                    Text("Real-time Web Access",
                        style: Theme.of(context).textTheme.titleSmall),
                  ],
                ),
                VSpacing.sm,
                Row(
                  children: [
                    Icon(Icons.check_circle_outline_rounded,
                        color: TColor.finePine),
                    HSpacing.sm,
                    Text("AI Writing Assistant",
                        style: Theme.of(context).textTheme.titleSmall),
                  ],
                ),
                VSpacing.sm,
                Row(
                  children: [
                    Icon(Icons.check_circle_outline_rounded,
                        color: TColor.finePine),
                    HSpacing.sm,
                    Text("Jira Copilot Assistant",
                        style: Theme.of(context).textTheme.titleSmall),
                  ],
                ),
                VSpacing.sm,
                Row(
                  children: [
                    Icon(Icons.check_circle_outline_rounded,
                        color: TColor.finePine),
                    HSpacing.sm,
                    Text("Github Copilot Assistant",
                        style: Theme.of(context).textTheme.titleSmall),
                  ],
                ),
                VSpacing.sm,
                Text.rich(
                  TextSpan(
                    text: "Maximize productivity with ",
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall
                        ?.copyWith(color: TColor.petRock.withOpacity(0.8)),
                    children: [
                      TextSpan(
                          text: "unlimited*",
                          style:
                              Theme.of(context).textTheme.titleSmall!.copyWith(
                                    fontWeight: FontWeight.w700,
                                  )),
                      const TextSpan(text: " queries"),
                    ],
                  ),
                ),
                Divider(
                  color: TColor.petRock.withOpacity(0.5),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Other benefits",
                      style: Theme.of(context).textTheme.bodyLarge),
                ),
                VSpacing.sm,
                Row(
                  children: [
                    Icon(Icons.check_circle_outline_rounded,
                        color: TColor.finePine),
                    HSpacing.sm,
                    Text("No request limits during high-traffic",
                        style: Theme.of(context).textTheme.titleSmall),
                  ],
                ),
                VSpacing.sm,
                Row(
                  children: [
                    Icon(Icons.check_circle_outline_rounded,
                        color: TColor.finePine),
                    HSpacing.sm,
                    Text("2X faster response speed",
                        style: Theme.of(context).textTheme.titleSmall),
                  ],
                ),
                VSpacing.sm,
                Row(
                  children: [
                    Icon(Icons.check_circle_outline_rounded,
                        color: TColor.finePine),
                    HSpacing.sm,
                    Text("Priority email support",
                        style: Theme.of(context).textTheme.titleSmall),
                  ],
                ),
                VSpacing.sm,
              ],
            ),
          ],
        ),
      ),
    );
  }
}
