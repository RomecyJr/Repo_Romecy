from prometheus_client import start_http_server, Gauge
import random, time, os

g_open = Gauge('itsm_open_tickets', 'Chamados abertos (mock)', ['source','priority'])
g_mttr = Gauge('itsm_mttr_hours', 'MTTR em horas (mock)', ['source'])
g_tma  = Gauge('itsm_tma_minutes', 'TMA em minutos (mock)', ['source'])

def fetch_mock(source):
    return {
        "open_p1": random.randint(0, 5),
        "open_p2": random.randint(3, 15),
        "mttr": round(random.uniform(1.5, 7.5), 2),
        "tma": round(random.uniform(5, 30), 1),
    }

def loop():
    sources = os.getenv("SOURCES","jira,tiflux,otrs").split(",")
    while True:
        for s in sources:
            data = fetch_mock(s)
            g_open.labels(s,'P1').set(data["open_p1"])
            g_open.labels(s,'P2').set(data["open_p2"])
            g_mttr.labels(s).set(data["mttr"])
            g_tma.labels(s).set(data["tma"])
        time.sleep(15)

if __name__ == "__main__":
    start_http_server(9108)
    loop()
