## Build / develop the Sindbad docs

The docs site is built by Julia (`DocumenterVitepress`) and served/bundled by Node (`vitepress`).

```sh
cd docs
```
### Prereqs

- **Node**: install via your system package manager or from `https://nodejs.org/en`
- **Julia**: compatible with the `docs/Manifest.toml` in this repo

### Install Node deps

```sh
npm ci
```

## Build the documentation

From the repo root (or from `docs/`), run:

```sh
julia --project=docs -e 'include("docs/make.jl")'
```

This will:

- instantiate/precompile the `docs/` Julia environment
- generate doc pages (models / libs / extensions)
- build the static site output under `docs/build/`

## Start a local dev server

After the Julia build step above, run:

```sh
npm run docs:dev
```

Then open the local URL printed by Vitepress (typically `http://localhost:5173/`).

## Build directly

Also, if all `md` files are already available, the following should also work

```sh
npm run docs:build
```

and to get a `preview` 

```sh
npm run docs:preview
```
___