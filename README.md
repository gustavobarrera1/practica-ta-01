# Crear entorno
python3 -m venv env

# Activar
source env/bin/activate

# Desactivar
deactivate

# Crear archivo requirements

pip3 freeze > requirements.txt

# Instalar entorno con requirements

pip3 install -r requirements.txt


# Deployar app

kubectl apply -f deployment.yaml -n monitoring

kubectl apply -f servicemonitor.yaml -n monitoring
