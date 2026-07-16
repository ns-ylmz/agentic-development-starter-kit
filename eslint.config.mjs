// Base flat config: JS + TypeScript recommended rules, Prettier as an ESLint
// rule (so post-edit-verify.sh and lint-staged surface format drift), and a
// CJS escape hatch for tooling configs that require it.
//
// Per-workspace configs (apps/*, packages/*) extend this root config and add
// framework-specific plugins (React, NestJS, etc.) themselves. Keep this
// base framework-free.
import prettierConfig from 'eslint-config-prettier';
import prettierPlugin from 'eslint-plugin-prettier';
import globals from 'globals';
import tseslint from 'typescript-eslint';
import js from '@eslint/js';

export default [
  {
    ignores: [
      '**/build/**',
      '**/coverage/**',
      '**/dist/**',
      '**/.turbo/**',
      '**/*.tsbuildinfo',
      '**/node_modules/**',
    ],
  },

  js.configs.recommended,
  ...tseslint.configs.recommended,

  {
    files: ['**/*.{ts,tsx}'],
    languageOptions: {
      parser: tseslint.parser,
      parserOptions: {
        // Type-aware linting without hardcoding a tsconfig path; each
        // workspace's own tsconfig is discovered automatically.
        projectService: true,
      },
    },
    plugins: {
      prettier: prettierPlugin,
    },
    rules: {
      'prettier/prettier': 'error',
      '@typescript-eslint/no-unused-vars': 'warn',
      '@typescript-eslint/no-empty-object-type': [
        'error',
        { allowInterfaces: 'with-single-extends' },
      ],
    },
  },

  // Tooling configs that must stay CommonJS (e.g. a webpack.config.js).
  {
    files: ['**/*.config.js'],
    languageOptions: {
      sourceType: 'commonjs',
      globals: { ...globals.node },
    },
    rules: {
      '@typescript-eslint/no-require-imports': 'off',
    },
  },

  prettierConfig,
];
