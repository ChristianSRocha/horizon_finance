# Horizon Finance

![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)

Um aplicativo de finanças pessoal, open source e focado em simplicidade, que não apenas rastreia seus gastos, mas também projeta a saúde financeira do seu futuro.

## 🎯 Sobre o Projeto

A maioria das ferramentas de controle financeiro falha por ser complexa demais ou por exigir um esforço manual muito grande. Este projeto nasceu para resolver esse problema, oferecendo uma experiência de usuário fluida e intuitiva, com um diferencial claro: **análise preditiva**.

O objetivo é capacitar os usuários a tomarem decisões mais inteligentes, fornecendo uma visão clara do passado, presente e, mais importante, do futuro de suas finanças.

### ✨ Funcionalidades Principais (MVP)

* **📊 Dashboard Preditivo:** Visualize seu saldo atual e veja uma projeção de como ele estará nos próximos 30, 60 ou 90 dias com base nos seus hábitos.
* **💸 Registro Simplificado:** Adicione receitas e despesas de forma rápida, com um sistema de categorização inteligente.
* **🔄 Transações Recorrentes:** Cadastre aluguéis, assinaturas e outras contas fixas uma única vez.
* **🏆 Metas Visuais:** Crie metas financeiras e acompanhe seu progresso de forma motivadora.
* **📄 Importação de Extratos:** Comece a usar rapidamente importando seus extratos bancários em formato CSV/OFX.

## 🛠️ Tecnologias Utilizadas

A arquitetura do projeto foi escolhida com foco em performance, desenvolvimento ágil, baixo custo e na filosofia open source.

* **Frontend (Mobile):** [**Flutter**](https://flutter.dev/) - Para um desenvolvimento multiplataforma (iOS & Android) com um único código-base.
* **Backend:** [**Supabase**](https://supabase.io/) - Uma alternativa open source ao Firebase, oferecendo banco de dados, autenticação, e Edge Functions.
* **Banco de Dados:** [**PostgreSQL**](https://www.postgresql.org/) - Robusto, confiável e escalável, é o coração do Supabase.
* **Infraestrutura:** [**Docker**](https://www.docker.com/) - Para facilitar a configuração do ambiente de desenvolvimento e permitir a auto-hospedagem (self-hosting).

## 🚀 Como Começar (Ambiente de Desenvolvimento)

Para rodar este projeto localmente, você precisará ter o Docker e o Docker Compose instalados.

1.  **Clone o repositório:**
    ```bash
    git clone https://github.com/](https://github.com/)matheusoms/horizon_finance.git](https://github.com/matheusoms/horizon_finance.git
    ```

2.  **Navegue até o diretório do projeto:**
    ```bash
    cd horizon_finance
    ```

3.  **Configure as variáveis de ambiente:**
    * Renomeie o arquivo `.env.example` para `.env`.
    * Preencha as variáveis necessárias conforme as instruções no próprio arquivo.

4.  **Inicie os containers com Docker Compose:**
    ```bash
    docker-compose up -d
    ```

5.  **Comece a desenvolver com Flutter:**
    * Certifique-se de ter o Flutter instalado e configurado.
    * Execute o app em um emulador ou dispositivo físico.
    ```bash
    flutter run
    ```

## 🤝 Como Contribuir

Este é um projeto de código aberto e contribuições são muito bem-vindas! Se você tem alguma ideia, sugestão ou quer corrigir um bug, sinta-se à vontade para:

1.  Fazer um **Fork** deste repositório.
2.  Criar uma nova **Branch** (`git checkout -b feature/sua-feature-incrivel`).
3.  Fazer o **Commit** das suas alterações (`git commit -m 'Adiciona sua feature incrível'`).
4.  Fazer o **Push** para a Branch (`git push origin feature/sua-feature-incrivel`).
5.  Abrir um **Pull Request**.

Por favor, leia nosso arquivo `CONTRIBUTING.md` para mais detalhes sobre nosso código de conduta.

## 📄 Licença

Este projeto está sob a licença MIT. Veja o arquivo [LICENSE](LICENSE.md) para mais detalhes.
