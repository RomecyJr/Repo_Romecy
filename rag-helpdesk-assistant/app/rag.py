import os
from pathlib import Path
from langchain_community.vectorstores import FAISS
from langchain_community.embeddings import HuggingFaceEmbeddings
from langchain.text_splitter import RecursiveCharacterTextSplitter
from langchain_community.document_loaders import TextLoader
from langchain.chains import RetrievalQA
from langchain_community.llms import HuggingFaceHub

def get_vector_store():
    kb_path = Path(__file__).parent / "kb"
    kb_path.mkdir(exist_ok=True)
    default_doc = kb_path / "helpdesk_policies.txt"
    if not default_doc.exists():
        default_doc.write_text(
            "Prioridades: P1 crítico, P2 alto, P3 médio.\n"
            "SLA: P1 resposta 15min, resolução 4h.\n"
            "Abertura de chamado via portal ou e-mail suporte@empresa.\n"
        )
    docs = []
    for f in kb_path.glob("*.txt"):
        docs.extend(TextLoader(str(f)).load())
    splitter = RecursiveCharacterTextSplitter(chunk_size=600, chunk_overlap=100)
    chunks = splitter.split_documents(docs)
    emb = HuggingFaceEmbeddings(model_name=os.getenv("EMB_MODEL","sentence-transformers/all-MiniLM-L6-v2"))
    return FAISS.from_documents(chunks, emb)

_vs = None
def answer_query(q: str) -> str:
    global _vs
    if _vs is None:
        _vs = get_vector_store()
    retriever = _vs.as_retriever(search_kwargs={"k": 4})
    llm = HuggingFaceHub(
        repo_id=os.getenv("HF_MODEL","google/flan-t5-base"),
        huggingfacehub_api_token=os.getenv("HF_TOKEN")
    )
    chain = RetrievalQA.from_chain_type(llm=llm, retriever=retriever)
    return chain.run(q)
