-- Script de inicialização do banco de dados
-- Criar tabela produtos se não existir

CREATE TABLE IF NOT EXISTS produtos (
    id BIGSERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    preco DECIMAL(10,2) NOT NULL,
    descricao VARCHAR(500)
);

-- Inserir alguns dados de exemplo
INSERT INTO produtos (nome, preco, descricao) VALUES 
('Notebook Dell Inspiron', 2500.99, 'Notebook Dell Inspiron 15 com 8GB RAM e SSD 256GB'),
('Mouse Logitech', 89.90, 'Mouse óptico sem fio Logitech M170'),
('Teclado Mecânico', 299.99, 'Teclado mecânico RGB com switches Cherry MX Blue')
ON CONFLICT DO NOTHING;

-- Verificar se os dados foram inseridos
SELECT COUNT(*) as total_produtos FROM produtos;

