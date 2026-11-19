import '/flutter_flow/flutter_flow_util.dart';
import 'cadastro_produto.dart' show CadastroProdutoWidget;
import 'package:flutter/material.dart';

class CadastroProdutoModel extends FlutterFlowModel<CadastroProdutoWidget> {
  /// State fields for stateful widgets in this page.

  final formKey = GlobalKey<FormState>();

  // State field(s) for nome widget.
  FocusNode? nomeFocusNode;
  TextEditingController? nomeTextController;
  String? Function(BuildContext, String?)? nomeTextControllerValidator;

  // State field(s) for categoria widget.
  FocusNode? categoriaFocusNode;
  TextEditingController? categoriaTextController;
  String? Function(BuildContext, String?)? categoriaTextControllerValidator;

  // State field(s) for preco widget.
  FocusNode? precoFocusNode;
  TextEditingController? precoTextController;
  String? Function(BuildContext, String?)? precoTextControllerValidator;

  // State field(s) for descricao widget.
  FocusNode? descricaoFocusNode;
  TextEditingController? descricaoTextController;
  String? Function(BuildContext, String?)? descricaoTextControllerValidator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    nomeFocusNode?.dispose();
    nomeTextController?.dispose();

    categoriaFocusNode?.dispose();
    categoriaTextController?.dispose();

    precoFocusNode?.dispose();
    precoTextController?.dispose();

    descricaoFocusNode?.dispose();
    descricaoTextController?.dispose();
  }
}
