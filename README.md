
## JENKINS

1. Ingresar https://labs.play-with-docker.com
2. Agregar una nueva instancia.
3. En la consola ejecutar el siguiente comando:

    - git clone https://github.com/sixeyed/pi.git && cd pi && git checkout bday7
    - docker-compose -f jenkins.yml up -d
4. Ingresar al contenedor
    - docker stats
    - copiar el containerID
    - docker exec -it 1a4aecde4c74 sh
5. Ejecutar los siguientes comandos.
    - apk add --no-cache python3 py3-pip && pip3 install --upgrade pip && pip3 install awscli && rm -rf /var/cache/apk
    - wget https://releases.hashicorp.com/terraform/0.14.4/terraform_0.14.4_linux_amd64.zip -O file.zip
    - unzip file.zip 
    - mv terraform /usr/bin/
    - apk add jq
6. Crear llaves de autenticación.
    - ssh-keygen
    - cat ~/.ssh/id_rsa.pub e importar a Github: https://docs.github.com/es/github/authenticating-to-github/adding-a-new-ssh-key-to-your-github-account
8. Agregar Access Key y Secret Key AWS
9. Ingresar a Jenkins usuario:pi password:pi
10. Agregar plugins Administrar Jenkins> Administrar Plugins> Todos los plugins:
    - Build Timestamp
    - ansiColor
    - Workspace Cleanup
    Selecionar: "descargar ahora e instalar despues de reiniciar"
11. Configurar el Jenkis Administrar Jenkins> Congiurar el sistema > BUILD_TIMESTAMP
    - Timezone: America/Lima
    - Pattern: yyMMddHHmmss
12. Agregar Job: Nueva tarea> Ingresan el nombre del JOB> Pipeline
13. Agregar repositorio: Pipeline> Definition: Pipeline script from SCM > SCM: GIT > Repository URL: (agregan el repositorio de github)



2. Click the README.md link from the list of files.
3. Click the **Edit** button.
4. Delete the following text: *Delete this line to make a change to the README from Bitbucket.*
5. After making your change, click **Commit** and then **Commit** again in the dialog. The commit page will open and you’ll see the change you just made.
6. Go back to t