import marimo

__generated_with = "0.19.9"
app = marimo.App(width="medium")


@app.cell
def _():
    import marimo as mo
    import dlt
    import ibis
    import altair as alt
    from dlt.helpers.marimo import render, load_package_viewer

    return alt, dlt, ibis, load_package_viewer, mo, render


@app.cell
def _(mo):
    mo.md(r"""
    # 📚 Open Library Harry Potter Books Analysis

    This notebook analyzes Harry Potter-related books from the Open Library API using dlt's dataset interface.
    """)
    return


@app.cell
def _(dlt):
    # Access the pipeline and dataset using dlt's native interface
    pipeline = dlt.attach("open_library_pipeline")
    dataset = pipeline.dataset()
    # Get ibis connection for rich data exploration
    ibis_con = dataset.ibis()
    return (ibis_con,)


@app.cell
async def _(load_package_viewer, render):
    # Display the dlt package viewer widget
    await render(load_package_viewer)
    return


@app.cell
def _(mo):
    mo.md(r"""
    ## 📊 Books by Author
    """)
    return


@app.cell
def _(alt, ibis, ibis_con):
    # Query for books by author (top 15) using ibis
    author_table = ibis_con.table("books__author_name")
    author_query = (
        author_table
        .group_by("value")
        .agg(book_count=author_table.value.count())
        .order_by(ibis.desc("book_count"))
        .limit(15)
    )
    author_df = author_query.to_pandas()
    author_df = author_df.rename(columns={"value": "author"})

    # Bar chart for authors
    author_chart = alt.Chart(author_df).mark_bar(color="#6366f1").encode(
        x=alt.X("book_count:Q", title="Number of Books"),
        y=alt.Y("author:N", sort="-x", title="Author"),
        tooltip=["author", "book_count"]
    ).properties(
        title="Top 15 Authors by Number of Books",
        width=600,
        height=400
    )
    author_chart
    return


@app.cell
def _(mo):
    mo.md(r"""
    ## 📈 Books Published Per Year
    """)
    return


@app.cell
def _(alt, ibis_con):
    # Query for books by year using ibis
    books_table = ibis_con.table("books")
    year_query = (
        books_table
        .filter((books_table.first_publish_year >= 1997) & (books_table.first_publish_year <= 2025))
        .group_by("first_publish_year")
        .agg(books=books_table.first_publish_year.count())
        .order_by("first_publish_year")
    )
    year_df = year_query.to_pandas()
    year_df = year_df.rename(columns={"first_publish_year": "year"})

    # Line chart for publication years
    year_chart = alt.Chart(year_df).mark_line(
        point=True,
        color="#10b981"
    ).encode(
        x=alt.X("year:O", title="Year"),
        y=alt.Y("books:Q", title="Number of Books"),
        tooltip=["year", "books"]
    ).properties(
        title="Harry Potter-Related Books Published Per Year (1997-2025)",
        width=700,
        height=350
    )
    year_chart
    return


@app.cell
def _(mo):
    mo.md(r"""
    ## 🌍 Books by Language
    """)
    return


@app.cell
def _(alt, ibis, ibis_con):
    # Query for books by language using ibis
    lang_table = ibis_con.table("books__language")
    lang_query = (
        lang_table
        .group_by("value")
        .agg(count=lang_table.value.count())
        .order_by(ibis.desc("count"))
        .limit(10)
    )
    language_df = lang_query.to_pandas()

    # Map language codes to full names
    lang_map = {
        'eng': 'English', 'ger': 'German', 'fre': 'French',
        'spa': 'Spanish', 'ita': 'Italian', 'chi': 'Chinese',
        'por': 'Portuguese', 'rus': 'Russian', 'kor': 'Korean', 'pol': 'Polish'
    }
    language_df["language"] = language_df["value"].map(lambda x: lang_map.get(x, x))

    # Pie chart for languages
    language_chart = alt.Chart(language_df).mark_arc(innerRadius=50).encode(
        theta=alt.Theta("count:Q", title="Count"),
        color=alt.Color("language:N", title="Language", scale=alt.Scale(scheme="tableau10")),
        tooltip=["language", "count"]
    ).properties(
        title="Proportion of Books by Language (Top 10)",
        width=400,
        height=400
    )
    language_chart
    return


@app.cell
def _(mo):
    mo.md(r"""
    ## 📋 Summary Statistics

    Key insights from the Open Library Harry Potter books dataset.
    """)
    return


@app.cell
def _(ibis_con, mo):
    # Get summary stats using ibis
    total_books = ibis_con.table("books").count().to_pandas()
    total_authors = ibis_con.table("books__author_name").value.nunique().to_pandas()
    total_languages = ibis_con.table("books__language").value.nunique().to_pandas()

    mo.md(f"""
    | Metric | Value |
    |--------|-------|
    | **Total Books** | {total_books:,} |
    | **Unique Authors** | {total_authors:,} |
    | **Languages** | {total_languages} |
    """)
    return


@app.cell
def _():
    return


@app.cell
def _():
    return


if __name__ == "__main__":
    app.run()
