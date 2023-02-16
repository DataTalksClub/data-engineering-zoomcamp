from prefect.deployments import Deployment
from parameterized_flow import etl_parameters
from prefect.infrastructure.docker import DockerContainer


docker_block = DockerContainer.load("zoom")

docker_dep = Deployment.build_from_flow(flow= etl_parameters,
    name='docker01v',
    infrastructure=docker_block
    )


if '__main__' == __name__:
    docker_dep.apply()
