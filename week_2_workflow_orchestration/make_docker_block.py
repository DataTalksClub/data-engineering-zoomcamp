from prefect.infrastructure.docker import DockerContainer

#alternative to creating DockerContainer block in the UI
docker_block = DockerContainer(
    image=mihrutochka/prefect:zoomcamp, 
    image=pull_policy="ALWAYS"
    auto_remove=True,
)

docker_block.save("zoomcamp", overwrite=True)

