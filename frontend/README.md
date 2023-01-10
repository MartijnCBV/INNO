# INNO-Frontend-Elm

Compile: 
```shell
elm make --output=main.js
```

Compile for production:
```shell
elm make --optimize --output=main.js
```

compile with debug:
```shell
elm make --debug --output=main.js
```

run dev server:
```shell
elm-live src/Main.elm --port 1234 --hot -- --output=main.js
```

run dev server with debug:
```shell
elm-live src/Main.elm --port 1234 --hot -- --debug --output=main.js
```

Review:
```shell
elm-review src/*
```