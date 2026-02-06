# DE Zoomcamp 4.1.1 — Analytics Engineering Basics

> 📄 Video: [Analytics Engineering Basics](https://www.youtube.com/watch?v=uF76d5EmdtU)  
> 📄 Further reading: [What is Analytics Engineering?](https://docs.getdbt.com/docs/introduction)  
> 📄 Kimball's Dimensional Modeling: *The Data Warehouse Toolkit* (Ralph Kimball & Margy Ross)

This is the kickoff video for Module 4. No hands-on coding here — it's all about setting the stage. Why does analytics engineering exist, what does it actually do, and what are the data modeling concepts we'll be leaning on for the rest of the module. Worth sitting with before diving into the dbt stuff.

---

## Why analytics engineering exists

A few shifts in the data world created a gap that nobody was filling:

- **Cloud data warehouses** (BigQuery, Snowflake, Redshift) made storage and compute cheap. You no longer have to be surgical about what data you load.
- **EL tools** like Fivetran and Stitch made getting data into the warehouse almost trivial — the extract and load steps are basically automated now.
- **SQL-first BI tools** like Looker brought version control into the data workflow. And tools like Mode enabled self-service analytics for business users.
- **Data governance** became a bigger conversation as more people started touching data.

All of this changed how data teams work and how stakeholders consume data. But it left a gap between the people building the infrastructure and the people using the data.

### The traditional data team

In the old model you had three roles and a pretty clean split:

- **Data Engineer** — builds and maintains the infrastructure. Great software engineer, but not necessarily close to how the business actually uses the data.
- **Data Analyst** — uses the data to answer questions and solve business problems. Understands the business well, but not trained as a software engineer.
- **Data Scientist** — similar story to the analyst. Writing more and more code these days, but software engineering best practices weren't part of the training.

### The gap

Analysts and scientists are writing more code, but they weren't trained for it. Engineers are great at building systems, but they don't always know how the data gets consumed downstream. Nobody was bridging that gap.

### Analytics Engineer

The analytics engineer is the bridge. They bring software engineering best practices — version control, testing, documentation, modularity — into the work that analysts and scientists are already doing. It's a role that sits at the intersection of the data engineer and the data analyst.

In terms of the toolchain, an analytics engineer might touch:

- **Data loading** — tools like Fivetran, Stitch (the EL layer)
- **Data storing** — cloud data warehouses, shared territory with data engineers
- **Data modeling** — this is the core of it. Tools like dbt or Dataform. This is where most of Module 4 lives.
- **Data presentation** — BI tools like Google Looker Studio. The end product that business users actually see.

The focus this week is on modeling and presentation — everything in between "data is in the warehouse" and "business user sees a dashboard."

---

## ETL vs ELT — a quick recap

Two philosophies for getting data transformed and ready:

**ETL (Extract → Transform → Load)** — you transform the data *before* it hits the warehouse. Takes longer to set up because the transformation logic has to be built first, but the data in the warehouse is clean and stable from day one.

**ELT (Extract → Load → Transform)** — you load the raw data first, then transform it *inside* the warehouse. Faster and more flexible. This is the approach that cloud warehouses made possible — storage is cheap, so just load everything and figure out the transformations later.

ELT is the dominant approach now, and it's the one we'll be working with. dbt fits squarely into the "T" of ELT — it runs transformations inside the warehouse using SQL.

---

## Dimensional Modeling — the key concepts

This is Kimball's framework, and it's the main mental model for how we'll structure our data this week. The goal is twofold: make the data **understandable to business users**, and make **queries fast**.

Note: unlike third normal form (3NF), dimensional modeling deliberately allows some data redundancy. The priority is usability and performance, not eliminating duplication.

### Fact tables vs Dimension tables (Star Schema)

The two building blocks:

- **Fact tables** — measurements, metrics, business events. Think of them as **verbs**. "A sale happened." "An order was placed." They correspond to a business process.
- **Dimension tables** — the context around those facts. Think of them as **nouns**. "Who bought it? What product? When?" They correspond to a business entity like a customer or a product.

Together they form a **star schema** — the fact table in the center, dimension tables radiating out around it. It's the classic layout you'll see in most data warehouses.

### The Kitchen Analogy

Kimball's book uses a restaurant analogy to describe how data flows through a warehouse. It maps pretty cleanly onto what we'll be doing in the project:

- **Staging area (the pantry)** — raw data lands here. Not meant for business users. Only people who know what they're doing should be poking around in it.
- **Processing area (the kitchen)** — this is where raw data gets transformed into proper data models. Again, limited to the people doing the cooking — the data engineers and analytics engineers. The focus here is on efficiency and following standards.
- **Presentation area (the dining hall)** — the final, polished output. This is what business stakeholders actually see and interact with. Clean, structured, ready to consume.

We'll be building exactly this layered structure in our dbt project throughout the module.