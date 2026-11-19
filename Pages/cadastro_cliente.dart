import 'package:cloud_firestore/cloud_firestore.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'cadastro_cliente_model.dart';
export 'cadastro_cliente_model.dart';

class CadastroClienteWidget extends StatefulWidget {
  const CadastroClienteWidget({super.key});

  static String routeName = 'CadastroCliente';
  static String routePath = '/cadastroCliente';

  @override
  State<CadastroClienteWidget> createState() => _CadastroClienteWidgetState();
}

class _CadastroClienteWidgetState extends State<CadastroClienteWidget> {
  late CadastroClienteModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CadastroClienteModel());

    _model.nomeTextController ??= TextEditingController();
    _model.nomeFocusNode ??= FocusNode();

    _model.telefoneTextController ??= TextEditingController();
    _model.telefoneFocusNode ??= FocusNode();

    _model.emailTextController ??= TextEditingController();
    _model.emailFocusNode ??= FocusNode();

    _model.enderecoTextController ??= TextEditingController();
    _model.enderecoFocusNode ??= FocusNode();
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  Future<void> _salvarCliente() async {
    FocusScope.of(context).unfocus();

    final nome = _model.nomeTextController?.text.trim() ?? '';
    final telefone = _model.telefoneTextController?.text.trim() ?? '';
    final email = _model.emailTextController?.text.trim() ?? '';
    final endereco = _model.enderecoTextController?.text.trim() ?? '';

    // ==========================================
    // Validação de Segurança e Integridade dos Dados
    // ==========================================
    if (nome.isEmpty || telefone.isEmpty || email.isEmpty) {
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
              'Por favor, preencha o Nome, Telefone e E-mail do cliente para concluir o cadastro.',
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

    if (nome.length < 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'O nome deve ter no mínimo 3 caracteres.',
            style: GoogleFonts.inter(color: Colors.white),
          ),
          backgroundColor: const Color(0xFF836638),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    if (telefone.replaceAll(RegExp(r'\D'), '').length < 8) {
      await showDialog(
        context: context,
        builder: (alertDialogContext) {
          return AlertDialog(
            backgroundColor: const Color(0xFFFAF2EB),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: Text(
              'Telefone Inválido',
              style: GoogleFonts.oswald(
                color: const Color(0xFF3C1E02),
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            content: Text(
              'Informe um número de telefone ou WhatsApp válido com pelo menos 8 dígitos.',
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

    if (!email.contains('@') || !email.contains('.')) {
      await showDialog(
        context: context,
        builder: (alertDialogContext) {
          return AlertDialog(
            backgroundColor: const Color(0xFFFAF2EB),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: Text(
              'E-mail Inválido',
              style: GoogleFonts.oswald(
                color: const Color(0xFF3C1E02),
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            content: Text(
              'Por favor, insira um endereço de e-mail válido (ex: cliente@email.com).',
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
        'telefone': telefone,
        'email': email,
        'endereco': endereco,
        'data_criacao': FieldValue.serverTimestamp(),
      };

      await FirebaseFirestore.instance.collection('clientes').add(docData);

      // Limpar os campos do formulário
      _model.nomeTextController?.clear();
      _model.telefoneTextController?.clear();
      _model.emailTextController?.clear();
      _model.enderecoTextController?.clear();

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
                    'Cliente cadastrado com sucesso!',
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
                context.pushNamed(ListaClientesWidget.routeName);
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
                context.pushNamed(ListaClientesWidget.routeName);
              }
            },
          ),
          title: Text(
            'CADASTRAR CLIENTE',
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
                          Icons.person_add_alt_1_rounded,
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
                              'Hora Pães - Clientes',
                              style: GoogleFonts.oswald(
                                color: const Color(0xFFFAF2EB),
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Cadastre clientes para pedidos e entregas no Firestore',
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
                        'Dados Pessoais do Cliente',
                        style: GoogleFonts.oswald(
                          color: const Color(0xFF3C1E02),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Insira as informações de contato do cliente.',
                        style: GoogleFonts.inter(
                          color: const Color(0xFF57636C),
                          fontSize: 13,
                        ),
                      ),
                      const Divider(height: 24, thickness: 1, color: Color(0xFFD6BBA3)),

                      // Campo: Nome
                      Text(
                        'Nome Completo *',
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
                          hintText: 'Ex: Maria Silva, João Santos...',
                          hintStyle: GoogleFonts.inter(color: Colors.grey[400], fontSize: 14),
                          prefixIcon: const Icon(Icons.person_outline, color: Color(0xFF836638)),
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

                      // Campo: Telefone
                      Text(
                        'Telefone / WhatsApp *',
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                          color: const Color(0xFF3C1E02),
                        ),
                      ),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _model.telefoneTextController,
                        focusNode: _model.telefoneFocusNode,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          hintText: 'Ex: (41) 99888-7766',
                          hintStyle: GoogleFonts.inter(color: Colors.grey[400], fontSize: 14),
                          prefixIcon: const Icon(Icons.phone_outlined, color: Color(0xFF836638)),
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

                      // Campo: E-mail
                      Text(
                        'E-mail *',
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                          color: const Color(0xFF3C1E02),
                        ),
                      ),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _model.emailTextController,
                        focusNode: _model.emailFocusNode,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          hintText: 'Ex: cliente@email.com',
                          hintStyle: GoogleFonts.inter(color: Colors.grey[400], fontSize: 14),
                          prefixIcon: const Icon(Icons.email_outlined, color: Color(0xFF836638)),
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

                      // Campo: Endereço
                      Text(
                        'Endereço / Observações',
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                          color: const Color(0xFF3C1E02),
                        ),
                      ),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _model.enderecoTextController,
                        focusNode: _model.enderecoFocusNode,
                        maxLines: 2,
                        decoration: InputDecoration(
                          hintText: 'Rua, número, complemento, bairro...',
                          hintStyle: GoogleFonts.inter(color: Colors.grey[400], fontSize: 14),
                          prefixIcon: const Icon(Icons.location_on_outlined, color: Color(0xFF836638)),
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
                  onPressed: _isLoading ? null : _salvarCliente,
                  text: _isLoading ? 'SALVANDO...' : 'SALVAR CLIENTE',
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
                    context.pushNamed(ListaClientesWidget.routeName);
                  },
                  icon: const Icon(Icons.people_alt_outlined, color: Color(0xFF836638)),
                  label: Text(
                    'Ver lista de clientes cadastrados',
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
