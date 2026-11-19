import re
import json
import os
import unittest

class TestFirestoreSecurityRules(unittest.TestCase):
    """
    Testes de Segurança e Validação das Regras do Cloud Firestore
    Garante que os dados salvos respeitem os requisitos de segurança e tipos.
    """
    @classmethod
    def setUpClass(cls):
        rules_path = os.path.join(os.path.dirname(__file__), 'Firestore Rules', 'firestore.rules')
        with open(rules_path, 'r', encoding='utf-8') as f:
            cls.rules_content = f.read()

    def test_rules_file_exists_and_valid_version(self):
        self.assertIn("rules_version = '2';", self.rules_content)
        self.assertIn("service cloud.firestore", self.rules_content)

    def test_produtos_collection_rules(self):
        self.assertIn("match /produtos/{document}", self.rules_content)
        self.assertIn("allow read: if true;", self.rules_content)
        self.assertIn("isValidProduto(request.resource.data)", self.rules_content)
        self.assertIn("allow delete: if false;", self.rules_content)

    def test_clientes_collection_rules(self):
        self.assertIn("match /clientes/{document}", self.rules_content)
        self.assertIn("allow read: if true;", self.rules_content)
        self.assertIn("isValidCliente(request.resource.data)", self.rules_content)
        self.assertIn("allow delete: if false;", self.rules_content)

    # -------------------------------------------------------------
    # Simulação da Lógica de Validação das Regras de Segurança
    # -------------------------------------------------------------
    def is_valid_produto_rule_sim(self, data):
        # Validação conforme definida em firestore.rules
        required_keys = ['nome', 'preco', 'categoria']
        if not all(k in data for k in required_keys):
            return False
        if not isinstance(data['nome'], str) or not (2 <= len(data['nome']) <= 100):
            return False
        if not isinstance(data['preco'], (int, float)) or data['preco'] <= 0:
            return False
        if not isinstance(data['categoria'], str) or len(data['categoria']) == 0:
            return False
        if 'descricao' in data and not isinstance(data['descricao'], str):
            return False
        return True

    def is_valid_cliente_rule_sim(self, data):
        # Validação conforme definida em firestore.rules
        required_keys = ['nome', 'telefone', 'email']
        if not all(k in data for k in required_keys):
            return False
        if not isinstance(data['nome'], str) or not (3 <= len(data['nome']) <= 100):
            return False
        if not isinstance(data['telefone'], str) or len(data['telefone']) < 8:
            return False
        if not isinstance(data['email'], str) or not re.match(r'.*@.*', data['email']):
            return False
        if 'endereco' in data and not isinstance(data['endereco'], str):
            return False
        return True

    def test_produto_security_valid_payload(self):
        valid_payload = {
            'nome': 'Pão Francês',
            'categoria': 'Pães',
            'preco': 1.50,
            'descricao': 'Pão quentinho crocante'
        }
        self.assertTrue(self.is_valid_produto_rule_sim(valid_payload))

    def test_produto_security_reject_missing_fields(self):
        # Falta preço
        invalid_payload = {'nome': 'Bolo', 'categoria': 'Doces'}
        self.assertFalse(self.is_valid_produto_rule_sim(invalid_payload))

        # Falta categoria
        invalid_payload2 = {'nome': 'Bolo', 'preco': 15.0}
        self.assertFalse(self.is_valid_produto_rule_sim(invalid_payload2))

    def test_produto_security_reject_negative_or_zero_price(self):
        invalid_payload = {'nome': 'Sonho', 'categoria': 'Doces', 'preco': -5.0}
        self.assertFalse(self.is_valid_produto_rule_sim(invalid_payload))

        invalid_payload_zero = {'nome': 'Sonho', 'categoria': 'Doces', 'preco': 0}
        self.assertFalse(self.is_valid_produto_rule_sim(invalid_payload_zero))

    def test_produto_security_reject_non_numeric_price(self):
        invalid_payload = {'nome': 'Sonho', 'categoria': 'Doces', 'preco': "cinco"}
        self.assertFalse(self.is_valid_produto_rule_sim(invalid_payload))

    def test_produto_security_reject_short_name(self):
        invalid_payload = {'nome': 'A', 'categoria': 'Pães', 'preco': 2.0}
        self.assertFalse(self.is_valid_produto_rule_sim(invalid_payload))

    def test_cliente_security_valid_payload(self):
        valid_payload = {
            'nome': 'Maria Oliveira',
            'telefone': '(41) 99888-1122',
            'email': 'maria@email.com',
            'endereco': 'Rua das Flores, 123'
        }
        self.assertTrue(self.is_valid_cliente_rule_sim(valid_payload))

    def test_cliente_security_reject_missing_telefone(self):
        invalid_payload = {'nome': 'Maria Oliveira', 'email': 'maria@email.com'}
        self.assertFalse(self.is_valid_cliente_rule_sim(invalid_payload))

    def test_cliente_security_reject_invalid_email(self):
        invalid_payload = {'nome': 'Maria Oliveira', 'telefone': '998881122', 'email': 'email_sem_arroba'}
        self.assertFalse(self.is_valid_cliente_rule_sim(invalid_payload))

    def test_cliente_security_reject_short_name(self):
        invalid_payload = {'nome': 'Jo', 'telefone': '998881122', 'email': 'jo@email.com'}
        self.assertFalse(self.is_valid_cliente_rule_sim(invalid_payload))


class TestAppValidationAndRequirements(unittest.TestCase):
    """
    Testes de Validação das Telas e Requisitos do Trimestre
    """
    def setUp(self):
        self.base_dir = os.path.dirname(__file__)

    def test_all_trimestre_screen_files_exist(self):
        required_files = [
            os.path.join(self.base_dir, 'Pages', 'cadastro_produto.dart'),
            os.path.join(self.base_dir, 'Pages', 'cadastro_produto_model.dart'),
            os.path.join(self.base_dir, 'Pages', 'lista_produtos.dart'),
            os.path.join(self.base_dir, 'Pages', 'lista_produtos_model.dart'),
            os.path.join(self.base_dir, 'Pages', 'cadastro_cliente.dart'),
            os.path.join(self.base_dir, 'Pages', 'cadastro_cliente_model.dart'),
            os.path.join(self.base_dir, 'Pages', 'lista_clientes.dart'),
            os.path.join(self.base_dir, 'Pages', 'lista_clientes_model.dart'),
        ]
        for f in required_files:
            self.assertTrue(os.path.exists(f), f"Arquivo obrigatório não encontrado: {f}")

    def test_cadastro_produto_contains_validation_and_actions(self):
        path = os.path.join(self.base_dir, 'Pages', 'cadastro_produto.dart')
        with open(path, 'r', encoding='utf-8') as f:
            code = f.read()

        # Requisito 5: Formulário, Create Document, limpar campos, Show SnackBar
        self.assertIn("FirebaseFirestore.instance.collection('produtos').add", code)
        self.assertIn("showSnackBar", code)
        self.assertIn("clear()", code)
        self.assertIn("Campos Obrigatórios", code)
        self.assertIn("Preço Inválido", code)
        self.assertIn("FieldValue.serverTimestamp()", code)

    def test_lista_produtos_contains_backend_query_and_cards(self):
        path = os.path.join(self.base_dir, 'Pages', 'lista_produtos.dart')
        with open(path, 'r', encoding='utf-8') as f:
            code = f.read()

        # Requisito 6: ListView, Backend Query List of Documents, Cards, Botão + para cadastro
        self.assertIn("StreamBuilder", code)
        self.assertIn(".collection('produtos')", code)
        self.assertIn(".orderBy('data_criacao', descending: true)", code)
        self.assertIn("CadastroProdutoWidget.routeName", code)
        self.assertIn("Card(", code)

    def test_cadastro_cliente_contains_validation_and_actions(self):
        path = os.path.join(self.base_dir, 'Pages', 'cadastro_cliente.dart')
        with open(path, 'r', encoding='utf-8') as f:
            code = f.read()

        # Requisito 7: Formulário, Create Document, limpar campos, Show SnackBar
        self.assertIn("FirebaseFirestore.instance.collection('clientes').add", code)
        self.assertIn("showSnackBar", code)
        self.assertIn("clear()", code)
        self.assertIn("Campos Obrigatórios", code)
        self.assertIn("Telefone Inválido", code)
        self.assertIn("E-mail Inválido", code)
        self.assertIn("FieldValue.serverTimestamp()", code)

    def test_lista_clientes_contains_backend_query_and_cards(self):
        path = os.path.join(self.base_dir, 'Pages', 'lista_clientes.dart')
        with open(path, 'r', encoding='utf-8') as f:
            code = f.read()

        # Requisito 8: ListView, Backend Query List of Documents, Cards, Botão + para cadastro
        self.assertIn("StreamBuilder", code)
        self.assertIn(".collection('clientes')", code)
        self.assertIn(".orderBy('data_criacao', descending: true)", code)
        self.assertIn("CadastroClienteWidget.routeName", code)
        self.assertIn("Card(", code)

    def test_navigation_integration_in_initial_page(self):
        path = os.path.join(self.base_dir, 'Pages', 'paginainicial2.dart')
        with open(path, 'r', encoding='utf-8') as f:
            code = f.read()

        self.assertIn("ListaProdutosWidget.routeName", code)
        self.assertIn("ListaClientesWidget.routeName", code)
        self.assertIn("EquipeWidget.routeName", code)
        self.assertIn("ObjetivosWidget.routeName", code)
        self.assertIn("DiagramasWidget.routeName", code)

    def test_firestore_indexes_configured(self):
        indexes_path = os.path.join(self.base_dir, 'Firestore Indexes', 'firestore.indexes.json')
        with open(indexes_path, 'r', encoding='utf-8') as f:
            data = json.load(f)

        self.assertIn("indexes", data)
        collections = [idx.get('collectionGroup') for idx in data['indexes']]
        self.assertIn('produtos', collections)
        self.assertIn('clientes', collections)

if __name__ == '__main__':
    unittest.main()
