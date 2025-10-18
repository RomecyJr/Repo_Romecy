from fastapi import FastAPI
from pydantic import BaseModel
from .rag import answer_query

app = FastAPI(title="RAG Helpdesk Assistant")

class Ask(BaseModel):
    question: str

@app.get("/health")
def health():
    return {"status": "ok"}

@app.post("/ask")
def ask(payload: Ask):
    return {"answer": answer_query(payload.question)}
