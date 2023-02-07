from prefect.infrastructure.docker import DockerContainer

docker_container_block = DockerContainer.load(
    image="ixcheldelsol/prefect:zoomcamp",
    image_pull_policy="Always",
    auto_remove=True,
)

docker_container_block.save("ixcheldelsol-container", overwrite=True)