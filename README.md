# Agendaki: App de Agendamentos de espaço

## Requerimentos

### Fluxo de Telas:
 - Tela de Login
 - Tela de Cadastro/Visualização de Espaços
 - Tela de Agendamento
 - Tela de Minhas Reservas
 - Tela de Administração
### Estrutura do Banco:
 - usuarios: {id, nome, email, tipo}
 - espacos: {id, nome, descricao, disponibilidade[]}
 - agendamentos: {id, espaco_id, usuario_id, data_hora, status}
### Bibliotecas:
 - table_calendar
 - cloud_firestore
 -firebase_auth
### Integrações:
 -Firebase
 - EmailJS ou Firebase Functions para envio de confirmação


## Equipe
    - Nalyson: frontend
    - Aiko: backend
    - Kennedy: frontend
    - Souzinha: frontend
    - Kaik: backend

### Prazo: dia 30/06