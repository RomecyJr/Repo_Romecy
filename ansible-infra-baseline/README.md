# 🛡️ Ansible Infra Baseline

![Status](https://img.shields.io/badge/status-active-success.svg)
![CI](https://github.com/OWNER/REPO/actions/workflows/ansible-ci.yml/badge.svg)
![Ansible](https://img.shields.io/badge/ansible-2.16+-black.svg)
![License](https://img.shields.io/badge/license-MIT-blue.svg)

Baseline de infraestrutura com Ansible para padronizar sistemas Linux, endurecer segurança, configurar auditoria, usuários/grupos, pacotes, serviços e conformidade CIS.

## ✨ Recursos
- Hardening CIS e benchmarks recomendados
- SSH seguro, firewall, fail2ban, auditd e logrotate
- Regras de usuários, sudoers, política de senhas (PAM)
- Repositórios, pacotes e serviços essenciais
- Suporte a Debian/Ubuntu, RHEL/CentOS, Rocky, Amazon Linux

## 📂 Estrutura
```
ansible-infra-baseline/
├── inventories/
│   ├── dev/
│   └── prod/
├── playbooks/
│   ├── site.yml
│   └── hardening.yml
├── roles/
│   ├── common/
│   ├── security/
│   ├── ssh/
│   ├── audit/
│   └── compliance/
├── group_vars/
├── host_vars/
└── README.md
```

## 🚀 Início Rápido

### Requisitos
- Ansible 2.16+
- Python 3.9+
- Acesso SSH aos hosts

### Configuração
1. Edite o inventário:
```ini
# inventories/dev/hosts
[web]
10.0.0.10 ansible_user=ubuntu ansible_ssh_private_key_file=~/.ssh/id_rsa
```

2. Defina variáveis:
```yaml
# group_vars/all.yml
timezone: America/Sao_Paulo
users:
  - name: devops
    groups: [sudo]
    ssh_key: "ssh-ed25519 AAAA..."
```

3. Execute o baseline:
```bash
ansible-playbook -i inventories/dev playbooks/site.yml -K
```

## 📘 Playbooks

- playbooks/site.yml
```yaml
- hosts: all
  become: true
  roles:
    - role: common
    - role: security
    - role: ssh
    - role: audit
```

- playbooks/hardening.yml
```yaml
- hosts: all
  become: true
  roles:
    - role: compliance
      tags: [cis]
```

## 🔐 Variáveis Principais
```yaml
security:
  ssh:
    permit_root_login: "no"
    password_authentication: "no"
  firewall:
    enabled: true
    inbound_allow:
      - 22
      - 80
      - 443
password_policy:
  minlen: 12
  retry: 3
  unlock_time: 600
```

## ✅ Testes e CI
- Molecule + Docker para testes de roles
- GitHub Actions para lint (ansible-lint) e execução de Molecule

```yaml
# .github/workflows/ansible-ci.yml
name: Ansible CI
on: [push, pull_request]
jobs:
  lint:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: ansible/ansible-lint-action@main
  molecule:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Install deps
        run: pip install molecule[docker] ansible
      - name: Run tests
        run: molecule test
```

![Relatório Molecule](docs/screenshots/molecule-report.png)

## 🧩 Extensões
- Integração com OpenSCAP para relatórios de conformidade
- Relatórios HTML de hardening pós-execução

## 🧭 Roadmap
- [ ] Suporte SUSE e Arch
- [ ] Modo dry-run semanal (cron)
- [ ] Inventário dinâmico (AWS/GCP)

## 📝 Licença
MIT License

---

Badges:
- ![CI](https://github.com/OWNER/REPO/actions/workflows/ansible-ci.yml/badge.svg)

Última atualização: Outubro 2025
