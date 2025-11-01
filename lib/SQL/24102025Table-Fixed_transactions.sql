create table if not exists transactions(
  id uuid PRIMARY KEY,
  usuario_id uuid NOT NULL,
  tipo TEXT NOT NULL CHECK (tipo IN ('RECEITA', 'DESPESA')),
  descricao VARCHAR(255) NOT NULL,
  valor DECIMAL(10, 2) NOT NULL,
  dia_do_mes INT,
  data TIMESTAMP,
  fixed_transaction BOOL NOT NULL,
  categoria_id BIGINT REFERENCES categories(id) ON DELETE SET NULL,
  status TEXT NOT NULL CHECK (status IN ('ATIVO', 'INATIVO')) DEFAULT('ATIVO'),
  data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (usuario_id) REFERENCES profiles(id) ON DELETE CASCADE
  -- Restrição para garantir a integridade dos dados
  CONSTRAINT check_transaction_type
  CHECK (
    (fixed_transaction = TRUE AND dia_do_mes IS NOT NULL AND data IS NULL) OR
    (fixed_transaction = FALSE AND data IS NOT NULL AND dia_do_mes IS NULL)
  )
);