import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AiAssistantBottomSheet extends StatefulWidget {
  const AiAssistantBottomSheet({super.key});

  @override
  State<AiAssistantBottomSheet> createState() => _AiAssistantBottomSheetState();
}

class _AiAssistantBottomSheetState extends State<AiAssistantBottomSheet> {
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 150), () {
      if (mounted) {
        _focusNode.requestFocus();
      }
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _handleCardTap(String placeholderText) {
    HapticFeedback.selectionClick();
    // Logique d'action lors du tap
  }

  Widget _buildSuggestionCard({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 12.0),
        padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey[200]!),
          borderRadius: BorderRadius.circular(16.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 4,
              offset: const Offset(0, 2),
            )
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: const Color(0xFF4227DE)),
            const SizedBox(width: 8),
            Text(
              text,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.grey[800],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomInsets = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      padding: EdgeInsets.only(bottom: bottomInsets),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28.0)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 12.0, 20.0, 16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 24),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const Text(
                "Assistant Immo+",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: Row(
                  children: [
                    _buildSuggestionCard(
                      icon: Icons.person_search,
                      text: "Trouver un locataire",
                      onTap: () =>
                          _handleCardTap("Je cherche un locataire pour..."),
                    ),
                    _buildSuggestionCard(
                      icon: Icons.vibration,
                      text: "Estimer un bien",
                      onTap: () =>
                          _handleCardTap("J'aimerais faire l'estimation de..."),
                    ),
                    _buildSuggestionCard(
                      icon: Icons.assignment_turned_in,
                      text: "Vérifier un dossier de bail",
                      onTap: () => _handleCardTap(
                          "Je souhaite vérifier les documents d'un bail..."),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    margin: const EdgeInsets.only(right: 12, bottom: 4),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.add, color: Colors.black87),
                      onPressed: () {
                        HapticFeedback.selectionClick();
                      },
                    ),
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: Colors.transparent),
                      ),
                      child: Stack(
                        alignment: Alignment.centerRight,
                        children: [
                          TextField(
                            focusNode: _focusNode,
                            cursorColor: const Color(0xFF4227DE),
                            maxLines: 4,
                            minLines: 1,
                            textInputAction: TextInputAction.send,
                            style: const TextStyle(
                                fontSize: 16, color: Colors.black87),
                            decoration: InputDecoration(
                              hintText:
                                  "Décrivez le bien ou posez une question...",
                              hintStyle: TextStyle(
                                color: Colors.grey[500],
                                fontSize: 14,
                                height: 1.4,
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.only(
                                  left: 16, top: 12, bottom: 12, right: 60),
                            ),
                            onTap: () => HapticFeedback.selectionClick(),
                          ),
                          Positioned(
                            right: 8,
                            bottom: 8,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Colors.indigo, Colors.pinkAccent],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.pink.withOpacity(0.2),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  )
                                ],
                              ),
                              child: const Text(
                                "PRO",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 12, bottom: 2),
                    child: GestureDetector(
                      onTap: () {
                        HapticFeedback.selectionClick();
                      },
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: const BoxDecoration(
                          color: Color(0xFF1E1E1E),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.mic_rounded,
                          color: Colors.white,
                          size: 22,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
