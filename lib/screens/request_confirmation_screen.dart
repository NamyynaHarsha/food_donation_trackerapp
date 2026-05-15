import 'package:flutter/material.dart';

import '../widgets/reusable_widgets.dart';

class RequestConfirmationScreen
    extends StatefulWidget {

  final String donorName;

  const RequestConfirmationScreen({
    super.key,
    required this.donorName,
  });

  @override
  State<RequestConfirmationScreen>
      createState() =>
          _RequestConfirmationScreenState();
}

class _RequestConfirmationScreenState
    extends State<RequestConfirmationScreen>
    with TickerProviderStateMixin {

  late AnimationController
      _scaleController;

  late AnimationController
      _glowController;

  @override
  void initState() {
    super.initState();

    // SCALE ANIMATION
    _scaleController =
        AnimationController(
      duration:
          const Duration(milliseconds: 800),

      vsync: this,
    )..forward();

    // GLOW ANIMATION
    _glowController =
        AnimationController(
      duration:
          const Duration(milliseconds: 1500),

      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _scaleController.dispose();

    _glowController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final primary =
        Theme.of(context).colorScheme.primary;

    return Scaffold(

      backgroundColor:
          const Color(0xFFF7F7F7),

      body: Stack(
        children: [

          // CONFETTI BACKGROUND
          CustomPaint(
            painter: ConfettiPainter(),

            child: Container(),
          ),

          // MAIN CONTENT
          SafeArea(
            child: SingleChildScrollView(
              child: SizedBox(
                height:
                    MediaQuery.of(context)
                        .size
                        .height,

                child: Column(
                  mainAxisAlignment:
                      MainAxisAlignment
                          .center,

                  children: [

                    // CHECKMARK
                    Stack(
                      alignment:
                          Alignment.center,

                      children: [

                        // GLOW
                        ScaleTransition(
                          scale:
                              Tween<double>(
                            begin: 0.8,
                            end: 1.2,
                          ).animate(
                            CurvedAnimation(
                              parent:
                                  _glowController,

                              curve: Curves
                                  .easeInOut,
                            ),
                          ),

                          child: Container(
                            width: 180,
                            height: 180,

                            decoration:
                                BoxDecoration(
                              shape:
                                  BoxShape.circle,

                              color: primary
                                  .withValues(
                                alpha: 0.15,
                              ),
                            ),
                          ),
                        ),

                        // CHECK ICON
                        ScaleTransition(
                          scale:
                              CurvedAnimation(
                            parent:
                                _scaleController,

                            curve:
                                Curves.elasticOut,
                          ),

                          child: Container(
                            width: 140,
                            height: 140,

                            decoration:
                                BoxDecoration(
                              shape:
                                  BoxShape.circle,

                              color: primary,
                            ),

                            child: const Icon(
                              Icons.check,
                              size: 80,
                              color:
                                  Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(
                        height: 50),

                    // SUCCESS TEXT
                    Column(
                      children: [

                        const Text(
                          'Request Sent',

                          style: TextStyle(
                            fontSize: 30,
                            fontWeight:
                                FontWeight
                                    .bold,

                            color:
                                Colors.black,
                          ),
                        ),

                        const SizedBox(
                            height: 6),

                        Text(
                          'Successfully!',

                          style: TextStyle(
                            fontSize: 30,
                            fontWeight:
                                FontWeight
                                    .bold,

                            color: primary,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(
                        height: 45),

                    // DONOR CARD
                    Container(
                      margin:
                          const EdgeInsets
                              .symmetric(
                        horizontal: 24,
                      ),

                      padding:
                          const EdgeInsets
                              .all(22),

                      decoration:
                          BoxDecoration(
                        color: Colors.white,

                        borderRadius:
                            BorderRadius
                                .circular(
                          20,
                        ),

                        boxShadow: [
                          BoxShadow(
                            color: Colors.black
                                .withValues(
                              alpha: 0.06,
                            ),

                            blurRadius: 12,

                            offset:
                                const Offset(
                              0,
                              4,
                            ),
                          ),
                        ],
                      ),

                      child: Column(
                        children: [

                          // DONOR INFO
                          Row(
                            children: [

                              CircleAvatar(
                                radius: 32,

                                backgroundColor:
                                    primary
                                        .withValues(
                                  alpha: 0.12,
                                ),

                                child: Text(
                                  widget
                                      .donorName[0]
                                      .toUpperCase(),

                                  style:
                                      TextStyle(
                                    fontSize:
                                        28,

                                    fontWeight:
                                        FontWeight
                                            .bold,

                                    color:
                                        primary,
                                  ),
                                ),
                              ),

                              const SizedBox(
                                  width: 18),

                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment
                                          .start,

                                  children: [

                                    Text(
                                      widget
                                          .donorName,

                                      style:
                                          const TextStyle(
                                        fontSize:
                                            20,

                                        fontWeight:
                                            FontWeight
                                                .bold,
                                      ),
                                    ),

                                    const SizedBox(
                                        height:
                                            4),

                                    Text(
                                      'Food Donor',

                                      style:
                                          TextStyle(
                                        color: Colors
                                                .grey[
                                            600],

                                        fontSize:
                                            14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              Container(
                                padding:
                                    const EdgeInsets
                                        .symmetric(
                                  horizontal:
                                      12,
                                  vertical:
                                      6,
                                ),

                                decoration:
                                    BoxDecoration(
                                  color: primary
                                      .withValues(
                                    alpha:
                                        0.12,
                                  ),

                                  borderRadius:
                                      BorderRadius
                                          .circular(
                                    20,
                                  ),
                                ),

                                child: Text(
                                  'Verified',

                                  style:
                                      TextStyle(
                                    color:
                                        primary,

                                    fontWeight:
                                        FontWeight
                                            .w600,

                                    fontSize:
                                        12,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(
                              height: 24),

                          Divider(
                            color:
                                Colors.grey[200],
                          ),

                          const SizedBox(
                              height: 24),

                          // NOTIFICATION INFO
                          Row(
                            crossAxisAlignment:
                                CrossAxisAlignment
                                    .start,

                            children: [

                              CircleAvatar(
                                radius: 28,

                                backgroundColor:
                                    primary
                                        .withValues(
                                  alpha: 0.12,
                                ),

                                child: Icon(
                                  Icons
                                      .notifications_active,

                                  size: 28,
                                  color: primary,
                                ),
                              ),

                              const SizedBox(
                                  width: 18),

                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment
                                          .start,

                                  children: [

                                    const Text(
                                      'The donor has been notified.',

                                      style:
                                          TextStyle(
                                        fontSize:
                                            15,

                                        fontWeight:
                                            FontWeight
                                                .w600,
                                      ),
                                    ),

                                    const SizedBox(
                                        height:
                                            8),

                                    Text(
                                      'You will receive a notification once the donor confirms the pickup request.',

                                      style:
                                          TextStyle(
                                        fontSize:
                                            13,

                                        height:
                                            1.5,

                                        color: Colors
                                                .grey[
                                            600],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(
                        height: 50),

                    // BUTTON
                    Container(
                      margin:
                          const EdgeInsets
                              .symmetric(
                        horizontal: 24,
                      ),

                      child: PrimaryButton(
                        text:
                            'Back to Dashboard',

                        onPressed: () {

                          Navigator.popUntil(
                            context,

                            (route) =>
                                route.isFirst,
                          );
                        },
                      ),
                    ),

                    const SizedBox(
                        height: 30),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// CONFETTI PAINTER
class ConfettiPainter
    extends CustomPainter {

  @override
  void paint(
    Canvas canvas,
    Size size,
  ) {

    final paint = Paint();

    final confettiPieces = [

      {'x': 0.2, 'y': 0.15, 'color': const Color(0xFFE8A5C1), 'size': 8.0},
      {'x': 0.15, 'y': 0.4, 'color': const Color(0xFFD97BA3), 'size': 6.0},
      {'x': 0.1, 'y': 0.6, 'color': const Color(0xFFE8A5C1), 'size': 7.0},
      {'x': 0.85, 'y': 0.35, 'color': const Color(0xFFD97BA3), 'size': 8.0},
      {'x': 0.8, 'y': 0.65, 'color': const Color(0xFFE8A5C1), 'size': 6.0},

      {'x': 0.1, 'y': 0.25, 'color': const Color(0xFFFDB750), 'size': 7.0},
      {'x': 0.75, 'y': 0.25, 'color': const Color(0xFFFDB750), 'size': 8.0},
      {'x': 0.1, 'y': 0.75, 'color': const Color(0xFFFDB750), 'size': 6.0},

      {'x': 0.4, 'y': 0.1, 'color': const Color(0xFF66BB6A), 'size': 7.0},
      {'x': 0.55, 'y': 0.15, 'color': const Color(0xFF81C784), 'size': 6.0},
      {'x': 0.9, 'y': 0.6, 'color': const Color(0xFF66BB6A), 'size': 7.0},

      {'x': 0.6, 'y': 0.12, 'color': const Color(0xFF64B5F6), 'size': 8.0},
      {'x': 0.85, 'y': 0.4, 'color': const Color(0xFF42A5F5), 'size': 6.0},

      {'x': 0.15, 'y': 0.45, 'color': const Color(0xFFAB47BC), 'size': 7.0},
      {'x': 0.8, 'y': 0.75, 'color': const Color(0xFFBA68C8), 'size': 6.0},
    ];

    for (var piece
        in confettiPieces) {

      paint.color =
          piece['color'] as Color;

      final x =
          (piece['x'] as double) *
              size.width;

      final y =
          (piece['y'] as double) *
              size.height;

      final pieceSize =
          piece['size'] as double;

      canvas.drawRRect(
        RRect.fromRectAndRadius(

          Rect.fromCenter(
            center: Offset(x, y),

            width: pieceSize,

            height: pieceSize * 1.5,
          ),

          Radius.circular(
            pieceSize * 0.3,
          ),
        ),

        paint,
      );
    }
  }

  @override
  bool shouldRepaint(
    ConfettiPainter oldDelegate,
  ) {
    return false;
  }
}