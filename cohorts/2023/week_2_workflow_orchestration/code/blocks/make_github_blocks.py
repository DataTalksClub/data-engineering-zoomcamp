from prefect.filesystems import GitHub

github_block = GitHub(name="github-storage", repository="https://github.com/MichalGasiorowski/data-engineering-zoomcamp")
github_block.save("github-storage", overwrite=True)
