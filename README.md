# Motoko Tasker

Bienvenido a mi proyecto de certificación para la certificación ICP Developer I 

La idea es muy simple, un servicio donde se puedan crear muchas tareas (Taks) por usuario, puedas actualizar su estatus a completadas, siempre validando que solo el usuario creador pueda obtenerlas y actualizarlas, las funciones disponibles son:

-createUserTask: crea una nueva task con base a una descripción
-getTaskById: obtiene una task con base a un id enviado
-getUserTaks: obtiene todas las tasks creadas por el usuario
-UpdateTask: actualiza una task con base al id enviado

## Prerequisitos

- Contar con Mac/Linux o o WSL2<- super importante, en caso de contar con computadoras con windows.
- Tener descargado e instalada la herramienta dfx de Dfinity

```bash
sh -ci "$(curl -fsSL https://internetcomputer.org/install.sh)"
```

- Tener detenido algun servicio de Internet Computer o otro proceso de red que tenga en uso el puerto 8000.

## Corre este proyecto de forma local

Para correr este proyecto localmente asegurate de utiizar los siguientes comandos:

### 1. Inicia una replica de Internet Computer en segundo plano.

```bash
# Una replica es una instancia local que ejecuta una copia del estado del canister
dfx start --background
```

### 2. Abre una nueva ventana de tu terminal.

### 3. Reserva un identificador para tu Canister

```bash
dfx canister create motoko_tasker_backend
```

### 4. Compila y constuye el archivo wasm de tu Canister

```bash
dfx build
```

### 5. Despliega tu canister en la replica y genera la interfaz candid para consumir tu canister de forma visual

```bash
dfx deploy
```

## Realiza cambios en tu canister

Si has realizado cambios en tu archivo main.mo deberas compilar y actualizar tu canister.

```bash
# Compila de nuevo tu proyecto
dfx build

# Instala el archivo wasm generado de la compilación en tu canister
dfx canister install --all --mode upgrade

```

Una vez desplegado te dará la dirección a revisar
