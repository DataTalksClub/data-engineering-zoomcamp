from prefect_github import GitHubCredentials
from prefect_github.repository import query_repository
from prefect import flow

@flow(print_logs=True, retries=3)
def github_add_star_flow():
    github_credentials = GitHubCredentials.load("github-token")
    repository = query_repository(
        "PrefectHQ",
        "Prefect",
        github_credentials=github_credentials,
        return_fields="id"
    )
    import pdb; pdb.set_trace()
    return repository