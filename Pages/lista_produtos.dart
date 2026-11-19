import 'package:cloud_firestore/cloud_firestore.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import 'lista_produtos_model.dart';
export 'lista_produtos_model.dart';

class ListaProdutosWidget extends StatefulWidget {
  const ListaProdutosWidget({super.key});

  static String routeName = 'ListaProdutos';
  static String routePath = '/listaProdutos';

  @override
  State<ListaProdutosWidget> createState() => _ListaProdutosWidgetState();
}

class _ListaProdutosWidgetState extends State<ListaProdutosWidget> {
  late ListaProdutosModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ListaProdutosModel());
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  String _formatarData(dynamic dataCriacao) {
    if (dataCriacao == null) return '';
    if (dataCriacao is Timestamp) {
      final dt = dataCriacao.toDate();
      return DateFormat('dd/MM/yyyy HH:mm').format(dt);
    }
    if (dataCriacao is DateTime) {
      return DateFormat('dd/MM/yyyy HH:mm').format(dataCriacao);
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: const Color(0xFFFAF2EB),
      appBar: AppBar(
        backgroundColor: const Color(0xFF3C1E02),
        automaticallyImplyLeading: false,
        leading: FlutterFlowIconButton(
          borderRadius: 8,
          buttonSize: 40,
          fillColor: const Color(0xFF3C1E02),
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
            size: 24,
          ),
          onPressed: () async {
            context.pushNamed(Paginainicial2Widget.routeName);
          },
        ),
        title: Text(
          'PRODUTOS CADASTRADOS',
          style: GoogleFonts.oswald(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.0,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 12, 0),
            child: FlutterFlowIconButton(
              borderRadius: 20,
              buttonSize: 40,
              fillColor: const Color(0xFF836638),
              icon: const Icon(
                Icons.add,
                color: Color(0xFFFAF2EB),
                size: 24,
              ),
              onPressed: () async {
                context.pushNamed(CadastroProdutoWidget.routeName);
              },
            ),
          ),
        ],
        centerTitle: false,
        elevation: 2,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          context.pushNamed(CadastroProdutoWidget.routeName);
        },
        backgroundColor: const Color(0xFF3C1E02),
        elevation: 4,
        icon: const Icon(Icons.add, color: Color(0xFFFAF2EB)),
        label: Text(
          'Novo Produto',
          style: GoogleFonts.interTight(
            color: const Color(0xFFFAF2EB),
            fontWeight: FontWeight.bold,
            letterSpacing: 1.0,
          ),
        ),
      ),
      body: SafeArea(
        top: true,
        child: Column(
          children: [
            // Banner de contexto
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              color: const Color(0xFFEFE2D3),
              child: Row(
                children: [
                  const Icon(Icons.bakery_dining_rounded, color: Color(0xFF3C1E02), size: 24),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Cardápio Hora Pães • Ordenado por mais recentes',
                      style: GoogleFonts.inter(
                        color: const Color(0xFF3C1E02),
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, thickness: 1, color: Color(0xFFD6BBA3)),

            // ListView com Backend Query (List of Documents no Cloud Firestore)
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('produtos')
                    .orderBy('data_criacao', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  // Estado de Carregamento
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF3C1E02),
                      ),
                    );
                  }

                  // Estado de Erro (com fallback para consulta simples se índice composto pendente)
                  if (snapshot.hasError) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.info_outline, color: Color(0xFF836638), size: 48),
                            const SizedBox(height: 12),
                            Text(
                              'Aguardando conexão ou permissão do Firestore.',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.inter(
                                color: const Color(0xFF3C1E02),
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              '${snapshot.error}',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.inter(
                                color: Colors.grey[700],
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  final docs = snapshot.data?.docs ?? [];

                  // Estado Vazio
                  if (docs.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: const BoxDecoration(
                                color: Color(0xFFEFE2D3),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.storefront_outlined,
                                color: Color(0xFF836638),
                                size: 64,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Nenhum produto cadastrado ainda',
                              style: GoogleFonts.oswald(
                                color: const Color(0xFF3C1E02),
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Clique no botão "+" abaixo para cadastrar o primeiro item da padaria!',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.inter(
                                color: const Color(0xFF57636C),
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 20),
                            FFButtonWidget(
                              onPressed: () async {
                                context.pushNamed(CadastroProdutoWidget.routeName);
                              },
                              text: 'CADASTRAR PRODUTO',
                              icon: const Icon(Icons.add, size: 18),
                              options: FFButtonOptions(
                                height: 42,
                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                color: const Color(0xFF3C1E02),
                                textStyle: GoogleFonts.interTight(
                                  color: const Color(0xFFFAF2EB),
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                                elevation: 2,
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  // ListView exibindo os documentos em Cards
                  return ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      final doc = docs[index];
                      final data = doc.data() as Map<String, dynamic>;

                      final nome = data['nome']?.toString() ?? 'Sem nome';
                      final categoria = data['categoria']?.toString() ?? 'Geral';
                      final preco = (data['preco'] as num?)?.toDouble() ?? 0.0;
                      final descricao = data['descricao']?.toString() ?? '';
                      final dataFormatada = _formatarData(data['data_criacao']);

                      return Card(
                        margin: const EdgeInsets.only(bottom: 14),
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: const BorderSide(
                            color: Color(0xFFD6BBA3),
                            width: 0.8,
                          ),
                        ),
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Linha 1: Nome e Preço
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Text(
                                      nome,
                                      style: GoogleFonts.oswald(
                                        color: const Color(0xFF3C1E02),
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFAF2EB),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: const Color(0xFF836638),
                                        width: 1.2,
                                      ),
                                    ),
                                    child: Text(
                                      'R\$ ${preco.toStringAsFixed(2)}',
                                      style: GoogleFonts.interTight(
                                        color: const Color(0xFF836638),
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),

                              // Linha 2: Categoria (Badge)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF3C1E02),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  categoria.toUpperCase(),
                                  style: GoogleFonts.inter(
                                    color: const Color(0xFFFAF2EB),
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.8,
                                  ),
                                ),
                              ),

                              // Linha 3: Descrição (se houver)
                              if (descricao.isNotEmpty) ...[
                                const SizedBox(height: 8),
                                Text(
                                  descricao,
                                  style: GoogleFonts.inter(
                                    color: const Color(0xFF57636C),
                                    fontSize: 13,
                                    height: 1.3,
                                  ),
                                ),
                              ],

                              // Linha 4: Data de Cadastro (Current Time)
                              if (dataFormatada.isNotEmpty) ...[
                                const SizedBox(height: 10),
                                const Divider(height: 1, thickness: 0.6, color: Color(0xFFE0E0E0)),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.access_time_rounded,
                                      size: 14,
                                      color: Color(0xFF836638),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      'Cadastrado em: $dataFormatada',
                                      style: GoogleFonts.inter(
                                        color: const Color(0xFF836638),
                                        fontSize: 11,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
