CREATE TABLE IF NOT EXISTS fixed_transactions (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  usuario_id UUID NOT NULL,
  categoria_id BIGINT, 
  
  -- Dados da transação
  descricao VARCHAR(255) NOT NULL,
  valor DECIMAL(10, 2) NOT NULL,
  tipo TEXT NOT NULL CHECK (tipo IN ('RECEITA', 'DESPESA')),
  
  -- Regras de recorrência
  dia_do_mes INT NOT NULL CHECK (dia_do_mes >= 1 AND dia_do_mes <= 31),
  is_active BOOLEAN NOT NULL DEFAULT TRUE, -- Mapeia para @JsonKey(name: 'is_active')
  
  -- Controle de execução
  ultima_geracao TIMESTAMP, -- Mapeia para @JsonKey(name: 'ultima_geracao')
  data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

  -- Chaves Estrangeiras
  FOREIGN KEY (usuario_id) REFERENCES profiles(id) ON DELETE CASCADE,
  FOREIGN KEY (categoria_id) REFERENCES categories(id) ON DELETE SET NULL
);

-- Index para melhorar a performance da busca diária do Service
CREATE INDEX idx_fixed_transactions_user_active ON fixed_transactions(usuario_id, is_active);
CREATE INDEX idx_fixed_transactions_day ON fixed_transactions(dia_do_mes);