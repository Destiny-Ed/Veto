import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _page = 0;
  int _maxTrades = 2;
  bool _firstLoss = true;
  final List<String> _availableApps = ['MetaTrader 5', 'TradingView', 'cTrader', 'Thinkorswim'];
  final Set<String> _selected = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _controller,
                onPageChanged: (i) => setState(() => _page = i),
                children: [
                  _buildWelcome(),
                  _buildRules(),
                  _buildAppPicker(),
                  _buildAffirmation(),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                children: [
                  if (_page > 0)
                    TextButton(
                      onPressed: () => _controller.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.ease),
                      child: const Text('Back', style: TextStyle(color: Color(0xFF1E88E5))),
                    ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: _page == 3 ? _finish : () => _controller.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.ease),
                    child: Text(_page == 3 ? 'Start Veto' : 'Next'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcome() {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.gavel, size: 80, color: Color(0xFF1E88E5)),
          const SizedBox(height: 24),
          Text('Veto', style: Theme.of(context).textTheme.headlineLarge),
          const SizedBox(height: 12),
          const Text(
            'The app that vetoes overtrading.\nLock your trading apps until you follow the rules.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Color(0xFFB0B0B0), height: 1.5),
          ),
        ],
      ),
    );
  }

  Widget _buildRules() {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Your Rules', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 32),
          const Text('Max trades per day', style: TextStyle(fontSize: 16)),
          Slider(
            value: _maxTrades.toDouble(),
            min: 1,
            max: 5,
            divisions: 4,
            label: '$_maxTrades',
            activeColor: const Color(0xFF1E88E5),
            onChanged: (v) => setState(() => _maxTrades = v.round()),
          ),
          Text('$_maxTrades trades', style: const TextStyle(color: Color(0xFF1E88E5), fontWeight: FontWeight.bold)),
          const SizedBox(height: 24),
          SwitchListTile(
            title: const Text('First loss = done for the day'),
            value: _firstLoss,
            activeColor: const Color(0xFF1E88E5),
            onChanged: (v) => setState(() => _firstLoss = v),
          ),
        ],
      ),
    );
  }

  Widget _buildAppPicker() {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Select Trading Apps', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 8),
          const Text('These will be locked until you complete the morning checklist.', style: TextStyle(color: Color(0xFFB0B0B0))),
          const SizedBox(height: 24),
          Expanded(
            child: ListView(
              children: _availableApps.map((app) {
                final selected = _selected.contains(app);
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: Icon(selected ? Icons.check_circle : Icons.circle_outlined, color: selected ? const Color(0xFF1E88E5) : Colors.grey),
                    title: Text(app),
                    onTap: () {
                      setState(() {
                        if (selected) {
                          _selected.remove(app);
                        } else {
                          _selected.add(app);
                        }
                      });
                    },
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAffirmation() {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.verified, size: 64, color: Color(0xFF1E88E5)),
          const SizedBox(height: 24),
          const Text(
            'I commit to following my rules.\nAfter a loss or my max trades, Veto locks the apps.\nI will not negotiate in the moment.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, height: 1.6),
          ),
        ],
      ),
    );
  }

  void _finish() {
    context.read<AppState>().completeOnboarding(
          max: _maxTrades,
          firstLoss: _firstLoss,
          apps: _selected.toList(),
        );
  }
}
