FROM jupyter/pyspark-notebook:x86_64-hadoop-3

USER root

# Configure IPython system-wide
COPY ipython_kernel_config.py "/etc/ipython/"
RUN fix-permissions "/etc/ipython/"

# Уточнить версии при необходимости!
RUN pip install 'pyspark==3.2.2'

# Переключиться на обычного пользователя перед дальнейшими действиями
USER ${NB_UID}

# Лучше попробовать установку с mamba:
RUN mamba install --yes \
    'grpcio-status' \
    'grpcio' \
    'pandas=2.0.3' \
    'pyarrow' && \
    mamba clean --all -f -y && \
    fix-permissions "${CONDA_DIR}" && \
    fix-permissions "/home/${NB_USER}"

WORKDIR "${HOME}"
EXPOSE 4040
