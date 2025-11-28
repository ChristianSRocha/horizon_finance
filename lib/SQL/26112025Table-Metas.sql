CREATE TABLE IF NOT EXISTS metas (
  id uuid PRIMARY KEY,
  usuario_id uuid REFERENCES auth.users NOT NULL,
  nome text NOT NULL,
  descricao text,
  valor_total decimal(10,2) NOT NULL,
  valor_atual decimal(10,2) NOT NULL DEFAULT 0,
  data_final timestamp,
  data_criacao timestamp DEFAULT current_timestamp
);

ALTER TABLE metas ENABLE ROW LEVEL SECURITY;

create policy "Users can select own metas" on metas for select using (auth.uid() = usuario_id);
create policy "Users can insert own metas" on metas for insert with check (auth.uid() = usuario_id);
create policy "Users can update own metas" on metas for update using (auth.uid() = usuario_id);
create policy "Users can delete own metas" on metas for delete using (auth.uid() = usuario_id);


