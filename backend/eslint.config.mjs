import globals from 'globals'
import pluginJs from '@eslint/js'
import tsEslint from 'typescript-eslint'
import eslintJest from 'eslint-plugin-jest'
import prettierConfig from 'eslint-config-prettier'

/** @type {import('eslint').Linter.Config[]} */
export default [
  { files: ['**/*.{js,mjs,cjs,ts}'] },
  { files: ['**/*.js'], languageOptions: { sourceType: 'commonjs' } },
  { languageOptions: { globals: globals.browser, parser: tsEslint.parser } },
  pluginJs.configs.recommended,
  tsEslint.configs.eslintRecommended,
  eslintJest.configs.recommended,
  prettierConfig,
]
