import { buildSync } from "esbuild";

buildSync({
  entryPoints: ["src/app.ts"],
  bundle: true,
  sourcemap: true,
  treeShaking: true,
  minify: false,
  outfile: "dist/bundle.mjs",
  target: "esnext",
  platform: "node",
  packages: "external",
  format: "esm",
});
