---
video_url: https://www.youtube.com/watch?v=XuPDQ1UcNyI
prev_url: 15-ai-copilot-in-kestra.md
next_url: 17-deploy-to-the-cloud.md
---
# Bonus: Retrieval Augmented Generation (RAG)

To further learn how to provide context to your prompts, this bonus section demonstrates how to use RAG.

## What is RAG?
**RAG (Retrieval Augmented Generation)** is a technique that:
1. **Retrieves** relevant information from your data sources
2. **Augments** the AI prompt with this context
3. **Generates** a response grounded in real data

This solves the hallucination problem by ensuring the AI has access to current, accurate information at query time.


*RAG adds a retrieval path between the question and the model so answers can be grounded in current source material.*

## How RAG Works in Kestra
```mermaid
graph LR
    A[Ask AI] --> B[Fetch Docs]
    B --> C[Create Embeddings]
    C --> D[Find Similar Content]
    D --> E[Add Context to Prompt]
    E --> F[LLM Answer]
```

**The Process:**
1. **Ingest documents**: Load documentation, release notes, or other data sources
2. **Create embeddings**: Convert text into vector representations using an LLM
3. **Store embeddings**: Save vectors in Kestra's KV Store (or a vector database)
4. **Query with context**: When you ask a question, retrieve relevant embeddings and include them in the prompt
5. **Generate response**: The LLM has real context and provides accurate answers

## Exercise: Retrieval With vs Without Context
**Objective:** Understand how RAG eliminates hallucinations by grounding LLM responses in real data.

**Part A: Without RAG**
1. Navigate to the [`10_chat_without_rag.yaml`](flows/10_chat_without_rag.yaml) flow in your Kestra UI
2. Click **Execute**
3. Wait for the execution to complete
4. Open the **Logs** tab
5. Read the output - notice how the response about "Kestra 1.1 features" is:
   - Vague or generic
   - Potentially incorrect
   - Missing specific details
   - Based only on the model's training data (which may be outdated)

**Part B: With RAG**
1. Navigate to the [`11_chat_with_rag.yaml`](flows/11_chat_with_rag.yaml) flow
2. Click **Execute**
3. Watch the execution:
   - First task: **Ingests** Kestra 1.1 release documentation, creates **embeddings** and stores them
   - Second task: **Prompts LLM** with context retrieved from stored embeddings
4. Open the **Logs** tab
5. Compare this output with the previous one - notice how it's:
   - ✅ Specific and detailed
   - ✅ Accurate with real features from the release
   - ✅ Grounded in actual documentation

**Key Learning:** RAG (Retrieval Augmented Generation) grounds AI responses in current documentation, eliminating hallucinations and providing accurate, context-aware answers.

### Try another Kestra release (optional)

1. For this run, ask **What changed for Namespace Files in Kestra 1.2?** Before running the flows, open the [release notes](https://kestra.io/blogs/release-1-2#revision-history-for-namespace-files) and save the URL and this sentence.

   > Namespace Files in Kestra 1.2 now support comprehensive version control with revision history.

2. Copy both flows under new flow IDs in your course namespace. Replace the user message in Part A (`messages[0].content`) and the prompt in Part B (`prompt`) with the same question above.
3. In Part B, replace the `ingest_release_notes.fromExternalURLs` entry with the [raw Markdown for the 1.2 release notes](https://raw.githubusercontent.com/kestra-io/docs/b4ea2486d47bf27270ac03b37462cd04351883e3/src/contents/blogs/release-1-2/index.md).
4. Run both flows and read the generated answer under the response heading in each log. Write down what each answer says about revision history and check it against the sentence you saved.

You can open both links in your browser. If you already use an MCP client, you can also check both URLs in one call with the keyless [Parallel Search MCP](https://docs.parallel.ai/integrations/mcp/installation). Add `https://mcp.parallel.ai/mcp` to your client as an HTTP server, then ask `web_fetch` to read both links with `full_content: true` and find the same sentence in each. If your client supports custom headers, set `User-Agent` to `data-engineering-zoomcamp-rag/1.0`.

## RAG Best Practices
1. **Keep documents updated**: Regularly re-ingest to ensure current information
2. **Chunk appropriately**: Break large documents into meaningful chunks
3. **Test retrieval quality**: Verify that the right documents are retrieved

## Additional AI Resources
Kestra Documentation:
- [AI Tools Overview](https://go.kestra.io/de-zoomcamp/ai-tools)
- [AI Copilot](https://go.kestra.io/de-zoomcamp/ai-copilot)
- [RAG Workflows](https://go.kestra.io/de-zoomcamp/rag-workflows)
- [AI Workflows](https://go.kestra.io/de-zoomcamp/ai-workflows)
- [Kestra Blueprints](https://go.kestra.io/de-zoomcamp/blueprints) - Pre-built workflow examples

Kestra Plugin Documentation:
- [AI Plugin](https://go.kestra.io/de-zoomcamp/ai-plugin)
- [RAG Tasks](https://go.kestra.io/de-zoomcamp/ai-rag-task)

External Documentation:
- [Google Gemini](https://go.kestra.io/de-zoomcamp/gemini-docs)
- [Google AI Studio](https://go.kestra.io/de-zoomcamp/ai-studio)

<!-- nav:start -->
[← Previous: AI Copilot in Kestra](15-ai-copilot-in-kestra.md) · [Next: Bonus: Deploy to the Cloud (Optional) →](17-deploy-to-the-cloud.md)
<!-- nav:end -->
