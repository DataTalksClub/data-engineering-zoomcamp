FROM mageai/mageai:latest

ARG USER_CODE_PATH=/home/src/${PROJECT_NAME}

# Note: this overwrites the requirements.txt file in your new project on first run. 
# You can delete this line for the second run :) 
COPY requirements.txt ${USER_CODE_PATH}requirements.txt 
RUN mkdir -p /home/src/.secrets
COPY ./.secrets/nyc-rides-ella-d8109977b99b.json /home/src/.secrets/
# RUN mv /home/src/secrets/ /home/src/.secrets/
# RUN mv /home/src/nyc-rides-ella-d8109977b99b.json /home/src/.secrets/

RUN pip3 install -r ${USER_CODE_PATH}requirements.txt
