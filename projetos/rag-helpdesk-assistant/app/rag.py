def answer_query(q: str) -> str:
    """Versão simplificada para demonstração - funciona sem dependências de IA"""
    responses = {
        "sla": "SLA P1: resposta em 15 minutos, resolução em 4 horas. P2: resposta em 1 hora, resolução em 8 horas.",
        "p1": "P1 é prioridade crítica - indisponibilidade total do sistema. SLA: resposta 15min, resolução 4h.",
        "abrir chamado": "Para abrir chamado, acesse o portal de suporte ou envie email para suporte@empresa.com",
        "prioridades": "Temos 3 prioridades: P1 (crítico), P2 (alto), P3 (médio).",
    }

    q_lower = q.lower()
    for key, response in responses.items():
        if key in q_lower:
            return response

    return f"Base de conhecimento consultada. Pergunta recebida: '{q}'. Para mais informações, consulte a documentação completa ou abra um chamado."
