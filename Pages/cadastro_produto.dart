import 'package:cloud_firestore/cloud_firestore.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'cadastro_produto_model.dart';
export 'cadastro_produto_model.dart';

class CadastroProdutoWidget extends StatefulWidget {
  const CadastroProdutoWidget({super.key});

  static String routeName = 'CadastroProduto';
  static String routePath = '/cadastroProduto';

  @override
  State<CadastroProdutoWidget> createState() => _CadastroProdutoWidgetState();
}

class _CadastroProdutoWidgetState extends State<CadastroProdutoWidget> {
  late CadastroProdutoModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CadastroProdutoModel());

    _model.nomeTextController ??= TextEditingController();
    _model.nomeFocusNode ??= FocusNode();

    _model.categoriaTextController ??= TextEditingController();
    _model.categoriaFocusNode ??= FocusNode();

    _model.precoTextController ??= TextEditingController();
    _model.precoFocusNode ??= FocusNode();

    _model.descricaoTextController ??= TextEditingController();
    _model.descricaoFocusNode ??= FocusNode();
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  Future<void> _salvarProduto() async {
    FocusScope.of(context).unfocus();

    final nome = _model.nomeTextController?.text.trim() ?? '';
    final categoria = _model.categoriaTextController?.text.trim() ?? '';
    final precoTexto = _model.precoTextController?.text.trim().replaceAll(',', '.') ?? '';
    final descricao = _model.descricaoTextController?.text.trim() ?? '';

    // ==========================================
    // Validação de Segurança e Integridade dos Dados
    // ==========================================
    if (nome.isEmpty || categoria.isEmpty || precoTexto.isEmpty) {
      await showDialog(
        context: context,
        builder: (alertDialogContext) {
          return AlertDialog(
            backgroundColor: const Color(0xFFFAF2EB),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: Row(
              children: [
                const Icon(Icons.warning_amber_rounded, color: Color(0xFF836638), size: 28),
                const SizedBox(width: 8),
                Text(
                  'Campos Obrigatórios',
                  style: GoogleFonts.oswald(
                    color: const Color(0xFF3C1E02),
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
            content: Text(
              'Por favor, preencha todos os campos obrigatórios (Nome, Categoria e Preço) antes de salvar.',
              style: GoogleFonts.inter(
                color: const Color(0xFF422121),
                fontSize: 14,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(alertDialogContext),
                child: Text(
                  'Entendi',
                  style: GoogleFonts.interTight(
                    color: const Color(0xFF3C1E02),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          );
        },
      );
      return;
    }

    if (nome.length < 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'O nome do produto deve ter no mínimo 2 caracteres.',
            style: GoogleFonts.inter(color: Colors.white),
          ),
          backgroundColor: const Color(0xFF836638),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final preco = double.tryParse(precoTexto);
    if (preco == null || preco <= 0) {
      await showDialog(
        context: context,
        builder: (alertDialogContext) {
          return AlertDialog(
            backgroundColor: const Color(0xFFFAF2EB),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: Text(
              'Preço Inválido',
              style: GoogleFonts.oswald(
                color: const Color(0xFF3C1E02),
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            content: Text(
              'Por favor, informe um valor numérico válido maior que zero (ex: 4.50).',
              style: GoogleFonts.inter(
                color: const Color(0xFF422121),
                fontSize: 14,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(alertDialogContext),
                child: Text(
                  'Corrigir',
                  style: GoogleFonts.interTight(
                    color: const Color(0xFF3C1E02),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          );
        },
      );
      return;
    }

    // ==========================================
    // Gravação no Cloud Firestore (Create Document)
    // ==========================================
    setState(() => _isLoading = true);

    try {
      final docData = <String, dynamic>{
        'nome': nome,
        'categoria': categoria,
        'preco': preco,
        'descricao': descricao,
        'data_criacao': FieldValue.serverTimestamp(),
      };

      await FirebaseFirestore.instance.collection('produtos').add(docData);

      // Limpar os campos do formulário
      _model.nomeTextController?.clear();
      _model.categoriaTextController?.clear();
      _model.precoTextController?.clear();
      _model.descricaoTextController?.clear();

      if (mounted) {
        // Exibir mensagem de sucesso via SnackBar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle_outline, color: Colors.white),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Produto cadastrado com sucesso!',
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            backgroundColor: const Color(0xFF3C1E02),
            duration: const Duration(seconds: 4),
            behavior: SnackBarBehavior.floating,
            action: SnackBarAction(
              label: 'Ver Lista',
              textColor: const Color(0xFFFAF2EB),
              onPressed: () {
                context.pushNamed(ListaProdutosWidget.routeName);
              },
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Erro ao salvar: $e',
              style: GoogleFonts.inter(color: Colors.white),
            ),
            backgroundColor: Colors.red[800],
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
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
              if (Navigator.of(context).canPop()) {
                Navigator.of(context).pop();
              } else {
                context.pushNamed(ListaProdutosWidget.routeName);
              }
            },
          ),
          title: Text(
            'CADASTRAR PRODUTO',
            style: GoogleFonts.oswald(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.0,
            ),
          ),
          centerTitle: false,
          elevation: 2,
        ),
        body: SafeArea(
          top: true,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header ilustrativo
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF3C1E02),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [
                      BoxShadow(
                        blurRadius: 10,
                        color: Color(0x33000000),
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFAF2EB),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.bakery_dining_rounded,
                          color: Color(0xFF3C1E02),
                          size: 32,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Hora Pães - Produtos',
                              style: GoogleFonts.oswald(
                                color: const Color(0xFFFAF2EB),
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Cadastre os itens do cardápio no Cloud Firestore',
                              style: GoogleFonts.inter(
                                color: const Color(0xFFD6BBA3),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Card do Formulário
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [
                      BoxShadow(
                        blurRadius: 12,
                        color: Color(0x14000000),
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Informações do Produto',
                        style: GoogleFonts.oswald(
                          color: const Color(0xFF3C1E02),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Preencha os campos abaixo com os dados do item.',
                        style: GoogleFonts.inter(
                          color: const Color(0xFF57636C),
                          fontSize: 13,
                        ),
                      ),
                      const Divider(height: 24, thickness: 1, color: Color(0xFFD6BBA3)),

                      // Campo: Nome
                      Text(
                        'Nome do Produto *',
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                          color: const Color(0xFF3C1E02),
                        ),
                      ),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _model.nomeTextController,
                        focusNode: _model.nomeFocusNode,
                        decoration: InputDecoration(
                          hintText: 'Ex: Pão Francês, Capuccino Tradicional...',
                          hintStyle: GoogleFonts.inter(color: Colors.grey[400], fontSize: 14),
                          prefixIcon: const Icon(Icons.lunch_dining_outlined, color: Color(0xFF836638)),
                          filled: true,
                          fillColor: const Color(0xFFFAF2EB),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Color(0xFFD6BBA3)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Color(0xFFD6BBA3)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Color(0xFF3C1E02), width: 2),
                          ),
                        ),
                        style: GoogleFonts.inter(fontSize: 14, color: const Color(0xFF101518)),
                      ),
                      const SizedBox(height: 16),

                      // Campo: Categoria
                      Text(
                        'Categoria *',
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                          color: const Color(0xFF3C1E02),
                        ),
                      ),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _model.categoriaTextController,
                        focusNode: _model.categoriaFocusNode,
                        decoration: InputDecoration(
                          hintText: 'Ex: Pães, Bebidas, Bolos & Doces, Salgados',
                          hintStyle: GoogleFonts.inter(color: Colors.grey[400], fontSize: 14),
                          prefixIcon: const Icon(Icons.category_outlined, color: Color(0xFF836638)),
                          filled: true,
                          fillColor: const Color(0xFFFAF2EB),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Color(0xFFD6BBA3)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Color(0xFFD6BBA3)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Color(0xFF3C1E02), width: 2),
                          ),
                        ),
                        style: GoogleFonts.inter(fontSize: 14, color: const Color(0xFF101518)),
                      ),
                      const SizedBox(height: 16),

                      // Campo: Preço
                      Text(
                        'Preço (R$) *',
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                          color: const Color(0xFF3C1E02),
                        ),
                      ),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _model.precoTextController,
                        focusNode: _model.precoFocusNode,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        decoration: InputDecoration(
                          hintText: 'Ex: 4.50',
                          hintStyle: GoogleFonts.inter(color: Colors.grey[400], fontSize: 14),
                          prefixIcon: const Icon(Icons.attach_money_rounded, color: Color(0xFF836638)),
                          filled: true,
                          fillColor: const Color(0xFFFAF2EB),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Color(0xFFD6BBA3)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Color(0xFFD6BBA3)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Color(0xFF3C1E02), width: 2),
                          ),
                        ),
                        style: GoogleFonts.inter(fontSize: 14, color: const Color(0xFF101518)),
                      ),
                      const SizedBox(height: 16),

                      // Campo: Descrição
                      Text(
                        'Descrição',
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                          color: const Color(0xFF3C1E02),
                        ),
                      ),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _model.descricaoTextController,
                        focusNode: _model.descricaoFocusNode,
                        maxLines: 3,
                        decoration: InputDecoration(
                          hintText: 'Ingredientes, sabor, modo de preparo...',
                          hintStyle: GoogleFonts.inter(color: Colors.grey[400], fontSize: 14),
                          prefixIcon: const Icon(Icons.notes_rounded, color: Color(0xFF836638)),
                          filled: true,
                          fillColor: const Color(0xFFFAF2EB),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Color(0xFFD6BBA3)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Color(0xFFD6BBA3)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Color(0xFF3C1E02), width: 2),
                          ),
                        ),
                        style: GoogleFonts.inter(fontSize: 14, color: const Color(0xFF101518)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Botão Salvar
                FFButtonWidget(
                  onPressed: _isLoading ? null : _salvarProduto,
                  text: _isLoading ? 'SALVANDO...' : 'SALVAR PRODUTO',
                  icon: const Icon(Icons.save_rounded, size: 20),
                  options: FFButtonOptions(
                    height: 50,
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    color: const Color(0xFF3C1E02),
                    textStyle: GoogleFonts.interTight(
                      color: const Color(0xFFFAF2EB),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                    elevation: 3,
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                const SizedBox(height: 12),

                // Botão secundário para ver a lista
                TextButton.icon(
                  onPressed: () {
                    context.pushNamed(ListaProdutosWidget.routeName);
                  },
                  icon: const Icon(Icons.list_alt_rounded, color: Color(0xFF836638)),
                  label: Text(
                    'Ver lista de produtos cadastrados',
                    style: GoogleFonts.inter(
                      color: const Color(0xFF836638),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
