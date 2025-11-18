create table if not exists fixed_transaction_templates(
  id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  usuario_id uuid NOT NULL,
  tipo TEXT NOT NULL CHECK (tipo IN ('RECEITA', 'DESPESA')),
  descricao VARCHAR(255) NOT NULL,
  valor DECIMAL(10, 2) NOT NULL,
  dia_do_mes INT NOT NULL CHECK (dia_do_mes >= 1 AND dia_do_mes <= 31),
  categoria_id BIGINT REFERENCES categories(id) ON DELETE SET NULL,
  ativo BOOLEAN NOT NULL DEFAULT TRUE,
  data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (usuario_id) REFERENCES profiles(id) ON DELETE CASCADE
);

-- Índice para buscar templates ativos de um usuário
CREATE INDEX idx_templates_usuario_ativo 
ON fixed_transaction_templates(usuario_id, ativo);