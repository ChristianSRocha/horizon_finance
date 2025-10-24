create table if not exists fixed_transactions(
  id uuid PRIMARY KEY,
  usuario_id uuid NOT NULL,
  tipo TEXT NOT NULL CHECK (tipo IN ('RECEITA', 'DESPESA')),
  descricao VARCHAR(255) NOT NULL,
  valor DECIMAL(10, 2) NOT NULL,
  dia_do_mes INT NOT NULL,
  categoria_id BIGINT REFERENCES categories(id) ON DELETE SET NULL,
  status TEXT NOT NULL CHECK (status IN ('ATIVO', 'INATIVO')),
  data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (usuario_id) REFERENCES profiles(id) ON DELETE CASCADE
);