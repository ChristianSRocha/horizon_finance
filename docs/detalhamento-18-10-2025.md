# Análise Detalhada do Projeto: Horizon Finance

Este documento detalha a estrutura, tecnologias, fluxos e estado atual do projeto Horizon Finance, com base nos arquivos fornecidos.

## 1. Visão Geral e Objetivo

O **Horizon Finance** é um aplicativo de finanças pessoais desenvolvido em Flutter. O objetivo principal, conforme o `README.md`, é oferecer uma ferramenta simples para rastreamento de gastos com um diferencial de **análise preditiva**, projetando a saúde financeira futura do usuário.

## 2. Arquitetura e Tecnologias (Stack)

O projeto adota uma arquitetura moderna e focada em desenvolvimento ágil e multiplataforma.

*   **Frontend (Mobile):** **Flutter**. A escolha é clara pela presença de arquivos `.dart`, a estrutura de `lib/`, o `pubspec.yaml` e a capacidade de rodar em Android e Web (conforme as pastas `android/` e `web/`).
*   **Backend:** **Supabase**. Mencionado no `README.md` como a alternativa open-source ao Firebase. Isso implica o uso de seus serviços para:
    *   **Autenticação:** Gerenciamento de usuários (login/cadastro).
    *   **API:** Os métodos `fromJson` e `toJson` nos modelos sugerem a comunicação com uma API RESTful ou similar, que o Supabase provê automaticamente sobre o banco de dados.
*   **Banco de Dados:** **PostgreSQL**. É o banco de dados subjacente ao Supabase. Os nomes de campos nos métodos `fromJson` (ex: `user_id`, `created_at`) seguem a convenção `snake_case`, comum em bancos de dados SQL.
*   **Gerenciamento de Estado:** **Provider**. A dependência `provider: ^6.0.5` no `pubspec.yaml` indica que este é o padrão escolhido para gerenciar o estado da aplicação.
*   **Ambiente de Desenvolvimento:** **Docker**. O `README.md` instrui o uso de `docker-compose` para configurar o ambiente local, facilitando a inicialização do backend Supabase para desenvolvimento.

### Principais Dependências (`pubspec.yaml`):

*   `provider`: Para gerenciamento de estado.
*   `http`: Para realizar chamadas de API para o backend.
*   `fl_chart`: Para a criação de gráficos e visualizações de dados (essencial para o dashboard preditivo).
*   `shared_preferences` / `sqflite`: Para armazenamento local de dados, como tokens de sessão ou cache.
*   `intl`: Para formatação de datas e números.
*   `email_validator`: Para validação de formulários.

## 3. Estrutura de Diretórios

A organização do código-fonte na pasta `lib/` segue um padrão lógico e escalável:

```
lib/
├── main.dart             # Ponto de entrada da aplicação.
├── models/               # Modelos de dados (a representação das entidades do app).
│   ├── financial_goal.dart
│   ├── transaction.dart
│   └── user.dart
├── screens/              # As diferentes telas da aplicação.
│   ├── auth/             # Telas de autenticação e onboarding.
│   │   ├── cadastro_screen.dart
│   │   ├── despesas_fixas_screen.dart
│   │   ├── login_cadastro_screen.dart
│   │   └── renda_mensal_screen.dart
│   └── dashboard/        # Tela principal após o login (mencionada, mas não fornecida).
└── theme/                # Lógica de tema e responsividade.
    └── responsive_theme.dart
```

*   **`models/`**: Contém as classes que estruturam os dados da aplicação: `User`, `Transaction`, e `FinancialGoal`. Elas incluem lógica de serialização/desserialização (`fromJson`/`toJson`), propriedades computadas (ex: `progressPercentage` em `FinancialGoal`) e métodos utilitários como `copyWith`.
*   **`screens/`**: Separa as telas por funcionalidade. A subpasta `auth/` agrupa todo o fluxo inicial do usuário.
*   **`theme/`**: O arquivo `responsive_theme.dart` é uma excelente prática, centralizando a lógica para adaptar tamanhos de fontes, espaçamentos e layouts a diferentes tamanhos de tela (mobile, tablet, desktop).

## 4. Fluxos de Usuário Implementados

Com base nas telas existentes, o seguinte fluxo de **Cadastro e Onboarding** está estruturado:

1.  **Tela Inicial (`LoginCadastroScreen`):** É a porta de entrada, provavelmente com opções para "Login" e "Criar Conta".

2.  **Criação de Conta (`CadastroScreen`):**
    *   O usuário preenche um formulário com Nome, E-mail, Senha e Confirmação de Senha.
    *   Há validação de formulário e um indicador de loading (`_isLoading`).
    *   Atualmente, a chamada de API é simulada com um `Future.delayed`.
    *   Após o sucesso, o app **não vai para o login**, mas sim para a próxima etapa do onboarding.

3.  **Onboarding: Renda Mensal (`RendaMensalScreen`):**
    *   O usuário é redirecionado para esta tela (cujo arquivo não foi fornecido, mas o fluxo é claro) para informar sua renda mensal.

4.  **Onboarding: Despesas Fixas (`DespesasFixasScreen`):**
    *   Em seguida, o usuário informa valores para suas despesas fixas mensais (Aluguel, Assinaturas, etc.).
    *   A tela apresenta uma lista de categorias de despesas com campos de input para os valores.

5.  **Finalização e Acesso ao App:**
    *   Ao clicar em "Finalizar e Acessar o App", o usuário é redirecionado para a `DashboardScreen`, concluindo o fluxo de cadastro e configuração inicial.

## 5. Pontos de Melhoria e Próximos Passos

*   **Integração com Backend:** O fluxo de cadastro (`_handleCadastro` em `cadastro_screen.dart`) e a tela de despesas fixas ainda não estão integrados com um serviço real. O próximo passo seria substituir a simulação pela chamada real ao Supabase para criar o usuário e salvar seus dados de onboarding.
*   **Gerenciamento de Estado:** A lógica de negócio (como salvar os dados do onboarding) deve ser movida das telas para um `ChangeNotifier` do Provider. Isso desacoplará a UI da lógica de dados, tornando o código mais limpo e testável.
*   **Validação de Input:** Na tela `DespesasFixasScreen`, os `TextFormField` precisam de validação e de um `TextEditingController` para capturar e processar os valores inseridos pelo usuário. Atualmente, o `onValueChanged` está vazio.
*   **Componentização:** O widget `_buildTextField` em `CadastroScreen` é um bom exemplo de componentização. Essa prática pode ser estendida. Por exemplo, o `_buildDespesaTile` em `DespesasFixasScreen` poderia ser extraído para seu próprio arquivo de widget, tornando a tela principal mais limpa.
*   **Constantes:** Cores e estilos de texto que se repetem podem ser movidos para um arquivo de tema central (`lib/theme/app_theme.dart`), em vez de serem definidos localmente em cada widget.

## 6. Conclusão

O projeto "Horizon Finance" tem uma base sólida e bem estruturada. A escolha da stack tecnológica é moderna e adequada para o objetivo proposto. Os modelos de dados são completos e o fluxo de onboarding está bem definido, faltando apenas a implementação da lógica de comunicação com o backend e um gerenciamento de estado mais robusto para conectar todas as peças. O foco em responsividade desde o início (`responsive_theme.dart`) é um grande diferencial.