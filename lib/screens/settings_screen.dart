import 'package:flutter/material.dart';
import '../services/game_storage.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late bool _sound;
  late bool _music;
  late bool _vibration;

  @override
  void initState() {
    super.initState();
    _sound     = GameStorage.isSoundEnabled();
    _music     = GameStorage.isMusicEnabled();
    _vibration = GameStorage.isVibrationEnabled();
  }

  Future<void> _confirmReset() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF2D1B4E),
        title: const Text('Reset Progress?',
            style: TextStyle(color: Colors.white)),
        content: const Text(
          'This will erase all level progress, stars, and coins. This cannot be undone.',
          style: TextStyle(color: Color(0xFFB39DDB)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel',
                style: TextStyle(color: Colors.white54)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFDC2626)),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Reset'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await GameStorage.resetAll();
      await GameStorage.init();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Progress reset successfully.'),
            backgroundColor: Color(0xFF064E3B),
          ),
        );
        setState(() {
          _sound     = GameStorage.isSoundEnabled();
          _music     = GameStorage.isMusicEnabled();
          _vibration = GameStorage.isVibrationEnabled();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1B0A3A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1B0A3A),
        foregroundColor: Colors.white,
        title: const Text('Settings',
            style: TextStyle(fontWeight: FontWeight.w700)),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // ── Audio section ─────────────────────────
          _sectionLabel('Audio'),
          _toggle(
            icon: Icons.volume_up_rounded,
            label: 'Sound Effects',
            value: _sound,
            onChanged: (v) async {
              await GameStorage.setSoundEnabled(v);
              setState(() => _sound = v);
            },
          ),
          _toggle(
            icon: Icons.music_note_rounded,
            label: 'Background Music',
            value: _music,
            onChanged: (v) async {
              await GameStorage.setMusicEnabled(v);
              setState(() => _music = v);
            },
          ),

          const SizedBox(height: 24),

          // ── Feedback section ──────────────────────
          _sectionLabel('Feedback'),
          _toggle(
            icon: Icons.vibration_rounded,
            label: 'Vibration',
            value: _vibration,
            onChanged: (v) async {
              await GameStorage.setVibrationEnabled(v);
              setState(() => _vibration = v);
            },
          ),

          const SizedBox(height: 24),

          // ── Legal section ─────────────────────────
          _sectionLabel('Legal'),
          _tile(
            icon: Icons.privacy_tip_rounded,
            label: 'Privacy Policy',
            onTap: () {
              // TODO: open privacy policy URL
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Privacy policy URL coming soon.')),
              );
            },
          ),

          const SizedBox(height: 24),

          // ── Danger zone ───────────────────────────
          _sectionLabel('Danger Zone'),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF7F1D1D).withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                  color: const Color(0xFFDC2626).withValues(alpha: 0.4)),
            ),
            child: ListTile(
              leading: const Icon(Icons.delete_forever_rounded,
                  color: Color(0xFFDC2626)),
              title: const Text('Reset All Progress',
                  style: TextStyle(
                      color: Color(0xFFDC2626),
                      fontWeight: FontWeight.w600)),
              subtitle: const Text('Erase all data and start over',
                  style: TextStyle(color: Colors.white38, fontSize: 12)),
              onTap: _confirmReset,
            ),
          ),

          const SizedBox(height: 32),

          // ── App version ───────────────────────────
          const Center(
            child: Text(
              'Brain Twist v1.0.0',
              style: TextStyle(color: Colors.white24, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionLabel(String label) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(
          label.toUpperCase(),
          style: const TextStyle(
            color: Color(0xFF7C3AED),
            fontSize: 11,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.5,
          ),
        ),
      );

  Widget _toggle({
    required IconData icon,
    required String label,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) =>
      Container(
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: const Color(0xFF2D1B4E),
          borderRadius: BorderRadius.circular(14),
        ),
        child: SwitchListTile(
          secondary: Icon(icon, color: const Color(0xFF7C3AED)),
          title:
              Text(label, style: const TextStyle(color: Colors.white)),
          value: value,
          onChanged: onChanged,
          activeColor: const Color(0xFF7C3AED),
        ),
      );

  Widget _tile({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) =>
      Container(
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: const Color(0xFF2D1B4E),
          borderRadius: BorderRadius.circular(14),
        ),
        child: ListTile(
          leading: Icon(icon, color: const Color(0xFF7C3AED)),
          title: Text(label,
              style: const TextStyle(color: Colors.white)),
          trailing: const Icon(Icons.chevron_right_rounded,
              color: Colors.white38),
          onTap: onTap,
        ),
      );
}
