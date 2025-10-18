# Ansible Infra Baseline
Playbooks de baseline/hardening (Linux) e updates (Windows).

## Requisitos
- Ansible 2.15+
- Acesso SSH/WinRM às máquinas de teste

## Execução
```bash
ansible-playbook -i inventories/dev/hosts.ini playbooks/linux_hardening.yml
ansible-playbook -i inventories/dev/hosts.ini playbooks/windows_updates.yml
```

## Observações
- Ajuste usuários/chaves em group_vars.
- Em Windows, configure WinRM previamente.
