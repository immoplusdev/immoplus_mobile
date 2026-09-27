import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:immoplus/app/core/config/injection.dart';
import 'package:immoplus/app/data/models/remote/polls/poll_model.dart';
import 'package:immoplus/app/data/repositories/poll_repository.dart';

/// Palette du sondage — regroupée ici pour pouvoir l'ajuster en un seul
/// endroit sans chasser des couleurs éparpillées dans le widget.
class _PollColors {
  static const Color background = Colors.white;
  static const Color border = Color(0xFFEFEFEF);
  static const Color badge = Color(0xFFFF3B30);
  static const Color question = Color(0xFF111111);
  static const Color optionLabel = Color(0xFF1A1A1A);
  static const Color percentage = Color(0xFF111111);
  static const Color track = Color(0xFFF5F5F6);
  static const Color fillBase = Color(0xFF8B7CF6);
  static const Color myVoteBorder = Color(0xFF8B7CF6);
  static const Color meta = Color(0xFF9AA0A6);
}

/// Sondage embarqué dans la home (`poll_banner`). Les barres affichent
/// toujours les résultats en direct (comme un sondage Twitter/Instagram) :
/// taper une option vote pour elle si l'utilisateur n'a pas encore voté sur
/// ce sondage précis, sinon les barres restent juste informatives.
class PollBannerCard extends StatefulWidget {
  final PollModel poll;

  const PollBannerCard({super.key, required this.poll});

  @override
  State<PollBannerCard> createState() => _PollBannerCardState();
}

class _PollBannerCardState extends State<PollBannerCard> {
  late PollModel _poll = widget.poll;
  bool _isSubmitting = false;
  String? _pendingOptionId;
  late String? _myVoteOptionId = widget.poll.votedOptionId;

  @override
  void didUpdateWidget(covariant PollBannerCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.poll.pollId != widget.poll.pollId) {
      _poll = widget.poll;
      _myVoteOptionId = widget.poll.votedOptionId;
    }
  }

  bool get _isClosed =>
      _poll.status.toUpperCase() == 'CLOSED' ||
      (_poll.expiresAt != null && _poll.expiresAt!.isBefore(DateTime.now()));

  /// Tap sur une option : premier vote si pas encore voté, sinon reclic sur
  /// le choix déjà fait (bordé) = annulation, reclic sur une autre =
  /// changement de vote.
  Future<void> _handleTap(String optionId) async {
    if (_isSubmitting || _isClosed) return;

    if (!_poll.userHasVoted) {
      await _run(optionId: optionId, call: () => getIt<PollRepository>().vote(
            pollId: _poll.pollId,
            optionId: optionId,
          ));
    } else if (optionId == _myVoteOptionId) {
      await _handleCancel();
    } else {
      await _run(optionId: optionId, call: () => getIt<PollRepository>().changeVote(
            pollId: _poll.pollId,
            optionId: optionId,
          ));
    }
  }

  Future<void> _handleCancel() async {
    if (_isSubmitting || !_poll.userHasVoted) return;
    await _run(
      optionId: _myVoteOptionId,
      call: () => getIt<PollRepository>().cancelVote(pollId: _poll.pollId),
    );
  }

  Future<void> _run({
    required String? optionId,
    required Future<PollModel> Function() call,
  }) async {
    setState(() {
      _isSubmitting = true;
      _pendingOptionId = optionId;
    });
    try {
      final updated = await call();
      if (!mounted) return;
      setState(() {
        _poll = updated;
        // Source de vérité côté serveur (`votedOptionId`) plutôt que
        // l'optionId local — évite tout désync si la réponse diverge.
        _myVoteOptionId = updated.votedOptionId;
      });
    } catch (_) {
      // Échec réseau : le sondage reste dans son état précédent, on
      // réessaiera au prochain tap.
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
          _pendingOptionId = null;
        });
      }
    }
  }

  String get _expiryLabel {
    final expiresAt = _poll.expiresAt;
    if (expiresAt == null) return '';
    final diff = expiresAt.difference(DateTime.now());
    if (diff.isNegative) return 'Sondage terminé';
    if (diff.inDays >= 1) {
      return 'Fini dans ${diff.inDays} jour${diff.inDays > 1 ? 's' : ''}';
    }
    if (diff.inHours >= 1) return 'Fini dans ${diff.inHours}h';
    return 'Fini dans ${diff.inMinutes.clamp(1, 59)}min';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _PollColors.background,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: _PollColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Sondage',
            style: GoogleFonts.plusJakartaSans(
              fontWeight: FontWeight.w700,
              fontSize: 11,
              color: _PollColors.badge,
            ),
          ),
          const Gap(8),
          Text(
            _poll.question,
            style: GoogleFonts.plusJakartaSans(
              fontWeight: FontWeight.w700,
              fontSize: 13,
              color: _PollColors.question,
              height: 1.2,
            ),
          ),
          const Gap(14),
          for (final option in _poll.options) ...[
            _PollOptionBar(
              option: option,
              canVote: !_isClosed && !_isSubmitting,
              isPending: _pendingOptionId == option.id,
              isMyVote: _myVoteOptionId == option.id,
              onTap: () => _handleTap(option.id),
            ),
            const Gap(10),
          ],
          if (_poll.userHasVoted && !_isClosed) ...[
            GestureDetector(
              onTap: _isSubmitting ? null : _handleCancel,
              child: Text(
                'Annuler mon vote',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: _PollColors.meta,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            const Gap(10),
          ],
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${_poll.totalVotes} votes',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  color: _PollColors.meta,
                ),
              ),
              if (_expiryLabel.isNotEmpty)
                Text(
                  _expiryLabel,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    color: _PollColors.meta,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PollOptionBar extends StatelessWidget {
  final PollOption option;
  final bool canVote;
  final bool isPending;
  final bool isMyVote;
  final VoidCallback onTap;

  const _PollOptionBar({
    required this.option,
    required this.canVote,
    required this.isPending,
    required this.isMyVote,
    required this.onTap,
  });

  static const double _height = 36;
  static const double _radius = 24;

  @override
  Widget build(BuildContext context) {
    final pct = option.percentage.clamp(0, 100) / 100;
    final fillAlpha = (0.28 + 0.72 * pct).clamp(0.28, 1.0).toDouble();

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: canVote ? onTap : null,
        borderRadius: BorderRadius.circular(_radius),
        child: Ink(
          height: _height,
          decoration: BoxDecoration(
            color: _PollColors.track,
            borderRadius: BorderRadius.circular(_radius),
            border: isMyVote
                ? Border.all(color: _PollColors.myVoteBorder, width: 2)
                : null,
          ),
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(_radius),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        height: _height,
                        width: constraints.maxWidth * pct,
                        color: _PollColors.fillBase.withValues(alpha: fillAlpha),
                      ),
                    );
                  },
                ),
              ),
              Positioned.fill(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          option.label,
                          style: GoogleFonts.plusJakartaSans(
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                            color: _PollColors.optionLabel,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (isPending)
                        const SizedBox(
                          width: 14,
                          height: 14,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      else
                        Text(
                          '${option.percentage}%',
                          style: GoogleFonts.plusJakartaSans(
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                            color: _PollColors.percentage,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
