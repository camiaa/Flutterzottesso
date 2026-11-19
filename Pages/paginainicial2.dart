import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'paginainicial2_model.dart';
export 'paginainicial2_model.dart';

class Paginainicial2Widget extends StatefulWidget {
  const Paginainicial2Widget({super.key});

  static String routeName = 'paginainicial2';
  static String routePath = '/paginainicial2';

  @override
  State<Paginainicial2Widget> createState() => _Paginainicial2WidgetState();
}

class _Paginainicial2WidgetState extends State<Paginainicial2Widget> {
  late Paginainicial2Model _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => Paginainicial2Model());
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: const Color(0xFFFAF2EB),
        body: SafeArea(
          top: true,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    'assets/images/Captura_de_tela_2026-05-04_235645.png',
                    width: 90044.4,
                    height: 260,
                    fit: BoxFit.cover,
                  ),
                ),
                const Divider(
                  thickness: 2,
                  color: Color(0xFFD6BBA3),
                ),
                // Botão: INÍCIO (Home da Padaria)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  child: FFButtonWidget(
                    onPressed: () async {
                      context.pushNamed(HomePageWidget.routeName);
                    },
                    text: 'INÍCIO',
                    options: FFButtonOptions(
                      width: 300,
                      height: 42,
                      padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
                      iconPadding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                      color: const Color(0xFF3C1E02),
                      textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                            font: GoogleFonts.interTight(
                              fontWeight: FlutterFlowTheme.of(context)
                                  .titleSmall
                                  .fontWeight,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .titleSmall
                                  .fontStyle,
                            ),
                            color: const Color(0xFFFAF2EB),
                            letterSpacing: 2,
                            fontWeight: FlutterFlowTheme.of(context)
                                .titleSmall
                                .fontWeight,
                            fontStyle:
                                FlutterFlowTheme.of(context).titleSmall.fontStyle,
                          ),
                      elevation: 0,
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                ),

                // ==========================================
                // Telas 5 e 6: Entidade 1 - PRODUTOS
                // ==========================================
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  child: FFButtonWidget(
                    onPressed: () async {
                      context.pushNamed(ListaProdutosWidget.routeName);
                    },
                    text: 'PRODUTOS',
                    icon: const Icon(
                      Icons.bakery_dining_rounded,
                      color: Color(0xFFFAF2EB),
                      size: 20,
                    ),
                    options: FFButtonOptions(
                      width: 300,
                      height: 42,
                      padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
                      iconPadding: const EdgeInsetsDirectional.fromSTEB(0, 0, 8, 0),
                      color: const Color(0xFF3C1E02),
                      textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                            font: GoogleFonts.interTight(
                              fontWeight: FlutterFlowTheme.of(context)
                                  .titleSmall
                                  .fontWeight,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .titleSmall
                                  .fontStyle,
                            ),
                            color: const Color(0xFFFAF2EB),
                            letterSpacing: 2,
                            fontWeight: FlutterFlowTheme.of(context)
                                .titleSmall
                                .fontWeight,
                            fontStyle:
                                FlutterFlowTheme.of(context).titleSmall.fontStyle,
                          ),
                      elevation: 0,
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                ),

                // ==========================================
                // Telas 7 e 8: Entidade 2 - CLIENTES
                // ==========================================
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  child: FFButtonWidget(
                    onPressed: () async {
                      context.pushNamed(ListaClientesWidget.routeName);
                    },
                    text: 'CLIENTES',
                    icon: const Icon(
                      Icons.people_alt_rounded,
                      color: Color(0xFFFAF2EB),
                      size: 20,
                    ),
                    options: FFButtonOptions(
                      width: 300,
                      height: 42,
                      padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
                      iconPadding: const EdgeInsetsDirectional.fromSTEB(0, 0, 8, 0),
                      color: const Color(0xFF3C1E02),
                      textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                            font: GoogleFonts.interTight(
                              fontWeight: FlutterFlowTheme.of(context)
                                  .titleSmall
                                  .fontWeight,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .titleSmall
                                  .fontStyle,
                            ),
                            color: const Color(0xFFFAF2EB),
                            letterSpacing: 2,
                            fontWeight: FlutterFlowTheme.of(context)
                                .titleSmall
                                .fontWeight,
                            fontStyle:
                                FlutterFlowTheme.of(context).titleSmall.fontStyle,
                          ),
                      elevation: 0,
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                ),

                // Botão: EQUIPE
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  child: FFButtonWidget(
                    onPressed: () async {
                      context.pushNamed(EquipeWidget.routeName);
                    },
                    text: 'EQUIPE',
                    options: FFButtonOptions(
                      width: 300,
                      height: 42,
                      padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
                      iconPadding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                      color: const Color(0xFF3C1E02),
                      textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                            font: GoogleFonts.interTight(
                              fontWeight: FlutterFlowTheme.of(context)
                                  .titleSmall
                                  .fontWeight,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .titleSmall
                                  .fontStyle,
                            ),
                            color: const Color(0xFFFAF2EB),
                            letterSpacing: 2,
                            fontWeight: FlutterFlowTheme.of(context)
                                .titleSmall
                                .fontWeight,
                            fontStyle:
                                FlutterFlowTheme.of(context).titleSmall.fontStyle,
                          ),
                      elevation: 0,
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                ),

                // Botão: OBJETIVOS
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  child: FFButtonWidget(
                    onPressed: () async {
                      context.pushNamed(ObjetivosWidget.routeName);
                    },
                    text: 'OBJETIVOS',
                    options: FFButtonOptions(
                      width: 300,
                      height: 42,
                      padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
                      iconPadding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                      color: const Color(0xFF3C1E02),
                      textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                            font: GoogleFonts.interTight(
                              fontWeight: FlutterFlowTheme.of(context)
                                  .titleSmall
                                  .fontWeight,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .titleSmall
                                  .fontStyle,
                            ),
                            color: const Color(0xFFFAF2EB),
                            letterSpacing: 2,
                            fontWeight: FlutterFlowTheme.of(context)
                                .titleSmall
                                .fontWeight,
                            fontStyle:
                                FlutterFlowTheme.of(context).titleSmall.fontStyle,
                          ),
                      elevation: 0,
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                ),

                // Botão: DIAGRAMAS
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  child: FFButtonWidget(
                    onPressed: () async {
                      context.pushNamed(DiagramasWidget.routeName);
                    },
                    text: 'DIAGRAMAS',
                    options: FFButtonOptions(
                      width: 300,
                      height: 42,
                      padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
                      iconPadding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                      color: const Color(0xFF3C1E02),
                      textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                            font: GoogleFonts.interTight(
                              fontWeight: FlutterFlowTheme.of(context)
                                  .titleSmall
                                  .fontWeight,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .titleSmall
                                  .fontStyle,
                            ),
                            color: const Color(0xFFFAF2EB),
                            letterSpacing: 2,
                            fontWeight: FlutterFlowTheme.of(context)
                                .titleSmall
                                .fontWeight,
                            fontStyle:
                                FlutterFlowTheme.of(context).titleSmall.fontStyle,
                          ),
                      elevation: 0,
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                const Divider(
                  thickness: 2,
                  color: Color(0xFFD6BBA3),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
