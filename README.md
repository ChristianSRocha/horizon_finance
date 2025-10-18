# Horizon Finance

**Seu futuro financeiro começa aqui.**

Horizon Finance é uma aplicação mobile de controle financeiro pessoal, focada em simplicidade, visualização de dados e análise preditiva. O projeto visa resolver a baixa aderência de usuários a ferramentas de controle financeiro, que muitas vezes são complexas ou exigem inserção manual de dados em planilhas.

Nossa principal proposta é transportar o controle financeiro para a palma da sua mão, simplificando ao máximo o registro de transações e oferecendo um diferencial claro: a **capacidade de prever sua saúde financeira futura** com base em seus hábitos, ajudando você a tomar decisões mais informadas.

## 🎯 Proposta do Projeto

O objetivo geral do Horizon Finance é desenvolver uma aplicação mobile multiplataforma (iOS e Android) que permita ao usuário ter uma visualização clara de suas finanças passadas, presentes e **futuras**.

O projeto ataca duas dores principais:
1.  **Alta Fricção:** A dificuldade e a falta de praticidade em registrar gastos diários, que leva ao abandono de ferramentas de controle.
2.  **Visão Reativa:** Ferramentas tradicionais focam apenas no "o que você gastou". Nós focamos em "para onde você está indo", permitindo ajustes de curso antes que os problemas ocorram.

## 🛠️ Arquitetura e Tecnologias

A arquitetura foi escolhida visando performance, desenvolvimento ágil, custos operacionais nulos ou baixos e a filosofia de código aberto.

* **Frontend (Mobile):** **Flutter**
    * **Por quê?** Framework de código aberto que nos permite compilar para iOS e Android a partir de um único código-base, garantindo agilidade no desenvolvimento e performance nativa.
    * **Gerenciamento de Estado:** **Provider**, para uma gestão de estado reativa e desacoplada da UI.

* **Backend (BaaS):** **Supabase (Cloud)**
    * **Por quê?** É uma plataforma "Backend-as-a-Service" open-source que nos fornece instantaneamente toda a infraestrutura necessária, hospedada na nuvem.

* **Banco de Dados:** **PostgreSQL**
    * **Por quê?** É o banco de dados padrão do Supabase, conhecido por sua robustez e escalabilidade, ideal para dados financeiros estruturados. A segurança é garantida por políticas de **Row Level Security (RLS)**, assegurando que cada usuário só possa acessar seus próprios dados.

* **Lógica de Servidor (Serverless):** **Supabase Edge Functions**
    * **Por quê?** Usadas para executar lógica de negócio customizada (escrita em TypeScript), como calcular resumos de relatórios ou, principalmente, atuar como um *broker* seguro para chamadas a APIs de terceiros.

* **Inteligência Artificial (IA):** **Gemini API**
    * **Por quê?** Utilizada para fornecer os insights preditivos e generativos. A API é chamada de forma segura através de uma Edge Function, que envia o histórico financeiro anonimizado do usuário e recebe em troca uma análise e dicas.

## ✨ Funcionalidades (MVP + IA)

O escopo do produto visa entregar um ciclo de valor completo, desde o cadastro até a análise preditiva.

* **Autenticação e Onboarding:**
    * Cadastro de usuário e autenticação (Email/Senha).
    * Configuração inicial guiada para cadastro de renda mensal e despesas fixas recorrentes.

* **Dashboard Preditivo (Core):**
    * Visualização clara do **saldo atual**.
    * Gráfico de **projeção de saldo** para os próximos 90 dias, baseado nos hábitos atuais do usuário.
    * Listagem de atividades recentes.

* **Gerenciamento de Transações (CRUD):**
    * Formulário simplificado para registro rápido de receitas e despesas manuais.
    * Sistema de categorização de transações (Moradia, Lazer, etc.).
    * Edição e exclusão de lançamentos.

* **Relatórios Visuais:**
    * Resumo de receitas, despesas e saldo por período.
    * Gráfico de despesas por categoria (pizza ou rosca).
    * Comparativo de fluxo semanal (Receita vs. Despesa).

* **Metas Financeiras:**
    * Criação de metas de poupança (ex: "Viagem", "Reserva de Emergência").
    * Acompanhamento visual do progresso para cada meta.

* **Insights com IA (O Diferencial):**
    * O app utiliza a API do Gemini para analisar o histórico de transações do usuário.
    * O usuário recebe **insights generativos e dicas** (ex: "Notei que seus gastos com 'Transporte' estão 20% acima da média" ou "Seu saldo atual sugere que você atingirá sua meta em 3 meses").

## 🌊 Fluxograma da Arquitetura (IA)

Este diagrama de sequência ilustra o fluxo principal de dados para obter a análise preditiva da IA, desde a requisição do usuário no app Flutter até a resposta da API do Gemini, orquestrada pelo Supabase.

```mermaid
sequenceDiagram
    participant User as Usuário (App Flutter)
    participant Supabase_Auth as Supabase (Autenticação)
    participant Supabase_DB as Supabase (Banco de Dados)
    participant Edge_Function as Supabase (Edge Function)
    participant Gemini as Gemini API

    User->>Supabase_Auth: 1. Login/Requisição com Token JWT
    Supabase_Auth-->>User: Token Validado

    User->>Edge_Function: 2. Chama a função `get-financial-forecast`
    Note over Edge_Function: A função extrai o ID do usuário do Token JWT

    Edge_Function->>Supabase_DB: 3. Busca o histórico de transações<br/>(SELECT * WHERE user_id = 'ID_do_usuário')
    Note over Supabase_DB: RLS garante que a função<br/>só acesse os dados do usuário correto
    Supabase_DB-->>Edge_Function: 4. Retorna o histórico do usuário

    Edge_Function->>Gemini: 5. Envia o histórico (JSON) para análise<br/>(chamada de API stateless)
    Gemini-->>Edge_Function: 6. Retorna a projeção e os insights (JSON)

    Edge_Function-->>User: 7. Envia o resultado final para o App

    User->>User: 8. Renderiza o gráfico e exibe os insights